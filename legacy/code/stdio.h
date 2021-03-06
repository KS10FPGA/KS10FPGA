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


#ifndef __STDIO_H
#define __STDIO_H

#include <stdarg.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C"
{
#endif

    int putchar(int ch);
    int puts(const char *s);
    int getchar(void);
    int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap) __attribute__ ((format (printf, 3, 0)));
    int printf(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
    int sprintf(char *buf, const char *fmt, ...) __attribute__ ((format (printf, 2, 3)));
    int snprintf(char *buf, size_t size, const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));

#ifdef __cplusplus
}
#endif

#endif
