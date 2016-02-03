//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Secure Digial Card Interface.
//!
//! This object provides the interfaces that are required to interact with
//! an SD Card.
//!
//! \file
//!    sd.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2015 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#include <stdint.h>
#include "sd.h"
#include "stdio.h"
#include "fatal.hpp"
#include "align.hpp"
#include "taskutil.hpp"
#include "fatfslib/ff.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/rom.h"
#include "driverlib/ssi.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_ints.h"
#include "driverlib/inc/hw_memmap.h"
#include "SafeRTOS/SafeRTOS_API.h"

//
// Port Definitions
//

#define GPIO_PORTCS_BASE  GPIO_PORTA_BASE       //!< Chip Select Base Address
#define GPIO_PIN_CS       GPIO_PIN_3            //!< Chip Select Pin
#define GPIO_PORTCD_BASE  GPIO_PORTB_BASE       //!< Card Detect Base Address
#define GPIO_PIN_CD       GPIO_PIN_6            //!< Card Detect Pin

//
// Debug macros
//

//#define VERBOSE_SD

#ifdef VERBOSE_SD
#define debug(...) printf(__VA_ARGS__)
#else
#define debug(...)
#endif

static const uint32_t bitRate = 250000;
static bool initialized = false;

enum cmd_t {
    CMD0   =  0,        //!< GO_IDLE_STATE Command
    CMD8   =  8,        //!< SEND_IF_COND Command
    CMD13  = 13,        //!< SEND_STATUS Command
    CMD17  = 17,        //!< READ_SINGLE Command
    CMD24  = 24,        //!< WRITE_SINGLE Command
    ACMD41 = 41,        //!< APP_SEND_OP_COND Command
    CMD55  = 55,        //!< APP_CMD Command
    CMD58  = 58,        //!< READ_OCR Command
};

//
//! Controls the chip enable of the SD Card.
//!
//! The SD specification allows the clock and data pins to be shared among
//! multiple SD Cards.   The chip enable operation is an integral part of the
//! SD protocol.
//!
//! The Chip Enable is active low.
//!
//! <p><dfn> chipEnable(true) </dfn> asserts the Chip Enable signal (low).</p>
//! <p><dfn> chipEnable(false) </dfn> negates the Chip Enable signal (high).</p>
//!
//! \param enable
//!     sets the state of the Chip Enable (CE) pin.
//!
//

static void chipEnable(bool enable) {
    ROM_GPIOPinWrite(GPIO_PORTCS_BASE, GPIO_PIN_CS, enable ? 0 : GPIO_PIN_CS);
}

//
//! Sends/Receives a byte of data to/from the SD Card.
//!
//! Transactions to the SD Card are always bi-directional.  Sometimes the data
//! to be transmitted doesn't matter but the received data is relevant;
//! sometimes that data to be transmitted does matter and the received is
//! ignored.
//!
//! \param byte
//!     data to be sent to the SD Card.
//!
//! \returns
//!     data read from the SD Card.
//

static uint8_t transactData(uint8_t byte) {
    uint32_t ret;
    ROM_SSIDataPut(SSI0_BASE, byte);
    ROM_SSIDataGet(SSI0_BASE, &ret);
    return ret & 0xff;
}

//
//! Sends a command to the SD Card.
//!
//! This function sends a properly formed command to the SD card.  In some
//! cases the CRC must be correct and in other cases the CRC is ignored and
//! can be anything.  Once the command is sent, this function waits for an
//! R1 Response (not all ones) from the SD Card.
//!
//! The first bit of the command must be a zero (start bit).  The second
//! bit of a command must be a one.  The last bit of the CRC must be a one
//! (stop bit).  Technically the CRC is only 7 bits and the stop bit is the
//! last bit sent - but that makes things confusing.
//!
//! \param cmd
//!     command byte
//!
//! \param data
//!     32-bit command payload
//!
//! \param crc
//!     crc7 (and stop bit)
//!
//! \returns
//!     R1 status from command.
//

static uint8_t sendCommand(uint8_t cmd, uint32_t data, uint8_t crc) {

    static const int nCR = 8;
    static const uint8_t startBit = 0x80;
    static const uint8_t hostBit  = 0x40;

    transactData((cmd & ~startBit) | hostBit);
    transactData(data >> 24);
    transactData(data >> 16);
    transactData(data >>  8);
    transactData(data >>  0);
    transactData(crc);

    //
    // Read R1 Response
    //

    uint8_t response;
    for (int i = 0; i < nCR; i++) {
        response = transactData(0xff);
        if (response != 0xff) {
            break;
        }
    }

    return response;
}

