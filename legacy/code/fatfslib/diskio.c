//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Disk IO Interface
//!
//! This object is the interface between the KS10 SD Card Drivers and the FAT
//! filesystem.
//!
//! \file
//!    diskio.cpp
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

#include <stdbool.h>
#include "ffconf.h"
#include "diskio.h"
#include "../sd.h"
#include "../stdio.h"

//!
//! Initialize the Drive
//!
//! \param [in] pdrv
//!     Physical drive number (0..255)
//!
//! \returns
//!     0 if successfully initialized, or
//!     STA_NOINIT otherwise.
//!
//! \note
//!     Only drive 0 is supported
//!

DSTATUS disk_initialize(BYTE pdrv) {
    if (!sdStatus()) {
        sdInitialize();
    }
    return (pdrv == 0) ? 0 : STA_NOINIT;
}

//!
//! Get Disk Status
//!
//! \param [in] pdrv
//!     Physical drive number (0..255)
//!
//! \returns
//!     0 if successfully initialized, or
//!     STA_NOINIT otherwise.
//!
//! \note
//!     Only drive 0 is supported.
//!

DSTATUS disk_status(BYTE pdrv) {
    return ((pdrv == 0) && sdStatus()) ? 0 : STA_NOINIT;
}

//!
//! Read Sector(s) from disk
//!
//! \param [in] pdrv
//!     Physical drive number (0..255)
//!
//! \param [in, out] buf
//!     Buffer to store read data.  Must be large enough for entire
//!     read operation.
//!
//! \param [in] sector
//!     Sector address (LBA)
//!
//! \param [in] count
//!     Number of sectors to read (1..128)
//!
//! \details
//!     The SD Card only implements single sector read operations.
//!     The read operation is called multiple times if multiple
//!     sectors are read.
//!
//! \returns
//!     RES_OK if disk was read successfully,
//!     RES_PARERR if not drive 0,
//!     RES_NOTRDY if the disk is busy,
//!     RES_ERR if read failed.
//!
//! \note
//!     Only drive 0 is supported.
//!

DRESULT disk_read(BYTE pdrv, BYTE *buf, DWORD sector, BYTE count) {
    if (pdrv != 0) {
        return RES_PARERR;
    } else if (!sdStatus()) {
        return RES_NOTRDY;
    }

    BYTE * bufptr = buf;
    for (DWORD i = 0; i < count; i++) {
        bool success = sdReadSector(bufptr, sector + i);
        if (!success) {
            return RES_ERROR;
        }
    }
    return RES_OK;
}

//!
//! Write Sector(s) to disk
//!
//! \param [in] pdrv
//!     Physical drive number (0..255)
//!
//! \param [in, out] buf
//!     Buffer to get data written to disk.
//!
//! \param [in] sector
//!     Sector address (LBA)
//!
//! \param [in] count
//!     Number of sectors to read (1..128)
//!
//! \details
//!     The SD Card only implements single sector write operations.
//!     The write operation is called multiple times if multiple
//!     sectors are written.
//!
//! \returns
//!     RES_OK if disk was written successfully,
//!     RES_PARERR if not drive 0,
//!     RES_NOTRDY if the disk is busy,
//!     RES_ERR if write failed.
//!
//! \note
//!     Only drive 0 is supported.
//!

#if !_FS_READONLY

DRESULT disk_write(BYTE pdrv, const BYTE *buf, DWORD sector, BYTE count) {

    if (pdrv != 0) {
        return RES_PARERR;
    } else if (!sdStatus()) {
        return RES_NOTRDY;
    }

    const BYTE * bufptr = buf;
    for (DWORD i = 0; i < count; i++) {
        bool success = sdWriteSector(bufptr, sector + i);
        if (!success) {
            return RES_ERROR;
        }
    }
    return RES_OK;
}

#endif

//!
//! Disk device control
//!
//! \param [in] pdrv
//!     Physical drive number (0..255)
//!
//! \param [in] cmd
//!     Control command code
//!
//! \param [in, out] buf
//!     Parameter buffer
//!
//!
//! \details
//!     The SD Card parameter are hard coded and not exactly
//!     correct.
//!
//! \returns
//!     RES_OK on recognized commands,
//!     RES_PARERR if not drive 0 or if the command is unrecognized.
//!
//! \note
//!     Only drive 0 is supported.
//!     Only the necessary ioctls are implemented.
//!

#if _USE_MKFS
#error "diskio.c: GET_SECTOR_COUNT and GET_BLOCK_SIZE ioctls are not implemented."
#endif

#if _MAX_SS != 512
#error "diskio.c: GET_SECTOR_SIZE ioctl is not implemented."
#endif

#if !_FS_READONLY

DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void* buf) {

    if (pdrv != 0) {
        return RES_PARERR;
    } else if (!sdStatus()) {
        return RES_NOTRDY;
    }

    switch(cmd) {
        case CTRL_SYNC:
            return RES_OK;
        case GET_SECTOR_COUNT:
        case GET_BLOCK_SIZE:
        case GET_SECTOR_SIZE:
            printf("disk_ioctl() - Unimplemented ioctl (%d)\n", cmd);
            return RES_PARERR;
        default:
            printf("disk_ioctl() - Unrecognized ioctl (%d)\n", cmd);
            return RES_PARERR;
    }

}

#endif

//!
//! Return the current time in FAT format
//!
//! \returns
//!     21 June 2017, 12:00:00 AM always
//!
//! \note
//!     We just need to return a valid time.  We don't have
//!     a realtime clock so we make one up.  We use today.
//!

#if !_FS_READONLY

DWORD get_fattime(void) {
    return (((2017UL - 1980) << 25) |   // 2017
            ( 6UL << 21) |              // Month
            (21UL << 16) |              // Day
            (12UL << 11) |              // Hour
            ( 0UL << 5)  |              // Min
            ( 0UL >> 1));               // Sec

#endif

}
