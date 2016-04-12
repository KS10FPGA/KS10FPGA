//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Telnet server
//!
//! \file
//!    telnet.cpp
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

#include <stdio.h>
#include <string.h>

#include "lwiplib.h"
#include "stdio.h"
#include "telnet.hpp"
#include "lwip/tcp.h"

//!
//! Prompt
//!

const char *telnet_t::prompt = "\r\ntelnet >";

//!
//! \brief
//!    min() template
//!

template <class T> const T& min(const T& a, const T& b) {
    return (a < b) ? a : b;
}

//!
//! \brief
//!    putchar
//!
//! \param ch -
//!    character to be output
//!

void telnet_t::putchar(char ch) {

    if ((magic == magic_number) && opened) {
        err_t err = tcp_write(pcb, &ch, sizeof(ch), TCP_WRITE_FLAG_COPY);
        if (err != ERR_OK) {
            if (debug) {
                printf("NET : tcp_write() returned %d\n", err);
            }
            return;
        }
    }

}

//!
//! \brief
//!    puts
//!
//! \param s -
//!    string to be output
//!

void telnet_t::puts(char *s) {

    if ((magic == magic_number) && opened) {
        err_t err = tcp_write(pcb, s, strlen(s), 0);
        if (err != ERR_OK) {
            if (debug) {
                printf("NET : tcp_write() returned %d\n", err);
            }
            return;
        }
    }

}

//!
//! \brief
//!    This function closes the connection and frees the telnet state.
//!

void telnet_t::close_conn(void) {

    tcp_arg(pcb, NULL);
    tcp_sent(pcb, NULL);
    tcp_recv(pcb, NULL);
    tcp_close(pcb);
    opened = false;
    printf("NET : Connection closed by foreign host.\n");

}

//!
//! \brief
//!    Parse the command line.
//!
//! \details
//!    If the command line is "quit", the connection is closed.
//!

void telnet_t::cmd_parser(void) {

    if (strncmp(ibuf, "quit", 5) == 0) {
        left = 0;
        close_conn();
        return;
    }
    left = snprintf(obuf, sizeof(obuf),
                    "\r\nThis is TELNET echoing your command : \"%s\"\r\n%s",
                    ibuf, prompt);
    ibuf[0] = 0;

}

//!
//! \brief
//!    Function to send data
//!

void telnet_t::send_data(void) {

    uint16_t bytesSent = 0;
    do {

        uint16_t bytesToSend = min<uint16_t>(left, tcp_sndbuf(pcb));
        err_t err = tcp_write(pcb, &obuf[bytesSent], bytesToSend, 0);

        if (err != ERR_OK) {
            printf("NET : tcp_write() returned %d\n", err);
            return;
        }

        left      -= bytesToSend;
        bytesSent += bytesToSend;

    } while (left > 0);

}

//!
//! \brief
//!    Get a character and line buffer it.
//!
//! \details
//!    This function buffers characters and sends them when a newline is
//!    received.
//!
//! \param ch -
//!    received character
//!

void telnet_t::get_char(char ch) {

    switch(ch) {
        case '\r':
            return;
        case '\n':
            cmd_parser();
            if (left > 0) {
                send_data();
            }
            break;
        default:
            int l = strlen(ibuf);
            ibuf[l++] = ch;
            ibuf[l] = 0;
            break;
    }

}

//!
//! \brief
//!    This function maintains the Telnet Protocol Command decoder state
//!
//! \param ch -
//!    received character
//!
//! \returns
//!    updated pointer to telnet state
//!

