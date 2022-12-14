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

        unsigned int tapeLength;        //!< Length of tape in feet
        unsigned int debug;             //!< Tape debugging
        long fsize;                     //!< File size
        int  filcnt;                    //!< File count
        int  objcnt;                    //!< Object count
        int  reccnt;                    //!< Record count
        bool statBOT;                   //!< BOT state
        bool statEOT;                   //!< EOT state
        bool lastTM;                    //!< TM state
        FILE *file;                     //!< File pointer

        //!
        //! \brief
        //!    File header contents
        //!

        enum header_t {
            h_EOT = 0xffffffff,         // End-of-tape
            h_GAP = 0xfffffffe,         // Erase gap
            h_ERR = 0x80000000,         // Header error
            h_TM  = 0x00000000,         // Tape mark
        };

        //!
        //! \brief
        //!    Tape densities
        //!

        enum density_t {
            d_800BPI  = 3,
            d_1600BPI = 4,
        };

        //!
        //! \brief
        //!    File formats
        //!

        enum format_t {
            f_CORDMP = 0,
            f_COMPAT = 3,
        };

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Strobe bit
        //!
        //! \returns
        //!    State of the mtDIR[STB] bit
        //!

        bool isSTB(uint64_t in) {
            return in & ks10_t::mtDIR_STB;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Ready bit
        //!
        //! \returns
        //!    State of the mtDIR[READY] bit
        //!

        bool isREADY(uint64_t in) {
            return in & ks10_t::mtDIR_READY;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Slave Select bits
        //!
        //! \returns
        //!    State of the mtDIR[SS] bits
        //!

        uint8_t getSS(uint64_t in) {
            return (in & ks10_t::mtDIR_SS) >> 56;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Density bits
        //!
        //! \returns
        //!    State of the mtDIR[DEN] bits
        //!

        uint8_t getDEN(uint64_t in) {
            return (in & ks10_t::mtDIR_DEN) >> 53;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Function bits
        //!
        //! \returns
        //!    State of the mtDIR[FUN] bits
        //!

        uint8_t getFUN(uint64_t in) {
            return (in & ks10_t::mtDIR_FUN) >> 48;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Format bits
        //!
        //! \returns
        //!    State of the mtDIR[FMT] bits
        //!

        uint8_t getFMT(uint64_t in) {
            return (in & ks10_t::mtDIR_FMT) >> 44;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Word Count Zero bit
        //!
        //! \returns
        //!    State of the mtDIR[WCZ] bit
        //!

        bool isWCZ(uint64_t in) {
            return in & ks10_t::mtDIR_WCZ;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Frame Count Zero bit
        //!
        //! \returns
        //!    State of the mtDIR[FCZ] bit
        //!

        bool isFCZ(uint64_t in) {
            return in & ks10_t::mtDIR_FCZ;
        }

        //!
        //! \brief
        //!    This function returns the state of the mtDIR Data bits
        //!
        //! \returns
        //!    State of the mtDIR[DATA] bits
        //!

        uint64_t getDATA(uint64_t in) {
            return in & ks10_t::mtDIR_DATA;
        }

        //!
        //! \brief
        //!    Calculate the number of bytes per KS10 word
        //!
        //! \details
        //!    This function calculates the number of bytes of tape per word.
        //!
        //! \param formt -
        //!    Tape format
        //!
        //! \returns
        //!    This returns the number of bytes per word
        //!

        int bytes_per_word(uint8_t format) {
            return (format == f_CORDMP) ? 5 : 4;
        }

        //!
        //! \brief
        //!    Calculate the number of bytes per tape.
        //!
        //! \details
        //!    This function calculates the number of bytes on the tape given
        //!    the tape length in feet and the tape density in bytes per inch.
        //!    This result is used to calculate the location of the EOT.
        //!
        //! \param density -
        //!    Number of bytes per inch.
        //!
        //! \returns
        //!    This returns the number of bytes that the tape can store.
        //!

        int bytes_per_tape(uint8_t density) {
            return (density == d_1600BPI) ? tapeLength * 12 * 1600 : tapeLength * 12 * 800;
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

        static const unsigned int debugTOP      = 0x00000001;
        static const unsigned int debugHEADER   = 0x00000002;
        static const unsigned int debugUNLOAD   = 0x00000004;
        static const unsigned int debugREWIND   = 0x00000008;
        static const unsigned int debugPRESET   = 0x00000010;
        static const unsigned int debugERASE    = 0x00000020;
        static const unsigned int debugWRTM     = 0x00000040;
        static const unsigned int debugRDFWD    = 0x00000080;
        static const unsigned int debugRDREV    = 0x00000100;
        static const unsigned int debugWRCHKFWD = 0x00000200;
        static const unsigned int debugWRCHKREV = 0x00000400;
        static const unsigned int debugWRFWD    = 0x00000800;
        static const unsigned int debugSPCFWD   = 0x00001000;
        static const unsigned int debugSPCREV   = 0x00002000;
        static const unsigned int debugBOTEOT   = 0x00004000;
        static const unsigned int debugDELAY    = 0x00008000;
        static const unsigned int debugVALIDATE = 0x00010000;
        static const unsigned int debugDATA     = 0x00020000;
        static const unsigned int debugPOS      = 0x00040000;

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
        tape_t(const char *filename, unsigned int tapeLength = 2400, unsigned int debug = 0);
        static void tapeThread(void);
};

#endif
