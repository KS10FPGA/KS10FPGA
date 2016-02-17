//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Embedded Stdio-like functions.
//!
//! \details
//!    This object provides some of the functionality of stdio.
//!
//! \file
//!    stdio.h
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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


#ifndef __STDIO_H
#define __STDIO_H

#ifdef __cplusplus
extern "C"
{
#endif

    int putchar(int ch);
    int puts(const char *s);
    int getchar(void);
    int printf(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));

#ifdef __cplusplus
}
#endif

#endif
