//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Simple PDP10 Disassembler
//!
//!
//! \file
//!    dasm.cpp
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


#include "dasm.hpp"
#include "stdio.h"

static const char* opSTD(const char *opcode, char *buf, unsigned long long insn) {

    char *ptr = buf;
    unsigned int len = 0;

    unsigned int op = (insn >> 27) &    0777;
    unsigned int ac = (insn >> 23) &     017;
    unsigned int in = (insn >> 22) &       1;
    unsigned int xr = (insn >> 18) &     017;
    unsigned int ea = (insn >>  0) & 0777777;

    //
    // Print instruction
    //

    len += sprintf(&ptr[len], "%03o %02o %01o %02o %06o\t", op, ac, in, xr, ea);

    //
    // Print opcode
    //

    len += sprintf(&ptr[len], "%s\t", opcode);

    //
    // Optionally print AC
    //

    if (ac != 0) {
        len += sprintf(&ptr[len], "%o,", ac);
    }

    //
    // Optionally print indirect
    //

    if (in != 0) {
        len += sprintf(&ptr[len], "@");
    }

    //
    // Optionally print EA
    //

    if (ac != 0 || in != 0 || xr != 0 || ea != 0) {

        if (ea & 0400000) {
            len += sprintf(&ptr[len], "-%o", (~ea + 1) & 0377777);
        } else {
            len += sprintf(&ptr[len], "%o", ea);
        }
    }

    //
    // Optionally print XR
    //

    if (xr != 0) {
        len += sprintf(&ptr[len], "(%o)", xr);
    }

    return buf;
}

static const char* opIOT(const char *, char *buf, unsigned long long insn) {

    static const char* table[] = {
        "APRID",        // 70000
        "70004",        // 70004
        "70010",        // 70010
        "70014",        // 70014
        "WRAPR",        // 70020
        "RDAPR",        // 70034
        "70030",        // 70030
        "70034",        // 70034
        "70040",        // 70040
        "70044",        // 70044
        "70050",        // 70050
        "70054",        // 70054
        "WRPI",         // 70060
        "RDPI",         // 70064
        "70070",        // 70070
        "70014",        // 70074
        "70100",        // 70100
        "RDUBR",        // 70104
        "CLRPT",        // 70110
        "WRUBR",        // 70114
        "WREBR",        // 70120
        "RDEBR",        // 70124
        "70130",        // 70130
        "70134",        // 70134
        "70140",        // 70140
        "70144",        // 70144
        "70150",        // 70150
        "70154",        // 70154
        "70160",        // 70160
        "70164",        // 70164
        "70170",        // 70170
        "70174",        // 70174
        "RDSPB",        // 70200
        "RDCSB",        // 70204
        "RDPUR",        // 70210
        "RDCSTM",       // 70214
        "RDTIM",        // 70220
        "RDINT",        // 70224
        "RDHSB",        // 70230
        "70234",        // 70234
        "WRSPB",        // 70240
        "WRCSB",        // 70244
        "WRPUR",        // 70250
        "WRCSTM",       // 70254
        "WRTIM",        // 70260
        "WRINT",        // 70264
        "WRHSB",        // 70270
        "70274",        // 70274
    };

    char *ptr = buf;
    unsigned int len = 0;

    unsigned int op = (insn >> 27) &    0777;
    unsigned int ac = (insn >> 23) &     017;
    unsigned int in = (insn >> 22) &       1;
    unsigned int xr = (insn >> 18) &     017;
    unsigned int ea = (insn >>  0) & 0777777;
    unsigned int f  = (insn >> 23) &     077;

    //
    // Print instruction
    //

    len += sprintf(&ptr[len], "%03o %02o %01o %02o %06o\t", op, ac, in, xr, ea);

    //
    // Print opcode
    //

    len += sprintf(&ptr[len], "%s\t", table[f]);

    //
    // Optionally print indirect
    //

    if (in != 0) {
        len += sprintf(&ptr[len], "@");
    }

    //
    // Optionally print EA
    //

    if (in != 0 || xr != 0 || ea != 0) {
        len += sprintf(&ptr[len], "%o", ea);
    }

    //
    // Optionally print XR
    //

    if (xr != 0) {
        len += sprintf(&ptr[len], "(%o)", xr);
    }

    return buf;

}


