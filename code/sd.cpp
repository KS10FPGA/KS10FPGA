
#include <stdint.h>
#include "sd.h"
#include "stdio.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/rom.h"
#include "driverlib/ssi.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_memmap.h"

#undef  SSI_BASE
#define SSI_BASE          SSI0_BASE		//!< SSI Port Base Address
#define GPIO_PORTCS_BASE  GPIO_PORTA_BASE	//!< Chip Select Base Address
#define GPIO_PORTCD_BASE  GPIO_PORTB_BASE	//!< Card Detect Base Address
#define GPIO_PIN_CS       GPIO_PIN_3		//!< Chip Select Pin 
#define GPIO_PIN_CD       GPIO_PIN_3		//!< Card Detect Pin

static const uint32_t bitRate = 250000;
static bool initialized = false;

enum cmd_t {
    CMD0   =  0,	// GO_IDLE_STATE
    CMD8   =  8,	// SEND_IF_COND
    CMD13  = 13,	// SEND_STATUS
    CMD17  = 17,	// READ_SINGLE
    CMD24  = 24,	// WRITE_SINGLE
    ACMD41 = 41,	// APP_SEND_OP_COND
    CMD55  = 55,	// APP_CMD
    CMD58  = 58,	// READ_OCR
};

void SDInitialize(void) __attribute__((constructor(301)));

//!
//! \brief
//!     Controls the chip enable of the SD Card.
//!
//! \param enable
//!     Sets the state of the Chip Enable (CE) pin.   When the argument is
//!     true, the Chip Enable signal is asserted low.
//!
//! \details
//!     The SD specification allows the clock and data pins to be shared among
//!      multiple SD Cards.   The chip enable operation is an integral part of
//!      the SD protocol.
//!
//! \note
//!     The Chip Enable is active low.
//!

static void chipEnable(bool enable) {
    GPIOPinWrite(GPIO_PORTCS_BASE, GPIO_PIN_CS, enable ? 0 : GPIO_PIN_CS);
}

//!
//! \brief
//!     Sends/Receives a byte of data to/from the SD Card.
//!
//! \param byte
//!     data to be sent to the SD Card.
//!
//! \details
//!     Transactions to the SD Card are always bi-directional.  Sometimes the
//!     data to be transmitted doesn't matter but the received data is
//!     relevant; sometimes that data to be transmitted does matter and the
//!     received data is not relevant.
//!
//! \returns
//!     data read from the SD Card.
//!

static uint8_t transactData(uint8_t byte) {
    uint32_t ret;
    SSIDataPut(SSI_BASE, byte);
    SSIDataGet(SSI_BASE, &ret);
    return ret & 0xff;
}

//!
//! \brief
//!     Sends a command to the SD Card.
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
//! \details
//!     This function sends a properly formed command to the SD card.  In some
//!     cases the CRC must be correct and in other cases the CRC is ignored and
//!     can be anything.  Once the command is sent, this function waits for an
//!     R1 Response (not all ones) from the SD Card.
//!
//!     The first bit of the command must be a zero (start bit).  The second
//!     bit of a command must be a one.  The last bit of the CRC must be a one
//!     (stop bit).  Technically the CRC is only 7 bits and the stop bit is the
//!     last bit sent - but that makes things confusing.
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

//!
//! \brief
//!     Waits for an R2 Response from the SD Card.
//!
//! \returns
//!     R2 Response from SD Card.
//!

static uint8_t getR2Response(void) {
    return transactData(0xff);
}

//!
//! \brief
//!     Waits for an R3 Response from the SD Card.
//!
//! \returns
//!     R3 Response from SD Card.
//!

static uint32_t getR3Response(void) {
    return ((transactData(0xff) << 24) |
            (transactData(0xff) << 16) |
            (transactData(0xff) <<  8) |
            (transactData(0xff) <<  0));
}

//!
//! \brief
//!     Waits for an R7 Response from the SD Card.
//!
//! \returns
//!     R7 Response from SD Card.
//!

static uint32_t getR7Response(void) {
    return ((transactData(0xff) << 24) |
            (transactData(0xff) << 16) |
            (transactData(0xff) <<  8) |
            (transactData(0xff) <<  0));
}

//!
//! \brief
//!     Waits for an Read Start Token Response from the SD Card.
//!
//! \returns
//!     Read Start Token Response from SD Card.
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
//!     Sends a Write Start Token Response to the SD Card.
//!
//! \returns
//!     Nothing
//!

void sendWriteStartToken(void) {
    transactData(0xff);
    transactData(0xfe);
}

