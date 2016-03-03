//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Telnet Task
//!
//! This module initializes lwIP and the telnet task
//!
//! \file
//!      telnet_task.cpp
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2014-2016 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 2 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
// Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#include "rom.h"
#include "stdio.h"
#include "lwiplib.h"
#include "telnet.hpp"
#include "telnet_task.hpp"
#include "inc/hw_ints.h"
#include "inc/hw_types.h"

//!
//! Telnet handles
//!

telnet_t* telnet23;
telnet_t* telnet2000;

//!
//! \brief
//!    Telnet initalization
//!
//! \details
//!    This function creates a telnet object and returns a pointer to it.
//!
//! \param port -
//!    telnet port
//!
//! \param debug -
//!    enable debug
//!
//! \returns
//!    pointer to telnet object (i.e., "this pointer") as a handle or NULL if
//!    system could not create the telnet object.
//!

telnet_t* telnet_init(unsigned int port, bool debug) {

    telnet_t *telnet = new telnet_t(port, debug);
    if (telnet == NULL) {
        printf("NET : Can't create telnet object.\n");
    }
    return telnet;

}

//!
//! Setup Telnet Callback
//!
//! \details
//!    This function initializes the various telnet ports.
//!
//! \param
//!    arg - pointer to task parameter.
//!

static void setupTelnet(void *arg) {

    debug_t *debug = static_cast<debug_t *>(arg);

    telnet23   = telnet_init(  23, debug->debugTelnet);
    telnet2000 = telnet_init(2000, debug->debugTelnet);
    printf("NET : Telnet servers started.\n");

}

//!
//! startTelnetTask
//!
//! \details
//!    This function initializes the LWIP task and sets up a callback to
//!    initialize the telnet interfaces.
//!

void startTelnetTask(debug_t *debug) {

    //
    // Get the MAC address from the user registers.
    //

    unsigned long user0;
    unsigned long user1;
    ROM_FlashUserGet(&user0, &user1);

    //
    // If the MAC address is unprogrammed, use the default of
    // 00:1a:b6:00:64:00
    //

    if ((user0 == 0xffffffff) || (user1 == 0xffffffff)) {
        user0 = 0x00b61a01;
        user1 = 0x00006400;
    }

    //
    // Convert the MAC address from the form used stored in the User Registers
    // into the form needed by the Ethernet Controller.
    //

    unsigned char macAddr[6];
    macAddr[0] = ((user0 >>  0) & 0xff);
    macAddr[1] = ((user0 >>  8) & 0xff);
    macAddr[2] = ((user0 >> 16) & 0xff);
    macAddr[3] = ((user1 >>  0) & 0xff);
    macAddr[4] = ((user1 >>  8) & 0xff);
    macAddr[5] = ((user1 >> 16) & 0xff);

    printf("NET : MAC Address is %02x:%02x:%02x:%02x:%02x:%02x\n",
           macAddr[0], macAddr[1], macAddr[2],
           macAddr[3], macAddr[4], macAddr[5]);

    //
    // Lower the priority of the Ethernet interrupt handler.  This is required
    // so that the interrupt handler can safely call the interrupt-safe
    // SafeRTOS functions (specifically to send messages to the queue).
    //

    ROM_IntPrioritySet(INT_ETH, 0xc0);

    //
    // Initialize lwIP MAC address and to use DHCP.
    //

    lwIPInit(macAddr, 0, 0, 0, IPADDR_USE_DHCP);

    //
    // Setup the remaining services inside the TCP/IP thread's context.
    //

    tcpip_callback(setupTelnet, debug);

    //
    // Success.
    //

    printf("NET : Successfully started telnet task.\n");

}
