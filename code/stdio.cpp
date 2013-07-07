//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Embedded Stdio-like functions.
//!
//! This object provides some of the functionality of stdio.
//!
//! \file
//!    stdio.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#include <stdarg.h>
#include <stdint.h>
#include <string.h>

#include "stdio.h"
#include "uart.h"

//! Upper case digits for printing radix greater than 10
static const char *upper_digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

//! Lower case digits for printing radix greater than 10
static const char *lower_digits = "0123456789abcdefghijklmnopqrstuvwxyz";

//
//! This function gets a character from the UART receiver.
//!
//! \returns
//!     Character read from UART receiver.
//!

char getchar(void) {
    return getUART();
}

//
//! This function outputs a character to the UART transmitter.
//!
//! This function expands newlines to CR, LF sequences.
//!
//! \param ch
//!     Character to output to UART transmitter.
//!
//

int putchar(int ch) {
    if (ch == '\n') {
        putUART('\r');
    }
    putUART(ch & 0xff);
    return ch;
}

//
//! Outputs a string to the UART transmitter.
//!
//! This function outputs a string to the UART transmitter.
//!
//! A newline is added which expands newlines to CR, LF sequences.
//!
//! \param s
//!     null terminated string to print.
//!
//! \returns
//!     1 always indicating success
//

int puts(const char *s) {
    while (*s) {
        putchar(*s++);
    }
    putchar('\n');
    return 1;
}

//
//! This function gets a string from the UART receiver.
//!
//! This function buffers a line of characters.  The Backspace is handled.
//!
//! \param [in] buf
//!     buffer to place input characters
//!
//! \param [in] len
//!     buffer length
//!
//! \returns
//!     pointer to buffer.
//

char *fgets(char *buf, unsigned int len) {
    unsigned int i;
    for (i = 0; i < len - 1; ) {
        char ch = getchar();
        switch (ch) {
            case '\r':
                buf[i] = '\0';
                return buf;
            case '\n':
                break;
            case 0x7f:
                if (i > 0) {
                    i -= 1;
                    putchar(ch);
                }
                break;
            default:
                buf[i++] = ch;
                putchar(ch);
        }
    }
    buf[i] = '\0';
    return buf;
}

//
//! Unsigned to ASCII
//!
//! This function converts an unsigned integer value to a null-terminated
//! string using the radix that was specified.  The result is stored in the
//! array given by buffer parameter.
//! 
//! \param [in] value
//!    Value to be printed
//!
//! \param [in, out] buffer
//!    Buffer space for input and output string operations
//!
//! \param [in] radix
//!    Radix of the print operation.  Radix must be between 2 and 36.
//! 
//! \param [in] digits
//!    Pointer to string of either uppercase or lowercase digits
//!
//! \note
//!    This function uses recursion to parse the number.  Beware of stack
//!    space issues.
//!
//! \returns
//!    Pointer to buffer
//

static char *__utoa(unsigned int value, char * buffer, unsigned int radix,
                    const char * digits)  {
    if (value / radix) {
        buffer = __utoa(value / radix, buffer, radix, digits);
    }
    *buffer++ = digits[value % radix];
    *buffer   = 0;
    return buffer;
}

//
//! Unsigned Long to ASCII
//!
//! This function converts an unsigned long integer value to a null-terminated
//! string using the radix that was specified.  The result is stored in the
//! array given by buffer parameter.
//! 
//! \param [in] value
//!    Value to be printed
//!
//! \param [in, out] buffer
//!    Buffer space for input and output string operations
//!
//! \param [in] radix
//!    Radix of the print operation.  Radix must be between 2 and 36.
//! 
//! \param [in] digits
//!    Pointer to string of either uppercase or lowercase digits
//!
//! \note
//!    This function uses recursion to parse the number.  Beware of stack
//!    space issues.
//!
//! \returns
//!    Pointer to buffer
//

