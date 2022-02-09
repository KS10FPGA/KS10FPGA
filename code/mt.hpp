//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    MT Interface Object
//!
//! \details
//!    This object allows the console to interact with the RH11 Massbus
//!    Controller, MT03 Tape Formatter, and TU-45 Tape Drive.
//!
//! \file
//!    mt.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2022 Rob Doyle
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

#ifndef __MT_HPP
#define __MT_HPP

#include <stdio.h>
#include <stdint.h>

#include "uba.hpp"
#include "ks10.hpp"
#include "rh11.hpp"

//!
//! \brief
//!    MT Interface Object
//!

class mt_t : public rh11_t {

    private:

        //
        // MT Control/Status Regiter #1 (MTCS1)
        //

        static const uint16_t MTCS1_SC     = 0100000;
        static const uint16_t MTCS1_RDY    = 0000200;
        static const uint16_t MTCS1_CMDRD  = 0000070;
        static const uint16_t MTCS1_CMDWR  = 0000060;
        static const uint16_t MTCS1_CMDWCH = 0000050;
        static const uint16_t MTCS1_CMDPRE = 0000020;
        static const uint16_t MTCS1_CMDCLR = 0000010;
        static const uint16_t MTCS1_GO     = 0000001;
        static const uint16_t MTCS1_FUN_UNLOAD   = 003;
        static const uint16_t MTCS1_FUN_REWIND   = 007;
        static const uint16_t MTCS1_FUN_DRVCLR   = 011;
        static const uint16_t MTCS1_FUN_PRESET   = 021;
        static const uint16_t MTCS1_FUN_ERASE    = 025;
        static const uint16_t MTCS1_FUN_WRTM     = 027;
        static const uint16_t MTCS1_FUN_SPCFWD   = 031;
        static const uint16_t MTCS1_FUN_SPCREV   = 033;
        static const uint16_t MTCS1_FUN_WRCHKFWD = 051;
        static const uint16_t MTCS1_FUN_WRCHKREV = 057;
        static const uint16_t MTCS1_FUN_WRFWD    = 061;
        static const uint16_t MTCS1_FUN_RDFWD    = 071;
        static const uint16_t MTCS1_FUN_RDREV    = 077;

        //
        static const uint16_t MTCS2_WCE    = 0040000;
        static const uint16_t MTCS2_OR     = 0000200;
        static const uint16_t MTCS2_IR     = 0000100;
        static const uint16_t MTCS2_CLR    = 0000040;
        static const uint16_t MTCS2_UNIT   = 0000007;
        // MT Drive Status Register (MTDS) Definitions
        //

        static const uint16_t MTDS_ATA     = 0100000;
        static const uint16_t MTDS_MOL     = 0010000;
        static const uint16_t MTDS_DPR     = 0000400;
        static const uint16_t MTDS_DRY     = 0000200;
        static const uint16_t MTDS_BOT     = 0000002;

        //
        // MT Error Register (MTER) Definitions
        //

        static const uint16_t MTER_FCE     = 0001000;

        //
        // MT Tape Control (MTTC) Definitions
        //

        static const uint16_t MTTC_SS      = 0000007;

        //
        // Private Functions
        //

        void executeCommand(uint16_t cmd, uint16_t param, uint16_t wordCnt = 0, uint16_t frameCnt = 0, ks10_t::addr_t = 0);

        //
        // Default TCU
        //

        static const uint16_t unit = 0;

    public:

        static const uint32_t baseADDR_MT = 03772440;

        //
        // MT non-volatile configuration
        //

        struct cfg_t {
            uint32_t mtccr;             // Console control register
            uint32_t baseaddr;          // Base address (includes UBA field)
            uint16_t param;             // Tape parameters (sets MTTC) (include slave and density)
            uint8_t  unit;              // Selected tape control unit (TCU)
            bool     bootdiag;          // Boot to diagnostic monitor
        } cfg;

        //!
        //! \brief
        //!    Take twos complement of non-zero numbers
        //!
        //! \details
        //!    The two's complement is done directly so it works on unsigned
        //!    numbers.
        //!
        //! \note
        //!    This is useful for setting the Word Count Register and setting
        //!    the Frame Count Register.
        //!

        uint16_t CMPL2(uint16_t in) {
            return (in == 0) ? 0 : ~in + 1;
        }

        static const char *printDEN(uint8_t den);
        static const char *printFMT(uint8_t fmt);
        static const char *printFUN(uint8_t fun);
        static const char *printMOP(uint8_t mop);
        static void dumpMTCS1(ks10_t::addr_t addr);
        static void dumpMTCS2(ks10_t::addr_t addr);
        static void dumpMTDS(ks10_t::addr_t addr);
        static void dumpMTER(ks10_t::addr_t addr);
        static void dumpMTMR(ks10_t::addr_t addr);
        static void dumpMTWC(ks10_t::addr_t addr);
        static void dumpMTFC(ks10_t::addr_t addr);
        static void dumpMTTC(ks10_t::addr_t addr);
        void dumpRegs(void);
        void cmdRewind(uint16_t param);
        void cmdUnload(uint16_t param);
        void cmdPreset(uint16_t param);
        void cmdSpaceFwd(uint16_t param, uint16_t frameCount);
        void cmdSpaceRev(uint16_t param, uint16_t frameCount);
        void testInit(uint16_t param);
        void testRead(uint16_t param);
        void testWrite(uint16_t param);
        void testWrchk(uint16_t param);
        void recallConfig(void);
        void saveConfig(void);
        void boot(uint16_t unit, uint16_t param, bool diagmode = false);
        mt_t(int32_t baseADDR = baseADDR_MT) : rh11_t(baseADDR) {
            ;
        }
};

#endif
