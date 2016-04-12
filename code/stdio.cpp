//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Embedded Stdio-like functions.
//!
//! \details
//!    This object provides some of the functionality of stdio.
//!
//! \file
//!    stdio.cpp
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

#include <stdarg.h>
#include <stdint.h>
#include <string.h>

#include "stdio.h"
#include "uart.h"

#include "telnetlib/telnet_task.hpp"

//! Upper case digits for printing radix greater than 10
static const char *upper_digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

//! Lower case digits for printing radix greater than 10
static const char *lower_digits = "0123456789abcdefghijklmnopqrstuvwxyz";

//!
//! \brief
//!    This function gets a character from the UART receiver.
//!
//! \returns
//!    Character read from UART receiver.
//!

int getchar(void) {
    return getUART();
}

//!
//! \brief
//!    This function outputs a character to the UART transmitter.
//!
//! \details
//!    This function expands newlines to CR, LF sequences.
//!
//! \param ch -
//!    Character to output to UART transmitter.
//!

#if 0

static char linbuf[133];
static int count = 0;

int putchar(int ch) {
    if (ch == '\n') {
        putUART('\r');
        linbuf[count++] = 0;
        telnet23->puts(linbuf);
        count = 0;
    }
    linbuf[count++] = ch & 0xff;
    putUART(ch & 0xff);
    return ch;
}

#else

int putchar(int ch) {
    if (ch == '\n') {
        putUART('\r');
    }
    putUART(ch & 0xff);
    return ch;
}

#endif

//!
//! \brief
//!    Outputs a string to the UART transmitter.
//!
//! \details
//!    This function outputs a string to the UART transmitter.
//!
//!    A newline is added which expands newlines to CR, LF sequences.
//!
//! \param s
//!     null terminated string to print.
//!
//! \returns
//!     1 always indicating success
//!

int puts(const char *s) {
    while (*s) {
        putchar(*s++);
    }
    putchar('\n');
    return 1;
}

//!
//! \brief
//!    Unsigned Long to ASCII
//!
//! \details
//!    This function converts an unsigned long integer value to a null-
//!    terminated string using the radix that was specified.  The result is
//!    stored in the array given by buffer parameter.
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
//!

static char *ultoa(unsigned long value, char * buffer, unsigned int radix, const char * digits) {
    if (value / radix) {
        buffer = ultoa(value / radix, buffer, radix, digits);
    }
    *buffer++ = digits[value % radix];
    *buffer   = 0;
    return buffer;
}

//!
//! \brief
//!    Unsigned long long to ASCII
//!
//! \details
//!    This function converts an unsigned long long integer value to a null-
//!    terminated string using the radix that was specified.  The result is
//!    stored in the array given by buffer parameter.
//!
//!    This function is specially hacked to work on only octal and hex numbers.
//!    These don't require long long division - just shifts.  The long long
//!    division by arbitrary radix requires a lot of support from the run time
//!    library and it isn't worth the extra code space since it will not be
//!    used.
//!
//!    The only support for unsigned long long is octal or hex printing.
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
//!

char *ulltoa(unsigned long long value, char * buffer, unsigned int radix, const char * digits) {
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
        buffer = ulltoa(value >> shift, buffer, radix, digits);
    }
    *buffer++ = digits[value & mask];
    *buffer   = 0;
    return buffer;
}

//!
//! \brief
//!    Signed Long Integer to ASCII
//!
//! \details
//!    This function converts an signed long integer value to a null-terminated
//!    string using the radix that was specified.  The result is stored in the
//!    array given by buffer parameter.
//!
//!    Negative numbers are printed properly.
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
//!

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

    ultoa((unsigned long)value, buffer, radix, lower_digits);
    return bufsav;
}

//!
//! \brief
//!    Signed Long Long Integer to ASCII
//!
//! \details
//!    This function converts an signed long long integer value to a null-
//!    terminated string using the radix that was specified.  The result is
//!    stored in the array given by buffer parameter.
//!
//!    This function is specially hacked to work on only octal and hex numbers.
//!    These don't require long long division - just shifts.  The long long
//!    division by arbitrary radix requires a lot of support from the run time
//!    library and it isn't worth the extra code space since it will not be
//!    used.
//!
//!    The only support for signed long long is octal or hex printing.
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
//!

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

    ulltoa((unsigned long long)value, buffer, radix, lower_digits);
    return bufsav;
}

//!
//! \brief
//!    Function to pad field sizes to specific widths
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
//! \param [in, out] src
//!    String to print
//!

static void chrout(int width, int prec, char padchar, bool leftFlag, char* src) {
    (void)prec;
    (void)leftFlag;
    char* p = src;
    while (*p++ && width > 0){
        width--;
    }
    while (width-- > 0) {
        putchar(padchar);
    }
    while (*src) {
        putchar(*src++);
    }
}

//!
//! \brief
//!    Function to pad field sizes to specific widths
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
//! \param [in, out] dest
//!    Destination
//!
//! \param [in, out] src
//!    Source
//!
//! \returns
//!    pointer to destination after update
//!

static int strout(int width, int prec, char padchar, bool leftFlag, char*& dest, char *src) {
    (void)prec;
    (void)leftFlag;
    int ret = 0;

    //
    // src length
    //

    char* p = src;
    while (*p++ && width > 0){
        width--;
    }

    while (width-- > 0) {
        *dest++ = padchar;
        ret++;
    }

    while (*src) {
        if (*src == '\t') printf("[TAB]");
        *dest++ = *src++;
        ret++;
    }
    return ret;
}