//!
//! \brief
//!     Initializes the SD Card
//!
//! \returns
//!     True if the SD Card is initialized properly, false
//!     otherwise.
//

bool SDInitializeCard(void) {
    
    printf("Initializing SD Card.\n");

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

 cmd0:
    printf("Sending CMD0.\n");
    chipEnable(true);
    uint8_t rsp0 = sendCommand(CMD0, 0x00000000, 0x95);
    chipEnable(false);
    transactData(0xff);
    if (rsp0 != 0x01) {
        printf("CMD0: Response was 0x%02x.\n", rsp0);
        goto cmd0;
        return false;
    }
            
    //
    // Send SEND_IF_COND Command
    // Check R1 Response
    // 

    printf("Sending CMD8.\n");
    chipEnable(true);
    uint8_t rsp8 = sendCommand(CMD8, 0x000001aa, 0x87);

    switch (rsp8) {
        
        //
        // V2.00 Initialization
        //

        case 0x01:
            {
                printf("CMD8: Attempting V2.00 Initialization.\n");

                //
                // Check R7 Response
                //

                uint32_t R7Response = getR7Response();
                chipEnable(false);
                transactData(0xff);
                if ((R7Response & 0x0000ffff) != 0x000001aa) {
                    printf("CMD8: R7 Response was 0x%08lx.\n", R7Response);
                    return false;
                }

                //
                // Send APP_CMD Command
                // Check R1 Response
                //

		int loop = 10;
		uint8_t rsp41;
		do {

		    printf("Sending CMD55.\n");
                    chipEnable(true);
		    uint8_t rsp55 = sendCommand(CMD55, 0x00000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);
		    if (rsp55 != 0x01) {
                        printf("CMD55: R1 Response was 0x%02x.\n", rsp55);
			return false;
		    }
		    printf("CMD55: R1 Response was 0x%02x.\n", rsp55);

		    //
		    // Send APP_SEND_OP_COND Command
		    // Check R1 Response
		    //

		    printf("Sending ACMD41.\n");
                    chipEnable(true);
		    rsp41 = sendCommand(ACMD41, 0x40000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);
		    printf("ACMD41: R1 Response was 0x%02x.\n", rsp41);
		    if (--loop == 0) {
                        chipEnable(false);
		        return false;
		    }
		} while (rsp41 != 0x00);
            
                //
                // Send READ_OCR Command
                // Check R1 Response
                //
                
                printf("Sending CMD58.\n");
                chipEnable(true);
                uint8_t rsp58 = sendCommand(CMD58, 0x00000000, 0xff);
                if (rsp58 != 0x00) {
                    printf("CMD58: R1 Response was 0x%02x.\n", rsp58);
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
                    printf("CMD58: R3 Response was 0x%08lx.\n", R3Response);
                    return false;
                }

                printf("CMD8: Successful V2.00 Initialization.\n");
                
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
                printf("CMD8: Attempting V1.00 Initialization.\n");
                chipEnable(false);
            
                //
                // Send READ_OCR Command
                // Check R1 Response
                //

                printf("Sending CMD58.\n");
                chipEnable(true);
                uint8_t rsp58 = sendCommand(CMD58, 0x00000000, 0xff);
                if (rsp58 != 0x00) {
                    chipEnable(false);
                    printf("CMD58: R1 Response was 0x%02x.\n", rsp58);
                    return false;
                }

                //
                // Check R3 Response to READ_OCR
                //
                
                uint32_t R3Response = getR3Response();
                chipEnable(false);
                transactData(0xff);
                if (R3Response != 0xe0ff8000) {
                    printf("CMD8: R3 Response was 0x%08lx.\n", R3Response);
                    return false;
                }

                //
                // Send APP_SEND_OP_COND Command
                // Check R1 Response
                //
                
                for (int i = 0; i < 10; i++) {
                    
                    printf("Sending ACMD41.\n");
                    chipEnable(true);
                    uint8_t rsp41 = sendCommand(ACMD41, 0x40000000, 0xff);
                    chipEnable(false);
                    transactData(0xff);
                    if (rsp41 == 0x00) {
                        printf("CMD8: Successful V1.00 Initialization.\n");
                        initialized = true;
                        return true;
                    }
                    
                }

                printf("CMD8: V1.00 Initialization Failure.\n");
                
            }
            
            //
            // Failure
            //
                
            return false;

        //
        // Everything else.
        //

        default:
            printf("CMD8: R1 Response was 0x%02x.\n", rsp8);
            return false;

    }
    return initialized;
}

