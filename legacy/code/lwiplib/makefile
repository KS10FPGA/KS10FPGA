#******************************************************************************
#
# KS10 Console Microcontroller
#
# Brief
#    LWIP Library Build rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2017 Rob Doyle
#
# This file is part of the KS10 FPGA Project
#
# The KS10 FPGA project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KS10 FPGA project is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this software.  If not, see <http://www.gnu.org/licenses/>.
#
#******************************************************************************

ifneq (${MAKECMDGOALS}, clean)
ifneq (${MAKECMDGOALS}, rcsclean)
include ../makedefs
endif
endif

TARGET := \
	lwiplib

LWIPDIR := \
	lwip-1.3.2

FILES := \
	lwiplib.o \
	mdix.o \
	$(LWIPDIR)/src/core/dhcp.o \
	$(LWIPDIR)/src/core/init.o \
	$(LWIPDIR)/src/core/mem.o \
	$(LWIPDIR)/src/core/memp.o \
	$(LWIPDIR)/src/core/netif.o \
	$(LWIPDIR)/src/core/pbuf.o \
	$(LWIPDIR)/src/core/raw.o \
	$(LWIPDIR)/src/core/sys.o \
	$(LWIPDIR)/src/core/tcp.o \
	$(LWIPDIR)/src/core/tcp_in.o \
	$(LWIPDIR)/src/core/tcp_out.o \
	$(LWIPDIR)/src/core/udp.o \
	\
	$(LWIPDIR)/src/core/ipv4/icmp.o \
	$(LWIPDIR)/src/core/ipv4/inet.o \
	$(LWIPDIR)/src/core/ipv4/inet_chksum.o \
	$(LWIPDIR)/src/core/ipv4/ip.o \
	$(LWIPDIR)/src/core/ipv4/ip_addr.o \
	$(LWIPDIR)/src/api/tcpip.o \
	\
	$(LWIPDIR)/src/netif/etharp.o \
	\
	$(LWIPDIR)/ports/stellaris/sys_arch.o \
	$(LWIPDIR)/ports/stellaris/netif/stellarisif.o

CFLAGS +=

HEADERS := \
	mdix.h \
	lwiplib.h \
	lwipopts.h \
	../align.hpp

$(TARGET).a : $(FILES)

$(FILES) : $(HEADERS)

clean:
	rm -f *.o
	rm -f *.a
	rm -f *.d
	rm -f $(FILES)

rcsclean: clean
	rcsclean *

rcsfetch: $(HEADERS) $(FILES:.o=.c) makefile

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