//
//! Wait for an R2 Response from the SD Card.
//!
//! \returns
//!     R2 Response from SD Card.
//

static uint8_t getR2Response(void) {
    return transactData(0xff);
}

//
//! Wait for an R3 Response from the SD Card.
//!
//! \returns
//!     R3 Response from SD Card.
//

static uint32_t getR3Response(void) {
    return ((transactData(0xff) << 24) |
            (transactData(0xff) << 16) |
            (transactData(0xff) <<  8) |
            (transactData(0xff) <<  0));
}

//
//! Wait for an R7 Response from the SD Card.
//!
//! \returns
//!     R7 Response from SD Card.
//

static uint32_t getR7Response(void) {
    return ((transactData(0xff) << 24) |
            (transactData(0xff) << 16) |
            (transactData(0xff) <<  8) |
            (transactData(0xff) <<  0));
}

//
//! Waits for a <em>Read Start Token</em> response from the SD Card.
//!
//! \returns
//!     Read Start Token Response from SD Card.
//

static uint8_t findReadStartToken(void) {
    static const int nAC = 1023;
    uint8_t response;
    for (int i = 0; i < nAC; i++) {
        response = transactData(0xff);
        if (response != 0xff) {
            break;
        }
    }
    return response;
}

//
//! Send a <em>Write Start Token</em> command to the SD Card.
//

void sendWriteStartToken(void) {
    transactData(0xff);
    transactData(0xfe);
}

//
//! Initializes the SD Card
//!
//! \returns
//!     True if the SD Card is initialized properly, false otherwise.
//

bool sdInitialize(void) {

    debug("Initializing SD Card.\n");

    initialized = false;

    chipEnable(false);
    for (int i = 0; i < 10; i++) {
        transactData(0xff);
    }

    //
    // Send GO_IDLE_STATE Command
    // Check R1 Response
    //
    // The SD Card will enter SPI mode if the CS signal is asserted (negative)
    // during the reception of the reset command (CMD0).
    //

    debug("Sending CMD0.\n");
    chipEnable(true);
    uint8_t rsp0 = sendCommand(CMD0, 0x00000000, 0x95);
    chipEnable(false);
    transactData(0xff);
    if (rsp0 != 0x01) {
        debug("CMD0: Response was 0x%02x.\n", rsp0);
        return false;
    }

    //
    // Send SEND_IF_COND Command
    // Check R1 Response
    //

    debug("Sending CMD8.\n");
    chipEnable(true);
    uint8_t rsp8 = sendCommand(CMD8, 0x000001aa, 0x87);

    switch (rsp8) {

        //
        // V2.00 Initialization
        //

        case 0x01:
            {
                debug("CMD8: Attempting V2.00 Initialization.\n");

                //
                // Check R7 Response
                //

                uint32_t R7Response = getR7Response();
                chipEnable(false);
                transactData(0xff);
                if ((R7Response & 0x0000ffff) != 0x000001aa) {
                    debug("CMD8: R7 Response was 0x%08lx.\n", R7Response);
                    return false;
                }

                int loop = 10;
                uint8_t rsp41;
                do {

                    //
                    // Send APP_CMD Command
                    // Check R1 Response
                    //

                    debug("Sending CMD55.\n");
                    chipEnable(true);
                    uint8_t rsp55 = sendCommand(CMD55, 0x00000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);
                    if (rsp55 != 0x01) {
                        debug("CMD55: R1 Response was 0x%02x.\n", rsp55);
                        return false;
                    }

                    //
                    // Send APP_SEND_OP_COND Command
                    // Check R1 Response
                    //

                    debug("Sending ACMD41.\n");
                    chipEnable(true);
                    rsp41 = sendCommand(ACMD41, 0x40000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);
                    debug("ACMD41: R1 Response was 0x%02x.\n", rsp41);
                    if (--loop == 0) {
                        chipEnable(false);
                        return false;
                    }
                } while (rsp41 != 0x00);

                //
                // Send READ_OCR Command
                // Check R1 Response
                //

                debug("Sending CMD58.\n");
                chipEnable(true);
                uint8_t rsp58 = sendCommand(CMD58, 0x00000000, 0xff);
                if (rsp58 != 0x00) {
                    debug("CMD58: R1 Response was 0x%02x.\n", rsp58);
                    chipEnable(false);
                    return false;
                }

                //
                // Check R3 Response to READ_OCR
                //

                uint32_t R3Response = getR3Response();
                chipEnable(false);
                transactData(0xff);
                if (R3Response != 0xc0ff8000) {
                    debug("CMD58: R3 Response was 0x%08lx.\n", R3Response);
                    return false;
                }

                debug("CMD8: Successful V2.00 Initialization.\n");

            }

            //
            // Success
            //

            initialized = true;
            break;

        //
        // V1.00 Initialization
        // Note: This has bit 2 set indicating "Illegal Command".
        //

        case 0x05:
            {
                debug("CMD8: Attempting V1.00 Initialization.\n");
                chipEnable(false);

                //
                // Send READ_OCR Command
                // Check R1 Response
                //

                debug("Sending CMD58.\n");
                chipEnable(true);
                uint8_t rsp58 = sendCommand(CMD58, 0x00000000, 0xff);
                if (rsp58 != 0x00) {
                    chipEnable(false);
                    debug("CMD58: R1 Response was 0x%02x.\n", rsp58);
                    return false;
                }

                //
                // Check R3 Response to READ_OCR
                //

                uint32_t R3Response = getR3Response();
                chipEnable(false);
                transactData(0xff);
                if (R3Response != 0xe0ff8000) {
                    debug("CMD8: R3 Response was 0x%08lx.\n", R3Response);
                    return false;
                }

                //
                // Send APP_SEND_OP_COND Command
                // Check R1 Response
                //

                for (int i = 0; i < 10; i++) {

                    debug("Sending ACMD41.\n");
                    chipEnable(true);
                    uint8_t rsp41 = sendCommand(ACMD41, 0x40000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);
                    if (rsp41 == 0x00) {
                        debug("CMD8: Successful V1.00 Initialization.\n");
                        initialized = true;
                        return true;
                    }

                }

                debug("CMD8: V1.00 Initialization Failure.\n");

            }

            //
            // Failure
            //

            return false;

        //
        // Everything else.
        //

        default:
            debug("CMD8: R1 Response was 0x%02x.\n", rsp8);
            return false;

    }
    return initialized;
}

