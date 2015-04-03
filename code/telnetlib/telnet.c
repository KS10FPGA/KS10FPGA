#include <stdio.h>
#include <string.h>

#include "lwiplib.h"
#include "stdio.h"
#include "telnet.h"
#include "ustdlib.h"
#include "lwip/stats.h"
#include "lwip/tcp.h"

//
// min() macro
//

#define min(a, b) ({ \
    __typeof__ (a) _a = (a); \
    __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; \
})

enum iacState_t {
    iacStateNORMAL = 0,
    iacStateIAC    = 1,
    iacStateWILL   = 2,
    iacStateWONT   = 3,
    iacStateDO     = 4,
    iacStateDONT   = 5,
};

struct state_t {
    unsigned int    magic;
    char            outbuf[133];
    char            inbuf[133];
    u16_t           left;
    struct tcp_pcb *pcb;
    enum iacState_t iacState;
};

static const char *prompt = "\r\niSendIR telnet >";
static const unsigned int magic = 0xb0bace4d;

void lwip_putchar(handle_t handle, char ch) {
    struct state_t *ts = (struct state_t *)handle;

    if (ts->magic == magic) {
        err_t err = tcp_write(ts->pcb, &ch, sizeof(ch), TCP_WRITE_FLAG_COPY);
        if (err != ERR_OK) {
            printf("lwip_putchar() returned %d\n", err);
            return;
        }
    }
}

static void close_conn(struct state_t *ts) {
    tcp_arg(ts->pcb, NULL);
    tcp_sent(ts->pcb, NULL);
    tcp_recv(ts->pcb, NULL);
    tcp_close(ts->pcb);
    mem_free(ts);
}

static void cmd_parser(struct state_t *ts) {

    if (strncmp(ts->inbuf, "quit", 5) == 0) {
        ts->left = 0;
        printf("Closing connection\n");
        close_conn(ts);
        return;
    }
    ts->left = usnprintf(ts->outbuf, sizeof(ts->outbuf),
                         "\r\nThis is TELNET echoing your command : \"%s\"\r\n%s",
                         ts->inbuf, prompt);
    ts->inbuf[0] = 0;
}

static void send_data(struct state_t *ts) {

    u16_t bytesSent = 0;
    struct tcp_pcb *pcb = ts->pcb;

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

static void get_char(struct state_t *ts, char c) {
    int l;
    switch(c) {
        case '\r':
            return;
        case '\n':
            cmd_parser(ts);
            if (ts->left > 0) {
                send_data(ts);
            }
            break;
        default:
            l = strlen(ts->inbuf);
            ts->inbuf[l++] = c;
            ts->inbuf[l] = 0;
            break;
    }
}

static err_t recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err) {
    char *q;
    int len;

    enum cmdCode_t {
        cmdCodeWILL = 251,
        cmdCodeWONT = 252,
        cmdCodeDO   = 253,
        cmdCodeDONT = 254,
        cmdCodeIAC  = 255,
    };

    struct state_t *ts = (struct state_t *)arg;

    if (err == ERR_OK && p != NULL) {

        tcp_recved(pcb, p->tot_len);

        q = (char*)p->payload;
        len = p->tot_len;

        while(len > 0) {
            char c = *q++;
            --len;

            switch (ts->iacState) {
                case iacStateIAC:
                    if (c == cmdCodeIAC) {
                        get_char(ts, c);
                        ts->iacState = iacStateNORMAL;
                    } else {
                        switch (c) {
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
                    if (c == cmdCodeIAC) {
                        ts->iacState = iacStateIAC;
                    } else {
                        get_char(ts, c);
                    }
                    break;
            }
        }
        pbuf_free(p);
    }

    if (err == ERR_OK && p == NULL) {
        printf("remote host closed connection\n");
        close_conn(ts);
    }

    return ERR_OK;
}

static err_t accept(void *arg, struct tcp_pcb *pcb, err_t err) {

    (void)err;
    struct state_t *ts = (struct state_t *)arg;

    printf("Accepting connection from %ld.%ld.%ld.%ld\n",
           (pcb->remote_ip.addr >>  0) & 0xff,
           (pcb->remote_ip.addr >>  8) & 0xff,
           (pcb->remote_ip.addr >> 16) & 0xff,
           (pcb->remote_ip.addr >> 24) & 0xff);

    tcp_setprio(pcb, TCP_PRIO_MIN);

    //
    // Register callbacks
    //

   tcp_recv(pcb, recv);

    //
    // Initialize local data
    //

    ts->magic = magic;
    ts->pcb = pcb;
    ts->inbuf[0] = 0;
    ts->iacState = iacStateNORMAL;
    ts->left = usnprintf(ts->outbuf, sizeof(ts->outbuf),
              "\nKS10 Telnet Interface\r\n%s",
              prompt);

    send_data(ts);
    return ERR_OK;
}

handle_t telnet_init(unsigned int port) {
    struct state_t *ts = mem_malloc(sizeof(struct state_t));
    if (ts == NULL) {
        printf("accept: Out of memory\n");
        return ts;
    }

    struct tcp_pcb *pcb = tcp_new();
    tcp_arg(pcb, ts);
    tcp_bind(pcb, IP_ADDR_ANY, port);
    pcb = tcp_listen(pcb);
    tcp_accept(pcb, accept);
    return ts;
}
