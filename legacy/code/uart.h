//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    UART Object
//!
//! \file
//!    uart.h
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

#ifndef __UART_H
#define __UART_H

#ifdef __cplusplus
extern "C" {
#endif

    bool txFull(void);
    void putUART(char ch);
    int  getUART(void);
    void enableUARTIntr(void);

#ifdef __cplusplus
}
#endif

#endif
