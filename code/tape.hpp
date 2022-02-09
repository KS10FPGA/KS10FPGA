//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Tape File simulator
//!
//! \details
//!    This file defines an object that performs tape operations on a tape file.
//!
//! \file
//!    tape.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2021-2022 Rob Doyle
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

#ifndef __TAPE_HPP
#define __TAPE_HPP

#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/stat.h>
#include "ks10.hpp"

void *tapeThread(void *arg);

//!
//! \brief
//!    Tape File Object
//!

class tape_t {

    private:
        long fsize;			// file size
        int  filcnt;
        int  objcnt;
        int  reccnt;
        bool statBOT;
        bool statEOT;
        bool lastTM;
        FILE *file;

        enum header_t {
            h_EOT = 0xffffffff,         // End-of-tape
            h_GAP = 0xfffffffe,         // Erase gap
            h_ERR = 0x80000000,         // Header error
            h_TM  = 0x00000000,         // Tape mark
        };

        enum density_t {
            d_1600BPI = 4,
        };

        enum format_t {
            f_CORDMP = 0,
            f_COMPAT = 3,
        };

        bool isSTB(uint64_t in) {
            return in & ks10_t::mtDIR_STB;
        }

        bool isREADY(uint64_t in) {
            return in & ks10_t::mtDIR_READY;
        }

        uint8_t getSS(uint64_t in) {
            return (in & ks10_t::mtDIR_SS) >> 56;
        }

        uint8_t getDEN(uint64_t in) {
            return (in & ks10_t::mtDIR_DEN) >> 53;
        }

        uint8_t getFUN(uint64_t in) {
            return (in & ks10_t::mtDIR_FUN) >> 48;
        }

        uint8_t getFMT(uint64_t in) {
            return (in & ks10_t::mtDIR_FMT) >> 44;
        }

        bool isWCZ(uint64_t in) {
            return in & ks10_t::mtDIR_WCZ;
        }

        bool isFCZ(uint64_t in) {
            return in & ks10_t::mtDIR_FCZ;
        }

        uint64_t getDATA(uint64_t in) {
            return in & ks10_t::mtDIR_DATA;
        }

        int bytes_per_word(uint8_t format) {
            return (format == f_CORDMP) ? 5 : 4;
        }

        int bytes_per_tape(uint8_t density) {
            return (density == d_1600BPI) ? 2400 * 12 * 1600 : 2400 * 12 * 800;
        }

        uint32_t readHeader(void);
        int  writeHeader(uint32_t header);
        int  readDataCORDMP(ks10_t::data_t &data);
        int  readDataCOMPAT(ks10_t::data_t &data);
        int  readData(uint8_t format, ks10_t::data_t &data);
        int  writeDataCORDMP(ks10_t::data_t);
        int  writeDataCOMPAT(ks10_t::data_t);
        int  writeData(ks10_t::data_t, uint8_t format);
        void waitReadWrite(uint8_t density, unsigned int bytes);
        void waitRewind(uint8_t density, unsigned int bytes);
    public:
        void unload(uint64_t mtDIR);
        void rewind(uint64_t mtDIR);
        void preset(uint64_t mtDIR);
        void erase(uint64_t mtDIR);
        void writeTapeMark(uint64_t mtDIR);
        void spaceForward(uint64_t mtDIR);
        void spaceReverse(uint64_t mtDIR);
        void writeCheckForward(uint64_t mtDIR);
        void writeCheckReverse(uint64_t mtDIR);
        void writeForward(uint64_t mtDIR);
        void readForward(uint64_t mtDIR);
        void readReverse(uint64_t mtDIR);
        void validate(void);
        void close(void);
        void processCommand(void);
        tape_t(const char *filename);
        static void *processThread(void *arg);
};

#endif
