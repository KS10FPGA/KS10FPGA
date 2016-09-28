//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Secure Digial Card Interface.
//!
//! \details
//!    This object uses the SSI interfact to communicate with an SD Card.
//!
//!    The SD Protocol is defined in the following document:
//!
//!    SD Specifications Part 1 Physical Layer Simplified Specification
//!    Version 3.01 May 18, 2010
//!
//! \file
//!    sd.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
//
// This file is part of the KS10 FPGA Project
//
// The KS10 FPGA project is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// The KS10 FPGA project is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this software.  If not, see <http://www.gnu.org/licenses/>.
//
//******************************************************************************
//
//! \addtogroup sdhc_api
//! @{
//

#include <stdint.h>
#include "sd.h"
#include "stdio.h"
#include "align.hpp"
#include "debug.hpp"
#include "fatal.hpp"
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
// Global Variables
//

static bool typeSDSC    = false;                //!< Card Type
static bool initialized = false;                //!< State
static bool debug       = false;                //!< Debug

static const uint32_t bitRate = 250000;         //!< bitrate

//
//! Port Definitions
//

#define GPIO_PORTCS_BASE  GPIO_PORTA_BASE       //!< Chip Select Base Address
#define GPIO_PIN_CS       GPIO_PIN_3            //!< Chip Select Pin
#define GPIO_PORTCD_BASE  GPIO_PORTB_BASE       //!< Card Detect Base Address
#define GPIO_PIN_CD       GPIO_PIN_6            //!< Card Detect Pin

//
//! SD Commands
//

enum cmd_t {
    CMD0   =  0,        //!< GO_IDLE_STATE command
    CMD8   =  8,        //!< SEND_IF_COND command
    CMD10  = 10,        //!< SEND_CID command
    CMD13  = 13,        //!< SEND_STATUS command
    CMD17  = 17,        //!< READ_SINGLE command
    CMD24  = 24,        //!< WRITE_SINGLE command
    ACMD41 = 41,        //!< APP_SEND_OP_COND command
    CMD55  = 55,        //!< APP_CMD command
    CMD58  = 58,        //!< READ_OCR command
};

//
//! SD R1 Responses
//

enum rspR1_t {
    rspR1_OK     = 0x00,        //!< OK
    rspR1_IDLE   = 0x01,        //!< Idle
    rspR1_ERST   = 0x02,        //!< Erase Reset
    rspR1_ILLCMD = 0x04,        //!< Illegal Command
    rspR1_CRC    = 0x08,        //!< CRC Error
    rspR1_ESEQ   = 0x10,        //!< Erase Sequence Error
    rspR1_ADDR   = 0x20,        //!< Address Error
    rspR1_PARM   = 0x40,        //!< Parameter Error
};

//!
//! SD R2 Responses
//!

enum rspR2_t {
    rspR2_OK     = 0x00,        //!< OK
    rspR2_WPESK  = 0x01,        //!< Write protect erase skip
    rspR2_ERR    = 0x02,        //!< Error
    rspR2_CCERR  = 0x04,        //!< Internal error
    rspR2_LOCK   = 0x08,        //!< Card is locked
    rspR2_ECC    = 0x10,        //!< Card ECC error
    rspR2_WP     = 0x20,        //!< Write protect
    rspR2_EPARM  = 0x40,        //!< Erase parameter error
    rspR2_OOR    = 0x80,        //!< Out of range
};

//!
//! \brief
//!    Controls the chip enable of the SD Card.
//!
//! \details
//!    The SD specification allows the clock and data pins to be shared among
//!    multiple SD Cards.   The chip enable operation is an integral part of the
//!    SD protocol.
//!
//!    The Chip Enable is active low.
//!
//!    <p><dfn> chipEnable(true) </dfn> asserts the Chip Enable signal (low).</p>
//!    <p><dfn> chipEnable(false) </dfn> negates the Chip Enable signal (high).</p>
//!
//! \param enable -
//!    sets the state of the Chip Enable (CE) pin.
//!
//!

static void chipEnable(bool enable) {
    ROM_GPIOPinWrite(GPIO_PORTCS_BASE, GPIO_PIN_CS, enable ? 0 : GPIO_PIN_CS);
}

