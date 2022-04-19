/* My own version of ctype */

#include "ctype-asm.h"

char ctype[256] = {
  /* 000-007 */  _ISeol, 0, 0, 0, 0, 0, 0, 0,
  /* 010-017 */ _ISblank, _ISblank, _ISeol, _ISblank, _ISblank, _ISblank, 0, 0,
  /* 020-027 */ 0, 0, 0, 0, 0, 0, 0, 0,
  /* 030-037 */ 0, 0, 0, 0, 0, 0, 0, 0,
  /* 040-047 */ _ISblank, 0, 0, 0, _IStoken, _IStoken, 0, 0,
  /* 050-057 */ 0, 0, 0, 0, 0, 0, _IStoken, 0,
  /* 060-067 */ _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal, _IStoken|_ISdigit|_ISoctal,
  /* 070-077 */ _IStoken|_ISdigit, _IStoken|_ISdigit, 0, 0, 0, 0, 0, 0,
  /* 100-107 */ 0, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken,
  /* 110-117 */ _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken,
  /* 120-127 */ _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken,
  /* 130-137 */ _IStoken, _IStoken, _IStoken, 0, 0, 0, 0, _IStoken,
  /* 140-147 */ 0,  _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken,
  /* 150-157 */ _IStoken,  _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken,
  /* 160-167 */ _IStoken,  _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken, _IStoken,
  /* 170-177 */ _IStoken,  _IStoken, _IStoken, 0, 0, 0, 0, 0
};

