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

        static const uint16_t MTTC_DEN     = 003400;
        static const uint16_t MTTC_FMT     = 000360;
        static const uint16_t MTTC_SS      = 0000007;

        static const uint16_t MTTC_DEN800NRZ = 001400;
        static const uint16_t MTTC_DEN1600PE = 002000;
        static const uint16_t MTTC_FMT10CORE = 000000;
        static const uint16_t MTTC_FMT10NORM = 000060;

        //
        // Private Functions
        //

        void executeCommand(uint16_t tcu, uint16_t param, uint16_t cmd, uint16_t wordCnt = 0, uint16_t frameCnt = 0, ks10_t::addr_t = 0);

    public:

        static const uint32_t baseADDR_MT = 03772440;

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

        //!
        //! \brief
        //!   Set the Write Lock status for selected unit
        //!

        static uint32_t writeLock(uint32_t mtccr, unsigned int unit, bool state) {
            if (unit < 8) {
                if (state) {
                    mtccr |=  (1 << (0 + unit));
                } else {
                    mtccr &= ~(1 << (0 + unit));
                }
            }
            return mtccr;
        }

        //!
        //! \brief
        //!   Return the Write Lock status for selected unit
        //!

        static bool writeLock(uint32_t mtccr, unsigned int unit) {
            if (unit >= 8) {
                return false;
            }
            return ((mtccr >> (0 + unit)) & 1);
        }

        //!
        //! \brief
        //!   Set the Media Online status for selected unit
        //!

        static uint32_t online(uint32_t mtccr, unsigned int unit, bool state) {
            if (unit < 8) {
                if (state) {
                    mtccr |=  (1 << (8 + unit));
                } else {
                    mtccr &= ~(1 << (8 + unit));
                }
            }
            return mtccr;
        }

        //!
        //! \brief
        //!   Return the Media Online status for selected unit
        //!

        static bool online(uint32_t mtccr, unsigned int unit) {
            if (unit >= 8) {
                return false;
            }
            return ((mtccr >> (8 + unit)) & 1);
        }

        //!
        //! \brief
        //!   Set the Media Online status for selected unit
        //!

        static uint32_t present(uint32_t mtccr, unsigned int unit, bool state) {
            if (unit < 8) {
                if (state) {
                    mtccr |=  (1 << (16 + unit));
                } else {
                    mtccr &= ~(1 << (16 + unit));
                }
            }
            return mtccr;
        }

        //!
        //! \brief
        //!   Return the drive present status for selected unit
        //!

        static bool present(uint32_t mtccr, unsigned int unit) {
            if (unit >= 8) {
                return false;
            }
            return ((mtccr >> (16 + unit)) & 1);
        }

        //!
        //! \brief
        //!   Set the format in the parameter variable
        //!

        static uint16_t format(uint16_t param, uint16_t fmt) {
            static const uint16_t fmtmask = 000360;
            return (param & ~fmtmask) | (fmt << 4);
        }

        //!
        //! \brief
        //!   Print the format in the parameter variable
        //!

        static const char *format(uint16_t param) {
            static const uint16_t fmtmask = 000360;
            return printFMT((param & fmtmask) >> 4);
        }

        //!
        //! \brief
        //!   Set the density in the parameter variable
        //!

        static uint16_t density(uint16_t param, uint16_t den) {
            static const unsigned int denmask = 003400;
            return (param & ~denmask) | (den << 8);
        }

        //!
        //! \brief
        //!   Print the density in the parameter variable
        //!

        static const char *density(uint16_t param) {
            static const unsigned int denmask = 003400;
            return printDEN((param & denmask) >> 8);
        }

        //!
        //! \brief
        //!   Set the slave in the parameter variable
        //!

        static uint16_t slave(uint16_t param, uint16_t slv) {
            static const uint16_t slvmask = 000007;
            return (param & ~slvmask) | (slv << 0);
        }

        //!
        //! \brief
        //!   Print the drive present status for selected unit
        //!

        static const char *slave(uint16_t param) {
            static const uint16_t slvmask = 000007;
            return printFMT((param & slvmask) >> 0);
        }

        static const char *printDEN(uint16_t den);
        static const char *printFMT(uint16_t fmt);
        static const char *printFUN(uint16_t fun);
        static const char *printMOP(uint16_t mop);
        static void dumpMTCS1(ks10_t::addr_t addr);
        static void dumpMTCS2(ks10_t::addr_t addr);
        static void dumpMTDS(ks10_t::addr_t addr);
        static void dumpMTER(ks10_t::addr_t addr);
        static void dumpMTMR(ks10_t::addr_t addr);
        static void dumpMTWC(ks10_t::addr_t addr);
        static void dumpMTFC(ks10_t::addr_t addr);
        static void dumpMTTC(ks10_t::addr_t addr);

        void dumpRegs(uint16_t tcu, uint16_t param);
        void cmdErase(uint16_t tcu, uint16_t param);
        void cmdRewind(uint16_t tcu, uint16_t param);
        void cmdUnload(uint16_t tcu, uint16_t param);
        void cmdPreset(uint16_t tcu, uint16_t param);
        void cmdSpaceFwd(uint16_t tcu, uint16_t param, uint16_t frameCount);
        void cmdSpaceRev(uint16_t tcu, uint16_t param, uint16_t frameCount);
        void testInit(uint16_t tcu, uint16_t param);
        void testRead(uint16_t tcu, uint16_t param);
        void testWrite(uint16_t tcu, uint16_t param);
        void testWrchk(uint16_t tcu, uint16_t param);
        void boot(uint16_t tcu, uint16_t param, bool diagmode = false);

        //!
        //! \brief
        //!    Constructor. Setup register addresses.
        //!

        mt_t(int32_t baseADDR = baseADDR_MT) : rh11_t(baseADDR) {
            ;
        }
};

#endif
