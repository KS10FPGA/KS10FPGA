
/* Just a list of the PDP-10 opcode names in numberic order. */
char *opcode_names[] = {
  /* Monitor UUOs and Local UUOs */
  "luuo00",  "luuo01",  "luuo02",  "luuo03",  "luuo04",  "luuo05",  "luuo06",  "luuo07",
  "luuo10",  "luuo11",  "luuo12",  "luuo13",  "luuo14",  "luuo15",  "luuo16",  "luuo17",
  "luuo20",  "luuo21",  "luuo22",  "luuo23",  "luuo24",  "luuo25",  "luuo26",  "luuo27",
  "luuo30",  "luuo31",  "luuo32",  "luuo33",  "luuo34",  "luuo35",  "luuo36",  "luuo37",
  "call",    "initi",   "muuo42",  "muuo43",  "muuo44",  "muuo45",  "muuo46",  "calli",
  "open",    "ttcall",  "muuo52",  "muuo53",  "muuo54",  "rename",  "in",      "out",
  "setsts",  "stato",   "status",  "getsts",  "inbuf",   "outbuf",  "input",   "output",
  "close",   "releas",  "mtape",   "ugetf",   "useti",   "useto",   "lookup",  "enter",

  /* Floating Point, Byte Manipulation, Other */
  "ujen",    "unk101",  "gfad",    "gfsb",    "jsys",    "adjsp",   "gfmp",    "gfdv",
  "dfad",    "dfsb",    "dfmp",    "dfdv",    "dadd",    "dsub",    "dmul",    "ddiv",
  "dmove",   "dmovn",   "fix",     "extend",  "dmovem",  "dmovnm",  "fixr",    "fltr",
  "ufa",     "dfn",     "fsc",     "ibp",     "ildb",    "ldb",     "idpb",    "dpb",
  "fad",     "fadl",    "fadm",    "fadb",    "fadr",    "fadrl",   "fadrm",   "fadrb",
  "fsb",     "fsbl",    "fsbm",    "fsbb",    "fsbr",    "fsbrl",   "fsbrm",   "fsbrb",
  "fmp",     "fmpl",    "fmpm",    "fmpb",    "fmpr",    "fmprl",   "fmprm",   "fmprb",
  "fdv",     "fdvl",    "fdvm",    "fdvb",    "fdvr",    "fdvrl",   "fdvrm",   "fdvrb",

  /* Integer Arithmetic, Jump To Subroutine */
  "move",    "movei",   "movem",   "moves",   "movs",    "movsi",   "movsm",   "movss",
  "movn",    "movni",   "movnm",   "movns",   "movm",    "movmi",   "movmm",   "movms",
  "imul",    "imuli",   "imulm",   "imulb",   "mul",     "muli",    "mulm",    "mulb",
  "idiv",    "idivi",   "idivm",   "idivb",   "div",     "divi",    "divm",    "divb",
  "ash",     "rot",     "lsh",     "jffo",    "ashc",    "rotc",    "lshc",    "circ",
  "exch",    "blt",     "aobjp",   "aobjn",   "jrst",    "jfcl",    "xct",     "map",
  "pushj",   "push",    "pop",     "popj",    "jsr",     "jsp",     "jsa",     "jra",
  "add",     "addi",    "addm",    "addb",    "sub",     "subi",    "subm",    "subb",

  /* Hop, Skip, and Jump (codes 3_0 do not skip or jump) */
  "cai",     "cail",    "caie",    "caile",   "caia",    "caige",   "cain",    "caig",
  "cam",     "caml",    "came",    "camle",   "cama",    "camge",   "camn",    "camg",
  "jump",    "jumpl",   "jumpe",   "jumple",  "jumpa",   "jumpge",  "jumpn",   "jumpg",
  "skip",    "skipl",   "skipe",   "skiple",  "skipa",   "skipge",  "skipn",   "skipg",
  "aoj",     "aojl",    "aoje",    "aojle",   "aoja",    "aojge",   "aojn",    "aojg",
  "aos",     "aosl",    "aose",    "aosle",   "aosa",    "aosge",   "aosn",    "aosg",
  "soj",     "sojl",    "soje",    "sojle",   "soja",    "sojge",   "sojn",    "sojg",
  "sos",     "sosl",    "sose",    "sosle",   "sosa",    "sosge",   "sosn",    "sosg",

  /* Two-argument Logical Operations */
  "setz",    "setzi",   "setzm",   "setzb",   "and",     "andi",    "andm",    "andb",
  "andca",   "andcai",  "andcam",  "andcab",  "setm",    "xmovei",  "setmm",   "setmb",
  "andcm",   "andcmi",  "andcmm",  "andcmb",  "seta",    "setai",   "setam",   "setab",
  "xor",     "xori",    "xorm",    "xorb",    "or",      "ori",     "orm",     "orb",
  "andcb",   "andcbi",  "andcbm",  "andcbb",  "eqv",     "eqvi",    "eqvm",    "eqvb",
  "setca",   "setcai",  "setcam",  "setcab",  "orca",    "orcai",   "orcam",   "orcab",
  "setcm",   "setcmi",  "setcmm",  "setcmb",  "orcm",    "orcmi",   "orcmm",   "orcmb",
  "orcb",    "orcbi",   "orcbm",   "orcbb",   "seto",    "setoi",   "setom",   "setob",

  /* Half Word {Left,Right} to {Left,Right} with {nochange,Zero,Ones,Extend}, {ac,Immediate,Memory,Self} */
  "hll",     "xhlli",   "hllm",    "hlls",    "hrl",     "hrli",    "hrlm",    "hrls",
  "hllz",    "hllzi",   "hllzm",   "hllzs",   "hrlz",    "hrlzi",   "hrlzm",   "hrlzs",
  "hllo",    "hlloi",   "hllom",   "hllos",   "hrlo",    "hrloi",   "hrlom",   "hrlos",
  "hlle",    "hllei",   "hllem",   "hlles",   "hrle",    "hrlei",   "hrlem",   "hrles",
  "hrr",     "hrri",    "hrrm",    "hrrs",    "hlr",     "hlri",    "hlrm",    "hlrs",
  "hrrz",    "hrrzi",   "hrrzm",   "hrrzs",   "hlrz",    "hlrzi",   "hlrzm",   "hlrzs",
  "hrro",    "hrroi",   "hrrom",   "hrros",   "hlro",    "hlroi",   "hlrom",   "hlros",
  "hrre",    "hrrei",   "hrrem",   "hrres",   "hlre",    "hlrei",   "hlrem",   "hlres",

  /* Test bits, {Right,Left,Direct,Swapped} with
     {Nochange,Zero,Complement,One} and skip if the masked bits were
     {noskip,Equal,Nonzero,Always} */
  "trn",     "tln",     "trne",    "tlne",    "trna",    "tlna",    "trnn",    "tlnn",
  "tdn",     "tsn",     "tdne",    "tsne",    "tdna",    "tsna",    "tdnn",    "tsnn",
  "trz",     "tlz",     "trze",    "tlze",    "trza",    "tlza",    "trzn",    "tlzn",
  "tdz",     "tsz",     "tdze",    "tsze",    "tdza",    "tsza",    "tdzn",    "tszn",
  "trc",     "tlc",     "trce",    "tlce",    "trca",    "tlca",    "trcn",    "tlcn",
  "tdc",     "tsc",     "tdce",    "tsce",    "tdca",    "tsca",    "tdcn",    "tscn",
  "tro",     "tlo",     "troe",    "tloe",    "troa",    "tloa",    "tron",    "tlon",
  "tdo",     "tso",     "tdoe",    "tsoe",    "tdoa",    "tsoa",    "tdon",    "tson",

#define KS10
#ifdef KS10

  "OP700",  "OP701",  "OP702",  "IOT703", "UMOVE",  "UMOVEM", "IOT706", "IOT707",
  "TIOE",   "TION",   "RDIO",   "WRIO",   "BSIO",   "BCIO",   "IOT716", "IOT717",
  "TIOEB",  "TIONB",  "RDIOB",  "WRIOB",  "BSIOB",  "BCIOB",  "IOT726", "IOT727",
  "IOT730", "IOT731", "IOT732", "IOT733", "IOT734", "IOT735", "IOT736", "IOT737",
  "IOT740", "IOT741", "IOT742", "IOT743", "IOT744", "IOT745", "IOT746", "IOT747",
  "IOT750", "IOT751", "IOT752", "IOT753", "IOT754", "IOT755", "IOT756", "IOT757",
  "IOT760", "IOT761", "IOT762", "IOT763", "IOT764", "IOT765", "IOT766", "IOT767",
  "UUO770", "UUO771", "UUO772", "UUO773", "UUO774", "UUO775", "UUO776", "UUO777",

#endif

};

/* I/O Opcodes 700-777
 * Bits 0-2 = "111", bits 3-9 = I/O device address, bits 10-12 = opcode
 * 7__    op      description
 * 700000         BLKI    Block Input, skip if I/O not finished
 * 700040         DATAI   Data Input, from device to memory
 * 700100         BLKO    Block Output, skip if I/O not finished
 * 700140         DATAO   Data Output, from memory to device
 * 700200         CONO    Conditions Out, 36 bits AC to device
 * 700240         CONI    Conditions in, 36 bits device to AC
 * 700300         CONSZ   Conditions, Skip if Zero (test 18 bits)
 * 700340         CONSO   Conditions, Skip if One (test 18 bits)
 */

unsigned int opcode_lookup(char *op)
{
  char **cp;
  unsigned int opcode;

  for (cp = opcode_names, opcode = 0;
       opcode < sizeof(opcode_names)/sizeof(char *);
       cp++, opcode++) {
    if (strcasecmp(op, *cp) == 0)
      return opcode;
  }
  return -1;
}
