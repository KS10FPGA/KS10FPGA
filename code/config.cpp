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
// Copyright (C) 2013-2017 Rob Doyle
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

#include "debug.hpp"
#include "config.hpp"

//!
//! \brief
//!    Write configuration data into SD Card.
//!
//! \param debug -
//!    <b>True</b> enables debug mode.
//!
//! \param filename
//!    Filename to write
//!
//! \param [in] buf
//!    Buffer to be written to SD Card.
//!
//! \param [in] size
//!    Size of buffer to be written to SD Card.
//!

bool config_t::write(bool debug, const char *filename, const void *buf, unsigned int size) {

    //
    // Open the configuration file
    //

    FIL fp;
    bool success = true;
    FRESULT status = f_open(&fp, filename, FA_CREATE_ALWAYS | FA_WRITE);
    if (status != FR_OK) {
        debug_printf(debug, "KS10: f_open() returned %d\n", status);
        return false;
    }

    //
    // Write the data.  Check the status.
    //

    unsigned int bytes;
    status = f_write(&fp, buf, size, &bytes);
    if (status != FR_OK) {
        debug_printf(debug, "KS10: f_write() returned %d.\n", status);
        success = false;
    }

    if (bytes != size) {
        debug_printf(debug, "KS10: f_write() wrote partial buffer.\n");
        success = false;
    }

    //
    // Close the file.
    //

    status = f_close(&fp);
    if (status != FR_OK) {
        debug_printf(debug, "KS10: f_close() returned %d\n", status);
        success = false;
    }

    return success;
}

//!
//! \brief
//!    Read configuration data from SD Card.
//!
//! \param debug -
//!    <b>True</b> enables debug mode.
//!
//! \param filename
//!    Filename to read
//!
//! \param [in] buf
//!    Buffer to be read from SD Card.
//!
//! \param [in] size
//!    Size of buffer to be read from SD Card.
//!

bool config_t::read(bool debug, const char *filename, void *buf, unsigned int size) {

    //
    // Open the configuration file
    //

    FIL fp;
    bool success = true;
    FRESULT status = f_open(&fp, filename, FA_READ);
    if (status != FR_OK) {
        debug_printf(debug, "KS10: f_open() returned %d\n", status);
        return false;
    }

    //
    // Write the data.  Check the status.
    //

    unsigned int bytes;
    status = f_read(&fp, buf, size, &bytes);
    if (status != FR_OK) {
        debug_printf(debug, "KS10: f_read() returned %d.\n", status);
        success = false;
    }

    if (bytes != size) {
        debug_printf(debug, "KS10: f_read() read partial buffer.\n");
        success = false;
    }

    //
    // Close the file.
    //

    status = f_close(&fp);
    if (status != FR_OK) {
        debug_printf(debug, "KS10: f_close() returned %d\n", status);
        success = false;
    }

    return success;
}