static const char* opJRST(const char *, char *buf, unsigned long long insn) {

    static const char* table[] = {
        "JRST",         // 00
        "PORTAL",       // 01 (same as JRST for KS10)
        "JRSTF",        // 02
        "INVALID",      // 03 (UUO)
        "HALT",         // 04
        "XJRSTF",       // 05
        "XJEN",         // 06
        "XPCW",         // 07
        "INVALID",      // 10 (UUO)
        "INVALID",      // 11 (UUO)
        "JEN",          // 12
        "INVALID",      // 13 (UUO)
        "SFM",          // 14
        "INVALID",      // 15 (UUO)
        "INVALID",      // 16 (UUO)
        "INVALID",      // 17 (UUO)
    };

    char *ptr = buf;
    unsigned int len = 0;

    unsigned int op = (insn >> 27) &    0777;
    unsigned int ac = (insn >> 23) &     017;
    unsigned int in = (insn >> 22) &       1;
    unsigned int xr = (insn >> 18) &     017;
    unsigned int ea = (insn >>  0) & 0777777;

    //
    // Print instruction
    //

    len += sprintf(&ptr[len], "%03o %02o %01o %02o %06o\t", op, ac, in, xr, ea);

    //
    // Print opcode
    //

    len += sprintf(&ptr[len], "%s\t", table[ac]);

    //
    // Optionally print indirect
    //

    if (in != 0) {
        len += sprintf(&ptr[len], "@");
    }

    //
    // Optionally print EA
    //

    if (in != 0 || xr != 0 || ea != 0) {
        len += sprintf(&ptr[len], "%o", ea);
    }
    //
    // Optionally print XR
    //

    if (xr != 0) {
        len += sprintf(&ptr[len], "(%o)", xr);
    }

    return buf;
}

