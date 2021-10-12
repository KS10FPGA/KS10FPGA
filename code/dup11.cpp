//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    DUP11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the DUP11 Terminal
//!    Multiplexer.   This is mostly for testing the DUP11 from the console.
//!
//! \file
//!    dup11.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2021 Rob Doyle
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

#include "stdio.h"
#include "uba.hpp"
#include "dup11.hpp"
#include "config.hpp"

//!
//! \brief
//!    Configuration file name
//!

static const char *cfg_file = ".ks10/dup11.cfg";

//!
//! \brief
//!    Recall the non-volatile DUP configuration from file
//!

void dup11_t::recallConfig(void) {
    if (!config_t::read(cfg_file, &cfg, sizeof(cfg))) {
        printf("KS10: Unable to read \"%s\".  Using defaults.\n", cfg_file);
    }

    // Init DUPCCR for now
    ks10_t::writeDUPCCR(ks10_t::dupH325 | ks10_t::dupW3 | ks10_t::dupW6);
}

//!
//! \brief
//!    Save the non-volatile DUP configuration to file
//!

void dup11_t::saveConfig(void) {
    cfg.dupccr = ks10_t::readDZCCR();
    if (config_t::write(cfg_file, &cfg, sizeof(cfg))) {
        printf("      dup: sucessfully wrote configuration file \"%s\".\n", cfg_file);
    }
}

//!
//! \brief
//!    Dump DUP11 registers
//!

void dup11_t::dumpRegs(void) {

    printf("KS10: Register Dump\n"
           "      UBAS  : %012llo\n"
           "      RXCSR : %06o\n"
           "      TXCSR : %06o\n"
           "      DUPCCR: 0x%08x\n",
           uba.readCSR(),
           ks10_t::readIO16(addrRXCSR),
           ks10_t::readIO16(addrTXCSR),
           ks10_t::readDZCCR());
}

