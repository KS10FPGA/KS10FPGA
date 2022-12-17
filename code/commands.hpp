//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Console commands
//!
//! \details
//!    This header file defines the interfaces to the command processing
//!    functions.
//!
//! \file
//!    commands.hpp
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

#ifndef __COMMANDS_HPP
#define __COMMANDS_HPP

//!
//! Command processor object
//!

class command_t {
    private:
        void recallConfig(void);

        bool cmdBA(int argc, char *argv[]);
        bool cmdBR(int argc, char *argv[]);
        bool cmdCE(int argc, char *argv[]);
        bool cmdCO(int argc, char *argv[]);
        bool cmdCL(int argc, char *argv[]);
        bool cmdCPU(int argc, char *argv[]);
        bool cmdDA(int argc, char *argv[]);
        bool cmdDUP(int argc, char *argv[]);
        bool cmdDZ(int argc, char *argv[]);
        bool cmdEX(int argc, char *argv[]);
        bool cmdGO(int argc, char *argv[]);
        bool cmdHA(int argc, char *argv[]);
        bool cmdHE(int argc, char *argv[]);
        bool cmdHS(int argc, char *argv[]);
        bool cmdLP(int argc, char *argv[]);
        bool cmdMR(int argc, char *argv[]);
        bool cmdMT(int argc, char *argv[]);
        bool cmdQU(int argc, char *argv[]);
        bool cmdRD(int argc, char *argv[]);
        bool cmdRP(int argc, char *argv[]);
        bool cmdSH(int argc, char *argv[]);
        bool cmdSI(int argc, char *argv[]);
        bool cmdST(int argc, char *argv[]);
        bool cmdTE(int argc, char *argv[]);
        bool cmdTP(int argc, char *argv[]);
        bool cmdTR(int argc, char *argv[]);
        bool cmdWR(int argc, char *argv[]);
        bool cmdZM(int argc, char *argv[]);
        bool cmdZZ(int argc, char *argv[]);

    public:
        bool execute(char * buf);
        command_t(void) {
            recallConfig();
        }
        static bool consoleOutput(void);

};

#endif