//!
//! \brief
//!    Sends/Receives a byte of data to/from the SD Card.
//!
//! \details
//!    Transactions to the SD Card are always bi-directional.  Sometimes the
//!    data to be transmitted doesn't matter but the received data is relevant;
//!    sometimes that data to be transmitted does matter and the received is
//!    ignored.
//!
//! \param byte -
//!    data to be sent to the SD Card.
//!
//! \returns
//!    data read from the SD Card.
//!

static uint8_t transactData(uint8_t byte) {
    uint32_t ret;
    ROM_SSIDataPut(SSI0_BASE, byte);
    ROM_SSIDataGet(SSI0_BASE, &ret);
    return ret & 0xff;
}

//!
//! \brief
//!    Sends a command to the SD Card.
//!
//! \details
//!    This function sends a properly formed command to the SD card.  In some
//!    cases the CRC must be correct and in other cases the CRC is ignored and
//!    can be anything.  Once the command is sent, this function waits for an
//!    R1 Response (not all ones) from the SD Card.
//!
//!    The first bit of the command must be a zero (start bit).  The second
//!    bit of a command must be a one.  The last bit of the CRC must be a one
//!    (stop bit).  Technically the CRC is only 7 bits and the stop bit is the
//!    last bit sent - but that makes things confusing.
//!
//! \param cmd -
//!    command byte
//!
//! \param data -
//!    32-bit command payload
//!
//! \param crc -
//!    crc7 (and stop bit)
//!
//! \returns
//!    R1 status from command.
//!

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

#ifdef SD_WRITE

//!
//! \brief
//!    Wait for an R2 Response from the SD Card.
//!
//! \returns
//!    R2 Response from SD Card.
//!

static uint8_t getR2Response(void) {
    return transactData(0xff);
}

#endif

//!
//! \brief
//!    Wait for an R3 Response from the SD Card.
//!
//! \returns
//!    R3 Response from SD Card.
//!

static uint32_t getR3Response(void) {
    return ((transactData(0xff) << 24) |
            (transactData(0xff) << 16) |
            (transactData(0xff) <<  8) |
            (transactData(0xff) <<  0));
}

//!
//! \brief
//!    Wait for an R7 Response from the SD Card.
//!
//! \returns
//!    R7 Response from SD Card.
//!

static uint32_t getR7Response(void) {
    return ((transactData(0xff) << 24) |
            (transactData(0xff) << 16) |
            (transactData(0xff) <<  8) |
            (transactData(0xff) <<  0));
}

//!
//! \brief
//!    Waits for a <em>Read Start Token</em> response from the SD Card.
//!
//! \returns
//!    Read Start Token Response from SD Card.
//!

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

//!
//! \brief
//!    Send a <em>Write Start Token</em> command to the SD Card.
//!

void sendWriteStartToken(void) {
    transactData(0xff);
    transactData(0xfe);
}

//!
//! \brief
//!    Initializes the SD Card
//!
//! \returns
//!    True if the SD Card is initialized properly, false otherwise.
//!

