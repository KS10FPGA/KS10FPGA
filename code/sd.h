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
//!      sd.h
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

#ifndef __SD_H
#define __SD_H

#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

    void SDInitialize(void);
    bool SDStatus(void);
    void SDCardDetect(bool init);
    bool SDInitializeCard(void);
    bool SDReadSector(uint8_t *buf, uint32_t sector);
    bool SDWriteSector(const uint8_t *buf, uint32_t sector);

#ifdef __cplusplus
}
#endif
#endif
