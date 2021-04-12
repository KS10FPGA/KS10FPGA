//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    lwIP wrapper
//!
//! \details
//!    This wrappers the generic lwIP code with LM3S9B96 specific code and with
//!    SafeRTOS-specific code
//!
//! \file
//!    lwiplib.c
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

#include "mdix.h"
#include "stdio.h"
#include "align.hpp"
#include "lwiplib.h"
#include "driverlib/rom.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/ethernet.h"
#include "lwip/dhcp.h"
#include "lwip/autoip.h"
#include "netif/stellarisif.h"

//!
//! \brief
//!    Net interface instance
///!

static struct netif netif;

//!
//! \brief
//!    Initialization callback argument type
//!

struct init_param_t {
    struct ip_addr ip_addr;
    struct ip_addr net_mask;
    struct ip_addr gw_addr;
};

//!
//! \brief
//!    Ethernet queue
//!
//! \details
//!    The Ethernet queue is used as a semaphone to signal the Ethernet Task
//!    that an interrupt has occured.
//!

static xQueueHandle enetIntQueue;

//!
//! \brief
//!    Ethernet interrupt.
//!
//! \details
//!    The Ethernet interrupt just signals the Ethernet Task via the Ethernet
//!    Interrupt Queue
//!

void enetIntHandler(void) {

    //
    // Read and clear the Ethernet interrupt
    //

    unsigned long status = ROM_EthernetIntStatus(ETH_BASE, false);
    ROM_EthernetIntClear(ETH_BASE, status);

    //
    // Signal the Ethernet interrupt task via the Ethernet queue
    //

    portBASE_TYPE taskWoken;
    xQueueSendFromISR(enetIntQueue, &status, &taskWoken);

    //
    // Disable the Ethernet interrupts.  The Ethernet interrupt is re-enabled
    // in the Ethernet task.
    //

    ROM_EthernetIntDisable(ETH_BASE, ETH_INT_RX | ETH_INT_TX);

    //
    // Potentially reschedule
    //

    taskYIELD_FROM_ISR(taskWoken);
}

//!
//! \brief
//!    Ethernet task.
//!
//! \details
//!    This task blocks on the Ethernet Interrupt Queue waiting for a signal.
//!    When a interrupt occurs, this task handles it mostly by calling the
//!    handler function.

static void enetIntTask(void *arg) {

     for (;;) {
        while (xQueueReceive(enetIntQueue, &arg, portMAX_DELAY) != pdPASS) {
            ;
        }
        stellarisif_interrupt(&netif);
        ROM_EthernetIntEnable(ETH_BASE, ETH_INT_RX | ETH_INT_TX);
    }
}

//!
//! \brief
//!    Initialization callback.
//!
//! \param arg
//!    Pointer to initialization data
//!

void init_callback(void *arg) {

    struct init_param_t * init_param = (struct init_param_t *)arg;

    //
    // Create a queue (to be used as a semaphore) to signal the Ethernet
    // interrupt task from the Ethernet interrupt handler.
    //

    const unsigned long queueLen = 1;
    const unsigned long queueSize = sizeof(void *);
    const unsigned long queueBufLen = (queueLen * queueSize) + portQUEUE_OVERHEAD_BYTES;
    static signed char  queueBuffer[sizeof(void *) + portQUEUE_OVERHEAD_BYTES];
    xQueueCreate(queueBuffer, queueBufLen, queueLen, queueSize, &enetIntQueue);

    //
    // Create Ethernet Interrupt task.
    //

    static signed char __align64 stack[512-4];
    xTaskCreate(enetIntTask, (const signed char *)"Ethernet", stack, sizeof(stack), 0, 1, 0);

    //
    // Create, configure and add the Ethernet controller interface with
    // default settings.
    //

    netif_add(&netif, &init_param->ip_addr, &init_param->net_mask, &init_param->gw_addr, NULL, stellarisif_init, tcpip_input);
    netif_set_default(&netif);

    //
    // Start DHCP, if enabled.
    //

#if LWIP_DHCP

    dhcp_start(&netif);

#endif

    //
    // Start AutoIP, if enabled
    //

#if LWIP_AUTOIP

    autoip_start(&netif);

#endif

    //
    // Set up interface
    //

    netif_set_up(&netif);

    //
    // Start the MDI-X timer
    //

    start_mdix();
}

//!
//! \brief
//!    Initialize lwIP
//!

//! \param ip_addr -
//!    IP Address
//!
//! \param net_mask -
//!    Netmask
//!
//! \param gw_addr -
//!    Gateway Address
//!

void lwip_param(struct ip_addr *ip_addr, struct ip_addr *net_mask, struct ip_addr *gw_addr) {

    static struct init_param_t init_param;

#if DHCP

    init_param.ip_addr.addr  = 0;
    init_param.net_mask.addr = 0;
    init_param.gw_addr.addr  = 0;

#else

    init_param.ip_addr.addr  = ip_addr->addr;
    init_param.net_mask.addr = net_mask->addr;
    init_param.gw_addr.addr  = gw_addr->addr;

#endif

    tcpip_init(init_callback, &init_param);

}

//!
//! \brief
//!    Function to return the lwIP net interface parameters
//!
//! \returns
//!    netif
//!

const struct netif *lwip_netif(void) {
    return &netif;
}
