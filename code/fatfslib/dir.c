//
//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! FATFS Directory Command
//!
//! This function generates a directory listing.
//!
//! \file
//!     dir.c
//!
//! \author
//!     Rob Doyle - doyle (at) cox (dot) net
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

#include <string.h>

#include "ff.h"
#include "dir.h"
#include "../stdio.h"

//
// The directory format for windows is :
//
// 05/17/2013  08:37 AM    <DIR>          fffffff 
// 04/25/2013  09:45 AM             x,xxx fffffff.fff
// 07/11/2012  08:31 PM             x,xxx fffff.fff
// 06/26/2013  08:47 AM    <DIR>          ffffffff
// 06/29/2013  11:18 PM    <DIR>          ffffffff
// 07/01/2013  05:34 PM    <DIR>          ffffffff
// 05/17/2013  08:37 AM    <DIR>          ffffffff
//
//
//! Perform a directory of SD Card
//!
//! This function prints a directory of the SD Card.
//!
//! \param arg
//!     Pathname argument
//!
//! \returns
//!     <b>FRESULT</b> of last file of directory operation.  If everything
//!     went correctly <b>FRESULT</b> is <b>FR_OK</b>.
//

FRESULT directory(const char* arg) {
    char path[128];
    strcpy(path, arg);

    DIR dir;
    FRESULT res = f_opendir(&dir, path);
    if (res == FR_OK) {
        for (;;) {
            FILINFO filinfo;
            res = f_readdir(&dir, &filinfo); 
            if (res != FR_OK || filinfo.fname[0] == 0) {
                break;
            }
            printf("%02d/%02d/%4d  %02d:%02d %cM   %s %8d %s%s%s\n",
                   ((filinfo.fdate >>  5) & 0x0f),                      // Month
                   ((filinfo.fdate >>  0) & 0x1f),                      // Day
                   ((filinfo.fdate >>  9) & 0x7f) + 1980,               // Year
                   ((filinfo.ftime >> 11) & 0x1f) % 12,                 // Hour
                   ((filinfo.ftime >>  5) & 0x3f),                      // Minute
                   ((filinfo.ftime >> 11) & 0x1f) > 12 ? 'P' : 'A',     // AM/PM
                   ((filinfo.fattrib & AM_DIR) ? "<DIR>" : "     "),    // Attrib
                   filinfo.fsize,                                       // Size
                   (*path == 0) ? path : path + 1,                      // Pathname
                   (*path == 0) ? "" : "/",                             // /
                   filinfo.fname);                                      // Filename
            if (filinfo.fattrib & AM_DIR) {
                int i = strlen(path);
                strncat(path, "/", 1);
                strncat(path, filinfo.fname, 12);
                res = directory(path);
                path[i] = 0;
                if (res != FR_OK) {
                    break;
                }
            }
        }
    }
    return res;
}