static char *__ultoa(unsigned long value, char * buffer, unsigned int radix,
                     const char * digits) {
    if (value / radix) {
        buffer = __ultoa(value / radix, buffer, radix, digits);
    }
    *buffer++ = digits[value % radix];
    *buffer   = 0;
    return buffer;
}

//
//! Unsigned long long to ASCII
//!
//! This function converts an unsigned long long integer value to a null-
//! terminated string using the radix that was specified.  The result is
//! stored in the array given by buffer parameter.
//! 
//! This function is specially hacked to work on only octal and hex numbers.
//! These don't require long long division - just shifts.  The long long
//! division by arbitrary radix requires a lot of support from the run time
//! library and it isn't worth the extra code space since it will not be used.
//!
//! The only support for unsigned long long is octal or hex printing.
//!
//! \param [in] value
//!    Value to be printed
//!
//! \param [in, out] buffer
//!    Buffer space for input and output string operations
//!
//! \param [in] radix
//!    Radix of the print operation.  Radix must be between 2 and 36.
//! 
//! \param [in] digits
//!    Pointer to string of either uppercase or lowercase digits
//!
//! \note
//!    This function uses recursion to parse the number.  Beware of stack
//!    space issues.
//!
//! \returns
//!    Pointer to buffer
//

char *__ulltoa(unsigned long long value, char * buffer, unsigned int radix,
               const char * digits) {
    unsigned int shift;
    unsigned long long mask;
    if (radix == 16) {
        shift = 4;
        mask  = 15ull;
    } else if (radix == 8) {
        shift = 3;
        mask  = 7ull;
    } else {
        strcpy(buffer, "Not implemented");
        return buffer;
    }
    if (value >> shift) {
        buffer = __ulltoa(value >> shift, buffer, radix, digits);
    }
    *buffer++ = digits[value & mask];
    *buffer   = 0;
    return buffer;
}

//
//! Signed Integer to ASCII
//!
//! This function converts an signed integer value to a null-terminated
//! string using the radix that was specified.  The result is stored in the
//! array given by buffer parameter.
//!
//! Negative numbers are printed properly.
//! 
//! \param [in] value
//!    Value to be printed
//!
//! \param [in, out] buffer
//!    Buffer space for input and output string operations
//!
//! \param [in] radix
//!    Radix of the print operation.  Radix must be between 2 and 36.
//! 
//! \note
//!    This function uses recursion to parse the number.  Beware of stack
//!    space issues.
//!
//! \returns
//!    Pointer to buffer
//

char *itoa(int value, char * buffer, int radix) {
    char *bufsav = buffer;

    if (radix < 2 || radix > 36) {
        *buffer = 0;
        return buffer;
    }

    if (radix == 10 && value < 0) {
        value =- value;
        *buffer++ = '-';
    }
    
    __utoa(value, buffer, radix, lower_digits);
    return bufsav;
}

//
//! Signed Long Integer to ASCII
//!
//! This function converts an signed long integer value to a null-terminated
//! string using the radix that was specified.  The result is stored in the
//! array given by buffer parameter.
//!
//! Negative numbers are printed properly.
//! 
//! \param [in] value
//!    Value to be printed
//!
//! \param [in, out] buffer
//!    Buffer space for input and output string operations
//!
//! \param [in] radix
//!    Radix of the print operation.  Radix must be between 2 and 36.
//! 
//! \note
//!    This function uses recursion to parse the number.  Beware of stack
//!    space issues.
//!
//! \returns
//!    Pointer to buffer
//

char *ltoa(long value, char * buffer, int radix) {
    char *bufsav = buffer;
    
    if (radix < 2 || radix > 36) {
        *buffer = 0;
        return buffer;
    }

    if (radix == 10 && value < 0) {
        value =- value;
        *buffer++ = '-';
    }

    __ultoa((unsigned long)value, buffer, radix, lower_digits);
    return bufsav;
}