bool sdInitialize(void) {

    initialized = false;

    debug_printf(debug, "SDHC: Initializing SD Card.\n");

    for (int loops = 0; ; loops++) {

        //
        // Send some ones so that the SD card can easily synchronize to the
        // start bit of CMD0 which will follow.
        //

        chipEnable(false);
        for (int i = 0; i < 10; i++) {
            transactData(0xff);
        }

        //
        // Issue a Software Reset command to the SD Card.
        //
        // Send GO_IDLE_STATE Command.
        //
        // The SD Card will enter SPI mode if the CS signal is asserted
        // (low) during the reception of the reset command (CMD0).
        //

        debug_printf(debug, "SDHC: Sending CMD0.\n");
        chipEnable(true);
        uint8_t rsp0 = sendCommand(CMD0, 0x00000000, 0x95);
        chipEnable(false);
        transactData(0xff);

        //
        // Check R1 Response to GO_IDLE_STATE Command.  The SD Card should be in
        // the IDLE state with no errors after this command is received.
        //

        debug_printf(debug, "SDHC: CMD0: R1 Response was 0x%02x.\n", rsp0);
        if (rsp0 == rspR1_IDLE) {
            break;
        } else if (loops == 10) {
            debug_printf(debug, "SDHC: Failed to Reset SD Card.\n");
            return false;
        }
    }

    //
    // Send SEND_IF_COND Command.
    //

    debug_printf(debug, "SDHC: Sending CMD8.\n");
    chipEnable(true);
    uint8_t rsp8 = sendCommand(CMD8, 0x000001aa, 0x87);

    //
    // Check R1 Response from SEND_IF_COND
    //
    //   V1.xx Cards do not accept a SEND_IF_COND command and should return an
    //   "Illegal Response" error.  V2.00 and V3.00 Cards will accept a
    //   SEND_IF_COND command will not return an "Illegal Response" error.
    //

    switch (rsp8) {

        //
        // V2.00 Initialization
        //

        case rspR1_IDLE:
            {
                debug_printf(debug, "SDHC: CMD8: Attempting V2.00 Initialization.\n");

                //
                // Check R7 Response to SEND_IF_COND Command.
                //
                // The "voltage accepted" and "check pattern" bit should
                // be set correctly
                //

                uint32_t R7Response = getR7Response();
                chipEnable(false);
                transactData(0xff);
                if ((R7Response & 0x0000ffff) != 0x000001aa) {
                    debug_printf(debug, "SDHC: CMD8: R7 Response was 0x%08lx.\n", R7Response);
                    return false;
                }

                //
                //
                //

                for (int loops = 0; ; loops++) {

                    //
                    // Send APP_CMD Command
                    //

                    debug_printf(debug, "SDHC: Sending CMD55.\n");
                    chipEnable(true);
                    uint8_t rsp55 = sendCommand(CMD55, 0x00000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);

                    //
                    // Check R1 Response to APP_CMD Command
                    //

                    if (rsp55 != rspR1_IDLE) {
                        debug_printf(debug, "SDHC: CMD55: R1 Response was 0x%02x.\n", rsp55);
                        return false;
                    }

                    //
                    // Send APP_SEND_OP_COND Command
                    //

                    debug_printf(debug, "SDHC: Sending ACMD41.\n");
                    chipEnable(true);
                    uint8_t rsp41 = sendCommand(ACMD41, 0x40000000, 0xff);
                    chipEnable(false);

                    //
                    // Check R1 Response to APP_SEND_OP_COND Command
                    //

                    transactData(0xff);
                    debug_printf(debug, "SDHC: ACMD41: R1 Response was 0x%02x.\n", rsp41);
                    if (rsp41 == rspR1_OK) {
                        break;
                    } else if (loops == 1000) {
                        return false;
                    }
                }

                //
                // Query the Operation Conditions Register (OCR)
                //
                // Send READ_OCR Command
                //

                debug_printf(debug, "SDHC: Sending CMD58.\n");
                chipEnable(true);
                uint8_t rsp58 = sendCommand(CMD58, 0x00000000, 0xff);

                //
                // Check R1 Response to READ_OCR
                //

                if (rsp58 != rspR1_OK) {
                    debug_printf(debug, "SDHC: CMD58: R1 Response was 0x%02x.\n", rsp58);
                    chipEnable(false);
                    return false;
                }

                //
                // Check R3 Response to READ_OCR
                //

                uint32_t R3Response = getR3Response();
                chipEnable(false);
                transactData(0xff);

                //
                // Mask off the 'don't care' bits of the OCR.  The relevant bits
                // are:
                //
                //   - Bit 31 : Not busy
                //   - Bit 30 : Card Capacity Status (CCS)
                //   - Bit 21 : 3.3V to 3.4V operation
                //   - Bit 20 : 3.2V to 3.3V operation
                //
                // Bit 31 should be asserted.
                //
                // If bit 30 is cleared, this indicates an SDSC card.
                //
                // The SD Card operates at 3.3V.  Therefore either Bit 20 or
                // Bit 21 (or both) should be set.
                //
                // See Table 5-1: OCR Register Definition
                //

                switch (R3Response & 0xc0300000) {
                    case 0xc0100000:
                    case 0xc0200000:
                    case 0xc0300000:
                        typeSDSC = false;
                        initialized = true;
                        printf("SDHC: SDHC Card Initialized Successfully.\n");
                        break;
                    case 0x80100000:
                    case 0x80200000:
                    case 0x80300000:
                        typeSDSC = true;
                        initialized = true;
                        printf("SDHC: SDSC Card Initialized Successfully.\n");
                        break;
                    default:
                        debug_printf(debug, "SDHC: CMD58: R3 Response was 0x%08lx.\n", R3Response);
                        break;
                }

                //
                // Send SEND_CID command
                //

                chipEnable(true);
                uint8_t rsp10 = sendCommand(CMD10, 0x00000000, 0xff);

                //
                // Check R1 response
                //

                if (rsp10 != rspR1_OK) {
                    debug_printf(debug, "SDHC: CMD10: R1 Response was 0x%02x.\n", rsp10);
                    chipEnable(false);
                    return false;
                }

                //
                // Read and print CID register
                //

                for (int i = 0; i < 100; i++) {
                    uint8_t sync = transactData(0xff);
                    if (sync == 0xfe) {
                        char buf[20];
                        for (int i = 0; i < 20; i++) {
                            buf[i] = transactData(0xff);
                        }
                        printf("SDHC: Manufacturer ID  : 0x%02x\n"
                               "SDHC: OEM ID           : %c%c\n"
                               "SDHC: Product Name     : %c%c%c%c%c\n"
                               "SDHC: Product Revision : %d.%d\n"
                               "SDHC: Product SN       : %02x%02x%02x%02x\n"
                               "SDHC: Manufacture Date : %d/%d\n",
                               buf[0],
                               buf[1], buf[2],
                               buf[3], buf[4], buf[5], buf[6], buf[7],
                               buf[8] >> 4, buf[8] & 0x0f,
                               buf[9], buf[10], buf[11], buf[12],
                               buf[14] & 0x0f, (2000 + (buf[13] << 4) + (buf[14] >> 4)));
                        break;
                    }
                }
                chipEnable(false);

            }
            break;

        //
        // V1.00 Initialization
        //

        case rspR1_ILLCMD | rspR1_IDLE:
            {
                debug_printf(debug, "SDHC: CMD8: Attempting V1.00 Initialization.\n");
                chipEnable(false);

                //
                // Send READ_OCR Command
                //

                debug_printf(debug, "SDHC: Sending CMD58.\n");
                chipEnable(true);
                uint8_t rsp58 = sendCommand(CMD58, 0x00000000, 0xff);

                //
                // Check R1 Response to READ_OCR command
                //

                if (rsp58 != rspR1_OK) {
                    chipEnable(false);
                    debug_printf(debug, "SDHC: CMD58: R1 Response was 0x%02x.\n", rsp58);
                    return false;
                }

                //
                // Check R3 Response to READ_OCR command
                //

                uint32_t R3Response = getR3Response();
                chipEnable(false);
                transactData(0xff);
                if (R3Response != 0xe0ff8000) {
                    debug_printf(debug, "SDHC: CMD8: R3 Response was 0x%08lx.\n", R3Response);
                    return false;
                }

                //
                // Send APP_SEND_OP_COND Command
                //

                for (int loops = 0; ; loops++) {
                    debug_printf(debug, "SDHC: Sending ACMD41.\n");
                    chipEnable(true);
                    uint8_t rsp41 = sendCommand(ACMD41, 0x40000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);

                    //
                    // Check R1 Response to APP_SEND_OP_COND
                    //

                    debug_printf(debug, "SDHC: CMD41: R1 Response was 0x%02x.\n", rsp41);
                    if (rsp41 == rspR1_OK) {
                        break;
                    } else if (loops == 10) {
                        return false;
                    }
                }

                printf("SDHC: Successful V1.00 Initialization.\n");
                initialized = true;
            }
            break;

        //
        // Everything else.
        //

        default:
            debug_printf(debug, "SDHC: CMD8: R1 Response was 0x%02x.\n", rsp8);
            break;

    }
    return initialized;
}