//
//! Reads a 512-byte sector from the SD Card
//!
//! \param [in, out] buf
//!     pointer to data buffer.  The buffer space must be at least 512 bytes.
//!     The buf pointer is modified by this function.
//!
//! \param [in] sector
//!     Linear sector address of SD Card
//!
//! \pre
//!     The SD Card must be initialized and mounted for reads to succeed.
//!
//! \note
//!     Sectors are always 512 bytes long
//!
//! \returns
//!     True if the read was successful, false otherwise.
//!

bool sdReadSector(uint8_t *buf, uint32_t sector) {

    if (!initialized) {
        debug("CMD17: Card is not initialized.\n");
        return false;
    }

    //
    // Send READ_SINGLE Command
    // Check R1 Response
    //

    debug("Sending CMD17.\n");
    chipEnable(true);
    uint8_t rsp17 = sendCommand(CMD17, sector, 0xff);
    if (rsp17 != 0x00) {
        debug("CMD17: R1 Response was 0x%02x.\n", rsp17);
        chipEnable(false);
        return false;
    }

    //
    // Find the Start Read Token
    //

    uint8_t readToken = findReadStartToken();
    if (readToken != 0xfe) {
        debug("CMD17: Read Token was 0x%02x.\n", readToken);
        chipEnable(false);
        return false;
    }

    //
    // Start Reading Data
    //

    for (int i = 0; i < 512; i++) {
        *buf++ = transactData(0xff);
    }

    //
    // Read and discard 16-bit CRC
    //

    transactData(0xff);
    transactData(0xff);

    //
    // Deselect SD Chip
    //

    chipEnable(false);

    //
    // Idle
    //

    transactData(0xff);

    //
    // Success
    //

    return true;
}

//
//! Writes a 512-byte sector to the SD Card
//!
//! \param [in,out] buf
//!     pointer to data buffer.  The buffer space must be at least 512 bytes.
//!     The buf pointer is modified by this function.
//!
//! \param [in] sector
//!     Linear sector address of SD Card
//!
//! \pre
//!     The SD Card must be initialized, mounted, and not read-only for writes
//!     to succeed.
//!
//! \note
//!     Sectors are always 512 bytes long
//!
//! \returns
//!     True if the write was successful, false otherwise.
//!