//
//! Signed Long Long Integer to ASCII
//!
//! This function converts an signed long long integer value to a null-
//! terminated string using the radix that was specified.  The result is
//! stored in the array given by buffer parameter.
//!
//! This function is specially hacked to work on only octal and hex numbers.
//! These don't require long long division - just shifts.  The long long
//! division by arbitrary radix requires a lot of support from the run time
//! library and it isn't worth the extra code space since it will not be used.
//!
//! The only support for signed long long is octal or hex printing.
//! 
//! \param [in] value
//!    Value to be printed
//!
//! \param [in, out] buffer
//!    Buffer space for input and output string operations
//!
//! \param [in] radix
//!    Radix of the print operation.  Radix must be between 2 and 36.
//! 
//! \note
//!    This function uses recursion to parse the number.  Beware of stack
//!    space issues.
//!
//! \returns
//!    Pointer to buffer
//

char *lltoa(long long value, char * buffer, int radix) {
    char *bufsav = buffer;
    
    if (radix < 2 || radix > 36) {
        *buffer = 0;
        return buffer;
    }

    if (radix == 10 && value < 0) {
        value =- value;
        *buffer++ = '-';
    }

    __ulltoa((unsigned long long)value, buffer, radix, lower_digits);
    return bufsav;
}

//
//! Function to pad field sizes to specific widths
//!
//! \param [in] width
//!    Minimum field width.
//!
//! \param [in] prec
//!    Precision.  Not implemented.
//! 
//! \param [in] padchar
//!    Either a zero or a space
//!
//! \param [in] leftFlag
//!    Left justify flag.  Not implemented.
//! 
//! \param [in, out] buffer
//!    Workspace.
//

static void padout(int width, int prec, char padchar, bool leftFlag, char* buffer) {
    (void)prec;
    (void)leftFlag;
    char* p = buffer;
    while (*p++ && width > 0){
        width--;
    }
    while (width-- > 0) { 
        putchar(padchar);
    }
    while (*buffer) {
        putchar(*buffer++);
    }
}

//
//!
//! Print formatted data to stdout
//!
//! The print format string has the following form:
//!   
//!  % [flags] [width] [.precision] [modifier] type
//!   
//!  <dl>
//!      <dt>flags:</dt>
//!          <dd><b>'-'</b> - Left justifies the result by padding with blanks
//!                          on the right. If not supplied, the results are
//!                          right justified by padding with blanks on the
//!                          left.</dd>
//!
//!      <dt>width: (n < 132)</dt>
//!          <dd><b>n</b> -  At least <b>n</b> characters are printed.  If the
//!                          output value has less than <b>n</b> characters,
//!                          the output is padded with blanks.</dd>
//!      <dt></dt>
//!          <dd><b>0n</b> - At least <b>n</b> characters are printed.  If the
//!                          output value has less than <b>n</b> characters,
//!                          the output is padded with zeros.</dd>
//!          
//!      <dt>precision:</dt>
//!          <dd><b>l</b> - arg is interpreted as a long</dd>
//!      <dt></dt>
//!          <dd><b>ll</b> - arg is interpreted as a long long</dd>
//!
//!      <dt>modifier:</dt>
//!          <dd>not implemented (floating point is not implemented)</dd>
//!
//!      <dt>type:</dt>
//!          <dd> <b>%</b> - literal percent</dd>
//!      <dt></dt>
//!          <dd> <b>c</b> - character</dd>
//!      <dt></dt>
//!          <dd> <b>d</b> - signed decimal int</dd>
//!      <dt></dt>
//!          <dd> <b>o</b> - unsigned octal int</dd>
//!      <dt></dt>
//!          <dd> <b>p</b> - pointer</dd>
//!      <dt></dt>
//!          <dd> <b>s</b> - string</dd>
//!      <dt></dt>
//!          <dd> <b>u</b> - unsigned decimal int</dd>
//!      <dt></dt>
//!          <dd> <b>x</b> - unsigned hexadecimal int in lower case</dd>
//!      <dt></dt>
//!          <dd> <b>X</b> - unsigned hexadecimal int in upper case</dd>
//!
//! </dl>
//!
//! \param [in] fmt
//!    format statement.  See above.
//!
//