//!
//! \brief
//!    Reads a 512-byte sector from the SD Card
//!
//! \param [in, out] buf -
//!    pointer to data buffer.  The buffer space must be at least 512 bytes.
//!    The buf pointer is modified by this function.
//!
//! \param [in] sector -
//!    Linear sector address of SD Card
//!
//! \pre
//!    The SD Card must be initialized and mounted for reads to succeed.
//!
//! \note
//!    Sectors are always 512 bytes long
//!
//! \returns
//!    True if the read was successful, false otherwise.
//!

bool sdReadSector(uint8_t *buf, uint32_t sector) {

    if (!initialized) {
        debug_printf(debug, "SDHC: CMD17: Card is not initialized.\n");
        return false;
    }

    //
    // Fix SDSC Addressing
    //

    if (typeSDSC) {
        sector = sector << 9;
    }

    //
    // Send READ_SINGLE Command
    //

    debug_printf(debug, "SDHC: Sending CMD17.\n");
    chipEnable(true);
    uint8_t rsp17 = sendCommand(CMD17, sector, 0xff);

    //
    // Check R1 Response
    //

    if (rsp17 != rspR1_OK) {
        debug_printf(debug, "SDHC: CMD17: R1 Response was 0x%02x.\n", rsp17);
        chipEnable(false);
        return false;
    }

    //
    // Find the Start Read Token
    //

    uint8_t readToken = findReadStartToken();
    if (readToken != 0xfe) {
        debug_printf(debug, "SDHC: CMD17: Read Token was 0x%02x.\n", readToken);
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

#ifdef SD_WRITE

//!
//! \brief
//!    Writes a 512-byte sector to the SD Card
//!
//! \param [in,out] buf -
//!    pointer to data buffer.  The buffer space must be at least 512 bytes.
//!    The buf pointer is modified by this function.
//!
//! \param [in] sector -
//!    Linear sector address of SD Card
//!
//! \pre
//!    The SD Card must be initialized, mounted, and not read-only for writes
//!    to succeed.
//!
//! \note
//!    Sectors are always 512 bytes long
//!
//! \returns
//!    True if the write was successful, false otherwise.
//!

bool sdWriteSector(const uint8_t *buf, uint32_t sector) {

    if (!initialized) {
        debug_printf(debug, "SDHC: CMD24: Card is not initialized.\n");
        return false;
    }

    //
    // Fix SDSC Addressing
    //

    if (typeSDSC) {
        sector = sector << 9;
    }

    //
    // Send WRITE_SINGLE Command
    //

    debug_printf(debug, "SDHC: Sending CMD24.\n");
    chipEnable(true);
    uint8_t rsp24 = sendCommand(CMD24, sector, 0xff);

    //
    // Check R1 Response
    //

    if (rsp24 != rspR1_OK) {
        debug_printf(debug, "SDHC: CMD24: R1 Response was 0x%02x.\n", rsp24);
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
        debug_printf(debug, "SDHC: CMD24: Data Response was 0x%02x.\n", dataResponse);
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
            debug_printf(debug, "SDHC: CMD24: No read token.\n");
            return false;
        }
        i = i + 1;
    } while (token == 0);

    //
    // Send SEND_STATUS Command
    //

    debug_printf(debug, "SDHC: Sending CMD13.\n");
    uint8_t rsp13 = sendCommand(CMD13, 0x00000000, 0xff);

    //
    // Check R1 Response
    //

    if (rsp13 != rspR1_OK) {
        debug_printf(debug, "SDHC: CMD13: R1 Response was 0x%02x.\n", rsp13);
        return false;
    }

    //
    // Check R2 Response
    //

    uint8_t R2Response = getR2Response();
    if (R2Response != rspR2_OK) {
        debug_printf(debug, "SDHC: CMD13: R2 Response was 0x%02x.\n", R2Response);
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

#endif

//!
//! \brief
//!    Check SD Card Status
//!
//! \returns
//!    True if the SD Card has been initialized successfully, false otherwise.
//!

bool sdStatus(void) {
    return initialized;
}

//!
//! \brief
//!    Detect changes in SD Card state
//!
//! \details
//!    Detect SD Card insertions and removals.  When an insertion is detected,
//!    initialize the SD Card and mount the FAT32 Filesystem.
//!
//! \param arg -
//!    Pointer to debug parameter list.
//!

static void sdTask(void *arg) {

    debug = static_cast<debug_t *>(arg)->debugSDHC;

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

//!
//! \brief
//!    Start the SD Task
//!
//! \param debug -
//!    thread parameter.
//!

void startSdTask(debug_t *debug) {
    static signed char __align64 stack[5120-4];
    portBASE_TYPE status = xTaskCreate(sdTask, reinterpret_cast<const signed char *>("SD"),
                                       stack, sizeof(stack), debug, taskSDPriority, NULL);
    if (status != pdPASS) {
        printf("SDHC: Failed to create SD task.  Status was %s.\n", taskError(status));
        fatal();
    }
}

//
//! @}
//
