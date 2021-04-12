//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    MDI-X Interface
//!
//! \details
//!    The auto MDI-X requires software assistance in the LM3S9B96.   This code
//!    periodically polls the interface state.   If the interface is down for
//!    for two seconds, this code will alternate between MDI and MDI-X and
//!    automatically choose the configuration to match the other end of the
//!    Ethernet link.
//!
//! \file
//!    mdix.c
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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

#include "driverlib/rom.h"
#include "driverlib/inc/hw_ethernet.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_types.h"

#include "lwip/sys.h"

//!
//! MDIX Timer
//!

static unsigned int timerMDIX = 0;

//!
//! 10 milliseconds polling period
//!

static const unsigned int timerMDIXperiod = 10;

//!
//! \brief
//!    This function implements the automatic MDI/MDIX detection.
//!
//! \param arg -
//!    not used
//!

static void timerMDIXupdate(void *arg) {
    
    //
    // 2 seconds of inactivity 
    //

    static const unsigned int timerMDIXtimeout = 2000;

    //
    // See if link is active
    //

    if ((ROM_EthernetPHYRead(ETH_BASE, PHY_MR1) & PHY_MR1_LINK) == 0) {

        //
        // Link is down.  Update timer.
        //

        timerMDIX += timerMDIXperiod;

        //
        // Check for timeout. 
        //

        if (timerMDIX > timerMDIXtimeout) {

            //
            // Toggle between MDI and MDI-X
            //

            HWREG(ETH_BASE + MAC_O_MDIX) ^= MAC_MDIX_EN;

            //
            // Reset the MDI-X timer.
            //

            timerMDIX = 0;
        }

    } else {

        //
        // Link is active. Reset the MDI-X timer.
        //

        timerMDIX = 0;
    }

    //
    // Re-schedule the MDI-X timer
    //

    sys_timeout(timerMDIXperiod, timerMDIXupdate, NULL);
}

//!
//! \brief
//!    Start the MDIX detection.
//!

void start_mdix(void) {
    sys_timeout(timerMDIXperiod, timerMDIXupdate, NULL);
}
