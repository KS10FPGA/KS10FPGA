/*!
********************************************************************************
**
** KS10 Console Microcontroller
**
** \brief
**      Linker Script
**
** \file
**      console.ld
**
** \author
**      Rob Doyle - doyle (at) cox (dot) net
**
********************************************************************************
*/
/* Copyright (C) 2013 Rob Doyle
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
********************************************************************************
*/

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x00040000
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00018000
}

SECTIONS
{
    .text :
    {
        _text = .;
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        KEEP (*(.init))
        KEEP (*(.fini))
        . = ALIGN(4);
    } > FLASH

    .preinit_array :    
    {
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array*))
        PROVIDE_HIDDEN (__preinit_array_end = .);
    } > FLASH

    .init_array :
    {
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array*))
        PROVIDE_HIDDEN (__init_array_end = .);
    } > FLASH

    .fini_array :
    {
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(.fini_array*))
        KEEP (*(SORT(.fini_array.*)))
        PROVIDE_HIDDEN (__fini_array_end = .);
    } > FLASH

    _etext = .;

    .data : 
    {
        _data = .;
        *(vtable)
        *(.data*)
        _edata = .;
    } > SRAM AT > FLASH

    .bss :
    {
        _bss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > SRAM

    PROVIDE (end = .);

    /*
     * Really weird things happen when the stack is not aligned to a
     * double-word.
     */

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _stackstart = .;
        . = . + 0x3000;
        _stackend = .;
    } > SRAM
}
