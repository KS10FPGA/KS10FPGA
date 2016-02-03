#ifndef __TELNET_H
#define __TELNET_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void * handle_t;
extern handle_t handle23;
extern handle_t handle2000;

handle_t telnet_init(unsigned int port);
void lwip_putchar(handle_t handle, char ch);

#ifdef __cplusplus
}
#endif

#endif
