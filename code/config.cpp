//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Configuration Object
//!
//! \details
//!    This object allows the console to store and recall configuration
//!    state from the SD Card.
//!
//! \file
//!    config.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2020 Rob Doyle
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

#include <stdio.h>
#include <stdlib.h>

#include "config.hpp"

//!
//! \brief
//!    Write configuration data.
//!
//! \param filename
//!    Filename to write
//!
//! \param [in] buf
//!    Buffer to be written.
//!
//! \param [in] size
//!    Size of buffer to be written.
//!

bool config_t::write(const char *filename, const void *buf, size_t size) {

    //
    // Open the configuration file
    //

    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {
        printf("KS10: config_t::write() - fopen(%s) failed.\n", filename);
        return false;
    }

    //
    // Write the data.  Check the status.
    //

    size_t bytes = fwrite(buf, 1, size, fp);
    if (bytes != size) {
        printf("KS10: config_t::write() - write() failed.\n");
        fclose(fp);
        return false;
    }

    //
    // Close the file.
    //

    fclose(fp);
    return true;
}

//!
//! \brief
//!    Read configuration data.
//!
//! \param filename
//!    Filename to read
//!
//! \param [in] buf
//!    Buffer to be read.
//!
//! \param [in] size
//!    Size of buffer to be read.
//!

bool config_t::read(const char *filename, void *buf, size_t size) {

    //
    // Open the configuration file
    //

    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("KS10: config_t::write() - fopen(%s) failed.\n", filename);
        return false;
    }

    //
    // Reade the data.  Check the status.
    //

    size_t bytes = fread(buf, 1, size, fp);
    if (bytes != size) {
        printf("KS10: config_t::read() - read() failed.\n");
        fclose(fp);
        return false;
    }

    //
    // Close the file.
    //

    fclose(fp);
    return true;
}

