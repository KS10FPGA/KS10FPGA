
//#include "lwip/debug.h"
#include "lwip/stats.h"
#include "lwip/tcp.h"

//#include "utils/uartstdio.h"
#include "ustdlib.h"

#include "../lwiplib/lwiplib.h"

#include <string.h>

#include "stdio.h"
#include "telnet.h"
#include <stdio.h>

#define min(a, b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })

enum cmdCode_t {
    cmdCodeWILL = 251,
    cmdCodeWONT = 252,
    cmdCodeDO   = 253,
    cmdCodeDONT = 254,
    cmdCodeIAC  = 255,
};

enum iacState_t {
    iacStateNORMAL = 0,
    iacStateIAC    = 1,
    iacStateWILL   = 2,
    iacStateWONT   = 3,
    iacStateDO     = 4,
    iacStateDONT   = 5,
};

struct state_t {
    char	    outbuf[133];
    char	    cmd_buffer[80];
    u16_t	    left;
    enum iacState_t iacState;
};

static const char *prompt = "\r\niSendIR telnet >";


static void close_conn(struct tcp_pcb *pcb, struct state_t *ts) {
    tcp_arg(pcb, NULL);
    tcp_sent(pcb, NULL);
    tcp_recv(pcb, NULL);
    mem_free(ts);
    tcp_close(pcb);
}


void cmd_parser(struct tcp_pcb *pcb, struct state_t *ts) {

    if (strncmp(ts->cmd_buffer, "quit", 5) == 0) {
        ts->left = 0;
        printf("Closing connection\n");
        close_conn(pcb, ts);
        return;
    }
    ts->left = usnprintf(ts->outbuf, sizeof(ts->outbuf),
                         "\r\nThis is TELNET echoing your command : \"%s\"\r\n%s",
                         ts->cmd_buffer, prompt);
    ts->cmd_buffer[0] = 0;
}

static void send_data(struct tcp_pcb *pcb, struct state_t *ts) {

    u16_t bytesSent = 0;

    do {

        u16_t bytesToSend = min(ts->left, tcp_sndbuf(pcb));
        err_t err = tcp_write(pcb, &ts->outbuf[bytesSent], bytesToSend, 0);

        if (err != ERR_OK) {
            printf("tcp_write() returned %d\n", err);
            return;
        }

        ts->left  -= bytesToSend;
        bytesSent += bytesToSend;

    } while (ts->left > 0);
}

void get_char(struct tcp_pcb *pcb, struct state_t *ts, char c) {
	int l;

	if (c == '\r') return;
	if (c != '\n')
	{
		l = strlen(ts->cmd_buffer);
		ts->cmd_buffer[l++] = c;
		ts->cmd_buffer[l] = 0;
	}
	else
	{
                cmd_parser(pcb, ts);		// handle command
		if (ts->left > 0)
		{
			send_data(pcb, ts);
		}
	}
}

static err_t recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err) {
	char *q;
	int len;

	struct state_t *ts = (struct state_t *)arg;

	if (err == ERR_OK && p != NULL) {

		/* Inform TCP that we have taken the data. */
		tcp_recved(pcb, p->tot_len);

		q = (char*)p->payload;
		len = p->tot_len;

		while(len > 0) {
			char c = *q++;
			--len;

			switch (ts->iacState) {
				case iacStateIAC:
					if(c == cmdCodeIAC) {
						get_char(pcb, ts, c);
						ts->iacState = iacStateNORMAL;
					} else {
						switch(c) {
							case cmdCodeWILL:
								ts->iacState = iacStateWILL;
								break;
							case cmdCodeWONT:
								ts->iacState = iacStateWONT;
								break;
							case cmdCodeDO:
								ts->iacState = iacStateDO;
								break;
							case cmdCodeDONT:
								ts->iacState = iacStateDONT;
								break;
							default:
								ts->iacState = iacStateNORMAL;
								break;
						}
					}
					break;

				case iacStateWILL:
                                        printf("Will %d\n", c);
                                        ts->left     = usnprintf(ts->outbuf, 4, "%c%c%c%c", cmdCodeIAC, cmdCodeDONT, c, 0);
					ts->iacState = iacStateNORMAL;
					break;
				case iacStateWONT:
                                        printf("Wont %d\n", c);
                                        ts->left     = usnprintf(ts->outbuf, 4, "%c%c%c%c", cmdCodeIAC, cmdCodeDONT, c, 0);
					ts->iacState = iacStateNORMAL;
					break;
				case iacStateDO:
                                        printf("Do %d\n", c);
                                        ts->left     = usnprintf(ts->outbuf, 4, "%c%c%c%c", cmdCodeIAC, cmdCodeWONT, c, 0);
					ts->iacState = iacStateNORMAL;
					break;
				case iacStateDONT:
                                        printf("Dont %d\n", c);
                                        ts->left     = usnprintf(ts->outbuf, 4, "%c%c%c%c", cmdCodeIAC, cmdCodeWONT, c, 0);
					ts->iacState = iacStateNORMAL;
					break;
				case iacStateNORMAL:
					if(c == cmdCodeIAC) {
						ts->iacState = iacStateIAC;
					} else {
						get_char(pcb, ts, c);
					}
					break;
			}
		}



		pbuf_free(p);
	}

	if (err == ERR_OK && p == NULL) {
		printf("remote host closed connection\n");
		close_conn(pcb, ts);
	}

	return ERR_OK;
}


static err_t accept(void *arg, struct tcp_pcb *pcb, err_t err) {
    (void)arg;
    (void)err;

    struct state_t *ts = mem_malloc(sizeof(struct state_t));
    if (ts == NULL) {
  	printf("accept: Out of memory\n");
	return ERR_MEM;
    }

    printf("Accepting connection from %ld.%ld.%ld.%ld\n",
           (pcb->remote_ip.addr >>  0) & 0xff,
           (pcb->remote_ip.addr >>  8) & 0xff,
           (pcb->remote_ip.addr >> 16) & 0xff,
           (pcb->remote_ip.addr >> 24) & 0xff);

    tcp_setprio(pcb, TCP_PRIO_MIN);

    //
    // Register callbacks
    //

    tcp_arg (pcb, ts);
    tcp_recv(pcb, recv);

    //    tcp_err (pcb, error);
    //    tcp_poll(pcb, poll, 4);
    
    //
    // Setup
    //

    ts->cmd_buffer[0] = 0;
    ts->iacState = iacStateNORMAL;
    ts->left = usnprintf(ts->outbuf, sizeof(ts->outbuf),
              "\nWelcome to asdf TELNET.\r\n%s",
              prompt);

    send_data(pcb, ts);

    return ERR_OK;
}

void telnet_init(unsigned int port) {
    struct tcp_pcb *pcb = tcp_new();
    tcp_bind(pcb, IP_ADDR_ANY, port);
    pcb = tcp_listen(pcb);
    tcp_accept(pcb, accept);
}