void telnet_t::update_state(char ch) {

    enum cmd_t {
        cmdWILL = 251,
        cmdWONT = 252,
        cmdDO   = 253,
        cmdDONT = 254,
        cmdIAC  = 255,
    };

    switch (state) {
        case stateIAC:
            if (ch == cmdIAC) {
                get_char(ch);
                state = stateNORMAL;
            } else {
                switch (ch) {
                    case cmdWILL:
                        state = stateWILL;
                        break;
                    case cmdWONT:
                        state = stateWONT;
                        break;
                    case cmdDO:
                        state = stateDO;
                        break;
                    case cmdDONT:
                        state = stateDONT;
                        break;
                    default:
                        state = stateNORMAL;
                        break;
                }
            }
            break;
        case stateWILL:
            if (debug) {
                printf("NET : Will %d\n", ch);
            }
            left  = snprintf(obuf, 4, "%c%c%c%c", cmdIAC, cmdDONT, ch, 0);
            state = stateNORMAL;
            break;
        case stateWONT:
            if (debug) {
                printf("NET : Wont %d\n", ch);
            }
            left  = snprintf(obuf, 4, "%c%c%c%c", cmdIAC, cmdDONT, ch, 0);
            state = stateNORMAL;
            break;
        case stateDO:
            if (debug) {
                printf("NET : Do %d\n", ch);
            }
            left  = snprintf(obuf, 4, "%c%c%c%c", cmdIAC, cmdWONT, ch, 0);
            state = stateNORMAL;
            if (ch == 6) {
                close_conn();
            }
            break;
        case stateDONT:
            if (debug) {
                printf("NET : Dont %d\n", ch);
            }
            left  = snprintf(obuf, 4, "%c%c%c%c", cmdIAC, cmdWONT, ch, 0);
            state = stateNORMAL;
            break;
        case stateNORMAL:
            if (ch == cmdIAC) {
                state = stateIAC;
            } else {
                get_char(ch);
            }
            break;
        default:
            if (debug) {
                printf("NET : Unrecognized Telnet Command (0x%02x).\n", ch);
            }
            break;
    }

}

//!
//! \brief
//!    TCP Receive Packet Callback
//!
//! \details
//!    This callback is executed when a packet is received.
//!
//!    This design is a little funky because the callbacks cannot call a C++
//!    member function.   We use a static member to work around that and pass
//!    the "this pointer" as an opaque argument.
//!
//! \param arg -
//!    "this pointer" to the telnet object
//!
//! \param pcb -
//!    pointer to pcb
//!
//! \param p -
//!    pointer to pbuf
//!
//! \param err -
//!    error state
//!
//! \returns
//!    ERR_OK always
//!

err_t telnet_t::recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err) {

    telnet_t *ts = static_cast<telnet_t *>(arg);

    if (err != ERR_OK || p == NULL) {

        ts->close_conn();

    } else {

        tcp_recved(pcb, p->tot_len);
        char *buf = static_cast<char*>(p->payload);
        for (int i = 0; i < p->tot_len; i++) {
            ts->update_state(*buf++);
        }
        pbuf_free(p);

    }
    return ERR_OK;

}

//!
//! \brief
//!    TCP accept callback
//!
//! \details
//!    This callback is executed when a listening connection has been made to
//!    another host.  This function should initalize that connection.  It
//!    should also register the receive callback.
//!
//!    This design is a little funky because the callbacks cannot call a C++
//!    member function.   We use a static member to work around that and pass
//!    the "this pointer" as an opaque argument.
//!
//! \param arg -
//!    "this pointer" to the telnet object
//!
//! \param pcb -
//!    pointer to protocol control block (pcb)
//!
//! \param err -
//!    error state
//!
//! \returns
//!    ERR_OK always
//!

err_t telnet_t::accept(void *arg, struct tcp_pcb *pcb, err_t err) {

    (void)err;
    telnet_t *ts = static_cast<telnet_t *>(arg);
    ts->pcb = pcb;

    printf("NET : Accepting connection from %ld.%ld.%ld.%ld\n",
           (pcb->remote_ip.addr >>  0) & 0xff,
           (pcb->remote_ip.addr >>  8) & 0xff,
           (pcb->remote_ip.addr >> 16) & 0xff,
           (pcb->remote_ip.addr >> 24) & 0xff);

    //
    // Set the connection priority
    //

    tcp_setprio(pcb, TCP_PRIO_MIN);

    //
    // Register receive callback
    //

   tcp_recv(pcb, recv);

    //
    // Print message
    //

    ts->left = snprintf(ts->obuf, sizeof(ts->obuf), "\nKS10 Telnet Interface\r\n%s", prompt);
    ts->send_data();
    ts->opened = true;
    return ERR_OK;

}

//!
//! \brief
//!    telnet object constructor
//!
//! \param port -
//!    telnet port
//!
//! \param debug -
//!    enables debugging output
//!

telnet_t::telnet_t(unsigned int port, bool debug) :

    port(port),
    debug(debug),
    opened(false),
    state(stateNORMAL),
    magic(magic_number),
    left(0) {

    ibuf[0] = 0;
    obuf[0] = 0;
    pcb = tcp_new();

    tcp_arg(pcb, this);
    err_t err = tcp_bind(pcb, IP_ADDR_ANY, port);
    if (err != ERR_OK) {
        if (debug) {
            printf("NET : tcp_bind() returned %d\n", err);
        }
        return;
    }
    pcb = tcp_listen(pcb);
    tcp_accept(pcb, telnet_t::accept);

}