//
//!
//! \brief
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

int printf(const char *fmt, ...) {
    char temp[128];
    int ret = 0;

    va_list ap;
    va_start(ap, fmt);

    char ch;

    while ((ch = *fmt++)) {
        if (ch != '%')  {
            putchar(ch);
        } else {
            char padchar  = ' ';
            unsigned int width = 0;
            unsigned int prec  = 0;
            unsigned int type  = 0;
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
            // Parse type modifiers
            //

            if (ch == 'l') {
                ch = *fmt++;
                type = 1;
            }
            if (ch == 'l') {
                ch = *fmt++;
                type = 2;
            }

            //
            // Parse conversion type
            //

            switch (ch) {
                case 0:
                    va_end(ap);
                    return ret;
                case 'u' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 10, lower_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 10, lower_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 10, lower_digits);
                            break;
                    }
                    chrout(width, prec, padchar, leftFlag, temp);
                    break;
                case 'd' :
                    switch (type) {
                        case 0:
                            ltoa(va_arg(ap, int), temp, 10);
                            break;
                        case 1:
                            ltoa(va_arg(ap, long), temp, 10);
                            break;
                        case 2:
                            lltoa(va_arg(ap, long long), temp, 10);
                            break;
                    }
                    chrout(width, prec, padchar, leftFlag, temp);
                    break;
                case 'o' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 8, lower_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 8, lower_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 8, lower_digits);
                            break;
                    }
                    chrout(width, prec, padchar, leftFlag, temp);
                    break;
                case 'x' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 16, lower_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 16, lower_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 16, lower_digits);
                            break;
                    }
                    chrout(width, prec, padchar, leftFlag, temp);
                    break;
                case 'X' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 16, upper_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 16, upper_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 16, upper_digits);
                            break;
                    }
                    chrout(width, prec, padchar, leftFlag, temp);
                    break;
                case 'c' :
                    putchar((char)(va_arg(ap, int)));
                    break;
                case 's' :
                    chrout(width, prec, 0, leftFlag, va_arg(ap, char*));
                    break;
                case '%' :
                    putchar(ch);
                default:
                    break;
            }
        }
    }
    va_end(ap);
    return ret;
}

//!
//! \brief
//!    Low level printer function
//!
//! \param buf -
//!    pointer to buffer where the output goes
//!
//! \param size  -
//!    size of the buffer
//!
//! \param fmt -
//!    format string
//!
//! \param ap -
//!    variable length argument list
//!
//! \returns
//!    number of characters that were printed
//!

int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap) {

    int ret = 0;
    char temp[80];

    if (size > 0) {
        size -= 1;
    }

    char ch;
    while ((ch = *fmt++)) {
        if (ch != '%')  {
            *buf++ = ch;
            ret += 1;
        } else {
            char padchar  = ' ';
            unsigned int width = 0;
            unsigned int prec  = 0;
            unsigned int type  = 0;
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
            // Parse type modifiers
            //

            if (ch == 'l') {
                ch = *fmt++;
                type = 1;
            }
            if (ch == 'l') {
                ch = *fmt++;
                type = 2;
            }

            //
            // Parse conversion type
            //

            switch (ch) {
                case 0:
                    return ret;
                case 'u' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 10, lower_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 10, lower_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 10, lower_digits);
                            break;
                    }
                    ret += strout(width, prec, padchar, leftFlag, buf, temp);
                    break;
                case 'd' :
                    switch (type) {
                        case 0:
                            lltoa(va_arg(ap, int), temp, 10);
                            break;
                        case 1:
                            lltoa(va_arg(ap, long), temp, 10);
                            break;
                        case 2:
                            lltoa(va_arg(ap, long long), temp, 10);
                            break;
                    }
                    ret += strout(width, prec, padchar, leftFlag, buf, temp);
                    break;
                case 'o' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 8, lower_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 8, lower_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 8, lower_digits);
                            break;
                    }
                    ret += strout(width, prec, padchar, leftFlag, buf, temp);
                    break;
                case 'x' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 16, lower_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 16, lower_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 16, lower_digits);
                            break;
                    }
                    ret += strout(width, prec, padchar, leftFlag, buf, temp);
                    break;
                case 'X' :
                    switch (type) {
                        case 0:
                            ultoa(va_arg(ap, unsigned int), temp, 16, upper_digits);
                            break;
                        case 1:
                            ultoa(va_arg(ap, unsigned long), temp, 16, upper_digits);
                            break;
                        case 2:
                            ulltoa(va_arg(ap, unsigned long long), temp, 16, upper_digits);
                            break;
                    }
                    ret += strout(width, prec, padchar, leftFlag, buf, temp);
                    break;
                case 'c' :
                    *buf++ = (char)(va_arg(ap, int));
                    ret += 1;
                    break;
                case 's' :
                    ret += strout(width, prec, 0, leftFlag, buf, va_arg(ap, char*));
                    break;
                case '%' :
                    *buf++ = ch;
                    ret += 1;
                    break;
                default:
                    break;
            }
        }
    }
    *buf++ = 0;
    return ret;
}

int sprintf(char *buf, const char *fmt, ...) {

    va_list ap;
    va_start(ap, fmt);

    int ret = vsnprintf(buf, size_t(~0), fmt, ap);

    va_end(ap);
    return ret;
}

int snprintf(char *buf, size_t size, const char *fmt, ...) {

    va_list ap;
    va_start(ap, fmt);

    int ret = vsnprintf(buf, size, fmt, ap);

    va_end(ap);
    return ret;
}
