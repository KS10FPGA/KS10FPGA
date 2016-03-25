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
	$(LWIPDIR)/src/core/dns.o \
	$(LWIPDIR)/src/core/init.o \
	$(LWIPDIR)/src/core/mem.o \
	$(LWIPDIR)/src/core/memp.o \
	$(LWIPDIR)/src/core/netif.o \
	$(LWIPDIR)/src/core/pbuf.o \
	$(LWIPDIR)/src/core/raw.o \
	$(LWIPDIR)/src/core/stats.o \
	$(LWIPDIR)/src/core/sys.o \
	$(LWIPDIR)/src/core/tcp.o \
	$(LWIPDIR)/src/core/tcp_in.o \
	$(LWIPDIR)/src/core/tcp_out.o \
	$(LWIPDIR)/src/core/udp.o \
	\
	$(LWIPDIR)/src/core/ipv4/autoip.o \
	$(LWIPDIR)/src/core/ipv4/icmp.o \
	$(LWIPDIR)/src/core/ipv4/igmp.o \
	$(LWIPDIR)/src/core/ipv4/inet.o \
	$(LWIPDIR)/src/core/ipv4/inet_chksum.o \
	$(LWIPDIR)/src/core/ipv4/ip.o \
	$(LWIPDIR)/src/core/ipv4/ip_addr.o \
	$(LWIPDIR)/src/core/ipv4/ip_frag.o \
	\
	$(LWIPDIR)/src/api/api_lib.o \
	$(LWIPDIR)/src/api/api_msg.o \
	$(LWIPDIR)/src/api/err.o \
	$(LWIPDIR)/src/api/netbuf.o \
	$(LWIPDIR)/src/api/netdb.o \
	$(LWIPDIR)/src/api/netifapi.o \
	$(LWIPDIR)/src/api/sockets.o \
	$(LWIPDIR)/src/api/tcpip.o \
	\
	$(LWIPDIR)/src/netif/etharp.o \
	\
	$(LWIPDIR)/ports/stellaris/sys_arch.o \
	$(LWIPDIR)/ports/stellaris/netif/stellarisif.o

CFLAGS +=

HEADERS := \
	lwiplib.h

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