const char* dasm(unsigned long long insn) {

    static char buffer[32];

    static const struct {
        const char *opcode;
        const char *(*fun)(const char* name, char *buf, unsigned long long arg);
    } table[01000] = {

        {"UUO",    opSTD},         // 000
        {"SJCL",   opSTD},         // 001
        {"SJCE",   opSTD},         // 002
        {"SJCLE",  opSTD},         // 003
        {"EDIT",   opSTD},         // 004
        {"SJCGE",  opSTD},         // 005
        {"SJCN",   opSTD},         // 006
        {"SJCG",   opSTD},         // 007

        {"CVTDBO", opSTD},         // 010
        {"CVTDBT", opSTD},         // 011
        {"CVTBDO", opSTD},         // 012
        {"CVTBDT", opSTD},         // 013
        {"MOVSO",  opSTD},         // 014
        {"MOVST",  opSTD},         // 015
        {"MOVSLJ", opSTD},         // 016
        {"MOVSRJ", opSTD},         // 017

        {"XBLT",   opSTD},         // 020
        {"LUUO21", opSTD},         // 021  GSNGL
        {"LUUO22", opSTD},         // 022  GDBLE
        {"LUUO23", opSTD},         // 023  GDFIX
        {"LUUO24", opSTD},         // 024  GFIX
        {"LUUO25", opSTD},         // 025  GDFIXR
        {"LUUO26", opSTD},         // 026  GFIXR
        {"LUUO27", opSTD},         // 027  DGFLTR

        {"LUUO30", opSTD},         // 030  GFLTR
        {"LUUO31", opSTD},         // 031
        {"LUUO32", opSTD},         // 032
        {"LUUO33", opSTD},         // 033
        {"LUUO34", opSTD},         // 034
        {"LUUO35", opSTD},         // 035
        {"LUUO36", opSTD},         // 036
        {"LUUO37", opSTD},         // 037

        {"MUUO30", opSTD},         // 040  CALL
        {"MUUO31", opSTD},         // 041  INIT
        {"MUUO32", opSTD},         // 042
        {"MUUO23", opSTD},         // 043
        {"MUUO24", opSTD},         // 044
        {"MUUO25", opSTD},         // 045
        {"MUUO26", opSTD},         // 046
        {"MUUO27", opSTD},         // 047  CALLU

        {"MUUO50", opSTD},         // 050  OPEN
        {"MLUU51", opSTD},         // 051  TTCALL
        {"MUUO52", opSTD},         // 052
        {"MUUO53", opSTD},         // 053
        {"MUUO54", opSTD},         // 054
        {"MUUO55", opSTD},         // 055  RENAME
        {"MUUO56", opSTD},         // 056  IN
        {"MUUO57", opSTD},         // 057  OUT

        {"MUUO60", opSTD},         // 060  SETSTS
        {"MUUO61", opSTD},         // 061  STATO
        {"MUUO62", opSTD},         // 062  GETSTS
        {"MUUO63", opSTD},         // 063  STATZ
        {"MUUO64", opSTD},         // 064  INBUF
        {"MUUO65", opSTD},         // 065  OUTBUF
        {"MUUO66", opSTD},         // 066  INPUT
        {"MUUO67", opSTD},         // 067  OUTPUT

        {"LUUO00", opSTD},         // 070  CLOSE
        {"LUUO21", opSTD},         // 071  RELEAS
        {"LUUO22", opSTD},         // 072  MTAPE
        {"LUUO23", opSTD},         // 073  UGETF
        {"LUUO24", opSTD},         // 074  USETI
        {"LUUO25", opSTD},         // 075  USETO
        {"LUUO26", opSTD},         // 076  LOOKUP
        {"LUUO27", opSTD},         // 077  ENTER

        {"UJEN",   opSTD},         // 100
        {"UUO101", opSTD},         // 101
        {"UUO102", opSTD},         // 102  GFAD
        {"UUO103", opSTD},         // 103  GFSB
        {"JSYS",   opSTD},         // 104
        {"ADJSP",  opSTD},         // 105
        {"UUO106", opSTD},         // 106  GFMP
        {"UUO107", opSTD},         // 107  GFDV

        {"DFAD",   opSTD},         // 110
        {"DFSB",   opSTD},         // 111
        {"DFMP",   opSTD},         // 112
        {"DFDV",   opSTD},         // 113
        {"DADD",   opSTD},         // 114
        {"DSUB",   opSTD},         // 115
        {"DMUL",   opSTD},         // 116
        {"DDIV",   opSTD},         // 117

        {"DMOVE",  opSTD},         // 120
        {"DMOVN",  opSTD},         // 121
        {"FIX",    opSTD},         // 122
        {"EXTEND", opSTD},         // 123
        {"DMOVEM", opSTD},         // 124
        {"DMOVNM", opSTD},         // 125
        {"FIXR",   opSTD},         // 126
        {"FLTR",   opSTD},         // 127

        {"UFA",    opSTD},         // 130
        {"DFN",    opSTD},         // 131
        {"FSC",    opSTD},         // 132
        {"IBP",    opSTD},         // 133
        {"ILDB",   opSTD},         // 134
        {"LDB",    opSTD},         // 135
        {"IDPB",   opSTD},         // 136
        {"DPB",    opSTD},         // 137

        {"FAD",    opSTD},         // 140
        {"FADL",   opSTD},         // 141
        {"FADM",   opSTD},         // 142
        {"FADB",   opSTD},         // 143
        {"FADRI",  opSTD},         // 144
        {"FADRL",  opSTD},         // 145
        {"FADRM",  opSTD},         // 146
        {"FADRB",  opSTD},         // 147

        {"FSB",    opSTD},         // 150
        {"FSBL",   opSTD},         // 151
        {"FSBM",   opSTD},         // 152
        {"FSBB",   opSTD},         // 153
        {"FSBRI",  opSTD},         // 154
        {"FSBRL",  opSTD},         // 155
        {"FSBRM",  opSTD},         // 156
        {"FSBRB",  opSTD},         // 157

        {"FMP",    opSTD},         // 160
        {"FMPL",   opSTD},         // 161
        {"FMPM",   opSTD},         // 162
        {"FMPB",   opSTD},         // 163
        {"FMPRI",  opSTD},         // 164
        {"FMPRL",  opSTD},         // 165
        {"FMPRM",  opSTD},         // 166
        {"FMPRB",  opSTD},         // 167

        {"FDV",    opSTD},         // 170
        {"FDVL",   opSTD},         // 171
        {"FDVM",   opSTD},         // 172
        {"FDVB",   opSTD},         // 173
        {"FDVRI",  opSTD},         // 174
        {"FDVRL",  opSTD},         // 175
        {"FDVRM",  opSTD},         // 176
        {"FDVRB",  opSTD},         // 177

        {"MOVE",   opSTD},         // 200
        {"MOVEI",  opSTD},         // 201
        {"MOVEM",  opSTD},         // 202
        {"MOVES",  opSTD},         // 203
        {"MOVS",   opSTD},         // 204
        {"MOVSI",  opSTD},         // 205
        {"MOVSM",  opSTD},         // 206
        {"MOVSS",  opSTD},         // 207

        {"MOVN",   opSTD},         // 210
        {"MOVNI",  opSTD},         // 211
        {"MOVNM",  opSTD},         // 212
        {"MOVNS",  opSTD},         // 213
        {"MOVM",   opSTD},         // 214
        {"MOVMI",  opSTD},         // 215
        {"MOVMM",  opSTD},         // 216
        {"MOVMS",  opSTD},         // 217

        {"IMUL",   opSTD},         // 220
        {"IMULI",  opSTD},         // 221
        {"IMULM",  opSTD},         // 222
        {"IMULB",  opSTD},         // 223
        {"MUL",    opSTD},         // 224
        {"MULI",   opSTD},         // 225
        {"MULM",   opSTD},         // 226
        {"MULB",   opSTD},         // 227

        {"IDIV",   opSTD},         // 230
        {"IDIVI",  opSTD},         // 231
        {"IDIVM",  opSTD},         // 232
        {"IDIVB",  opSTD},         // 233
        {"DIV",    opSTD},         // 234
        {"DIVI",   opSTD},         // 235
        {"DIVM",   opSTD},         // 236
        {"DIVB",   opSTD},         // 237

        {"ASH",    opSTD},         // 240
        {"ROT",    opSTD},         // 241
        {"LSH",    opSTD},         // 242
        {"JFFO",   opSTD},         // 243
        {"ASHC",   opSTD},         // 244
        {"ROTC",   opSTD},         // 245
        {"LSHC",   opSTD},         // 246
        {"UUO247", opSTD},         // 247

        {"EXCH",   opSTD},         // 250
        {"BLT",    opSTD},         // 251
        {"AOBJP",  opSTD},         // 252
        {"AOBJN",  opSTD},         // 253
        {"JRST",   opJRST},        // 254
        {"JFCL",   opSTD},         // 255
        {"XCT",    opSTD},         // 256
        {"MAP",    opSTD},         // 257

        {"PUSHJ",  opSTD},         // 260
        {"PUSH",   opSTD},         // 261
        {"POP",    opSTD},         // 262
        {"POPJ",   opSTD},         // 263
        {"JSR",    opSTD},         // 264
        {"JSP",    opSTD},         // 265
        {"JSA",    opSTD},         // 266
        {"JRA",    opSTD},         // 267

        {"ADD",    opSTD},         // 270
        {"ADDI",   opSTD},         // 271
        {"ADDM",   opSTD},         // 272
        {"ADDB",   opSTD},         // 273
        {"SUB",    opSTD},         // 274
        {"SUBI",   opSTD},         // 275
        {"SUBM",   opSTD},         // 276
        {"SUBB",   opSTD},         // 277

        {"CAI",    opSTD},         // 270
        {"CAIL",   opSTD},         // 301
        {"CAIE",   opSTD},         // 302
        {"CAILE",  opSTD},         // 303
        {"CAIA",   opSTD},         // 304
        {"CAIGE",  opSTD},         // 305
        {"CAIN",   opSTD},         // 306
        {"CAIG",   opSTD},         // 307

        {"CAM",    opSTD},         // 310
        {"CAML",   opSTD},         // 311
        {"CAME",   opSTD},         // 312
        {"CAMLE",  opSTD},         // 313
        {"CAMA",   opSTD},         // 314
        {"CAMGE",  opSTD},         // 315
        {"CAMN",   opSTD},         // 316
        {"CAMG",   opSTD},         // 317

        {"JUMP",   opSTD},         // 320
        {"JUMPL",  opSTD},         // 321
        {"JUMPE",  opSTD},         // 322
        {"JUMPLE", opSTD},         // 323
        {"JUMPA",  opSTD},         // 324
        {"JUMPGE", opSTD},         // 325
        {"JUMPN",  opSTD},         // 326
        {"JUMPG",  opSTD},         // 327

        {"SKIP",   opSTD},         // 330
        {"SKIPL",  opSTD},         // 331
        {"SKIPE",  opSTD},         // 332
        {"SKIPLE", opSTD},         // 333
        {"SKIPA",  opSTD},         // 334
        {"SKIPGE", opSTD},         // 335
        {"SKIPN",  opSTD},         // 336
        {"SKIPG",  opSTD},         // 337

        {"AOJ",    opSTD},         // 340
        {"AOJL",   opSTD},         // 341
        {"AOJE",   opSTD},         // 342
        {"AOJLE",  opSTD},         // 343
        {"AOJA",   opSTD},         // 344
        {"AOJGE",  opSTD},         // 345
        {"AOJN",   opSTD},         // 346
        {"AOJG",   opSTD},         // 347

        {"AOS",    opSTD},         // 350
        {"AOSL",   opSTD},         // 351
        {"AOSE",   opSTD},         // 352
        {"AOSLE",  opSTD},         // 353
        {"AOSA",   opSTD},         // 354
        {"AOSGE",  opSTD},         // 355
        {"AOSN",   opSTD},         // 356
        {"AOSG",   opSTD},         // 357

        {"SOJ",    opSTD},         // 360
        {"SOJL",   opSTD},         // 361
        {"SOJE",   opSTD},         // 362
        {"SOJLE",  opSTD},         // 363
        {"SOJA",   opSTD},         // 364
        {"SOJGE",  opSTD},         // 365
        {"SOJN",   opSTD},         // 366
        {"SOJG",   opSTD},         // 367

        {"SOS",    opSTD},         // 370
        {"SOSL",   opSTD},         // 371
        {"SOSE",   opSTD},         // 372
        {"SOSLE",  opSTD},         // 373
        {"SOSA",   opSTD},         // 374
        {"SOSGE",  opSTD},         // 375
        {"SOSN",   opSTD},         // 376
        {"SOSG",   opSTD},         // 377

        {"SETZ",   opSTD},         // 400
        {"SETZI",  opSTD},         // 401
        {"SETZM",  opSTD},         // 402
        {"SETZB",  opSTD},         // 403
        {"AND",    opSTD},         // 404
        {"ANDI",   opSTD},         // 405
        {"ANDM",   opSTD},         // 406
        {"ANDB",   opSTD},         // 407

        {"ANDCA",  opSTD},         // 410
        {"ANDCAI", opSTD},         // 411
        {"ANDCAM", opSTD},         // 412
        {"ANDCAB", opSTD},         // 413
        {"SETM",   opSTD},         // 414
        {"SETMI",  opSTD},         // 415
        {"SETMM",  opSTD},         // 416
        {"SETMB",  opSTD},         // 417

        {"ANDCM",  opSTD},         // 420
        {"ANDCMI", opSTD},         // 421
        {"ANDCMM", opSTD},         // 422
        {"ANDCMB", opSTD},         // 423
        {"SETA",   opSTD},         // 424
        {"SETAI",  opSTD},         // 425
        {"SETAM",  opSTD},         // 426
        {"SETAB",  opSTD},         // 427

        {"XOR",    opSTD},         // 430
        {"XORI",   opSTD},         // 431
        {"XORM",   opSTD},         // 432
        {"XORB",   opSTD},         // 433
        {"OR",     opSTD},         // 434
        {"ORI",    opSTD},         // 435
        {"ORM",    opSTD},         // 436
        {"ORB",    opSTD},         // 437

        {"ANDCB",  opSTD},         // 440
        {"ANDCBI", opSTD},         // 441
        {"ANDCBM", opSTD},         // 442
        {"ANDCBB", opSTD},         // 443
        {"EQV",    opSTD},         // 444
        {"EQVI",   opSTD},         // 445
        {"EQVM",   opSTD},         // 446
        {"EQVB",   opSTD},         // 447

        {"SETCA",  opSTD},         // 450
        {"SETCAI", opSTD},         // 451
        {"SETCAM", opSTD},         // 452
        {"SETCAB", opSTD},         // 453
        {"ORCA",   opSTD},         // 454
        {"ORCAI",  opSTD},         // 455
        {"ORCAM",  opSTD},         // 456
        {"ORCAB",  opSTD},         // 457

        {"SETCM",  opSTD},         // 460
        {"SETCMI", opSTD},         // 461
        {"SETCMM", opSTD},         // 462
        {"SETCMB", opSTD},         // 463
        {"ORCM",   opSTD},         // 464
        {"ORCMI",  opSTD},         // 465
        {"ORCMM",  opSTD},         // 466
        {"ORCMB",  opSTD},         // 467

        {"ORCB",   opSTD},         // 470
        {"ORCBI",  opSTD},         // 471
        {"ORCBM",  opSTD},         // 472
        {"ORCBB",  opSTD},         // 473
        {"SETO",   opSTD},         // 474
        {"SETOI",  opSTD},         // 475
        {"SETOM",  opSTD},         // 476
        {"SETOB",  opSTD},         // 477

        {"HLL",    opSTD},         // 500
        {"HLLI",   opSTD},         // 501
        {"HLLM",   opSTD},         // 502
        {"HLLS",   opSTD},         // 503
        {"HRL",    opSTD},         // 504
        {"HRLI",   opSTD},         // 505
        {"HRLM",   opSTD},         // 506
        {"HRLS",   opSTD},         // 507

        {"HLLZ",   opSTD},         // 510
        {"HLLZI",  opSTD},         // 511
        {"HLLZM",  opSTD},         // 512
        {"HLLZS",  opSTD},         // 513
        {"HRLZ",   opSTD},         // 514
        {"HRLZI",  opSTD},         // 515
        {"HRLZM",  opSTD},         // 516
        {"HRLZS",  opSTD},         // 517

        {"HLLO",   opSTD},         // 520
        {"HLLOI",  opSTD},         // 521
        {"HLLOM",  opSTD},         // 522
        {"HLLOS",  opSTD},         // 523
        {"HRLO",   opSTD},         // 524
        {"HRLOI",  opSTD},         // 525
        {"HRLOM",  opSTD},         // 526
        {"HRLOS",  opSTD},         // 527

        {"HLLE",   opSTD},         // 530
        {"HLLEI",  opSTD},         // 531
        {"HLLEM",  opSTD},         // 532
        {"HLLES",  opSTD},         // 533
        {"HRLE",   opSTD},         // 534
        {"HRLEI",  opSTD},         // 535
        {"HRLEM",  opSTD},         // 536
        {"HRLES",  opSTD},         // 537

        {"HRR",    opSTD},         // 540
        {"HRRI",   opSTD},         // 541
        {"HRRM",   opSTD},         // 542
        {"HRRS",   opSTD},         // 543
        {"HLR",    opSTD},         // 544
        {"HLRI",   opSTD},         // 545
        {"HLRM",   opSTD},         // 546
        {"HLRS",   opSTD},         // 547

        {"HRRZ",   opSTD},         // 550
        {"HRRZI",  opSTD},         // 551
        {"HRRZM",  opSTD},         // 552
        {"HRRZS",  opSTD},         // 553
        {"HLRZ",   opSTD},         // 554
        {"HLRZI",  opSTD},         // 555
        {"HLRZM",  opSTD},         // 556
        {"HLRZS",  opSTD},         // 557

        {"HRRO",   opSTD},         // 560
        {"HRROI",  opSTD},         // 561
        {"HRROM",  opSTD},         // 562
        {"HRROS",  opSTD},         // 563
        {"HLRO",   opSTD},         // 564
        {"HLROI",  opSTD},         // 565
        {"HLROM",  opSTD},         // 566
        {"HLROS",  opSTD},         // 567

        {"HRRE",   opSTD},         // 570
        {"HRREI",  opSTD},         // 571
        {"HRREM",  opSTD},         // 572
        {"HRRES",  opSTD},         // 573
        {"HLRE",   opSTD},         // 574
        {"HLREI",  opSTD},         // 575
        {"HLREM",  opSTD},         // 576
        {"HLRES",  opSTD},         // 577

        {"TRN",    opSTD},         // 600
        {"TLN",    opSTD},         // 601
        {"TRNE",   opSTD},         // 602
        {"TLNE",   opSTD},         // 603
        {"TRNA",   opSTD},         // 604
        {"TLNA",   opSTD},         // 605
        {"TRNN",   opSTD},         // 606
        {"TLNN",   opSTD},         // 607

        {"TDN",    opSTD},         // 610
        {"TSN",    opSTD},         // 611
        {"TDNE",   opSTD},         // 612
        {"TSNE",   opSTD},         // 613
        {"TDNA",   opSTD},         // 614
        {"TSNA",   opSTD},         // 615
        {"TDNN",   opSTD},         // 616
        {"TSNN",   opSTD},         // 617

        {"TRZ",    opSTD},         // 620
        {"TLZ",    opSTD},         // 621
        {"TRZE",   opSTD},         // 622
        {"TLZE",   opSTD},         // 623
        {"TRZA",   opSTD},         // 624
        {"TLZA",   opSTD},         // 625
        {"TRZN",   opSTD},         // 626
        {"TLZN",   opSTD},         // 627

        {"TDZ",    opSTD},         // 630
        {"TSZ",    opSTD},         // 631
        {"TDZE",   opSTD},         // 632
        {"TSZE",   opSTD},         // 633
        {"TDZA",   opSTD},         // 634
        {"TSZA",   opSTD},         // 635
        {"TDZN",   opSTD},         // 636
        {"TSZN",   opSTD},         // 637

        {"TRC",    opSTD},         // 640
        {"TLC",    opSTD},         // 641
        {"TRCE",   opSTD},         // 642
        {"TLCE",   opSTD},         // 643
        {"TRCA",   opSTD},         // 644
        {"TLCA",   opSTD},         // 645
        {"TRCN",   opSTD},         // 646
        {"TLCN",   opSTD},         // 647

        {"TDC",    opSTD},         // 650
        {"TSC",    opSTD},         // 651
        {"TDCE",   opSTD},         // 652
        {"TSCE",   opSTD},         // 653
        {"TDCA",   opSTD},         // 654
        {"TSCA",   opSTD},         // 655
        {"TDCN",   opSTD},         // 656
        {"TSCN",   opSTD},         // 657

        {"TRO",    opSTD},         // 660
        {"TLO",    opSTD},         // 661
        {"TROE",   opSTD},         // 662
        {"TLOE",   opSTD},         // 663
        {"TROA",   opSTD},         // 664
        {"TLOA",   opSTD},         // 665
        {"TRON",   opSTD},         // 666
        {"TLON",   opSTD},         // 667

        {"TDO",    opSTD},         // 670
        {"TSO",    opSTD},         // 671
        {"TDOE",   opSTD},         // 672
        {"TSOE",   opSTD},         // 673
        {"TDOA",   opSTD},         // 674
        {"TSOA",   opSTD},         // 675
        {"TDON",   opSTD},         // 676
        {"TSON",   opSTD},         // 677

        {"700",    opIOT},         // 700  APRID, WRAPR, RDAPR, WRPI, RDPI
        {"701",    opIOT},         // 701  RDUBR, CLRPT, WRUBR, WREBR, RDEBR
        {"702",    opIOT},         // 702  RDSPB, RDCSB, RDPUR, RDCSTM, RDTIM, RDINT, RDHSB
        {"IOT703", opSTD},         // 703
        {"UMOVE",  opSTD},         // 704
        {"UMOVEM", opSTD},         // 705
        {"IOT706", opSTD},         // 706
        {"IOT707", opSTD},         // 707

        {"TIOE",   opSTD},         // 710
        {"TION",   opSTD},         // 711
        {"RDIO",   opSTD},         // 712
        {"WRIO",   opSTD},         // 713
        {"BSIO",   opSTD},         // 714
        {"BCIO",   opSTD},         // 715
        {"IOT716", opSTD},         // 716
        {"IOT717", opSTD},         // 717

        {"TIOEB",  opSTD},         // 720
        {"TIONB",  opSTD},         // 721
        {"RDIOB",  opSTD},         // 722
        {"WRIOB",  opSTD},         // 723
        {"BSIOB",  opSTD},         // 724
        {"BCIOB",  opSTD},         // 725
        {"IOT726", opSTD},         // 726
        {"IOT727", opSTD},         // 727

        {"IOT730", opSTD},         // 730
        {"IOT731", opSTD},         // 731
        {"IOT732", opSTD},         // 732
        {"IOT733", opSTD},         // 733
        {"OT7434", opSTD},         // 734
        {"IOT735", opSTD},         // 735
        {"IOT736", opSTD},         // 736
        {"IOT737", opSTD},         // 737

        {"IOT740", opSTD},         // 740
        {"IOT741", opSTD},         // 741
        {"IOT742", opSTD},         // 742
        {"IOT743", opSTD},         // 743
        {"IOT744", opSTD},         // 744
        {"IOT745", opSTD},         // 745
        {"IOT746", opSTD},         // 746
        {"IOT747", opSTD},         // 747

        {"IOT750", opSTD},         // 750
        {"IOT751", opSTD},         // 751
        {"IOT752", opSTD},         // 752
        {"IOT753", opSTD},         // 753
        {"IOT754", opSTD},         // 754
        {"IOT755", opSTD},         // 755
        {"IOT756", opSTD},         // 756
        {"IOT757", opSTD},         // 757

        {"IOT760", opSTD},         // 760
        {"IOT761", opSTD},         // 761
        {"IOT762", opSTD},         // 762
        {"IOT763", opSTD},         // 763
        {"IOT764", opSTD},         // 764
        {"IOT765", opSTD},         // 765
        {"IOT766", opSTD},         // 766
        {"IOT767", opSTD},         // 767

        {"UUO770", opSTD},         // 770
        {"UUO771", opSTD},         // 771
        {"UUO772", opSTD},         // 772
        {"UUO773", opSTD},         // 773
        {"UUO774", opSTD},         // 774
        {"UUO775", opSTD},         // 775
        {"UUO776", opSTD},         // 776
        {"UUO777", opSTD},         // 777
    };

    unsigned int op = (insn >> 27) & 0777;
    return (table[op].fun)(table[op].opcode, buffer, insn);

}