int printf(const char *fmt, ...)  {
    char buffer[128];
    char *buf = buffer;

    va_list va;
    va_start(va, fmt);

    char ch;

    while ((ch = *fmt++)) {
        if (ch != '%')  {
            putchar(ch);
        } else {
            char padchar  = ' ';
            unsigned int width = 0;
            unsigned int prec  = 0;
            unsigned int size  = 0;
            bool leftFlag = false;

            //
            // Parse modifier
            //

            ch = *fmt++;
            if (ch == '-') {
                leftFlag = true;
                ch = *fmt++;
            }

            //
            // Parse field width
            //

            if (ch == '0') {
                padchar = ch;
                ch = *fmt++;
            }
            while (ch >= '0' && ch <= '9') {
                width = (width * 10) + (ch - '0');
                ch = *fmt++;
            }
            
            //
            // Parse precision
            //
            
            if (ch == '.') {
                ch = *fmt++;
                while (ch >= '0' && ch <= '9') {
                    prec = (prec * 10) + (ch - '0');
                    ch = *fmt++;
                }
            }

            //
            // Parse size modifiers
            //

            if (ch == 'l') {
                ch = *fmt++;
                size = 1;
            }
            if (ch == 'l') {
                ch = *fmt++;
                size = 2;
            }
            
            //
            // Parse conversion type
            //

            switch (ch) {
                case 0: 
                    va_end(va);
                    return 0;
                case 'u' :
                    switch(size) {
                        case 0:
                            __utoa(va_arg(va, unsigned int), buf, 10, lower_digits);
                            break;
                        case 1:
                            __ultoa(va_arg(va, unsigned long), buf, 10, lower_digits);
                            break;
                        case 2:
                            __ulltoa(va_arg(va, unsigned long long), buf, 10, lower_digits);
                            break;
                    }
                    padout(width, prec, padchar, leftFlag, buf);
                    break;
                case 'o' :
                    switch(size) {
                        case 0:
                            __utoa(va_arg(va, unsigned int), buf, 8, lower_digits);
                            break;
                        case 1:
                            __ultoa(va_arg(va, unsigned long), buf, 8, lower_digits);
                            break;
                        case 2:
                            __ulltoa(va_arg(va, unsigned long long), buf, 8, lower_digits);
                            break;
                    }
                    padout(width, prec, padchar, leftFlag, buf);
                    break;
                case 'd' :
                    switch(size) {
                        case 0:
                            itoa(va_arg(va, int), buf, 10);
                            break;
                        case 1:
                            ltoa(va_arg(va, long), buf, 10);
                            break;
                        case 2:
                            lltoa(va_arg(va, long long), buf, 10);
                            break;
                    }
                    padout(width, prec, padchar, leftFlag, buf);
                    break;
                case 'x' :
                    switch(size) {
                        case 0:
                            __utoa(va_arg(va, unsigned int), buf, 16, lower_digits);
                            break;
                        case 1:
                            __ultoa(va_arg(va, unsigned long), buf, 16, lower_digits);
                            break;
                        case 2:
                            __ulltoa(va_arg(va, unsigned long long), buf, 16, lower_digits);
                            break;
                    }
                    padout(width, prec, padchar, leftFlag, buf);
                    break;
                case 'X' : 
                    switch(size) {
                        case 0:
                            __utoa(va_arg(va, unsigned int), buf, 16, upper_digits);
                            break;
                        case 1:
                            __ultoa(va_arg(va, unsigned long), buf, 16, upper_digits);
                            break;
                        case 2:
                            __ulltoa(va_arg(va, unsigned long long), buf, 16, upper_digits);
                            break;
                    }
                    padout(width, prec, padchar, leftFlag, buf);
                    break;
                case 'c' : 
                    putchar((char)(va_arg(va, int)));
                    break;
                case 's' : 
                    padout(width, prec, 0, leftFlag, va_arg(va, char*));
                    break;
                case '%' :
                    putchar(ch);
                default:
                    break;
            }
        }
    }
    va_end(va);
    return 0;
}