//!
//! \brief
//!     Reads a 512-byte sector from the SD Card
//!
//! \param [in out] buf
//!     Pointer to data buffer.  The buffer space must be at least 512 bytes.
//!     The buf pointer is modified by this function.
//!
//! \param [in] sector
//!     Linear sector address of SD Card
//!
//! \pre
//!     The SD Card must be initialized for reads to succeed.
//!
//! \note
//!     Sectors are always 512 bytes long
//!
//! \returns
//!     True if the read was successful, false otherwise.
//!

bool SDReadSector(uint8_t *buf, uint32_t sector) {

    if (!initialized) {
        printf("CMD17: Card is not initialized.\n");
        return false;
    }

    //
    // Send READ_SINGLE Command
    // Check R1 Response
    //

    printf("Sending CMD17.\n");
    chipEnable(true);
    uint8_t rsp17 = sendCommand(CMD17, sector, 0xff);
    if (rsp17 != 0x00) {
        printf("CMD17: R1 Response was 0x%02x.\n", rsp17);
	chipEnable(false);
        return false;
    }

    //
    // Find the Start Read Token
    //

    uint8_t readToken = findReadStartToken();
    if (readToken != 0xfe) {
        printf("CMD17: Read Token was 0x%02x.\n", readToken);
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

//!
//! \brief
//!     Writes a 512-byte sector to the SD Card
//!
//! \param [in out] buf
//!     Pointer to data buffer.  The buffer space must be at least 512 bytes.
//!     The buf pointer is modified by this function.
//!
//! \param [in] sector
//!     Linear sector address of SD Card
//!
//! \pre
//!     The SD Card must be initialized for writes to succeed.
//!
//! \note
//!     Sectors are always 512 bytes long
//!
//! \returns
//!     True if the write was successful, false otherwise.
//!

bool SDWriteSector(const uint8_t *buf, uint32_t sector) {

    uint8_t R1Response;

    //
    // Send WRITE_SINGLE Command
    // Check R1 Response
    //

    printf("Sending CMD24.\n");
    chipEnable(true);
    R1Response = sendCommand(CMD24, sector, 0xff);
    if (R1Response != 0x00) {
        printf("CMD24: R1 Response was 0x%02x.\n", R1Response);
        return false;
    }

    //
    // Send Write Start Token
    //
    
    sendWriteStartToken();
    
    //
    // Start Writing Data
    //

    for (int i = 0; i < 256; i++) {
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
        printf("CMD24: Data Response was 0x%02x.\n", dataResponse);
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
            printf("CMD24: No read token.\n");
            return false;
        }
        i = i + 1;
    } while (token == 0);

    //
    // Send SEND_STATUS Command
    //

    printf("Sending CMD13.\n");
    R1Response = sendCommand(CMD13, 0x00000000, 0xff);
    if (R1Response != 0x00) {
        printf("CMD13: R1 Response was 0x%02x.\n", R1Response);
        return false;
    }
    uint8_t R2Response = getR2Response();
    if (R2Response != 0x00) {
        printf("CMD13: R2 Response was 0x%02x.\n", R2Response);
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

//!
//! \brief
//!     Check SD Card Status
//!
//! \returns
//!     True if the SD Card has been initialized successfully, false otherwise.
//!

bool SDStatus(void) {
    return initialized;
}

//!
//! \brief
//!     Timer Interrupt
//!
//! \details
//!     The Timer Interrupt polls the SD Card Detect input and periodically
//!     looks for card insertions and card removals.
//!

void SDTimerInterrupt(void) {
    static uint32_t lastCardDetect = 0;
    uint32_t cardDetect = GPIOPinRead(GPIO_PORTCD_BASE, GPIO_PIN_CD);
    if (cardDetect && !lastCardDetect) {
        printf("KS10> SD Card Inserted.\n");
        SDInitializeCard();
    } else if (!cardDetect && lastCardDetect) {
        printf("KS10> SD Card Ejected.\n");
        initialized = false;
    }
    lastCardDetect = cardDetect;
}


void SDInitialize(void) {

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_SSI0);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTCS_BASE, GPIO_PIN_CS);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTCD_BASE, GPIO_PIN_CD);
    ROM_GPIOPinTypeSSI(GPIO_PORTA_BASE, GPIO_PIN_2 | GPIO_PIN_4 | GPIO_PIN_5);
    ROM_SSIConfigSetExpClk(SSI_BASE, SysCtlClockGet(), SSI_FRF_MOTO_MODE_0, SSI_MODE_MASTER, bitRate, 8);
    ROM_SSIEnable(SSI_BASE);
    chipEnable(false);
    puts("1, ");
}
