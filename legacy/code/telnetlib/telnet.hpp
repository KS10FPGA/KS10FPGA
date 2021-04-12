//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Telnet server header file
//!
//! \file
//!    telnet.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
// Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#ifndef __TELNET_HPP
#define __TELNET_HPP

#include <stdint.h>
#include "lwip/tcp.h"

//!
//! Telnet object
//!

class telnet_t {
    public:
        void putchar(char ch);
        void puts(char *s);
        telnet_t(unsigned int port, bool debug);
    private:
        static const char *prompt;                              //!< Prompt
        static const unsigned int magic_number = 0xb0bace4d;    //!< Used to detect object corruption.

        //!
        //! Interpret As Command (IAC) state machine states
        //!

        enum state_t {
            stateNORMAL = 0,
            stateIAC    = 1,
            stateWILL   = 2,
            stateWONT   = 3,
            stateDO     = 4,
            stateDONT   = 5,
        };

        unsigned int port;
        bool debug;
        bool opened;
        state_t state;
        unsigned int magic;
        uint16_t left;
        char obuf[133];
        char ibuf[133];
        tcp_pcb *pcb;

        //
        // Private functions
        //

        void close_conn(void);                                  //!<
        void cmd_parser(void);
        void send_data(void);
        void get_char(char ch);
        void update_state(char ch);
        static err_t recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err);
        static err_t accept(void *arg, struct tcp_pcb *pcb, err_t err);
};

#endif