bool sdWriteSector(const uint8_t *buf, uint32_t sector) {

    uint8_t R1Response;

    //
    // Send WRITE_SINGLE Command
    // Check R1 Response
    //

    debug("Sending CMD24.\n");
    chipEnable(true);
    R1Response = sendCommand(CMD24, sector, 0xff);
    if (R1Response != 0x00) {
        debug("CMD24: R1 Response was 0x%02x.\n", R1Response);
        return false;
    }

    //
    // Send Write Start Token
    //

    sendWriteStartToken();

    //
    // Start Writing Data
    //

    for (int i = 0; i < 512; i++) {
        transactData(*buf++);
    }

    //
    // Send dummy CRC
    //

    transactData(0xff);
    transactData(0xff);

    //
    // Read the Data Response
    //

    uint8_t dataResponse = transactData(0xff);
    if ((dataResponse & 0x1f) != 0x05) {
        debug("CMD24: Data Response was 0x%02x.\n", dataResponse);
        return false;
    }

    //
    // Wait for busy token to clear.
    //

    int i = 0;
    uint8_t token;
    do {
        token = transactData(0xff);
        if (i == 65536) {
            debug("CMD24: No read token.\n");
            return false;
        }
        i = i + 1;
    } while (token == 0);

    //
    // Send SEND_STATUS Command
    //

    debug("Sending CMD13.\n");
    R1Response = sendCommand(CMD13, 0x00000000, 0xff);
    if (R1Response != 0x00) {
        debug("CMD13: R1 Response was 0x%02x.\n", R1Response);
        return false;
    }
    uint8_t R2Response = getR2Response();
    if (R2Response != 0x00) {
        debug("CMD13: R2 Response was 0x%02x.\n", R2Response);
        return false;
    }

    //
    // Send 8 clock cycles
    //

    transactData(0xff);

    //
    // Deselect SD Card
    //

    chipEnable(false);

    //
    // Success
    //

    return true;

}

//
//! Check SD Card Status
//!
//! \returns
//!     True if the SD Card has been initialized successfully, false otherwise.
//

bool sdStatus(void) {
    return initialized;
}

//
//! Detect changes in SD Card state
//!
//! Detect SD Card insertions and removals.  When an insertion is detected,
//! initialize the SD Card and mount the FAT32 Filesystem.
//

static void sdTask(void * /* param */) {

    //
    // Check card status every second
    //

    const unsigned long delay = 1000;

    //
    // Configure the hardware
    //

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_SSI0);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTCS_BASE, GPIO_PIN_CS);
    ROM_GPIOPinTypeGPIOInput(GPIO_PORTCD_BASE, GPIO_PIN_CD);
    ROM_GPIOPinTypeSSI(GPIO_PORTA_BASE, GPIO_PIN_2 | GPIO_PIN_4 | GPIO_PIN_5);
    ROM_SSIConfigSetExpClk(SSI0_BASE, ROM_SysCtlClockGet(), SSI_FRF_MOTO_MODE_0, SSI_MODE_MASTER, bitRate, 8);
    ROM_SSIEnable(SSI0_BASE);
    chipEnable(false);

    //
    // Check card status periodically
    //

    FATFS fatFS;
    bool lastCardDetect = false;
    portTickType lastTick = xTaskGetTickCount();

    for (;;) {
        bool cardDetect = !ROM_GPIOPinRead(GPIO_PORTCD_BASE, GPIO_PIN_CD);
        if (cardDetect && !lastCardDetect) {
            printf("SDHC: Card inserted.\n");
            if (sdInitialize()) {
                printf("SDHC: Card initialized successfully.\n");
                FRESULT status = f_mount(0, &fatFS);
                if (status == FR_OK) {
                    printf("SDHC: FAT filesystem successfully mounted on SD media.\n");
                } else {
                    printf("SDHC: Failed to mount FAT filesystem on SD media.  Status was %d.\n", status);
                }
            } else {
                printf("SDHC: Failed to initialize SD Card.\n");
            }
        } else if (!cardDetect && lastCardDetect) {
            printf("SDHC: Card ejected.\n");
            initialized = false;
        }
        lastCardDetect = cardDetect;
        xTaskDelayUntil(&lastTick, delay);
    }
}

//
//! Start the SD Task
//

void startSdTask(void) {
    static signed char __align64 stack[5120-4];
    portBASE_TYPE status = xTaskCreate(sdTask, reinterpret_cast<const signed char *>("SD"),
                                       stack, sizeof(stack), 0, taskSDPriority, NULL);
    if (status != pdPASS) {
        fatal("SDHC: Failed to create SD task.  Status was %s.\n", taskError(status));
    }
}
