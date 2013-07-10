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
// Copyright (C) 2013 Rob Doyle
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
    return ((pdrv == 0) && SDInitializeCard()) ? 0 : STA_NOINIT;
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
    return ((pdrv == 0) && SDStatus()) ? 0 : STA_NOINIT;
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
//!     The SD Card only implementes single sector read operations.
//!     The read operation is called multiple times if multiple
//!     sectors are read.
//!
//! \returns 
//!     RES_OK if disk was read successfully,
//!     RES_PARERR if not drive 0,
//!     RES_ERR if read failed.
//!
//! \note
//!     Only drive 0 is supported.
//!

DRESULT disk_read(BYTE pdrv, BYTE *buf, DWORD sector, BYTE count) {
    if (pdrv != 0) {
        return RES_PARERR;
    } else if (!SDStatus()) {
        return RES_NOTRDY;
    }

    BYTE * bufptr = buf;
    for (DWORD i = 0; i < count; i++) {
        bool success = SDReadSector(bufptr, sector + i);
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
//! \param [in out] buf
//!     Buffer to store read data.   Must be large enough for the entire
//!     write operation.
//! 
//! \param [in] sector
//!     Sector address (LBA)
//!
//! \param [in] count
//!     Number of sectors to read (1..128)
//!
//! \details
//!     The SD Card only implementes single sector write operations.
//!     The write operation is called multiple times if multiple
//!     sectors are written.
//!
//!     The KS10 Console SD Disk is read-only.  Writes to the SD Card
//!     always fail and return a write protect error.
//!
//! \returns
//!     RES_WRPRT always
//!
//! \note
//!     Only drive 0 is supported.
//!

#if 0
DRESULT disk_write(BYTE pdrv, const BYTE *buf, DWORD sector, BYTE count) {
    (void)pdrv;
    (void)buf;
    (void)sector;
    (void)count;
    return RES_WRPRT;
}
#endif
