; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 1
; 								Table of Contents					

; 1		CRAM4K.MIC[1,2]	13:05 16-APR-2015
; 13		KS10.MIC[1,2]	11:18 17-APR-2015
; 71	REVISION HISTORY
; 198	HOW TO READ THE MICROCODE
; 403	CONDITIONAL ASSEMBLY DEFINITIONS
; 469	2901 REGISTER USAGE
; 505	MICROCODE FIELDS -- LISTING FORMAT
; 553	MICROCODE FIELDS -- DATAPATH CHIP
; 705	MICROCODE FIELDS -- RAM FILE ADDRESS AND D-BUS
; 739	MICROCODE FIELDS -- PARITY GENERATION & HALF WORD CONTROL
; 762	MICROCODE FIELDS -- SPEC
; 865	MICROCODE FIELDS -- DISPATCH
; 909	MICROCODE FIELDS -- SKIP
; 960	MICROCODE FIELDS -- TIME CONTROL
; 980	MICROCODE FIELDS -- RANDOM CONTROL BITS
; 1002	MICROCODE FIELDS -- NUMBER FIELD
; 1346	DISPATCH ROM DEFINITIONS
; 1392	HOW TO READ MACROS
; 1551	MACROS -- DATA PATH CHIP -- GENERAL
; 1701	MACROS -- DATA PATH CHIP -- Q
; 1736	MACROS -- DATA PATH CHIP -- MISC.
; 1757	MACROS -- STORE IN AC
; 1789	MACROS -- MICROCODE WORK SPACE
; 1816	MACROS -- MEMORY CONTROL
; 1866	MACROS -- VMA
; 1883	MACROS -- TIME CONTROL
; 1896	MACROS -- SCAD, SC, FE LOGIC
; 1979	MACROS -- DATA PATH FIELD CONTROL
; 1995	MACROS -- SHIFT PATH CONTROL
; 2008	MACROS -- SPECIAL FUNCTIONS
; 2039	MACROS -- PC FLAGS
; 2068	MACROS -- PAGE FAIL FLAGS
; 2076	MACROS -- SINGLE SKIPS
; 2101	MACROS -- SPECIAL DISPATCH MACROS
; 2135	DISPATCH ROM MACROS
; 2176		SIMPLE.MIC[1,2]	16:49 11-NOV-1985
; 2178	POWER UP SEQUENCE
; 2260	THE INSTRUCTION LOOP -- START NEXT INSTRUCTION
; 2384	THE INSTRUCTION LOOP -- FETCH ARGUMENTS
; 2496	THE INSTRUCTION LOOP -- STORE ANSWERS
; 2580	MOVE GROUP
; 2617	EXCH
; 2632	HALFWORD GROUP
; 2799	DMOVE, DMOVN, DMOVEM, DMOVNM
; 2830	BOOLEAN GROUP
; 2985	ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO
; 3081	ROTATES AND LOGICAL SHIFTS -- LSHC
; 3116	ROTATES AND LOGICAL SHIFTS -- ASHC
; 3155	ROTATES AND LOGICAL SHIFTS -- ROTC
; 3187	TEST GROUP
; 3339	COMPARE -- CAI, CAM
; 3408	ARITHMETIC SKIPS -- AOS, SOS, SKIP
; 3458	CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ
; 3549	AC DECODE JUMPS -- JRST, JFCL
; 3639	EXTENDED ADDRESSING INSTRUCTIONS
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 2
; 								Table of Contents					

; 3680	XCT
; 3702	STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ
; 3799	STACK INSTRUCTIONS -- ADJSP
; 3832	SUBROUTINE CALL/RETURN -- JSR, JSP, JSA, JRA
; 3887	ILLEGAL INSTRUCTIONS AND UUO'S
; 4086	ARITHMETIC -- ADD, SUB
; 4115	ARITHMETIC -- DADD, DSUB
; 4148	ARITHMETIC -- MUL, IMUL
; 4199	ARITHMETIC -- DMUL
; 4340	ARITHMETIC -- DIV, IDIV
; 4417	ARITHMETIC -- DDIV
; 4538	ARITHMETIC -- DIVIDE SUBROUTINE
; 4603	ARITHMETIC -- DOUBLE DIVIDE SUBROUTINE
; 4643	ARITHMETIC -- SUBROUTINES FOR ARITHMETIC
; 4689	BYTE GROUP -- IBP, ILDB, LDB, IDPB, DPB
; 4766	BYTE GROUP -- INCREMENT BYTE POINTER SUBROUTINE
; 4779	BYTE GROUP -- BYTE EFFECTIVE ADDRESS EVALUATOR
; 4813	BYTE GROUP -- LOAD BYTE SUBROUTINE
; 4866	BYTE GROUP -- DEPOSIT BYTE IN MEMORY
; 4954	BYTE GROUP -- ADJUST BYTE POINTER
; 5113	BLT
; 5221	UBABLT - BLT BYTES TO/FROM UNIBUS FORMAT
; 5295		FLT.MIC[1,2]	01:46 20-MAR-1981
; 5296	FLOATING POINT -- FAD, FSB
; 5341	FLAOTING POINT -- FMP
; 5370	FLOATING POINT -- FDV
; 5420	FLOATING POINT -- FLTR, FSC
; 5455	FLOATING POINT -- FIX AND FIXR
; 5492	FLOATING POINT -- SINGLE PRECISION NORMALIZE
; 5559	FLOATING POINT -- ROUND ANSWER
; 5570	FLOATING POINT -- DFAD, DFSB
; 5659	FLOATING POINT -- DFMP
; 5720	FLOATING POINT -- DFDV
; 5774	FLOATING POINT -- DOUBLE PRECISION NORMALIZE
; 5884		EXTEND.MIC[1,2]	11:35 26-JULY-1984
; 5885	EXTEND -- DISPATCH ROM ENTRIES
; 5940	EXTEND -- INSTRUCTION SET DECODING
; 5982	EXTEND -- MOVE STRING -- SETUP
; 6027	EXTEND -- MOVE STRING -- OFFSET/TRANSLATE
; 6058	EXTEND -- MOVE STRING -- MOVSRJ
; 6106	EXTEND -- MOVE STRING -- SIMPLE MOVE LOOP
; 6130	EXTEND -- COMPARE STRING
; 6191	EXTEND -- DECIMAL TO BINARY CONVERSION
; 6323	EXTEND -- BINARY TO DECIMAL CONVERSION
; 6481	EXTEND -- EDIT -- MAIN LOOP
; 6535	EXTEND -- EDIT -- DECODE OPERATE GROUP
; 6554	EXTEND -- EDIT -- STOP EDIT
; 6569	EXTEND -- EDIT -- START SIGNIFICANCE
; 6576	EXTEND -- EDIT -- EXCHANGE MARK AND DESTINATION
; 6587	EXTEND -- EDIT -- PROCESS SOURCE BYTE
; 6650	EXTEND -- EDIT -- MESSAGE BYTE
; 6673	EXTEND -- EDIT -- SKIP
; 6687	EXTEND -- EDIT -- ADVANCE PATTERN POINTER
; 6720	EXTEND SUBROUTINES -- FILL OUT DESTINATION
; 6744	EXTEND SUBROUTINES -- GET MODIFIED SOURCE BYTE
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 3
; 								Table of Contents					

; 6781	EXTEND SUBROUTINES -- TRANSLATE
; 6867	EXTEND SUBROUTINES -- GET UNMODIFIED SOURCE BYTE
; 6896	EXTEND SUBROUTINES -- STORE BYTE IN DESTINATION STRING
; 6917	EXTEND SUBROUTINES -- UPDATE DEST STRING POINTERS
; 6961	EXTEND -- PAGE FAIL CLEANUP
; 7000		INOUT.MIC[1,2]	13:32 7-JAN-1986
; 7001	TRAPS
; 7032	IO -- INTERNAL DEVICES
; 7143	IO -- INTERNAL DEVICES -- EBR & UBR
; 7269	IO -- INTERNAL DEVICES -- KL PAGING REGISTERS
; 7311	IO -- INTERNAL DEVICES -- TIMER CONTROL
; 7342	IO -- INTERNAL DEVICES -- WRTIME & RDTIME
; 7381	IO -- INTERNAL DEVICES -- WRINT & RDINT
; 7395	IO -- INTERNAL DEVICES -- RDPI & WRPI
; 7435	IO -- INTERNAL DEVICES -- SUBROUTINES
; 7576	PRIORITY INTERRUPTS -- DISMISS SUBROUTINE
; 7591	EXTERNAL IO INSTRUCTIONS
; 7779	SMALL SUBROUTINES
; 7803	UNDEFINED IO INSTRUCTIONS
; 7884	UMOVE AND UMOVEM
; 7939	WRITE HALT STATUS BLOCK
; 8031		PAGEF.MIC[1,2]	11:16 17-APR-2015
; 8033	PAGE FAIL REFIL LOGIC
;	Cross Reference Index
;	DCODE Location / Line Number Index
;	UCODE Location / Line Number Index
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 4
; CRAM4K.MIC[1,2]	13:05 16-APR-2015				CRAM4K.MIC[1,2]	13:05 16-APR-2015		

							; 1	
							; 2	;KS10 MICROCODE PARAMETER FILE
							; 3	
							; 4	;PARAMETER FILE DEFINITIONS FOR CRAM4K
							; 5	;4K RAM ADDRESS SPACE ALLOWS ALL OPTIONS
							; 6	;INCLUDES KL AND KI PAGING
							; 7	
							; 8	.SET/CRAM4K=1	; USE ALL 4K OF CRAM ADDRESS SPACE
							; 9	.SET/UBABLT=1	; SUPPORT UBABLT INSTRUCTIONS
							; 10	.SET/INHCST=1	; ALLOW INHIBIT OF CST UPDATE IF CSB = 0
							; 11	
							; 12	.BIN
							; 13	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 5
; KS10.MIC[1,2]	11:18 17-APR-2015					CRAM4K.MIC[1,2]	13:05 16-APR-2015		

							; 14		.NOBIN
							; 15	
							; 16	.TITLE	"KS10 MICROCODE V2A(130), 15-APR-2015"
							; 17	
							; 18	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 19	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 20	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 21	;;;                                                           ;;;
							; 22	;;;                                                           ;;;
							; 23	;;;     COPYRIGHT (C) 1976,1977,1978,1979,1980,1981,1982,     ;;;
							; 24	;;;			1984,1985,1986			      ;;;
							; 25	;;;	  DIGITAL EQUIPMENT CORP., MAYNARD, MASS.             ;;;
							; 26	;;;                                                           ;;;
							; 27	;;;     THIS SOFTWARE IS FURNISHED UNDER A LICENSE  FOR  USE  ;;;
							; 28	;;;     ONLY  ON  A SINGLE COMPUTER SYSTEM AND MAY BE COPIED  ;;;
							; 29	;;;     ONLY WITH  THE  INCLUSION  OF  THE  ABOVE  COPYRIGHT  ;;;
							; 30	;;;     NOTICE.  THIS SOFTWARE, OR ANY OTHER COPIES THEREOF,  ;;;
							; 31	;;;     MAY NOT BE PROVIDED OR OTHERWISE MADE  AVAILABLE  TO  ;;;
							; 32	;;;     ANY  OTHER  PERSON EXCEPT FOR USE ON SUCH SYSTEM AND  ;;;
							; 33	;;;     TO ONE WHO AGREES TO THESE LICENSE TERMS.  TITLE  TO  ;;;
							; 34	;;;     AND  OWNERSHIP  OF  THE  SOFTWARE SHALL AT ALL TIMES  ;;;
							; 35	;;;     REMAIN IN DEC.                                        ;;;
							; 36	;;;                                                           ;;;
							; 37	;;;     THE INFORMATION  IN  THIS  DOCUMENT  IS  SUBJECT  TO  ;;;
							; 38	;;;     CHANGE WITHOUT NOTICE AND SHOULD NOT BE CONSTRUED AS  ;;;
							; 39	;;;     A COMMITMENT BY DIGITAL EQUIPMENT CORPORATION.        ;;;
							; 40	;;;                                                           ;;;
							; 41	;;;     DEC  ASSUMES  NO  RESPONSIBILITY  FOR  THE  USE   OR  ;;;
							; 42	;;;     RELIABILITY  OF  ITS  SOFTWARE IN EQUIPMENT WHICH IS  ;;;
							; 43	;;;     NOT SUPPLIED BY DEC.                                  ;;;
							; 44	;;;                                                           ;;;
							; 45	;;;     DESIGNED AND WRITTEN BY:                              ;;;
							; 46	;;;             DONALD A. LEWINE                              ;;;
							; 47	;;;             DIGITAL EQUIPMENT CORP.                       ;;;
							; 48	;;;             MARLBORO, MASS.                               ;;;
							; 49	;;;             MR1-2/E47  X6430                              ;;;
							; 50	;;;                                                           ;;;
							; 51	;;;     MAINTAINED AND ENHANCED BY:                           ;;;
							; 52	;;;             DONALD D. DOSSA				      ;;;
							; 53	;;;             DIGITAL EQUIPMENT CORP.                       ;;;
							; 54	;;;             MARLBORO, MASS.                               ;;;
							; 55	;;;             MR1-2/E18  DTN 231-4138                       ;;;
							; 56	;;;                                                           ;;;
							; 57	;;;             SEAN KEENAN				      ;;;
							; 58	;;;             DIGITAL EQUIPMENT CORP.                       ;;;
							; 59	;;;             MARLBORO, MASS.                               ;;;
							; 60	;;;             MR1-2/E18  DTN 231-4463                       ;;;
							; 61	;;;                                                           ;;;
							; 62	;;;		TIMOTHE LITT				      ;;;
							; 63	;;;             DIGITAL EQUIPMENT CORP.                       ;;;
							; 64	;;;             MARLBORO, MASS.                               ;;;
							; 65	;;;		IND-3/C9 262-8374			      ;;;
							; 66	;;;                                                           ;;;
							; 67	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 68	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 69	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 5-1
; KS10.MIC[1,2]	11:18 17-APR-2015					CRAM4K.MIC[1,2]	13:05 16-APR-2015		

							; 70	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 6
; KS10.MIC[1,2]	11:18 17-APR-2015				REVISION HISTORY					

							; 71	.TOC	"REVISION HISTORY"
							; 72	
							; 73	;REV	WHY
							; 74	;1	START KS10 MICROCODE BASED ON SM10 MICROCODE VERSION 510
							; 75	;2	UPDATE TO KS10 VERSION 512
							; 76	;3	FIX SOME DEFAULTS
							; 77	;4	CHANGE HARDWARE TO MATCH ECO #215
							; 78	;5	START TO UPDATE IO MICROCODE
							; 79	;6	MORE WORK ON IO
							; 80	;7	MAKE INTERRUPT THE 8080 BE A PULSE.
							; 81	;10	ADD NEW RDIO AND WRIO
							; 82	;11	FIX PROBLEMS IN MUUO CODE & CORRECT T-FIELDS
							; 83	;12	FIX PROBLEMS IN DDIV
							; 84	;13	FIX UP PROBLEMS IN PI
							; 85	;14	TURN ON WRITE FOR FL-EXIT
							; 86	;15	FIX UP MAP INSTRUCTION
							; 87	;16	MORE WORK ON KI-STYLE MAP
							; 88	;17	INVERT HOLD RIGHT AND HOLD LEFT BITS
							; 89	;20	FIXUP WRIO & RDIO EFFECTIVE ADDRESS CALC.
							; 90	;21	FIX EDIT 15
							; 91	;22	HAVE LSH USE FAST SHIFT HARDWARE
							; 92	;23	FIX T-FIELD VALUES FOR PRODUCTION HARDWARE
							; 93	;24	REMOVE WRITE TEST FROM IO READS & WRITES
							; 94	;25	REWRITE MUL & MULI TO BE FASTER AND SMALLER. ALSO MAKE ADJBP
							; 95	;	USE NEW MULSUB
							; 96	;26	MAKE BYTES USE FAST SHIFT ECO.
							; 97	;27	MAKE SURE VMA FETCH IS CORRECT
							; 98	;30	MORE OF 25 (FORGOT FMP)
							; 99	;31	FIX SOME PROBLEMS WITH TRAPS
							; 100	;32	SPEED UP EFFECTIVE ADDRESS CALCULATION
							; 101	;33	MORE OF 32
							; 102	;34	SPEED UP ASH & ROT
							; 103	;35	FIX UP RDTIM SO THAT TIME DOES NOT GO BACKWARDS
							; 104	;36	MORE OF 35
							; 105	;37	FIX UP PROBLEMS WITH INTERRUPTS AND DOUBLE F.P.
							; 106	;40	IMPROVE LISTING FORMAT
							; 107	;41	SPEEDUP KL-MODE PAGE REFILL
							; 108	;42	FIX UP DDIV
							; 109	;43	STILL MORE DDIV STUFF
							; 110	;44	CORRECT PROBLEMS IN D.P. PARITY STUFF
							; 111	;45	CORRECT THE BLT CLEAR-CORE CASE TO INTERRUPT CORRECTLY
							; 112	;46	MORE OF 45
							; 113	;47	DO NOT ALLOW SOFTWARE INTERRUPTS IF THE PI LEVEL IS NOT
							; 114	;	ACTIVE.
							; 115	;50	MAKE FDV WORK THE SAME AS THE KL10
							; 116	;51	FIX INTERRUPT IN CVTBDX. MAKE ABORT WORK LIKE SPEC.
							; 117	;52	FIX BUG IN HALT LOOP
							; 118	;53	FIX IOEA TO WORK IF NO @ OR INDEXING
							; 119	;54	EDIT 47 BROKE JEN
							; 120	;55	FIX FLAGS IN MULTIPLY. ALSO CODE BUMS
							; 121	;56	MORE CODE BUMS
							; 122	;57	CORRECT OVERFLOW TRAPS WHICH DO MUUOS TO NOT STORE
							; 123	;	THE TRAP FLAGS.
							; 124	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 7
; KS10.MIC[1,2]	11:18 17-APR-2015				REVISION HISTORY					

							; 125	;60	CORRECT TRAPS SO THAT DSKEA RUNS RIGHT
							; 126	;61	MORE OF 60. NOTE: MICROCODE REQUIRES ECO #299!!
							; 127	;62	ONE MORE TRY AT EDIT 60.
							; 128	;63	CORRECT TOPS-10 STYLE PAGING SO THAT A WRITE VIOLATION SETS
							; 129	;	BIT 2 IN THE PAGE FAIL WORD (ACCESS ALLOWED).
							; 130	;64	EDIT 63 BROKE HARD PAGE FAILS. (NXM, BAD DATA, AND IO NXM)
							; 131	;65	INTERRUPTS OUT OF MOVSRJ INSTRUCTIONS DO STRANGE THINGS.
							; 132	;66	IO NXM PAGE FAIL FOR MISSING UBA GIVES PC+1 IN PAGE FAIL BLOCK.
							; 133	;67	ON A BAD DATA ERROR, STORE THE BAD WORD IN AC BLOCK 7 WORD 0 AND
							; 134	;	1
							; 135	;70	FIX A BUG WHICH CAUSED INTERRUPTS OUT OF CVTBDT TO GENERATE A BAD
							; 136	;	ANSWER.
							; 137	;71	CLEANUP SOME THINGS TO MAKE LIFE EASIER FOR FIELD SERVICE
							; 138	;72	LOOK FOR 1-MS TRAP ON @ PAGE POINTERS AND ABORT REFILL IF
							; 139	;	SET.
							; 140	;73	CORRECT EDIT 72.
							; 141	;74	EDIT 67 GENERATES A DATA PATH PARITY ERROR BECAUSE OF THE BAD
							; 142	;	DATA. CORRECT TO NOT CHECK PARITY.
							; 143	;	ALSO CHANGE POP TO TIE UP BUS LESS.
							; 144	;75	EDIT 60 BROKE TRAPS. MISSING =0 AT TRAP:. 
							; 145	;76	CORRECT BUG IN DFAD AND DFSB
							; 146	;77	FIX PROBLEM SEEN IN SOME (ALL BUT ENGINEERING?) MACHINES CAUSED
							; 147	;	BY EDIT 76
							; 148	;100	CHANGE DFAD/DFSB TO HAVE 2 MORE GUARD BITS. THIS SHOULD PRODUCE
							; 149	;	KL10 ANSWERS FOR ALL NORMALIZED INPUTS
							; 150	;	ALSO FIX A BUG IN CVTBDX PAGE FAIL LOGIC.
							; 151	;101	DFDV OF 0.0 / -0.5 HANGS THE MACHINE
							; 152	;102	FIX CHOPPED FLOATING POINT INSTRUCTIONS
							; 153	;103	CORRECT DFDV ROUNDING BUG.
							; 154	;104	CORRECT PROBLEMS IN DFMP
							; 155	;105	RDTIME SOMETIMES GIVES WRONG ANSWER. CARRY BETWEEN
							; 156	;	WORDS GETS LOST SOMETIME.
							; 157	;106	MOVEM (ALSO, SETZM, SETOM, ETC.) SOMETIMES DOES NOT GENERATE
							; 158	;	A WRITE-TRAP IN 100% OF THE CASES THAT IT SHOULD.
							; 159	;107	PXCT 14, DOES NOT GET THE INDEX REGISTER IN THE PREVIOUS
							; 160	;	CONTEXT ALL THE TIME.
							; 161	;110	FIX TYPO IN EDIT 103
							; 162	;111	63. BIT BYTES DO NOT WORK CORRECTLY. DSKDA FAILS BECAUSE OF THIS
							; 163	;	PROBLEM.
							; 164	;******* VERSION 111 WENT OUT WITH SYSTEM REV 2 *******
							; 165	
							; 166	;112	FIX COMMENT IN TEST INSTRUCTIONS
							; 167	;113	CORRECT IOEA TO COMPUTE CORRECT ADDRESS IF JUST LOCAL INDEXING
							; 168	;	IS USED.
							; 169	;114	CORRECT INTERRUPT BUG IN DMUL
							; 170	;115	CORRECT COMMENTS HALT STATUS BLOCK
							; 171	;116	CORRECT PROBLEM WHERE CST MODIFIED BIT GETS SET BY MISTAKE.
							; 172	;117	RDINT INSTRUCTION DOES NOT WORK AT ALL. IT STORES RANDOM TRASH
							; 173	;	IN THE WRONG PLACE. NEED TO LOAD BR NOT AR.
							; 174	;120	FLOATING POINT OPERATIONS SOMETIMES GET THE WRONG RESULT WITH
							; 175	;	INPUTS OF UNNORMALIZED ZEROS. THIS SHOULD NEVER HAPPEN WITH
							; 176	;	FORTRAN OR ANY OTHER DEC LANGUAGE.
							; 177	;121	PREVENT KEEP-ALIVE CRASHES FROM OCCURRING BECAUSE THE MOVSRJ
							; 178	;	INSTRUCTION CAN LOCK OUT THE 1MS TIMER INTERRUPTS FROM BEING
							; 179	;	HANDLED. THIS CAUSES THE OPERATING SYSTEM TO LOSE TRACK OF THE
							; 180	;	PASSAGE OF TIME.; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 7-1
; KS10.MIC[1,2]	11:18 17-APR-2015				REVISION HISTORY					

							; 181	;122	DFAD FOLLOWED BY A FSC OF -5 CAUSES THE FSC TO GET WRONG
							; 182	;	ANSWER. HAD TO CLEAR FLAG WORD AT EXIT OF DFAD TO FIX PROBLEM
							; 183	;123	MORE CODE FOR EDIT 121. ADDED ANOTHER DISPATCH ADDRESS FOR
							; 184	;	PAGE FAIL CODE AT PFD:.
							; 185	;124	ADD ASSEMBLY OPTIONS FOR NOCST AND INHIBIT CST UPDATE.
							; 186	;	ADD BLTUB/BLTBU TO GET UBA STYLE BYTES SWAPPED TO/FROM ILDB FORM.
							; 187	;	ADD ASSEMBLY OPTIONS FOR KI/KL PAGE.  NEED THE SPACE FOR BLTUB/BU.
							; 188	;125	SUPPORT THE "MAJOR/MINOR VERSION IN 136" UCODE STANDARD.
							; 189	;	FIX BAD CONSTRAINT FOR INHCST ASSEMBLIES (NOT CURRENTLY USED)
							; 190	;126	FIX NON-TRIVIAL CASES OF RDUBR,WRUBR, AND PROCESS CONTEXT WORD.
							; 191	;127	JSR IN A TRAP CYCLE STORES E+1 SOMETIMES.  TRAP CYCLE WAS NOT BEING
							; 192	;	CLEARED (BY NICOND) BEFORE STARTING THE NEXT MEMORY READ.  
							; 193	;130	FIX UCODE HANG WITH STOPPPED CLOCKS ON WR (KL-PAGING REGISTER) IF
							; 194	;	PAGING IS ON.  IDEALLY, WE WOULD REMOVE WRITE TEST FROM THE DROM
							; 195	;	FIELD, BUT IT'S TOO LATE TO ECO THE ROMS.  
							; 196	;	RESTRICTION:  WRITE KLPAGE REGISTER LOCATION MUST BE WRITABLE.
							; 197	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 8
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ THE MICROCODE				

							; 198	.TOC	"HOW TO READ THE MICROCODE"
							; 199	
							; 200	;		
							; 201	;		
							; 202	;		1.0 FIELD DEFINITIONS
							; 203	;		
							; 204	;		THESE OCCUR AT THE BEGINNING  OF  THE  LISTING,  IN  THE  SOURCE  FILE  KS10.MIC
							; 205	;		(CONTROL AND DISPATCH RAM DEFINITIONS).  THEY HAVE THE FORM:
							; 206	;		
							; 207	;		        SYMBOL/=<L:R>M,J
							; 208	;		
							; 209	;		THE PARAMETER (J) IS MEANINGFUL WHEN "D" IS SPECIFIED AS THE DEFAULT  MECHANISM,
							; 210	;		AND  IN  THAT  CASE, GIVES THE DEFAULT VALUE OF THE FIELD IN OCTAL.  WHEN "F" IS
							; 211	;		SPECIFIED AS THE DEFAULT MECHANISM, (J) IS THE NAME OF A  FIELD  WHICH  CONTAINS
							; 212	;		THE DEFAULT VALUE FOR THIS FIELD.
							; 213	;		
							; 214	;		THE PARAMETER (L) GIVES THE BIT POSITION OF THE LEFTMOST BIT IN THE FIELD.   THE
							; 215	;		SAME METHOD IS USED AS FOR (R) BELOW.
							; 216	;		
							; 217	;		THE PARAMETER (R) GIVES THE FIELD POSITION IN DECIMAL AS THE BIT NUMBER  OF  THE
							; 218	;		RIGHTMOST  BIT  OF  THE FIELD.  BITS ARE NUMBERED FROM 0 ON THE LEFT.  NOTE THAT
							; 219	;		THE POSITION OF BITS IN THE MICROWORD SHOWN IN THE LISTING BEARS NO RELATION  TO
							; 220	;		THE ORDERING OF BITS IN THE HARDWARE MICROWORD, WHERE FIELDS ARE OFTEN BROKEN UP
							; 221	;		AND SCATTERED.
							; 222	;		
							; 223	;		THE PARAMETER (M) IS OPTIONAL, AND SELECTS A DEFAULT MECHANISM  FOR  THE  FIELD.
							; 224	;		THE  LEGAL  VALUES  OF  THIS PARAMETER ARE THE CHARACTERS "D", "F", "T", "P", OR
							; 225	;		"+".
							; 226	;		
							; 227	;		        "D" MEANS (J) IS THE DEFAULT VALUE OF THE FIELD IF NO EXPLICIT VALUE  IS
							; 228	;		        SPECIFIED.
							; 229	;		
							; 230	;		        "F" IS USED TO CAUSE THIS FIELD TO DEFAULT TO SOME OTHER FIELD.
							; 231	;		
							; 232	;		        "T" IS USED ON THE TIME FIELD TO SPECIFY THAT THE  VALUE  OF  THE  FIELD
							; 233	;		        DEPENDS  ON  THE  TIME PARAMETERS SELECTED FOR OTHER FIELDS.  "T" IS NOT
							; 234	;		        USED IN THE KS10.
							; 235	;		
							; 236	;		        "P" IS USED ON THE PARITY FIELD TO SPECIFY THAT THE VALUE OF  THE  FIELD
							; 237	;		        SHOULD  DEFAULT  SUCH THAT PARITY OF THE ENTIRE WORD IS ODD.  "P" IS NOT
							; 238	;		        USED ON THE KS10.
							; 239	;		
							; 240	;		        "+" IS USED ON THE JUMP ADDRESS FIELD TO SPECIFY THAT THE  DEFAULT  JUMP
							; 241	;		        ADDRESS  IS  THE  ADDRESS  OF  THE  NEXT  INSTRUCTION ASSEMBLED (NOT, IN
							; 242	;		        GENERAL, THE CURRENT LOCATION +1).
							; 243	;		
							; 244	;		IN GENERAL, A FIELD CORRESPONDS TO THE SET OF BITS WHICH PROVIDE  SELECT  INPUTS
							; 245	;		FOR MIXERS OR DECODERS, OR CONTROLS FOR ALU'S.
							; 246	;		
							; 247	;		
							; 248	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 9
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ THE MICROCODE				

							; 249	;		2.0 VALUE DEFINITIONS
							; 250	;		
							; 251	;		FOLLOWING A FIELD DEFINITION, SYMBOLS MAY BE CREATED IN THAT FIELD TO CORRESPOND
							; 252	;		TO VALUES OF THE FIELD.  THE FORM IS:
							; 253	;		
							; 254	;		        SYMBOL=N
							; 255	;		
							; 256	;		"N" IS, IN OCTAL, THE VALUE OF SYMBOL WHEN USED IN THE FIELD.
							; 257	;		
							; 258	;		
							; 259	;		
							; 260	;		3.0 LABEL DEFINITIONS
							; 261	;		
							; 262	;		A MICRO INSTRUCTION MAY BE LABELLED BY A SYMBOL FOLLOWED BY COLON PRECEDING  THE
							; 263	;		MICROINSTRUCTION  DEFINITION.   THE  ADDRESS OF THE MICROINSTRUCTION BECOMES THE
							; 264	;		VALUE OF THE SYMBOL IN THE FIELD NAMED "J".  EXAMPLE:
							; 265	;		
							; 266	;		        FOO:  J/FOO
							; 267	;		
							; 268	;		THIS IS A MICROINSTRUCTION WHOSE "J" FIELD (JUMP  ADDRESS)  CONTAINS  THE  VALUE
							; 269	;		"FOO".   IT  ALSO  DEFINES  THE  SYMBOL  "FOO"  TO  BE  THE  ADDRESS  OF ITSELF.
							; 270	;		THEREFORE, IF EXECUTED BY THE MICROPROCESSOR, IT WOULD LOOP ON ITSELF.
							; 271	;		
							; 272	;		
							; 273	;		
							; 274	;		4.0 COMMENTS
							; 275	;		
							; 276	;		A SEMICOLON ANYWHERE ON A LINE CAUSES THE REST OF THE LINE TO BE IGNORED BY  THE
							; 277	;		ASSEMBLER.  THIS TEXT IS AN EXAMPLE OF COMMENTS.
							; 278	;		
							; 279	;		
							; 280	;		
							; 281	;		5.0 MICROINSTRUCTION DEFINITION
							; 282	;		
							; 283	;		A WORD OF MICROCODE IS DEFINED BY SPECIFYING A FIELD  NAME,  FOLLOWED  BY  SLASH
							; 284	;		(/),  FOLLOWED BY A VALUE.  THE VALUE MAY BE A SYMBOL DEFINED FOR THAT FIELD, AN
							; 285	;		OCTAL DIGIT STRING, OR A DECIMAL DIGIT STRING (DISTINGUISHED BY THE FACT THAT IT
							; 286	;		CONTAINS  "8"  AND/OR "9" AND/OR IS TERMINATED BY A PERIOD).  SEVERAL FIELDS MAY
							; 287	;		BE SPECIFIED IN ONE MICROINSTRUCTION BY  SEPARATING  FIELD/VALUE  SPECIFICATIONS
							; 288	;		WITH COMMAS.  EXAMPLE:
							; 289	;		
							; 290	;		        AD/ZERO,RAMADR/AC*#,ACALU/AC+N,ACN/1,DBUS/DP
							; 291	;		
							; 292	;		
							; 293	;		6.0 CONTINUATION
							; 294	;		
							; 295	;		THE DEFINITION OF A MICROINSTRUCTION MAY CONTINUED ONTO TWO  OR  MORE  LINES  BY
							; 296	;		BREAKING IT AFTER ANY COMMA.  IN OTHER WORDS, IF THE LAST NON-BLANK, NON-COMMENT
							; 297	;		CHARACTER ON A LINE IS A COMMA, THE INSTRUCTION SPECIFICATION  IS  CONTINUED  ON
							; 298	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 10
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ THE MICROCODE				

							; 299	;		THE FOLLOWING LINE.  EXAMPLE:
							; 300	;		        READ [AR],              ;LOOK AT EFFECTIVE ADDRESS
							; 301	;		        SKIP DP18,              ;SEE IF RIGHT OR LEFT SHIFT
							; 302	;		        SC_SHIFT-1,              ;PUT NUMBER OF PLACE TO
							; 303	;		                                ;SHIFT IN SC
							; 304	;		        LOAD FE,                ; AND IN FE
							; 305	;		        INST DISP               ;GO DO THE SHIFT
							; 306	;		
							; 307	;		
							; 308	;		
							; 309	;		7.0 MACROS
							; 310	;		
							; 311	;		A MACRO IS A SYMBOL WHOSE VALUE IS ONE OR MORE FIELD/VALUE SPECIFICATIONS AND/OR
							; 312	;		MACROS.   A  MACRO  DEFINITION IS A LINE CONTAINING THE MACRO NAME FOLLOWED BY A
							; 313	;		QUOTED STRING WHICH IS THE VALUE OF THE MACRO.  EXAMPLE:
							; 314	;		
							; 315	;		        LOAD VMA "MEM/1, LDVMA/1
							; 316	;		
							; 317	;		THE APPEARANCE OF A MACRO IN A MICROINSTRUCTION DEFINITION IS EQUIVALENT TO  THE
							; 318	;		APPEARANCE OF ITS VALUE.
							; 319	;		
							; 320	;		MACRO MAY HAVE PARAMETERS ENCLOSED IN [].  FOR EXAMPLE,
							; 321	;		
							; 322	;		        []_[] "AD/A,A/@2,DEST/AD,B/@1"
							; 323	;		
							; 324	;		THE @1 GETS REPLACED BY WHAT IS WRITTEN IN  THE  FIRST  SET  OF  []  AND  @2  IS
							; 325	;		REPLACED BY WHAT IS WRITTEN IN THE SECOND SET OF [].  THUS
							; 326	;		
							; 327	;		        [AR]_[ARX]
							; 328	;		
							; 329	;		HAS THE SAME EFFECT AS SAYING
							; 330	;		
							; 331	;		        AD/A,A/ARX,DEST/AD,B/AR
							; 332	;		
							; 333	;		
							; 334	;		        SEE DESCRIPTION OF RULES FOR MACRO NAMES.
							; 335	;		
							; 336	;		8.0 PSEUDO OPS
							; 337	;		
							; 338	;		        THE MICRO ASSEMBLER HAS 13 PSEUDO-OPERATORS:
							; 339	;		
							; 340	;		        .DCODE AND .UCODE SELECT THE RAM INTO WHICH SUBSEQUENT MICROCODE WILL BE
							; 341	;		        LOADED,  AND  THEREFORE  THE  FIELD  DEFINITIONS  AND  MACROS  WHICH ARE
							; 342	;		        MEANINGFUL IN SUBSEQUENT MICROCODE
							; 343	;		        .TITLE DEFINES A STRING OF TEXT TO APPEAR IN THE PAGE HEADER, AND
							; 344	;		        .TOC DEFINES AN ENTRY FOR THE TABLE OF CONTENTS AT THE BEGINNING.
							; 345	;		        .SET DEFINES THE VALUE OF A CONDITIONAL ASSEMBLY PARAMETER,
							; 346	;		        .CHANGE REDEFINES A CONDITIONAL ASSEMBLY PARAMETER,
							; 347	;		        .DEFAULT ASSIGNS A VALUE TO AN UNDEFINED PARAMETER.
							; 348	;		        .IF ENABLES ASSEMBLY IF THE VALUE OF THE PARAMETER IS NOT ZERO,
							; 349	;		        .IFNOT ENABLES ASSEMBLY IF THE PARAMETER VALUE IS ZERO, AND
							; 350	;		        .ENDIF RE-ENABLES ASSEMBLY IF SUPPRESSED BY THE PARAMETER NAMED.
							; 351	;		        .NOBIN TURNS OFF THE BINARY A GETS RID OF THE SPACE USED TO LIST IT,
							; 352	;		        .BIN TURN BINARY BACK ON AGAIN.
							; 353	;		        .WIDTH CONTROLS THE NUMBER OF BITS IN THE CRAM
							; 354	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 11
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ THE MICROCODE				

							; 355	;		9.0 LOCATION CONTROL
							; 356	;		
							; 357	;		A MICROINSTRUCTION "LABELLED" WITH A NUMBER IS ASSIGNED TO THAT ADDRESS.
							; 358	;		
							; 359	;		THE CHARACTER "=" AT THE BEGINNING OF A LINE, FOLLOWED BY A STRING OF 0'S,  1'S,
							; 360	;		AND/OR   *'S,   SPECIFIES   A   CONSTRAINT   ON   THE   ADDRESS   OF   FOLLOWING
							; 361	;		MICROINSTRUCTIONS.  THE NUMBER OF CHARACTERS IN THE CONSTRAINT STRING (EXCLUDING
							; 362	;		THE  "=")  IS  THE  NUMBER  OF  LOW-ORDER  BITS CONSTRAINED IN THE ADDRESS.  THE
							; 363	;		MICROASSEMBLER ATTEMPTS TO FIND AN UNUSED LOCATION WHOSE ADDRESS HAS 0  BITS  IN
							; 364	;		THE POSITIONS CORRESPONDING TO 0'S IN THE CONSTRAINT STRING AND 1 BITS WHERE THE
							; 365	;		CONSTRAINT HAS 1'S.  ASTERISKS DENOTE "DON'T CARE" BIT POSITIONS.
							; 366	;		
							; 367	;		IF THERE ARE ANY 0'S IN THE CONSTRAINT STRING, THE CONSTRAINT IMPLIES A BLOCK OF
							; 368	;		<2**N> MICROWORDS, WHERE N IS THE NUMBER OF 0'S IN THE STRING.  ALL LOCATIONS IN
							; 369	;		THE BLOCK WILL HAVE 1'S IN THE ADDRESS BITS CORRESPONDING TO 1'S IN THE  STRING,
							; 370	;		AND BIT POSITIONS DENOTED BY *'S WILL BE THE SAME IN ALL LOCATIONS OF THE BLOCK.
							; 371	;		
							; 372	;		IN SUCH A CONSTRAINT BLOCK, THE DEFAULT ADDRESS PROGRESSION IS COUNTING  IN  THE
							; 373	;		"0"  POSITIONS  OF  THE  CONSTRAINT STRING, BUT A NEW CONSTRAINT STRING OCCURING
							; 374	;		WITHIN A BLOCK MAY FORCE SKIPPING OVER SOME LOCATIONS OF THE  BLOCK.   WITHIN  A
							; 375	;		BLOCK,  A  NEW  CONSTRAINT STRING DOES NOT CHANGE THE PATTERN OF DEFAULT ADDRESS
							; 376	;		PROGRESSION, IT MERELY ADVANCES THE LOCATION COUNTER OVER THOSE LOCATIONS.   THE
							; 377	;		MICROASSEMBLER WILL LATER FILL THEM IN.
							; 378	;		
							; 379	;		A NULL CONSTRAINT STRING ("=" FOLLOWED BY ANYTHING BUT "0", "1", OR "*")  SERVES
							; 380	;		TO TERMINATE A CONSTRAINT BLOCK.  EXAMPLES:
							; 381	;		
							; 382	;		        =0 
							; 383	;		
							; 384	;		THIS SPECIFIES THAT THE LOW-ORDER ADDRESS BIT MUST BE ZERO-- THE  MICROASSEMBLER
							; 385	;		FINDS  AN  EVEN-ODD  PAIR  OF LOCATIONS, AND PUTS THE NEXT TWO MICROINSTRUCTIONS
							; 386	;		INTO THEM.
							; 387	;		
							; 388	;		        =11
							; 389	;		THIS SPECIFIES THAT THE TWO LOW-ORDER BITS OF THE ADDRESS  MUST  BOTH  BE  ONES.
							; 390	;		SINCE THERE ARE NO 0'S IN THIS CONSTRAINT, THE ASSEMBLER FINDS ONLY ONE LOCATION
							; 391	;		MEETING THE CONSTRAINT.
							; 392	;		
							; 393	;		        =0*****
							; 394	;		
							; 395	;		THIS SPECIFIES  AN  ADDRESS  IN  WHICH  THE  "40"  BIT  IS  ZERO.   DUE  TO  THE
							; 396	;		IMPLEMENTATION OF THIS FEATURE IN THE ASSEMBLER, THE DEFAULT ADDRESS PROGRESSION
							; 397	;		APPLIES ONLY TO THE LOW-ORDER 5 BITS, SO THIS CONSTRAINT FINDS ONE WORD IN WHICH
							; 398	;		THE  "40"  BIT  IS ZERO, AND DOES NOT ATTEMPT TO FIND ONE IN WHICH THAT BIT IS A
							; 399	;		ONE.  THIS LIMITATION HAS BEEN CHANGED WITH NEWER ASSEMBLER  VERSIONS.   HOWEVER
							; 400	;		NONE  OF  THE  LOCATIONS  IN  THE  MICROCODE REQUIRE ANYTHING BUT THE CONSTRAINT
							; 401	;		MENTIONED ABOVE.
							; 402	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 12
; KS10.MIC[1,2]	11:18 17-APR-2015				CONDITIONAL ASSEMBLY DEFINITIONS			

							; 403	.TOC	"CONDITIONAL ASSEMBLY DEFINITIONS"
							; 404	
							; 405	.DEFAULT/SIM=0		;0=RUN ON REAL HARDWARE
							; 406				;1=RUN UNDER SIMULATOR
							; 407	
							; 408	.DEFAULT/FULL=1		;0=INCLUDE ONLY BASIC INSTRUCTIONS
							; 409				;1=INCLUDE FULL INSTRUCTION SET
							; 410	
							; 411	.DEFAULT/INHCST=0	;0=NO CODE TO INHIBIT CST UPDATE IF CSB=0
							; 412				;1=DON'T UPDATE CST IF CSB=0
							; 413	
							; 414	.DEFAULT/NOCST=0	;0=INCLUDE SUPPORT FOR WRITING THE CST
							; 415				;1=COMPLETELY DESUPPORT CST (FOR TOPS-10)
							; 416	
							; 417	.DEFAULT/CRAM4K=0	;0=2K CRAM (DEC KS10)
							; 418				;1=4K CRAM (KS10 FPGA)
							; 419	
							; 420	.DEFAULT/UBABLT=0	;0=NO UBABLT SUPPORT
							; 421				;1=SUPPORT UBA STYLE BLT INSTRUCTIONS.
							; 422	
							; 423	.DEFAULT/KIPAGE=1	;0=DON'T SUPPORT KI PAGING
							; 424				;1=DO
							; 425	
							; 426	.DEFAULT/KLPAGE=1	;0=DON'T SUPPORT KL PAGING
							; 427				;1=DO
							; 428	
							; 429	; THE DEC KS10 DOES NOT HAVE ENOUGH MICROCODE STORAGE TO INCLUDE ALL OF THE
							; 430	; MICROCODE OPTIONS SIMULTANEOUSLY.  KL PAGING AND KI PAGING ARE EXCLUSIVE
							; 431	; IF UBABLT IS ENABLED.  NEWER MACHINES HAVE 4K MICROCODE STORAGE WHICH
							; 432	; REMOVES THIS RESTRICTION.
							; 433	
							;;434	.IFNOT/CRAM4K 
							;;435		.IF/UBABLT
							;;436			.IF/KLPAGE
							;;437				.CHANGE/KIPAGE=0
							;;438			.ENDIF/KLPAGE
							;;439			.IF/KIPAGE
							;;440				.CHANGE/KLPAGE=0
							;;441			.ENDIF/KIPAGE
							;;442		.ENDIF/UBABLT
							; 443	.ENDIF/CRAM4K
							; 444	
							; 445	
							;;446	.IF/NOCST
							;;447		.CHANGE/INHCST=0
							; 448	.ENDIF/NOCST
							; 449	
							; 450	.DEFAULT/NONSTD=0	;0=STANDARD MICROCODE
							; 451				;1=NON-STANDARD MICROCODE
							; 452	
							; 453	.WIDTH/108		;ONLY FIELDS BETWEEN BITS 0 AND 107 EVER
							; 454				; GET LOADED INTO THE CRAM. OTHER FIELDS
							; 455				; ARE USED FOR DEFAULTING PROCESS.
							; 456	
							; 457	
							; 458	;CONFIGURE THE MICROCODE REGIONS.   KEEP STUFF OUT OF DROM SPACE; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 12-1
; KS10.MIC[1,2]	11:18 17-APR-2015				CONDITIONAL ASSEMBLY DEFINITIONS			

							; 459	
							; 460	.IF/CRAM4K
							; 461		.REGION/0,1377/2000,7777/1400,1777
							; 462	;	.REGION/0,1377/2000,3776/4000,7777/1400,1777
							;;463	.IFNOT/CRAM4K
							;;464		.REGION/0,1377/2000,3777/1400,1777
							; 465	.ENDIF/CRAM4K
							; 466	
							; 467	
							; 468	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 13
; KS10.MIC[1,2]	11:18 17-APR-2015				2901 REGISTER USAGE					

							; 469	.TOC	"2901 REGISTER USAGE"
							; 470	
							; 471	;	!=========================================================================!
							; 472	;0:	!                   MAG (ONES IN BITS 1-36, REST ZERO)                    !
							; 473	;	!-------------------------------------------------------------------------!
							; 474	;1:	!                 PC (ADDRESS OF CURRENT INSTRUCTION + 1)                 !
							; 475	;	!-------------------------------------------------------------------------!
							; 476	;2:	!                        HR (CURRENT INSTRUCTION)                         !
							; 477	;	!-------------------------------------------------------------------------!
							; 478	;3:	!                    AR (TEMP -- MEM OP AT INST START)                    !
							; 479	;	!-------------------------------------------------------------------------!
							; 480	;4:	!               ARX (TEMP -- LOW ORDER HALF OF DOUBLE PREC)               !
							; 481	;	!-------------------------------------------------------------------------!
							; 482	;5:	!                                BR (TEMP)                                !
							; 483	;	!-------------------------------------------------------------------------!
							; 484	;6:	!           BRX (TEMP -- LOW ORDER HALF OF DOUBLE PREC BR!BRX)            !
							; 485	;	!-------------------------------------------------------------------------!
							; 486	;7:	!                          ONE (THE CONSTANT 1)                           !
							; 487	;	!-------------------------------------------------------------------------!
							; 488	;10:	!                        EBR (EXEC BASE REGISTER)                         !
							; 489	;	!-------------------------------------------------------------------------!
							; 490	;11:	!                        UBR (USER BASE REGISTER)                         !
							; 491	;	!-------------------------------------------------------------------------!
							; 492	;12:	!           MASK (ONES IN BITS 0-35, ZERO IN -1, -2, 36 AND 37)           !
							; 493	;	!-------------------------------------------------------------------------!
							; 494	;13:	!          FLG (FLAG BITS)           !           PAGE FAIL CODE           !
							; 495	;	!-------------------------------------------------------------------------!
							; 496	;14:	!                  PI (PI SYSTEM STATUS REGISTER [RDPI])                  !
							; 497	;	!-------------------------------------------------------------------------!
							; 498	;15:	!                       XWD1 (1 IN EACH HALF WORD)                        !
							; 499	;	!-------------------------------------------------------------------------!
							; 500	;16:	!                                T0 (TEMP)                                !
							; 501	;	!-------------------------------------------------------------------------!
							; 502	;17:	!                                T1 (TEMP)                                !
							; 503	;	!=========================================================================!
							; 504	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 14
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- LISTING FORMAT			

							; 505		.TOC	"MICROCODE FIELDS -- LISTING FORMAT"
							; 506	
							; 507	;								; 3633	1561:
							; 508	;								; 3634	SUB:	[AR]_AC-[AR],
							; 509	;								; 3635		AD FLAGS, 3T,
							; 510	;	U 1561, 1500,2551,0303,0274,4463,7701,4200,0001,0001	; 3636		EXIT
							; 511	;	  [--]  [--] !!!! [][] !!![-][][-][]! !!!     [----]
							; 512	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!!        !
							; 513	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!!        +---- # (MAGIC NUMBER)
							; 514	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!!      
							; 515	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!+------------- MULTI PREC, MULTI SHIFT, CALL (4S, 2S, 1S)
							; 516	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!
							; 517	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !+-------------- FM WRITE, MEM, DIVIDE (4S, 2S, 1S)
							; 518	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !
							; 519	;	  !     !    !!!! ! !  !!!!  ! !  ! ! +--------------- CRY38, LOAD SC, LOAD FE (4S, 2S, 1S)
							; 520	;	  !     !    !!!! ! !  !!!!  ! !  ! !
							; 521	;	  !     !    !!!! ! !  !!!!  ! !  ! +----------------- T
							; 522	;	  !     !    !!!! ! !  !!!!  ! !  !
							; 523	;	  !     !    !!!! ! !  !!!!  ! !  +------------------- SKIP
							; 524	;	  !     !    !!!! ! !  !!!!  ! !
							; 525	;	  !     !    !!!! ! !  !!!!  ! +---------------------- DISP
							; 526	;	  !     !    !!!! ! !  !!!!  !
							; 527	;	  !     !    !!!! ! !  !!!!  +------------------------ SPEC
							; 528	;	  !     !    !!!! ! !  !!!!
							; 529	;	  !     !    !!!! ! !  !!!+--------------------------- CLOCKS & PARITY (CLKR, GENR, CHKR, CLKL, GENL, CHKL)
							; 530	;	  !     !    !!!! ! !  !!!
							; 531	;	  !     !    !!!! ! !  !!+---------------------------- DBM
							; 532	;	  !     !    !!!! ! !  !!
							; 533	;	  !     !    !!!! ! !  !+----------------------------- DBUS
							; 534	;	  !     !    !!!! ! !  !
							; 535	;	  !     !    !!!! ! !  +------------------------------ RAM ADDRESS
							; 536	;	  !     !    !!!! ! !
							; 537	;	  !     !    !!!! ! +--------------------------------- B
							; 538	;	  !     !    !!!! !
							; 539	;	  !     !    !!!! +----------------------------------- A
							; 540	;	  !     !    !!!!
							; 541	;	  !     !    !!!+------------------------------------- DEST
							; 542	;	  !     !    !!!
							; 543	;	  !     !    !!+-------------------------------------- RSRC
							; 544	;	  !     !    !!
							; 545	;	  !     !    !+--------------------------------------- LSRC   ]
							; 546	;	  !     !    !                                                ] - AD
							; 547	;	  !     !    +---------------------------------------- ALU    ]
							; 548	;	  !     !
							; 549	;	  !     +--------------------------------------------- J
							; 550	;	  !
							; 551	;	  LOCATION OF THIS MICRO WORD
							; 552	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 15
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- DATAPATH CHIP			

							; 553	.TOC	"MICROCODE FIELDS -- DATAPATH CHIP"
							; 554	
							; 555	J/=<0:11>+              ;CRA1
							; 556				;NEXT MICROCODE ADDRESS
							; 557	
							; 558	;ALU FUNCTIONS
							; 559	
							; 560	;NOTE: THE AD FIELD IS A 2 DIGIT FIELD. THE LEFT DIGIT IS THE
							; 561	; 2901 ALU FUNCTION. THE RIGHT DIGIT IS THE 2901 SRC CODE FOR
							; 562	; THE LEFT HALF. NORMALY THE RIGHT HALF SRC CODE IS THE SAME AS
							; 563	; THE LEFT HALF.
							; 564	AD/=<12:17>D,44       ;DPE1 & DPE2
							; 565		A+Q=00
							; 566		A+B=01
							; 567		0+Q=02
							; 568		0+B=03
							; 569		0+A=04
							; 570		D+A=05
							; 571		D+Q=06
							; 572		0+D=07
							; 573		Q-A-.25=10
							; 574		B-A-.25=11
							; 575		Q-.25=12
							; 576		B-.25=13
							; 577		A-.25=14
							; 578		A-D-.25=15
							; 579		Q-D-.25=16
							; 580		-D-.25=17
							; 581		A-Q-.25=20
							; 582		A-B-.25=21
							; 583		-Q-.25=22
							; 584		-B-.25=23
							; 585		-A-.25=24
							; 586		D-A-.25=25
							; 587		D-Q-.25=26
							; 588		D-.25=27
							; 589		A.OR.Q=30
							; 590		A.OR.B=31
							; 591		Q=32
							; 592		B=33
							; 593		A=34
							; 594		D.OR.A=35
							; 595		D.OR.Q=36
							; 596		D=37
							; 597		A.AND.Q=40
							; 598		A.AND.B=41
							; 599	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 16
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- DATAPATH CHIP			

							; 600	;MORE ALU FUNCTIONS
							; 601	
							; 602		ZERO=42
							; 603	;	ZERO=43
							; 604	;	ZERO=44
							; 605		D.AND.A=45
							; 606		D.AND.Q=46
							; 607	;	ZERO=47
							; 608		.NOT.A.AND.Q=50
							; 609		.NOT.A.AND.B=51
							; 610	;	Q=52
							; 611	;	B=53
							; 612	;	A=54
							; 613		.NOT.D.AND.A=55
							; 614		.NOT.D.AND.Q=56
							; 615	;	ZERO=57
							; 616		A.XOR.Q=60
							; 617		A.XOR.B=61
							; 618	;	Q=62
							; 619	;	B=63
							; 620	;	A=64
							; 621		D.XOR.A=65
							; 622		D.XOR.Q=66
							; 623	;	D=67
							; 624		A.EQV.Q=70
							; 625		A.EQV.B=71
							; 626		.NOT.Q=72
							; 627		.NOT.B=73
							; 628		.NOT.A=74
							; 629		D.EQV.A=75
							; 630		D.EQV.Q=76
							; 631		.NOT.D=77
							; 632	
							; 633	;THIS FIELD IS THE RIGHTMOST 3 BITS OF THE
							; 634	; AD FIELD. IT IS USED ONLY TO DEFAULT THE RSRC 
							; 635	; FIELD.
							; 636	LSRC/=<15:17>         ;DPE1
							; 637	
							; 638	;THIS IS THE SOURCE FOR THE RIGHT HALF OF THE
							; 639	; DATA PATH. IT LETS US MAKE THE RIGHT AND LEFT
							; 640	; HALF WORDS DO SLIGHTLY DIFFERENT THINGS.
							; 641	RSRC/=<18:20>F,LSRC	;DPE2
							; 642		AQ=0		;A  Q
							; 643		AB=1		;A  B
							; 644		0Q=2		;0  Q
							; 645		0B=3		;0  B
							; 646		0A=4		;0  A
							; 647		DA=5		;D  A
							; 648		DQ=6		;D  Q
							; 649		D0=7		;D  0
							; 650	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 17
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- DATAPATH CHIP			

							; 651	;DESTINATION CONTROL
							; 652	;SEE DPE1 AND DPE2 (2'S WEIGHT IS INVERTED ON DPE5)
							; 653	DEST/=<21:23>D,3      ;DPE1 & DPE2
							; 654		A=0		;A REG IS CHIP OUTPUT, AD IS WRITTEN
							; 655				; INTO REG FILE
							; 656		AD=1		;REG FILE GETS AD
							; 657		Q_AD=2		;REG FILE IS NOT LOADED
							; 658		PASS=3		;AD OUTPUT IS CHIP OUTPUT
							; 659				; Q AND REG FILE LEFT ALONE
							; 660		Q_Q*2=4		;ALSO REG FILE GETS AD*2
							; 661		AD*2=5		;AND Q IS LEFT ALONE
							; 662		Q_Q*.5=6	;ALSO REG FILE GETS AD*.5
							; 663		AD*.5=7		;AND Q IS LEFT ALONE
							; 664	
							; 665	;	<24:25>		;UNUSED
							; 666	
							; 667	A/=<26:29>            	;DPE1 & DPE2
							; 668		MAG=0
							; 669		PC=1
							; 670		HR=2
							; 671		AR=3
							; 672		ARX=4
							; 673		BR=5
							; 674		BRX=6
							; 675		ONE=7
							; 676		EBR=10
							; 677		UBR=11
							; 678		MASK=12
							; 679		FLG=13
							; 680		PI=14
							; 681		XWD1=15
							; 682		T0=16
							; 683		T1=17
							; 684	
							; 685	;	<30:31>		;UNUSED
							; 686	
							; 687	B/=<32:35>D,0         ;DPE1 & DPE2
							; 688		MAG=0
							; 689		PC=1
							; 690		HR=2
							; 691		AR=3
							; 692		ARX=4
							; 693		BR=5
							; 694		BRX=6
							; 695		ONE=7
							; 696		EBR=10
							; 697		UBR=11
							; 698		MASK=12
							; 699		FLG=13
							; 700		PI=14
							; 701		XWD1=15
							; 702		T0=16
							; 703		T1=17
							; 704	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 18
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- RAM FILE ADDRESS AND D-BUS		

							; 705	.TOC	"MICROCODE FIELDS -- RAM FILE ADDRESS AND D-BUS"
							; 706	
							; 707	RAMADR/=<36:38>D,4	;DPE6
							; 708		AC#=0		;AC NUMBER
							; 709		AC*#=1		;AC .FN. #
							; 710		XR#=2		;INDEX REGISTER
							; 711		VMA=4		;VIRTUAL MEMORY REFERENCE
							; 712		RAM=6		;VMA SUPPLIES 10-BIT RAM ADDRESS
							; 713		#=7		;ABSOLUTE RAM FILE REFERENCE
							; 714	
							; 715	;	<39:39>
							; 716	
							; 717	;LEFT HALF ON DPE3 AND RIGHT HALF ON DPE4
							; 718	DBUS/=<40:41>D,1      	;DPE3 & DPE4
							; 719		PC FLAGS=0	;PC FLAGS IN LEFT HALF
							; 720		PI NEW=0	;NEW PI LEVEL IN BITS 19-21
							; 721	;	VMA=0		;VMA IN BITS 27-35
							; 722		DP=1		;DATA PATH
							; 723		RAM=2		;CACHE, AC'S AND WORKSPACE
							; 724		DBM=3		;DBM MIXER
							; 725	
							; 726	;LEFT HALF ON DPM1 AND RIGHT HALF ON DPM2
							; 727	DBM/=<42:44>D,7       	;DPM1 & DPM2
							; 728		SCAD DIAG=0	;(LH) SCAD DIAGNOSTIC
							; 729		PF DISP=0	;PAGE FAIL DISP IN BITS 18-21
							; 730		APR FLAGS=0	;APR FLAGS IN BITS 22-35
							; 731		BYTES=1		;5 COPIES OF SCAD 1-7
							; 732		EXP=2		;LH=EXPONENT, RH=TIME FRACTION
							; 733		DP=3		;DATA PATH
							; 734		DP SWAP=4	;DATA PATH SWAPPED
							; 735		VMA=5		;VMA FLAGS,,VMA
							; 736		MEM=6		;MEMORY BUFFER
							; 737		#=7		;NUMBER FIELD IN BOTH HALVES
							; 738	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 19
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- PARITY GENERATION & HALF WORD CONTROL

							; 739	.TOC	"MICROCODE FIELDS -- PARITY GENERATION & HALF WORD CONTROL"
							; 740	
							; 741	AD PARITY OK/=<108>D,0  ;**NOT STORED IN CRAM**
							; 742				;THIS BIT IS A 1 IF THE ALU IS DOING
							; 743					; SOMETHING WHICH DOES NOT INVALIDATE
							; 744					; PARITY. IT DOES NOT APPEAR IN THE
							; 745					; REAL MACHINE. WE JUST USE IT TO SET
							; 746					; THE DEFAULT FOR GENR & GENL
							; 747	
							; 748	CLKL/=<45:45>D,1        ;DPE5
							; 749				;CLOCK THE LEFT HALF OF THE MACHINE
							; 750	GENL/=<46:46>F,AD PARITY OK ;DPE4 FROM CRM2 PARITY EN LEFT H
							; 751				;STORE PARITY FOR 2901 LEFT
							; 752	CHKL/=<47:47>           ;DPE4 FROM CRM2 PARITY CHK LEFT H
							; 753				;CHECK LEFT HALF DBUS PARITY
							; 754	
							; 755	CLKR/=<48:48>D,1        ;DPE5
							; 756				;CLOCK THE RIGHT HALF OF THE MACHINE
							; 757	GENR/=<49:49>F,AD PARITY OK ;DPE4 FROM CRM2 PARITY EN RIGHT H
							; 758				;STORE PARITY FOR 2901 RIGHT
							; 759	CHKR/=<50:50>           ;DPE4 FROM CRM2 PARITY CHK RIGHT H
							; 760				;CHECK RIGHT HALF DBUS PARITY
							; 761	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 20
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- SPEC				

							; 762	.TOC	"MICROCODE FIELDS -- SPEC"
							; 763	
							; 764	
							; 765	;
							; 766	;THE FOLLOWING SPECIAL FUNCTION ARE DECODED ON DPE1, DPE5, AND DPMA:
							; 767	;	!=========================================================================!
							; 768	;	!S!     EFFECT      !    CRA6 SPEC    !    CRA6 SPEC    !    CRA6 SPEC    !
							; 769	;	!P!    ON SHIFT     !      EN 40      !      EN 20      !      EN 10      !
							; 770	;	!E!      PATHS      !  E102 ON DPE5   !  E101 ON DPE5   !  E410 ON DPMA   !
							; 771	;	!C!   (SEE DPE1)    !                 !  E411 ON DPMA   !  E113 ON CRA2   !
							; 772	;	!=========================================================================!
							; 773	;	!0!     NORMAL      !   CRY 18 INH    !    PREVIOUS     !        #        !
							; 774	;	!-------------------------------------------------------------------------!
							; 775	;	!1!      ZERO       !     IR LOAD     !     XR LOAD     !   CLR 1 MSEC    !
							; 776	;	!-------------------------------------------------------------------------!
							; 777	;	!2!      ONES       !     <SPARE>     !     <SPARE>     !  CLR IO LATCH   !
							; 778	;	!-------------------------------------------------------------------------!
							; 779	;	!3!       ROT       !     PI LOAD     !    APR FLAGS    !   CLR IO BUSY   !
							; 780	;	!-------------------------------------------------------------------------!
							; 781	;	!4!      ASHC       !    ASH TEST     !    SET SWEEP    !   PAGE WRITE    !
							; 782	;	!-------------------------------------------------------------------------!
							; 783	;	!5!      LSHC       !    EXP TEST     !     APR EN      !     NICOND      !
							; 784	;	!-------------------------------------------------------------------------!
							; 785	;	!6!       DIV       !    PC FLAGS     !    PXCT OFF     !     PXCT EN     !
							; 786	;	!-------------------------------------------------------------------------!
							; 787	;	!7!      ROTC       !  AC BLOCKS EN   !     MEM CLR     !    MEM WAIT     !
							; 788	;	!=========================================================================!
							; 789	; THE DPM BOARD USES THE SPEC FIELD TO CONTROL THE
							; 790	;  DBM MIXER, AS FOLLOWS:
							; 791	;
							; 792	;	!=====================================!
							; 793	;	!  S  !                               !
							; 794	;	!  P  !        ACTION WHEN DBM        !
							; 795	;	!  E  !          SELECTS DP           !
							; 796	;	!  C  ! GET DP BITS  !  GET SCAD 1-7  !
							; 797	;	!=====================================!
							; 798	;	!  0  !     ALL      !      NONE      !
							; 799	;	!-------------------------------------!
							; 800	;	!  1  !     7-35     !      0-6       !
							; 801	;	!-------------------------------------!
							; 802	;	!  2  !0-6 AND 14-35 !      7-13      !
							; 803	;	!-------------------------------------!
							; 804	;	!  3  !0-13 AND 21-35!     14-20      !
							; 805	;	!-------------------------------------!
							; 806	;	!  4  !0-20 AND 28-35!     21-27      !
							; 807	;	!-------------------------------------!
							; 808	;	!  5  ! 0-27 AND 35  !     28-34      !
							; 809	;	!-------------------------------------!
							; 810	;	!  6  !         SAME AS ZERO          !
							; 811	;	!-------------------------------------!
							; 812	;	!  7  !         SAME AS ZERO          !
							; 813	;	!=====================================!
							; 814	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 21
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- SPEC				

							; 815	;THE SPEC FIELD IS DEFINED AS A 6-BIT FIELD. THE TOP 3 BITS
							; 816	; ARE SPEC SEL A, SPEC SEL B, AND SPEC SEL C. THE LOW 3 BITS ARE
							; 817	; THE SELECT CODE.
							; 818	
							; 819	SPEC/=<51:56>D,0      	;DPE1 & DPE5 & DPM1 & DPMA
							; 820		#=10		;DECODE # BITS 
							; 821		CLRCLK=11	;CLEAR 1MS NICOND FLAG
							; 822		CLR IO LATCH=12	;CLEAR IO LATCH
							; 823		CLR IO BUSY=13	;CLEAR IO BUSY
							; 824		LDPAGE=14	;WRITE PAGE TABLE
							; 825		NICOND=15	;DOING NICOND DISPATCH
							; 826		LDPXCT=16	;LOAD PXCT FLAGS
							; 827		WAIT=17		;MEM WAIT
							; 828		PREV=20		;FORCE PREVIOUS CONTEXT
							; 829		LOADXR=21	;LOAD XR #, USES PXCT FIELD TO SELECT 
							; 830				; CORRECT AC BLOCK
							; 831		APR FLAGS=23	;LOAD APR FLAGS
							; 832		CLRCSH=24	;CLEAR CACHE
							; 833		APR EN=25	;SET APR ENABLES
							; 834		MEMCLR=27	;CLEAR PAGE FAULT CONDITION
							; 835		SWEEP=34	;SET SWEEP
							; 836		PXCT OFF=36	;TURN OFF THE EFFECT OF PXCT
							; 837		INHCRY18=40	;INHIBIT CARRY INTO LEFT HALF
							; 838		LOADIR=41	;LOAD THE IR
							; 839		LDPI=43		;LOAD PI SYSTEM
							; 840		ASHOV=44	;TEST RESULT OF ASH
							; 841		EXPTST=45	;TEST RESULT OF FLOATING POINT
							; 842		FLAGS=46	;CHANGE PC FLAGS
							; 843		LDACBLK=47	;LOAD AC BLOCK NUMBERS
							; 844		LDINST=61	;LOAD INSTRUCTION
							; 845	
							; 846	;THE SPEC FIELD IS REDEFINED WHEN USED FOR BYTE MODE STUFF
							; 847	BYTE/=<54:56>         	;DPM1 (SPEC SEL)
							; 848		BYTE1=1
							; 849		BYTE2=2
							; 850		BYTE3=3
							; 851		BYTE4=4
							; 852		BYTE5=5
							; 853	
							; 854	;THE SPEC FIELD IS REDEFINED WHEN USED TO CONTROL SHIFT PATHS
							; 855	SHSTYLE/=<54:56>      	;DPE1 (SPEC SEL)
							; 856		NORM=0		;2 40-BIT REGISTERS
							; 857		ZERO=1		;SHIFT ZERO INTO 36 BITS (ASH TOP 2901)
							; 858		ONES=2		;SHIFT IN ONES
							; 859		ROT=3		;ROTATE
							; 860		ASHC=4		;ASHC
							; 861		LSHC=5		;LSHC
							; 862		DIV=6		;SPECIAL DIVIDE
							; 863		ROTC=7		;ROTATE DOUBLE
							; 864	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 22
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- DISPATCH				

							; 865	.TOC	"MICROCODE FIELDS -- DISPATCH"
							; 866	;	!=======================================================!
							; 867	;	! D !      CRA1      !      CRA1      !      DPEA       !
							; 868	;	! I !      DISP      !      DISP      !      DISP       !
							; 869	;	! S !       10       !       20       !       40        !
							; 870	;	! P !                !                !                 !
							; 871	;	!=======================================================!
							; 872	;	! 0 !    DIAG ADR    !    DIAG ADR    !        0        !
							; 873	;	!-------------------------------------------------------!
							; 874	;	! 1 !     RETURN     !     RETURN     !    DP 18-21     !
							; 875	;	!-------------------------------------------------------!
							; 876	;	! 2 !    MULTIPLY    !       J        !        J        !
							; 877	;	!-------------------------------------------------------!
							; 878	;	! 3 !   PAGE FAIL    !     AREAD     !     AREAD      !
							; 879	;	!-------------------------------------------------------!
							; 880	;	! 4 !     NICOND     !   NOT USABLE   !      NORM       !
							; 881	;	!-------------------------------------------------------!
							; 882	;	! 5 !      BYTE      !   NOT USABLE   !    DP 32-35     !
							; 883	;	!-------------------------------------------------------!
							; 884	;	! 6 !    EA MODE     !   NOT USABLE   !     DROM A      !
							; 885	;	!-------------------------------------------------------!
							; 886	;	! 7 !      SCAD      !   NOT USABLE   !     DROM B      !
							; 887	;	!=======================================================!
							; 888	;NOTE:	DISP EN 40 & DISP EN 10 ONLY CONTROL THE LOW 4 BITS OF THE
							; 889	;	JUMP ADDRESS. DISP EN 20 ONLY CONTROLS THE HI 7 BITS. TO DO
							; 890	;	SOMETHING TO ALL 11 BITS BOTH 20 & 40 OR 20 & 10 MUST BE ENABLED.
							; 891	
							; 892	DISP/=<57:62>D,70     	;CRA1 & DPEA
							; 893		CONSOLE=00	;CONSOLE DISPATCH
							; 894		DROM=12		;DROM
							; 895		AREAD=13	;AREAD
							; 896		DP LEFT=31	;DP 18-21
							; 897		NORM=34		;NORMALIZE
							; 898		DP=35		;DP 32-35
							; 899		ADISP=36	;DROM A FIELD
							; 900		BDISP=37	;DROM B FIELD
							; 901		RETURN=41	;RETURN
							; 902		MUL=62		;MULTIPLY
							; 903		PAGE FAIL=63	;PAGE FAIL
							; 904		NICOND=64	;NEXT INSTRUCTION DISPATCH
							; 905		BYTE=65		;BYTE SIZE AND POSITION
							; 906		EAMODE=66	;EFFECTIVE ADDRESS MODE
							; 907		SCAD0=67	;J!2 IF SCAD BIT 0 = 1
							; 908	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 23
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- SKIP				

							; 909	.TOC	"MICROCODE FIELDS -- SKIP"
							; 910	;	!=======================================================!
							; 911	;	! S !      CRA2      !      DPEA      !      DPEA       !
							; 912	;	! K !      SKIP      !      SKIP      !      SKIP       !
							; 913	;	! I !       10       !       20       !       40        !
							; 914	;	! P !                !                !                 !
							; 915	;	!=======================================================!
							; 916	;	! 0 !       0        !       0        !        0        !
							; 917	;	!-------------------------------------------------------!
							; 918	;	! 1 !   TRAP CYCLE   !     CRY 02     !    CARRY OUT    !
							; 919	;	!-------------------------------------------------------!
							; 920	;	! 2 !      AD=0      !    ADL SIGN    !      ADL=0      !
							; 921	;	!-------------------------------------------------------!
							; 922	;	! 3 !    SC SIGN     !    ADR SIGN    !      ADR=0      !
							; 923	;	!-------------------------------------------------------!
							; 924	;	! 4 !    EXECUTE     !    USER IOT    !      -USER      !
							; 925	;	!-------------------------------------------------------!
							; 926	;	! 5 !  -BUS IO BUSY  !   JFCL SKIP    !    FPD FLAG     !
							; 927	;	!-------------------------------------------------------!
							; 928	;	! 6 !   -CONTINUE    !     CRY 01     !  AC # IS ZERO   !
							; 929	;	!-------------------------------------------------------!
							; 930	;	! 7 !    -1 MSEC     !      TXXX      !  INTERRUPT REQ  !
							; 931	;	!=======================================================!
							; 932	
							; 933	SKIP/=<63:68>D,70     	;CRA2 & DPEA
							; 934		IOLGL=04	;(.NOT.USER)!(USER IOT)!(CONSOLE EXECUTE MODE)
							; 935		LLE=12		;AD LEFT .LE. 0
							; 936		CRY0=31		;AD CRY -2
							; 937		ADLEQ0=32	;ADDER LEFT = 0
							; 938		ADREQ0=33	;ADDER RIGHT = 0
							; 939		KERNEL=34	;.NOT. USER
							; 940		FPD=35		;FIRST PART DONE
							; 941		AC0=36		;AC NUMBER IS ZERO
							; 942		INT=37		;INTERRUPT REQUEST
							; 943		LE=42		;(AD SIGN)!(AD.EQ.0)
							; 944		CRY2=51		;AD CRY 02
							; 945		DP0=52		;AD SIGN
							; 946		DP18=53		;AD BIT 18
							; 947		IOT=54		;USER IOT
							; 948		JFCL=55		;JFCL SKIP
							; 949		CRY1=56		;AD CRY 1
							; 950		TXXX=57		;TEST INSTRUCTION SHOULD SKIP
							; 951		TRAP CYCLE=61	;THIS INSTRUCTION IS THE RESULT OF A
							; 952				; TRAP 1, 2, OR 3
							; 953		ADEQ0=62	;AD.EQ.0
							; 954		SC=63		;SC SIGN BIT
							; 955		EXECUTE=64	;CONSOLE EXECUTE MODE
							; 956		-IO BUSY=65	;.NOT. I/O LATCH
							; 957		-CONTINUE=66	;.NOT. CONTINUE
							; 958		-1 MS=67	;.NOT. 1 MS. TIMER
							; 959	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 24
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- TIME CONTROL			

							; 960	.TOC	"MICROCODE FIELDS -- TIME CONTROL"
							; 961	
							; 962	DT/=<109:111>D,0        ;**NOT STORED IN CRAM**
							; 963				;DEFAULT TIME FIELD (USED IN MACROS)
							; 964				; CAN BE OVERRIDDEN IN MACRO CALL
							; 965		2T=0
							; 966		3T=1
							; 967		4T=2
							; 968		5T=3
							; 969	
							; 970	
							; 971	T/=<69:71>F,DT          ;CSL5 (E601)
							; 972				;CLOCK TICKS MINUS TWO REQUIRED TO
							; 973				; DO A MICRO INSTRUCTION
							; 974		2T=0		;TWO TICKS
							; 975		3T=1		;THREE TICKS
							; 976		4T=2		;FOUR TICKS
							; 977		5T=3		;FIVE TICKS
							; 978	
							; 979	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 25
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- RANDOM CONTROL BITS			

							; 980	.TOC	"MICROCODE FIELDS -- RANDOM CONTROL BITS"
							; 981	
							; 982	CRY38/=<72>             ;DPE5
							; 983				;INJECT A CARRY INTO THE 2901 ADDER
							; 984	LOADSC/=<73>            ;DPM4
							; 985				;LOAD THE STEP COUNTER FROM THE SCAD
							; 986	LOADFE/=<74>            ;DPM4
							; 987				;LOAD THE FE REGISTER FROM THE SCAD
							; 988	FMWRITE/=<75>           ;DPE5 (E302)
							; 989				;WRITE THE RAM FILE.
							; 990	MEM/=<76>               ;DPM5 (E612) & DPE5 (E205)
							; 991				;START (OR COMPLETE) A MEMORY OR I/O CYCLE UNDER
							; 992				; CONTROL OF THE NUMBER FIELD.
							; 993	DIVIDE/=<77>            ;DPE5
							; 994				;THIS MICROINSTRUCTION IS DOING A DIVIDE
							; 995	MULTI PREC/=<78>        ;DPE5
							; 996				;MULTIPRECISION STEP IN DIVIDE, DFAD, DFSB
							; 997	MULTI SHIFT/=<79>       ;CSL5 (HAS NOTHING TO DO WITH DPE5 MULTI SHIFT)
							; 998				;FAST SHIFT
							; 999	CALL/=<80>              ;CRA2 (STACK IS ON CRA3)
							; 1000				;THIS IS A CALL
							; 1001	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 26
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1002	.TOC	"MICROCODE FIELDS -- NUMBER FIELD"
							; 1003	
							; 1004	;HERE IS THE GENERAL FIELD
							; 1005	#/=<90:107>           	;MANY PLACES
							; 1006	
							; 1007	;# REDEFINED WHEN USED AS SCAD CONTROL:
							; 1008	SCAD/=<90:92>         	;DPM3
							; 1009		A*2=0
							; 1010		A.OR.B=1
							; 1011		A-B-1=2
							; 1012		A-B=3
							; 1013		A+B=4
							; 1014		A.AND.B=5
							; 1015		A-1=6
							; 1016		A=7
							; 1017	SCADA/=<93:95>        	;DPM3
							; 1018		SC=0
							; 1019		S#=1
							; 1020		PTR44=2	;44 AND BIT 6 (SEE DPM3)
							; 1021		BYTE1=3
							; 1022		BYTE2=4
							; 1023		BYTE3=5
							; 1024		BYTE4=6
							; 1025		BYTE5=7
							; 1026	SCADB/=<96:97>        	;DPM3
							; 1027		FE=0
							; 1028		EXP=1
							; 1029		SHIFT=2
							; 1030		SIZE=3
							; 1031	S#/=<98:107>          	;DPM3
							; 1032	
							; 1033	;# REDEFINED WHEN USED AS STATE REGISTER CONTROL:
							; 1034	STATE/=<90:107>         ;NOT USED BY HARDWARE
							; 1035		SIMPLE=0	;SIMPLE INSTRUCTIONS
							; 1036		BLT=1		;BLT IN PROGRESS
							; 1037		MAP=400002	;MAP IN PROGRESS
							; 1038		SRC=3		;MOVE STRING SOURCE IN PROGRESS
							; 1039		DST=4		;MOVE STRING FILL IN PROGRESS
							; 1040		SRC+DST=5	;MOVE STRING DEST IN PROGRESS
							; 1041		DSTF=6		;FILLING DEST
							; 1042		CVTDB=7		;CONVERT DEC TO BIN
							; 1043		COMP-DST=10	;COMPARE DEST
							; 1044		EDIT-SRC=11	;EDIT SOURCE
							; 1045		EDIT-DST=12	;EDIT DEST
							; 1046		EDIT-S+D=13	;BOTH SRC AND DST POINTERS
							; 1047	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 27
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1048	;# REDEFINED WHEN USED AS WORSPACE ADDRESS
							; 1049	
							; 1050	WORK/=<98:107>        	;DPE6
							; 1051		BADW0=160	;AC BLK 7 WORD 0 (BAD DATA FROM MEMORY)
							; 1052		BADW1=161	;AC BLK 7 WORD 1 (BAD DATA FROM MEMORY)
							; 1053		MUL=200		;TEMP FOR MULTIPLY
							; 1054		DIV=201		;TEMP FOR DIVIDE
							; 1055		SV.VMA=210	;SAVE VMA
							; 1056		SV.AR=211	;SAVE AR
							; 1057		SV.ARX=212	;SAVE ARX
							; 1058		SV.BR=213	;SAVE BR
							; 1059		SV.BRX=214	;SAVE BRX
							; 1060		SBR=215		;SPT BASE REGISTER
							; 1061		CBR=216		;CST BASE ADDRESS
							; 1062		CSTM=217	;CST MASK
							; 1063		PUR=220		;PROCESS USE REGISTER
							; 1064		ADJP=221	;"P" FOR ADJBP
							; 1065		ADJS=222	;"S" FOR ADJBP
							; 1066		ADJPTR=223	;BYTE POINTER FOR ADJBP
							; 1067		ADJQ1=224	;TEMP FOR ADJBP
							; 1068		ADJR2=225	;TEMP FOR ADJBP
							; 1069		ADJBPW=226	;(BYTES/WORD) FOR ADJBP
							; 1070		HSBADR=227	;ADDRESS OF HALT STATUS BLOCK
							; 1071		APR=230		;APR ENABLES
							; 1072	;THE FOLLOWING WORDS ARE USED BY EXTEND INSTRUCTION
							; 1073		E0=240		;ORIGINAL EFFECTIVE ADDRESS
							; 1074		E1=241		;EFFECTIVE ADDRESS OF WORD AT E0
							; 1075		SLEN=242	;SOURCE LENGTH
							; 1076		MSK=243		;BYTE MASK
							; 1077		FILL=244	;FILL BYTE
							; 1078		CMS=245		;SRC BYTE IN STRING COMPARE
							; 1079		FSIG=246	;PLACE TO SAVE ARX WHILE STORING
							; 1080				; THE FLOAT CHAR
							; 1081		BDH=247		;BINARY BEING CONVERTED TO
							; 1082		BDL=250		; DECIMAL
							; 1083	
							; 1084	;TIMER STUFF
							; 1085		TIME0=300	;HIGH ORDER 36 BITS OF TIME
							; 1086		TIME1=301	;LOW ORDER 36 BITS OF TIME
							; 1087		PERIOD=302	;INTERRUPT PERIOD
							; 1088		TTG=303		;TIME TO GO TO NEXT INTERRUPT
							; 1089	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 28
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1090	;DDIV STUFF
							; 1091		AC0=314
							; 1092		AC1=315
							; 1093		AC2=316
							; 1094		AC3=317
							; 1095		DDIV SGN=320
							; 1096		DVSOR H=321
							; 1097		DVSOR L=322
							; 1098	;POWERS OF TEN
							; 1099		DECLO=344	;LOW WORD
							; 1100		DECHI=373	;HIGH WORD
							; 1101	
							; 1102		YSAVE=422	;Y OF LAST INDIRECT POINTER
							; 1103		PTA.E=423	;ADDRESS OF EXEC PAGE MAP (NOT PROCESS TABLE)
							; 1104		PTA.U=424	;ADDRESS OF USER PAGE MAP
							; 1105		TRAPPC=425	;SAVED PC FROM TRAP CYCLE
							; 1106		SV.AR1=426	;ANOTHER PLACE TO SAVE AR
							; 1107	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 29
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1108	;# REDEFINED WHEN USED AS PC FLAG CONTROL (ALL ON DPE9)
							; 1109	
							; 1110	SETOV/=<90>             ;DPE9
							; 1111				;SET ARITHMETIC OVERFLOW
							; 1112	SETFOV/=<91>            ;SET FLOATING OVERFLOW
							; 1113	SETNDV/=<92>            ;SET NO DIVIDE
							; 1114	
							; 1115	;---------------------------------------------------------------------
							; 1116	
							; 1117	CLRFPD/=<93>            ;CLEAR FIRST PART DONE
							; 1118	SETFPD/=<94>            ;SET FIRST PART DONE
							; 1119	HOLD USER/=<95>         ;WHEN THIS BIT IS SET IT:
							; 1120				; 1. PREVENTS SETTING USER IOT IN USER MODE
							; 1121				; 2. PREVENTS CLEARING USER IN USER MODE
							; 1122	
							; 1123	;---------------------------------------------------------------------
							; 1124	
							; 1125	;	<96>		;SPARE
							; 1126	TRAP2/=<97>             ;SET TRAP 2
							; 1127	TRAP1/=<98>             ;SET TRAP 1
							; 1128	
							; 1129	;---------------------------------------------------------------------
							; 1130	
							; 1131	LD PCU/=<99>            ;LOAD PCU FROM USER
							; 1132	;	<100>		;SPARE
							; 1133	;	<101>		;SPARE
							; 1134	
							; 1135	;---------------------------------------------------------------------
							; 1136	
							; 1137	;	<102>		;SPARE
							; 1138	;	<103>		;SPARE
							; 1139	JFCLFLG/=<104>          ;DO A JFCL INSTRUCTION
							; 1140	
							; 1141	;---------------------------------------------------------------------
							; 1142	
							; 1143	LD FLAGS/=<105>         ;LOAD FLAGS FROM DP
							; 1144	;	<106>
							; 1145	ADFLGS/=<107>           ;UPDATE CARRY FLAGS
							; 1146	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 30
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1147	;# REDEFINED WHEN USED AS MEMORY CYCLE CONTROL
							; 1148	
							; 1149	FORCE USER/=<90>        ;FORCE USER MODE REFERENCE
							; 1150	FORCE EXEC/=<91>        ;FORCE EXEC MODE REFERENCE
							; 1151				; (DOES NOT WORK UNDER PXCT)
							; 1152	FETCH/=<92>             ;THIS IS AN INSTRUCTION FETCH
							; 1153	
							; 1154	;---------------------------------------------------------------------
							; 1155	
							; 1156	READ CYCLE/=<93>        ;SELECT A READ CYCLE
							; 1157	WRITE TEST/=<94>        ;PAGE FAILE IF NOT WRITTEN
							; 1158	WRITE CYCLE/=<95>       ;SELECT A MEMORY WRITE CYCLE
							; 1159	
							; 1160	;---------------------------------------------------------------------
							; 1161	
							; 1162	;	<96>		;SPARE BIT
							; 1163	DONT CACHE/=<97>        ;DO NOT LOOK IN CACHE
							; 1164	PHYSICAL/=<98>          ;DO NOT INVOKE PAGING HARDWARE
							; 1165	
							; 1166	;---------------------------------------------------------------------
							; 1167	
							; 1168	PXCT/=<99:101>          ;WHICH PXCT BITS TO LOOK AT
							; 1169		CURRENT=0
							; 1170		E1=1
							; 1171		D1=3
							; 1172		BIS-SRC-EA=4
							; 1173		E2=5
							; 1174		BIS-DST-EA=6
							; 1175		D2=7
							; 1176	
							; 1177	;---------------------------------------------------------------------
							; 1178	
							; 1179	AREAD/=<102>            ;LET DROM SELECT SYSLE TYPE AND VMA LOAD
							; 1180	DP FUNC/=<103>          ;IGNORE # BITS 0-11 AND USE DP 0-13 INSTEAD
							; 1181				; DP9 MEANS "FORCE PREVIOUS"
							; 1182	LDVMA/=<104>            ;LOAD THE VMA
							; 1183	
							; 1184	;---------------------------------------------------------------------
							; 1185	
							; 1186	EXT ADR/=<105>          ;PUT VMA BITS 14-17 ONTO BUS
							; 1187	WAIT/=<106>             ;START A MEMORY OR I/O CYCLE
							; 1188	BWRITE/=<107>           ;START A MEMORY CYCLE IF DROM ASKS FOR IT
							; 1189	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 31
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1190	;THESE BITS ARE USED ONLY TO SETUP DP FOR A DP FUNCTION
							; 1191	
							; 1192	;	<99>		;PREVIOUS
							; 1193	IO CYCLE/=<100>         ;THIS IS AN I/O CYCLE
							; 1194	WRU CYCLE/=<101>        ;WHO ARE YOU CYCLE
							; 1195	
							; 1196	;---------------------------------------------------------------------
							; 1197	
							; 1198	VECTOR CYCLE/=<102>     ;READ INTERRUPT VECTOR
							; 1199	IO BYTE/=<103>          ;BYTE CYCLE
							; 1200	;	<104>
							; 1201	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 32
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1202	;# REDEFINED WHEN USED AS PI RIGHT BITS
							; 1203	PI.ZER/=<90:92>         ;ZEROS
							; 1204	PI.IP1/=<93>            ;PI 1 IN PROG
							; 1205	PI.IP2/=<94>
							; 1206	PI.IP3/=<95>
							; 1207	PI.IP4/=<96>
							; 1208	PI.IP5/=<97>
							; 1209	PI.IP6/=<98>
							; 1210	PI.IP7/=<99>
							; 1211	PI.ON/=<100>            ;SYSTEM IS ON
							; 1212	PI.CO1/=<101>           ;CHAN 1 IS ON
							; 1213	PI.CO2/=<102>
							; 1214	I.CO3/=<103>
							; 1215	I.CO4/=<104>
							; 1216	I.CO5/=<105>
							; 1217	I.CO6/=<106>
							; 1218	I.CO7/=<107>
							; 1219	
							; 1220	;# REDEFINED WHEN USED AS WRPI DATA
							; 1221	PI.MBZ/=<90:93>         ;MUST BE ZERO
							; 1222	PI.DIR/=<94>            ;DROP INTERRUPT REQUESTS
							; 1223	PI.CLR/=<95>            ;CLEAR SYSTEM
							; 1224	PI.REQ/=<96>            ;REQUEST INTERRUPT
							; 1225	PI.TCN/=<97>            ;TURN CHANNEL ON
							; 1226	PI.TCF/=<98>            ;TURN CHANNEL OFF
							; 1227	PI.TSF/=<99>            ;TURN SYSTEM OFF
							; 1228	PI.TSN/=<100>           ;TURN SYSTEM ON
							; 1229	PI.SC1/=<101>           ;SELECT CHANNEL 1
							; 1230	PI.SC2/=<102>
							; 1231	PI.SC3/=<103>
							; 1232	PI.SC4/=<104>
							; 1233	PI.SC5/=<105>
							; 1234	PI.SC6/=<106>
							; 1235	PI.SC7/=<107>
							; 1236	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 33
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1237	;# REDEFINED WHEN USED AS AC CONTROL
							; 1238	
							; 1239	
							; 1240	;THIS FIELD CONTROLS THE INPUT TO A 74LS181 ON DPE6. THE NUMBER
							; 1241	; FIELD HAS THIS FORMAT IN <98:107>:
							; 1242	;
							; 1243	;	!-----!-----!-----!-----!-----!-----!-----!-----!-----!-----!
							; 1244	;	!CARRY! S8  !  S4 ! S2  !  S1 ! MODE! B8  ! B4  !  B2 ! B1  !
							; 1245	;	!  IN !       FUNCTION        !     !      DATA INPUTS      !
							; 1246	;	!-----!-----------------------!-----!-----------------------!
							; 1247	;
							; 1248	
							; 1249	ACALU/=<98:103>       	
							; 1250		B=25
							; 1251		AC+N=62
							; 1252	ACN/=<104:107>
							; 1253				;AC NAMES FOR STRING INSTRUCTIONS
							; 1254		SRCLEN=0	;SOURCE LENGTH
							; 1255		SRCP=1		;SOURCE POINTER
							; 1256		DLEN=3		;DEST LENGTH
							; 1257		DSTP=4		;DEST POINTER
							; 1258		MARK=3		;POINTER TO MARK
							; 1259		BIN0=3		;HIGH WORD OF BINARY
							; 1260		BIN1=4		;LOW WORD OF BINARY
							; 1261	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 34
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1262	;# FIELD REDEFINED WHEN USE AS APRID DATA
							; 1263	MICROCODE OPTIONS/=<90:98>
							; 1264	;100	- NON-STANDARD MICROCODE
							; 1265	;200	- NO CST AT ALL
							; 1266	;400	- INHIBIT CST UPDATE IS AVAILABLE
							; 1267	;040	- UBABLT INSTRUCTIONS ARE PRESENT
							; 1268	;020	- KI PAGING IS PRESENT
							; 1269	;010	- KL PAGING IS PRESENT
							; 1270	MICROCODE OPTION(INHCST)/=<90>
							; 1271	.IF/INHCST
							; 1272		OPT=1
							;;1273	.IFNOT/INHCST
							;;1274		OPT=0
							; 1275	.ENDIF/INHCST
							; 1276	MICROCODE OPTION(NOCST)/=<91>
							;;1277	.IF/NOCST
							;;1278		OPT=1
							; 1279	.IFNOT/NOCST
							; 1280		OPT=0
							; 1281	.ENDIF/NOCST
							; 1282	MICROCODE OPTION(NONSTD)/=<92>
							;;1283	.IF/NONSTD
							;;1284		OPT=1
							; 1285	.IFNOT/NONSTD
							; 1286		OPT=0
							; 1287	.ENDIF/NONSTD
							; 1288	MICROCODE OPTION(UBABLT)/=<93>
							; 1289	.IF/UBABLT
							; 1290		OPT=1
							;;1291	.IFNOT/UBABLT
							;;1292		OPT=0
							; 1293	.ENDIF/UBABLT
							; 1294	MICROCODE OPTION(KIPAGE)/=<94>
							; 1295	.IF/KIPAGE
							; 1296		OPT=1
							;;1297	.IFNOT/KIPAGE
							;;1298		OPT=0
							; 1299	.ENDIF/KIPAGE
							; 1300	MICROCODE OPTION(KLPAGE)/=<95>
							; 1301	.IF/KLPAGE
							; 1302		OPT=1
							;;1303	.IFNOT/KLPAGE
							;;1304		OPT=0
							; 1305	.ENDIF/KLPAGE
							; 1306	
							; 1307	MICROCODE VERSION/=<99:107>
							; 1308		UCV=130
							; 1309	
							; 1310	MICROCODE RELEASE(MAJOR)/=<99:104>
							; 1311		UCR=2		;MAJOR VERSION NUMBER (1,2,3,....)
							; 1312	
							; 1313	MICROCODE RELEASE(MINOR)/=<105:107>
							; 1314		UCR=1		;MINOR VERSION NUMBER (.1,.2,.3,...)
							; 1315	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 35
; KS10.MIC[1,2]	11:18 17-APR-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1316	;# FIELD REDEFINED WHEN USED AS A HALT CODE
							; 1317	
							; 1318	HALT/=<90:107>
							; 1319				;CODES 0 TO 77 ARE "NORMAL" HALTS
							; 1320		POWER=0		;POWER UP
							; 1321		HALT=1		;HALT INSTRUCTION
							; 1322		CSL=2		;CONSOLE HALT
							; 1323				;CODES 100 TO 777 ARE SOFTWARE ERRORS
							; 1324		IOPF=100	;I/O PAGE FAIL
							; 1325		ILLII=101	;ILLEGAL INTERRUPT INSTRUCTION
							; 1326		ILLINT=102	;BAD POINTER TO UNIBUS INTERRUPT VECTOR
							; 1327				;CODES 1000 TO 1777 ARE HARDWARE ERRORS
							; 1328		BW14=1000	;ILLEGAL BWRITE FUNCTION (BAD DROM)
							; 1329		NICOND 5=1004	;ILLEGAL NICOND DISPATCH
							; 1330		MULERR=1005	;VALUE COMPUTED FOR 10**21 WAS WRONG
							;;1331	.IFNOT/FULL
							;;1332		PAGEF=1777	;PAGE FAIL IN SMALL MICROCODE
							; 1333	.ENDIF/FULL
							; 1334	
							; 1335	
							; 1336	
							; 1337	;# FIELD REDEFINED WHEN USED AS FLG BITS
							; 1338	
							; 1339	FLG.W/=<94>             ;W BIT FROM PAGE MAP
							; 1340	FLG.PI/=<95>            ;PI CYCLE
							; 1341	FLG.C/=<96>             ;CACHE BIT FROM PAGE MAP
							; 1342	FLG.SN/=<97>		;SPECIAL NEGATE IN FDV & DFDV
							; 1343	
							; 1344	;RIGHT HALF OF FLG USED TO RECOVER FROM PAGE FAILS
							; 1345	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 36
; KS10.MIC[1,2]	11:18 17-APR-2015				DISPATCH ROM DEFINITIONS				

							; 1346	.TOC	"DISPATCH ROM DEFINITIONS"
							; 1347	
							; 1348	;ALL ON DPEA
							; 1349	
							; 1350		.DCODE
							; 1351	A/=<2:5>                ;OPERAND FETCH MODE
							; 1352		READ=0		;READ
							; 1353		WRITE=1		;WRITE
							; 1354		DREAD=2		;DOUBLE READ
							; 1355		DBLAC=3		;DOUBLE AC
							; 1356		SHIFT=4		;SIMPLE SHIFT
							; 1357		DSHIFT=5	;DOUBLE SHIFT
							; 1358		FPI=6		;FLOATING POINT IMMEDIATE
							; 1359		FP=7		;FLOATING POINT
							; 1360		RD-PF=10	;READ, THEN START PREFETCH
							; 1361		DFP=11		;DOUBLE FLOATING POINT
							; 1362		IOT=12		;CHECK FOR IO LEGAL THEN SAME AS I
							; 1363	
							; 1364	B/=<8:11>               ;STORE RESULTS AS
							; 1365		SELF=4		;SELF
							; 1366		DBLAC=5		;DOUBLE AC
							; 1367		DBLB=6		;DOUBLE BOTH
							; 1368		AC=15		;AC
							; 1369		MEM=16		;MEMORY
							; 1370		BOTH=17		;BOTH
							; 1371	
							; 1372	;B-FIELD WHEN USED IN FLOATING POINT OPERATIONS
							; 1373	ROUND/=<8>              ;ROUND THE RESULT
							; 1374	MODE/=<9>               ;SEPARATE ADD/SUB & MUL/DIV ETC.
							; 1375	FL-B/=<10:11>           ;STORE RESULTS AS
							; 1376		AC=1		;AC
							; 1377		MEM=2		;MEMORY
							; 1378		BOTH=3		;BOTH
							; 1379	
							; 1380	J/=<12:23>              ;DISPATCH ADDRESS (MUST BE 1400 TO 1777)
							; 1381	
							; 1382	ACDISP/=<24>            ;DISPATCH ON AC FIELD
							; 1383	I/=<25>                 ;IMMEDIATE DISPATCH. DISP/AREAD DOES A DISP/DROM
							; 1384				; IF THIS BIT IS SET.
							; 1385	READ/=<26>              ;START A READ AT AREAD
							; 1386	TEST/=<27>              ;START A WRITE TEST  AT AREAD
							; 1387	COND FUNC/=<28>       	;START A MEMORY CYCLE ON BWRITE
							; 1388	VMA/=<29>D,1            ;LOAD THE VMA ON AREAD
							; 1389	WRITE/=<30>           	;START A WRITE ON AREAD
							; 1390		.UCODE
							; 1391	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 37
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ MACROS					

							; 1392	.TOC	"HOW TO READ MACROS"
							; 1393	;		
							; 1394	;		1.0  REGISTER TRANSFER MACROS
							; 1395	;		
							; 1396	;		MOST MACROS USED IN THE KS10 ARE USED TO OPERATE ON DATA IN  (OR  FROM/TO)  2901
							; 1397	;		REGISTERS.   THE  NAMES  OF  THE  2901  REGISTERS  ARE  MACRO PARAMETERS AND ARE
							; 1398	;		ENCLOSED IN [].  A TYPICAL MACRO IS:
							; 1399	;		
							; 1400	;		        [AR]_[AR]+[BR]
							; 1401	;		
							; 1402	;		THE SYMBOL _ IS PRONOUNCED "GETS".  THE ABOVE MACRO WOULD BE READ "THE  AR  GETS
							; 1403	;		THE AR PLUS THE BR".
							; 1404	;		
							; 1405	;		IF A MACRO DOES NOT HAVE A _ IN IT, THERE IS NO RESULT STORED.  THUS,  [AR]-[BR]
							; 1406	;		JUST COMPARES THE AR AND THE BR AND ALLOWS FOR SKIPS ON THE VARIOUS ALU BITS.
							; 1407	;		
							; 1408	;		
							; 1409	;		
							; 1410	;		1.1  SPECIAL SYMBOLS
							; 1411	;		
							; 1412	;		THERE ARE A BUNCH OF SYMBOLS USED IN THE MACROS WHICH ARE  NOT  2901  REGISTERS.
							; 1413	;		THEY ARE DEFINED HERE:
							; 1414	;		
							; 1415	;		     1.  AC -- THE AC SELECTED BY THE CURRENT INSTRUCTION.  SEE DPEA
							; 1416	;		
							; 1417	;		     2.  AC[] -- AC+N.  AC[1] IS AC+1, AC[2] IS AC+2, ETC.
							; 1418	;		
							; 1419	;		     3.  APR -- THE APR FLAGS FROM DPMA
							; 1420	;		
							; 1421	;		     4.  EA -- THE EFFECTIVE ADDRESS.  THAT IS, 0  IN  THE  LEFT  HALF  AND  THE
							; 1422	;		         CONTENTS OF THE HR IN THE RIGHT HALF.
							; 1423	;		
							; 1424	;		     5.  EXP -- THE F.P.  EXPONENT  FROM  THE  SCAD.   [AR]_EXP  WILL  TAKE  THE
							; 1425	;		         EXPONENT OUT OF THE FE AND PUT IT BACK INTO THE NUMBER IN THE AR.
							; 1426	;		
							; 1427	;		     6.  FE -- THE FE REGISTER
							; 1428	;		
							; 1429	;		     7.  FLAGS -- THE PC FLAGS (FROM DPE9) IN THE LEFT HALF.
							; 1430	;		
							; 1431	;		     8.  Q -- THE Q REGISTER
							; 1432	;		
							; 1433	;		     9.  RAM -- THE RAM FILE, RAM ADDRESS IS IN THE VMA.
							; 1434	;		
							; 1435	;		    10.  P -- THE P FIELD OF THE BYTE POINTER.  SAME IDEA AS EXP.
							; 1436	;		
							; 1437	;		    11.  TIME -- THE 1MS.  TIMER
							; 1438	;		
							; 1439	;		    12.  VMA -- THE VMA.  WHEN READ IT INCLUDES THE VMA FLAGS
							; 1440	;		
							; 1441	;		    13.  XR -- INDEX REGISTER
							; 1442	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 38
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ MACROS					

							; 1443	;		    14.  XWD -- HALF WORD.  USED TO GENERATE CONSTANTS.  FOR EXAMPLE, [AR]_0 XWD
							; 1444	;		         [40] WOULD LOAD THE CONSTANT 40 (OCTAL) INTO THE AR.
							; 1445	;		
							; 1446	;		    15.  +SIGN AND -SIGN -- SIGN BITS USED TO SIGN  SMEAR  F.P.   NUMBERS.   FOR
							; 1447	;		         EXAMPLE, [AR]_+SIGN WOULD CLEAR AR BITS 0 TO 8.
							; 1448	;		
							; 1449	;		    16.  WORK[] -- LOCATIONS IN  THE  WORKSPACE  USED  AS  SCRATCH  SPACE.   FOR
							; 1450	;		         EXAMPLE,  [AR]_WORK[CSTM]  WOULD LOAD THE AR WITH THE CST MASK FROM THE
							; 1451	;		         RAM.  CSTM IS A SYMBOL DEFINED IN THE WORK FIELD.
							; 1452	;		
							; 1453	;		
							; 1454	;		
							; 1455	;		
							; 1456	;		1.2  LONG
							; 1457	;		
							; 1458	;		LONG IS USED ON SHIFT OPERATIONS  TO  INDICATE  THAT  THE  Q  REGISTER  IS  ALSO
							; 1459	;		SHIFTED.  THIS SAYS NOTHING ABOUT HOW THE SHIFT PATHS ARE CONNECTED UP.
							; 1460	;		
							; 1461	;		
							; 1462	;		
							; 1463	;		2.0  MEMORY MACROS
							; 1464	;		
							; 1465	;		MEMORY IS INDICATED BY THE SYMBOL "MEM".  WHEN WE  ARE  WAITING  FOR  DATA  FROM
							; 1466	;		MEMORY  THE  "MEM  READ" MACRO IS USED.  WHEN WE ARE SENDING DATA TO MEMORY, THE
							; 1467	;		"MEM WRITE" MACRO IS USED.  EXAMPLE,
							; 1468	;		        MEM READ,               ;WAIT FOR MEMORY
							; 1469	;		        [AR]_MEM                ;LOAD DATA INTO AR
							; 1470	;		VMA_ IS USED THE LOAD THE VMA.  THUS, VMA_[PC] LOADS THE VMA FROM THE PC.
							; 1471	;		
							; 1472	;		
							; 1473	;		
							; 1474	;		3.0  TIME CONTROL
							; 1475	;		
							; 1476	;		THERE ARE 2 SETS OF MACROS USED FOR TIME CONTROL.  THE FIRST,  SELECTS  THE  RAM
							; 1477	;		ADDRESS  TO  SPEED UP THE NEXT INSTRUCTION.  THESE MACROS ARE AC, AC[], XR, VMA,
							; 1478	;		WORK[].  THE SECOND, SETS THE TIME FIELD.  THESE ARE  2T,  3T,  4T,  AND  5T  TO
							; 1479	;		SELECT 2, 3, 4, OR 5 TICKS.
							; 1480	;		
							; 1481	;		
							; 1482	;		
							; 1483	;		4.0  SCAD MACROS
							; 1484	;		
							; 1485	;		THE SCAD MACROS LOOK LIKE THE 2901 MACROS EXECPT NO [] ARE REQUIRED.  THERE  ARE
							; 1486	;		ONLY A FEW SYMBOLS USED.
							; 1487	;		
							; 1488	;		     1.  FE -- THE FE REGISTER
							; 1489	;		
							; 1490	;		     2.  SC -- THE SC REGISTER
							; 1491	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 39
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ MACROS					

							; 1492	;		     3.  EXP -- THE EXPONENT FROM A F.P.  NUMBER.  FOR EXAMPLE FE_EXP LOADS  THE
							; 1493	;		         FE FROM DP BITS 1-8.
							; 1494	;		
							; 1495	;		     4.  SHIFT -- THE SHIFT COUNT FROM SHIFT INSTRUCTIONS.  THAT IS DP  BITS  18
							; 1496	;		         AND 28-35.
							; 1497	;		
							; 1498	;		     5.  S# -- THE SMALL NUMBER.  THE 10 BIT MAGIC NUMBER  INPUT  TO  THE  SCADA
							; 1499	;		         MIXER.
							; 1500	;		
							; 1501	;		
							; 1502	;		
							; 1503	;		
							; 1504	;		5.0  CONTROL MACROS
							; 1505	;		
							; 1506	;		ALL CONTROL MACROS LOOK LIKE ENGLISH COMMANDS.  SOME EXAMPLES,
							; 1507	;		        HOLD LEFT               ;DO NOT CLOCK LEFT HALF OF DP
							; 1508	;		        SET APR ENABLES         ;LOAD APR ENABLES FROM DP
							; 1509	;		        SET NO DIVIDE           ;SET NO DIVIDE PC FLAG
							; 1510	;		
							; 1511	;		
							; 1512	;		
							; 1513	;		6.0  SKIPS
							; 1514	;		
							; 1515	;		ALL SKIPS CAUSE THE NEXT MICRO INSTRUCTION TO COME  FROM  THE  ODD  WORD  OF  AN
							; 1516	;		EVEN/ODD PAIR.  THE MACROS HAVE THE FORMAT OF SKIP COND.  THEY SKIP IF CONDITION
							; 1517	;		IS TRUE.  SOME EXAMPLES,
							; 1518	;		        SKIP AD.EQ.0            ;SKIP IF ADDER OUTPUT IS ZERO
							; 1519	;		        SKIP IRPT               ;SKIP IF INTERRUPT IS PENDING
							; 1520	;		
							; 1521	;		
							; 1522	;		
							; 1523	;		7.0  DISPATCH MACROS
							; 1524	;		
							; 1525	;		DISPATCH MACROS CAUSE THE MACHINE TO GO TO ONE OF MANY PLACES.   IN  MOST  CASES
							; 1526	;		THEY HAVE THE WORD "DISP" IN THE NAME OF THE MACRO.  FOR EXAMPLE, MUL DISP, BYTE
							; 1527	;		DISP.
							; 1528	;		
							; 1529	;		
							; 1530	;		
							; 1531	;		8.0  SUPER MACROS
							; 1532	;		
							; 1533	;		THERE ARE PLACES WHERE ONE MICRO  INSTRUCTION  IS  USED  IN  MANY  PLACES.   FOR
							; 1534	;		EXAMPLE,  MANY  PLACES  DETECT ILLEGAL OPERATIONS AND WANT TO GENERATE A TRAP TO
							; 1535	;		THE MONITOR.  WE COULD WRITE
							; 1536	;		        J/UUO
							; 1537	;		BUT THIS WASTES A MICRO STEP DOING A USELESS JUMP.  INSTEAD WE WRITE,
							; 1538	;		        UUO
							; 1539	;		THIS MACRO IS THE FIRST STEP  OF  THE  UUO  ROUTINE  AND  JUMPS  TO  THE  SECOND
							; 1540	;		INSTRUCTION.   WE  WRITE THE EXPANSION OF THE UUO MACRO AS THE FIRST INSTRUCTION
							; 1541	;		OF THE UUO ROUTINE SO THAT THE READER CAN SEE WHAT IT DOES.   SOME  EXAMPLES  OF
							; 1542	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 40
; KS10.MIC[1,2]	11:18 17-APR-2015				HOW TO READ MACROS					

							; 1543	;		SUPER MACROS ARE:
							; 1544	;		        PAGE FAIL TRAP          ;GENERATE A PAGE FAIL TRAP
							; 1545	;		        DONE                    ;THIS INSTRUCTION IS NOW COMPLETE
							; 1546	;		                                ; USED WITH A SKIP OR DISP WHERE
							; 1547	;		                                ; SOME PATHS ARE NOP'S
							; 1548	;		        HALT []                 ;JUMP TO HALT LOOP. ARGUMENT IS A
							; 1549	;		                                ; CODE
							; 1550	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 41
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- DATA PATH CHIP -- GENERAL			

							; 1551	.TOC	"MACROS -- DATA PATH CHIP -- GENERAL"
							; 1552	
							; 1553	.NOT.[] 	"AD/.NOT.A,A/@1"
							; 1554	[]+[]		"AD/A+B,A/@1,B/@2"
							; 1555	[]-[]		"AD/A-B-.25,A/@1,B/@2,ADD .25"
							; 1556	[]-#		"AD/A-D-.25,DBUS/DBM,DBM/#,A/@1,ADD .25"
							; 1557	[].AND.#	"AD/D.AND.A,DBUS/DBM,DBM/#,A/@1"
							; 1558	[].AND.Q	"AD/A.AND.Q,A/@1,DEST/PASS"
							; 1559	[].AND.[]	"AD/A.AND.B,A/@2,B/@1,DEST/PASS"
							; 1560	[].AND.NOT.[]	"AD/.NOT.A.AND.B,A/@2,B/@1,DEST/PASS"
							; 1561	[].OR.[]	"AD/A.OR.B,A/@2,B/@1,DEST/PASS"
							; 1562	[].XOR.#	"AD/D.XOR.A,DBUS/DBM,DBM/#,A/@1"
							; 1563	[].XOR.[]	"AD/A.XOR.B,A/@2,B/@1,DEST/PASS"
							; 1564	[]_#-[]		"AD/D-A-.25,DEST/AD,A/@2,B/@1,DBUS/DBM,DBM/#,ADD .25"
							; 1565	[]_#		"AD/D,DBUS/DBM,DBM/#,DEST/AD,B/@1"
							; 1566	[]_-1		"AD/-A-.25,A/ONE,DEST/AD,B/@1,ADD .25"
							; 1567	[]_-2		"AD/-A-.25,DEST/AD*2,A/ONE,B/@1,ADD .25"
							; 1568	[]_-Q		"AD/-Q-.25,DEST/AD,B/@1,ADD .25"
							; 1569	[]_-Q*2		"AD/-Q-.25,DEST/AD*2,B/@1,ADD .25"
							; 1570	[]_-Q*.5	"AD/-Q-.25,DEST/AD*.5,B/@1,ADD .25"
							; 1571	[]_-[]		"AD/-A-.25,A/@2,DEST/AD,B/@1,ADD .25"
							; 1572	[]_-[]-.25	"AD/-A-.25,A/@2,DEST/AD,B/@1"
							; 1573	[]_-[]*2	"AD/-A-.25,A/@2,DEST/AD*2,B/@1,ADD .25"
							; 1574	[]_.NOT.AC	"AD/.NOT.D,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1"
							; 1575	[]_.NOT.AC[]	"AD/.NOT.D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,DT/3T"
							; 1576	[]_.NOT.Q	"AD/.NOT.Q,DEST/AD,B/@1"
							; 1577	[]_.NOT.[]	"AD/.NOT.A,A/@2,DEST/AD,B/@1"
							; 1578	[]_0		"AD/ZERO,DEST/AD,B/@1"
							; 1579	[]_0*.5 LONG	"AD/ZERO,DEST/Q_Q*.5,B/@1"
							; 1580	[]_0 XWD []	"AD/47,DEST/AD,B/@1,DBM/#,DBUS/DBM,#/@2,RSRC/DA,A/MASK"
							; 1581	[]_AC		"AD/D,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,AD PARITY"
							; 1582	[]_-AC		"AD/-D-.25,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,ADD .25"
							; 1583	[]_-AC[]	"AD/-D-.25,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,ADD .25,DT/3T"
							; 1584	[]_AC*.5	"AD/D,DBUS/RAM,RAMADR/AC#,DEST/AD*.5,B/@1,DT/3T"
							; 1585	[]_AC*.5 LONG	"AD/D,DBUS/RAM,RAMADR/AC#,DEST/Q_Q*.5,B/@1,DT/3T"
							; 1586	[]_AC*2 	"AD/D,DBUS/RAM,RAMADR/AC#,DEST/AD*2,B/@1,DT/3T"
							; 1587	[]_AC+1 	"AD/D+A,DBUS/RAM,RAMADR/AC#,A/ONE,DEST/AD,B/@1"
							; 1588	[]_AC+1000001	"AD/D+A,DBUS/RAM,RAMADR/AC#,A/XWD1,DEST/AD,B/@1"
							; 1589	[]_AC+[]	"AD/D+A,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,DT/3T"
							; 1590	[]_AC-1 	"AD/D-A-.25,DBUS/RAM,RAMADR/AC#,A/ONE,DEST/AD,B/@1,ADD .25"
							; 1591	[]_AC-[]	"AD/D-A-.25,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,ADD .25"
							; 1592	[]_AC-[]-.25	"AD/D-A-.25,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1"
							; 1593	[]_AC[]-[]	"AD/D-A-.25,A/@3,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,ADD .25,DT/3T"
							; 1594	[]_AC[]-1	"AD/D-A-.25,A/ONE,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,ADD .25,DT/3T"
							; 1595	[]_AC[].AND.[]	"AD/D.AND.A,A/@3,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,DT/3T"
							; 1596	[]_AC.AND.MASK	"AD/D.AND.A,A/MASK,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,AD PARITY"
							; 1597	[]_AC[]		"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,AD PARITY,DT/3T"
							; 1598	[]_AC[]*2	"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD*2,B/@1,AD PARITY,DT/3T"
							; 1599	[]_AC[]*.5	"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD*.5,B/@1,AD PARITY,DT/3T"
							; 1600	[]_APR		"AD/D,DBUS/DBM,DBM/APR FLAGS,DEST/AD,B/@1,DT/3T"
							; 1601	[]_CURRENT AC [] "AD/D,DBUS/RAM,RAMADR/#,ACALU/B,ACN/@2,DEST/AD,B/@1,AD PARITY,DT/3T"
							; 1602	[]_EA FROM []	"AD/57,RSRC/0A,A/@2,DEST/AD,B/@1"
							; 1603	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 42
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- DATA PATH CHIP -- GENERAL			

							; 1604	[]_EA		"AD/57,RSRC/0A,A/HR,DEST/AD,B/@1"
							; 1605	[]_EXP		"AD/D,DBUS/DBM,DBM/EXP,A/@1,B/@1,DEST/A,SCAD/A+B,SCADA/S#,S#/0,SCADB/FE,HOLD RIGHT,EXP TEST"
							; 1606	[]_FE		"AD/D,DEST/AD*.5,B/@1,DBUS/DBM,DBM/DP,SCAD/A+B,SCADA/S#,S#/0,SCADB/FE,BYTE/BYTE5"
							; 1607	[]_FLAGS	"AD/D.AND.A,DBUS/PC FLAGS,A/MASK,DEST/AD,B/@1,RSRC/0Q"
							; 1608	[]_P		"AD/D,DEST/A,A/@1,B/@1,DBUS/DBM,DBM/DP,BYTE/BYTE1,SCAD/A+B,SCADA/S#,S#/0,SCADB/FE"
							; 1609	[]_PC WITH FLAGS "AD/D,DBUS/PC FLAGS,RSRC/0A,A/PC,DEST/AD,B/@1"
							; 1610	[]_Q		"AD/Q,DEST/AD,B/@1"
							; 1611	[]_Q*.5		"AD/Q,DEST/AD*.5,B/@1"
							; 1612	[]_Q*2		"AD/Q,DEST/AD*2,B/@1"
							; 1613	[]_Q*2 LONG	"AD/Q,DEST/Q_Q*2,B/@1"
							; 1614	[]_Q+1		"AD/A+Q,A/ONE,DEST/AD,B/@1"
							; 1615	[]_RAM		"AD/D,DBUS/RAM,RAMADR/RAM,DEST/AD,B/@1,AD PARITY"
							; 1616	[]_TIME		"AD/44,RSRC/DA,A/MASK,DBUS/DBM,DBM/EXP,DEST/AD,B/@1"
							; 1617	[]_VMA		"AD/D,DEST/AD,B/@1,DBUS/DBM,DBM/VMA"
							; 1618	[]_XR		"AD/D,DBUS/RAM,RAMADR/XR#,DEST/AD,B/@1"
							; 1619	[]_[]		"AD/A,A/@2,DEST/AD,B/@1"
							; 1620	[]_[] SWAP	"AD/D,DBUS/DBM,DBM/DP SWAP,DEST/A,A/@2,B/@1"
							; 1621	[]_[] XWD 0	"AD/45,DEST/AD,B/@1,DBM/#,DBUS/DBM,#/@2,RSRC/D0,A/MASK"
							; 1622	[]_[]*.5	"AD/A,A/@2,DEST/AD*.5,B/@1"
							; 1623	[]_[]*.5 LONG	"AD/A,A/@2,DEST/Q_Q*.5,B/@1"
							; 1624	[]_[]*2 	"AD/A,A/@2,DEST/AD*2,B/@1"
							; 1625	[]_[]*2 LONG	"AD/A,A/@2,DEST/Q_Q*2,B/@1"
							; 1626	[]_[]*4 	"AD/A+B,A/@2,B/@1,DEST/AD*2"
							; 1627	[]_[]+# 	"AD/D+A,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1"
							; 1628	[]_[]+.25	"AD/0+A,A/@2,DEST/AD,B/@1, ADD .25"
							; 1629	[]_[]+0		"AD/0+A,A/@2,DEST/AD,B/@1"
							; 1630	[]_[]+1 	"AD/A+B,A/ONE,B/@1,B/@2,DEST/AD"
							; 1631	[]_[]+1000001	"AD/D+A,A/@2,DBUS/DBM,DBM/#,#/1,DEST/AD,B/@1"
							; 1632	[]_[]+AC	"AD/D+A,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1"
							; 1633	[]_[]+AC[]	"AD/D+A,A/@2,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@3,DEST/AD,B/@1,DT/3T"
							; 1634	[]_[]+Q		"AD/A+Q,A/@2,DEST/AD,B/@1"
							; 1635	[]_[]+RAM	"AD/D+A,A/@2,DBUS/RAM,RAMADR/RAM,DEST/AD,B/@1"
							; 1636	[]_[]+XR	"AD/D+A,DBUS/RAM,RAMADR/XR#,A/@2,DEST/AD,B/@1,HOLD LEFT"
							; 1637	[]_[]+[]	"AD/A+B,A/@3,B/@1,B/@2,DEST/AD"
							; 1638	[]_[]+[]+.25	"AD/A+B,A/@3,B/@1,B/@2,DEST/AD, ADD .25"
							; 1639	[]_[]-# 	"AD/A-D-.25,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1, ADD .25"
							; 1640	[]_[]-1 	"AD/B-A-.25,B/@1,A/ONE,DEST/AD,ADD .25"
							; 1641	[]_[]-1000001	"AD/A-D-.25,A/@2,DBUS/DBM,DBM/#,#/1,DEST/AD,B/@1,ADD .25"
							; 1642	[]_[]-AC	"AD/A-D-.25,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,ADD .25"
							; 1643	[]_[]-RAM	"AD/A-D-.25,A/@2,DBUS/RAM,RAMADR/RAM,DEST/AD,B/@1,ADD .25"
							; 1644	[]_[]-[]	"AD/B-A-.25,B/@1,B/@2,A/@3,DEST/AD,ADD .25"
							; 1645	[]_[]-[] REV	"AD/A-B-.25,B/@1,B/@3,A/@2,DEST/AD,ADD .25"
							; 1646	[]_[].AND.#	"AD/D.AND.A,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1647	[]_[].AND.# CLR LH "AD/ZERO,RSRC/DA,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1648	[]_[].AND.# CLR RH "AD/D.AND.A,RSRC/0Q,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1649	[]_(AC[].AND.[])*.5 "AD/D.AND.A,DEST/AD*.5,A/@3,B/@1,RAMADR/AC*#,DBUS/RAM,ACALU/AC+N,ACN/@2"
							; 1650	[]_(Q+1)*.5	"AD/A+Q,A/ONE,DEST/AD*.5,B/@1"
							; 1651	[]_(#-[])*2	"AD/D-A-.25,DEST/AD*2,A/@2,B/@1,DBUS/DBM,DBM/#,ADD .25"
							; 1652	[]_(-[])*.5	"AD/-A-.25,A/@2,DEST/AD*.5,B/@1,ADD .25"
							; 1653	[]_(-[]-.25)*.5 LONG "AD/-A-.25,A/@2,DEST/Q_Q*.5,B/@1"
							; 1654	[]_(-[]-.25)*2 LONG "AD/-A-.25,A/@2,DEST/Q_Q*2,B/@1"
							; 1655	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 43
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- DATA PATH CHIP -- GENERAL			

							; 1656	[]_([].AND.#)*.5 "AD/D.AND.A,DBUS/DBM,DBM/#,DEST/AD*.5,A/@2,B/@1"
							; 1657	[]_([].AND.#)*2	"AD/D.AND.A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1658	[]_([].AND.NOT.#)*.5 "AD/.NOT.D.AND.A,DBUS/DBM,DBM/#,DEST/AD*.5,A/@2,B/@1"
							; 1659	[]_([].AND.NOT.#)*2	"AD/.NOT.D.AND.A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1660	[]_([].AND.[])*.5 "AD/A.AND.B,DEST/AD*.5,A/@3,B/@1,B/@2"
							; 1661	[]_([].AND.[])*2 "AD/A.AND.B,DEST/AD*2,A/@3,B/@1,B/@2"
							; 1662	[]_([].OR.#)*.5 "AD/D.OR.A,DBUS/DBM,DBM/#,DEST/AD*.5,A/@2,B/@1"
							; 1663	[]_([].OR.#)*2	"AD/D.OR.A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1664	[]_([]+#)*2	"AD/D+A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1665	[]_([]+1)*2 	"AD/A+B,A/ONE,B/@1,B/@2,DEST/AD*2"
							; 1666	[]_([]+[])*.5 LONG	"AD/A+B,A/@3,B/@1,B/@2,DEST/Q_Q*.5"
							; 1667	[]_([]+[])*2 LONG	"AD/A+B,A/@3,B/@1,B/@2,DEST/Q_Q*2"
							; 1668	[]_([]-[])*.5 LONG	"AD/B-A-.25,A/@3,B/@1,B/@2,DEST/Q_Q*.5, ADD .25"
							; 1669	[]_([]-[])*2 LONG	"AD/B-A-.25,A/@3,B/@1,B/@2,DEST/Q_Q*2, ADD .25"
							; 1670	[]_([]+[]+.25)*.5 LONG	"AD/A+B,A/@3,B/@1,B/@2,DEST/Q_Q*.5, ADD .25"
							; 1671	[]_[].AND.AC	"AD/D.AND.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1672	[]_[].AND.NOT.# "AD/.NOT.D.AND.A,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1"
							; 1673	[]_[].AND.NOT.[] "AD/.NOT.A.AND.B,DEST/AD,B/@1,B/@2,A/@3"
							; 1674	[]_[].AND.NOT.AC "AD/.NOT.D.AND.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1675	[]_[].AND.Q	"AD/A.AND.Q,A/@2,DEST/AD,B/@1"
							; 1676	[]_[].AND.[]	"AD/A.AND.B,A/@3,B/@1,B/@2,DEST/AD"
							; 1677	[]_[].EQV.AC	"AD/D.EQV.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1678	[]_[].EQV.Q	"AD/A.EQV.Q,A/@2,DEST/AD,B/@1"
							; 1679	[]_[].OR.#	"AD/D.OR.A,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1"
							; 1680	[]_[].OR.AC	"AD/D.OR.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1681	[]_[].OR.FLAGS	"AD/D.OR.A,DBUS/PC FLAGS,RSRC/0A,A/@1,DEST/AD,B/@1"
							; 1682	[]_[].OR.[]	"AD/A.OR.B,A/@3,B/@2,B/@1,DEST/AD"
							; 1683	[]_[].XOR.#	"AD/D.XOR.A,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1684	[]_[].XOR.AC	"AD/D.XOR.A,DBUS/RAM,RAMADR/AC#,A/@1,DEST/AD,B/@2"
							; 1685	[]_[].XOR.[]	"AD/A.XOR.B,A/@3,B/@1,B/@2,DEST/AD"
							; 1686	
							; 1687	[] LEFT_0	"AD/57,RSRC/0B,DEST/AD,B/@1"
							; 1688	[] RIGHT_0	"AD/53,RSRC/D0,DEST/AD,B/@1"
							; 1689	[] LEFT_-1	"AD/54,RSRC/0B,DEST/AD,A/MASK,B/@1"
							; 1690	[] RIGHT_-1	"AD/53,RSRC/0A,DEST/AD,A/MASK,B/@1"
							; 1691	
							; 1692	
							; 1693	[]_+SIGN	"[@1]_[@1].AND.#, #/777, HOLD RIGHT"
							; 1694	[]_-SIGN	"[@1]_[@1].OR.#, #/777000, HOLD RIGHT"
							; 1695	;THE FOLLOWING 2 MACROS ARE USED IN DOUBLE FLOATING STUFF
							; 1696	; THEY ASSUME THAT THE OPERAND HAS BEEN SHIFTED RIGHT 1 PLACE.
							; 1697	; THEY SHIFT 1 MORE PLACE
							; 1698	[]_+SIGN*.5	"AD/.NOT.D.AND.A,A/@1,B/@1,DEST/AD*.5,DBUS/DBM,DBM/#,#/777400,RSRC/0A"
							; 1699	[]_-SIGN*.5	"AD/D.OR.A,A/@1,B/@1,DEST/AD*.5,DBUS/DBM,DBM/#,#/777400,RSRC/0A"
							; 1700	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 44
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- DATA PATH CHIP -- Q				

							; 1701	.TOC	"MACROS -- DATA PATH CHIP -- Q"
							; 1702	
							; 1703	Q-[]		"AD/Q-A-.25,A/@1,ADD .25"
							; 1704	Q.AND.NOT.[]	"AD/.NOT.A.AND.Q,A/@1,DEST/PASS"
							; 1705	Q_[]		"AD/A,DEST/Q_AD,A/@1"
							; 1706	Q_[]-[] 	"AD/A-B-.25,A/@1,B/@2,DEST/Q_AD,ADD .25"
							; 1707	Q_[]+[] 	"AD/A+B,A/@1,B/@2,DEST/Q_AD"
							; 1708	Q_[].AND.[]	"AD/A.AND.B,A/@1,B/@2,DEST/Q_AD"
							; 1709	Q_.NOT.AC[]	"AD/.NOT.D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,DT/3T"
							; 1710	Q_-[]		"AD/-A-.25,DEST/Q_AD,A/@1, ADD .25"
							; 1711	Q_-1		"Q_-[ONE]"
							; 1712	Q_-AC[]	"AD/-D-.25,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,ADD .25,DT/3T"
							; 1713	Q_-Q		"AD/-Q-.25,ADD .25,DEST/Q_AD"
							; 1714	Q_AC		"AD/D,DBUS/RAM,RAMADR/AC#,DEST/Q_AD,CHK PARITY"
							; 1715	Q_AC[]		"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,CHK PARITY,DT/3T"
							; 1716	Q_AC[].AND.MASK	"AD/D.AND.A,A/MASK,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,CHK PARITY,DT/3T"
							; 1717	Q_AC[].AND.[]	"AD/D.AND.A,A/@2,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,CHK PARITY,DT/3T"
							; 1718	Q_.NOT.Q		"AD/.NOT.Q,DEST/Q_AD"
							; 1719	Q_#		"AD/D,DBUS/DBM,DBM/#,DEST/Q_AD"
							; 1720	Q_0		"AD/ZERO,DEST/Q_AD"
							; 1721	Q_0 XWD []	"AD/47,DEST/Q_AD,DBM/#,DBUS/DBM,#/@1,RSRC/DA,A/MASK"
							; 1722	Q_Q+.25		"AD/0+Q,DEST/Q_AD,ADD .25"
							; 1723	Q_Q+1		"AD/A+Q,A/ONE,DEST/Q_AD"
							; 1724	Q_Q-1		"AD/Q-A-.25,A/ONE,DEST/Q_AD, ADD .25"
							; 1725	Q_Q+AC		"AD/D+Q,DBUS/RAM,RAMADR/AC#,DEST/Q_AD"
							; 1726	Q_Q*.5		"[MAG]_[MASK]*.5 LONG, SHSTYLE/NORM"
							; 1727	Q_Q*2		"[MASK]_[MAG]*2 LONG, SHSTYLE/NORM"
							; 1728	Q_Q.OR.#	"AD/D.OR.Q,DBUS/DBM,DBM/#,DEST/Q_AD"
							; 1729	Q_Q.AND.#	"AD/D.AND.Q,DBUS/DBM,DBM/#,DEST/Q_AD"
							; 1730	Q_Q.AND.[]	"AD/A.AND.Q,A/@1,DEST/Q_AD"
							; 1731	Q_Q.AND.NOT.[]	"AD/.NOT.A.AND.Q,A/@1,DEST/Q_AD"
							; 1732	Q_Q+[]		"AD/A+Q,A/@1,DEST/Q_AD"
							; 1733	Q_[].AND.Q	"AD/A.AND.Q,A/@1,DEST/Q_AD"
							; 1734	Q_[].OR.Q	"AD/A.OR.Q,A/@1,DEST/Q_AD"
							; 1735	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 45
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- DATA PATH CHIP -- MISC.			

							; 1736	.TOC	"MACROS -- DATA PATH CHIP -- MISC."
							; 1737	
							; 1738	CLEAR []0	"AD/D.AND.A,A/@1,DBUS/DBM,DBM/#,#/377777,DEST/AD,B/@1,HOLD RIGHT"
							; 1739	CLEAR ARX0	"CLEAR [ARX]0"
							; 1740	
							; 1741	;CYCLE CHIP REGISTERS THRU AD SO WE CAN TEST BITS
							; 1742	READ XR		"AD/D,DBUS/RAM,RAMADR/XR#"
							; 1743	READ [] 	"AD/B,B/@1"
							; 1744	READ Q		"AD/Q"
							; 1745	
							; 1746	;TEST BITS IN REGISTERS (SKIP IF ZERO)
							; 1747	TR []		"AD/D.AND.A,DBUS/DBM,DBM/#,A/@1,SKIP ADR.EQ.0,DT/3T"
							; 1748	TL []		"AD/D.AND.A,DBUS/DBM,DBM/#,A/@1,SKIP ADL.EQ.0,DT/3T"
							; 1749	
							; 1750	
							; 1751	;CAUSE BITS -2 AND -1 TO MATCH BIT 0. 
							; 1752	FIX [] SIGN	"AD/D,DEST/A,A/@1,B/@1,DBUS/DP,HOLD RIGHT"
							; 1753	
							; 1754	;GENERATE A MASK IN Q AND ZERO A 2901 REGISTER
							; 1755	GEN MSK []	"AD/ZERO,DEST/Q_Q*2,B/@1,ONES"
							; 1756	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 46
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- STORE IN AC					

							; 1757	.TOC	"MACROS -- STORE IN AC"
							; 1758	
							; 1759	FM WRITE	"FMWRITE/1"
							; 1760	
							; 1761	AC[]_[] VIA AD	"AD/B,DEST/PASS,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,CHK PARITY"
							; 1762	AC_[] VIA AD	"AD/B,DEST/PASS,B/@1,RAMADR/AC#,DBUS/DP,FM WRITE,CHK PARITY"
							; 1763	AC[]_[]		"AD/A,DEST/A,B/@2,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1764	AC[]_[] TEST	"AD/D,DBUS/DP,DEST/A,B/@2,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1765	AC[]_[]+1	"AD/A+B,DEST/PASS,A/ONE,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1766	AC[]_[]*2	"AD/A+B,DEST/PASS,A/@2,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1767	AC_[]		"AD/A,DEST/A,B/@1,A/@1,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1768	AC_[] TEST	"AD/D,DBUS/DP,DEST/A,B/@1,A/@1,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1769	AC_[]+1		"AD/A+B,DEST/PASS,A/ONE,B/@1,RAMADR/AC#, FM WRITE"
							; 1770	AC_[]+Q		"AD/A+Q,DEST/PASS,A/@1,B/@1,RAMADR/AC#, FM WRITE"
							; 1771	AC[]_[]+Q	"AD/A+Q,DEST/PASS,A/@2,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1, FM WRITE"
							; 1772	AC[]_[]-[]	"AD/A-B-.25,DEST/PASS,B/@3,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,ADD .25"
							; 1773	AC[]_[]+[]	"AD/A+B,DEST/PASS,B/@3,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1774	AC_[]+[]	"AD/A+B,DEST/PASS,B/@2,A/@1,RAMADR/AC#,DBUS/DP,FM WRITE"
							; 1775	AC[]_[].AND.[]	"AD/A.AND.B,DEST/PASS,B/@3,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1776	AC[]_Q.AND.[]	"AD/A.AND.Q,DEST/PASS,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1777	AC[]_[].EQV.Q	"AD/A.EQV.Q,DEST/PASS,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1778	AC[]_-[]	"AD/-B-.25,DEST/PASS,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,ADD .25"
							; 1779	AC_-[]		"AD/-A-.25,DEST/PASS,A/@1,RAMADR/AC#,DBUS/DP, ADD .25,FM WRITE"
							; 1780	AC_[].OR.[]	"AD/A.OR.B,A/@1,B/@2,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1781	AC[]_.NOT.[]	"AD/.NOT.B,DEST/PASS,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1782	AC_.NOT.[]	"AD/.NOT.B,DEST/PASS,B/@1,RAMADR/AC#,DBUS/DP,FM WRITE"
							; 1783	AC[]_-Q		"AD/-Q-.25,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,ADD .25"
							; 1784	AC_Q		"AD/Q,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1785	AC[]_0		"AD/ZERO,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1786	AC[]_1		"AD/B,DEST/PASS,B/ONE,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1787	AC[]_Q		"AD/Q,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1788	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 47
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- MICROCODE WORK SPACE				

							; 1789	.TOC	"MACROS -- MICROCODE WORK SPACE"
							; 1790	
							; 1791	
							; 1792	WORK[]_Q	"AD/Q,DEST/PASS,RAMADR/#,WORK/@1,FM WRITE"
							; 1793	Q_WORK[]	"AD/D,DEST/Q_AD,RAMADR/#,DBUS/RAM,WORK/@1,DT/3T"
							; 1794	WORK[]_0	"AD/ZERO,DEST/PASS,RAMADR/#,WORK/@1,FM WRITE"
							; 1795	WORK[]_1	"AD/B,DEST/PASS,RAMADR/#,WORK/@1,B/ONE,FM WRITE"
							; 1796	WORK[]_[]	"AD/B,DEST/PASS,RAMADR/#,WORK/@1,B/@2,FM WRITE"
							; 1797	WORK[]_[] CLR LH "AD/47,RSRC/AB,DEST/PASS,RAMADR/#,WORK/@1,B/@2,A/MASK,FM WRITE"
							; 1798	WORK[]_[]-1	"AD/A-B-.25,A/@2,B/ONE,DEST/PASS,RAMADR/#,WORK/@1,FM WRITE, ADD .25"
							; 1799	WORK[]_.NOT.[]	"AD/.NOT.B,DEST/PASS,RAMADR/#,WORK/@1,B/@2,FM WRITE"
							; 1800	WORK[]_[].AND.[] "AD/A.AND.B,DEST/PASS,RAMADR/#,WORK/@1,A/@2,B/@3,FM WRITE"
							; 1801	[].AND.NOT.WORK[] "AD/.NOT.D.AND.A,A/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1802	[].AND.WORK[]	"AD/D.AND.A,A/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1803	[]_[]+WORK[]	"AD/D+A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1804	[]_[].AND.WORK[] "AD/D.AND.A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1805	[]_[].AND.NOT.WORK[] "AD/.NOT.D.AND.A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1806	[]_[].OR.WORK[]	"AD/D.OR.A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1807	[]_WORK[]	"AD/D,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1808	[]_.NOT.WORK[]	"AD/.NOT.D,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1809	[]_-WORK[]	"AD/-D-.25,ADD .25,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1810	[]_WORK[]+1	"AD/D+A,A/ONE,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1811	Q_Q-WORK[]	"AD/Q-D-.25,DEST/Q_AD,DBUS/RAM,RAMADR/#,WORK/@1,ADD .25,DT/3T"
							; 1812	[]_[]-WORK[]	"AD/A-D-.25,DEST/AD,A/@2,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,ADD .25,DT/3T"
							; 1813	
							; 1814	RAM_[]		"AD/B,DEST/PASS,RAMADR/RAM,B/@1,FM WRITE"
							; 1815	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 48
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- MEMORY CONTROL				

							; 1816	.TOC		"MACROS -- MEMORY CONTROL"
							; 1817	
							; 1818	MEM CYCLE		"MEM/1"
							; 1819	
							; 1820	;THE FOLLOWING MACROS CONTROL MEMORY ADDRESS
							; 1821	LOAD VMA		"MEM CYCLE,LDVMA/1"
							; 1822	FORCE EXEC		"FORCE EXEC/1"
							; 1823	VMA PHYSICAL		"PHYSICAL/1,FORCE EXEC/1,FORCE USER/0,EXT ADR/1,LOAD VMA"
							; 1824	VMA PHYSICAL WRITE	"LOAD VMA,VMA PHYSICAL,WAIT/1,MEM/1,WRITE CYCLE/1,WRITE TEST/0"
							; 1825	VMA PHYSICAL READ	"LOAD VMA,VMA PHYSICAL,WAIT/1,MEM/1,READ CYCLE/1,WRITE TEST/0"
							; 1826	VMA EXTENDED		"EXT ADR/1"
							; 1827	
							; 1828	PXCT EA			"PXCT/E1"
							; 1829	PXCT DATA		"PXCT/D1"
							; 1830	PXCT BLT DEST		"PXCT/D1"
							; 1831	PXCT BYTE PTR EA 	"PXCT/E2"
							; 1832	PXCT BYTE DATA		"PXCT/D2"
							; 1833	PXCT STACK WORD		"PXCT/D2"
							; 1834	PXCT BLT SRC		"PXCT/D2"
							; 1835	PXCT EXTEND EA		"PXCT/E2"
							; 1836	
							; 1837	;THE FOLLOWING MACROS GET MEMORY CYCLES STARTED
							; 1838	WRITE TEST		"WRITE TEST/1,WAIT/1"
							; 1839	START READ		"MEM CYCLE,READ CYCLE/1,WAIT/1"
							; 1840	START WRITE		"MEM CYCLE,WRITE TEST,WRITE CYCLE/1,WAIT/1"
							; 1841	START NO TEST WRITE	"MEM CYCLE,WRITE CYCLE/1,WAIT/1"
							; 1842	FETCH			"START READ,FETCH/1,PXCT/CURRENT,WAIT/1"
							; 1843	
							; 1844	;THE FOLLOWING MACROS COMPLETE MEMORY CYCLES
							; 1845	MEM WAIT		"MEM CYCLE,WAIT/1"
							; 1846	MEM READ		"MEM WAIT,DBUS/DBM,DBM/MEM"
							; 1847	MEM WRITE		"MEM WAIT,DT/3T"
							; 1848	SPEC MEM READ		"SPEC/WAIT,DBUS/DBM,DBM/MEM"
							; 1849	SPEC MEM WRITE		"SPEC/WAIT,DT/3T"
							; 1850	
							; 1851	
							; 1852	;THINGS WHICH WRITE MEMORY
							; 1853	MEM_[]			"AD/B,DEST/PASS,B/@1,DBUS/DP,RAMADR/VMA,CHK PARITY"
							; 1854	MEM_Q			"AD/Q,DBUS/DP,RAMADR/VMA"
							; 1855	
							; 1856	
							; 1857	;THINGS WHICH READ MEMORY
							; 1858	[]_IO DATA		"AD/D,DBUS/DBM,RAMADR/VMA,DEST/AD,B/@1"
							; 1859	[]_MEM			"AD/D,DBUS/DBM,RAMADR/VMA,DEST/AD,B/@1,CHK PARITY"
							; 1860	[]_MEM THEN FETCH	"AD/D,DBUS/DBM,RAMADR/VMA,DEST/A,A/PC,B/@1,CHK PARITY, FETCH, LOAD VMA"
							; 1861	[]_MEM*.5		"AD/D,DBUS/DBM,RAMADR/VMA,DEST/AD*.5,B/@1,CHK PARITY"
							; 1862	[]_MEM.AND.MASK		"AD/D.AND.A,A/MASK,DBUS/DBM,RAMADR/VMA,DEST/AD,B/@1,CHK PARITY"
							; 1863	[]_(MEM.AND.[])*.5	"AD/D.AND.A,A/@2,DBUS/DBM,RAMADR/VMA,DEST/AD*.5,B/@1,CHK PARITY"
							; 1864	Q_MEM			"AD/D,DBUS/DBM,RAMADR/VMA,DEST/Q_AD,CHK PARITY"
							; 1865	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 49
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- VMA						

							; 1866	.TOC	"MACROS -- VMA"
							; 1867	
							; 1868	VMA_[]			"AD/A,A/@1,DEST/PASS,LOAD VMA"
							; 1869	VMA_[] WITH FLAGS	"AD/A,A/@1,DEST/PASS,LOAD VMA,WAIT/1, MEM/1, EXT ADR/1, DP FUNC/1, DT/3T"
							; 1870	VMA_[].OR.[] WITH FLAGS	"AD/A.OR.B,A/@1,B/@2,DEST/PASS,LOAD VMA,WAIT/1, MEM/1, EXT ADR/1, DP FUNC/1, DT/3T"
							; 1871	VMA_[]+1		"AD/A+B,A/ONE,B/@1,DEST/AD,HOLD LEFT,LOAD VMA"
							; 1872	VMA_[]-1		"AD/B-A-.25,A/ONE,B/@1,ADD .25,HOLD LEFT,LOAD VMA"
							; 1873	VMA_[]+XR		"AD/D+A,DBUS/RAM,RAMADR/XR#,A/@1,LOAD VMA"
							; 1874	VMA_[]+[]		"AD/A+B,DEST/PASS,A/@1,B/@2,LOAD VMA"
							; 1875	
							; 1876	NEXT [] PHYSICAL WRITE "AD/A+B,A/ONE,B/@1,DEST/AD,HOLD LEFT,LOAD VMA, VMA PHYSICAL, START WRITE"
							; 1877	
							; 1878	;MACROS TO LOAD A 2901 REGISTER WITH VMA FLAG BITS
							; 1879	[]_VMA FLAGS	"AD/45,DEST/AD,B/@1,DBM/#,DBUS/DBM,RSRC/D0,A/MASK"
							; 1880	[]_VMA IO READ	"[@1]_VMA FLAGS,READ CYCLE/1,IO CYCLE/1,WRITE TEST/0, PHYSICAL/1, FORCE EXEC/1, FORCE USER/0"
							; 1881	[]_VMA IO WRITE	"[@1]_VMA FLAGS,WRITE CYCLE/1,IO CYCLE/1,WRITE TEST/0, PHYSICAL/1, FORCE EXEC/1, FORCE USER/0"
							; 1882	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 50
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- TIME CONTROL					

							; 1883	.TOC	"MACROS -- TIME CONTROL"
							; 1884	
							; 1885	AC		"RAMADR/AC#"
							; 1886	AC[]		"RAMADR/AC*#,ACALU/AC+N,ACN/@1"
							; 1887	XR		"RAMADR/XR#"
							; 1888	VMA		"RAMADR/VMA"
							; 1889	WORK[]		"RAMADR/#, WORK/@1"
							; 1890	
							; 1891	2T		"T/2T"
							; 1892	3T		"T/3T"
							; 1893	4T		"T/4T"
							; 1894	5T		"T/5T"
							; 1895	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 51
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- SCAD, SC, FE LOGIC				

							; 1896	.TOC	"MACROS -- SCAD, SC, FE LOGIC"
							; 1897	
							; 1898	LOAD SC		"LOADSC/1"
							; 1899	LOAD FE		"LOADFE/1"
							; 1900	STEP SC		"SCAD/A-1,SCADA/SC,LOAD SC,SKIP/SC"
							; 1901	SHIFT		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/1, LOAD FE, MULTI SHIFT/1"
							; 1902	
							; 1903	SC_SC-1		"SCAD/A-1,SCADA/SC,LOAD SC"
							; 1904	SC_SHIFT	"SCAD/A+B,SCADA/S#,S#/0,SCADB/SHIFT,LOAD SC"
							; 1905	SC_SHIFT-1	"SCAD/A+B,SCADA/S#,S#/1777,SCADB/SHIFT,LOAD SC"
							; 1906	SC_SHIFT-2	"SCAD/A+B,SCADA/S#,S#/1776,SCADB/SHIFT,LOAD SC"
							; 1907	SC_-SHIFT	"SCAD/A-B,SCADA/S#,S#/0000,SCADB/SHIFT,LOAD SC"
							; 1908	SC_-SHIFT-1	"SCAD/A-B,SCADA/S#,SCADB/SHIFT,S#/1777,LOAD SC"
							; 1909	SC_-SHIFT-2	"SCAD/A-B,SCADA/S#,SCADB/SHIFT,S#/1776,LOAD SC"
							; 1910	SC_SC-EXP	"SCAD/A-B,SCADA/SC,SCADB/EXP,LOAD SC"
							; 1911	SC_SC-EXP-1	"SCAD/A-B-1,SCADA/SC,SCADB/EXP,LOAD SC"
							; 1912	SC_SC-FE-1	"SCAD/A-B-1,SCADA/SC,SCADB/FE,LOAD SC"
							; 1913	SC_SC-FE	"SCAD/A-B,SCADA/SC,SCADB/FE,LOAD SC"
							; 1914	SC_EXP		"SCAD/A+B,SCADA/S#,S#/0,SCADB/EXP,LOAD SC"
							; 1915	SC_S#-FE	"SCAD/A-B,SCADA/S#,SCADB/FE,LOAD SC"
							; 1916	SC_FE+S#	"SCAD/A+B,SCADA/S#,SCADB/FE,LOAD SC"
							; 1917	SC_FE		"SCAD/A.OR.B,SCADA/S#,S#/0,SCADB/FE,LOAD SC"
							; 1918	SC_S#		"SCAD/A,SCADA/S#,LOAD SC"
							; 1919	
							; 1920	
							; 1921	SC_36.		"SC_S#,S#/36."
							; 1922	SC_35.		"SC_S#,S#/35."
							; 1923	SC_34.		"SC_S#,S#/34."
							; 1924	SC_28.		"SC_S#,S#/28."
							; 1925	SC_27.		"SC_S#,S#/27."
							; 1926	SC_26.		"SC_S#,S#/26."
							; 1927	SC_24.		"SC_S#,S#/24."
							; 1928	SC_22.		"SC_S#,S#/22."
							; 1929	SC_20.		"SC_S#,S#/20."
							; 1930	SC_19.		"SC_S#,S#/19."
							; 1931	SC_14.		"SC_S#,S#/14."
							; 1932	SC_11.		"SC_S#,S#/11."
							; 1933	SC_9.		"SC_S#,S#/9."
							; 1934	SC_8.		"SC_S#,S#/8."
							; 1935	SC_7		"SC_S#,S#/7"
							; 1936	SC_6		"SC_S#,S#/6"
							; 1937	SC_5		"SC_S#,S#/5"
							; 1938	SC_4		"SC_S#,S#/4"
							; 1939	SC_3		"SC_S#,S#/3"
							; 1940	SC_2		"SC_S#,S#/2"
							; 1941	SC_1		"SC_S#,S#/1"
							; 1942	SC_0		"SC_S#,S#/0."
							; 1943	SC_-1		"SC_S#,S#/1777"
							; 1944	SC_-2		"SC_S#,S#/1776"
							; 1945	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 52
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- SCAD, SC, FE LOGIC				

							; 1946	FE_-FE		"SCAD/A-B,SCADA/S#,S#/0,SCADB/FE,LOAD FE"
							; 1947	FE_-FE-1	"SCAD/A-B,SCADA/S#,S#/1777,SCADB/FE,LOAD FE"
							; 1948	FE_FE-19	"SCAD/A+B,SCADB/FE,SCADA/S#,S#/1550,LOAD FE"
							; 1949	FE_-FE+S#	"SCAD/A-B,SCADA/S#,SCADB/FE,LOAD FE"
							; 1950	FE_FE+SC	"SCAD/A+B,SCADA/SC,SCADB/FE, LOAD FE"
							; 1951	FE_FE.AND.S#	"SCAD/A.AND.B,SCADA/S#,SCADB/FE, LOAD FE"
							; 1952	FE_P		"SCAD/A,SCADA/BYTE1, LOAD FE"
							; 1953	FE_S		"SCAD/A+B, SCADA/S#, S#/0 ,SCADB/SIZE, LOAD FE"
							; 1954	FE_S+2		"SCAD/A+B, SCADA/S#, S#/20, SCADB/SIZE, LOAD FE"
							; 1955	FE_-S-20	"SCAD/A-B,SCADA/S#,S#/1760,SCADB/SIZE, LOAD FE"
							; 1956	FE_-S-10	"SCAD/A-B,SCADA/S#,S#/1770,SCADB/SIZE, LOAD FE"
							; 1957	FE_S#		"SCAD/A,SCADA/S#,LOAD FE"
							; 1958	FE_S#-FE	"SCAD/A-B,SCADA/S#,SCADB/FE,LOAD FE"
							; 1959	FE_-2		"FE_S#,S#/1776"
							; 1960	FE_-12.		"FE_S#,S#/1764"
							; 1961	FE_0		"FE_S#,S#/0"
							; 1962	FE_-1		"FE_S#,S#/1777"
							; 1963	FE_FE+1		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/1,LOAD FE"
							; 1964	FE_FE+2		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/2,LOAD FE"
							; 1965	FE_FE+10		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/10,LOAD FE"
							; 1966	FE_FE-1		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/1777,LOAD FE"
							; 1967	FE_FE+4		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/4,LOAD FE"
							; 1968	FE_EXP		"SCAD/A+B,SCADA/S#,S#/0,SCADB/EXP,LOAD FE"
							; 1969	FE_SC+EXP	"SCAD/A+B,SCADA/SC,SCADB/EXP,LOAD FE"
							; 1970	FE_SC-EXP	"SCAD/A-B,SCADA/SC,SCADB/EXP,LOAD FE"
							; 1971	FE_FE+P		"SCAD/A+B,SCADA/BYTE1,SCADB/FE, LOAD FE"
							; 1972	FE_FE-200	"SCAD/A+B,SCADA/S#,S#/1600,SCADB/FE,LOAD FE"
							; 1973	FE_-FE+200	"SCAD/A-B,SCADA/S#,S#/200,SCADB/FE,LOAD FE"
							; 1974	FE_FE+S#	"SCAD/A+B,SCADA/S#,SCADB/FE,LOAD FE"
							; 1975	
							; 1976	
							; 1977	GEN 17-FE	"SCAD/A-B,SCADA/S#,S#/210,SCADB/FE"
							; 1978	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 53
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- DATA PATH FIELD CONTROL			

							; 1979	.TOC	"MACROS -- DATA PATH FIELD CONTROL"
							; 1980	
							; 1981	HOLD LEFT	"CLKL/0,GENL/0"
							; 1982	ADL PARITY	"GENL/1"
							; 1983	CHK PARITY L	"CHKL/1"
							; 1984	
							; 1985	HOLD RIGHT	"CLKR/0,GENR/0"
							; 1986	ADR PARITY	"GENR/1"
							; 1987	CHK PARITY R	"CHKR/1"
							; 1988	
							; 1989	AD PARITY	"AD PARITY OK/1"
							; 1990	CHK PARITY	"CHKL/1,CHKR/1"
							; 1991	BAD PARITY	"CHKL/0,CHKR/0"
							; 1992	
							; 1993	INH CRY18	"SPEC/INHCRY18"
							; 1994	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 54
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- SHIFT PATH CONTROL				

							; 1995	.TOC	"MACROS -- SHIFT PATH CONTROL"
							; 1996	
							; 1997	ASH		"SHSTYLE/NORM"	;ASH SHIFT
							; 1998	LSH		"SHSTYLE/NORM"	;LSH SHIFT (SAME HARDWARE AS ASH BUT
							; 1999					; BITS -2 AND -1 ARE PRESET TO ZERO)
							; 2000	ROT		"SHSTYLE/ROT"
							; 2001	LSHC		"SHSTYLE/LSHC"
							; 2002	ASHC		"SHSTYLE/ASHC"
							; 2003	ROTC		"SHSTYLE/ROTC"
							; 2004	ONES		"SHSTYLE/ONES"	;SHIFT IN 1 BITS
							; 2005	DIV		"SHSTYLE/DIV"	;SPECIAL PATH FOR DIVIDE (LIKE ROTC BUT
							; 2006					; COMPLEMENT BIT AS IT GOES AROUND)
							; 2007	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 55
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- SPECIAL FUNCTIONS				

							; 2008	.TOC	"MACROS -- SPECIAL FUNCTIONS"
							; 2009	
							; 2010	LOAD IR		"SPEC/LOADIR"	;LOAD INSTRUCTION REG FROM
							; 2011					; DBUS0-DBUS8, LOAD AC# FROM
							; 2012					; DBUS9-DBUS12
							; 2013					; UPDATE LAST-INST-PUBLIC PC FLAG
							; 2014	LOAD INST	"SPEC/LDINST"
							; 2015	LOAD INST EA	"SPEC/LOADXR,PXCT/CURRENT"
							; 2016	LOAD BYTE EA	"SPEC/LOADXR,PXCT/E2"
							; 2017	LOAD IND EA	"SPEC/LOADXR,PXCT/E1"
							; 2018	LOAD SRC EA	"SPEC/LOADXR,PXCT/BIS-SRC-EA"
							; 2019	LOAD DST EA	"SPEC/LOADXR,PXCT/BIS-DST-EA"
							; 2020	ADD .25		"CRY38/1"	;GENERATE CARRY IN TO BIT 37
							; 2021	CALL []		"CALL/1,J/@1"	;CALL A SUBROUTINE
							; 2022	LOAD PXCT	"SPEC/LDPXCT"	;LOAD PXCT FLAGS IF EXEC MODE
							; 2023	TURN OFF PXCT	"SPEC/PXCT OFF"
							; 2024	LOAD PAGE TABLE	"SPEC/LDPAGE"
							; 2025	LOAD AC BLOCKS	"SPEC/LDACBLK"
							; 2026	SWEEP		"SPEC/SWEEP,PHYSICAL/1"
							; 2027	CLRCSH		"SPEC/CLRCSH,PHYSICAL/1"
							; 2028	LOAD PI		"SPEC/LDPI"
							; 2029	SET HALT	"SPEC/#,#/74"
							; 2030	CLEAR CONTINUE	"SPEC/#,#/40"
							; 2031	CLEAR EXECUTE	"SPEC/#,#/20"
							; 2032	CLEAR RUN	"SPEC/#,#/10"
							; 2033	UNHALT		"SPEC/#,#/62"
							; 2034	SET APR ENABLES	"SPEC/APR EN"
							; 2035	ABORT MEM CYCLE	"DBUS/DBM,RAMADR/VMA,DBM/MEM,AD/ZERO,SPEC/MEMCLR,LOAD VMA"
							; 2036	CLR IO BUSY	"SPEC/CLR IO BUSY"
							; 2037	CLR IO LATCH	"SPEC/CLR IO LATCH"
							; 2038	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 56
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- PC FLAGS					

							; 2039	.TOC	"MACROS -- PC FLAGS"
							; 2040	
							; 2041	CHANGE FLAGS	"SPEC/FLAGS"
							; 2042	
							; 2043	SET AROV	"CHANGE FLAGS, HOLD USER/1, SETOV/1, TRAP1/1"
							; 2044	SET FOV		"CHANGE FLAGS, HOLD USER/1, SETFOV/1, TRAP1/1"
							; 2045	SET NO DIVIDE	"CHANGE FLAGS, HOLD USER/1, SETOV/1, SETNDV/1, TRAP1/1"
							; 2046	SET FL NO DIVIDE "SET NO DIVIDE, SETFOV/1"
							; 2047	
							; 2048	ASH AROV	"SPEC/ASHOV"
							; 2049	SET FPD		"CHANGE FLAGS, HOLD USER/1, SETFPD/1"
							; 2050	CLR FPD		"CHANGE FLAGS, HOLD USER/1, CLRFPD/1"
							; 2051	
							; 2052	SET PDL OV	"CHANGE FLAGS, HOLD USER/1, TRAP2/1"
							; 2053	SET TRAP1	"CHANGE FLAGS, HOLD USER/1, TRAP1/1"
							; 2054	
							; 2055	LOAD PCU	"CHANGE FLAGS, LD PCU/1"
							; 2056	UPDATE USER	"CHANGE FLAGS, HOLD USER/1"
							; 2057	LEAVE USER	"CHANGE FLAGS, HOLD USER/0"
							; 2058	
							; 2059	JFCL FLAGS	"CHANGE FLAGS, HOLD USER/1, JFCLFLG/1"
							; 2060	
							; 2061	LOAD FLAGS	"CHANGE FLAGS, LD FLAGS/1"
							; 2062	EXP TEST	"SPEC/EXPTST"
							; 2063	AD FLAGS	"CHANGE FLAGS, ADFLGS/1, HOLD USER/1"
							; 2064	
							; 2065	NO DIVIDE	"SET NO DIVIDE, J/NIDISP"
							; 2066	FL NO DIVIDE	"SET FL NO DIVIDE, J/NIDISP"
							; 2067	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 57
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- PAGE FAIL FLAGS				

							; 2068	.TOC	"MACROS -- PAGE FAIL FLAGS"
							; 2069	
							; 2070	STATE_[]	"[FLG]_#,STATE/@1,HOLD LEFT"
							; 2071	END STATE	"[FLG]_0, HOLD LEFT"
							; 2072	
							; 2073	END BLT		"END STATE"
							; 2074	END MAP		"END STATE"
							; 2075	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 58
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- SINGLE SKIPS					

							; 2076	.TOC	"MACROS -- SINGLE SKIPS"
							; 2077					;SKIPS IF:
							; 2078	SKIP IF AC0	"SKIP/AC0"	;THE AC NUMBER IS ZERO
							; 2079	SKIP DP0	"SKIP/DP0"	;DP BIT 0=1
							; 2080	SKIP DP18	"SKIP/DP18"	;DP BIT 18=1
							; 2081	SKIP AD.EQ.0	"SKIP/ADEQ0,DT/3T" ;ADDER OUTPUT IS ZERO
							; 2082	SKIP AD.LE.0	"SKIP/LE,DT/3T" ;ADDER OUTPUT IS LESS THAN OR EQUAL
							; 2083					; TO ZERO.
							; 2084	SKIP ADL.LE.0	"SKIP/LLE,DT/3T" ;ADDER LEFT IS LESS THAN OR EQUAL
							; 2085					; TO ZERO.
							; 2086	SKIP FPD	"SKIP/FPD"	;FIRST-PART-DONE PC FLAG IS SET
							; 2087	SKIP KERNEL	"SKIP/KERNEL"	;USER=0
							; 2088	SKIP IO LEGAL	"SKIP/IOLGL"	;USER=0 OR USER IOT=1
							; 2089	SKIP CRY0	"SKIP/CRY0"	;ADDER BIT CRY0=1 (NOT PC FLAG BIT)
							; 2090	SKIP CRY1	"SKIP/CRY1"	;ADDER BIT CRY1=1 (NOT PC FLAG BIT)
							; 2091	SKIP CRY2	"SKIP/CRY2,DT/3T"	;ADDER BIT CRY2=1
							; 2092	SKIP JFCL	"SKIP/JFCL"	;IF JFCL SHOULD JUMP
							; 2093	SKIP ADL.EQ.0	"SKIP/ADLEQ0"	;ALU BITS -2 TO 17 = 0
							; 2094	SKIP ADR.EQ.0	"SKIP/ADREQ0"	;ALU BITS 18-35 = 0
							; 2095	SKIP IRPT	"SKIP/INT"	;INTERRUPT IS PENDING
							; 2096	SKIP -1MS	"SKIP/-1 MS"	;DON'T SKIP IF 1MS TIMER HAS EXPIRED.
							; 2097	SKIP AC REF	"SKIP/ACREF"	;VMA IS 0-17
							; 2098	SKIP EXECUTE	"SKIP/EXECUTE"	;CONSOLE EXECUTE
							; 2099	TXXX TEST	"SKIP/TXXX"	;TEST INSTRUCTION SHOULD SKIP
							; 2100	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 59
; KS10.MIC[1,2]	11:18 17-APR-2015				MACROS -- SPECIAL DISPATCH MACROS			

							; 2101	.TOC		"MACROS -- SPECIAL DISPATCH MACROS"
							; 2102	
							; 2103	NEXT INST	"DISP/NICOND,SPEC/NICOND,J/NICOND"
							; 2104	NEXT INST FETCH	"DISP/NICOND,SPEC/NICOND,J/NICOND-FETCH"
							; 2105	EA MODE DISP	"DISP/EAMODE,RAMADR/XR#"
							; 2106	AREAD		"DISP/AREAD,WAIT/1,AREAD/1,MEM/1,J/0"
							; 2107	B DISP		"DISP/BDISP"
							; 2108	BWRITE DISP	"B DISP,MEM/1,BWRITE/1,WRITE CYCLE/1,J/BWRITE"
							; 2109	INST DISP	"DISP/DROM,J/0"
							; 2110	EXIT		"BWRITE DISP,SPEC/0, WRITE TEST/1"
							; 2111	AD FLAGS EXIT	"BWRITE DISP, WRITE TEST/0, AD FLAGS"
							; 2112	FL-EXIT		"WRITE CYCLE/1,WRITE TEST/1,MEM/1,BWRITE/1,B DISP,J/FL-BWRITE"
							; 2113	TEST DISP	"B DISP,J/TEST-TABLE"
							; 2114	SKIP-COMP DISP	"B DISP,J/SKIP-COMP-TABLE"
							; 2115	JUMP DISP	"B DISP,J/JUMP-TABLE"
							; 2116	DONE		"VMA_[PC],LOAD VMA, FETCH, NEXT INST FETCH"
							; 2117	JUMPA		"[PC]_[AR],HOLD LEFT,LOAD VMA,FETCH,NEXT INST FETCH"
							; 2118	UUO		"[HR]_[HR].AND.#,#/777740,HOLD RIGHT,J/UUOGO"
							; 2119	LUUO		"[AR]_0 XWD [40], J/LUUO1"
							; 2120	PAGE FAIL TRAP	"TL [FLG], FLG.PI/1, J/PFT"
							; 2121	TAKE INTERRUPT	"[FLG]_[FLG].OR.#,FLG.PI/1,HOLD RIGHT,J/PI"
							; 2122	INTERRUPT TRAP	"WORK[SV.AR]_[AR], J/ITRAP"
							; 2123	MUL DISP	"DISP/MUL"
							; 2124	DIV DISP	"DISP/DIV"
							; 2125	BYTE DISP	"DISP/BYTE, DT/3T"
							; 2126	SCAD DISP	"DISP/SCAD0"	;SKIP (2'S WEIGHT) IS SCAD IS MINUS
							; 2127	RETURN []	"DISP/RETURN,J/@1"
							; 2128	PI DISP		"DISP/PI"
							; 2129	NORM DISP	"DISP/NORM,DT/3T"
							; 2130	DISMISS		"TR [PI], #/077400, CALL [JEN1],DT/3T"
							; 2131	CALL LOAD PI	"[T0]_[PI] SWAP, CALL [LDPI2]"
							; 2132	HALT []		"AD/47,DEST/AD,B/T1,DBM/#,DBUS/DBM,HALT/@1,RSRC/DA,A/MASK, J/HALTED"
							; 2133	CLEANUP DISP	"READ [FLG], DBUS/DP, DISP/DP, 3T, J/CLEANUP"
							; 2134	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 60
; KS10.MIC[1,2]	11:18 17-APR-2015				DISPATCH ROM MACROS					

							; 2135	.TOC		"DISPATCH ROM MACROS"
							; 2136		.DCODE
							; 2137	
							; 2138	;"A FIELD" MACROS SAY HOW TO FETCH ARGUMENTS
							; 2139	
							; 2140	I	"I/1"
							; 2141	I-PF	"I/1,VMA/0,READ/1"
							; 2142	R	"A/READ,READ/1"
							; 2143	R-PF	"A/RD-PF,READ/1"
							; 2144	W	"A/WRITE,TEST/1"
							; 2145	RW	"A/READ,TEST/1,READ/1"
							; 2146	IW	"I/1,TEST/1"	;IMMED WHICH STORE IN E. (SETZM, ETC.)
							; 2147	IR	"I/1,READ/1"	;START READ A GO TO EXECUTE CODE
							; 2148	DBL R	"A/DREAD,READ/1"	;AR!ARX _ E!E+1
							; 2149	DBL AC	"A/DBLAC"
							; 2150	SH	"A/SHIFT,VMA/0,READ/1"
							; 2151	SHC	"A/DSHIFT,VMA/0,READ/1"
							; 2152	FL-R	"A/FP,READ/1"	;FLOATING POINT READ
							; 2153	FL-RW	"A/FP,READ/1,TEST/1"
							; 2154	FL-I	"A/FPI,READ/0"	;FLOATING POINT IMMEDIATE
							; 2155	DBL FL-R "A/DFP,READ/1"
							; 2156	IOT	"A/IOT"		;CHECK FOR IO LEGAL
							; 2157	
							; 2158	;"B FIELD" MACROS SAY HOW TO STORE RESULTS
							; 2159	
							; 2160	AC	"B/AC"
							; 2161	M	"B/MEM,TEST/1,COND FUNC/1"
							; 2162	B	"B/BOTH,TEST/1,COND FUNC/1"
							; 2163	S	"B/SELF,TEST/1,COND FUNC/1"
							; 2164	DAC	"B/DBLAC"
							; 2165	DBL B	"B/DBLB,TEST/1,COND FUNC/1"
							; 2166	FL-AC	"FL-B/AC"			;FLOATING POINT
							; 2167	FL-MEM	"FL-B/MEM,TEST/1,COND FUNC/1"	;FLOATING POINT TO MEMORY
							; 2168	FL-BOTH	"FL-B/BOTH,TEST/1,COND FUNC/1"	;FLOATING POINT TO BOTH
							; 2169	ROUND	"ROUND/1"			;FLOATING POINT ROUNDED
							; 2170	
							; 2171	
							; 2172	;CONTROL BITS
							; 2173	W TEST	"TEST/1"
							; 2174	AC DISP	"ACDISP/1"
							; 2175		.UCODE
							; 2176	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 61
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			DISPATCH ROM MACROS					

							; 2177		.BIN
							; 2178	.TOC	"POWER UP SEQUENCE"
							; 2179	
							; 2180		.UCODE
							; 2181	
							; 2182	;HERE IS WHERE WE FIRE THE MACHINE UP DURING POWER ON
							; 2183	
							; 2184	
U 0000, 0002,3771,0012,4374,4007,0700,0000,0037,7777	; 2185	0:	[MASK]_#, #/377777	;BUILD A MASK WITH
U 0002, 0013,3445,1212,4174,4007,0700,0000,0000,0000	; 2186		[MASK]_[MASK]*2 	; A ONE IN 36-BITS AND 0
U 0013, 0053,3551,1212,4374,4007,0700,0000,0000,0001	; 2187		[MASK]_[MASK].OR.#,#/1	; IN BITS -2,-1,36,37
U 0053, 0061,3447,1200,4174,4007,0700,0000,0000,0000	; 2188		[MAG]_[MASK]*.5 	;MAKE CONSTANT
U 0061, 0071,3771,0015,4374,4007,0700,0000,0000,0001	; 2189		[XWD1]_#, #/1		;CONSTANT WITH 1 IN EACH
							; 2190					; HALF WORD
							; 2191		[ONE]_0 XWD [1],	;THE CONSTANT 1
U 0071, 0003,4751,1207,4374,4007,0700,0010,0000,0001	; 2192		CALL/1			;RESET STACK (CAN NEVER RETURN
							; 2193					; TO WHERE MR LEFT US)
U 0003, 0100,4751,1203,4374,4007,0700,0000,0037,6000	; 2194	3:	[AR]_0 XWD [376000]	;ADDRESS OF HALT STATUS
							; 2195					; BLOCK
U 0100, 0106,3333,0003,7174,4007,0700,0400,0000,0227	; 2196		WORK[HSBADR]_[AR]	;SAVE FOR HALT LOOP
U 0106, 0110,4221,0011,4364,4277,0700,0200,0000,0010	; 2197		[UBR]_0, ABORT MEM CYCLE ;CLEAR THE UBR AND RESET
							; 2198					; MEMORY CONTROL LOGIC
U 0110, 0125,4221,0010,4174,4477,0700,0000,0000,0000	; 2199		[EBR]_0, LOAD AC BLOCKS ;CLEAR THE EBR AND FORCE
							; 2200					; PREVIOUS AND CURRENT AC
							; 2201					; BLOCKS TO ZERO
U 0125, 0131,4221,0013,4174,4257,0700,0000,0000,0000	; 2202		[FLG]_0, SET APR ENABLES ;CLEAR THE STATUS FLAGS AND
							; 2203					; DISABLE ALL APR CONDITIONS
U 0131, 0162,3333,0013,7174,4007,0700,0400,0000,0230	; 2204		WORK[APR]_[FLG] 	;ZERO REMEMBERED ENABLES
							; 2205	
U 0162, 0212,3333,0013,7174,4007,0700,0400,0000,0300	; 2206		WORK[TIME0]_[FLG]	;CLEAR TIME BASE
U 0212, 0214,3333,0013,7174,4007,0700,0400,0000,0301	; 2207		WORK[TIME1]_[FLG]	; ..
							; 2208	.IF/FULL
U 0214, 0223,4223,0000,1174,4007,0700,0400,0000,1443	; 2209		AC[BIN0]_0		;COMPUTE A TABLE OF POWERS OF
U 0223, 0226,3333,0007,1174,4007,0700,0400,0000,1444	; 2210		AC[BIN1]_1		; TEN
U 0226, 0235,4221,0003,4174,4007,0700,2000,0071,0023	; 2211		[AR]_0, SC_19.		;WE WANT TO GET 22 NUMBERS
U 0235, 0242,3333,0007,7174,4007,0700,0400,0000,0344	; 2212		WORK[DECLO]_1		;STARTING WITH 1
U 0242, 0244,4223,0000,7174,4007,0700,0400,0000,0373	; 2213		WORK[DECHI]_0		; ..
U 0244, 0311,3771,0002,4374,4007,0700,0000,0000,0344	; 2214		[HR]_#, WORK/DECLO	;ADDRESS OF LOW WORD
U 0311, 0323,3771,0006,4374,4007,0700,0000,0000,0373	; 2215		[BRX]_#, WORK/DECHI	;ADDRESS OF HIGH WORD
U 0323, 0010,0111,0706,4174,4007,0700,0200,0000,0010	; 2216	TENLP:	[BRX]_[BRX]+1, LOAD VMA ;ADDRESS THE HIGH WORD
							; 2217	=0*	[ARX]_AC[BIN1], 	;LOW WORD TO ARX
U 0010, 0560,3771,0004,1276,6007,0701,0010,0000,1444	; 2218		CALL [DBSLOW]		;MULTIPLY BY TEN
U 0012, 0324,3333,0005,6174,4007,0700,0400,0000,0000	; 2219		RAM_[BR]		;SAVE HIGH WORD
U 0324, 0334,0111,0702,4174,4007,0700,0200,0000,0010	; 2220		[HR]_[HR]+1, LOAD VMA	;WHERE TO STORE LOW WORD
U 0334, 0224,3333,0004,6174,4007,0630,2400,0060,0000	; 2221		RAM_[ARX], STEP SC	;STORE LOW WORD AND SEE IF
							; 2222					; WE ARE DONE
U 0224, 0323,4443,0000,4174,4007,0700,0000,0000,0000	; 2223	=0	J/TENLP 		;NOT YET--KEEP GOING
U 0225, 0140,6553,0500,4374,4007,0321,0000,0033,0656	; 2224		[BR].XOR.#, 3T, SKIP ADL.EQ.0, #/330656
							; 2225					;DID WE GET THE RIGHT ANSWER
							; 2226					; IN THE TOP 18 BITS?
U 0140, 0104,4751,1217,4374,4007,0700,0000,0000,1005	; 2227	=0**0	HALT [MULERR]		;NO--CPU IS BROKEN
							; 2228	.ENDIF/FULL
							; 2229	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 62
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			POWER UP SEQUENCE					

U 0141, 3647,4221,0014,4174,4007,0700,0010,0000,0000	; 2230	=0**1	[PI]_0, CALL [LOADPI]	;CLEAR PI STATE
							; 2231	=1**1				;CLEAR REGISTERS SO NO
							; 2232					;PARITY ERROR HAPPEN
							;;2233	.IFNOT/FULL
							;;2234		[ARX]_0 		;WRITTEN WHILE COMPUTING POWERS
							;;2235		[BR]_0			;OF 10
							;;2236		[BRX]_0
							; 2237	.ENDIF/FULL
U 0151, 0343,4751,1217,4374,4007,0700,0000,0000,0120	; 2238		[T1]_0 XWD [120]	;RH OF 120 CONTAINS START ADDRESS
							; 2239					; FOR SIMULATOR. FOR THE REAL
							; 2240					; MACHINE IT IS JUST DATA WITH
							; 2241					; GOOD PARITY.
							; 2242	=
							; 2243	;THE CODE UNDER .IF/SIM MUST USE THE SAME ADDRESS AS THE CODE
							; 2244	; UNDER .IFNOT/SIM SO THAT MICROCODE ADDRESSES DO NOT CHANGE BETWEEN
							; 2245	; VERSIONS
							;;2246	.IF/SIM
							;;2247		VMA_[T1], START READ	;READ THE WORD
							;;2248		MEM READ, [PC]_MEM, HOLD LEFT, J/START
							;;2249					;GO FIRE UP SIMULATOR AT THE
							;;2250					; PROGRAMS STARTING ADDRESS
							; 2251	.IFNOT/SIM
							; 2252		[PC]_0, 		;CLEAR LH OF PC
							; 2253		LEAVE USER,		;ENTER EXEC MODE
U 0343, 0346,4221,0001,4174,4467,0700,0000,0000,0004	; 2254		LOAD FLAGS		;CLEAR TRAP FLAGS
							; 2255		[T1]_#, HALT/POWER,	;LOAD T1 WITH POWER UP CODE
U 0346, 0116,3771,0017,4374,4007,0700,0000,0000,0000	; 2256		J/PWRON			;ENTER HALT LOOP. DO NOT STORE
							; 2257					; HALT STATUS BLOCK
							; 2258	.ENDIF/SIM
							; 2259	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 63
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- START NEXT INSTRUCTION		

							; 2260	.TOC	"THE INSTRUCTION LOOP -- START NEXT INSTRUCTION"
							; 2261	
							; 2262	;ALL INSTRUCTIONS EXCEPT JUMP'S AND UUO'S END UP HERE
							; 2263	1400:
U 1400, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 2264	DONE:	DONE
U 1401, 0110,0111,0701,4170,4156,4700,0200,0014,0012	; 2265	1401:	VMA_[PC]+1, NEXT INST FETCH, FETCH
							; 2266	=0
U 0260, 0110,0111,0701,4170,4156,4700,0200,0014,0012	; 2267	SKIP:	VMA_[PC]+1, NEXT INST FETCH, FETCH
U 0261, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 2268		DONE
							; 2269	
							; 2270	
							; 2271	;16-WAY DISPATCH BASED ON NEXT INSTRUCTION
							; 2272	=0000
							; 2273	NICOND:
							; 2274	=0001	[AR]_0 XWD [423],	;TRAP TYPE 3
							; 2275					; GET ADDRESS OF TRAP INST
							; 2276		TURN OFF PXCT,		;CLEAR PXCT
U 0101, 3534,4751,1203,4374,4367,0700,0000,0000,0423	; 2277		J/TRAP			;PROCESS TRAP (INOUT.MIC)
							; 2278	=0010	[AR]_0 XWD [422],	;TRAP TYPE 2
							; 2279		TURN OFF PXCT,		;CLEAR PXCT
U 0102, 3534,4751,1203,4374,4367,0700,0000,0000,0422	; 2280		J/TRAP			;GO TRAP
							; 2281	=0011	[AR]_0 XWD [421],	;TRAP TYPE 1
							; 2282		TURN OFF PXCT,		;TURN OF PXCT
U 0103, 3534,4751,1203,4374,4367,0700,0000,0000,0421	; 2283		J/TRAP			;GO TRAP
U 0105, 0104,4751,1217,4374,4007,0700,0000,0000,0002	; 2284	=0101	HALT [CSL]		;"HA" COMMAND TO 8080
							; 2285	=0111
							; 2286		VMA_[PC],		;LOAD VMA
							; 2287		FETCH,			;INDICATE INSTRUCTION FETCH
U 0107, 0117,3443,0100,4174,4007,0700,0200,0014,0012	; 2288		J/XCTGO 		;GO GET INSTRUCTION
							; 2289	;THE NEXT SET OF CASES ARE USED WHEN THERE IS A FETCH
							; 2290	; IN PROGESS
							; 2291	=1000
							; 2292	NICOND-FETCH:
							; 2293	=1001	[AR]_0 XWD [423],	;TRAP TYPE 3
							; 2294		TURN OFF PXCT,
U 0111, 3534,4751,1203,4374,4367,0700,0000,0000,0423	; 2295		J/TRAP
							; 2296	=1010	[AR]_0 XWD [422],	;TRAP TYPE 2
							; 2297		TURN OFF PXCT,
U 0112, 3534,4751,1203,4374,4367,0700,0000,0000,0422	; 2298		J/TRAP
							; 2299	=1011	[AR]_0 XWD [421],	;TRAP TYPE 1
							; 2300		TURN OFF PXCT,
U 0113, 3534,4751,1203,4374,4367,0700,0000,0000,0421	; 2301		J/TRAP
U 0115, 0104,4751,1217,4374,4007,0700,0000,0000,0002	; 2302	=1101	HALT [CSL]		;"HA" COMMAND TO 8080
							; 2303	=1111
							; 2304	XCTGO:	MEM READ,		;WAIT FOR MEMORY
							; 2305		[HR]_MEM,		;PUT DATA IN HR
							; 2306		LOAD INST,		;LOAD IR & AC #
U 0117, 0363,3771,0002,4365,5617,0700,0200,0000,0002	; 2307		J/INCPC 		;GO BUMP PC
							; 2308	=
							; 2309	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 64
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- START NEXT INSTRUCTION		

							; 2310	;HERE WE POINT PC TO NEXT INSTRUCTION WHILE WE WAIT FOR
							; 2311	; EFFECTIVE ADDRESS LOGIC TO SETTLE
							; 2312	INCPC:	VMA_[PC]+1,		;ADDRESS OF NEXT INSTRUCTION
							; 2313		FETCH/1,		;INSTRUCTION FETCH
							; 2314		TURN OFF PXCT,		;CLEAR EFFECT OF PXCT
U 0363, 0201,0111,0701,2170,4366,6700,0200,0010,0010	; 2315		EA MODE DISP		;DISPACTH OF INDEXING AND @
							; 2316	
							; 2317	;MAIN EFFECTIVE ADDRESS CALCULATION
							; 2318	=0001
							; 2319	EACALC:
							; 2320	;
							; 2321	;	THE FIRST 4 CASES ARE USED ONLY FOR JRST
							; 2322	;
							; 2323	
							; 2324	;CASE 0 -- JRST 0,FOO(XR)
							; 2325		[PC]_[HR]+XR,		;UPDATE PC
							; 2326		HOLD LEFT,		;ONLY RH
							; 2327		LOAD VMA, FETCH,	;START GETTING IT
U 0201, 0110,0551,0201,2270,4156,4700,0200,0014,0012	; 2328		NEXT INST FETCH 	;START NEXT INST
							; 2329	
							; 2330	;CASE 2 -- JRST 0,FOO
							; 2331		[PC]_[HR],		;NEW PC
							; 2332		HOLD LEFT,		;ONLY RH
							; 2333		LOAD VMA, FETCH,	;START GETTING IT
U 0203, 0110,3441,0201,4170,4156,4700,0200,0014,0012	; 2334		NEXT INST FETCH 	;START NEXT INST
							; 2335	
							; 2336	;CASE 4 -- JRST 0,@FOO(XR)
							; 2337		[HR]_[HR]+XR,		;ADD IN INDEX
							; 2338		START READ,		;START TO FETCH @ WORD
							; 2339		LOAD VMA,		;PUT ADDRESS IN VMA
U 0205, 0366,0551,0202,2270,4007,0700,0200,0004,0012	; 2340		J/FETIND		;GO DO MEM WAIT (FORGET ABOUT JRST)
							; 2341	
							; 2342	;CASE 6 -- JRST 0,@FOO
							; 2343		VMA_[HR],		;LOAD UP ADDRESS
							; 2344		START READ,		;START TO FETCH @ WORD
U 0207, 0366,3443,0200,4174,4007,0700,0200,0004,0012	; 2345		J/FETIND		;GO DO MEM WAIT (FORGET ABOUT JRST)
							; 2346	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 65
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- START NEXT INSTRUCTION		

							; 2347	;
							; 2348	;THESE 4 ARE FOR THE NON-JRST CASE
							; 2349	;
							; 2350	
							; 2351	;CASE 10 -- JUST INDEXING
							; 2352	INDEX:	[HR]_[HR]+XR,		;ADD IN INDEX REGISTER
U 0211, 0213,0551,0202,2270,4007,0700,0000,0000,0000	; 2353		HOLD LEFT		;JUST DO RIGHT HALF
							; 2354	
							; 2355	;CASE 12 -- NO INDEXING OR INDIRECT
							; 2356	NOMOD:	[AR]_EA,		;PUT 0,,E IN AR
U 0213, 0000,5741,0203,4174,4001,3700,0200,0000,0342	; 2357		PXCT DATA, AREAD	;DO ONE OR MORE OF THE FOLLWING
							; 2358					; ACCORDING TO THE DROM:
							; 2359					;1. LOAD VMA
							; 2360					;2. START READ OR WRITE
							; 2361					;3. DISPATCH TO 40-57
							; 2362					;   OR DIRECTLY TO EXECUTE CODE
							; 2363	
							; 2364	;CASE 14 -- BOTH INDEXING AND INDIRECT
							; 2365	BOTH:	[HR]_[HR]+XR,		;ADD IN INDEX REGISTER
							; 2366		LOAD VMA, PXCT EA,	;PUT ADDRESS IN VMA
U 0215, 0366,0551,0202,2270,4007,0700,0200,0004,0112	; 2367		START READ, J/FETIND	;START CYCLE AND GO WAIT FOR DATA
							; 2368	
							; 2369	;CASE 16 -- JUST INDIRECT
							; 2370	INDRCT: VMA_[HR],		;LOAD ADDRESS OF @ WORD
U 0217, 0366,3443,0200,4174,4007,0700,0200,0004,0112	; 2371		START READ, PXCT EA	;START CYCLE
							; 2372	
							; 2373	
							; 2374	;HERE TO FETCH INDIRECT WORD
							; 2375	FETIND: MEM READ, [HR]_MEM,	;GET DATA WORD
							; 2376		HOLD LEFT,		;JUST RIGHT HALF
U 0366, 0371,3771,0002,4361,5217,0700,0200,0000,0102	; 2377		LOAD IND EA		;RELOAD @ AND INDEX FLOPS
							; 2378	
							; 2379	XCT2:	VMA_[PC],		;PUT PC BACK IN VMA
							; 2380		FETCH/1,		;TURN ON FETCH FLAG
							; 2381		EA MODE DISP,		;REDO CALCULATION FOR
U 0371, 0201,3443,0100,2174,4006,6700,0200,0010,0010	; 2382		J/EACALC		; NEW WORD
							; 2383	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 66
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- FETCH ARGUMENTS			

							; 2384	.TOC	"THE INSTRUCTION LOOP -- FETCH ARGUMENTS"
							; 2385	;HERE ON AREAD DISP TO HANDLE VARIOUS CASES OF ARGUMENT FETCH
							; 2386	
							; 2387	;CASE 0 -- READ (E)
							; 2388	40:	MEM READ,		;WAIT FOR DATA
							; 2389		[AR]_MEM,		;PUT WORD IN AR
U 0040, 0000,3771,0003,4365,5001,2700,0200,0000,0002	; 2390		INST DISP		;GO TO EXECUTE CODE
							; 2391	
							; 2392	;CASE 1 -- WRITE (E)
							; 2393	41:	[AR]_AC,		;PUT AC IN AR
U 0041, 0000,3771,0003,0276,6001,2700,0000,0000,0000	; 2394		INST DISP		;GO TO EXECUTE CODE
							; 2395	
							; 2396	;CASE 2 -- DOUBLE READ
							; 2397	42:	MEM READ,		;WAIT FOR DATA
U 0042, 0401,3771,0003,4365,5007,0700,0200,0000,0002	; 2398		[AR]_MEM		;PUT HI WORD IN AR
							; 2399		VMA_[HR]+1, PXCT DATA,	;POINT TO E+1
U 0401, 0406,0111,0702,4170,4007,0700,0200,0004,0312	; 2400		START READ		;START MEMORY CYCLE
							; 2401		MEM READ,		;WAIT FOR DATA
							; 2402		[ARX]_MEM,		;LOW WORD IN ARX
U 0406, 0000,3771,0004,4365,5001,2700,0200,0000,0002	; 2403		INST DISP		;GO TO EXECUTE CODE
							; 2404	
							; 2405	;CASE 3 -- DOUBLE AC
U 0043, 0415,3771,0003,0276,6007,0700,0000,0000,0000	; 2406	43:	[AR]_AC 		;GET HIGH AC
							; 2407		[ARX]_AC[1],		;PUT C(AC+1) IN ARX
U 0415, 0000,3771,0004,1276,6001,2701,0000,0000,1441	; 2408		INST DISP		;GO TO EXECUTE CODE
							; 2409	
							; 2410	;CASE 4 -- SHIFT
							; 2411	44:
							; 2412	SHIFT:	READ [AR],		;LOOK AT EFFECTIVE ADDRESS
							; 2413		SKIP DP18,		;SEE IF LEFT OR RIGHT
							; 2414		SC_SHIFT-1,		;PUT NUMBER OF PLACES TO SHIFT IN
							; 2415		LOAD FE,		; SC AND FE
U 0044, 0000,3333,0003,4174,4001,2530,3000,0041,5777	; 2416		INST DISP		;GO DO THE SHIFT
							; 2417	
							; 2418	;CASE 5 -- SHIFT COMBINED
U 0045, 0416,3772,0000,1275,5007,0701,0000,0000,1441	; 2419	45:	Q_AC[1] 		;PUT LOW WORD IN Q
U 0416, 0431,3776,0005,0274,4007,0701,0000,0000,0000	; 2420		[BR]_AC*.5 LONG 	;PUT AC IN BR & SHIFT BR!Q RIGHT
							; 2421		[BR]_[BR]*.5 LONG,	;SHIFT BR!Q 1 MORE PLACE RIGHT
U 0431, 0044,3446,0505,4174,4007,0700,0000,0000,0000	; 2422		J/SHIFT 		;GO DO SHIFT SETUP
							; 2423	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 67
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- FETCH ARGUMENTS			

							; 2424	;CASE 6 -- FLOATING POINT IMMEDIATE
							; 2425	46:	[AR]_[AR] SWAP,		;FLIP BITS TO LEFT HALF
U 0046, 0372,3770,0303,4344,4007,0700,0000,0000,0000	; 2426		J/FPR0			;JOIN COMMON F.P. CODE
							; 2427	
							; 2428	;CASE 7 -- FLOATING POINT
							; 2429	47:	MEM READ,		;WAIT FOR MEMORY (SPEC/MEM WAIT)
U 0047, 0372,3771,0003,4365,5007,0700,0200,0000,0002	; 2430		[AR]_MEM		;DATA INTO AR
							; 2431	=0
							; 2432	FPR0:	READ [AR],		;LOOK AT NUMBER
							; 2433		SC_EXP, FE_EXP, 	;PUT EXPONENT IN SC & FE
							; 2434		SKIP DP0,		;SEE IF NEGATIVE
U 0372, 0412,3333,0003,4174,4007,0520,3010,0041,2000	; 2435		CALL [ARSIGN]		;EXTEND AR SIGN
							; 2436	FPR1:	[ARX]_0,		;ZERO ARX
U 0373, 0000,4221,0004,4174,4001,2700,0000,0000,0000	; 2437		INST DISP		;GO TO EXECUTE CODE
							; 2438	
							; 2439	;CASE 10 -- READ THEN PREFETCH
							; 2440	50:	MEM READ,		;WAIT FOR DATA
							; 2441		[AR]_MEM THEN FETCH,	;PUT DATA IN AR AND START A READ
							; 2442					; VMA HAS PC+1.
U 0050, 0000,3770,0103,4365,5001,2700,0200,0014,0012	; 2443		INST DISP		;GO DO IT
							; 2444	
							; 2445	;CASE 11 -- DOUBLE FLOATING READ
							; 2446	51:	SPEC MEM READ,		;WAIT FOR DATA
							; 2447		[BR]_MEM,		;HOLD IN BR
							; 2448		SC_EXP, FE_EXP, 	;SAVE EXPONENT
U 0051, 0402,3771,0005,4365,5177,0521,3000,0041,2000	; 2449		SKIP DP0, 3T		;SEE IF MINUS
							; 2450	=0	[AR]_[AR]+1,		;POINT TO E+1
							; 2451		LOAD VMA, PXCT DATA,	;PUT IN VMA
U 0402, 0445,0111,0703,4174,4007,0700,0200,0004,0312	; 2452		START READ, J/DFPR1	;GO GET POSITIVE DATA
							; 2453		[AR]_[AR]+1,		;POINT TO E+1
							; 2454		LOAD VMA, PXCT DATA,	;PUT IN VMA
U 0403, 0432,0111,0703,4174,4007,0700,0200,0004,0312	; 2455		START READ		;GO GET NEGATIVE DATA
							; 2456		[BR]_-SIGN,		;SMEAR MINUS SIGN
U 0432, 0451,3551,0505,4374,0007,0700,0000,0077,7000	; 2457		J/DFPR2 		;CONTINUE BELOW
U 0445, 0451,4551,0505,4374,0007,0700,0000,0000,0777	; 2458	DFPR1:	[BR]_+SIGN		;SMEAR PLUS SIGN
							; 2459	DFPR2:	MEM READ, 3T,		;WAIT FOR MEMORY
							; 2460		[ARX]_(MEM.AND.[MAG])*.5,
U 0451, 0452,4557,0004,4365,5007,0701,0200,0000,0002	; 2461		ASH			;SET SHIFT PATHS
U 0452, 0467,3447,0503,4174,4007,0700,0000,0000,0000	; 2462		[AR]_[BR]*.5		;SHIFT AR
							; 2463		[AR]_[AR]*.5,		;COMPLETE SHIFTING
U 0467, 0471,3447,0303,4174,4007,0700,2000,0011,0000	; 2464		SC_FE			;PAGE FAIL MAY HAVE ZAPPED
							; 2465					; THE SC.
							; 2466		VMA_[PC], FETCH,	;GET NEXT INST
U 0471, 0000,3443,0100,4174,4001,2700,0200,0014,0012	; 2467		INST DISP		;DO THIS ONE
							; 2468	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 68
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- FETCH ARGUMENTS			

							; 2469	;CASE 12 -- TEST FOR IO LEGAL
U 0052, 0404,4443,0000,4174,4007,0040,0000,0000,0000	; 2470	52:	SKIP IO LEGAL		;IS IO LEGAL?
U 0404, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 2471	=0	UUO			;NO
U 0405, 0000,4443,0000,4174,4001,2700,0000,0000,0000	; 2472		INST DISP		;YES--DO THE INSTRUCTION
							; 2473	
							; 2474	
							; 2475	;CASE 13 -- RESERVED
							; 2476	;53:
							; 2477	
							; 2478	;CASE 14 -- RESERVED
							; 2479	;54:
							; 2480	
							; 2481	;CASE 15 -- RESERVED
							; 2482	;55:
							; 2483	
							; 2484	;CASE 16 -- RESERVED
							; 2485	;56:
							; 2486	
							; 2487	;CASE 17 -- RESERVED
							; 2488	;57:
							; 2489	
							; 2490	;EXTEND AR SIGN.
							; 2491	;CALL WITH SKIP ON AR0, RETURNS 1 ALWAYS
							; 2492	=0
U 0412, 0001,4551,0303,4374,0004,1700,0000,0000,0777	; 2493	ARSIGN:	[AR]_+SIGN, RETURN [1]	;EXTEND + SIGN
U 0413, 0001,3551,0303,4374,0004,1700,0000,0077,7000	; 2494		[AR]_-SIGN, RETURN [1]	;EXTEND - SIGN
							; 2495	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 69
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- STORE ANSWERS			

							; 2496	.TOC	"THE INSTRUCTION LOOP -- STORE ANSWERS"
							; 2497	
							; 2498	;NOTE:	INSTRUCTIONS WHICH STORE IN BOTH AC AND MEMORY
							; 2499	;	(E.G. ADDB, AOS)  MUST STORE IN MEMORY FIRST
							; 2500	;	SO THAT IF A PAGE FAIL HAPPENS THE  AC IS
							; 2501	;	STILL INTACT.
							; 2502	
							; 2503	1500:
							; 2504	BWRITE: ;BASE ADDRESS OF BWRITE DISPATCH
							; 2505	
							; 2506	;CASE 0 -- RESERVED
							; 2507	;1500:
							; 2508	
							; 2509	;CASE 1  --  RESERVED
							; 2510	;1501:
							; 2511	
							; 2512	;CASE 2  --  RESERVED
							; 2513	;1502:
							; 2514	
							; 2515	;CASE 3  --  RESERVED
							; 2516	;1503:
							; 2517	
							; 2518	;CASE 4 -- STORE SELF
							; 2519	1504:
							; 2520	STSELF: SKIP IF AC0,		;IS AC # ZERO?
U 1504, 0434,4443,0000,4174,4007,0360,0000,0000,0000	; 2521		J/STBTH1		;GO TO STORE BOTH CASE
							; 2522	
							; 2523	;CASE 5 -- STORE DOUBLE AC
							; 2524	1505:
							; 2525	DAC:	AC[1]_[ARX],		;STORE AC 1
U 1505, 1515,3440,0404,1174,4007,0700,0400,0000,1441	; 2526		J/STAC			;GO STORE AC
							; 2527	
							; 2528	;CASE 6 -- STORE DOUBLE BOTH (KA10 STYLE MEM_AR ONLY)
							; 2529	1506:
							; 2530	STDBTH: MEM WRITE,		;WAIT FOR MEMORY
							; 2531		MEM_[AR],		;STORE AR
U 1506, 1505,3333,0003,4175,5007,0701,0200,0000,0002	; 2532		J/DAC			;NOW STORE AC & AC+1
							; 2533	
							; 2534	;CASE 7 -- RESERVED
							; 2535	;1507:
							; 2536	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 70
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- STORE ANSWERS			

							; 2537	;CASE 10  --  RESERVED
							; 2538	;1510:
							; 2539	
							; 2540	;CASE 11  --  RESERVED
							; 2541	;1511:
							; 2542	
							; 2543	;CASE 12  --  RESERVED
							; 2544	;1512:
							; 2545	
							; 2546	;CASE 13  --  RESERVED
							; 2547	;1513:
							; 2548	
							; 2549	;CASE 14  --  RESERVED
							; 2550	1514:
							; 2551	FL-BWRITE:			;THE NEXT 4 CASES ARE ALSO 
							; 2552					;USED IN FLOATING POINT
U 1514, 0104,4751,1217,4374,4007,0700,0000,0000,1000	; 2553		HALT	[BW14]
							; 2554	
							; 2555	;CASE 15 -- STORE AC
							; 2556	1515:
							; 2557	STAC:	AC_[AR],		;STORE AC
U 1515, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 2558		NEXT INST		;DO NEXT INSTRUCTION
							; 2559	
							; 2560	;CASE 16 -- STORE IN MEMORY
							; 2561	1516:
							; 2562	STMEM:	MEM WRITE,		;WAIT FOR MEMORY
							; 2563		MEM_[AR],		;STORE AR
U 1516, 1400,3333,0003,4175,5007,0701,0200,0000,0002	; 2564		J/DONE			;START FETCH OF NEXT
							; 2565	
							; 2566	;CASE 17 -- STORE BOTH
							; 2567	1517:
							; 2568	STBOTH: MEM WRITE,		;WAIT FOR MEMORY
							; 2569		MEM_[AR],		;STORE AR
U 1517, 1515,3333,0003,4175,5007,0701,0200,0000,0002	; 2570		J/STAC			;NOW STORE AC
							; 2571	
							; 2572	=0
							; 2573	STBTH1: MEM WRITE,		;WAIT FOR MEMORY
							; 2574		MEM_[AR],		;STORE AR
U 0434, 1515,3333,0003,4175,5007,0701,0200,0000,0002	; 2575		J/STAC			;NOW STORE AC
							; 2576	STORE:	MEM WRITE,		;WAIT FOR MEMORY
							; 2577		MEM_[AR],		;STORE AC
U 0435, 1400,3333,0003,4175,5007,0701,0200,0000,0002	; 2578		J/DONE			;START NEXT INST
							; 2579	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 71
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			MOVE GROUP						

							; 2580	.TOC	"MOVE GROUP"
							; 2581	
							; 2582		.DCODE
D 0200, 1015,1515,1100					; 2583	200:	R-PF,	AC,	J/STAC		;MOVE
D 0201, 0015,1515,3000					; 2584		I-PF,	AC,	J/STAC		;MOVEI
D 0202, 0116,1404,0700					; 2585		W,	M,	J/MOVE		;MOVEM
D 0203, 0004,1504,1700					; 2586		RW,	S,	J/STSELF	;MOVES
							; 2587	
D 0204, 1015,1402,1100					; 2588	204:	R-PF,	AC,	J/MOVS		;MOVS
D 0205, 0015,1402,3000					; 2589		I-PF,	AC,	J/MOVS		;MOVSI
D 0206, 0116,1402,0700					; 2590		W,	M,	J/MOVS		;MOVSM
D 0207, 0004,1402,1700					; 2591		RW,	S,	J/MOVS		;MOVSS
							; 2592	
D 0210, 1015,1405,1100					; 2593	210:	R-PF,	AC,	J/MOVN		;MOVN
D 0211, 0015,1405,3000					; 2594		I-PF,	AC,	J/MOVN		;MOVNI
D 0212, 0116,1405,0700					; 2595		W,	M,	J/MOVN		;MOVNM
D 0213, 0004,1405,1700					; 2596		RW,	S,	J/MOVN		;MOVNS
							; 2597	
D 0214, 1015,1403,1100					; 2598	214:	R-PF,	AC,	J/MOVM		;MOVM
D 0215, 0015,1515,3000					; 2599		I-PF,	AC,	J/STAC		;MOVMI
D 0216, 0116,1403,0700					; 2600		W,	M,	J/MOVM		;MOVMM
D 0217, 0004,1403,1700					; 2601		RW,	S,	J/MOVM		;MOVNS
							; 2602		.UCODE
							; 2603	
							; 2604	1402:
U 1402, 1500,3770,0303,4344,4003,7700,0200,0003,0001	; 2605	MOVS:	[AR]_[AR] SWAP,EXIT
							; 2606	
							; 2607	1403:
U 1403, 1404,3333,0003,4174,4007,0520,0000,0000,0000	; 2608	MOVM:	READ [AR], SKIP DP0, J/MOVE
							; 2609	
							; 2610	1404:
U 1404, 1500,4443,0000,4174,4003,7700,0200,0003,0001	; 2611	MOVE:	EXIT
							; 2612	1405:
							; 2613	MOVN:	[AR]_-[AR],		;NEGATE NUMBER
							; 2614		AD FLAGS, 3T,		;UPDATE FLAGS
U 1405, 1404,2441,0303,4174,4467,0701,4000,0001,0001	; 2615		J/MOVE			;STORE ANSWER
							; 2616	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 72
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			EXCH							

							; 2617	.TOC	"EXCH"
							; 2618	
							; 2619		.DCODE
D 0250, 0015,1406,1500					; 2620	250:	R,W TEST,	AC,	J/EXCH
							; 2621		.UCODE
							; 2622	
							; 2623	1406:
							; 2624	EXCH:	[BR]_AC,		;COPY AC TO THE BR
U 1406, 0506,3771,0005,0276,6007,0700,0200,0003,0002	; 2625		START WRITE		;START A WRITE CYCLE
							; 2626		MEM WRITE,		;COMPLETE WRITE CYCLE
							; 2627		MEM_[BR],		;STORE BR (AC) IN MEMORY
U 0506, 1515,3333,0005,4175,5007,0701,0200,0000,0002	; 2628		J/STAC			;STORE THE AR IN AC. NOTE: AR
							; 2629					; WAS LOADED WITH MEMORY OPERAND
							; 2630					; AS PART OF INSTRUCTION DISPATCH
							; 2631	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 73
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2632	.TOC	"HALFWORD GROUP"
							; 2633	;	DESTINATION LEFT HALF
							; 2634	
							; 2635		.DCODE
D 0500, 1015,1410,1100					; 2636	500:	R-PF,	AC,	J/HLL
D 0501, 0015,1410,3000					; 2637		I-PF,	AC,	J/HLL
D 0502, 0016,1407,1700					; 2638		RW,	M,	J/HRR		;HLLM = HRR EXCEPT FOR STORE
D 0503, 0004,1404,1700					; 2639		RW,	S,	J/MOVE		;HLLS = MOVES
							; 2640	
D 0504, 1015,1411,1100					; 2641		R-PF,	AC,	J/HRL
D 0505, 0015,1411,3000					; 2642		I-PF,	AC,	J/HRL
D 0506, 0016,1413,1700					; 2643		RW,	M,	J/HRLM
D 0507, 0004,1414,1700					; 2644		RW,	S,	J/HRLS
							; 2645	
D 0510, 1015,1432,1100					; 2646	510:	R-PF,	AC,	J/HLLZ
D 0511, 0015,1432,3000					; 2647		I-PF,	AC,	J/HLLZ
D 0512, 0116,1432,0700					; 2648		W,	M,	J/HLLZ
D 0513, 0004,1432,1700					; 2649		RW,	S,	J/HLLZ
							; 2650	
D 0514, 1015,1424,1100					; 2651		R-PF,	AC,	J/HRLZ
D 0515, 0015,1424,3000					; 2652		I-PF,	AC,	J/HRLZ
D 0516, 0116,1424,0700					; 2653		W,	M,	J/HRLZ
D 0517, 0004,1424,1700					; 2654		RW,	S,	J/HRLZ
							; 2655	
D 0520, 1015,1433,1100					; 2656	520:	R-PF,	AC,	J/HLLO
D 0521, 0015,1433,3000					; 2657		I-PF,	AC,	J/HLLO
D 0522, 0116,1433,0700					; 2658		W,	M,	J/HLLO
D 0523, 0004,1433,1700					; 2659		RW,	S,	J/HLLO
							; 2660	
D 0524, 1015,1425,1100					; 2661		R-PF,	AC,	J/HRLO
D 0525, 0015,1425,3000					; 2662		I-PF,	AC,	J/HRLO
D 0526, 0116,1425,0700					; 2663		W,	M,	J/HRLO
D 0527, 0004,1425,1700					; 2664		RW,	S,	J/HRLO
							; 2665	
D 0530, 1015,1430,1100					; 2666	530:	R-PF,	AC,	J/HLLE
D 0531, 0015,1430,3000					; 2667		I-PF,	AC,	J/HLLE
D 0532, 0116,1430,0700					; 2668		W,	M,	J/HLLE
D 0533, 0004,1430,1700					; 2669		RW,	S,	J/HLLE
							; 2670	
D 0534, 1015,1422,1100					; 2671		R-PF,	AC,	J/HRLE
D 0535, 0015,1422,3000					; 2672		I-PF,	AC,	J/HRLE
D 0536, 0116,1422,0700					; 2673		W,	M,	J/HRLE
D 0537, 0004,1422,1700					; 2674		RW,	S,	J/HRLE
							; 2675	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 74
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2676	;	DESTINATION RIGHT HALF
							; 2677	
D 0540, 1015,1407,1100					; 2678	540:	R-PF,	AC,	J/HRR
D 0541, 0015,1407,3000					; 2679		I-PF,	AC,	J/HRR
D 0542, 0016,1410,1700					; 2680		RW,	M,	J/HLL		;HRRM = HLL EXCEPT FOR STORE
D 0543, 0004,1404,1700					; 2681		RW,	S,	J/MOVE		;HRRS = MOVES
							; 2682	
D 0544, 1015,1412,1100					; 2683		R-PF,	AC,	J/HLR
D 0545, 0015,1412,3000					; 2684		I-PF,	AC,	J/HLR
D 0546, 0016,1415,1700					; 2685		RW,	M,	J/HLRM
D 0547, 0004,1416,1700					; 2686		RW,	S,	J/HLRS
							; 2687	
D 0550, 1015,1420,1100					; 2688	550:	R-PF,	AC,	J/HRRZ
D 0551, 0015,1420,3000					; 2689		I-PF,	AC,	J/HRRZ
D 0552, 0116,1420,0700					; 2690		W,	M,	J/HRRZ
D 0553, 0004,1420,1700					; 2691		RW,	S,	J/HRRZ
							; 2692	
D 0554, 1015,1426,1100					; 2693		R-PF,	AC,	J/HLRZ
D 0555, 0015,1426,3000					; 2694		I-PF,	AC,	J/HLRZ
D 0556, 0116,1426,0700					; 2695		W,	M,	J/HLRZ
D 0557, 0004,1426,1700					; 2696		RW,	S,	J/HLRZ
							; 2697	
D 0560, 1015,1421,1100					; 2698	560:	R-PF,	AC,	J/HRRO
D 0561, 0015,1421,3000					; 2699		I-PF,	AC,	J/HRRO
D 0562, 0116,1421,0700					; 2700		W,	M,	J/HRRO
D 0563, 0004,1421,1700					; 2701		RW,	S,	J/HRRO
							; 2702	
D 0564, 1015,1427,1100					; 2703		R-PF,	AC,	J/HLRO
D 0565, 0015,1427,3000					; 2704		I-PF,	AC,	J/HLRO
D 0566, 0116,1427,0700					; 2705		W,	M,	J/HLRO
D 0567, 0004,1427,1700					; 2706		RW,	S,	J/HLRO
							; 2707	
D 0570, 1015,1417,1100					; 2708	570:	R-PF,	AC,	J/HRRE
D 0571, 0015,1417,3000					; 2709		I-PF,	AC,	J/HRRE
D 0572, 0116,1417,0700					; 2710		W,	M,	J/HRRE
D 0573, 0004,1417,1700					; 2711		RW,	S,	J/HRRE
							; 2712	
D 0574, 1015,1423,1100					; 2713		R-PF,	AC,	J/HLRE
D 0575, 0015,1423,3000					; 2714		I-PF,	AC,	J/HLRE
D 0576, 0116,1423,0700					; 2715		W,	M,	J/HLRE
D 0577, 0004,1423,1700					; 2716		RW,	S,	J/HLRE
							; 2717	
							; 2718		.UCODE
							; 2719	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 75
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2720	;FIRST THE GUYS THAT LEAVE THE OTHER HALF ALONE
							; 2721	
							; 2722	;THE AR CONTAINS THE MEMORY OPERAND. SO WE WANT TO PUT THE LH OF
							; 2723	; AC INTO AR TO DO A HRR. OBVIOUS THING FOR HLL.
							; 2724	1407:
U 1407, 1500,3771,0003,0276,0003,7700,0200,0003,0001	; 2725	HRR:	[AR]_AC,HOLD RIGHT,EXIT
							; 2726	1410:
U 1410, 1500,3771,0003,0270,6003,7700,0200,0003,0001	; 2727	HLL:	[AR]_AC,HOLD LEFT,EXIT
							; 2728	
							; 2729	;HRL FLOW:
							; 2730	;AT HRL AR CONTAINS:
							; 2731	;
							; 2732	;	!------------------!------------------!
							; 2733	;	!     LH OF (E)    !	 RH OF (E)    !
							; 2734	;	!------------------!------------------!
							; 2735	;
							; 2736	;AR_AR SWAP GIVES:
							; 2737	;
							; 2738	;	!------------------!------------------!
							; 2739	;	!     RH OF (E)    !	 LH OF (E)    !
							; 2740	;	!------------------!------------------!
							; 2741	;
							; 2742	;AT HLL, AR_AC,HOLD LEFT GIVES:
							; 2743	;
							; 2744	;	!------------------!------------------!
							; 2745	;	!     RH OF (E)    !	 RH OF AC     !
							; 2746	;	!------------------!------------------!
							; 2747	;
							; 2748	;THE EXIT MACRO CAUSES THE AR TO BE STORED IN AC (AT STAC).
							; 2749	; THE REST OF THE HALF WORD IN THIS GROUP ARE VERY SIMILAR.
							; 2750	
							; 2751	1411:
U 1411, 1410,3770,0303,4344,4007,0700,0000,0000,0000	; 2752	HRL:	[AR]_[AR] SWAP,J/HLL
							; 2753	1412:
U 1412, 1407,3770,0303,4344,4007,0700,0000,0000,0000	; 2754	HLR:	[AR]_[AR] SWAP,J/HRR
							; 2755	
							; 2756	1413:
U 1413, 0511,3770,0303,4344,4007,0700,0000,0000,0000	; 2757	HRLM:	[AR]_[AR] SWAP
U 0511, 1402,3771,0003,0270,6007,0700,0000,0000,0000	; 2758		[AR]_AC,HOLD LEFT,J/MOVS
							; 2759	1414:
U 1414, 1500,3770,0303,4344,0003,7700,0200,0003,0001	; 2760	HRLS:	[AR]_[AR] SWAP,HOLD RIGHT,EXIT
							; 2761	
							; 2762	1415:
U 1415, 0512,3770,0303,4344,4007,0700,0000,0000,0000	; 2763	HLRM:	[AR]_[AR] SWAP
U 0512, 1402,3771,0003,0276,0007,0700,0000,0000,0000	; 2764		[AR]_AC,HOLD RIGHT,J/MOVS
							; 2765	1416:
U 1416, 1500,3770,0303,4340,4003,7700,0200,0003,0001	; 2766	HLRS:	[AR]_[AR] SWAP,HOLD LEFT,EXIT
							; 2767	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 76
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2768	;NOW THE HALFWORD OPS WHICH CONTROL THE "OTHER" HALF.
							; 2769	; ENTER WITH 0,,E (E) OR (AC) IN AR
							; 2770	
							; 2771	1417:
U 1417, 1420,3333,0003,4174,4007,0530,0000,0000,0000	; 2772	HRRE:	READ [AR],SKIP DP18
							; 2773	1420:
U 1420, 1500,5731,0003,4174,4003,7700,0200,0003,0001	; 2774	HRRZ:	[AR] LEFT_0, EXIT
							; 2775	1421:
U 1421, 1500,5431,1203,4174,4003,7700,0200,0003,0001	; 2776	HRRO:	[AR] LEFT_-1, EXIT
							; 2777	
							; 2778	1422:
U 1422, 1424,3333,0003,4174,4007,0530,0000,0000,0000	; 2779	HRLE:	READ [AR],SKIP DP18
							; 2780	1424:
U 1424, 1402,3771,0003,4374,0007,0700,0000,0000,0000	; 2781	HRLZ:	[AR]_#,#/0,HOLD RIGHT,J/MOVS
							; 2782	1425:
U 1425, 1402,3771,0003,4374,0007,0700,0000,0077,7777	; 2783	HRLO:	[AR]_#,#/777777,HOLD RIGHT,J/MOVS
							; 2784	
							; 2785	1423:
U 1423, 1426,3333,0003,4174,4007,0520,0000,0000,0000	; 2786	HLRE:	READ [AR],SKIP DP0
							; 2787	1426:
U 1426, 1402,3771,0003,4370,4007,0700,0000,0000,0000	; 2788	HLRZ:	[AR]_#,#/0,HOLD LEFT,J/MOVS
							; 2789	1427:
U 1427, 1402,3771,0003,4370,4007,0700,0000,0077,7777	; 2790	HLRO:	[AR]_#,#/777777,HOLD LEFT,J/MOVS
							; 2791	
							; 2792	1430:
U 1430, 1432,3333,0003,4174,4007,0520,0000,0000,0000	; 2793	HLLE:	READ [AR],SKIP DP0
							; 2794	1432:
U 1432, 1500,5371,0003,4174,4003,7700,0200,0003,0001	; 2795	HLLZ:	[AR] RIGHT_0, EXIT
							; 2796	1433:
U 1433, 1500,5341,1203,4174,4003,7700,0200,0003,0001	; 2797	HLLO:	[AR] RIGHT_-1, EXIT
							; 2798	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 77
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			DMOVE, DMOVN, DMOVEM, DMOVNM				

							; 2799	.TOC	"DMOVE, DMOVN, DMOVEM, DMOVNM"
							; 2800	
							; 2801		.DCODE
D 0120, 0205,1505,1100					; 2802	120:	DBL R,	DAC,	J/DAC
D 0121, 0215,1434,1100					; 2803		DBL R,	AC,	J/DMOVN
							; 2804		.UCODE
							; 2805	
							; 2806	1434:
U 1434, 3107,4551,0404,4374,0007,0700,0010,0037,7777	; 2807	DMOVN:	CLEAR ARX0, CALL [DBLNGA]
U 1436, 1515,3440,0404,1174,4007,0700,0400,0000,1441	; 2808	1436:	AC[1]_[ARX], J/STAC
							; 2809	
							; 2810		.DCODE
D 0124, 0300,1567,0100					; 2811	124:	DBL AC, 	J/DMOVN1
D 0125, 0100,1565,0500					; 2812		W,		J/DMOVNM
							; 2813		.UCODE
							; 2814	
							; 2815	
							; 2816	1565:
U 1565, 3106,3771,0004,1276,6007,0701,0010,0000,1441	; 2817	DMOVNM: [ARX]_AC[1],CALL [DBLNEG]
							; 2818	1567:
							; 2819	DMOVN1: [HR]+[ONE],		;GET E+1
							; 2820		LOAD VMA,		;PUT THAT IN VMA
							; 2821		START WRITE,		;STORE IN E+1
U 1567, 0531,0113,0207,4174,4007,0700,0200,0003,0312	; 2822		PXCT DATA		;DATA CYCLE
U 0531, 0532,3333,0004,4175,5007,0701,0200,0000,0002	; 2823		MEM WRITE, MEM_[ARX]	;STORE LOW WORD
							; 2824		VMA_[HR],		;GET E
							; 2825		LOAD VMA,		;SAVE IN VMA
							; 2826		PXCT DATA,		;OPERAND STORE
							; 2827		START WRITE,		;START MEM CYCLE
U 0532, 0435,3443,0200,4174,4007,0700,0200,0003,0312	; 2828		J/STORE 		;GO STORE AR
							; 2829	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 78
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BOOLEAN GROUP						

							; 2830	.TOC	"BOOLEAN GROUP"
							; 2831	
							; 2832		.DCODE
D 0400, 0015,1441,3000					; 2833	400:	I-PF,	AC,	J/SETZ
D 0401, 0015,1441,3000					; 2834		I-PF,	AC,	J/SETZ
D 0402, 0016,1441,2700					; 2835		IW,	M,	J/SETZ
D 0403, 0017,1441,2700					; 2836		IW,	B,	J/SETZ
							; 2837		.UCODE
							; 2838	
							; 2839	1441:
U 1441, 1500,4221,0003,4174,4003,7700,0200,0003,0001	; 2840	SETZ:	[AR]_0, EXIT
							; 2841	
							; 2842		.DCODE
D 0404, 1015,1442,1100					; 2843	404:	R-PF,	AC,	J/AND
D 0405, 0015,1442,3000					; 2844		I-PF,	AC,	J/AND
D 0406, 0016,1442,1700					; 2845		RW,	M,	J/AND
D 0407, 0017,1442,1700					; 2846		RW,	B,	J/AND
							; 2847		.UCODE
							; 2848	
							; 2849	1442:
U 1442, 1500,4551,0303,0274,4003,7700,0200,0003,0001	; 2850	AND:	[AR]_[AR].AND.AC,EXIT
							; 2851	
							; 2852		.DCODE
D 0410, 1015,1443,1100					; 2853	410:	R-PF,	AC,	J/ANDCA
D 0411, 0015,1443,3000					; 2854		I-PF,	AC,	J/ANDCA
D 0412, 0016,1443,1700					; 2855		RW,	M,	J/ANDCA
D 0413, 0017,1443,1700					; 2856		RW,	B,	J/ANDCA
							; 2857		.UCODE
							; 2858	
							; 2859	1443:
U 1443, 1500,5551,0303,0274,4003,7700,0200,0003,0001	; 2860	ANDCA:	[AR]_[AR].AND.NOT.AC,EXIT
							; 2861	
							; 2862		.DCODE
D 0414, 1015,1404,1100					; 2863	414:	R-PF,	AC,	J/MOVE	 ;SETM = MOVE
D 0415, 0015,1404,3000					; 2864		I-PF,	AC,	J/MOVE
D 0416, 0016,1404,1700					; 2865		RW,	M,	J/MOVE	 ;SETMM = NOP THAT WRITES MEMORY
D 0417, 0017,1404,1700					; 2866		RW,	B,	J/MOVE	 ;SETMB = MOVE THAT WRITES MEMORY
							; 2867	
D 0420, 1015,1444,1100					; 2868	420:	R-PF,	AC,	J/ANDCM
D 0421, 0015,1444,3000					; 2869		I-PF,	AC,	J/ANDCM
D 0422, 0016,1444,1700					; 2870		RW,	M,	J/ANDCM
D 0423, 0017,1444,1700					; 2871		RW,	B,	J/ANDCM
							; 2872		.UCODE
							; 2873	
							; 2874	1444:
U 1444, 1442,7441,0303,4174,4007,0700,0000,0000,0000	; 2875	ANDCM:	[AR]_.NOT.[AR],J/AND
							; 2876	
							; 2877		.DCODE
D 0424, 0000,1400,1100					; 2878	424:	R,		J/DONE
D 0425, 0000,1400,2100					; 2879		I,		J/DONE
D 0426, 0116,1404,0700					; 2880		W,	M,	J/MOVE		;SETAM = MOVEM
D 0427, 0116,1404,0700					; 2881		W,	M,	J/MOVE		;SETAB, TOO
							; 2882		.UCODE
							; 2883	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 79
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BOOLEAN GROUP						

							; 2884		.DCODE
D 0430, 1015,1445,1100					; 2885	430:	R-PF,	AC,	J/XOR
D 0431, 0015,1445,3000					; 2886		I-PF,	AC,	J/XOR
D 0432, 0016,1445,1700					; 2887		RW,	M,	J/XOR
D 0433, 0017,1445,1700					; 2888		RW,	B,	J/XOR
							; 2889		.UCODE
							; 2890	
							; 2891	1445:
U 1445, 1500,6551,0303,0274,4003,7700,0200,0003,0001	; 2892	XOR:	[AR]_[AR].XOR.AC,EXIT
							; 2893	
							; 2894		.DCODE
D 0434, 1015,1446,1100					; 2895	434:	R-PF,	AC,	J/IOR
D 0435, 0015,1446,3000					; 2896		I-PF,	AC,	J/IOR
D 0436, 0016,1446,1700					; 2897		RW,	M,	J/IOR
D 0437, 0017,1446,1700					; 2898		RW,	B,	J/IOR
							; 2899		.UCODE
							; 2900	
							; 2901	1446:
U 1446, 1500,3551,0303,0274,4003,7700,0200,0003,0001	; 2902	IOR:	[AR]_[AR].OR.AC,EXIT
							; 2903	
							; 2904		.DCODE
D 0440, 1015,1447,1100					; 2905	440:	R-PF,	AC,	J/ANDCB
D 0441, 0015,1447,3000					; 2906		I-PF,	AC,	J/ANDCB
D 0442, 0016,1447,1700					; 2907		RW,	M,	J/ANDCB
D 0443, 0017,1447,1700					; 2908		RW,	B,	J/ANDCB
							; 2909		.UCODE
							; 2910	
							; 2911	1447:
U 1447, 1443,7441,0303,4174,4007,0700,0000,0000,0000	; 2912	ANDCB:	[AR]_.NOT.[AR],J/ANDCA
							; 2913	
							; 2914		.DCODE
D 0444, 1015,1450,1100					; 2915	444:	R-PF,	AC,	J/EQV
D 0445, 0015,1450,3000					; 2916		I-PF,	AC,	J/EQV
D 0446, 0016,1450,1700					; 2917		RW,	M,	J/EQV
D 0447, 0017,1450,1700					; 2918		RW,	B,	J/EQV
							; 2919		.UCODE
							; 2920	
							; 2921	1450:
U 1450, 1500,7551,0303,0274,4003,7700,0200,0003,0001	; 2922	EQV:	[AR]_[AR].EQV.AC,EXIT
							; 2923	
							; 2924		.DCODE
D 0450, 0015,1451,3000					; 2925	450:	I-PF,	AC,	J/SETCA
D 0451, 0015,1451,3000					; 2926		I-PF,	AC,	J/SETCA
D 0452, 0016,1451,2700					; 2927		IW,	M,	J/SETCA
D 0453, 0017,1451,2700					; 2928		IW,	B,	J/SETCA
							; 2929		.UCODE
							; 2930	
							; 2931	1451:
U 1451, 1500,7771,0003,0274,4003,7700,0200,0003,0001	; 2932	SETCA:	[AR]_.NOT.AC,EXIT
							; 2933	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 80
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BOOLEAN GROUP						

							; 2934		.DCODE
D 0454, 1015,1452,1100					; 2935	454:	R-PF,	AC,	J/ORCA
D 0455, 0015,1452,3000					; 2936		I-PF,	AC,	J/ORCA
D 0456, 0016,1452,1700					; 2937		RW,	M,	J/ORCA
D 0457, 0017,1452,1700					; 2938		RW,	B,	J/ORCA
							; 2939		.UCODE
							; 2940	
							; 2941	1452:
U 1452, 0564,7771,0005,0274,4007,0700,0000,0000,0000	; 2942	ORCA:	[BR]_.NOT.AC
U 0564, 1500,3111,0503,4174,4003,7700,0200,0003,0001	; 2943		[AR]_[AR].OR.[BR],EXIT
							; 2944	
							; 2945		.DCODE
D 0460, 1015,1453,1100					; 2946	460:	R-PF,	AC,	J/SETCM
D 0461, 0015,1453,3000					; 2947		I-PF,	AC,	J/SETCM
D 0462, 0016,1453,1700					; 2948		RW,	M,	J/SETCM
D 0463, 0017,1453,1700					; 2949		RW,	B,	J/SETCM
							; 2950		.UCODE
							; 2951	
							; 2952	1453:
U 1453, 1500,7441,0303,4174,4003,7700,0200,0003,0001	; 2953	SETCM:	[AR]_.NOT.[AR],EXIT
							; 2954	
							; 2955		.DCODE
D 0464, 1015,1454,1100					; 2956	464:	R-PF,	AC,	J/ORCM
D 0465, 0015,1454,3000					; 2957		I-PF,	AC,	J/ORCM
D 0466, 0016,1454,1700					; 2958		RW,	M,	J/ORCM
D 0467, 0017,1454,1700					; 2959		RW,	B,	J/ORCM
							; 2960		.UCODE
							; 2961	
							; 2962	1454:
U 1454, 1446,7441,0303,4174,4007,0700,0000,0000,0000	; 2963	ORCM:	[AR]_.NOT.[AR],J/IOR
							; 2964	
							; 2965		.DCODE
D 0470, 1015,1455,1100					; 2966	470:	R-PF,	AC,	J/ORCB
D 0471, 0015,1455,3000					; 2967		I-PF,	AC,	J/ORCB
D 0472, 0016,1455,1700					; 2968		RW,	M,	J/ORCB
D 0473, 0017,1455,1700					; 2969		RW,	B,	J/ORCB
							; 2970		.UCODE
							; 2971	
							; 2972	1455:
U 1455, 1453,4551,0303,0274,4007,0700,0000,0000,0000	; 2973	ORCB:	[AR]_[AR].AND.AC,J/SETCM
							; 2974	
							; 2975		.DCODE
D 0474, 0015,1456,3000					; 2976	474:	I-PF,	AC,	J/SETO
D 0475, 0015,1456,3000					; 2977		I-PF,	AC,	J/SETO
D 0476, 0016,1456,2700					; 2978		IW,	M,	J/SETO
D 0477, 0017,1456,2700					; 2979		IW,	B,	J/SETO
							; 2980		.UCODE
							; 2981	
							; 2982	1456:
U 1456, 1500,2441,0703,4174,4003,7700,4200,0003,0001	; 2983	SETO:	[AR]_-[ONE], EXIT
							; 2984	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 81
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 2985	.TOC	"ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO"
							; 2986	
							; 2987		.DCODE
D 0240, 0400,1622,1000					; 2988	240:	SH,		J/ASH
D 0241, 0400,1632,1000					; 2989		SH,		J/ROT
D 0242, 0400,1612,1000					; 2990		SH,		J/LSH
D 0243, 0000,1462,2100					; 2991		I,		J/JFFO
D 0244, 0000,1466,3000					; 2992		I-PF,		J/ASHC
D 0245, 0500,1470,1000					; 2993	245:	SHC,		J/ROTC
D 0246, 0500,1464,1000					; 2994		SHC,		J/LSHC
							; 2995		.UCODE
							; 2996	
							; 2997	
							; 2998	;HERE IS THE CODE FOR LOGICAL SHIFT. THE EFFECTIVE ADDRESS IS
							; 2999	; IN AR.
							; 3000	1612:
							; 3001	LSH:	[AR]_AC,		;PICK UP AC
							; 3002		FE_-FE-1,		;NEGATIVE SHIFT
U 1612, 0572,3771,0003,0276,6007,0700,1000,0031,1777	; 3003		J/LSHL			;SHIFT LEFT
							; 3004	1613:	[AR]_AC.AND.MASK,	;MAKE IT LOOK POSITIVE
							; 3005		FE_FE+1, 		;UNDO -1 AT SHIFT
U 1613, 0604,4551,1203,0276,6007,0700,1000,0041,0001	; 3006		J/ASHR			;GO SHIFT RIGHT
							; 3007	
							; 3008	LSHL:	[AR]_[AR]*2,		;SHIFT LEFT
U 0572, 1515,3445,0303,4174,4007,0700,1020,0041,0001	; 3009		SHIFT, J/STAC		;FAST SHIFT & GO STORE AC
							; 3010	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 82
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 3011	;HERE IS THE CODE FOR ARITHMETIC SHIFT. THE EFFECTIVE ADDRESS IS
							; 3012	; IN AR.
							; 3013	
							; 3014	ASH36 LEFT	"[AR]_[AR]*2 LONG, ASHC, STEP SC, ASH AROV"
							; 3015	
							; 3016	1622:
U 1622, 0612,4222,0000,4174,4007,0700,0000,0000,0000	; 3017	ASH:	Q_0, J/ASHL0		;HARDWARE ONLY DOES ASHC
							; 3018	1623:	[AR]_AC,		;GET THE ARGUMENT
U 1623, 0604,3771,0003,0276,6007,0700,1000,0041,0001	; 3019		FE_FE+1 		;FE HAS NEGATIVE SHIFT COUNT
							; 3020	ASHR:	[AR]_[AR]*.5,		;SHIFT RIGHT
							; 3021		ASH, SHIFT,		;FAST SHIFT
U 0604, 1515,3447,0303,4174,4007,0700,1020,0041,0001	; 3022		J/STAC			;STORE AC WHEN DONE
							; 3023	
							; 3024	ASHL0:	[AR]_AC*.5,		;GET INTO 9 CHIPS
U 0612, 0454,3777,0003,0274,4007,0631,2000,0060,0000	; 3025		STEP SC 		;SEE IF NULL SHIFT
							; 3026	=0
U 0454, 0454,3444,0303,4174,4447,0630,2000,0060,0000	; 3027	ASHL:	ASH36 LEFT, J/ASHL	;SHIFT LEFT
							; 3028					;SLOW BECAUSE WE HAVE TO
							; 3029					; TEST FOR OVERFLOW
							; 3030	
U 0455, 1515,3445,0303,4174,4007,0700,0000,0000,0000	; 3031	ASHX:	[AR]_[AR]*2, J/STAC	;SHIFT BACK INTO 10 CHIPS
							; 3032	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 83
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 3033	;HERE IS THE CODE FOR ROTATE. THE EFFECTIVE ADDRESS IS
							; 3034	; IN AR.
							; 3035	1632:
							; 3036	ROT:	[AR]_AC*.5,		;PICK UP THE AC (& SHIFT)
							; 3037		FE_-FE-1,		;NEGATIVE SHIFT COUNT
U 1632, 0701,3777,0003,0274,4007,0701,1000,0031,1777	; 3038		J/ROTL			;ROTATE LEFT
							; 3039	1633:	[AR]_AC*.5,		;PICK UP THE AC (& SHIFT)
U 1633, 0632,3777,0003,0274,4007,0701,1000,0041,0001	; 3040		FE_FE+1 		;NEGATIVE SHIFT COUNT
U 0632, 0646,3447,0303,4174,4007,0700,0000,0000,0000	; 3041		[AR]_[AR]*.5		;PUT IN 9 DIPS
							; 3042		[AR]_[AR]*.5,		;SHIFT RIGHT
U 0646, 0651,3447,0303,4174,4037,0700,1020,0041,0001	; 3043		ROT, SHIFT		;FAST SHIFT
U 0651, 0455,3445,0303,4174,4007,0700,0000,0000,0000	; 3044	ASHXX:	[AR]_[AR]*2,J/ASHX	;SHIFT TO STD PLACE
							; 3045	
U 0701, 0706,3447,0303,4174,4007,0700,0000,0000,0000	; 3046	ROTL:	[AR]_[AR]*.5		;PUT IN RIGHT 36-BITS
							; 3047		[AR]_[AR]*2,		;ROTATE LEFT
							; 3048		ROT, SHIFT,		;FAST SHIFT
U 0706, 0651,3445,0303,4174,4037,0700,1020,0041,0001	; 3049		J/ASHXX 		;ALL DONE--SHIFT BACK
							; 3050	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 84
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 3051	1462:
							; 3052	JFFO:	[BR]_AC.AND.MASK, 4T,	;GET AC WITH NO SIGN
U 1462, 0502,4551,1205,0276,6007,0622,0000,0000,0000	; 3053		SKIP AD.EQ.0		; EXTENSION. SKIP IF
							; 3054					; ZERO.
							; 3055	=0	[PC]_[AR],		;NOT ZERO--JUMP
							; 3056		LOAD VMA, FETCH,	;GET NEXT INST
U 0502, 0747,3441,0301,4174,4007,0700,0200,0014,0012	; 3057		J/JFFO1 		;ENTER LOOP
U 0503, 1400,4223,0000,1174,4007,0700,0400,0000,1441	; 3058		AC[1]_0, J/DONE 	;ZERO--DONE
							; 3059	
U 0747, 0514,4443,0000,4174,4007,0700,1000,0071,1764	; 3060	JFFO1:	FE_-12. 		;WHY -12.? WELL THE
							; 3061					; HARDWARE LOOKS AT
							; 3062					; BIT -2 SO THE FIRST
							; 3063					; 2 STEPS MOVE THE BR
							; 3064					; OVER. WE ALSO LOOK AT
							; 3065					; THE DATA BEFORE THE SHIFT
							; 3066					; SO WE END UP GOING 1 PLACE
							; 3067					; TOO MANY. THAT MEANS THE
							; 3068					; FE SHOULD START AT -3.
							; 3069					; HOWEVER, WE COUNT THE FE BY
							; 3070					; 4  (BECAUSE THE 2 LOW ORDER
							; 3071					; BITS DO NOT COME BACK) SO
							; 3072					; FE_-12.
							; 3073	=0
							; 3074	JFFOL:	[BR]_[BR]*2,		;SHIFT LEFT
							; 3075		FE_FE+4,		;COUNT UP BIT NUMBER
U 0514, 0514,3445,0505,4174,4007,0520,1000,0041,0004	; 3076		SKIP DP0, J/JFFOL	;LOOP TILL WE FIND THE BIT
U 0515, 0752,3777,0003,4334,4057,0700,0000,0041,0000	; 3077		[AR]_FE 		;GET ANSWER BACK
U 0752, 0767,4251,0303,4374,4007,0700,0000,0000,0077	; 3078		[AR]_[AR].AND.# CLR LH,#/77 ;MASK TO 1 COPY
U 0767, 0100,3440,0303,1174,4156,4700,0400,0000,1441	; 3079		AC[1]_[AR], NEXT INST	;STORE AND EXIT
							; 3080	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 85
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- LSHC			

							; 3081	.TOC	"ROTATES AND LOGICAL SHIFTS -- LSHC"
							; 3082	
							; 3083	;SHIFT CONNECTIONS WHEN THE SPECIAL FUNCTION "LSHC" IS DONE:
							; 3084	;
							; 3085	;   !-!   !----!------------------------------------!
							; 3086	;   !0!-->!0000!	 HIGH ORDER 36 BITS	    !  RAM FILE
							; 3087	;   !-!   !----!------------------------------------!
							; 3088	;						   ^
							; 3089	;						   :
							; 3090	;		....................................
							; 3091	;		:
							; 3092	;	  !----!------------------------------------!
							; 3093	;	  !0000!	  LOW ORDER 36 BITS	    !  Q-REGISTER
							; 3094	;	  !----!------------------------------------!
							; 3095	;						   ^
							; 3096	;						   :
							; 3097	;						  !-!
							; 3098	;						  !0!
							; 3099	;						  !-!
							; 3100	;
							; 3101	
							; 3102	1464:
U 1464, 0544,4443,0000,4174,4007,0630,2000,0060,0000	; 3103	LSHC:	STEP SC, J/LSHCL
U 1465, 1006,3333,0003,4174,4007,0700,2000,0031,5777	; 3104	1465:	READ [AR], SC_-SHIFT-1
U 1006, 0534,4443,0000,4174,4007,0630,2000,0060,0000	; 3105		STEP SC
							; 3106	=0
U 0534, 0534,3446,0505,4174,4057,0630,2000,0060,0000	; 3107	LSHCR:	[BR]_[BR]*.5 LONG,STEP SC,LSHC,J/LSHCR
U 0535, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3108		[BR]_[BR]*2 LONG,J/LSHCX
							; 3109	
							; 3110	=0
U 0544, 0544,3444,0505,4174,4057,0630,2000,0060,0000	; 3111	LSHCL:	[BR]_[BR]*2 LONG,LSHC,STEP SC,J/LSHCL
U 0545, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3112		[BR]_[BR]*2 LONG
U 1014, 1026,3444,0505,4174,4007,0700,0000,0000,0000	; 3113	LSHCX:	[BR]_[BR]*2 LONG
U 1026, 1064,3440,0505,0174,4007,0700,0400,0000,0000	; 3114		AC_[BR], J/ASHCQ1
							; 3115	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 86
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ASHC			

							; 3116	.TOC	"ROTATES AND LOGICAL SHIFTS -- ASHC"
							; 3117	
							; 3118	
							; 3119	1466:
							; 3120	ASHC:	READ [AR],		;PUT AR ON DP
							; 3121		SC_SHIFT, LOAD FE,	;PUT SHIFT IN BOTH SC AND FE
U 1466, 0554,3333,0003,4174,4007,0330,3000,0041,4000	; 3122		SKIP ADR.EQ.0		;SEE IF NULL SHIFT
							; 3123	=0	Q_AC[1],		;NOT NULL--GET LOW WORD
U 0554, 1046,3772,0000,1275,5007,0701,0000,0000,1441	; 3124		J/ASHC1 		;CONTINUE BELOW
U 0555, 0100,4443,0000,4174,4156,4700,0000,0000,0000	; 3125	NIDISP: NEXT INST		;NULL--ALL DONE
							; 3126	ASHC1:	[BR]_AC*.5 LONG,	;GET HIGH WORD
							; 3127					;AND SHIFT Q
U 1046, 0602,3776,0005,0274,4007,0631,0000,0000,0000	; 3128		SKIP/SC 		;SEE WHICH DIRECTION
							; 3129	=0	[BR]_[BR]*.5,		;ADJUST POSITION
							; 3130		SC_FE+S#, S#/1776,	;SUBRTACT 2 FROM FE
U 0602, 0624,3447,0505,4174,4007,0700,2000,0041,1776	; 3131		J/ASHCL 		;GO LEFT
							; 3132		[BR]_[BR]*.5,		;ADJUST POSITION
U 0603, 0614,3447,0505,4174,4007,0700,2000,0031,1776	; 3133		SC_S#-FE, S#/1776	;SC_-2-FE, SC_+# OF STEPS
							; 3134	=0				;HERE TO GO RIGHT
							; 3135	ASHCR:	[BR]_[BR]*.5 LONG,	;GO RIGHT
							; 3136		ASHC,			;SET DATA PATHS FOR ASHC (SEE DPE1)
U 0614, 0614,3446,0505,4174,4047,0630,2000,0060,0000	; 3137		STEP SC, J/ASHCR	;COUNT THE STEP AND KEEP LOOPING
							; 3138		[BR]_[BR]*2 LONG,	;PUT BACK WHERE IT GOES
U 0615, 1053,3444,0505,4174,4047,0700,0000,0000,0000	; 3139		ASHC, J/ASHCX		;COMPLETE INSTRUCTION
							; 3140	
							; 3141	=0
							; 3142	ASHCL:	[BR]_[BR]*2 LONG,	;GO LEFT
							; 3143		ASHC, ASH AROV, 	;SEE IF OVERFLOW
U 0624, 0624,3444,0505,4174,4447,0630,2000,0060,0000	; 3144		STEP SC, J/ASHCL	;LOOP OVER ALL PLACES
							; 3145		[BR]_[BR]*2 LONG,	;SHIFT BACK WHERE IT GOES
U 0625, 1053,3444,0505,4174,4447,0700,0000,0000,0000	; 3146		ASHC, ASH AROV		;CAN STILL OVERFLOW
							; 3147	ASHCX:	AC_[BR]+[BR], 3T,	;PUT BACK HIGH WORD
U 1053, 0634,0113,0505,0174,4007,0521,0400,0000,0000	; 3148		SKIP DP0		;SEE HOW TO FIX LOW SIGN
							; 3149	=0	Q_Q.AND.#, #/377777,	;POSITIVE, CLEAR LOW SIGN
U 0634, 1064,4662,0000,4374,0007,0700,0000,0037,7777	; 3150		HOLD RIGHT, J/ASHCQ1	;GO STORE ANSWER
							; 3151		Q_Q.OR.#, #/400000,	;NEGATIVE, SET LOW SIGN
U 0635, 1064,3662,0000,4374,0007,0700,0000,0040,0000	; 3152		HOLD RIGHT		;IN LEFT HALF
U 1064, 0100,3223,0000,1174,4156,4700,0400,0000,1441	; 3153	ASHCQ1: AC[1]_Q, NEXT INST	;PUT BACK Q AND EXIT
							; 3154	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 87
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROTC			

							; 3155	.TOC	"ROTATES AND LOGICAL SHIFTS -- ROTC"
							; 3156	
							; 3157	;SHIFT CONNECTIONS WHEN THE SPECIAL FUNCTION "ROTC" IS DONE:
							; 3158	;
							; 3159	;	  !----!------------------------------------!
							; 3160	;   .....>!0000!	 HIGH ORDER 36 BITS	    !  RAM FILE
							; 3161	;   :	  !----!------------------------------------!
							; 3162	;   :						   ^
							; 3163	;   :						   :
							; 3164	;   :	............................................
							; 3165	;   :	:
							; 3166	;   :	: !----!------------------------------------!
							; 3167	;   :	..!0000!	  LOW ORDER 36 BITS	    !  Q-REGISTER
							; 3168	;   :	  !----!------------------------------------!
							; 3169	;   :						   ^
							; 3170	;   :						   :
							; 3171	;   :..............................................:
							; 3172	;
							; 3173	
							; 3174	1470:
U 1470, 0644,4443,0000,4174,4007,0630,2000,0060,0000	; 3175	ROTC:	STEP SC, J/ROTCL
U 1471, 1077,3333,0003,4174,4007,0700,2000,0031,5777	; 3176	1471:	READ [AR], SC_-SHIFT-1
U 1077, 0642,4443,0000,4174,4007,0630,2000,0060,0000	; 3177		STEP SC
							; 3178	=0
U 0642, 0642,3446,0505,4174,4077,0630,2000,0060,0000	; 3179	ROTCR:	[BR]_[BR]*.5 LONG,STEP SC,ROTC,J/ROTCR
U 0643, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3180		[BR]_[BR]*2 LONG,J/LSHCX
							; 3181	
							; 3182	=0
U 0644, 0644,3444,0505,4174,4077,0630,2000,0060,0000	; 3183	ROTCL:	[BR]_[BR]*2 LONG,ROTC,STEP SC,J/ROTCL
							; 3184		[BR]_[BR]*2 LONG,
U 0645, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3185		J/LSHCX
							; 3186	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 88
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

							; 3187	.TOC	"TEST GROUP"
							; 3188	
							; 3189		.DCODE
							; 3190	
							; 3191	;SPECIAL MACROS USED ONLY IN B-FIELD OF TEST INSTRUCTIONS
							; 3192	TN-		"B/4"
							; 3193	TNE		"B/0"
							; 3194	WORD-TNE	"B/10"	;USED IN TIOE
							; 3195	TNA		"B/0"
							; 3196	TNN		"B/4"
							; 3197	WORD-TNN	"B/14"	;USED IN TION
							; 3198	TZ-		"B/5"
							; 3199	TZE		"B/1"
							; 3200	TZA		"B/1"
							; 3201	TZN		"B/5"
							; 3202	TC-		"B/6"
							; 3203	TCE		"B/2"
							; 3204	TCA		"B/2"
							; 3205	TCN		"B/6"
							; 3206	TO-		"B/7"
							; 3207	TOE		"B/3"
							; 3208	TOA		"B/3"
							; 3209	TON		"B/7"
							; 3210	
D 0600, 0000,1400,2100					; 3211	600:	I,		J/DONE		;TRN- IS NOP
D 0601, 0000,1400,2100					; 3212		I,		J/DONE		;SO IS TLN-
D 0602, 0000,1475,2100					; 3213		I,	TNE,	J/TDXX
D 0603, 0000,1474,2100					; 3214		I,	TNE,	J/TSXX
D 0604, 0000,1473,2100					; 3215		I,	TNA,	J/TDX
D 0605, 0000,1472,2100					; 3216		I,	TNA,	J/TSX
D 0606, 0004,1475,2100					; 3217		I,	TNN,	J/TDXX
D 0607, 0004,1474,2100					; 3218		I,	TNN,	J/TSXX
							; 3219	
D 0610, 0000,1400,2100					; 3220	610:	I,		J/DONE		;TDN- IS A NOP
D 0611, 0000,1400,2100					; 3221		I,		J/DONE		;TSN- ALSO
D 0612, 0000,1475,1100					; 3222		R,	TNE,	J/TDXX
D 0613, 0000,1474,1100					; 3223		R,	TNE,	J/TSXX
D 0614, 0000,1473,1100					; 3224		R,	TNA,	J/TDX
D 0615, 0000,1472,1100					; 3225		R,	TNA,	J/TSX
D 0616, 0004,1475,1100					; 3226		R,	TNN,	J/TDXX
D 0617, 0004,1474,1100					; 3227		R,	TNN,	J/TSXX
							; 3228	
D 0620, 0005,1473,2100					; 3229	620:	I,	TZ-,	J/TDX
D 0621, 0005,1472,2100					; 3230		I,	TZ-,	J/TSX
D 0622, 0001,1475,2100					; 3231		I,	TZE,	J/TDXX
D 0623, 0001,1474,2100					; 3232		I,	TZE,	J/TSXX
D 0624, 0001,1473,2100					; 3233		I,	TZA,	J/TDX
D 0625, 0001,1472,2100					; 3234		I,	TZA,	J/TSX
D 0626, 0005,1475,2100					; 3235		I,	TZN,	J/TDXX
D 0627, 0005,1474,2100					; 3236		I,	TZN,	J/TSXX
							; 3237	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 89
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

D 0630, 0005,1473,1100					; 3238	630:	R,	TZ-,	J/TDX
D 0631, 0005,1472,1100					; 3239		R,	TZ-,	J/TSX
D 0632, 0001,1475,1100					; 3240		R,	TZE,	J/TDXX
D 0633, 0001,1474,1100					; 3241		R,	TZE,	J/TSXX
D 0634, 0001,1473,1100					; 3242		R,	TZA,	J/TDX
D 0635, 0001,1472,1100					; 3243		R,	TZA,	J/TSX
D 0636, 0005,1475,1100					; 3244		R,	TZN,	J/TDXX
D 0637, 0005,1474,1100					; 3245		R,	TZN,	J/TSXX
							; 3246	
D 0640, 0006,1473,2100					; 3247	640:	I,	TC-,	J/TDX
D 0641, 0006,1472,2100					; 3248		I,	TC-,	J/TSX
D 0642, 0002,1475,2100					; 3249		I,	TCE,	J/TDXX
D 0643, 0002,1474,2100					; 3250		I,	TCE,	J/TSXX
D 0644, 0002,1473,2100					; 3251		I,	TCA,	J/TDX
D 0645, 0002,1472,2100					; 3252		I,	TCA,	J/TSX
D 0646, 0006,1475,2100					; 3253		I,	TCN,	J/TDXX
D 0647, 0006,1474,2100					; 3254		I,	TCN,	J/TSXX
							; 3255	
D 0650, 0006,1473,1100					; 3256	650:	R,	TC-,	J/TDX
D 0651, 0006,1472,1100					; 3257		R,	TC-,	J/TSX
D 0652, 0002,1475,1100					; 3258		R,	TCE,	J/TDXX
D 0653, 0002,1474,1100					; 3259		R,	TCE,	J/TSXX
D 0654, 0002,1473,1100					; 3260		R,	TCA,	J/TDX
D 0655, 0002,1472,1100					; 3261		R,	TCA,	J/TSX
D 0656, 0006,1475,1100					; 3262		R,	TCN,	J/TDXX
D 0657, 0006,1474,1100					; 3263		R,	TCN,	J/TSXX
D 0660, 0007,1473,2100					; 3264	660:	I,	TO-,	J/TDX
D 0661, 0007,1472,2100					; 3265		I,	TO-,	J/TSX
D 0662, 0003,1475,2100					; 3266		I,	TOE,	J/TDXX
D 0663, 0003,1474,2100					; 3267		I,	TOE,	J/TSXX
D 0664, 0003,1473,2100					; 3268		I,	TOA,	J/TDX
D 0665, 0003,1472,2100					; 3269		I,	TOA,	J/TSX
D 0666, 0007,1475,2100					; 3270		I,	TON,	J/TDXX
D 0667, 0007,1474,2100					; 3271		I,	TON,	J/TSXX
							; 3272	
D 0670, 0007,1473,1100					; 3273	670:	R,	TO-,	J/TDX
D 0671, 0007,1472,1100					; 3274		R,	TO-,	J/TSX
D 0672, 0003,1475,1100					; 3275		R,	TOE,	J/TDXX
D 0673, 0003,1474,1100					; 3276		R,	TOE,	J/TSXX
D 0674, 0003,1473,1100					; 3277		R,	TOA,	J/TDX
D 0675, 0003,1472,1100					; 3278		R,	TOA,	J/TSX
D 0676, 0007,1475,1100					; 3279		R,	TON,	J/TDXX
D 0677, 0007,1474,1100					; 3280		R,	TON,	J/TSXX
							; 3281	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 90
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

							; 3282		.UCODE
							; 3283	
							; 3284	;THESE 64 INSTRUCTIONS ARE DECODED BY MASK MODE(IMMEDIATE OR MEMORY)
							; 3285	; IN THE A FIELD, DISPATCH TO HERE ON THE J FIELD, AND RE-DISPATCH
							; 3286	; FOR THE MODIFICATION ON THE B FIELD.
							; 3287	
							; 3288	; ENTER WITH 0,E OR (E) IN AR, B FIELD BITS 2 AND 3 AS FOLLOWS:
							; 3289	; 0 0	NO MODIFICATION
							; 3290	; 0 1	0S
							; 3291	; 1 0	COMPLEMENT
							; 3292	; 1 1	ONES
							; 3293	;   THIS ORDER HAS NO SIGNIFICANCE EXCEPT THAT IT CORRESPONDS TO THE
							; 3294	;   ORDER OF INSTRUCTIONS AT TGROUP.
							; 3295	
							; 3296	;THE BIT 1 OF THE B FIELD IS USED TO DETERMINE THE SENSE
							; 3297	; OF THE SKIP
							; 3298	; 1	SKIP IF AC.AND.MASK .NE. 0 (TXX- AND TXXN)
							; 3299	; 0	SKIP IF AC.AND.MASK .EQ. 0 (TXXA AND TXXE)
							; 3300	
							; 3301	;BIT 0 IS UNUSED AND MUST BE ZERO
							; 3302	
							; 3303	
							; 3304	1472:
U 1472, 1473,3770,0303,4344,4007,0700,0000,0000,0000	; 3305	TSX:	[AR]_[AR] SWAP		;TSXX AND TLXX
							; 3306	1473:
U 1473, 0014,4221,0005,4174,4003,7700,0000,0000,0000	; 3307	TDX:	[BR]_0,TEST DISP	; ALWAYS AND NEVER SKIP CASES
							; 3308	
							; 3309	1474:
U 1474, 1475,3770,0303,4344,4007,0700,0000,0000,0000	; 3310	TSXX:	[AR]_[AR] SWAP		;TSXE, TSXN, TLXE, TLXN
							; 3311	1475:
							; 3312	TDXX:	[BR]_[AR].AND.AC,	;TDXE, TDXN, TRXE, TRXN
U 1475, 0014,4551,0305,0274,4003,7700,0000,0000,0000	; 3313		TEST DISP
							; 3314	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 91
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

							; 3315	;TEST DISP DOES AN 8 WAY BRANCH BASED ON THE B-FIELD OF DROM
							; 3316	
							; 3317	=1100
							; 3318	TEST-TABLE:
							; 3319	
							; 3320	;CASE 0 & 4	-- TXNX
U 0014, 1400,3333,0005,4174,4007,0571,0000,0000,0000	; 3321	TXXX:	READ [BR], TXXX TEST, 3T, J/DONE
							; 3322	
							; 3323	;CASE 1 & 5 -- TXZ AND TXZX
U 0015, 1117,7441,0303,4174,4007,0700,0000,0000,0000	; 3324		[AR]_.NOT.[AR],J/TXZX
							; 3325	
							; 3326	;CASE 2 & 6 -- TXC AND TXCX
U 0016, 1123,6551,0303,0274,4007,0700,0000,0000,0000	; 3327		[AR]_[AR].XOR.AC,J/TDONE
							; 3328	
							; 3329	;CASE 3 & 7 -- TXO AND TXOX
U 0017, 1123,3551,0303,0274,4007,0700,0000,0000,0000	; 3330		[AR]_[AR].OR.AC,J/TDONE
							; 3331	
							; 3332	;THE SPECIAL FUNCTION TXXX TEST CAUSES A MICROCODE SKIP IF
							; 3333	; AD.EQ.0 AND DROM B IS 0-3 OR AD.NE.0 AND DROM B IS 4-7.
							; 3334	
U 1117, 1123,4551,0303,0274,4007,0700,0000,0000,0000	; 3335	TXZX:	[AR]_[AR].AND.AC
U 1123, 0014,3440,0303,0174,4007,0700,0400,0000,0000	; 3336	TDONE:	AC_[AR],J/TXXX
							; 3337	;	READ BR,TXXX TEST,J/DONE
							; 3338	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 92
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			COMPARE -- CAI, CAM					

							; 3339	.TOC	"COMPARE -- CAI, CAM"
							; 3340	
							; 3341		.DCODE
							; 3342	
							; 3343	;SPECIAL B-FIELD ENCODING USED BY SKIP-JUMP-COMPARE CLASS
							; 3344	; INSTRUCTIONS:
							; 3345	
							; 3346	SJC-	"B/0"	;NEVER
							; 3347	SJCL	"B/1"	;LESS
							; 3348	SJCE	"B/2"	;EQUAL
							; 3349	SJCLE	"B/3"	;LESS EQUAL
							; 3350	SJCA	"B/4"	;ALWAYS
							; 3351	SJCGE	"B/5"	;GREATER THAN OR EQUAL
							; 3352	SJCN	"B/6"	;NOT EQUAL
							; 3353	SJCG	"B/7"	;GREATER
							; 3354	
							; 3355		.UCODE
							; 3356	
							; 3357	;COMPARE TABLE
							; 3358	=1000
							; 3359	SKIP-COMP-TABLE:
							; 3360	
							; 3361	;CASE 0 -- NEVER
U 0250, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 3362		DONE
							; 3363	
							; 3364	;CASE 1 -- LESS
U 0251, 1400,3333,0003,4174,4007,0520,0000,0000,0000	; 3365		READ [AR], SKIP DP0,J/DONE
							; 3366	
							; 3367	;CASE 2 -- EQUAL
U 0252, 1400,3333,0003,4174,4007,0621,0000,0000,0000	; 3368	SKIPE:	READ [AR], SKIP AD.EQ.0,J/DONE
							; 3369	
							; 3370	;CASE 3 -- LESS OR EQUAL
U 0253, 1400,3333,0003,4174,4007,0421,0000,0000,0000	; 3371		READ [AR], SKIP AD.LE.0,J/DONE
							; 3372	
							; 3373	;CASE 4 -- ALWAYS
U 0254, 0110,0111,0701,4170,4156,4700,0200,0014,0012	; 3374		VMA_[PC]+1, NEXT INST FETCH, FETCH
							; 3375	
							; 3376	;CASE 5 -- GREATER THAN OR EQUAL
U 0255, 0260,3333,0003,4174,4007,0520,0000,0000,0000	; 3377		READ [AR], SKIP DP0,J/SKIP
							; 3378	
							; 3379	;CASE 6 -- NOT EQUAL
U 0256, 0260,3333,0003,4174,4007,0621,0000,0000,0000	; 3380		READ [AR], SKIP AD.EQ.0,J/SKIP
							; 3381	
							; 3382	;CASE 7 -- GREATER
U 0257, 0260,3333,0003,4174,4007,0421,0000,0000,0000	; 3383		READ [AR], SKIP AD.LE.0,J/SKIP
							; 3384	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 93
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			COMPARE -- CAI, CAM					

							; 3385		.DCODE
D 0300, 0000,1400,2100					; 3386	300:	I,	SJC-,	J/DONE	;CAI
D 0301, 0001,1476,2100					; 3387		I,	SJCL,	J/CAIM
D 0302, 0002,1476,2100					; 3388		I,	SJCE,	J/CAIM
D 0303, 0003,1476,2100					; 3389		I,	SJCLE,	J/CAIM
D 0304, 0004,1476,2100					; 3390		I,	SJCA,	J/CAIM
D 0305, 0005,1476,2100					; 3391		I,	SJCGE,	J/CAIM
D 0306, 0006,1476,2100					; 3392		I,	SJCN,	J/CAIM
D 0307, 0007,1476,2100					; 3393		I,	SJCG,	J/CAIM
							; 3394	
D 0310, 0000,1476,1100					; 3395	310:	R,	SJC-,	J/CAIM	;CAM
D 0311, 0001,1476,1100					; 3396		R,	SJCL,	J/CAIM
D 0312, 0002,1476,1100					; 3397		R,	SJCE,	J/CAIM
D 0313, 0003,1476,1100					; 3398		R,	SJCLE,	J/CAIM
D 0314, 0004,1476,1100					; 3399		R,	SJCA,	J/CAIM
D 0315, 0005,1476,1100					; 3400		R,	SJCGE,	J/CAIM
D 0316, 0006,1476,1100					; 3401		R,	SJCN,	J/CAIM
D 0317, 0007,1476,1100					; 3402		R,	SJCG,	J/CAIM
							; 3403		.UCODE
							; 3404	
							; 3405	1476:
U 1476, 0250,2551,0303,0274,4003,7701,4000,0000,0000	; 3406	CAIM:	[AR]_AC-[AR], 3T, SKIP-COMP DISP
							; 3407	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 94
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC SKIPS -- AOS, SOS, SKIP			

							; 3408	.TOC	"ARITHMETIC SKIPS -- AOS, SOS, SKIP"
							; 3409	;ENTER WITH (E) IN AR
							; 3410	
							; 3411		.DCODE
D 0330, 0000,1477,1100					; 3412	330:	R,	SJC-,	J/SKIPS ;NOT A NOP IF AC .NE. 0
D 0331, 0001,1477,1100					; 3413		R,	SJCL,	J/SKIPS
D 0332, 0002,1477,1100					; 3414		R,	SJCE,	J/SKIPS
D 0333, 0003,1477,1100					; 3415		R,	SJCLE,	J/SKIPS
D 0334, 0004,1477,1100					; 3416		R,	SJCA,	J/SKIPS
D 0335, 0005,1477,1100					; 3417		R,	SJCGE,	J/SKIPS
D 0336, 0006,1477,1100					; 3418		R,	SJCN,	J/SKIPS
D 0337, 0007,1477,1100					; 3419		R,	SJCG,	J/SKIPS
							; 3420		.UCODE
							; 3421	
							; 3422	1477:
							; 3423	SKIPS:	FIX [AR] SIGN,
U 1477, 0742,3770,0303,4174,0007,0360,0000,0000,0000	; 3424		SKIP IF AC0
U 0742, 0250,3440,0303,0174,4003,7700,0400,0000,0000	; 3425	=0	AC_[AR],SKIP-COMP DISP
U 0743, 0250,4443,0000,4174,4003,7700,0000,0000,0000	; 3426		SKIP-COMP DISP
							; 3427	
							; 3428		.DCODE
D 0350, 0000,1431,1500					; 3429	350:	RW,	SJC-,	J/AOS
D 0351, 0001,1431,1500					; 3430		RW,	SJCL,	J/AOS
D 0352, 0002,1431,1500					; 3431		RW,	SJCE,	J/AOS
D 0353, 0003,1431,1500					; 3432		RW,	SJCLE,	J/AOS
D 0354, 0004,1431,1500					; 3433		RW,	SJCA,	J/AOS
D 0355, 0005,1431,1500					; 3434		RW,	SJCGE,	J/AOS
D 0356, 0006,1431,1500					; 3435		RW,	SJCN,	J/AOS
D 0357, 0007,1431,1500					; 3436		RW,	SJCG,	J/AOS
							; 3437		.UCODE
							; 3438	
							; 3439	1431:
U 1431, 1126,0111,0703,4174,4467,0701,0000,0001,0001	; 3440	AOS:	[AR]_[AR]+1, 3T, AD FLAGS
U 1126, 1133,4443,0000,4174,4007,0700,0200,0003,0002	; 3441	XOS:	START WRITE
U 1133, 1477,3333,0003,4175,5007,0701,0200,0000,0002	; 3442		MEM WRITE,MEM_[AR],J/SKIPS
							; 3443	
							; 3444		.DCODE
D 0370, 0000,1437,1500					; 3445	370:	RW,	SJC-,	J/SOS
D 0371, 0001,1437,1500					; 3446		RW,	SJCL,	J/SOS
D 0372, 0002,1437,1500					; 3447		RW,	SJCE,	J/SOS
D 0373, 0003,1437,1500					; 3448		RW,	SJCLE,	J/SOS
D 0374, 0004,1437,1500					; 3449		RW,	SJCA,	J/SOS
D 0375, 0005,1437,1500					; 3450		RW,	SJCGE,	J/SOS
D 0376, 0006,1437,1500					; 3451		RW,	SJCN,	J/SOS
D 0377, 0007,1437,1500					; 3452		RW,	SJCG,	J/SOS
							; 3453		.UCODE
							; 3454	
							; 3455	1437:
U 1437, 1126,1111,0703,4174,4467,0701,4000,0001,0001	; 3456	SOS:	[AR]_[AR]-1, 3T, AD FLAGS, J/XOS
							; 3457	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 95
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ		

							; 3458	.TOC	"CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ"
							; 3459	; ENTER WITH E IN AR
							; 3460	
							; 3461	=1000
							; 3462	JUMP-TABLE:
							; 3463	
							; 3464	;CASE 0 -- NEVER
U 0270, 0100,3440,0505,0174,4156,4700,0400,0000,0000	; 3465		AC_[BR], NEXT INST
							; 3466	
							; 3467	;CASE 1 -- LESS
U 0271, 0744,3770,0505,0174,4007,0520,0400,0000,0000	; 3468		AC_[BR] TEST, SKIP DP0, J/JUMP-
							; 3469	
							; 3470	;CASE 2 -- EQUAL
U 0272, 0744,3770,0505,0174,4007,0621,0400,0000,0000	; 3471		AC_[BR] TEST, SKIP AD.EQ.0, J/JUMP-
							; 3472	
							; 3473	;CASE 3 -- LESS THAN OR EQUAL
U 0273, 0744,3770,0505,0174,4007,0421,0400,0000,0000	; 3474		AC_[BR] TEST, SKIP AD.LE.0, J/JUMP-
							; 3475	
							; 3476	;CASE 4 -- ALWAYS
U 0274, 0762,3440,0505,0174,4007,0700,0400,0000,0000	; 3477	JMPA:	AC_[BR], J/JUMPA
							; 3478	
							; 3479	;CASE 5 -- GREATER THAN OR EQUAL TO
U 0275, 0762,3770,0505,0174,4007,0520,0400,0000,0000	; 3480		AC_[BR] TEST, SKIP DP0, J/JUMPA
							; 3481	
							; 3482	;CASE 6 -- NOT EQUAL
U 0276, 0762,3770,0505,0174,4007,0621,0400,0000,0000	; 3483		AC_[BR] TEST, SKIP AD.EQ.0, J/JUMPA
							; 3484	
							; 3485	;CASE 7 -- GREATER
U 0277, 0762,3770,0505,0174,4007,0421,0400,0000,0000	; 3486		AC_[BR] TEST, SKIP AD.LE.0, J/JUMPA
							; 3487	
							; 3488	=0
U 0744, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 3489	JUMP-:	DONE
U 0745, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3490		JUMPA
							; 3491	
							; 3492	=0
U 0762, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3493	JUMPA:	JUMPA
U 0763, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 3494		DONE
							; 3495	
							; 3496	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 96
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ		

							; 3497		.DCODE
D 0320, 0000,1400,2100					; 3498	320:	I,	SJC-,	J/DONE
D 0321, 0001,1440,2100					; 3499		I,	SJCL,	J/JUMP
D 0322, 0002,1440,2100					; 3500		I,	SJCE,	J/JUMP
D 0323, 0003,1440,2100					; 3501		I,	SJCLE,	J/JUMP
D 0324, 0004,1520,2100					; 3502		I,	SJCA,	J/JRST
D 0325, 0005,1440,2100					; 3503		I,	SJCGE,	J/JUMP
D 0326, 0006,1440,2100					; 3504		I,	SJCN,	J/JUMP
D 0327, 0007,1440,2100					; 3505		I,	SJCG,	J/JUMP
							; 3506		.UCODE
							; 3507	
							; 3508	1440:
U 1440, 0270,3771,0005,0276,6003,7700,0000,0000,0000	; 3509	JUMP:	[BR]_AC,JUMP DISP
							; 3510	
							; 3511		.DCODE
D 0340, 0000,1611,3000					; 3512	340:	I-PF,	SJC-,	J/AOJ
D 0341, 0001,1611,2100					; 3513		I,	SJCL,	J/AOJ
D 0342, 0002,1611,2100					; 3514		I,	SJCE,	J/AOJ
D 0343, 0003,1611,2100					; 3515		I,	SJCLE,	J/AOJ
D 0344, 0004,1611,2100					; 3516		I,	SJCA,	J/AOJ
D 0345, 0005,1611,2100					; 3517		I,	SJCGE,	J/AOJ
D 0346, 0006,1611,2100					; 3518		I,	SJCN,	J/AOJ
D 0347, 0007,1611,2100					; 3519		I,	SJCG,	J/AOJ
							; 3520		.UCODE
							; 3521	
							; 3522	1611:
U 1611, 0270,0551,0705,0274,4463,7702,0000,0001,0001	; 3523	AOJ:	[BR]_AC+1, AD FLAGS, 4T, JUMP DISP
							; 3524	
							; 3525		.DCODE
D 0360, 0000,1542,3000					; 3526	360:	I-PF,	SJC-,	J/SOJ
D 0361, 0001,1542,2100					; 3527		I,	SJCL,	J/SOJ
D 0362, 0002,1542,2100					; 3528		I,	SJCE,	J/SOJ
D 0363, 0003,1542,2100					; 3529		I,	SJCLE,	J/SOJ
D 0364, 0004,1542,2100					; 3530		I,	SJCA,	J/SOJ
D 0365, 0005,1542,2100					; 3531		I,	SJCGE,	J/SOJ
D 0366, 0006,1542,2100					; 3532		I,	SJCN,	J/SOJ
D 0367, 0007,1542,2100					; 3533		I,	SJCG,	J/SOJ
							; 3534		.UCODE
							; 3535	
							; 3536	1542:
U 1542, 0270,2551,0705,0274,4463,7702,4000,0001,0001	; 3537	SOJ:	[BR]_AC-1, AD FLAGS, 4T, JUMP DISP
							; 3538	
							; 3539		.DCODE
D 0252, 0005,1547,2100					; 3540	252:	I,	SJCGE,	J/AOBJ
D 0253, 0001,1547,2100					; 3541		I,	SJCL,	J/AOBJ
							; 3542		.UCODE
							; 3543	
							; 3544	1547:
							; 3545	AOBJ:	[BR]_AC+1000001,	;ADD 1 TO BOTH HALF WORDS
							; 3546		INH CRY18, 3T,		;NO CARRY INTO LEFT HALF
U 1547, 0270,0551,1505,0274,4403,7701,0000,0000,0000	; 3547		JUMP DISP		;HANDLE EITHER AOBJP OR AOBJN
							; 3548	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 97
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			AC DECODE JUMPS -- JRST, JFCL				

							; 3549	.TOC	"AC DECODE JUMPS -- JRST, JFCL"
							; 3550	
							; 3551		.DCODE
D 0254, 0000,1520,6000					; 3552	254:	I,VMA/0, AC DISP,	J/JRST	;DISPATCHES TO 1 OF 16
							; 3553						; PLACES ON AC BITS
D 0255, 0000,1540,2100					; 3554		I,			J/JFCL
							; 3555		.UCODE
							; 3556	
							; 3557	;JRST DISPATCHES TO ONE OF 16 LOC'NS ON AC BITS
							; 3558	
							; 3559	=0000
							; 3560	1520:
U 1520, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3561	JRST:	JUMPA			;(0) JRST 0,
U 1521, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3562	1521:	JUMPA			;(1) PORTAL IS SAME AS JRST
							; 3563	1522:	VMA_[PC]-1, START READ, ;(2) JRSTF
U 1522, 0150,1113,0701,4170,4007,0700,4200,0004,0012	; 3564		J/JRSTF
U 1523, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3565	1523:	UUO			;(3)
U 1524, 0764,4443,0000,4174,4007,0340,0000,0000,0000	; 3566	1524:	SKIP KERNEL, J/HALT	;(4) HALT
							; 3567	1525:
							; 3568	XJRSTF0: VMA_[AR], START READ, ;(5) XJRSTF
U 1525, 2603,3443,0300,4174,4007,0700,0200,0004,0012	; 3569		J/XJRSTF
U 1526, 0320,4443,0000,4174,4007,0340,0000,0000,0000	; 3570	1526:	SKIP KERNEL, J/XJEN	;(6) XJEN
U 1527, 1024,4443,0000,4174,4007,0340,0000,0000,0000	; 3571	1527:	SKIP KERNEL, J/XPCW	;(7) XPCW
							; 3572	1530:	VMA_[PC]-1, START READ, ;(10)
U 1530, 1004,1113,0701,4170,4007,0040,4200,0004,0012	; 3573		 SKIP IO LEGAL, J/JRST10
U 1531, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3574	1531:	UUO			;(11)
							; 3575	1532:	VMA_[PC]-1, START READ, ;(12) JEN
U 1532, 0300,1113,0701,4170,4007,0040,4200,0004,0012	; 3576		 SKIP IO LEGAL, J/JEN
U 1533, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3577	1533:	UUO			;(13)
U 1534, 1034,4443,0000,4174,4007,0340,0000,0000,0000	; 3578	1534:	SKIP KERNEL, J/SFM	;(14) SFM
U 1535, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3579	1535:	UUO			;(15)
U 1536, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3580	1536:	UUO			;(16)
U 1537, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3581	1537:	UUO			;(17)
							; 3582	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 98
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			AC DECODE JUMPS -- JRST, JFCL				

							; 3583	=0*
							; 3584	JRSTF:	MEM READ,		;WAIT FOR DATA
							; 3585		[HR]_MEM,		;STICK IN HR
							; 3586		LOAD INST EA,		;LOAD @ AND XR
U 0150, 1146,3771,0002,4365,5217,0700,0210,0000,0002	; 3587		CALL [JRST0]		;COMPUTE EA AGAIN
U 0152, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3588		JUMPA			;JUMP
							; 3589	
U 1146, 0030,4443,0000,2174,4006,6700,0000,0000,0000	; 3590	JRST0:	EA MODE DISP		;WHAT TYPE OF EA?
							; 3591	=100*
							; 3592		READ XR,		;INDEXED
							; 3593		LOAD FLAGS,		;GET FLAGS FROM XR
							; 3594		UPDATE USER,		;ALLOW USER TO SET
U 0030, 0002,3773,0000,2274,4464,1700,0000,0001,0004	; 3595		RETURN [2]		;ALL DONE
							; 3596		READ [HR],		;PLAIN
							; 3597		LOAD FLAGS,		;LOAD FLAGS FROM INST
							; 3598		UPDATE USER,		;ALLOW USER TO SET
U 0032, 0002,3333,0002,4174,4464,1700,0000,0001,0004	; 3599		RETURN [2]		;RETURN
							; 3600		[HR]_[HR]+XR,		;BOTH
							; 3601		LOAD VMA,		;FETCH IND WORD
							; 3602		START READ,		;START MEM CYCLE
U 0034, 1155,0551,0202,2270,4007,0700,0200,0004,0012	; 3603		J/JRST1 		;CONTINUE BELOW
							; 3604		VMA_[HR],		;INDIRECT
							; 3605		START READ,		;FETCH IND WORD
							; 3606		PXCT EA,		;SETUP PXCT STUFF
U 0036, 1155,3443,0200,4174,4007,0700,0200,0004,0112	; 3607		J/JRST1 		;CONTINUE BELOW
							; 3608	JRST1:	MEM READ,		;WAIT FOR DATA
							; 3609		[HR]_MEM,		;LOAD THE HR
							; 3610		LOAD INST EA,		;LOAD @ AND XR
U 1155, 1146,3771,0002,4365,5217,0700,0200,0000,0002	; 3611		J/JRST0 		;LOOP BACK
							; 3612	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 99
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			AC DECODE JUMPS -- JRST, JFCL				

							; 3613	=0
U 0764, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3614	HALT:	UUO			;USER MODE
U 0765, 1163,3441,0301,4174,4007,0700,0000,0000,0000	; 3615		[PC]_[AR]		;EXEC MODE--CHANGE PC
U 1163, 0104,4751,1217,4374,4007,0700,0000,0000,0001	; 3616		HALT [HALT]		;HALT INSTRUCTION
							; 3617	
							; 3618	=0
U 1004, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3619	JRST10: UUO
U 1005, 0303,4443,0000,4174,4007,0700,0000,0000,0000	; 3620		J/JEN2			;DISMISS INTERRUPT
							; 3621	=0000
U 0300, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3622	JEN:	UUO			; FLAGS
							; 3623		MEM READ,
							; 3624		[HR]_MEM,		;GET INST
							; 3625		LOAD INST EA,		;LOAD XR & @
U 0301, 1146,3771,0002,4365,5217,0700,0210,0000,0002	; 3626		CALL [JRST0]		;COMPUTE FLAGS
							; 3627	=0011
U 0303, 2456,4553,1400,4374,4007,0331,0010,0007,7400	; 3628	JEN2:	DISMISS 		;DISMISS INTERRUPT
U 0307, 3650,3770,1416,4344,4007,0700,0010,0000,0000	; 3629	=0111	CALL LOAD PI		;RELOAD PI HARDWARE
U 0317, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3630	=1111	JUMPA			;GO JUMP
							; 3631	=
							; 3632	
							; 3633	1540:
							; 3634	JFCL:	JFCL FLAGS,		;ALL DONE IN HARDWARE
							; 3635		SKIP JFCL,		;SEE IF SKIPS
							; 3636		3T,			;ALLOW TIME
U 1540, 0744,4443,0000,4174,4467,0551,0000,0001,0010	; 3637		J/JUMP- 		;JUMP IF WE SHOULD
							; 3638	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 100
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			EXTENDED ADDRESSING INSTRUCTIONS			

							; 3639	.TOC	"EXTENDED ADDRESSING INSTRUCTIONS"
							; 3640	
							; 3641	=0000
U 0320, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3642	XJEN:	UUO			;HERE IF USER MODE
U 0321, 2456,4553,1400,4374,4007,0331,0010,0007,7400	; 3643		DISMISS 		;CLEAR HIGHEST INTERRUPT
U 0325, 0335,3333,0012,4174,4437,0700,0000,0000,0000	; 3644	=0101	READ [MASK], LOAD PI	;NO MORE INTERRUPTS
							; 3645	=1101	ABORT MEM CYCLE,	;AVOID INTERRUPT PAGE FAIL
U 0335, 1525,4223,0000,4364,4277,0700,0200,0000,0010	; 3646		J/XJRSTF0		;START READING FLAG WORD
							; 3647	=
							; 3648	
U 2603, 2604,3771,0005,4365,5007,0700,0200,0000,0002	; 3649	XJRSTF: MEM READ, [BR]_MEM	;PUT FLAGS IN BR
							; 3650		[AR]_[AR]+1,		;INCREMENT ADDRESS
							; 3651		LOAD VMA,		;PUT RESULT IN VMA
U 2604, 2625,0111,0703,4174,4007,0700,0200,0004,0012	; 3652		START READ		;START MEMORY
							; 3653		MEM READ, [PC]_MEM,	;PUT DATA IN PC
U 2625, 2627,3771,0001,4361,5007,0700,0200,0000,0002	; 3654		HOLD LEFT		;IGNORE SECTION NUMBER
							; 3655		READ [BR], LOAD FLAGS,	;LOAD NEW FLAGS
U 2627, 2721,3333,0005,4174,4467,0700,0000,0001,0004	; 3656		UPDATE USER		;BUT HOLD USER FLAG
							; 3657	PISET:	[FLG]_[FLG].AND.NOT.#,	;CLEAR PI CYCLE
U 2721, 0305,5551,1313,4374,4007,0700,0000,0001,0000	; 3658		 FLG.PI/1, J/PIEXIT	;RELOAD PI HARDWARE
							; 3659					; INCASE THIS IS AN
							; 3660					; INTERRUPT INSTRUCTION
							; 3661	
							; 3662	=0
U 1024, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3663	XPCW:	UUO			;USER MODE
U 1025, 0060,4521,1205,4074,4007,0700,0000,0000,0000	; 3664		[BR]_FLAGS		;PUT FLAGS IN BR
							; 3665	=0*0
							; 3666	PIXPCW: VMA_[AR], START WRITE,	;STORE FLAGS
U 0060, 3727,3443,0300,4174,4007,0700,0210,0003,0012	; 3667		CALL [STOBR]		;PUT BR IN MEMORY
							; 3668	=1*0	VMA_[AR]+1, LOAD VMA,
							; 3669		START WRITE,		;PREPEARE TO STORE PC
U 0064, 3730,0111,0703,4170,4007,0700,0210,0003,0012	; 3670		CALL [STOPC]		;PUT PC IN MEMORY
							; 3671	=1*1	[AR]_[AR]+1,		;DO NEW PC PART
U 0065, 2603,0111,0703,4174,4007,0700,0200,0004,0002	; 3672		START READ, J/XJRSTF
							; 3673	=
							; 3674	
							; 3675	=0
U 1034, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3676	SFM:	UUO
U 1035, 2734,3443,0300,4174,4007,0700,0200,0003,0012	; 3677		VMA_[AR], START WRITE	;STORE FLAGS
U 2734, 0435,4521,1203,4074,4007,0700,0000,0000,0000	; 3678		[AR]_FLAGS, J/STORE	;STORE AND EXIT
							; 3679	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 101
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			XCT							

							; 3680	.TOC	"XCT"
							; 3681	
							; 3682		.DCODE
D 0256, 0000,1541,1100					; 3683	256:	R,		J/XCT	;OPERAND FETCHED AS DATA
							; 3684		.UCODE
							; 3685	
							; 3686	1541:
U 1541, 1044,4443,0000,4174,4007,0340,0000,0000,0000	; 3687	XCT:	SKIP KERNEL		;SEE IF MAY BE PXCT
							; 3688	=0
							; 3689	XCT1A:	[HR]_[AR],		;STUFF INTO HR
							; 3690		DBUS/DP,		;PLACE ON DBUS FOR IR
							; 3691		LOAD INST,		;LOAD IR, AC, XR, ETC.
							; 3692		PXCT/E1,		;ALLOW XR TO BE PREVIOUS
U 1044, 2735,3441,0302,4174,4617,0700,0000,0000,0100	; 3693		J/XCT1			;CONTINUE BELOW
							; 3694	
							; 3695		READ [HR],		;LOAD PXCT FLAGS
							; 3696		LOAD PXCT,		; ..
U 1045, 1044,3333,0002,4174,4167,0700,0000,0000,0000	; 3697		J/XCT1A			;CONTINUE WITH NORMAL FLOW
							; 3698	
							; 3699	XCT1:	WORK[YSAVE]_[HR] CLR LH,;SAVE FOR IO INSTRUCTIONS
U 2735, 0371,4713,1202,7174,4007,0700,0400,0000,0422	; 3700		J/XCT2			;GO EXECUTE IT
							; 3701	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 102
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ		

							; 3702	.TOC	"STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ"
							; 3703	
							; 3704		.DCODE
D 0260, 0000,1544,2100					; 3705	260:	I,	B/0,	J/PUSHJ
D 0261, 0002,1543,3100					; 3706		IR,	B/2,	J/PUSH
D 0262, 0002,1545,2100					; 3707		I,	B/2,	J/POP
D 0263, 0000,1546,2100					; 3708		I,		J/POPJ
							; 3709		.UCODE
							; 3710	
							; 3711	;ALL START WITH E IN AR
							; 3712	1543:
							; 3713	PUSH:	MEM READ,		;PUT MEMOP IN BR
U 1543, 2736,3771,0005,4365,5007,0700,0200,0000,0002	; 3714		[BR]_MEM		; ..
							; 3715	PUSH1:	[ARX]_AC+1000001,	;BUMP BOTH HALVES OF AC
							; 3716		INH CRY18,		;NO CARRY
							; 3717		LOAD VMA,		;START TO STORE ITEM
							; 3718		START WRITE,		;START MEM CYCLE
							; 3719		PXCT STACK WORD,	;THIS IS THE STACK DATA WORD
							; 3720		3T,			;ALLOW TIME
							; 3721		SKIP CRY0,		;GO TO STMAC, SKIP IF PDL OV
U 2736, 1152,0551,1504,0274,4407,0311,0200,0003,0712	; 3722		J/STMAC 		; ..
							; 3723	
							; 3724	1544:
							; 3725	PUSHJ:	[BR]_PC WITH FLAGS,	;COMPUTE UPDATED FLAGS
							; 3726		CLR FPD,		;CLEAR FIRST-PART-DONE
U 1544, 2736,3741,0105,4074,4467,0700,0000,0005,0000	; 3727		J/PUSH1 		; AND JOIN PUSH CODE
							; 3728	
							; 3729	=0
							; 3730	STMAC:	MEM WRITE,		;WAIT FOR MEMORY
							; 3731		MEM_[BR],		;STORE BR ON STACK
							; 3732		B DISP, 		;SEE IF PUSH OR PUSHJ
U 1152, 0220,3333,0005,4175,5003,7701,0200,0000,0002	; 3733		J/JSTAC 		;BELOW
							; 3734	;WE MUST STORE THE STACK WORD PRIOR TO SETTING PDL OV IN CASE OF
							; 3735	; PAGE FAIL.
							; 3736		MEM WRITE,		;WAIT FOR MEMORY
U 1153, 2737,3333,0005,4175,5007,0701,0200,0000,0002	; 3737		MEM_[BR]		;STORE BR
							; 3738	SETPDL: SET PDL OV,		;OVERFLOW
							; 3739		B DISP, 		;SEE IF PUSH OR PUSHJ
U 2737, 0220,4443,0000,4174,4463,7700,0000,0001,2000	; 3740		J/JSTAC 		;BELOW
							; 3741	
							; 3742	=00
							; 3743	JSTAC:	[PC]_[AR],		;PUSHJ--LOAD PC
							; 3744		LOAD VMA,		;LOAD ADDRESS
U 0220, 0221,3441,0301,4174,4007,0700,0200,0014,0012	; 3745		FETCH			;GET NEXT INST
							; 3746	JSTAC1: AC_[ARX],		;STORE BACK STACK PTR
U 0221, 0100,3440,0404,0174,4156,4700,0400,0000,0000	; 3747		NEXT INST		;DO NEXT INST
							; 3748		AC_[ARX],		;UPDATE STACK POINTER
U 0222, 1400,3440,0404,0174,4007,0700,0400,0000,0000	; 3749		J/DONE			;DO NEXT INST
							; 3750	=
							; 3751	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 103
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ		

							; 3752	1545:
							; 3753	POP:	[ARX]_AC,		;GET POINTER
							; 3754		LOAD VMA,		;ADDRESS OF STACK WORD
							; 3755		START READ, 3T,		;START CYCLE
U 1545, 2740,3771,0004,0276,6007,0701,0200,0004,0712	; 3756		PXCT STACK WORD 	;FOR PXCT
							; 3757	
							; 3758		MEM READ,		;LOAD BR (QUIT IF PAGE FAIL)
U 2740, 2741,3771,0005,4365,5007,0700,0200,0000,0002	; 3759		[BR]_MEM		;STACK WORD TO BR
							; 3760	
							; 3761		[ARX]_[ARX]+#,		;UPDATE POINTER
							; 3762		#/777777,		;-1 IN EACH HALF
							; 3763		INH CRY18, 3T,		;BUT NO CARRY
U 2741, 1156,0551,0404,4374,4407,0311,0000,0077,7777	; 3764		SKIP CRY0		;SEE IF OVERFLOW
							; 3765	
							; 3766	=0	VMA_[AR],		;EFFECTIVE ADDRESS
							; 3767		PXCT DATA,		;FOR PXCT
							; 3768		START WRITE,		;WHERE TO STORE RESULT
U 1156, 2743,3443,0300,4174,4007,0700,0200,0003,0312	; 3769		J/POPX1			;OVERFLOW
							; 3770	
							; 3771		VMA_[AR],		;EFFECTIVE ADDRESS
							; 3772		PXCT DATA,		;FOR PXCT
U 1157, 2742,3443,0300,4174,4007,0700,0200,0003,0312	; 3773		START WRITE		;WHERE TO STORE RESULT
							; 3774	
							; 3775		MEM WRITE,		;WAIT FOR MEM
							; 3776		MEM_[BR],		;STORE BR
							; 3777		B DISP, 		;POP OR POPJ?
U 2742, 0220,3333,0005,4175,5003,7701,0200,0000,0002	; 3778		J/JSTAC 		;STORE POINTER
							; 3779	
							; 3780	
							; 3781	POPX1:	MEM WRITE,		;WAIT FOR MEMORY
							; 3782		MEM_[BR],		;STORE BR
U 2743, 2737,3333,0005,4175,5007,0701,0200,0000,0002	; 3783		J/SETPDL		;GO SET PDL OV
							; 3784	
							; 3785	1546:
							; 3786	POPJ:	[ARX]_AC,		;GET POINTER
							; 3787		LOAD VMA,		;POINT TO STACK WORD
							; 3788		PXCT STACK WORD, 3T,	;FOR PXCT
U 1546, 2744,3771,0004,0276,6007,0701,0200,0004,0712	; 3789		START READ		;START READ
							; 3790		[ARX]_[ARX]+#,		;UPDATE POINTER
							; 3791		#/777777,		;-1 IN BOTH HALFS
							; 3792		INH CRY18, 3T,		;INHIBIT CARRY 18
U 2744, 1164,0551,0404,4374,4407,0311,0000,0077,7777	; 3793		SKIP CRY0		;SEE IF OVERFLOW
U 1164, 1165,4443,0000,4174,4467,0700,0000,0001,2000	; 3794	=0	SET PDL OV		;SET OVERFLOW
							; 3795		MEM READ, [PC]_MEM,	;STICK DATA IN PC
							; 3796		HOLD LEFT,		;NO FLAGS
U 1165, 0221,3771,0001,4361,5007,0700,0200,0000,0002	; 3797		J/JSTAC1		;STORE POINTER
							; 3798	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 104
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			STACK INSTRUCTIONS -- ADJSP				

							; 3799	.TOC	"STACK INSTRUCTIONS -- ADJSP"
							; 3800	
							; 3801		.DCODE
D 0105, 0000,1551,3000					; 3802	105:	I-PF,	B/0,		J/ADJSP
							; 3803		.UCODE
							; 3804	
							; 3805	1551:
							; 3806	ADJSP:	[AR]_[AR] SWAP, 	;MAKE 2 COPIES OF RH
U 1551, 2745,3770,0303,4344,0007,0700,0000,0000,0000	; 3807		HOLD RIGHT
							; 3808		[BR]_AC,		;READ AC, SEE IF MINUS
							; 3809		3T,
U 2745, 1166,3771,0005,0276,6007,0521,0000,0000,0000	; 3810		SKIP DP0
							; 3811	=0	AC_[BR]+[AR],		;UPDATE AC
							; 3812		INH CRY18,		;NO CARRY
							; 3813		SKIP DP0,		;SEE IF STILL OK
							; 3814		3T,			;ALLOW TIME
U 1166, 1170,0113,0503,0174,4407,0521,0400,0000,0000	; 3815		J/ADJSP1		;TEST FOR OFLO
							; 3816		AC_[BR]+[AR],		;UPDATE AC
							; 3817		INH CRY18,		;NO CARRY
							; 3818		SKIP DP0,		;SEE IF STILL MINUS
							; 3819		3T,			;ALLOW TIME FOR SKIP
U 1167, 1172,0113,0503,0174,4407,0521,0400,0000,0000	; 3820		J/ADJSP2		;CONTINUE BELOW
							; 3821	
							; 3822	=0
U 1170, 0100,4443,0000,4174,4156,4700,0000,0000,0000	; 3823	ADJSP1: NEXT INST		;NO OVERFLOW
							; 3824		SET PDL OV,		;SET PDL OV
U 1171, 0555,4443,0000,4174,4467,0700,0000,0001,2000	; 3825		J/NIDISP		;GO DO NICOND DISP
							; 3826	
							; 3827	=0
							; 3828	ADJSP2: SET PDL OV,		;SET PDL OV
U 1172, 0555,4443,0000,4174,4467,0700,0000,0001,2000	; 3829		J/NIDISP		;GO DO NICOND DISP
U 1173, 0100,4443,0000,4174,4156,4700,0000,0000,0000	; 3830		NEXT INST		;NO OVERFLOW
							; 3831	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 105
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			SUBROUTINE CALL/RETURN -- JSR, JSP, JSA, JRA		

							; 3832	.TOC	"SUBROUTINE CALL/RETURN -- JSR, JSP, JSA, JRA"
							; 3833	
							; 3834		.DCODE
D 0264, 0000,1552,2100					; 3835	264:	I,		J/JSR
D 0265, 0000,1550,2100					; 3836		I,		J/JSP
D 0266, 0000,1554,2100					; 3837		I,		J/JSA
D 0267, 0000,1555,2100					; 3838		I,		J/JRA
							; 3839		.UCODE
							; 3840	
							; 3841	1550:
U 1550, 2746,3741,0105,4074,4007,0700,0000,0000,0000	; 3842	JSP:	[BR]_PC WITH FLAGS	;GET PC WITH FLAGS
							; 3843		CLR FPD,		;CLEAR FIRST-PART-DONE
							; 3844		AC_[BR],		;STORE FLAGS
U 2746, 0762,3440,0505,0174,4467,0700,0400,0005,0000	; 3845		J/JUMPA 		;GO JUMP
							; 3846	
							; 3847	1552:
							; 3848	JSR:	[BR]_PC WITH FLAGS,	;GET PC WITH FLAGS
U 1552, 2747,3741,0105,4074,4467,0700,0000,0005,0000	; 3849		CLR FPD 		;CLEAR FIRST-PART-DONE
							; 3850		VMA_[AR],		;EFFECTIVE ADDRESS
U 2747, 2750,3443,0300,4174,4007,0700,0200,0003,0012	; 3851		START WRITE		;STORE OLD PC WORD
							; 3852		MEM WRITE,		;WAIT FOR MEMORY
U 2750, 2751,3333,0005,4175,5007,0701,0200,0000,0002	; 3853		MEM_[BR]		;STORE
							; 3854		[PC]_[AR]+1000001,	;PC _ E+1
							; 3855		HOLD LEFT,		;NO JUNK IN LEFT
							; 3856		3T,			;ALLOW TIME FOR DBM
U 2751, 1400,0551,0301,4370,4007,0701,0000,0000,0001	; 3857		J/DONE	 		;[127] START AT E+1
							; 3858					;[127] MUST NICOND TO CLEAR TRAP CYCLE
							; 3859	
							; 3860	
							; 3861	
							; 3862	1554:
							; 3863	JSA:	[BR]_[AR],		;SAVE E
U 1554, 2752,3441,0305,4174,4007,0700,0200,0003,0002	; 3864		START WRITE		;START TO STORE
U 2752, 0130,3770,0304,4344,4007,0700,0000,0000,0000	; 3865		[ARX]_[AR] SWAP 	;ARX LEFT _ E
							; 3866	=0*0	[AR]_AC, 		;GET OLD AC
U 0130, 3114,3771,0003,0276,6007,0700,0010,0000,0000	; 3867		CALL [IBPX]		;SAVE AR IN MEMORY
							; 3868	=1*0	[ARX]_[PC],		;ARX NOW HAS E,,PC
							; 3869		HOLD LEFT,		; ..
U 0134, 3731,3441,0104,4170,4007,0700,0010,0000,0000	; 3870		CALL [AC_ARX]		;GO PUT ARX IN AC
							; 3871	=1*1	[PC]_[BR]+1000001,	;NEW PC
							; 3872		3T,			;ALLOW TIME
							; 3873		HOLD LEFT,		;NO JUNK IN PC LEFT
U 0135, 1400,0551,0501,4370,4007,0701,0000,0000,0001	; 3874		J/DONE	 		;[127] START AT E+1
							; 3875					;[127] NICOND MUST CLEAR TRAP CYCLE
							; 3876	=
							; 3877	
							; 3878	1555:
U 1555, 2753,3771,0005,0276,6007,0700,0000,0000,0000	; 3879	JRA:	[BR]_AC 		;GET AC
U 2753, 2754,3770,0505,4344,4007,0700,0000,0000,0000	; 3880		[BR]_[BR] SWAP		;OLD E IN BR RIGHT
							; 3881		VMA_[BR],		;LOAD VMA
U 2754, 2755,3443,0500,4174,4007,0700,0200,0004,0012	; 3882		START READ		;FETCH SAVED AC
							; 3883		MEM READ,		;WAIT FOR MEMORY
							; 3884		[BR]_MEM,		;LOAD BR WITH SAVE AC
U 2755, 0274,3771,0005,4365,5007,0700,0200,0000,0002	; 3885		J/JMPA			;GO JUMP
							; 3886	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 106
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 3887	.TOC	"ILLEGAL INSTRUCTIONS AND UUO'S"
							; 3888	;LUUO'S TRAP TO CURRENT CONTEXT
							; 3889	
							; 3890		.DCODE
D 0030, 0000,1557,2100					; 3891	030:	I,	B/0,	J/LUUO
D 0031, 0001,1557,2100					; 3892		I,	B/1,	J/LUUO
D 0032, 0002,1557,2100					; 3893		I,	B/2,	J/LUUO
D 0033, 0003,1557,2100					; 3894		I,	B/3,	J/LUUO
D 0034, 0004,1557,2100					; 3895		I,	B/4,	J/LUUO
D 0035, 0005,1557,2100					; 3896		I,	B/5,	J/LUUO
D 0036, 0006,1557,2100					; 3897		I,	B/6,	J/LUUO
D 0037, 0007,1557,2100					; 3898		I,	B/7,	J/LUUO
							; 3899	
							; 3900	;MONITOR UUO'S -- TRAP TO EXEC
							; 3901	
D 0040, 0000,1556,2100					; 3902	040:	I,		J/MUUO		;CALL
D 0041, 0000,1556,2100					; 3903		I,		J/MUUO		;INIT
D 0042, 0000,1556,2100					; 3904		I,		J/MUUO
D 0043, 0000,1556,2100					; 3905		I,		J/MUUO
D 0044, 0000,1556,2100					; 3906		I,		J/MUUO
D 0045, 0000,1556,2100					; 3907		I,		J/MUUO
D 0046, 0000,1556,2100					; 3908		I,		J/MUUO
D 0047, 0000,1556,2100					; 3909		I,		J/MUUO		;CALLI
D 0050, 0000,1556,2100					; 3910		I,		J/MUUO		;OPEN
D 0051, 0000,1556,2100					; 3911		I,		J/MUUO		;TTCALL
D 0052, 0000,1556,2100					; 3912		I,		J/MUUO
D 0053, 0000,1556,2100					; 3913		I,		J/MUUO
D 0054, 0000,1556,2100					; 3914		I,		J/MUUO
D 0055, 0000,1556,2100					; 3915		I,		J/MUUO		;RENAME
D 0056, 0000,1556,2100					; 3916		I,		J/MUUO		;IN
D 0057, 0000,1556,2100					; 3917		I,		J/MUUO		;OUT
D 0060, 0000,1556,2100					; 3918		I,		J/MUUO		;SETSTS
D 0061, 0000,1556,2100					; 3919		I,		J/MUUO		;STATO
D 0062, 0000,1556,2100					; 3920		I,		J/MUUO		;GETSTS
D 0063, 0000,1556,2100					; 3921		I,		J/MUUO		;STATZ
D 0064, 0000,1556,2100					; 3922		I,		J/MUUO		;INBUF
D 0065, 0000,1556,2100					; 3923		I,		J/MUUO		;OUTBUF
D 0066, 0000,1556,2100					; 3924		I,		J/MUUO		;INPUT
D 0067, 0000,1556,2100					; 3925		I,		J/MUUO		;OUTPUT
D 0070, 0000,1556,2100					; 3926		I,		J/MUUO		;CLOSE
D 0071, 0000,1556,2100					; 3927		I,		J/MUUO		;RELEAS
D 0072, 0000,1556,2100					; 3928		I,		J/MUUO		;MTAPE
D 0073, 0000,1556,2100					; 3929		I,		J/MUUO		;UGETF
D 0074, 0000,1556,2100					; 3930		I,		J/MUUO		;USETI
D 0075, 0000,1556,2100					; 3931		I,		J/MUUO		;USETO
D 0076, 0000,1556,2100					; 3932		I,		J/MUUO		;LOOKUP
D 0077, 0000,1556,2100					; 3933		I,		J/MUUO		;ENTER
							; 3934	
							; 3935	;EXPANSION OPCODES
							; 3936	
D 0100, 0000,1556,2100					; 3937	100:	I,		J/UUO		;UJEN
D 0101, 0000,1661,2100					; 3938		I,		J/UUO101
D 0102, 0000,1662,2100					; 3939		I,		J/UUO102	;GFAD
D 0103, 0000,1663,2100					; 3940		I,		J/UUO103	;GFSB
							; 3941	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 107
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 3942	;RESERVED OPCODES
							; 3943	
D 0000, 0000,1556,2100					; 3944	000:	I,		J/UUO
D 0104, 0000,1664,2100					; 3945	104:	I,		J/JSYS		;JSYS
D 0106, 0000,1666,2100					; 3946	106:	I,		J/UUO106	;GFMP
D 0107, 0000,1667,2100					; 3947		I,		J/UUO107	;GFDV
D 0130, 0000,1660,2100					; 3948	130:	I,	B/0,	J/FP-LONG	;UFA
D 0131, 0001,1660,2100					; 3949		I,	B/1,	J/FP-LONG	;DFN
D 0141, 0002,1660,2100					; 3950	141:	I,	B/2,	J/FP-LONG	;FADL
D 0151, 0003,1660,2100					; 3951	151:	I,	B/3,	J/FP-LONG	;FSBL
D 0161, 0004,1660,2100					; 3952	161:	I,	B/4,	J/FP-LONG	;FMPL
D 0171, 0005,1660,2100					; 3953	171:	I,	B/5,	J/FP-LONG	;FDVL
D 0247, 0000,1665,2100					; 3954	247:	I,		J/UUO247	;RESERVED
							; 3955		.UCODE
							; 3956	
							; 3957	1661:
U 1661, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3958	UUO101: UUO
							; 3959	1662:
U 1662, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3960	UUO102: UUO
							; 3961	1663:
U 1663, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3962	UUO103: UUO
							; 3963	1664:
U 1664, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3964	JSYS:	UUO
							; 3965	1666:
U 1666, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3966	UUO106: UUO
							; 3967	1667:
U 1667, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3968	UUO107: UUO
							; 3969	1660:
U 1660, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3970	FP-LONG:UUO
							; 3971	1665:
U 1665, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3972	UUO247: UUO
							; 3973	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 108
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 3974	;HERE FOR UUO'S WHICH TRAP TO EXEC
							; 3975	1556:
							; 3976	UUO:	;THIS TAG IS USED FOR ILLEGAL THINGS WHICH DO UUO TRAPS
							; 3977	MUUO:	;THIS TAG IS USED FOR MONITOR CALL INSTRUCTIONS
							; 3978		[HR]_[HR].AND.#,	;MASK OUT @ AND XR
							; 3979		#/777740,		;MASK
U 1556, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3980		HOLD RIGHT		;KEEP RIGHT
							; 3981	;THE UUO MACRO DOES THE ABOVE INSTRUCTION AND GOES TO UUOGO
U 2756, 1174,4751,1204,4374,4007,0700,0000,0000,0424	; 3982	UUOGO:	[ARX]_0 XWD [424]	;HERE FROM UUO MACRO
							; 3983					;GET OFFSET TO UPT
							; 3984	=0	[ARX]_[ARX]+[UBR],	;ADDRESS OF MUUO WORD
U 1174, 4047,0111,1104,4174,4007,0700,0010,0000,0000	; 3985		CALL [ABORT]		;STOP MEMORY
							; 3986	.IF/KIPAGE
							; 3987	.IF/KLPAGE
							; 3988		READ [EBR],		;IF BOTH POSSIBLE, SEE WHICH IS ENABLED
U 1175, 1176,3333,0010,4174,4007,0520,0000,0000,0000	; 3989		SKIP DP0		;KL PAGING ??
							; 3990	=0
							; 3991	.ENDIF/KLPAGE
							; 3992		READ [ARX],		;GET THE ADDRESS
							; 3993		LOAD VMA,		;START WRITE
							; 3994		VMA PHYSICAL WRITE,	;ABSOLUTE ADDRESS
U 1176, 0310,3333,0004,4174,4007,0700,0200,0021,1016	; 3995		J/KIMUUO		;GO STORE KI STYLE
							; 3996	.ENDIF/KIPAGE
							; 3997	.IF/KLPAGE
U 1177, 1200,3770,0203,4344,4007,0700,0000,0000,0000	; 3998		[AR]_[HR] SWAP		;PUT IN RIGHT HALF
							; 3999	=0	[AR]_FLAGS,		;FLAGS IN LEFT HALF
							; 4000		HOLD RIGHT,		;JUST WANT FLAGS
U 1200, 2764,4521,1203,4074,0007,0700,0010,0000,0000	; 4001		CALL [UUOFLG]		;CLEAR TRAP FLAGS
							; 4002		READ [ARX],		;LOOK AT ADDRESS
							; 4003		LOAD VMA,		;LOAD THE VMA
U 1201, 0314,3333,0004,4174,4007,0700,0200,0021,1016	; 4004		VMA PHYSICAL WRITE	;STORE FLAG WORD
							; 4005	=0*	MEM WRITE,		;WAIT FOR MEMORY
U 0314, 2765,3333,0003,4175,5007,0701,0210,0000,0002	; 4006		MEM_[AR], CALL [NEXT]	;STORE
							; 4007		MEM WRITE,		;WAIT FOR MEMORY
U 0316, 0020,3333,0001,4175,5007,0701,0200,0000,0002	; 4008		MEM_[PC]		;STORE FULL WORD PC
							; 4009	=000	[HR]_0, 		;SAVE E
U 0020, 2765,4221,0002,4174,0007,0700,0010,0000,0000	; 4010		HOLD RIGHT, CALL [NEXT]	;BUT CLEAR OPCODE
							; 4011	.ENDIF/KLPAGE
							; 4012	=010
							; 4013	UUOPCW: MEM WRITE,		;WAIT FOR MEMORY
							; 4014		MEM_[HR],		;STORE INSTRUCTION IN KI
							; 4015					; OR FULL WORD E IN KL
U 0022, 3603,3333,0002,4175,5007,0701,0210,0000,0002	; 4016		CALL [GETPCW]		;GET PROCESS-CONTEXT-WORD
							; 4017	
							; 4018	=011	NEXT [ARX] PHYSICAL WRITE, ;POINT TO NEXT WORD
U 0023, 3727,0111,0704,4170,4007,0700,0210,0023,1016	; 4019		CALL [STOBR]		;STORE PROCESS CONTEXT WORD
							; 4020	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 109
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 4021	;NOW WE MUST PICK ONE OF 8 NEW PC WORDS BASED ON PC FLAGS
U 0027, 2757,4751,1205,4374,4007,0700,0000,0000,0430	; 4022	=111	[BR]_0 XWD [430]	;OFFSET INTO UPT
							; 4023	=
U 2757, 2760,0111,1105,4174,4007,0700,0000,0000,0000	; 4024		[BR]_[BR]+[UBR] 	;ADDRESS OF WORD
U 2760, 2761,4521,1203,4074,4007,0700,0000,0000,0000	; 4025		[AR]_FLAGS		;GET FLAGS
							; 4026		TL [AR],		;LOOK AT FLAGS
U 2761, 1202,4553,0300,4374,4007,0321,0000,0000,0600	; 4027		#/600			;TRAP SET?
							; 4028	=0	[BR]_[BR].OR.#, 	;YES--POINT TO TRAP CASE
							; 4029		#/1,			; ..
U 1202, 1203,3551,0505,4370,4007,0700,0000,0000,0001	; 4030		HOLD LEFT		;LEAVE LEFT ALONE
							; 4031		TL [AR],		;USER OR EXEC
U 1203, 1204,4553,0300,4374,4007,0321,0000,0001,0000	; 4032		#/10000 		; ..
							; 4033	=0	[BR]_[BR].OR.#, 	;USER
							; 4034		#/4,			;POINT TO USER WORDS
U 1204, 1205,3551,0505,4370,4007,0700,0000,0000,0004	; 4035		HOLD LEFT
							; 4036		READ [BR],		;LOOK AT ADDRESS
							; 4037		LOAD VMA,		;PLACE IN VMA
							; 4038		VMA PHYSICAL,		;PHYSICAL ADDRESS
U 1205, 2762,3333,0005,4174,4007,0700,0200,0024,1016	; 4039		START READ		;GET NEW PC WORD
							; 4040	GOEXEC: MEM READ,		;WAIT FOR DATA
U 2762, 2763,3771,0003,4365,5007,0700,0200,0000,0002	; 4041		[AR]_MEM		;STICK IN AR
							; 4042		READ [AR],		;LOOK AT DATA
							; 4043		LOAD FLAGS,		;LOAD NEW FLAGS
							; 4044		LEAVE USER,		;ALLOW USER TO LOAD
							; 4045		LOAD PCU,		;SET PCU FROM USER
U 2763, 0762,3333,0003,4174,4467,0700,0000,0000,0404	; 4046		J/JUMPA 		;JUMP
							; 4047	
							; 4048	.IF/KIPAGE
							; 4049	;HERE FOR TOPS-10 STYLE PAGING
							; 4050	
							; 4051	=00
							; 4052	KIMUUO: MEM WRITE,		;STORE INSTRUCTION
U 0310, 2765,3333,0002,4175,5007,0701,0210,0000,0002	; 4053		MEM_[HR], CALL [NEXT]	;IN MEMORY
							; 4054	=10	[AR]_PC WITH FLAGS,	;GET PC WORD
U 0312, 2764,3741,0103,4074,4007,0700,0010,0000,0000	; 4055		CALL [UUOFLG]		;CLEAR TRAP FLAGS
							; 4056	=11	MEM WRITE,		;STORE PC WORD
							; 4057		MEM_[AR],		; ..
U 0313, 0022,3333,0003,4175,5007,0701,0200,0000,0002	; 4058		J/UUOPCW		;GO STORE PROCESS CONTEXT
							; 4059	.ENDIF/KIPAGE
							; 4060	
							; 4061	UUOFLG:	[AR]_[AR].AND.NOT.#,	;CLEAR TRAP FLAGS
							; 4062		#/600, HOLD RIGHT,	; IN WORD TO SAVE
U 2764, 0001,5551,0303,4374,0004,1700,0000,0000,0600	; 4063		RETURN [1]		; BACK TO CALLER
							; 4064	
							; 4065	NEXT:	NEXT [ARX] PHYSICAL WRITE, ;POINT TO NEXT WORD
U 2765, 0002,0111,0704,4170,4004,1700,0200,0023,1016	; 4066		RETURN [2]
							; 4067	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 110
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 4068	;HERE FOR LUUO'S
							; 4069	1557:
U 1557, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 4070	LUUO:	[AR]_0 XWD [40] 	;AR GET CONSTANT 40
							; 4071	;THE LUUO MACRO DOES THE ABOVE INSTRUCTION AND GOES TO LUUO1
							; 4072	400:				;FOR SIMULATOR
							; 4073	LUUO1:	READ [AR],		;LOAD 40 INTO
							; 4074		LOAD VMA,		; THE VMA AND
U 0400, 2766,3333,0003,4174,4007,0700,0200,0003,0012	; 4075		START WRITE		; PREPARE TO STORE
							; 4076		[HR]_[HR].AND.#,	;CLEAR OUT INDEX AND @
							; 4077		#/777740,		; ..
U 2766, 2767,4551,0202,4374,0007,0700,0000,0077,7740	; 4078		HOLD RIGHT
							; 4079		MEM WRITE,		;STORE LUUO IN 40
U 2767, 2770,3333,0002,4175,5007,0701,0200,0000,0002	; 4080		MEM_[HR]
							; 4081		VMA_[AR]+1,		;POINT TO 41
							; 4082		LOAD VMA,		;PUT 41 IN VMA
							; 4083		START READ,		;START FETCH
U 2770, 2525,0111,0703,4170,4007,0700,0200,0004,0012	; 4084		J/CONT1 		;GO EXECUTE THE INSTRUCTION
							; 4085	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 111
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- ADD, SUB					

							; 4086	.TOC	"ARITHMETIC -- ADD, SUB"
							; 4087	
							; 4088		.DCODE
D 0270, 1015,1560,1100					; 4089	270:	R-PF,	AC,	J/ADD
D 0271, 0015,1560,3000					; 4090		I-PF,	AC,	J/ADD
D 0272, 0016,1560,1700					; 4091		RW,	M,	J/ADD
D 0273, 0017,1560,1700					; 4092		RW,	B,	J/ADD
							; 4093		.UCODE
							; 4094	
							; 4095	1560:
							; 4096	ADD:	[AR]_[AR]+AC,		;DO THE ADD
U 1560, 1500,0551,0303,0274,4463,7701,0200,0001,0001	; 4097		AD FLAGS EXIT, 3T	;UPDATE CARRY FLAGS
							; 4098					;STORE ANSWER
							; 4099					;MISSES 3-TICKS BY 3 NS.
							; 4100	
							; 4101	
							; 4102		.DCODE
D 0274, 1015,1561,1100					; 4103	274:	R-PF,	AC,	J/SUB
D 0275, 0015,1561,3000					; 4104		I-PF,	AC,	J/SUB
D 0276, 0016,1561,1700					; 4105		RW,	M,	J/SUB
D 0277, 0017,1561,1700					; 4106		RW,	B,	J/SUB
							; 4107		.UCODE
							; 4108	
							; 4109	1561:
							; 4110	SUB:	[AR]_AC-[AR],		;DO THE SUBTRACT
U 1561, 1500,2551,0303,0274,4463,7701,4200,0001,0001	; 4111		AD FLAGS EXIT, 3T	;UPDATE PC CARRY FLAGS
							; 4112					;ALL DONE
							; 4113					;MISSES 3-TICKS BY 3 NS.
							; 4114	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 112
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DADD, DSUB				

							; 4115	.TOC	"ARITHMETIC -- DADD, DSUB"
							; 4116	
							; 4117		.DCODE
D 0114, 0205,1457,1100					; 4118	114:	DBL R,	DAC,	J/DADD
D 0115, 0205,1615,1100					; 4119		DBL R,	DAC,	J/DSUB
							; 4120		.UCODE
							; 4121	
							; 4122	1457:
							; 4123	DADD:	[ARX]_[ARX]+AC[1], 4T,	;ADD LOW WORDS
U 1457, 1206,0551,0404,1274,4007,0562,0000,0000,1441	; 4124		SKIP CRY1		;SEE IF CARRY TO HIGH WORD
							; 4125	=0
							; 4126	DADD1:	[AR]_[AR]+AC,		;ADD HIGH WORDS
							; 4127		ADD .25,		;ADD IN ANY CARRY FROM LOW WORD
							; 4128		AD FLAGS, 4T,		;UPDATE PC FLAGS
U 1206, 2772,0551,0303,0274,4467,0702,4000,0001,0001	; 4129		J/CPYSGN		;COPY SIGN TO LOW WORD
U 1207, 2771,7441,1205,4174,4007,0700,0000,0000,0000	; 4130		[BR]_.NOT.[MASK]	;SET BITS 35 AND 36 IN
							; 4131		[AR]_[AR].OR.[BR],	; AR SO THAT ADD .25 WILL
U 2771, 1206,3111,0503,4170,4007,0700,0000,0000,0000	; 4132		HOLD LEFT, J/DADD1	; ADD 1.
							; 4133	
							; 4134	1615:
							; 4135	DSUB:	[ARX]_AC[1]-[ARX], 4T,	;SUBTRACT LOW WORD
U 1615, 1210,2551,0404,1274,4007,0562,4000,0000,1441	; 4136		SKIP CRY1		;SEE IF CARRY
							; 4137	=0	[AR]_AC-[AR]-.25,	;NO CARRY
							; 4138		AD FLAGS, 4T,		;UPDATE PC FLAGS
U 1210, 2772,2551,0303,0274,4467,0702,0000,0001,0001	; 4139		J/CPYSGN		;GO COPY SIGN
							; 4140		[AR]_AC-[AR], 4T,	;THERE WAS A CARRY
U 1211, 2772,2551,0303,0274,4467,0702,4000,0001,0001	; 4141		AD FLAGS		;UPDATE CARRY FLAGS
							; 4142	
U 2772, 1212,3770,0303,4174,0007,0520,0000,0000,0000	; 4143	CPYSGN: FIX [AR] SIGN, SKIP DP0
U 1212, 1404,4551,0404,4374,0007,0700,0000,0037,7777	; 4144	=0	[ARX]_[ARX].AND.#, #/377777, HOLD RIGHT, J/MOVE
U 1213, 1404,3551,0404,4374,0007,0700,0000,0040,0000	; 4145		[ARX]_[ARX].OR.#, #/400000, HOLD RIGHT, J/MOVE
							; 4146	
							; 4147	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 113
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- MUL, IMUL					

							; 4148	.TOC	"ARITHMETIC -- MUL, IMUL"
							; 4149	
							; 4150		.DCODE
D 0220, 1015,1641,1100					; 4151	220:	R-PF,	AC,	J/IMUL
D 0221, 0015,1641,3000					; 4152		I-PF,	AC,	J/IMUL
D 0222, 0016,1641,1700					; 4153		RW,	M,	J/IMUL
D 0223, 0017,1641,1700					; 4154		RW,	B,	J/IMUL
							; 4155		.UCODE
							; 4156	1641:
U 1641, 2773,3441,0306,0174,4007,0700,0000,0000,0000	; 4157	IMUL:	[BRX]_[AR], AC		;COPY C(E)
U 2773, 0021,3772,0000,0275,5007,0700,2000,0071,0043	; 4158		Q_AC, SC_35.		;GET THE AC
							; 4159	=0**	[BRX]_[BRX]*.5 LONG,	;SHIFT RIGHT
U 0021, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 4160		CALL [MULSUB]		;MULTIPLY
U 0025, 1214,3333,0004,4174,4007,0621,0000,0000,0000	; 4161		READ [ARX], SKIP AD.EQ.0 ;SEE IF FITS
U 1214, 2774,3445,0404,4174,4007,0700,0000,0000,0000	; 4162	=0	[ARX]_[ARX]*2, J/IMUL2	;NOT ZERO--SHIFT LEFT
U 1215, 1500,3221,0003,4174,4003,7700,0200,0003,0001	; 4163	IMUL1:	[AR]_Q, EXIT		;POSITIVE
							; 4164	
							; 4165	IMUL2:	[MASK].AND.NOT.[ARX],	;SEE IF ALL SIGN BITS
U 2774, 1216,5113,0412,4174,4007,0621,0000,0000,0000	; 4166		SKIP AD.EQ.0		; ..
							; 4167	=0	FIX [ARX] SIGN, 	;NOT ALL SIGN BITS
U 1216, 1220,3770,0404,4174,0007,0520,0000,0000,0000	; 4168		SKIP DP0, J/IMUL3	;GIVE + OR - OVERFLOW
U 1217, 1500,7001,0003,4174,4003,7700,0200,0003,0001	; 4169		[AR]_[MAG].EQV.Q, EXIT	;NEGATIVE
							; 4170	=0
U 1220, 1404,3221,0003,4174,4467,0700,0000,0041,1000	; 4171	IMUL3:	[AR]_Q, SET AROV, J/MOVE
U 1221, 1404,7001,0003,4174,4467,0700,0000,0041,1000	; 4172		[AR]_[MAG].EQV.Q, SET AROV, J/MOVE
							; 4173	
							; 4174	
							; 4175		.DCODE
D 0224, 1005,1571,1100					; 4176	224:	R-PF,	DAC,	J/MUL
D 0225, 0005,1571,3000					; 4177		I-PF,	DAC,	J/MUL
D 0226, 0016,1571,1700					; 4178		RW,	M,	J/MUL
D 0227, 0006,1571,1700					; 4179		RW,	DBL B,	J/MUL
							; 4180		.UCODE
							; 4181	
							; 4182	
							; 4183	1571:
U 1571, 2775,3442,0300,0174,4007,0700,0000,0000,0000	; 4184	MUL:	Q_[AR], AC		;COPY C(E)
U 2775, 2776,3441,0316,4174,4007,0700,0000,0000,0000	; 4185		[T0]_[AR]		;SAVE FOR OVERFLOW TEST
U 2776, 0031,3771,0006,0276,6007,0700,2000,0071,0043	; 4186		[BRX]_AC, SC_35.	;GET THE AC
							; 4187	=0**	[BRX]_[BRX]*.5 LONG,	;SHIFT OVER
U 0031, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 4188		CALL [MULSUB]		;MULTIPLY
U 0035, 2777,3445,0403,4174,4007,0700,0000,0000,0000	; 4189		[AR]_[ARX]*2		;SHIFT OVER
U 2777, 1222,3770,0303,4174,0007,0520,0000,0000,0000	; 4190		FIX [AR] SIGN, SKIP DP0 ;SEE IF NEGATIVE
							; 4191	=0	[ARX]_[MAG].AND.Q,	;POSITIVE
U 1222, 1500,4001,0004,4174,4003,7700,0200,0003,0001	; 4192		EXIT
U 1223, 1224,4113,0616,4174,4007,0520,0000,0000,0000	; 4193		[T0].AND.[BRX], SKIP DP0 ;TRIED TO SQUARE 1B0?
U 1224, 1500,7001,0004,4174,4003,7700,0200,0003,0001	; 4194	=0	[ARX]_[MAG].EQV.Q, EXIT	;NO
							; 4195		[ARX]_[MAG].EQV.Q, 	;YES 
U 1225, 1404,7001,0004,4174,4467,0700,0000,0041,1000	; 4196		SET AROV, J/MOVE
							; 4197	
							; 4198	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 114
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

							; 4199	.TOC	"ARITHMETIC -- DMUL"
							; 4200	
							; 4201		.DCODE
D 0116, 0205,1566,1100					; 4202	116:	DBL R,	DAC,		J/DMUL
							; 4203		.UCODE
							; 4204	
							; 4205	.IF/FULL
							; 4206	1566:
U 1566, 3000,3447,0303,4174,4007,0700,0000,0000,0000	; 4207	DMUL:	[AR]_[AR]*.5		;SHIFT MEM OPERAND RIGHT
U 3000, 3001,4117,0004,4174,4007,0700,0000,0000,0000	; 4208		[ARX]_([ARX].AND.[MAG])*.5
							; 4209		[BR]_[ARX],		;COPY LOW WORD
U 3001, 0120,3441,0405,4174,4007,0350,0000,0000,0000	; 4210		SKIP FPD		;SEE IF FIRST PART DONE
							; 4211	;
							; 4212	; BRX * BR ==> C(E+1) * C(AC+1)
							; 4213	;
							; 4214	=000	[BRX]_(AC[1].AND.[MAG])*.5, 3T, ;GET LOW AC
U 0120, 3013,4557,0006,1274,4007,0701,0010,0000,1441	; 4215		CALL [DMULGO]		;START MULTIPLY
							; 4216		[ARX]_(AC[2].AND.[MAG])*.5, 3T, ;FIRST PART DONE
U 0121, 3003,4557,0004,1274,4007,0701,0000,0000,1442	; 4217		J/DMUL1 		;GO DO SECOND PART
U 0124, 0171,3223,0000,1174,4007,0700,0400,0000,1443	; 4218	=100	AC[3]_Q 		;SALT AWAY 1 WORD OF PRODUCT
							; 4219	=
							; 4220	;
							; 4221	; BRX * Q ==> C(E) * C(AC+1)
							; 4222	;
							; 4223	=0**	Q_[AR], SC_35., 	;GO MULT NEXT HUNK
U 0171, 0563,3442,0300,4174,4007,0700,2010,0071,0043	; 4224		CALL [QMULT]		; ..
U 0175, 3002,3441,0416,4174,4007,0700,0000,0000,0000	; 4225		[T0]_[ARX]		;SAVE PRODUCT
							; 4226		AC[2]_Q, [ARX]_Q*.5,	;SAVE PRODUCT
U 3002, 0410,3227,0004,1174,4007,0700,0400,0000,1442	; 4227		J/DMUL2			;GO DO HIGH HALF
U 3003, 0410,3777,0016,1276,6007,0701,0000,0000,1441	; 4228	DMUL1:	[T0]_AC[1]*.5		;RESTORE T0
							; 4229	=0*0
							; 4230	;
							; 4231	; BRX * BR ==> C(AC) * C(E+1)
							; 4232	;
							; 4233	DMUL2:	[BRX]_AC*.5,		;PREPARE TO DO HIGH HALF
U 0410, 3014,3777,0006,0274,4007,0701,0010,0000,0000	; 4234		CALL [DBLMUL]		; GO DO IT
							; 4235		AC[1]_[T0]*2, 3T,	;INTERRUPT, SAVE T0
U 0411, 3016,0113,1616,1174,4007,0701,0400,0000,1441	; 4236		J/DMLINT		;SET FPD AND INTERRUPT
U 0414, 3004,3223,0000,1174,4007,0700,0400,0000,1442	; 4237		AC[2]_Q 		;SAVE PRODUCT
							; 4238	=
U 3004, 0543,0111,1604,4174,4007,0700,0000,0000,0000	; 4239		[ARX]_[ARX]+[T0]	;PREPARE FOR LAST MUL
							; 4240	;
							; 4241	; BRX * Q ==> C(AC) * C(E)
							; 4242	;
							; 4243	=0**	Q_[AR], SC_35., 	;DO THE LAST MULTIPLY
U 0543, 0563,3442,0300,4174,4007,0700,2010,0071,0043	; 4244		CALL [QMULT]		; GO DO IT
							; 4245		[ARX]_[ARX]*2,		;SHIFT BACK
U 0547, 3005,3445,0404,4174,4467,0700,0000,0005,0000	; 4246		CLR FPD 		;CLEAR FPD
							; 4247	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 115
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

U 3005, 1226,3770,0404,0174,4007,0520,0400,0000,0000	; 4248		AC_[ARX] TEST, SKIP DP0 ;PUT BACK INTO AC
U 1226, 3012,3223,0000,1174,4007,0700,0400,0000,1441	; 4249	=0	AC[1]_Q, J/DMTRAP	;POSITIVE
U 1227, 3006,7003,0000,1174,4007,0700,0400,0000,1441	; 4250		AC[1]_[MAG].EQV.Q	;NEGATIVE
U 3006, 3007,3772,0000,1275,5007,0701,0000,0000,1442	; 4251		Q_AC[2]
U 3007, 3010,7003,0000,1174,4007,0700,0400,0000,1442	; 4252		AC[2]_[MAG].EQV.Q
U 3010, 3011,3772,0000,1275,5007,0701,0000,0000,1443	; 4253		Q_AC[3]
U 3011, 3012,7003,0000,1174,4007,0700,0400,0000,1443	; 4254		AC[3]_[MAG].EQV.Q
							; 4255	DMTRAP: [AR]_PC WITH FLAGS,	;LOOK AT FLAGS
U 3012, 1230,3741,0103,4074,4007,0520,0000,0000,0000	; 4256		SKIP DP0		;SEE IF AROV SET?
U 1230, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 4257	=0	DONE			;NO--ALL DONE
U 1231, 1400,4443,0000,4174,4467,0700,0000,0041,1000	; 4258		SET AROV, J/DONE	;YES--FORCE TRAP 1 ALSO
							; 4259	
							; 4260	
							; 4261	;WAYS TO CALL MULTIPLY
U 3013, 3014,4221,0004,4174,4007,0700,0000,0000,0000	; 4262	DMULGO: [ARX]_0 		;CLEAR ARX
U 3014, 3015,3442,0500,4174,4007,0700,2000,0071,0043	; 4263	DBLMUL: Q_[BR], SC_35.
U 3015, 0563,3447,0606,4174,4007,0700,0000,0000,0000	; 4264		[BRX]_[BRX]*.5
							; 4265	=0**
							; 4266	QMULT:	Q_Q*.5,
U 0563, 3021,3446,1200,4174,4007,0700,0010,0000,0000	; 4267		CALL [MULTIPLY]
							; 4268		[ARX]+[ARX], AD FLAGS,	;TEST FOR OVERFLOW
U 0567, 0004,0113,0404,4174,4464,1701,0000,0001,0001	; 4269		3T, RETURN [4]		;AND RETURN
							; 4270	
U 3016, 2717,4443,0000,4174,4467,0700,0000,0003,0000	; 4271	DMLINT: SET FPD, J/FIXPC	;SET FPD, BACKUP PC
							; 4272					; INTERRUPT
							;;4273	.IFNOT/FULL
							;;4274	1566:
							;;4275	DMUL:	UUO
							; 4276	.ENDIF/FULL
							; 4277	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 116
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

							; 4278	;MULTIPLY SUBROUTINE
							; 4279	;ENTERED WITH:
							; 4280	;	MULTIPLIER IN Q
							; 4281	;	MULTIPLICAND IN BRX
							; 4282	;RETURNS 4 WITH PRODUCT IN ARX!Q
							; 4283	
							; 4284	MUL STEP	"A/BRX,B/ARX,DEST/Q_Q*.5,ASHC,STEP SC,MUL DISP"
							; 4285	MUL FINAL	"A/BRX,B/ARX,DEST/Q_Q*2"
							; 4286	
U 3017, 3020,3446,0606,4174,4007,0700,0000,0000,0000	; 4287	MULSUB: [BRX]_[BRX]*.5 LONG
							; 4288	MULSB1: [ARX]_0*.5 LONG,	;CLEAR ARX AND SHIFT Q
							; 4289		STEP SC,		;COUNT FIRST STEP
U 3020, 0122,4226,0004,4174,4007,0630,2000,0060,0000	; 4290		J/MUL+			;ENTER LOOP
							; 4291	
							; 4292	;MULTIPLY SUBROUTINE
							; 4293	;ENTERED WITH:
							; 4294	;	MULTIPLIER IN Q
							; 4295	;	MULTIPLICAND IN BRX
							; 4296	;	PARTIAL PRODUCT IN ARX
							; 4297	;RETURNS 4 WITH Q*BRX+ARX IN ARX!Q
							; 4298	
							; 4299	MULTIPLY:
							; 4300		Q_Q*.5, 		;SHIFT Q
							; 4301		STEP SC,		;COUNT FIRST STEP
U 3021, 0122,3446,1200,4174,4007,0630,2000,0060,0000	; 4302		J/MUL+			;ENTER LOOP
							; 4303	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 117
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

							; 4304	;HERE FOR POSITIVE STEPS
							; 4305	=010				;0 IN A POSITIVE STEP
							; 4306	MUL+:	AD/B,			;DON'T ADD
							; 4307		MUL STEP,		;SHIFT
U 0122, 0122,3336,0604,4174,4046,2630,2000,0060,0000	; 4308		J/MUL+			;KEEP POSITIVE
							; 4309	=011				;DONE
							; 4310		AD/B,			;DON'T ADD
							; 4311		MUL FINAL,		;SHIFT
U 0123, 0004,3334,0604,4174,4004,1700,0000,0000,0000	; 4312		RETURN [4]		;SHIFT Q AND RETURN
							; 4313	=110				;1 IN A POSITIVE STEP
							; 4314		AD/B-A-.25, ADD .25,	;SUBTRACT
							; 4315		MUL STEP,		;SHIFT AND COUNT
U 0126, 0142,1116,0604,4174,4046,2630,6000,0060,0000	; 4316		J/MUL-			;NEGATIVE NOW
							; 4317	=111				;DONE
							; 4318		AD/B-A-.25, ADD .25,	;SUBTRACT
							; 4319		MUL FINAL,		;SHIFT
U 0127, 0004,1114,0604,4174,4004,1700,4000,0000,0000	; 4320		RETURN [4]		; AND RETURN
							; 4321	
							; 4322	;HERE FOR NEGATIVE STEPS
							; 4323	=010				;0 IN NEGATIVE STEP
							; 4324	MUL-:	AD/A+B, 		;ADD
							; 4325		MUL STEP,		;SHIFT AND COUNT
U 0142, 0122,0116,0604,4174,4046,2630,2000,0060,0000	; 4326		J/MUL+			;POSITIVE NOW
							; 4327	=011				;DONE
							; 4328		AD/A+B, 		;ADD
							; 4329		MUL FINAL,		;SHIFT
U 0143, 0004,0114,0604,4174,4004,1700,0000,0000,0000	; 4330		RETURN [4]			;FIX Q AND RETURN
							; 4331	=110				;1 IN NEGATIVE STEP
							; 4332		AD/B,			;DON'T ADD
							; 4333		MUL STEP,		;SHIFT AND COUNT
U 0146, 0142,3336,0604,4174,4046,2630,2000,0060,0000	; 4334		J/MUL-			;STILL NEGATIVE
							; 4335	=111				;DONE
							; 4336		AD/B,			;DON'T ADD
							; 4337		MUL FINAL,		;SHIFT
U 0147, 0004,3334,0604,4174,4004,1700,0000,0000,0000	; 4338		RETURN [4]			;FIX Q AND RETURN
							; 4339	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 118
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIV, IDIV					

							; 4340	.TOC	"ARITHMETIC -- DIV, IDIV"
							; 4341	
							; 4342		.DCODE
D 0230, 1005,1600,1100					; 4343	230:	R-PF,	DAC,	J/IDIV
D 0231, 0005,1600,3000					; 4344		I-PF,	DAC,	J/IDIV
D 0232, 0016,1600,1700					; 4345		RW,	M,	J/IDIV
D 0233, 0006,1600,1700					; 4346		RW,	DBL B,	J/IDIV
							; 4347	
D 0234, 1005,1601,1100					; 4348	234:	R-PF,	DAC,	J/DIV
D 0235, 0005,1601,3000					; 4349		I-PF,	DAC,	J/DIV
D 0236, 0016,1601,1700					; 4350		RW,	M,	J/DIV
D 0237, 0006,1601,1700					; 4351		RW,	DBL B,	J/DIV
							; 4352		.UCODE
							; 4353	
							; 4354	1600:
U 1600, 3022,3441,0305,0174,4007,0700,0000,0000,0000	; 4355	IDIV:	[BR]_[AR], AC		;COPY MEMORY OPERAND
							; 4356		Q_AC,			;LOAD Q
U 3022, 1232,3772,0000,0275,5007,0520,0000,0000,0000	; 4357		SKIP DP0		;SEE IF MINUS
							; 4358	=0	[AR]_0, 		;EXTEND + SIGN
U 1232, 0161,4221,0003,4174,4007,0700,0000,0000,0000	; 4359		J/DIV1			;NOW SAME AS DIV
							; 4360		[AR]_-1,		;EXTEND - SIGN
U 1233, 0161,2441,0703,4174,4007,0700,4000,0000,0000	; 4361		J/DIV1			;SAME AS DIV
							; 4362	
							; 4363	1601:
U 1601, 3023,3441,0305,4174,4007,0700,0000,0000,0000	; 4364	DIV:	[BR]_[AR]		;COPY MEM OPERAND
U 3023, 3024,3771,0003,0276,6007,0700,0000,0000,0000	; 4365		[AR]_AC 		;GET AC
U 3024, 3025,3772,0000,1275,5007,0701,0000,0000,1441	; 4366		Q_AC[1] 		;AND AC+1
							; 4367		READ [AR],		;TEST FOR NO DIVIDE
U 3025, 0160,3333,0003,4174,4007,0621,0000,0000,0000	; 4368		SKIP AD.EQ.0
							; 4369	=000	.NOT.[AR],		;SEE IF ALL SIGN BITS IN AR
							; 4370		SKIP AD.EQ.0,		; ..
U 0160, 1234,7443,0300,4174,4007,0621,0000,0000,0000	; 4371		J/DIVA			;CONTINUE BELOW
							; 4372	=001
							; 4373	DIV1:	READ [BR],		;SEE IF DIVIDE BY
U 0161, 0164,3333,0005,4174,4007,0621,0000,0000,0000	; 4374		SKIP AD.EQ.0		; ZERO
							; 4375	=100
							; 4376	DIV2:	SC_34., 		;NOT ZERO--LOAD STEP COUNT
U 0164, 0370,4443,0000,4174,4007,0700,2010,0071,0042	; 4377		CALL [DIVSUB]		;DIVIDE
U 0165, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4378	=101	NO DIVIDE		;DIVIDE BY ZERO
							; 4379	=110	[ARX]_[AR],		;COPY REMAINDER
U 0166, 1215,3441,0304,4174,4007,0700,0000,0000,0000	; 4380		J/IMUL1 		;STORE ANSWER
							; 4381	=
							; 4382	
							; 4383	
							; 4384	=0
							; 4385	DIVA:	[BRX]_[AR],		;HIGH WORD IS NOT SIGNS
U 1234, 3026,3441,0306,4174,4007,0700,0000,0000,0000	; 4386		J/DIVB			;GO TEST FOR NO DIVIDE
							; 4387		READ [BR],		;ALL SIGN BITS
							; 4388		SKIP AD.EQ.0,		;SEE IF ZERO DIVIDE
U 1235, 0164,3333,0005,4174,4007,0621,0000,0000,0000	; 4389		J/DIV2			;BACK TO MAIN FLOW
							; 4390	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 119
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIV, IDIV					

U 3026, 3027,3221,0004,4174,4007,0700,0000,0000,0000	; 4391	DIVB:	[ARX]_Q 		;MAKE ABS VALUES
							; 4392		READ [AR],		;SEE IF +
U 3027, 0330,3333,0003,4174,4007,0520,0000,0000,0000	; 4393		SKIP DP0
							; 4394	=00	READ [BR],		;SEE IF +
							; 4395		SKIP DP0,
U 0330, 1236,3333,0005,4174,4007,0520,0000,0000,0000	; 4396		J/DIVC			;CONTINUE BELOW
							; 4397		CLEAR [ARX]0,		;FLUSH DUPLICATE SIGN
U 0331, 3110,4551,0404,4374,0007,0700,0010,0037,7777	; 4398		CALL [DBLNG1]		;NEGATE AR!ARX
							; 4399	=11	READ [BR],		;SEE IF TOO BIG
							; 4400		SKIP DP0,
U 0333, 1236,3333,0005,4174,4007,0520,0000,0000,0000	; 4401		J/DIVC
							; 4402	=
							; 4403	=0
							; 4404	DIVC:	[AR]-[BR],		;COMPUTE DIFFERENCE
							; 4405		SKIP DP0,		;SEE IF IT GOES
							; 4406		3T,			;ALLOW TIME
U 1236, 1240,2113,0305,4174,4007,0521,4000,0000,0000	; 4407		J/NODIV 		;TEST
							; 4408		[AR]+[BR],
							; 4409		SKIP DP0,		;SAME TEST FOR -VE BR
							; 4410		3T,
U 1237, 1240,0113,0305,4174,4007,0521,0000,0000,0000	; 4411		J/NODIV
							; 4412	=0
U 1240, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4413	NODIV:	NO DIVIDE		;TOO BIG
							; 4414		[AR]_[BRX],		;FITS
U 1241, 0161,3441,0603,4174,4007,0700,0000,0000,0000	; 4415		J/DIV1			;GO BACK AND DIVIDE
							; 4416	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 120
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DDIV					

							; 4417	.TOC	"ARITHMETIC -- DDIV"
							; 4418	
							; 4419		.DCODE
D 0117, 0205,1627,1100					; 4420	117:	DBL R,	DAC,	J/DDIV
							; 4421		.UCODE
							; 4422	
							; 4423	.IF/FULL
							; 4424	1627:
U 1627, 3030,4112,0400,4174,4007,0700,0000,0000,0000	; 4425	DDIV:	Q_[ARX].AND.[MAG]	;COPY LOW WORD
							; 4426		[BR]_[AR]*.5,		;COPY MEMORY OPERAND
U 3030, 1242,3447,0305,4174,4007,0421,0000,0000,0000	; 4427		SKIP AD.LE.0		;SEE IF POSITIVE
							; 4428	=0	[BR]_[BR]*.5 LONG,	;POSITIVE
U 1242, 1246,3446,0505,4174,4007,0700,0000,0000,0000	; 4429		J/DDIV1 		;CONTINUE BELOW
							; 4430		[BR]_[BR]*.5 LONG,	;NEGATIVE OR ZERO
U 1243, 1244,3446,0505,4174,4007,0520,0000,0000,0000	; 4431		SKIP DP0		;SEE WHICH?
							; 4432	=0	[MAG].AND.Q,		;SEE IF ALL ZERO
U 1244, 1246,4003,0000,4174,4007,0621,0000,0000,0000	; 4433		SKIP AD.EQ.0, J/DDIV1	;CONTINUE BELOW
U 1245, 3031,4751,1217,4374,4007,0700,0000,0000,0005	; 4434		[T1]_0 XWD [5]		;NEGATE MEM OP
							; 4435		Q_Q.OR.#, #/600000,	;SIGN EXTEND THE LOW
U 3031, 3032,3662,0000,4374,0007,0700,0000,0060,0000	; 4436		HOLD RIGHT		; WORD
U 3032, 3033,2222,0000,4174,4007,0700,4000,0000,0000	; 4437		Q_-Q			;MAKE Q POSITIVE
							; 4438		[BR]_(-[BR]-.25)*.5 LONG, ;NEGATE HIGH WORD
							; 4439		ASHC, MULTI PREC/1,	;USE CARRY FROM LOW WORD
U 3033, 3035,2446,0505,4174,4047,0700,0040,0000,0000	; 4440		J/DDIV3 		;CONTINUE BELOW
							; 4441	=0
							; 4442	DDIV1:	[BR]_[BR]*.5 LONG,	;SHIFT OVER 1 PLACE
U 1246, 3034,3446,0505,4174,4047,0700,0000,0000,0000	; 4443		ASHC, J/DDIV2		;CONTINUE BELOW
U 1247, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4444		NO DIVIDE		;DIVIDE BY ZERO
U 3034, 3035,4751,1217,4374,4007,0700,0000,0000,0004	; 4445	DDIV2:	[T1]_0 XWD [4]		;MEM OPERAND IS POSITIVE
U 3035, 3036,3221,0006,0174,4007,0700,0000,0000,0000	; 4446	DDIV3:	[BRX]_Q, AC		;COPY Q
							; 4447	
U 3036, 0054,3777,0003,0274,4007,0520,0000,0000,0000	; 4448		[AR]_AC*.5, 2T, SKIP DP0 ;GET AC--SEE IF NEGATIVE
							; 4449	=0*1*0
							; 4450	DDIV3A:	Q_AC[1].AND.[MAG],	;POSITIVE (OR ZERO)
U 0054, 1250,4552,0000,1275,5007,0701,0000,0000,1441	; 4451		J/DDIV4 		;CONTINUE BELOW
							; 4452		[T1]_[T1].XOR.#,	;NEGATIVE
U 0055, 3077,6551,1717,4374,4007,0700,0010,0000,0007	; 4453		#/7, CALL [QDNEG]	;UPDATE SAVED FLAGS
							; 4454	=1*1*1	[AR]_[AR]*.5,		;SHIFT AR OVER
U 0075, 0054,3447,0303,4174,4007,0700,0000,0000,0000	; 4455		J/DDIV3A		;GO BACK AND LOAD Q
							; 4456	=
							; 4457	=0
							; 4458	DDIV4:	[AR]_[AR]*.5 LONG,	;SHIFT AR OVER
U 1250, 3061,3446,0303,4174,4007,0700,0010,0000,0000	; 4459		CALL [DDIVS]		;SHIFT 1 MORE PLACE
U 1251, 1252,2113,0305,4174,4007,0521,4000,0000,0000	; 4460		[AR]-[BR], 3T, SKIP DP0 ;TEST MAGNITUDE
							; 4461	=0	[AR]-[BR], 2T,
U 1252, 1254,2113,0305,4174,4007,0620,4000,0000,0000	; 4462		SKIP AD.EQ.0, J/DDIV5
U 1253, 3037,3221,0004,4174,4007,0700,0000,0000,0000	; 4463		[ARX]_Q, J/DDIV5A	;ANSWER FITS
							; 4464	
							; 4465	=0
U 1254, 0033,3333,0017,4174,4003,5701,0000,0000,0000	; 4466	DDIV5:	READ [T1], 3T, DISP/DP, J/NODDIV
U 1255, 1256,1003,0600,4174,4007,0521,4000,0000,0000	; 4467		Q-[BRX], 3T, SKIP DP0
U 1256, 0033,3333,0017,4174,4003,5701,0000,0000,0000	; 4468	=0	READ [T1], 3T, DISP/DP, J/NODDIV
U 1257, 3037,3221,0004,4174,4007,0700,0000,0000,0000	; 4469		[ARX]_Q 		;COPY LOW WORD
							; 4470	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 121
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DDIV					

							; 4471	;HERE WITH EVERYTHING SETUP AND READY TO GO
U 3037, 0354,4552,0000,1275,5007,0701,0000,0000,1442	; 4472	DDIV5A: Q_AC[2].AND.[MAG]
U 0354, 1302,3446,1200,4174,4007,0700,2010,0071,0042	; 4473	=0*	Q_Q*.5, SC_34., CALL [DBLDIV]
U 0356, 3040,3224,0016,4174,4007,0700,0000,0000,0000	; 4474		[T0]_Q*2 LONG
U 3040, 3041,0002,1600,4174,4007,0700,0000,0000,0000	; 4475		Q_Q+[T0]
U 3041, 1260,4003,0000,1174,4007,0700,0400,0000,1440	; 4476		AC[0]_Q.AND.[MAG]	;STORE ANSWER
U 1260, 3061,3442,0400,4174,4007,0700,0010,0000,0000	; 4477	=0	Q_[ARX], CALL [DDIVS]	;SHIFT OUT EXTRA ZERO BIT
U 1261, 3042,3221,0004,4174,4007,0700,0000,0000,0000	; 4478		[ARX]_Q 		; ..
U 3042, 0551,4552,0000,1275,5007,0701,0000,0000,1443	; 4479		Q_AC[3].AND.[MAG]
							; 4480	=0*	[T0]_[AR]*.5 LONG,	;SHIFT Q, PUT AR ON DP
							; 4481		SC_34., 		;LOAD SHIFT COUNT
							; 4482		SKIP DP0,		;LOOK AT AR SIGN
U 0551, 1302,3446,0316,4174,4007,0520,2010,0071,0042	; 4483		CALL [DBLDIV]		;GO DIVIDE
U 0553, 3043,3224,0016,4174,4007,0700,0000,0000,0000	; 4484		[T0]_Q*2 LONG
U 3043, 0056,3333,0017,4174,4003,5701,0000,0000,0000	; 4485		READ [T1], 3T, DISP/DP	;WHAT SIGN IS QUO
							; 4486	=1110	[T0]_[T0]+Q,		;POSITIVE QUO
U 0056, 3046,0001,1616,4174,4007,0700,0000,0000,0000	; 4487		J/DDIV5B		;CONTINUE BELOW
U 0057, 3044,2225,0016,4174,4007,0700,4000,0000,0000	; 4488		[T0]_-Q*2		;NEGATIVE QUO
							; 4489		AD/-D-.25, DBUS/RAM, 3T,
							; 4490		RAMADR/AC#, DEST/Q_AD,
U 3044, 3045,1772,0000,0274,4007,0701,0040,0000,0000	; 4491		MULTI PREC/1
U 3045, 1262,3223,0000,0174,4007,0621,0400,0000,0000	; 4492		AC_Q, SKIP AD.EQ.0
U 1262, 3047,3440,1616,1174,4007,0700,0400,0000,1441	; 4493	=0	AC[1]_[T0], J/DDIV5C
U 1263, 3051,4223,0000,1174,4007,0700,0400,0000,1441	; 4494		AC[1]_0, J/DDIV6
							; 4495	
U 3046, 3051,4113,1600,1174,4007,0700,0400,0000,1441	; 4496	DDIV5B: AC[1]_[T0].AND.[MAG], J/DDIV6	;STORE LOW WORD IN + CASE
							; 4497	
U 3047, 3050,3551,1616,4374,0007,0700,0000,0040,0000	; 4498	DDIV5C: [T0]_[T0].OR.#, #/400000, HOLD RIGHT
U 3050, 3051,3440,1616,1174,4007,0700,0400,0000,1441	; 4499		AC[1]_[T0]
							; 4500	
U 3051, 1264,3333,0003,4174,4007,0520,0000,0000,0000	; 4501	DDIV6:	READ [AR], SKIP DP0	;LOOK AT AR SIGN
							; 4502	=0
U 1264, 3055,3442,0400,4174,4007,0700,0000,0000,0000	; 4503	DDIV7:	Q_[ARX], J/DDIV8
U 1265, 3052,0112,0406,4174,4007,0700,0000,0000,0000	; 4504		Q_[ARX]+[BRX]
							; 4505		[AR]_[AR]+[BR],
U 3052, 3053,0111,0503,4174,4007,0700,0040,0000,0000	; 4506		MULTI PREC/1
U 3053, 3054,0002,0600,4174,4007,0700,0000,0000,0000	; 4507		Q_Q+[BRX]
							; 4508		[AR]_[AR]+[BR],
U 3054, 3055,0111,0503,4174,4007,0700,0040,0000,0000	; 4509		MULTI PREC/1
U 3055, 0355,3333,0017,4174,4003,5701,0000,0000,0000	; 4510	DDIV8:	READ [T1], 3T, DISP/DP
							; 4511	=1101
							; 4512	DDIV8A: [AR]_[AR]*2 LONG, ASHC, ;POSITIVE REMAINDER
U 0355, 3057,3444,0303,4174,4047,0700,0000,0000,0000	; 4513		J/DDIV9 		;CONTINUE BELOW
U 0357, 3056,2222,0000,4174,4007,0700,4000,0000,0000	; 4514		Q_-Q			;NEGATE REMAINDER IN AR!Q
							; 4515		[AR]_(-[AR]-.25)*2 LONG,
U 3056, 3057,2444,0303,4174,4047,0700,0040,0000,0000	; 4516		MULTI PREC/1, ASHC
							; 4517	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 122
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DDIV					

							; 4518	DDIV9:	AC[2]_[AR]+[AR], 3T,
U 3057, 1266,0113,0303,1174,4007,0521,0400,0000,1442	; 4519		SKIP DP0
							; 4520	=0	AC[3]_Q.AND.[MAG],
U 1266, 0100,4003,0000,1174,4156,4700,0400,0000,1443	; 4521		NEXT INST
U 1267, 3060,4002,0000,1174,4007,0700,0000,0000,1443	; 4522		Q_Q.AND.[MAG], AC[3]
							; 4523		AC[3]_[MAG].EQV.Q,
U 3060, 0100,7003,0000,1174,4156,4700,0400,0000,1443	; 4524		NEXT INST
							; 4525	
							; 4526	
							; 4527	;HERE IF WE WANT TO SET NO DIVIDE
							; 4528	=11011
U 0033, 3077,4443,0000,4174,4007,0700,0010,0000,0000	; 4529	NODDIV: CALL [QDNEG]		;FIXUP AC TO AC+3
U 0037, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4530		NO DIVIDE		;ABORT DIVIDE
							; 4531	
U 3061, 0001,3446,0303,4174,4044,1700,0000,0000,0000	; 4532	DDIVS:	[AR]_[AR]*.5 LONG, ASHC, RETURN [1]
							;;4533	.IFNOT/FULL
							;;4534	1627:
							;;4535	DDIV:	UUO
							; 4536	.ENDIF/FULL
							; 4537	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 123
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIVIDE SUBROUTINE				

							; 4538	.TOC	"ARITHMETIC -- DIVIDE SUBROUTINE"
							; 4539	
							; 4540	;HERE IS THE SUBROUTINE TO DO DIVIDE
							; 4541	;ENTER WITH:
							; 4542	;	AR!Q = D'END
							; 4543	;	BR = D'SOR
							; 4544	;RETURN 2 WITH:
							; 4545	;	AR = REMAINDER
							; 4546	;	Q = QUOTIENT
							; 4547	;CALLER MUST CHECK FOR ZERO DIVIDE PRIOR TO CALL
							; 4548	;
							; 4549	=1000
							; 4550	DIVSUB:	Q_Q.AND.#,		;CLEAR SIGN BIT IN
							; 4551		#/377777,		;MASK
							; 4552		HOLD RIGHT,		;JUST CLEAR BIT 0
U 0370, 3062,4662,0000,4374,0007,0700,0010,0037,7777	; 4553		CALL [DIVSGN]		;DO REAL DIVIDE
U 0374, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 4554	=1100	RETURN [2]		;ALL POSITIVE
U 0375, 0002,2222,0000,4174,4004,1700,4000,0000,0000	; 4555	=1101	Q_-Q, RETURN [2]	;-QUO +REM
U 0376, 0377,2222,0000,4174,4007,0700,4000,0000,0000	; 4556	=1110	Q_-Q			;ALL NEGATIVE
U 0377, 0002,2441,0303,4174,4004,1700,4000,0000,0000	; 4557	=1111	[AR]_-[AR], RETURN [2]	;NEGATIVE REMAINDER
							; 4558	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 124
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIVIDE SUBROUTINE				

							; 4559	;HERE IS THE INNER DIVIDE SUBROUTINE
							; 4560	;SAME SETUP AS DIVSUB
							; 4561	;RETURNS WITH AR AND Q POSITIVE AND
							; 4562	;	14 IF ALL POSITIVE
							; 4563	;	15 IF -QUO
							; 4564	;	16 IF ALL NEGATIVE
							; 4565	;	17 IF NEGATIVE REMAINDER
							; 4566	
							; 4567	BASIC DIV STEP	"DEST/Q_Q*2, DIV, A/BR, B/AR, STEP SC"
							; 4568	DIV STEP	"BASIC DIV STEP, AD/A+B, DIVIDE/1"
							; 4569	FIRST DIV STEP	"BASIC DIV STEP, AD/B-A-.25, ADD .25"
							; 4570	
U 3062, 1270,3333,0003,4174,4007,0520,0000,0000,0000	; 4571	DIVSGN:	READ [AR], SKIP DP0
U 1270, 3064,4221,0004,4174,4007,0700,0000,0000,0000	; 4572	=0	[ARX]_0, J/DVSUB2	;REMAINDER IS POSITIVE
U 1271, 1272,2222,0000,4174,4007,0621,4000,0000,0000	; 4573		Q_-Q, SKIP AD.EQ.0	;COMPLEMENT LOW WORD
U 1272, 3063,7441,0303,4174,4007,0700,0000,0000,0000	; 4574	=0	[AR]_.NOT.[AR], J/DVSUB1 ;COMPLEMENT HI WORD
U 1273, 3063,2441,0303,4174,4007,0700,4000,0000,0000	; 4575		[AR]_-[AR]		;TWO'S COMPLEMENT HI WORD SINCE
							; 4576					; LOW WORD WAS ZERO
U 3063, 3064,3771,0004,4374,4007,0700,0000,0010,0000	; 4577	DVSUB1: [ARX]_#, #/100000	;REMAINDER IS NEGATIVE
U 3064, 1274,3333,0005,4174,4007,0520,0000,0000,0000	; 4578	DVSUB2: READ [BR], SKIP DP0	;IS THE DIVISOR NEGATIVE
							; 4579	=0
							; 4580	DVSUB3: [AR]_[AR]*.5 LONG,	;START TO PUT IN 9-CHIPS
U 1274, 3066,3446,0303,4174,4007,0700,0000,0000,0000	; 4581		J/DIVSET		;JOIN MAIN STREAM
U 1275, 3065,2441,0505,4174,4007,0700,4000,0000,0000	; 4582		[BR]_-[BR]		;COMPLEMENT DIVISOR
							; 4583		[ARX]_[ARX].OR.#, 	;ADJUST SIGN OF QUOTIENT
U 3065, 1274,3551,0404,4374,4007,0700,0000,0004,0000	; 4584		#/40000, J/DVSUB3	;USE 9 CHIPS
U 3066, 3067,3447,0303,4174,4007,0700,0000,0000,0000	; 4585	DIVSET: [AR]_[AR]*.5
U 3067, 3070,3447,0505,4174,4007,0700,0000,0000,0000	; 4586		[BR]_[BR]*.5
U 3070, 3071,3447,0505,4174,4007,0700,0000,0000,0000	; 4587		[BR]_[BR]*.5
U 3071, 1276,1114,0503,4174,4067,0630,6000,0060,0000	; 4588		FIRST DIV STEP
							; 4589	;HERE IS THE MAIN DIVIDE LOOP
							; 4590	=0
U 1276, 1276,0114,0503,4174,4067,0630,2100,0060,0000	; 4591	DIVIDE: DIV STEP, J/DIVIDE
U 1277, 3072,3444,1717,4174,4067,0700,0100,0000,0000	; 4592		[T1]_[T1]*2 LONG, DIVIDE/1, DIV
U 3072, 1300,3447,0303,4174,4007,0520,0000,0000,0000	; 4593		[AR]_[AR]*.5, SKIP DP0
							; 4594	=0
U 1300, 3073,3444,0303,4174,4007,0700,0000,0000,0000	; 4595	FIX++:	[AR]_[AR]*2 LONG, J/FIX1++
U 1301, 1300,0111,0503,4174,4007,0700,0000,0000,0000	; 4596		[AR]_[AR]+[BR], J/FIX++
U 3073, 3074,3444,0303,4174,4007,0700,0000,0000,0000	; 4597	FIX1++: [AR]_[AR]*2 LONG
U 3074, 3075,4002,1200,4174,4007,0700,0000,0000,0000	; 4598		Q_[MASK].AND.Q
							; 4599		READ [ARX], 3T,		;RETURN TO 1 OF 4 PLACES
							; 4600		DISP/1,			;BASED ON SIGN OF RESULT
U 3075, 0014,3333,0004,4174,4000,1701,0000,0000,0000	; 4601		J/14			;RETURN
							; 4602	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 125
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DOUBLE DIVIDE SUBROUTINE			

							; 4603	.TOC	"ARITHMETIC -- DOUBLE DIVIDE SUBROUTINE"
							; 4604	.IF/FULL
							; 4605	;CALL WITH:
							; 4606	;	AR!ARX!Q = 3 WORD DV'END
							; 4607	;	BR!BRX	 = 2 WORD DV'SOR
							; 4608	;RETURN 2 WITH:
							; 4609	;	AR!ARX	 = 2 WORD REMAINDER
							; 4610	;			CORRECT IF POSITIVE (Q IS ODD)
							; 4611	;			WRONG (BY BR!BRX) IF NEGATIVE (Q IS EVEN)
							; 4612	;	Q	 = 1 WORD QUOTIENT
							; 4613	;CALLER MUST CHECK FOR ZERO DIVIDE PRIOR TO CALL
							; 4614	;
							; 4615	;NOTE: THIS SUBROUTINE ONLY WORKS FOR POSITIVE NUMBERS
							; 4616	;
							; 4617	=0
							; 4618	;HERE FOR NORMAL STARTUP
							; 4619	DBLDIV: [ARX]_([ARX]-[BRX])*2 LONG, ;SUBTRACT LOW WORD
U 1302, 3076,1114,0604,4174,4057,0700,4000,0000,0000	; 4620		LSHC, J/DIVHI		;GO ENTER LOOP
							; 4621	;SKIP ENTRY POINT IF FINAL STEP IN PREVIOUS ENTRY WAS IN ERROR
							; 4622		[ARX]_([ARX]+[BRX])*2 LONG, ;CORRECTION STEP
U 1303, 3076,0114,0604,4174,4057,0700,0000,0000,0000	; 4623		LSHC, J/DIVHI		;GO ENTER LOOP
							; 4624	
							; 4625	;HERE IS DOUBLE DIVIDE LOOP
							; 4626	DIVHI:	AD/A+B, 		;ADD (HARDWARE MAY OVERRIDE)
							; 4627		A/BR, B/AR,		;OPERANDS ARE AR AND BR
							; 4628		DEST/AD*2,		;SHIFT LEFT
							; 4629		SHSTYLE/NORM,		;SET SHIFT PATHS (SEE DPE1)
							; 4630		MULTI PREC/1,		;INJECT SAVED BITS
U 3076, 1304,0115,0503,4174,4007,0630,2040,0060,0000	; 4631		STEP SC 		;COUNT DOWN LOOP
							; 4632	=0	AD/A+B, 		;ADD (HARDWARE MAY OVERRIDE)
							; 4633		A/BRX, B/ARX,		;LOW WORDS
							; 4634		DEST/Q_Q*2,		;SHIFT WHOLE MESS LEFT
							; 4635		SHSTYLE/DIV,		;SET SHIFT PATHS (SEE DPE1)
							; 4636		DIVIDE/1,		;SAVE BITS
U 1304, 3076,0114,0604,4174,4067,0700,0100,0000,0000	; 4637		J/DIVHI 		;KEEP LOOPING
							; 4638	;HERE WHEN ALL DONE
							; 4639		DEST/Q_Q*2, DIV,	;SHIFT IN LAST Q BIT
							; 4640		DIVIDE/1,		;GENERATE BIT
U 1305, 0002,4444,0002,4174,4064,1700,0100,0000,0000	; 4641		B/HR, RETURN [2]	;ZERO HR AND RETURN
							; 4642	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 126
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- SUBROUTINES FOR ARITHMETIC		

							; 4643	.TOC	"ARITHMETIC -- SUBROUTINES FOR ARITHMETIC"
							; 4644	
							; 4645	;QUAD WORD NEGATE
							; 4646	;ARGUMENT IN AC!AC1!AC2!AC3
							; 4647	;LEAVES COPY OF AC!AC1 IN AR!Q
							; 4648	;RETURNS TO CALL!24
U 3077, 3100,1772,0000,1274,4007,0701,4000,0000,1443	; 4649	QDNEG:	Q_-AC[3]
							; 4650		AC[3]_Q.AND.[MAG],	;PUT BACK LOW WORD
U 3100, 1306,4003,0000,1174,4007,0621,0400,0000,1443	; 4651		SKIP AD.EQ.0		;SEE IF ANY CARRY
							; 4652	=0
U 1306, 3103,7772,0000,1274,4007,0701,0000,0000,1442	; 4653	COM2A:	Q_.NOT.AC[2], J/COM2	;CARRY--DO 1'S COMPLEMENT
U 1307, 3101,1772,0000,1274,4007,0701,4000,0000,1442	; 4654		Q_-AC[2]		;NEXT WORD
							; 4655		AC[2]_Q.AND.[MAG],	;PUT BACK WORD
U 3101, 1310,4003,0000,1174,4007,0621,0400,0000,1442	; 4656		SKIP AD.EQ.0
							; 4657	=0
U 1310, 3104,7772,0000,1274,4007,0701,0000,0000,1441	; 4658	COM1A:	Q_.NOT.AC[1], J/COM1
U 1311, 3102,1772,0000,1274,4007,0701,4000,0000,1441	; 4659		Q_-AC[1]
							; 4660		AC[1]_Q.AND.[MAG],
U 3102, 1312,4003,0000,1174,4007,0621,0400,0000,1441	; 4661		SKIP AD.EQ.0
							; 4662	=0
U 1312, 3105,7771,0003,0274,4007,0700,0000,0000,0000	; 4663	COM0A:	[AR]_.NOT.AC, J/COM0
U 1313, 3105,1771,0003,0274,4007,0701,4000,0000,0000	; 4664		[AR]_-AC, 3T, J/COM0
							; 4665	
U 3103, 1310,4003,0000,1174,4007,0700,0400,0000,1442	; 4666	COM2:	AC[2]_Q.AND.[MAG], J/COM1A
U 3104, 1312,4003,0000,1174,4007,0700,0400,0000,1441	; 4667	COM1:	AC[1]_Q.AND.[MAG], J/COM0A
U 3105, 0024,3440,0303,0174,4004,1700,0400,0000,0000	; 4668	COM0:	AC_[AR], RETURN [24]
							; 4669	.ENDIF/FULL
							; 4670	
							; 4671	;DOUBLE WORD NEGATE
							; 4672	;ARGUMENT IN AR AND ARX
							; 4673	;RETURNS TO CALL!2
							; 4674	
U 3106, 3107,4551,0404,4374,0007,0700,0000,0037,7777	; 4675	DBLNEG: CLEAR ARX0		;FLUSH DUPLICATE SIGN
							; 4676	DBLNGA: [ARX]_-[ARX],		;FLIP LOW WORD
U 3107, 1314,2441,0404,4174,4007,0621,4000,0000,0000	; 4677		SKIP AD.EQ.0		;SEE IF CARRY
							; 4678	=0	[AR]_.NOT.[AR], 	;NO CARRY-- 1 COMP
U 1314, 2240,7441,0303,4174,4467,0700,0000,0001,0001	; 4679		AD FLAGS, J/CLARX0	;CLEAR LOW SIGN
							; 4680		[AR]_-[AR],		;CARRY
U 1315, 2240,2441,0303,4174,4467,0701,4000,0001,0001	; 4681		AD FLAGS, 3T, J/CLARX0
							; 4682	
							; 4683	;SAME THING BUT DOES NOT SET PC FLAGS
U 3110, 1316,2441,0404,4174,4007,0621,4000,0000,0000	; 4684	DBLNG1: [ARX]_-[ARX], SKIP AD.EQ.0
U 1316, 2240,7441,0303,4174,4007,0700,0000,0000,0000	; 4685	=0	[AR]_.NOT.[AR], J/CLARX0
U 1317, 2240,2441,0303,4174,4007,0700,4000,0000,0000	; 4686		[AR]_-[AR], J/CLARX0
							; 4687	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 127
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- SUBROUTINES FOR ARITHMETIC		

							; 4688		.NOBIN
							; 4689	.TOC	"BYTE GROUP -- IBP, ILDB, LDB, IDPB, DPB"
							; 4690	
							; 4691	
							; 4692	;ALL FIVE INSTRUCTIONS OF THIS GROUP ARE CALLED WITH THE BYTE POINTER
							; 4693	;IN THE AR.  ALL INSTRUCTIONS SHARE COMMON SUBROUTINES.
							; 4694	
							; 4695	;IBP OR ADJBP
							; 4696	;IBP IF AC#0, ADJBP OTHERWISE
							; 4697	; HERE WITH THE BASE POINTER IN AR
							; 4698	
							; 4699	;HERE IS A MACRO TO DO IBP. WHAT HAPPENS IS:
							; 4700	;	THE AR IS PUT ON THE DP.
							; 4701	;	THE BR IS LOADED FROM THE DP WITH BITS 0-5 FROM SCAD
							; 4702	;	THE SCAD COMPUTES P-S
							; 4703	;	IBPS IS CALLED WITH A 4-WAY DISPATCH ON SCAD0 AND FIRST-PART-DONE
							; 4704	;THE MACRO IS WRITTEN WITH SEVERAL SUB-MACROS BECAUSE OF RESTRICTIONS
							; 4705	; IN THE MICRO ASSEMBLER
							; 4706	
							; 4707	IBP DP		"AD/D, DEST/A, A/AR, B/BR, DBUS/DBM, DBM/DP, BYTE/BYTE1"
							; 4708	IBP SCAD	"SCAD/A-B, SCADA/BYTE1, SCADB/SIZE"
							; 4709	IBP SPEC	"SCAD DISP, SKIP FPD"
							; 4710	CALL IBP	"IBP DP, IBP SCAD, IBP SPEC, CALL [IBPS], DT/3T"
							; 4711	
							; 4712	SET P TO 36-S	"AD/D,DEST/A,A/BR,B/AR,DBUS/DBM,DBM/DP,SCAD/A-B,SCADB/SIZE,BYTE/BYTE1,SCADA/PTR44"
							; 4713	
							; 4714	;THE FOLLOWING MACRO IS USED FOR COUNTING SHIFTS IN THE BYTE ROUTINES. IT
							; 4715	; USES THE FE AND COUNTS BY 8. NOTE: BYTE STEP IS A 2S WEIGHT SKIP NOT 1S.
							; 4716	BYTE STEP	"SCAD/A+B,SCADA/S#,S#/1770,SCADB/FE,LOAD FE, 3T,SCAD DISP"
							; 4717	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 128
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- IBP, ILDB, LDB, IDPB, DPB			

							; 4718		.BIN
							; 4719	
							; 4720		.DCODE
D 0133, 0015,1610,1100					; 4721	133:	R,	AC,	J/IBP		;OR ADJBP
D 0134, 0000,1620,1500					; 4722	134:	R,W TEST,	J/ILDB		;CAN'T USE RPW BECAUSE OF FPD
D 0135, 0000,1624,1100					; 4723		R,		J/LDB
D 0136, 0000,1630,1500					; 4724		R,W TEST,	J/IDPB
D 0137, 0000,1634,1100					; 4725		R,		J/DPB
							; 4726		.UCODE
							; 4727	1610:
U 1610, 0240,4443,0000,4174,4007,0360,0000,0000,0000	; 4728	IBP:	SKIP IF AC0		;SEE IF ADJBP
							; 4729	=000	WORK[ADJPTR]_[AR],	;SAVE POINTER
U 0240, 3146,3333,0003,7174,4007,0700,0400,0000,0223	; 4730		J/ADJBP 		;GO ADJUST BYTE POINTER
U 0241, 0350,3770,0305,4334,4016,7351,0010,0033,6000	; 4731	=001	CALL IBP		;BUMP BYTE POINTER
U 0245, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 4732	=101	DONE			;POINTER STORED
							; 4733	=
							; 4734	
							; 4735	1620:
U 1620, 0350,3770,0305,4334,4016,7351,0010,0033,6000	; 4736	ILDB:	CALL IBP		;BUMP BYTE POINTER
							; 4737	1624:
							; 4738	LDB:	READ [AR],		;LOOK AT POINTER
							; 4739		LOAD BYTE EA, FE_P, 3T, ;GET STUFF OUT OF POINTER
U 1624, 3116,3333,0003,4174,4217,0701,1010,0073,0500	; 4740		CALL [BYTEA]		;COMPUTE EFFECTIVE ADDRESS
U 1625, 0660,3443,0100,4174,4007,0700,0200,0014,0012	; 4741	1625:	VMA_[PC], FETCH 	;START FETCH OF NEXT INST
							; 4742	=0*	READ [AR],		;LOOK AT POINTER
							; 4743		FE_FE.AND.S#, S#/0770,	;MASK OUT JUNK IN FE
							; 4744		BYTE DISP,		;DISPATCH ON BYTE SIZE
U 0660, 0340,3333,0003,4174,4006,5701,1010,0051,0770	; 4745		CALL [LDB1]		;GET BYTE
							; 4746		AC_[AR], CLR FPD,	;STORE AC
U 0662, 0555,3440,0303,0174,4467,0700,0400,0005,0000	; 4747		J/NIDISP		;GO DO NEXT INST
							; 4748	
							; 4749	1630:
U 1630, 0350,3770,0305,4334,4016,7351,0010,0033,6000	; 4750	IDPB:	CALL IBP		;BUMP BYTE POINTER
							; 4751	1634:
U 1634, 3111,3775,0004,0274,4007,0701,0000,0000,0000	; 4752	DPB:	[ARX]_AC*2		;PUT 7 BIT BYTE IN 28-34
							; 4753		AD/A, A/ARX, SCAD/A,	;PUT THE BYTE INTO
							; 4754		SCADA/BYTE5, 3T,	; INTO THE FE REGISTER
U 3111, 3112,3443,0400,4174,4007,0701,1000,0077,0000	; 4755		LOAD FE 		; FE REGISTER
U 3112, 0264,3771,0004,0276,6007,0700,0000,0000,0000	; 4756		[ARX]_AC		;PUT BYTE IN ARX
							; 4757	=100	READ [AR],		;LOOK AT BYTE POINTER
							; 4758		LOAD BYTE EA,		;LOAD UP EFFECTIVE ADDRESS
U 0264, 3116,3333,0003,4174,4217,0700,0010,0000,0500	; 4759		CALL [BYTEA]		;COMPUTE EFFECTIVE ADDRESS
							; 4760		READ [AR],		;LOOK AT POINTER AGAIN
							; 4761		BYTE DISP,		;DISPATCH ON SIZE
U 0265, 0360,3333,0003,4174,4006,5701,0010,0000,0000	; 4762		CALL [DPB1]		;GO STORE BYTE
U 0267, 1400,4443,0000,4174,4467,0700,0000,0005,0000	; 4763	=111	CLR FPD, J/DONE 	;ALL DONE
							; 4764	=
							; 4765	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 129
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- INCREMENT BYTE POINTER SUBROUTINE		

							; 4766	.TOC	"BYTE GROUP -- INCREMENT BYTE POINTER SUBROUTINE"
							; 4767	
							; 4768	=00
U 0350, 3114,3441,0503,4174,4007,0700,0200,0003,0002	; 4769	IBPS:	[AR]_[BR], START WRITE, J/IBPX	;NO OVERFLOW, BR HAS ANSWER
U 0351, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 4770		RETURN [4]			;FIRST PART DONE SET
U 0352, 3113,3770,0503,4334,4017,0700,0000,0032,6000	; 4771		SET P TO 36-S, J/NXTWRD 	;WORD OVERFLOW
U 0353, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 4772		RETURN [4]			;FPD WAS SET IGNORE OVERFLOW
							; 4773						; AND RETURN
							; 4774	
U 3113, 3114,0111,0703,4170,4007,0700,0200,0003,0002	; 4775	NXTWRD: [AR]_[AR]+1, HOLD LEFT, START WRITE	;BUMP Y AND RETURN
U 3114, 0004,3333,0003,4175,5004,1701,0200,0000,0002	; 4776	IBPX:	MEM WRITE, MEM_[AR], RETURN [4]
							; 4777	
							; 4778	
							; 4779	.TOC	"BYTE GROUP -- BYTE EFFECTIVE ADDRESS EVALUATOR"
							; 4780	
							; 4781	;ENTER WITH POINTER IN AR
							; 4782	;RETURN1 WITH (EA) IN VMA AND WORD IN BR
							; 4783	BYTEAS: EA MODE DISP,		;HERE TO AVOID FPD
U 3115, 0070,4443,0000,2174,4006,6700,0000,0000,0000	; 4784		J/BYTEA0		;GO COMPUTE EA
							; 4785	BYTEA:	SET FPD,		;SET FIRST-PART-DONE
U 3116, 0070,4443,0000,2174,4466,6700,0000,0003,0000	; 4786		EA MODE DISP		;DISPATCH
							; 4787	=100*
							; 4788	BYTEA0: VMA_[AR]+XR,		;INDEXING
							; 4789		START READ,		;FETCH DATA WORD
							; 4790		PXCT BYTE DATA, 	;FOR PXCT
U 0070, 3120,0553,0300,2274,4007,0700,0200,0004,0712	; 4791		J/BYTFET		;GO WAIT
							; 4792		VMA_[AR],		;PLAIN
							; 4793		START READ,		;START CYCLE
							; 4794		PXCT BYTE DATA, 	;FOR PXCT
U 0072, 3120,3443,0300,4174,4007,0700,0200,0004,0712	; 4795		J/BYTFET		;GO WAIT
							; 4796		VMA_[AR]+XR,		;BOTH
							; 4797		START READ,		;START CYCLE
							; 4798		PXCT BYTE PTR EA,	;FOR PXCT
U 0074, 3117,0553,0300,2274,4007,0700,0200,0004,0512	; 4799		J/BYTIND		;GO DO INDIRECT
							; 4800		VMA_[AR],		;JUST @
							; 4801		START READ,		;START READ
U 0076, 3117,3443,0300,4174,4007,0700,0200,0004,0512	; 4802		PXCT BYTE PTR EA	;FOR PXCT
							; 4803	BYTIND: MEM READ,		;WAIT FOR @ WORD
							; 4804		[AR]_MEM,		;PUT IN AR
							; 4805		HOLD LEFT,		;JUST IN RH (SAVE P & S)
							; 4806		LOAD BYTE EA,		;LOOP BACK
U 3117, 3115,3771,0003,4361,5217,0700,0200,0000,0502	; 4807		J/BYTEAS		; ..
							; 4808	
							; 4809	BYTFET: MEM READ,		;WAIT FOR BYTE DATA
							; 4810		[BR]_MEM.AND.MASK,	; WORD. UNSIGNED
U 3120, 0001,4551,1205,4365,5004,1700,0200,0000,0002	; 4811		RETURN [1]		;RETURN TO CALLER
							; 4812	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 130
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- LOAD BYTE SUBROUTINE			

							; 4813	.TOC	"BYTE GROUP -- LOAD BYTE SUBROUTINE"
							; 4814	
							; 4815	;CALL WITH:
							; 4816	;	WORD IN BR
							; 4817	;	POINTER IN AR
							; 4818	;	P IN FE
							; 4819	;	BYTE DISPATCH
							; 4820	;RETURN2 WITH BYTE IN AR
							; 4821	LDB SCAD	"SCAD/A,BYTE/BYTE5"
							; 4822	7-BIT LDB	"AD/D,DBUS/DBM,DBM/DP,DEST/A,A/BR,B/BR, LDB SCAD"
							; 4823	
							; 4824	=000
							; 4825	LDB1:	GEN 17-FE, 3T,		;GO SEE IF ALL THE BITS
							; 4826		SCAD DISP,		; ARE IN THE LEFT HALF
U 0340, 0550,4443,0000,4174,4006,7701,0000,0031,0210	; 4827		J/LDBSWP		;GO TO LDBSWP & SKIP IF LH
							; 4828	
							; 4829	;HERE ARE THE 7-BIT BYTES
U 0341, 3121,3770,0505,4334,4057,0700,0000,0073,0000	; 4830	=001	7-BIT LDB, SCADA/BYTE1, J/LDB7
U 0342, 3121,3770,0505,4334,4057,0700,0000,0074,0000	; 4831	=010	7-BIT LDB, SCADA/BYTE2, J/LDB7
U 0344, 3121,3770,0505,4334,4057,0700,0000,0075,0000	; 4832	=100	7-BIT LDB, SCADA/BYTE3, J/LDB7
U 0345, 3121,3770,0505,4334,4057,0700,0000,0076,0000	; 4833	=101	7-BIT LDB, SCADA/BYTE4, J/LDB7
U 0347, 3121,3770,0505,4334,4057,0700,0000,0077,0000	; 4834	=111	7-BIT LDB, SCADA/BYTE5, J/LDB7
							; 4835	=
							; 4836	
							; 4837	;FOR 7-BIT BYTES WE HAVE BYTE IN BR 28-35 AND JUNK IN REST OF BR.
							; 4838	; WE JUST MASK THE SELECTED BYTE AND SHIFT ONE PLACE RIGHT.
							; 4839	LDB7:	AD/ZERO,RSRC/DA,	;LH_ZERO, RH_D.AND.A
							; 4840		DBUS/DBM,DBM/#,#/376,	;D INPUT IS 376
							; 4841		A/BR,			;A IS BR
							; 4842		B/AR,			;PUT RESULT IN AR
							; 4843		DEST/AD*.5, 3T, 	;SHIFT RESULT 1 PLACE
U 3121, 0002,4257,0503,4374,4004,1701,0000,0000,0376	; 4844		RETURN [2]		;RETURN TO CALLER
							; 4845	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 131
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- LOAD BYTE SUBROUTINE			

							; 4846	;HERE FOR NORMAL BYTES
							; 4847	=00
							; 4848	LDBSWP: FE_-FE, 		;MAKE P NEGATIVE
U 0550, 3123,4443,0000,4174,4007,0700,1000,0031,0000	; 4849		J/LDBSH 		;JOIN MAIN LDB LOOP
U 0552, 3122,3770,0505,4344,4007,0700,0000,0000,0000	; 4850	=10	[BR]_[BR] SWAP		;SHIFT 18 STEPS
							; 4851	=
							; 4852		[BR]_0, HOLD RIGHT,	;PUT ZERO IN LH
U 3122, 3123,4221,0005,4174,0007,0700,1000,0031,0220	; 4853		FE_-FE+S#, S#/220	;UPDATE FE
							; 4854	LDBSH:	[BR]_[BR]*.5,		;SHIFT RIGHT
							; 4855		FE_FE+10,		;UPDATE THE FE
U 3123, 3124,3447,0505,4174,4007,0700,1020,0041,0010	; 4856		MULTI SHIFT/1		;FAST SHIFT
U 3124, 3125,3333,0003,4174,4007,0700,1000,0031,7770	; 4857		READ [AR], FE_-S-10	;GET SIZE
U 3125, 3126,4222,0000,4174,4007,0700,0000,0000,0000	; 4858		Q_0			;CLEAR Q
							; 4859		GEN MSK [AR],		;PUT MASK IN Q (WIPEOUT AR)
							; 4860		FE_FE+10,		;COUNT UP ALL STEPS
U 3126, 3127,4224,0003,4174,4027,0700,1020,0041,0010	; 4861		MULTI SHIFT/1		;FAST SHIFT
U 3127, 3130,4224,0003,4174,4027,0700,0000,0000,0000	; 4862		GEN MSK [AR]		;ONE MORE BIT
U 3130, 0002,4001,0503,4174,4004,1700,0000,0000,0000	; 4863		[AR]_[BR].AND.Q, RETURN [2]
							; 4864	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 132
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- LOAD BYTE SUBROUTINE			

							; 4865		.NOBIN
							; 4866	.TOC	"BYTE GROUP -- DEPOSIT BYTE IN MEMORY"
							; 4867	
							; 4868	;FLOW FOR DPB (NOT 7-BIT BYTE)
							; 4869	;
							; 4870	;FIRST SET ARX TO -1 AND Q TO ZERO AND ROTATE LEFT
							; 4871	; S PLACES GIVING:
							; 4872	
							; 4873	;		ARX		  Q
							; 4874	;	+------------------!------------------+
							; 4875	;	!111111111111000000!000000000000111111!
							; 4876	;	+------------------!------------------+
							; 4877	;					!<--->!
							; 4878	;					S BITS
							; 4879	;
							; 4880	
							; 4881	;NOW THE AC IS LOAD INTO THE ARX AND BOTH THE ARX AND Q
							; 4882	; ARE SHIFTED LEFT P BITS GIVING:
							; 4883	
							; 4884	;	+------------------!------------------+
							; 4885	;	!??????BBBBBB000000!000000111111000000!
							; 4886	;	+------------------!------------------+
							; 4887	;	 <----><---->		  <----><---->
							; 4888	;	  JUNK	BYTE		   MASK P BITS
							; 4889	;
							; 4890	
							; 4891	;AT THIS POINT WE ARE ALMOST DONE. WE NEED TO AND
							; 4892	; THE BR WITH .NOT. Q TO ZERO THE BITS FOR THE BYTE
							; 4893	; AND AND ARX WITH Q TO MASK OUT THE JUNK THIS GIVES:
							; 4894	;
							; 4895	;		ARX
							; 4896	;	+------------------+
							; 4897	;	!000000BBBBBB000000!
							; 4898	;	+------------------!
							; 4899	;
							; 4900	;		AR
							; 4901	;	+------------------+
							; 4902	;	!DDDDDD000000DDDDDD!
							; 4903	;	+------------------+
							; 4904	;
							; 4905	;WE NOW OR THE AR WITH ARX TO GENERATE THE ANSWER.
							; 4906	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 133
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- DEPOSIT BYTE IN MEMORY			

							; 4907		.BIN
							; 4908	
							; 4909	;DEPOSIT BYTE SUBROUTINE
							; 4910	;CALL WITH:
							; 4911	;	BYTE POINTER IN AR
							; 4912	;	BYTE TO STORE IN ARX
							; 4913	;	WORD TO MERGE WITH IN BR
							; 4914	;	(E) OF BYTE POINTER IN VMA
							; 4915	;	7-BIT BYTE IN FE
							; 4916	;	BYTE DISPATCH
							; 4917	;RETURN2 WITH BYTE IN MEMORY
							; 4918	;
							; 4919	DPB SCAD	"SCAD/A+B,SCADA/S#,SCADB/FE,S#/0"
							; 4920	7-BIT DPB	"AD/D,DEST/A,A/BR,DBUS/DBM,DBM/DP,B/AR, DPB SCAD"
							; 4921	
							; 4922	=000
U 0360, 3133,3333,0003,4174,4007,0700,1000,0031,7770	; 4923	DPB1:	READ [AR], FE_-S-10, J/DPBSLO	;NOT SPECIAL
U 0361, 3131,3770,0503,4334,4017,0700,0000,0041,0000	; 4924	=001	7-BIT DPB, BYTE/BYTE1, J/DPB7
U 0362, 3131,3770,0503,4334,4027,0700,0000,0041,0000	; 4925	=010	7-BIT DPB, BYTE/BYTE2, J/DPB7
U 0364, 3131,3770,0503,4334,4037,0700,0000,0041,0000	; 4926	=100	7-BIT DPB, BYTE/BYTE3, J/DPB7
U 0365, 3131,3770,0503,4334,4047,0700,0000,0041,0000	; 4927	=101	7-BIT DPB, BYTE/BYTE4, J/DPB7
U 0367, 3131,3770,0503,4334,4057,0700,0000,0041,0000	; 4928	=111	7-BIT DPB, BYTE/BYTE5, J/DPB7
							; 4929	=
U 3131, 3132,3447,1200,4174,4007,0700,0200,0003,0002	; 4930	DPB7:	[MAG]_[MASK]*.5, START WRITE
U 3132, 0002,3333,0003,4175,5004,1701,0200,0000,0002	; 4931		MEM WRITE, MEM_[AR], RETURN [2]
							; 4932	
							; 4933	
U 3133, 3134,4222,0000,4174,4007,0700,0000,0000,0000	; 4934	DPBSLO: Q_0			;CLEAR Q
							; 4935		GEN MSK [MAG],		;GENERATE MASK IN Q (ZAP MAG)
							; 4936		FE_FE+10,		;COUNT STEPS
U 3134, 3135,4224,0000,4174,4027,0700,1020,0041,0010	; 4937		MULTI SHIFT/1		;FAST SHIFT
U 3135, 3136,4224,0000,4174,4027,0700,0000,0000,0000	; 4938		GEN MSK [MAG]		;ONE MORE BITS
U 3136, 3137,3333,0003,4174,4007,0701,1000,0073,0000	; 4939		READ [AR], 3T, FE_P	;AMOUNT TO SHIFT
U 3137, 3140,4443,0000,4174,4007,0700,1000,0051,0770	; 4940		FE_FE.AND.S#, S#/0770	;MASK OUT JUNK
							; 4941		Q_Q.AND.[MASK], 	;CLEAR BITS 36 AND 37
U 3140, 3141,4002,1200,4174,4007,0700,1000,0031,0000	; 4942		FE_-FE			;MINUS NUMBER OF STEPS
							; 4943		[ARX]_[ARX]*2 LONG,	;SHIFT BYTE AND MASK
							; 4944		FE_FE+10,		;COUNT OUT STEPS
U 3141, 3142,3444,0404,4174,4007,0700,1020,0041,0010	; 4945		MULTI SHIFT/1		;FAST SHIFT
							; 4946	;AT THIS POINT WE HAVE DONE ALL THE SHIFTING WE NEED. THE BYTE IS
							; 4947	; IN ARX AND THE MASK IS IN Q.
U 3142, 3143,7221,0003,4174,4007,0700,0000,0000,0000	; 4948		[AR]_.NOT.Q
U 3143, 3144,4111,0503,4174,4007,0700,0000,0000,0000	; 4949		[AR]_[AR].AND.[BR]
U 3144, 3145,4001,0404,4174,4007,0700,0000,0000,0000	; 4950		[ARX]_[ARX].AND.Q
							; 4951		[AR]_[AR].OR.[ARX],
U 3145, 3131,3111,0403,4174,4007,0700,0000,0000,0000	; 4952		J/DPB7
							; 4953	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 134
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 4954	.TOC	"BYTE GROUP -- ADJUST BYTE POINTER"
							; 4955	.IF/FULL
							; 4956	;FIRST THE NUMBER OF BYTES PER WORD IS COMPUTED FROM THE
							; 4957	; FOLLOWING FORMULA:
							; 4958	;
							; 4959	;		       (  P  )	    ( 36-P )
							; 4960	;  BYTES PER WORD = INT( --- ) + INT( ---- )
							; 4961	;		       (  S  )	    (  S   )
							; 4962	;
							; 4963	;THIS GIVES 2 BYTES PER WORD FOR THE FOLLOWING 12 BIT BYTE:
							; 4964	;	!=====================================!
							; 4965	;	!  6  !////////////!	12     !  6   !
							; 4966	;	!=====================================!
							; 4967	;		P=18 AND S=12
							; 4968	;
							; 4969	;WE GET 3 BYTES/WORD IF THE BYTES FALL IN THE NATURAL PLACE:
							; 4970	;	!=====================================!
							; 4971	;	!    12     !\\\\\\\\\\\\!     12     !
							; 4972	;	!=====================================!
							; 4973	;	       P=12 AND S=12
							; 4974	
							; 4975	;WE COME HERE WITH THE BYTE POINTER IN AR, AND ADJPTR
							; 4976	ADJBP:	[ARX]_[AR] SWAP,	;MOVE SIZE OVER
U 3146, 1320,3770,0304,4344,4007,0700,2000,0071,0011	; 4977		SC_9.			;READY TO SHIFT
							; 4978	=0
							; 4979	ADJBP0: [ARX]_[ARX]*.5, 	;SHIFT P OVER
							; 4980		STEP SC,		; ..
U 1320, 1320,3447,0404,4174,4007,0630,2000,0060,0000	; 4981		J/ADJBP0		; ..
							; 4982		[ARX]_([ARX].AND.#)*.5, ;SHIFT AND MASK
							; 4983		3T,			;WAIT
U 1321, 3147,4557,0404,4374,4007,0701,0000,0000,0176	; 4984		#/176			;6 BIT MASK
							; 4985		[ARX]_#,		;CLEAR LH
							; 4986		#/0,			; ..
U 3147, 3150,3771,0004,4374,0007,0700,0000,0000,0000	; 4987		HOLD RIGHT		; ..
U 3150, 3151,3333,0004,7174,4007,0700,0400,0000,0221	; 4988		WORK[ADJP]_[ARX]	;SAVE P
							; 4989		[BR]_([AR].AND.#)*.5,	;START ON S
							; 4990		3T,			;EXTRACT S
U 3151, 3152,4557,0305,4374,4007,0701,0000,0000,7700	; 4991		#/007700		; ..
							; 4992		[BR]_[BR] SWAP, 	;SHIFT 18 PLACES
U 3152, 3153,3770,0505,4344,4007,0700,2000,0071,0003	; 4993		SC_3			; ..
							; 4994		[BR]_0, 		;CLEAR LH
U 3153, 1322,4221,0005,4174,0007,0700,0000,0000,0000	; 4995		HOLD RIGHT		; ..
							; 4996	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 135
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 4997	=0
							; 4998	ADJBP1: [BR]_[BR]*.5,		;SHIFT S OVER
							; 4999		STEP SC,		; ..
U 1322, 1322,3447,0505,4174,4007,0630,2000,0060,0000	; 5000		J/ADJBP1		; ..
							; 5001		WORK[ADJS]_[BR],	;SALT S AWAY
U 1323, 1324,3333,0005,7174,4007,0621,0400,0000,0222	; 5002		SKIP AD.EQ.0		;SEE IF ZERO
							; 5003	=0	Q_[ARX],		;DIVIDE P BY S
							; 5004		SC_34.,			;STEP COUNT
U 1324, 0664,3442,0400,4174,4007,0700,2000,0071,0042	; 5005		J/ADJBP2		;SKIP NEXT WORD
U 1325, 1404,3771,0003,7274,4007,0701,0000,0000,0223	; 5006		[AR]_WORK[ADJPTR], J/MOVE	;S=0 -- SAME AS MOVE
							; 5007	=0*
							; 5008	ADJBP2: [AR]_#, 		;FILL AR WITH SIGN BITS
							; 5009		#/0,			;POSITIVE
U 0664, 0370,3771,0003,4374,4007,0700,0010,0000,0000	; 5010		CALL [DIVSUB]		;GO DIVIDE
U 0666, 3154,3223,0000,7174,4007,0700,0400,0000,0224	; 5011		WORK[ADJQ1]_Q		;SAVE QUOTIENT
							; 5012		Q_#,			;COMPUTE (36-P)/S
							; 5013		#/36.,			; ..
U 3154, 3155,3772,0000,4370,4007,0700,0000,0000,0044	; 5014		HOLD LEFT		;SMALL ANSWER
U 3155, 3156,1662,0000,7274,4007,0701,4000,0000,0221	; 5015		Q_Q-WORK[ADJP]		;SUBTRACT P
U 3156, 3157,3771,0005,7274,4007,0701,0000,0000,0222	; 5016		[BR]_WORK[ADJS]		;DIVIDE BY S
U 3157, 0670,4443,0000,4174,4007,0700,2000,0071,0042	; 5017		SC_34.			;STEP COUNT
							; 5018	=0*	[AR]_#,			;MORE SIGN BITS
							; 5019		#/0,			; ..
U 0670, 0370,3771,0003,4374,4007,0700,0010,0000,0000	; 5020		CALL [DIVSUB]		;GO DIVIDE
U 0672, 3160,3333,0003,7174,4007,0700,0400,0000,0225	; 5021		WORK[ADJR2]_[AR]	;SAVE REMAINDER
							; 5022		[AR]_#, 		;ASSUME NEGATIVE ADJ
U 3160, 3161,3771,0003,4374,4007,0700,0000,0077,7777	; 5023		#/777777		;EXTEND SIGN
							; 5024		AD/D+Q, 		;BR_(P/S)+((36-P)/S)
							; 5025		DEST/AD,		; ..
							; 5026		B/BR,			; ..
							; 5027		RAMADR/#,		; ..
							; 5028		DBUS/RAM,		; ..
							; 5029		WORK/ADJQ1,		; ..
							; 5030		4T,			; ..
U 3161, 1326,0661,0005,7274,4007,0622,0000,0000,0224	; 5031		SKIP AD.EQ.0		;SEE IF ZERO
							; 5032	=0	Q_Q+AC, 		;GET ADJUSTMENT
							; 5033		SC_34.,			;STEP COUNT
							; 5034		SKIP DP0,		;GO DO DIVIDE
							; 5035		4T,			;WAIT FOR DP
U 1326, 0570,0662,0000,0274,4007,0522,2000,0071,0042	; 5036		J/ADJBP3		;BELOW
U 1327, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 5037		NO DIVIDE		;0 BYTES/WORD
							; 5038	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 136
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 5039	;WE NOW DIVIDE THE ADJUSTMENT BY THE BYTES PER WORD AND FORCE THE
							; 5040	; REMAINDER (R) TO BE A POSITIVE NUMBER (MUST NOT BE ZERO). THE
							; 5041	; QUOTIENT IS ADDED TO THE Y FIELD IN THE BYTE POINTER AND THE NEW
							; 5042	; P FIELD IS COMPUTED BY:
							; 5043	;
							; 5044	;	     (		     ( 36-P ))
							; 5045	; NEW P = 36-((R * S) +  RMDR( ---- ))
							; 5046	;	     (		     (	 S  ))
							; 5047	;
							; 5048	;WE NOW HAVE BYTES/WORD IN BR AND ADJUSTMENT IN Q. DIVIDE TO GET
							; 5049	; WORDS TO ADJUST BY.
							; 5050	=00
							; 5051	ADJBP3: [AR]_#, 		;POSITIVE ADJUSTMENT
U 0570, 0571,3771,0003,4374,4007,0700,0000,0000,0000	; 5052		#/0.
							; 5053		WORK[ADJBPW]_[BR],	;SAVE BYTES/WORD & COMPUTE
U 0571, 0370,3333,0005,7174,4007,0700,0410,0000,0226	; 5054		CALL [DIVSUB]		; ADJ/(BYTES/WORD)
							; 5055	;WE NOW WANT TO ADJUST THE REMAINDER SO THAT IT IS POSITIVE
							; 5056	=11	Q_#,			;ONLY RIGHT HALF
							; 5057		#/0,			; ..
U 0573, 3162,3772,0000,4374,0007,0700,0000,0000,0000	; 5058		HOLD RIGHT		; ..
							; 5059	=
							; 5060		READ [AR],		;ALREADY +
U 3162, 1330,3333,0003,4174,4007,0421,0000,0000,0000	; 5061		SKIP AD.LE.0		; ..
							; 5062	=0
							; 5063	ADJBP4: AD/D+Q, 		;ADD Q TO POINTER AND STORE
							; 5064		DEST/AD,		; ..
							; 5065		B/BR,			;RESULT TO BR
							; 5066		RAMADR/#,		;PTR IS IN RAM
							; 5067		DBUS/RAM,		; ..
							; 5068		WORK/ADJPTR,		; ..
							; 5069		INH CRY18,		;JUST RH
							; 5070		3T,			;WAIT FOR RAM
U 1330, 3164,0661,0005,7274,4407,0701,0000,0000,0223	; 5071		J/ADJBP5		;CONTINUE BELOW
							; 5072		Q_Q-1,			;NO--MAKE Q SMALLER
U 1331, 3163,1002,0700,4170,4007,0700,4000,0000,0000	; 5073		HOLD LEFT		; ..
							; 5074		[AR]_[AR]+WORK[ADJBPW], ;MAKE REM BIGGER
U 3163, 1330,0551,0303,7274,4007,0701,0000,0000,0226	; 5075		J/ADJBP4		;NOW HAVE + REMAINDER
							; 5076	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 137
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 5077	ADJBP5: [BRX]_[AR],		;COMPUTE R*S
U 3164, 3165,3441,0306,4174,4007,0700,2000,0071,0043	; 5078		SC_35.			;STEP COUNT
U 3165, 0062,3772,0000,7274,4007,0701,0000,0000,0222	; 5079		Q_WORK[ADJS]		;GET S
							; 5080	=01*	[BRX]_[BRX]*.5 LONG,	;SHIFT OVER
U 0062, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 5081		CALL [MULSUB]		; ..
							; 5082		AD/D+Q, 		;AR_(R*S)+RMDR(36-P)/S
							; 5083		DEST/AD,		; ..
							; 5084		B/AR,			; ..
							; 5085		RAMADR/#,		; ..
							; 5086		3T,			; ..
							; 5087		DBUS/RAM,		; ..
U 0066, 3166,0661,0003,7274,4007,0701,0000,0000,0225	; 5088		WORK/ADJR2		; ..
							; 5089		[AR]_(#-[AR])*2,	;COMPUTE 36-AR
							; 5090		3T,			;AND START LEFT
U 3166, 3167,2555,0303,4374,4007,0701,4000,0000,0044	; 5091		#/36.			; ..
							; 5092		[AR]_[AR] SWAP, 	;PUT THE POSITION BACK
U 3167, 3170,3770,0303,4344,4007,0700,2000,0071,0011	; 5093		SC_9.			; ..
							; 5094		[AR]_#, 		;CLEAR JUNK FROM RH
							; 5095		#/0,			; ..
U 3170, 1332,3771,0003,4370,4007,0700,0000,0000,0000	; 5096		HOLD LEFT		; ..
							; 5097	=0
							; 5098	ADJBP6: [AR]_[AR]*2,		;LOOP OVER ALL BITS
							; 5099		STEP SC,		; ..
U 1332, 1332,3445,0303,4174,4007,0630,2000,0060,0000	; 5100		J/ADJBP6		; ..
							; 5101		[BR]_[BR].AND.#,	; ..
							; 5102		#/007777,		; ..
U 1333, 3171,4551,0505,4374,0007,0700,0000,0000,7777	; 5103		HOLD RIGHT		; ..
							; 5104		AC_[AR].OR.[BR],	;ALL DONE
U 3171, 1400,3113,0305,0174,4007,0700,0400,0000,0000	; 5105		J/DONE
							;;5106	.IFNOT/FULL
							;;5107	
							;;5108	ADJBP:	UUO			;NO ADJBP IN SMALL
							;;5109						; MICROCODE
							; 5110	.ENDIF/FULL
							; 5111	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 138
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 5112		.NOBIN
							; 5113	.TOC	"BLT"
							; 5114	
							; 5115	;THIS CODE PROVIDES A GUARANTEED RESULT IN AC ON COMPLETION OF
							; 5116	; THE TRANSFER (EXCEPT IN THE CASE AC IS PART OF BUT NOT THE LAST WORD
							; 5117	; OF THE DESTINATION BLOCK).  WHEN AC IS NOT PART OF THE DESTINATION
							; 5118	; BLOCK, IT IS LEFT CONTAINING THE ADDRESSES OF THE FIRST WORD FOLLOWING
							; 5119	; THE SOURCE BLOCK (IN THE LH), AND THE FIRST WORD FOLLOWING THE DEST-
							; 5120	; INATION BLOCK (IN THE RH).  IF AC IS THE LAST WORD OF THE DESTINATION
							; 5121	; BLOCK, IT WILL BE A COPY OF THE LAST WORD OF THE SOURCE BLOCK.
							; 5122	
							; 5123	;IN ADDITION, A SPECIAL-CASE CHECK IS MADE FOR THE CASE IN WHICH EACH
							; 5124	; WORD STORED IS USED AS THE SOURCE OF THE NEXT TRANSFER.  IN THIS CASE,
							; 5125	; ONLY ONE READ NEED BE PERFORMED, AND THAT DATA MAY BE STORED FOR EACH
							; 5126	; TRANSFER.  THUS THE COMMON USE OF BLT TO CLEAR CORE IS SPEEDED UP.
							; 5127	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 139
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BLT							

							; 5128		.BIN
							; 5129	
							; 5130	;HERE TO SETUP FOR A BLT/UBABLT
							; 5131	
U 3172, 1334,3770,0604,4344,4007,0700,0000,0000,0000	; 5132	SETBLT:	[ARX]_[BRX] SWAP	;COPY TO ARX (SRC IN RH)
							; 5133	=0	VMA_[ARX],		;ADDRESS OF FIRST WORD
							; 5134		START READ,
							; 5135		PXCT BLT SRC,
U 1334, 3723,3443,0400,4174,4007,0700,0210,0004,0712	; 5136		CALL [CLARXL]		;CLEAR THE LEFT HALF OF
							; 5137		[BRX]_0,		; BOTH SRC AND DEST
U 1335, 3173,4221,0006,4174,0007,0700,0000,0000,0000	; 5138		HOLD RIGHT
U 3173, 3174,2112,0306,4174,4007,0700,4000,0000,0000	; 5139		Q_[AR]-[BRX]		;NUMBER OF WORDS TO MOVE
U 3174, 3175,0001,0705,4174,4007,0700,0000,0000,0000	; 5140		[BR]_Q+1		;LENGTH +1
							; 5141		[BR]_[BR] SWAP, 	;COPY TO BOTH HALFS
U 3175, 3176,3770,0505,4344,0007,0700,0000,0000,0000	; 5142		HOLD RIGHT
							; 5143		[BR]_AC+[BR],		;FINAL AC
U 3176, 3177,0551,0505,0274,4407,0701,0000,0000,0000	; 5144		INH CRY18		;KEEP AC CORRECT IF DEST IS 777777
U 3177, 0002,3771,0013,4370,4004,1700,0000,0000,0001	; 5145		STATE_[BLT],RETURN [2]	;SET PAGE FAIL FLAGS
							; 5146	
							; 5147		.DCODE
D 0251, 0000,1640,2100					; 5148	251:	I,		J/BLT
							; 5149		.UCODE
							; 5150	
							; 5151	1640:
U 1640, 3172,3771,0006,0276,6007,0700,0010,0000,0000	; 5152	BLT:	[BRX]_AC,CALL [SETBLT]	;FETCH THE AC (DEST IN RH)
							; 5153	1642:	AC_[BR],		;STORE BACK IN AC
U 1642, 3722,3440,0505,0174,4007,0700,0410,0000,0000	; 5154		CALL [LOADQ]		;LOAD FIRST WORD INTO Q
							; 5155	1643:	[BR]_[ARX]+1000001,	;SRC+1
							; 5156		3T,
U 1643, 3200,0551,0405,4370,4007,0701,0000,0000,0001	; 5157		HOLD LEFT
							; 5158		[BR]-[BRX], 3T,		;IS THIS THE CORE CLEAR CASE
U 3200, 1336,2113,0506,4174,4007,0331,4000,0000,0000	; 5159		SKIP ADR.EQ.0
							; 5160	=0
							; 5161	BLTLP1: VMA_[BRX],		;NO, GET DEST ADR
							; 5162		START WRITE,		;START TO STORE NEXT WORD
							; 5163		PXCT BLT DEST,		;WHERE TO STORE
U 1336, 3203,3443,0600,4174,4007,0700,0200,0003,0312	; 5164		J/BLTGO
							; 5165	
							; 5166		;SKIP TO NEXT PAGE IF CLEARING CORE
							; 5167	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 140
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BLT							

							; 5168	;CLEAR CORE CASE
							; 5169		VMA_[BRX],
							; 5170		START WRITE,
U 1337, 3201,3443,0600,4174,4007,0700,0200,0003,0312	; 5171		PXCT BLT DEST
							; 5172	BLTCLR: MEM WRITE,		;STORE WORD
							; 5173		MEM_Q,
U 3201, 1340,3223,0000,4174,4007,0671,0200,0000,0002	; 5174		SKIP/-1 MS		;1 MS TIMER UP
U 1340, 3204,4443,0000,4174,4007,0700,0000,0000,0000	; 5175	=0	J/BLTGOT		;GO TAKE INTERRUPT
							; 5176		[BRX]-[AR],		;BELOW E?
							; 5177		3T,
U 1341, 1342,2113,0603,4174,4007,0521,4000,0000,0000	; 5178		SKIP DP0
							; 5179	=0	END BLT,		;NO--STOP BLT
U 1342, 1400,4221,0013,4170,4007,0700,0000,0000,0000	; 5180		J/DONE
							; 5181		[ARX]_[ARX]+1,		;FOR PAGE FAIL LOGIC
U 1343, 1344,0111,0704,4174,4007,0370,0000,0000,0000	; 5182		SKIP IRPT
							; 5183	=0	VMA_[BRX]+1,
							; 5184		LOAD VMA,
							; 5185		PXCT BLT DEST,
							; 5186		START WRITE,		;YES--KEEP STORING
U 1344, 3201,0111,0706,4170,4007,0700,0200,0003,0312	; 5187		J/BLTCLR
							; 5188		VMA_[BRX]+1,		;INTERRUPT
							; 5189		LOAD VMA,
							; 5190		PXCT BLT DEST,
							; 5191		START WRITE,
U 1345, 3203,0111,0706,4170,4007,0700,0200,0003,0312	; 5192		J/BLTGO
							; 5193	
							; 5194	;HERE FOR NORMAL BLT
							; 5195	BLTLP:	MEM READ,		;FETCH
							; 5196		Q_MEM,
U 3202, 1336,3772,0000,4365,5007,0700,0200,0000,0002	; 5197		J/BLTLP1
							; 5198	BLTGO:	MEM WRITE,		;STORE
U 3203, 3204,3223,0000,4174,4007,0701,0200,0000,0002	; 5199		MEM_Q
							; 5200	BLTGOT:	[BRX]-[AR],		;BELOW E?
							; 5201		3T,
U 3204, 1346,2113,0603,4174,4007,0521,4000,0000,0000	; 5202		SKIP DP0
							; 5203	=0	END BLT,		;NO--STOP BLT
U 1346, 1400,4221,0013,4170,4007,0700,0000,0000,0000	; 5204		J/DONE
U 1347, 3205,0111,0706,4174,4007,0700,0000,0000,0000	; 5205		[BRX]_[BRX]+1		;UPDATE DEST ADDRESS
							; 5206		VMA_[ARX]+1,
							; 5207		LOAD VMA,
							; 5208		PXCT BLT SRC,
							; 5209		START READ,		;YES--MOVE 1 MORE WORD
U 3205, 3202,0111,0704,4170,4007,0700,0200,0004,0712	; 5210		J/BLTLP
							; 5211	
							; 5212	;HERE TO CLEAN UP AFTER BLT PAGE FAILS
							; 5213	BLT-CLEANUP:
U 3206, 3207,3770,0303,4344,4007,0700,0000,0000,0000	; 5214		[AR]_[AR] SWAP		;PUT SRC IN LEFT HALF
							; 5215		[AR]_WORK[SV.BRX],
U 3207, 3210,3771,0003,7270,4007,0701,0000,0000,0214	; 5216		HOLD LEFT
							; 5217		AC_[AR],		;STORE THE AC AND RETURN
U 3210, 1100,3440,0303,0174,4007,0700,0400,0000,0000	; 5218		J/CLEANED
							; 5219	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 141
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BLT							

							; 5220	.IF/UBABLT
							; 5221	.TOC	"UBABLT - BLT BYTES TO/FROM UNIBUS FORMAT"
							; 5222	
							; 5223	;THESE INSTRUCTION MOVE WORDS FROM BYTE TO UNIBUS AND UNIBUS TO BYTE
							; 5224	;FORMAT.  FORMATS ARE:
							; 5225	;
							; 5226	;BYTE FORMAT:
							; 5227	;
							; 5228	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5229	; ;; BYTE 0 ;; BYTE 1 ;; BYTE 2 ;; BYTE 3 ;; 4 BITS ;;
							; 5230	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5231	;
							; 5232	;UNIBUS FORMAT:
							; 5233	;
							; 5234	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5235	; ;; 2 BITS ;; BYTE 1 ;; BYTE 0 ;; 2 BITS ;; BYTE 3 ;; BYTE 2 ;;
							; 5236	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5237	;
							; 5238	
							; 5239	=0*
							; 5240	BLTX:	[BRX]_AC,		;FETCH THE AC (DEST IN RH)
U 0674, 3172,3771,0006,0276,6007,0700,0010,0000,0000	; 5241		CALL [SETBLT]		;DO THE REST OF THE SETUP
U 0676, 3211,3440,0505,0174,4007,0700,0400,0000,0000	; 5242		AC_[BR]			;STORE THE FINAL AC IN AC
							; 5243	
							; 5244	BLTXLP:	MEM READ,		;READ THE SOURCE WORD
							; 5245		Q_MEM,			;FROM MEMORY
U 3211, 0006,3772,0000,4365,5003,7700,0200,0000,0002	; 5246		B DISP			;SKIP IF BLTUB (OPCODE 717)
							; 5247	=110	Q_Q*.5,			;BLTBU (OPCODE 716) - SHIFT RIGHT 1 BIT
U 0006, 3217,3446,1200,4174,4007,0700,0000,0000,0000	; 5248		J/BLTBU1		;CONTINUE INSTRUCTION
							; 5249	
							; 5250		AD/D.AND.Q,DBUS/DBM,	;BLTUB - MASK LOW BYTES, SHIFT LEFT
U 0007, 0610,4665,0017,4374,4007,0700,0000,0000,0377	; 5251		DBM/#,#/377,DEST/AD*2,B/T1	;AND STORE RESULT
							; 5252	=00	FE_S#,S#/1767,		;-9 MORE BITS TO PUT LOW BYTE OF LH
U 0610, 3224,4443,0000,4174,4007,0700,1010,0071,1767	; 5253		CALL [T1LSH]		; IN TOP OF LH SHIFT LEFT
							; 5254	=01	FE_S#,S#/1772,		;-6 BITS TO PUT HI BYTE TO RIGHT
U 0611, 3225,4443,0000,4174,4007,0700,1010,0071,1772	; 5255		CALL [Q_RSH]		; OF LOW BYTE.  
U 0613, 3212,4662,0000,4374,4007,0700,0000,0000,1774	; 5256	=11	Q_Q.AND.#,#/001774	;KEEP ONLY HI BYTES
							; 5257	=
							; 5258		AD/A.OR.Q,A/T1,DEST/AD,	;MERGE PAIRS OF BYTES. NOW SWAPPED,
U 3212, 3213,3001,1717,4174,4007,0700,0000,0000,0000	; 5259		B/T1			;BUT STILL IN HALF-WORDS
							; 5260		AD/57,RSRC/0A,A/T1,	;CLEAR LH OF Q WHILE LOADING
U 3213, 3214,5742,1700,4174,4007,0700,0000,0000,0000	; 5261		DEST/Q_AD		;RH WITH LOW WORD
U 3214, 3215,3444,0012,4174,4007,0700,0000,0000,0000	; 5262		Q_Q*2			;SHIFT LOW WORD ACROSS 1/2 WORD
U 3215, 3216,3444,0012,4174,4007,0700,0000,0000,0000	; 5263		Q_Q*2			;AND INTO FINAL POSITION
							; 5264		[T1]_[T1].AND.# CLR RH,	;CLEAR ALL BUT HIGH 16-BIT WORD
U 3216, 3223,4521,1717,4374,4007,0700,0000,0077,7774	; 5265		#/777774,J/BLTXV	;FROM T1 AND CONTINUE
							; 5266	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 142
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			UBABLT - BLT BYTES TO/FROM UNIBUS FORMAT		

U 3217, 3220,3446,1200,4174,4007,0700,0000,0000,0000	; 5267	BLTBU1:	Q_Q*.5			;NOW IN 1/2 WORDS
U 3220, 3221,3446,1200,4170,4007,0700,0000,0000,0000	; 5268		Q_Q*.5,HOLD LEFT	;INSERT A NULL BIT IN RH
U 3221, 3222,3446,1200,4170,4007,0700,0000,0000,0000	; 5269		Q_Q*.5,HOLD LEFT	;ONE MORE - NOW IN HALF WORDS
							; 5270		AD/D.AND.Q,DBUS/DBM,	;BUT NOT SWAPPED.  COPY RIGHT BYTE
U 3222, 0630,4665,0017,4374,4007,0700,0000,0000,0377	; 5271		DBM/#,#/377,DEST/AD*2,B/T1	;TO T1 AND SHIFT LEFT 1 POSITION
							; 5272	=00	FE_S#,S#/1771,		;-7 BITS MORE
U 0630, 3224,4443,0000,4174,4007,0700,1010,0071,1771	; 5273		CALL [T1LSH]		;TO FINAL RESTING PLACE
							; 5274	=01	FE_S#,S#/1770,		;-8. LEFT BYTES MOVE RIGHT
U 0631, 3225,4443,0000,4174,4007,0700,1010,0071,1770	; 5275		CALL [Q_RSH]		;TO FINAL RESTING PLACE
U 0633, 3223,4662,0000,4374,4007,0700,0000,0000,0377	; 5276	=11	Q_Q.AND.#,#/377		;WANT ONLY THE NEW BYTES
							; 5277	=
							; 5278	
							; 5279	BLTXV:	Q_[T1].OR.Q,		;MERGE RESULTS
U 3223, 3226,3002,1700,4174,4007,0700,0000,0000,0000	; 5280		J/BLTXW			;AND STUFF IN MEMORY
							; 5281	
U 3224, 0001,3445,1717,4174,4004,1700,1020,0041,0001	; 5282	T1LSH:	[T1]_[T1]*2,SHIFT,RETURN [1]
U 3225, 0002,3446,1200,4174,4004,1700,1020,0041,0001	; 5283	Q_RSH:	Q_Q*.5,SHIFT,RETURN [2]
							; 5284	
							; 5285	BLTXW:	VMA_[BRX],START WRITE,	;DEST TO VMA
U 3226, 3227,3443,0600,4174,4007,0700,0200,0003,0312	; 5286		PXCT BLT DEST
U 3227, 3230,3223,0000,4174,4007,0701,0200,0000,0002	; 5287		MEM WRITE,MEM_Q		;STORE
U 3230, 1350,2113,0603,4174,4007,0521,4000,0000,0000	; 5288		[BRX]-[AR],3T,SKIP DP0	;DONE?
U 1350, 1400,4221,0013,4170,4007,0700,0000,0000,0000	; 5289	=0	END BLT,J/DONE		;YES
U 1351, 3231,0111,0706,4174,4007,0700,0000,0000,0000	; 5290		[BRX]_[BRX]+1		;NO, INC DEST
							; 5291		VMA_[ARX]+1,LOAD VMA,	; AND SOURCE (LOADING VMA)
							; 5292		PXCT BLT SRC,START READ,;START UP MEMORY
U 3231, 3211,0111,0704,4170,4007,0700,0200,0004,0712	; 5293		J/BLTXLP		;AND CONTINUE WITH NEXT WORD
							; 5294	.ENDIF/UBABLT
							; 5295	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 143
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FAD, FSB				

							; 5296	.TOC	"FLOATING POINT -- FAD, FSB"
							; 5297	
							; 5298		.DCODE
D 0140, 0701,1577,1100					; 5299	140:	FL-R,	FL-AC,		J/FAD
D 0142, 0702,1577,1700					; 5300	142:	FL-RW,	FL-MEM,		J/FAD
D 0143, 0703,1577,1700					; 5301		FL-RW,	FL-BOTH,	J/FAD
D 0144, 0711,1577,1100					; 5302		FL-R,	FL-AC, ROUND,	J/FAD
D 0145, 0611,1577,0100					; 5303		FL-I,	FL-AC, ROUND,	J/FAD
D 0146, 0712,1577,1700					; 5304		FL-RW,	FL-MEM, ROUND,	J/FAD
D 0147, 0713,1577,1700					; 5305		FL-RW,	FL-BOTH, ROUND,	J/FAD
							; 5306	
D 0150, 0701,1576,1100					; 5307	150:	FL-R,	FL-AC,		J/FSB
D 0152, 0702,1576,1700					; 5308	152:	FL-RW,	FL-MEM,		J/FSB
D 0153, 0703,1576,1700					; 5309		FL-RW,	FL-BOTH,	J/FSB
D 0154, 0711,1576,1100					; 5310		FL-R,	FL-AC, ROUND,	J/FSB
D 0155, 0611,1576,0100					; 5311		FL-I,	FL-AC, ROUND,	J/FSB
D 0156, 0712,1576,1700					; 5312		FL-RW,	FL-MEM, ROUND,	J/FSB
D 0157, 0713,1576,1700					; 5313		FL-RW,	FL-BOTH, ROUND,	J/FSB
							; 5314		.UCODE
							; 5315	
							; 5316	;BOTH FAD & FSB ARE ENTERED WITH THE MEMORY OPERAND IN AR
							; 5317	; SIGN SMEARED. THE EXPONENT IN BOTH SC AND FE.
							; 5318	1576:
U 1576, 1577,2441,0303,4174,4007,0700,4000,0000,0000	; 5319	FSB:	[AR]_-[AR]		;MAKE MEMOP NEGATIVE
							; 5320	
							; 5321	1577:
U 1577, 0720,3771,0005,0276,6006,7701,2000,0020,2000	; 5322	FAD:	[BR]_AC, SC_SC-EXP-1, 3T, SCAD DISP
							; 5323	=0*
U 0720, 1354,3333,0005,4174,4007,0520,0000,0000,0000	; 5324	FAS1:	READ [BR], SKIP DP0, J/FAS2	;BR .LE. AR
U 0722, 3232,3441,0304,4174,4007,0700,0000,0000,0000	; 5325		[ARX]_[AR]		;SWAP AR AND BR
U 3232, 3233,3441,0503,4174,4007,0700,2000,0041,2000	; 5326		[AR]_[BR], SC_EXP
U 3233, 3234,3441,0405,4174,4007,0700,2000,0020,0000	; 5327		[BR]_[ARX], SC_SC-FE-1	;NUMBER OF SHIFT STEPS
U 3234, 1352,3333,0003,4174,4007,0520,1000,0041,2000	; 5328		READ [AR], FE_EXP, 2T, SKIP DP0
U 1352, 3235,4551,0303,4374,0007,0700,0000,0000,0777	; 5329	=0	[AR]_+SIGN, J/FAS3
U 1353, 3235,3551,0303,4374,0007,0700,0000,0077,7000	; 5330		[AR]_-SIGN, J/FAS3
							; 5331	
							; 5332	=0	;SIGN SMEAR BR AND UNNORMALIZE
U 1354, 3235,4551,0505,4374,0007,0700,0000,0000,0777	; 5333	FAS2:	[BR]_+SIGN, J/FAS3
U 1355, 3235,3551,0505,4374,0007,0700,0000,0077,7000	; 5334		[BR]_-SIGN, J/FAS3
							; 5335	
U 3235, 1356,4222,0000,4174,4007,0630,2000,0060,0000	; 5336	FAS3:	Q_0, STEP SC
							; 5337	=0
U 1356, 1356,3446,0505,4174,4047,0630,2000,0060,0000	; 5338	FAS4:	[BR]_[BR]*.5 LONG, STEP SC, ASHC, J/FAS4
U 1357, 0420,0111,0503,4174,4003,4701,0000,0000,0000	; 5339		[AR]_[AR]+[BR], NORM DISP, J/SNORM
							; 5340	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 144
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLAOTING POINT -- FMP					

							; 5341	.TOC	"FLAOTING POINT -- FMP"
							; 5342	
							; 5343		.DCODE
D 0160, 0701,1570,1100					; 5344	160:	FL-R,	FL-AC,		J/FMP
D 0162, 0702,1570,1700					; 5345	162:	FL-RW,	FL-MEM,		J/FMP
D 0163, 0703,1570,1700					; 5346		FL-RW,	FL-BOTH,	J/FMP
							; 5347	
D 0164, 0711,1570,1100					; 5348		FL-R,	FL-AC, ROUND,	J/FMP
D 0165, 0611,1570,0100					; 5349		FL-I,	FL-AC, ROUND,	J/FMP
D 0166, 0712,1570,1700					; 5350		FL-RW,	FL-MEM, ROUND,	J/FMP
D 0167, 0713,1570,1700					; 5351		FL-RW,	FL-BOTH, ROUND,	J/FMP
							; 5352		.UCODE
							; 5353	
							; 5354	1570:
							; 5355	FMP:	[BRX]_AC,		;GET AC
							; 5356		FE_SC+EXP, 3T,		;EXPONENT OF ANSWER
U 1570, 1360,3771,0006,0276,6007,0521,1000,0040,2000	; 5357		SKIP DP0		;GET READY TO SMEAR SIGN
U 1360, 3236,4551,0606,4374,0007,0700,0000,0000,0777	; 5358	=0	[BRX]_+SIGN, J/FMP1	;POSITIVE
U 1361, 3236,3551,0606,4374,0007,0700,0000,0077,7000	; 5359		[BRX]_-SIGN, J/FMP1	;NEGATIVE
U 3236, 0163,3442,0300,4174,4007,0700,2000,0071,0033	; 5360	FMP1:	Q_[AR], SC_27.		;GET MEMORY OPERAND
							; 5361	=01*	[BRX]_[BRX]*.5 LONG,	;SHIFT RIGHT
U 0163, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 5362		CALL [MULSUB]		;MULTIPLY
							; 5363		Q_Q.AND.#, #/777000,	;WE ONLY COMPUTED
U 0167, 3237,4662,0000,4370,4007,0700,0000,0077,7000	; 5364		HOLD LEFT		; 27 BITS
U 3237, 3240,3441,0403,4174,4007,0700,1000,0041,0002	; 5365		[AR]_[ARX], FE_FE+2	;SET SHIFT PATHS
							; 5366		[AR]_[AR]*.5 LONG,	;SHIFT OVER
							; 5367		FE_FE-200,		;ADJUST EXPONENT
U 3240, 0420,3446,0303,4174,4003,4701,1000,0041,1600	; 5368		NORM DISP, J/SNORM	;NORMALIZE & EXIT
							; 5369	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 145
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FDV					

							; 5370	.TOC	"FLOATING POINT -- FDV"
							; 5371	
							; 5372		.DCODE
D 0170, 0701,1574,1100					; 5373	170:	FL-R,	FL-AC,		J/FDV
D 0172, 0702,1574,1700					; 5374	172:	FL-RW,	FL-MEM,		J/FDV
D 0173, 0703,1574,1700					; 5375		FL-RW,	FL-BOTH,	J/FDV
							; 5376	
D 0174, 0711,1574,1100					; 5377		FL-R,	FL-AC, ROUND,	J/FDV
D 0175, 0611,1574,0100					; 5378		FL-I,	FL-AC, ROUND,	J/FDV
D 0176, 0712,1574,1700					; 5379		FL-RW,	FL-MEM, ROUND,	J/FDV
D 0177, 0713,1574,1700					; 5380		FL-RW,	FL-BOTH, ROUND,	J/FDV
							; 5381		.UCODE
							; 5382	
							; 5383	
							; 5384	1574:
U 1574, 1362,3441,0305,0174,4007,0621,0000,0000,0000	; 5385	FDV:	[BR]_[AR], SKIP AD.EQ.0, AC	;COPY DIVSOR SEE IF 0
							; 5386	=0
							; 5387		[AR]_AC, FE_SC-EXP, SKIP DP0,	;GET AC & COMPUTE NEW
U 1362, 1364,3771,0003,0276,6007,0520,1000,0030,2000	; 5388			J/FDV0			; EXPONENT
U 1363, 0555,4443,0000,4174,4467,0700,0000,0071,1000	; 5389		FL NO DIVIDE			;DIVIDE BY ZERO
							; 5390	=0
U 1364, 3241,4551,0303,4374,0007,0700,0000,0000,0777	; 5391	FDV0:	[AR]_+SIGN, J/FDV1
U 1365, 3242,3551,0303,4374,0007,0700,0000,0077,7000	; 5392		[AR]_-SIGN, J/FDV2
U 3241, 3243,3441,0304,4174,4007,0700,1000,0031,0200	; 5393	FDV1:	[ARX]_[AR],FE_-FE+200,J/FDV3	;COMPUTE 2*DVND
U 3242, 3243,2441,0304,4174,4007,0700,5000,0031,0200	; 5394	FDV2:	[ARX]_-[AR],FE_-FE+200,J/FDV3	;ABSOLUTE VALUE
U 3243, 1366,3445,0506,4174,4007,0520,0000,0000,0000	; 5395	FDV3:	[BRX]_[BR]*2, SKIP DP0	;ABSOLUTE VALUE
							; 5396	=0
U 1366, 1370,2113,0406,4174,4007,0311,4000,0000,0000	; 5397	FDV4:	[ARX]-[BRX], SKIP CRY0, 3T, J/FDV5	;FLOATING NO DIV?
U 1367, 1366,2445,0506,4174,4007,0700,4000,0000,0000	; 5398		[BRX]_-[BR]*2, J/FDV4		;FORCE ABSOLUTE VALUE
							; 5399	=0
U 1370, 1372,3447,0606,4174,4007,0700,0000,0000,0000	; 5400	FDV5:	[BRX]_[BRX]*.5, J/FDV6		;SHIFT BACK ARX
U 1371, 0555,4443,0000,4174,4467,0700,0000,0071,1000	; 5401		FL NO DIVIDE			;UNNORMALIZED INPUT
							; 5402	=0
							; 5403	FDV6:	[AR]_[AR]*2,			;DO NOT DROP A BIT
U 1372, 3725,3445,0303,4174,4007,0700,0010,0000,0000	; 5404		CALL [SBRL]			;AT FDV7+1
U 1373, 0144,2113,0604,4174,4007,0421,4000,0000,0000	; 5405		[BRX]-[ARX], SKIP AD.LE.0	;IS ANSWER .LE. 1?
							; 5406	=00100
U 0144, 3062,4222,0000,4174,4007,0700,2010,0071,0033	; 5407	FDV7:	Q_0, SC_27., CALL [DIVSGN]	;DIVIDE
U 0145, 0144,3447,0303,4174,4007,0700,1000,0041,0001	; 5408	=00101	[AR]_[AR]*.5, FE_FE+1, J/FDV7	;SCALE DV'END
							; 5409	=01100
U 0154, 3244,3227,0003,4174,4007,0700,0000,0000,0000	; 5410	FDV8:	[AR]_Q*.5, J/FDV9		;PUT ANSWER IN AR
							; 5411	=01101	READ [AR], SKIP AD.EQ.0,	;-VE ANSWER, LOOK AT RMDR
U 0155, 2074,3333,0003,4174,4007,0621,0010,0000,0000	; 5412		CALL [SETSN]			; SEE HOW TO NEGATE
							; 5413	=01110	READ [AR], SKIP AD.EQ.0,	;-VE ANSWER, LOOK AT RMDR
U 0156, 2074,3333,0003,4174,4007,0621,0010,0000,0000	; 5414		CALL [SETSN]			; SEE HOW TO NEGATE
U 0157, 3244,3227,0003,4174,4007,0700,0000,0000,0000	; 5415	=01111	[AR]_Q*.5, J/FDV9		;PUT ANSWER IN AR
U 0177, 3244,2227,0003,4174,4007,0700,4000,0000,0000	; 5416	=11111	[AR]_-Q*.5, J/FDV9		;ZERO RMDR
							; 5417	
U 3244, 2003,4222,0000,4174,4007,0700,0000,0000,0000	; 5418	FDV9:	Q_0, J/SNORM0			;GO NORMALIZE
							; 5419	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 146
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FLTR, FSC				

							; 5420	.TOC	"FLOATING POINT -- FLTR, FSC"
							; 5421	
							; 5422		.DCODE
D 0127, 0011,1616,1100					; 5423	127:	R,	FL-AC,ROUND,	J/FLTR
D 0132, 0001,1621,2100					; 5424	132:	I,	FL-AC,		J/FSC
							; 5425		.UCODE
							; 5426	
							; 5427	1616:
U 1616, 1374,4553,0300,4374,4007,0321,0000,0077,7000	; 5428	FLTR:	[AR].AND.#, #/777000, 3T, SKIP ADL.EQ.0 ;SMALL POS NUMBER?
U 1374, 1376,2441,0305,4174,4007,0521,4000,0000,0000	; 5429	=0	[BR]_-[AR], SKIP DP0, 3T, J/FLTR1	;NO--SEE IF MINUS
U 1375, 2003,4222,0000,4174,4007,0700,1000,0071,0233	; 5430		Q_0, FE_S#, S#/233, J/SNORM0	;FITS IN 27 BITS
							; 5431	=0
							; 5432	FLTR1:	[BR].AND.#, #/777000, 3T,
U 1376, 2000,4553,0500,4374,4007,0321,0000,0077,7000	; 5433			SKIP ADL.EQ.0, J/FLTR1A	;SMALL NEGATIVE NUMBER
U 1377, 3245,4222,0000,4174,4007,0700,1000,0071,0244	; 5434		Q_0, FE_S#, S#/244, J/FLTR2	;LARGE POS NUMBER
							; 5435	=0
U 2000, 3245,4222,0000,4174,4007,0700,1000,0071,0244	; 5436	FLTR1A:	Q_0, FE_S#, S#/244, J/FLTR2	;BIG NUMBER
U 2001, 2003,4222,0000,4174,4007,0700,1000,0071,0233	; 5437		Q_0, FE_S#, S#/233, J/SNORM0	;FITS IN 27 BITS
							; 5438	;AT THIS POINT WE KNOW THE NUMBER TAKES MORE THAN 27 BITS. WE JUST
							; 5439	; SHIFT 8 PLACES RIGHT AND NORMALIZE. WE COULD BE MORE CLEVER BUT
							; 5440	; THIS IS THE RARE CASE ANYWAY.
U 3245, 2002,3446,0303,4174,4047,0700,2000,0071,0006	; 5441	FLTR2:	[AR]_[AR]*.5 LONG, ASHC, SC_6	;SHOVE OVER TO THE RIGHT
							; 5442	=0
							; 5443	FLTR3:	[AR]_[AR]*.5 LONG, ASHC, 	;SHIFT RIGHT 9 PLACES
U 2002, 2002,3446,0303,4174,4047,0630,2000,0060,0000	; 5444			STEP SC, J/FLTR3	; SO IT WILL FIT
U 2003, 0420,3333,0003,4174,4003,4701,0000,0000,0000	; 5445	SNORM0:	READ [AR], NORM DISP, J/SNORM	;NORMALIZE ANSWER
							; 5446	
							; 5447	
							; 5448	1621:
U 1621, 3246,3333,0003,4174,4007,0700,2000,0041,4000	; 5449	FSC:	READ [AR], SC_SHIFT
U 3246, 3247,4222,0000,0174,4007,0700,0000,0000,0000	; 5450		Q_0, AC				;DON'T SHIFT IN JUNK
U 3247, 2004,3771,0003,0276,6007,0520,1000,0040,2000	; 5451		[AR]_AC, FE_SC+EXP, SKIP DP0	;SIGN SMEAR
U 2004, 2003,4551,0303,4374,0007,0700,0000,0000,0777	; 5452	=0	[AR]_+SIGN, J/SNORM0
U 2005, 2003,3551,0303,4374,0007,0700,0000,0077,7000	; 5453		[AR]_-SIGN, J/SNORM0
							; 5454	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 147
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FIX AND FIXR				

							; 5455	.TOC	"FLOATING POINT -- FIX AND FIXR"
							; 5456	
							; 5457		.DCODE
D 0122, 0701,1626,1100					; 5458	122:	FL-R,	FL-AC,		J/FIX
D 0126, 0711,1626,1100					; 5459	126:	FL-R,	FL-AC,ROUND,	J/FIX
							; 5460		.UCODE
							; 5461	
							; 5462	1626:
							; 5463	FIX:	Q_0, SCAD/A+B, SCADA/S#,	;CLEAR Q, SEE IF
							; 5464			S#/1534, SCADB/FE, 3T,	; ANSWER FITS IN
U 1626, 0724,4222,0000,4174,4006,7701,0000,0041,1534	; 5465			SCAD DISP		; 35 BITS.
U 0724, 0555,4443,0000,4174,4467,0700,0000,0041,1000	; 5466	=0*	SET AROV, J/NIDISP		;TOO BIG
U 0726, 0730,4443,0000,4174,4006,7701,2000,0041,1544	; 5467		SC_FE+S#, S#/1544, 3T, SCAD DISP ;NEED TO MOVE LEFT?
U 0730, 2010,4443,0000,4174,4007,0630,2000,0060,0000	; 5468	=0*	STEP SC, J/FIXL
U 0732, 3250,4443,0000,4174,4007,0700,2000,0031,0232	; 5469		SC_S#-FE, S#/232		;NUMBER OF PLACES TO SHIFT
							; 5470						; RIGHT
U 3250, 2006,4443,0000,4174,4007,0630,2000,0060,0000	; 5471		STEP SC				;ALREADY THERE
							; 5472	=0
							; 5473	FIXR:	[AR]_[AR]*.5 LONG, ASHC,	;SHIFT BINARY POINT
U 2006, 2006,3446,0303,4174,4047,0630,2000,0060,0000	; 5474			STEP SC, J/FIXR		; TO BIT 35.5
U 2007, 0063,3447,0705,4174,4003,7700,0000,0000,0000	; 5475		[BR]_[ONE]*.5, B DISP, J/FIXX	;WHICH KIND OF FIX?
							; 5476	
							; 5477	=0
U 2010, 2010,3445,0303,4174,4007,0630,2000,0060,0000	; 5478	FIXL:	[AR]_[AR]*2, STEP SC, J/FIXL	;SHIFT LEFT
U 2011, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 5479		AC_[AR], NEXT INST		;WE ARE NOW DONE
							; 5480	
							; 5481	=0*11
U 0063, 2012,3333,0003,4174,4007,0520,0000,0000,0000	; 5482	FIXX:	READ [AR], SKIP DP0, J/FIXT	;FIX--SEE IF MINUS
U 0073, 1514,0111,0503,4174,4003,7700,0200,0003,0001	; 5483	FIXX1:	[AR]_[AR]+[BR], FL-EXIT		;FIXR--ROUND UP
							; 5484	=0
U 2012, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 5485	FIXT:	AC_[AR], NEXT INST		;FIX & +, TRUNCATE
U 2013, 2014,3223,0000,4174,4007,0621,0000,0000,0000	; 5486		READ Q, SKIP AD.EQ.0		;NEGATIVE--ANY FRACTION?
U 2014, 1514,0111,0703,4174,4003,7700,0200,0003,0001	; 5487	=0	[AR]_[AR]+1, FL-EXIT		;YES--ROUND UP
							; 5488		[BR]_.NOT.[MASK],		;MAYBE--GENERATE .75
U 2015, 0073,7441,1205,4174,4007,0700,0000,0000,0000	; 5489		J/FIXX1				;ROUND UP IF BIT 36 OR
							; 5490						; 37 SET
							; 5491	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 148
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- SINGLE PRECISION NORMALIZE		

							; 5492	.TOC	"FLOATING POINT -- SINGLE PRECISION NORMALIZE"
							; 5493	
							; 5494	;NORMALIZE DISPATCH IS A 9-WAY DISPATCH. THE HARDWARE LOOKS AT
							; 5495	; 4 SIGNALS: DP=0, DP BIT 8, DP BIT 9, DP BIT -2. THE 9 CASES
							; 5496	; ARE:
							; 5497	
							; 5498	;	DP=0	DP08	DP09	DP00	ACTION TO TAKE
							; 5499	;	0	0	0	0	SHIFT LEFT
							; 5500	;
							; 5501	;	0	0	0	1	NEGATE AND RETRY
							; 5502	;
							; 5503	;	0	0	1	0	ALL DONE
							; 5504	;
							; 5505	;	0	0	1	1	NEGATE AND RETRY
							; 5506	;
							; 5507	;	0	1	0	0	SHIFT RIGHT
							; 5508	;
							; 5509	;	0	1	0	1	NEGATE AND RETRY
							; 5510	;
							; 5511	;	0	1	1	0	SHIFT RIGHT
							; 5512	;
							; 5513	;	0	1	1	1	NEGATE AND RETRY
							; 5514	;
							; 5515	;	1	-	-	-	LOOK AT Q BITS
							; 5516	
							; 5517	;ENTER HERE WITH UNNORMALIZED NUMBER IN AR!Q. FE HOLDS THE NEW
							; 5518	; EXPONENT. CALL WITH NORM DISP
							; 5519	=0000		;9-WAY DISPATCH
U 0420, 0420,3444,0303,4174,4063,4701,1000,0041,1777	; 5520	SNORM:	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNORM
U 0421, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5521		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0422, 0262,3333,0003,4174,4003,4701,0010,0000,0000	; 5522		READ [AR], NORM DISP, CALL [SROUND]
U 0423, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5523		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0424, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5524		[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0425, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5525		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0426, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5526		[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0427, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5527		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0430, 2016,3223,0000,4174,4007,0621,0000,0000,0000	; 5528		READ Q, SKIP AD.EQ.0, J/SNORM1
U 0436, 2017,3770,0303,4324,0457,0700,0000,0041,0000	; 5529	=1110	[AR]_EXP, J/FLEX
							; 5530	=
							; 5531	=0
U 2016, 0420,3444,0303,4174,4063,4701,1000,0041,1777	; 5532	SNORM1:	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNORM
U 2017, 1514,4443,0000,4174,4003,7700,0200,0003,0001	; 5533	FLEX:	FL-EXIT
							; 5534	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 149
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- SINGLE PRECISION NORMALIZE		

							; 5535	=0
U 2020, 0440,7441,0303,4174,4003,4701,0000,0000,0000	; 5536	SNNEG:	[AR]_.NOT.[AR], NORM DISP, J/SNNORM ;NEGATE HIGH WORD
							; 5537						; (NO CARRY)
U 2021, 0440,2441,0303,4174,4003,4701,4000,0000,0000	; 5538		[AR]_-[AR], NORM DISP, J/SNNORM	;NEGATE HIGH WORD (W/CARRY)
							; 5539	=0000
U 0440, 0440,3444,0303,4174,4063,4701,1000,0041,1777	; 5540	SNNORM:	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNNORM
U 0442, 0262,3333,0003,4174,4003,4701,0010,0000,0000	; 5541	=0010	READ [AR], NORM DISP, CALL [SROUND]
U 0444, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5542	=0100	[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0446, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5543	=0110	[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0450, 0440,3444,0303,4174,4063,4701,1000,0041,1777	; 5544	=1000	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNNORM
U 0456, 0327,3770,0303,4324,0453,7700,0000,0041,0000	; 5545	=1110	[AR]_EXP, B DISP
							; 5546	=
U 0327, 2022,4553,1300,4374,4007,0321,0000,0000,2000	; 5547	=0111	TL [FLG], FLG.SN/1, J/SNNOT
							; 5548		[AR]_[AR].AND.[MASK],	;CLEAR ANY LEFT OVER BITS
U 0337, 2025,4111,1203,4174,4007,0700,0000,0000,0000	; 5549		J/SNNOT1
							; 5550	=0
U 2022, 3251,7441,0303,4174,4007,0700,0000,0000,0000	; 5551	SNNOT:	[AR]_.NOT.[AR], J/SNNOT2
U 2023, 2024,3223,0000,4174,4007,0621,0000,0000,0000	; 5552		READ Q, SKIP AD.EQ.0
U 2024, 3251,7441,0303,4174,4007,0700,0000,0000,0000	; 5553	=0	[AR]_.NOT.[AR], J/SNNOT2
U 2025, 3251,2441,0303,4174,4007,0700,4000,0000,0000	; 5554	SNNOT1:	[AR]_-[AR], J/SNNOT2	;NORMAL NEGATE AND EXIT
U 3251, 1514,4221,0013,4174,4003,7700,0200,0003,0001	; 5555	SNNOT2:	[FLG]_0, FL-EXIT
							; 5556	
							; 5557	
							; 5558	
							; 5559	.TOC	"FLOATING POINT -- ROUND ANSWER"
							; 5560	
							; 5561	=*01*
U 0262, 0407,3447,0705,4174,4003,7700,0000,0000,0000	; 5562	SROUND:	[BR]_[ONE]*.5, B DISP, J/SRND1
U 0266, 0262,3447,0303,4174,4007,0700,1000,0041,0001	; 5563		[AR]_[AR]*.5, FE_FE+1, J/SROUND ;WE WENT TOO FAR
							; 5564	=0111
U 0407, 0016,4443,0000,4174,4004,1700,0000,0000,0000	; 5565	SRND1:	RETURN [16]			;NOT ROUNDING INSTRUCTION
U 0417, 0302,0111,0503,4174,4003,4701,0000,0000,0000	; 5566		[AR]_[AR]+[BR], NORM DISP
U 0302, 0016,4443,0000,4174,4004,1700,0000,0000,0000	; 5567	=*01*	RETURN [16]
U 0306, 0016,3447,0303,4174,4004,1700,1000,0041,0001	; 5568		[AR]_[AR]*.5, FE_FE+1, RETURN [16]
							; 5569	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 150
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFAD, DFSB				

							; 5570	.TOC	"FLOATING POINT -- DFAD, DFSB"
							; 5571	
							; 5572		.DCODE
D 0110, 1100,1637,1100					; 5573	110:	DBL FL-R,		J/DFAD
D 0111, 1100,1635,1100					; 5574	111:	DBL FL-R,		J/DFSB
							; 5575		.UCODE
							; 5576	
							; 5577	;ENTER FROM A-READ CODE WITH:
							; 5578	;FE/	EXP
							; 5579	;SC/	EXP
							; 5580	;AR/	C(E) SHIFT RIGHT 2 PLACES
							; 5581	;ARX/	C(E+1) SHIFTED RIGHT 1 PLACE
							; 5582	1635:
U 1635, 3252,2441,0404,4174,4007,0700,4000,0000,0000	; 5583	DFSB:	[ARX]_-[ARX]		;NEGATE LOW WORD
U 3252, 1637,2441,0303,4174,4007,0700,0040,0000,0000	; 5584		[AR]_-[AR]-.25, MULTI PREC/1
							; 5585	1637:
U 1637, 3253,4557,0006,1274,4007,0701,0000,0000,1441	; 5586	DFAD:	[BRX]_(AC[1].AND.[MAG])*.5, 3T ;GET LOW WORD
							; 5587		[BR]_AC*.5, 3T,		;GET AC AND START TO SHIFT
							; 5588		SC_SC-EXP-1,		;NUMBER OF PLACES TO SHIFT
U 3253, 2026,3777,0005,0274,4007,0521,2000,0020,2000	; 5589		SKIP DP0		;SEE WHAT SIGN
							; 5590	=0	[BR]_+SIGN*.5, 3T,	;SIGN SMEAR
U 2026, 2030,5547,0505,0374,4007,0631,0000,0077,7400	; 5591		AC, SKIP/SC, J/DFAS1	;SEE WHICH IS BIGGER
							; 5592		[BR]_-SIGN*.5, 3T,	;SIGN SMEAR
U 2027, 2030,3547,0505,0374,4007,0631,0000,0077,7400	; 5593		AC, SKIP/SC, J/DFAS1	;SEE WHICH IS BIGGER
							; 5594	=0
							; 5595	DFAS1:	Q_[BRX],		;AR IS BIGGER
U 2030, 2032,3442,0600,4174,4007,0700,0000,0000,0000	; 5596		J/DFAS2			;ADJUST BR!Q
							; 5597		[T0]_AC,		;BR IS BIGGER OR EQUAL
U 2031, 3255,3771,0016,0276,6007,0700,2000,0041,2000	; 5598		SC_EXP, 2T, J/DFAS3	;SET SC TO THAT EXPONENT
							; 5599	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 151
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFAD, DFSB				

							; 5600	;HERE IF AR!ARX IS GREATER THAN BR!BRX
							; 5601	=0
U 2032, 0153,3441,0516,4174,4007,0700,0010,0000,0000	; 5602	DFAS2:	[T0]_[BR], CALL [DFADJ]	;ADJUST BR!Q
U 2033, 3254,3441,1605,4174,4007,0700,0000,0000,0000	; 5603		[BR]_[T0]		;PUT ANSWER BACK
U 3254, 3260,0002,0400,4174,4007,0700,0000,0000,0000	; 5604		Q_Q+[ARX], J/DFAS5	;ADD LOW WORDS
							; 5605	
							; 5606	;HERE IS BR!BRX IF GREATER THAN OR EQUAL TO AR!ARX
							; 5607	DFAS3:	Q_[ARX],		;SETUP TO SHIFT AR!ARX
U 3255, 3256,3442,0400,4174,4007,0700,2000,0020,0000	; 5608		SC_SC-FE-1		;COMPUTE # OF PLACES
U 3256, 2034,3333,0016,4174,4007,0700,1000,0041,2000	; 5609		READ [T0], FE_EXP	;EXPONENT OF ANSWER
U 2034, 0153,3441,0316,4174,4007,0700,0010,0000,0000	; 5610	=0	[T0]_[AR], CALL [DFADJ]	;ADJUST AR!Q
U 2035, 3257,3441,1603,4174,4007,0700,0000,0000,0000	; 5611		[AR]_[T0]		;PUT ANSWER BACK
U 3257, 3260,0002,0600,4174,4007,0700,0000,0000,0000	; 5612		Q_Q+[BRX], J/DFAS5	;ADD LOW WORDS
							; 5613	
							; 5614	;BIT DIDDLE TO GET THE ANSWER (INCLUDING 2 GUARD BITS) INTO
							; 5615	; AR!Q
							; 5616	DFAS5:	[AR]_([AR]+[BR])*.5 LONG, ;ADD HIGH WORDS
U 3260, 3261,0116,0503,4174,4047,0700,0040,0000,0000	; 5617		MULTI PREC/1, ASHC	;INJECT SAVED CRY2
							; 5618		[AR]_[AR]*2 LONG,	;SHIFT BACK LEFT
U 3261, 0433,3444,0303,4174,4046,2700,0000,0000,0000	; 5619		ASHC, MUL DISP		;SEE IF WE LOST A 1
							; 5620	=1011
U 0433, 3262,5111,1217,4174,4007,0700,0000,0000,0000	; 5621	DFAS6:	[T1]_[T1].AND.NOT.[MASK], J/DFAS7
U 0437, 0433,0222,0000,4174,4007,0700,4000,0000,0000	; 5622		Q_Q+.25, J/DFAS6
							; 5623	DFAS7:	[AR]_[AR]*2 LONG, ASHC,	;PUT IN GUARD BITS
U 3262, 3263,3444,0303,4174,4047,0700,1000,0041,1777	; 5624		FE_FE-1
							; 5625		[AR]_[AR]*2 LONG, ASHC,
U 3263, 3264,3444,0303,4174,4047,0700,1000,0041,1777	; 5626		FE_FE-1
U 3264, 2047,3002,1700,4170,4007,0700,0000,0000,0000	; 5627		Q_[T1].OR.Q, HOLD LEFT, J/DNORM0
							; 5628	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 152
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFAD, DFSB				

							; 5629	;SUBROUTINE TO ADJUST NUMBER IN T0!Q
							; 5630	;RETURNS 1 WITH
							; 5631	;	T0!Q ADJUSTED
							; 5632	;	FLG.SN=1 IF WE SHIFTED OUT ANY 1 BITS (STICKY BIT)
							; 5633	;	T1 HAS Q TWO STEPS PRIOR TO BEING DONE
							; 5634	DFADJ	"STEP SC, ASHC, MUL DISP"
							; 5635	
							; 5636	=0**11
							; 5637	DFADJ:	[T0]_[T0]*2 LONG, DIV,	;MOVE EVERYTHING 2 PLACES
U 0153, 2075,3444,1616,4174,4067,0700,0010,0000,0000	; 5638		CALL [CLRSN]
U 0173, 3265,3444,1616,4174,4067,0700,0000,0000,0000	; 5639		[T0]_[T0]*2 LONG, DIV
U 3265, 3266,3444,1616,4174,4067,0700,0000,0000,0000	; 5640		[T0]_[T0]*2 LONG, DIV
							; 5641		[T0]_[T0]*.5 LONG, ASHC, ;SHIFT AT LEAST 1 PLACE
U 3266, 0472,3446,1616,4174,4047,0630,2000,0060,0000	; 5642		STEP SC
							; 5643	=1010
							; 5644	DFADJ1:	[T0]_[T0]*.5 LONG,	;UNNORMALIZE T0!Q
U 0472, 0472,3446,1616,4174,4046,2630,2000,0060,0000	; 5645		DFADJ, J/DFADJ1		;LOOP TILL DONE
							; 5646	DFADJ2:	[T1]_Q,			;SAVE GUARD BITS
U 0473, 0453,3221,0017,4174,4006,2700,0000,0000,0000	; 5647		MUL DISP, J/DFADJ5	;LOOK AT LAST BIT
U 0476, 2036,3551,1313,4374,0007,0700,0000,0000,2000	; 5648		[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, J/DFADJ3
U 0477, 2037,3551,1313,4374,0007,0700,0000,0000,2000	; 5649		[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, J/DFADJ4
							; 5650	
							; 5651	=0
U 2036, 2036,3446,1616,4174,4047,0630,2000,0060,0000	; 5652	DFADJ3:	[T0]_[T0]*.5 LONG, ASHC, STEP SC, J/DFADJ3
U 2037, 0453,3221,0017,4174,4007,0700,0000,0000,0000	; 5653	DFADJ4:	[T1]_Q			;SAVE 2 GUARD BITS
							; 5654	=1011
U 0453, 3267,3446,1616,4174,4047,0700,0000,0000,0000	; 5655	DFADJ5:	[T0]_[T0]*.5 LONG, ASHC, J/DFADJ6
U 0457, 0453,3551,1313,4374,0007,0700,0000,0000,2000	; 5656		[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, J/DFADJ5
U 3267, 0001,3446,1616,4174,4044,1700,0000,0000,0000	; 5657	DFADJ6:	[T0]_[T0]*.5 LONG, ASHC, RETURN [1]
							; 5658	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 153
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFMP					

							; 5659	.TOC	"FLOATING POINT -- DFMP"
							; 5660	
							; 5661		.DCODE
D 0112, 1105,1631,1100					; 5662	112:	DBL FL-R,	DAC,	J/DFMP
							; 5663		.UCODE
							; 5664	
							; 5665	;SAME ENTRY CONDITIONS AS DFAD/DFSB
							; 5666	1631:
U 1631, 2040,3442,0400,4174,4007,0700,2000,0071,0006	; 5667	DFMP:	Q_[ARX], SC_6		;SHIFT MEM OP 8 PLACES
							; 5668	=0
							; 5669	DFMP1:	[AR]_[AR]*2 LONG, ASHC,	;SHIFT
U 2040, 2040,3444,0303,4174,4047,0630,2000,0060,0000	; 5670		STEP SC, J/DFMP1
U 2041, 3270,3446,1200,4174,4007,0700,0000,0000,0000	; 5671		Q_Q*.5
U 3270, 3271,4662,0000,4374,0007,0700,0000,0007,7777	; 5672		Q_Q.AND.#, #/077777, HOLD RIGHT
U 3271, 3272,3221,0005,4174,4007,0700,0000,0000,0000	; 5673		[BR]_Q			;COPY LOW WORD
							; 5674	;
							; 5675	; BRX * BR ==> C(E+1) * C(AC+1)
							; 5676	;
U 3272, 0623,4557,0006,1274,4007,0700,0000,0000,1441	; 5677		[BRX]_(AC[1].AND.[MAG])*.5 ;GET LOW AC
U 0623, 3020,3447,0606,4174,4007,0700,2010,0071,0043	; 5678	=0**	[BRX]_[BRX]*.5, SC_35., CALL [MULSB1]
							; 5679	;
							; 5680	; BRX * Q ==> C(E) * C(AC+1)
							; 5681	;
U 0627, 1012,3442,0300,4174,4007,0700,2000,0071,0043	; 5682		Q_[AR], SC_35. 		;GO MULT NEXT HUNK
U 1012, 3021,4443,0000,4174,4007,0700,0010,0000,0000	; 5683	=0**	CALL [MULTIPLY]
U 1016, 3273,3441,0416,4174,4007,0700,0000,0000,0000	; 5684		[T0]_[ARX]		;SAVE PRODUCT
U 3273, 3274,3227,0004,4174,4007,0700,2000,0011,0000	; 5685		[ARX]_Q*.5, SC_FE	;PUT IN NEXT STEP
							; 5686	;
							; 5687	; BRX * BR ==> C(AC) * C(E+1)
							; 5688	;
							; 5689		[BRX]_AC*.5,		;PREPARE TO DO HIGH HALF
							; 5690		FE_SC+EXP,		;EXPONENT ON ANSWER
U 3274, 2042,3777,0006,0274,4007,0521,1000,0040,2000	; 5691		SKIP DP0, 3T
U 2042, 1032,5547,0606,4374,4007,0701,0000,0077,7400	; 5692	=0	[BRX]_+SIGN*.5, 3T, J/DFMP2
U 2043, 1032,3547,0606,4374,4007,0701,0000,0077,7400	; 5693		[BRX]_-SIGN*.5, 3T
							; 5694	=0**
U 1032, 3021,3442,0500,4174,4007,0700,2010,0071,0043	; 5695	DFMP2:	Q_[BR], SC_35., CALL [MULTIPLY]	;GO MULTIPLY
U 1036, 3275,3221,0017,4174,4007,0700,0000,0000,0000	; 5696		[T1]_Q			;SAVE FOR ROUNDING
U 3275, 1062,0111,1604,4174,4007,0700,0000,0000,0000	; 5697		[ARX]_[ARX]+[T0]	;PREPARE FOR LAST MUL
							; 5698	;
							; 5699	; BRX * Q ==> C(AC) * C(E)
							; 5700	;
							; 5701	=0**	Q_[AR], SC_35., 	;DO THE LAST MULTIPLY
U 1062, 3021,3442,0300,4174,4007,0700,2010,0071,0043	; 5702		CALL [MULTIPLY]		; ..
							; 5703	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 154
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFMP					

							; 5704	;OK, WE NOW HAVE THE PRODUCT IN ARX!Q!T1. ALL WE NEED TO DO
							; 5705	; IS SOME BIT DIDDLES TO GET EVERYTHING IN THE RIGHT PLACE
							; 5706		[AR]_[ARX]*.5 LONG,	;SHIFT THE ANSWER
U 1066, 0243,3446,0403,4174,4007,0700,1000,0041,1576	; 5707		FE_FE+S#, S#/1576	;CORRECT EXPONENT
							; 5708	=0**11	READ [T1], SKIP AD.EQ.0, ;SEE IF LOW ORDER 1
U 0243, 2074,3333,0017,4174,4007,0621,0010,0000,0000	; 5709		CALL [SETSN]		; BITS AROUND SOMEPLACE
U 0263, 3276,3444,0303,4174,4047,0700,0000,0000,0000	; 5710		[AR]_[AR]*2 LONG, ASHC	;SHIFT LEFT
U 3276, 3277,3447,0705,4174,4007,0700,0000,0000,0000	; 5711		[BR]_[ONE]*.5		;PLACE TO INSTERT BITS
U 3277, 2044,4553,1700,4374,4007,0321,0000,0020,0000	; 5712		TL [T1], #/200000	;ANYTHING TO INJECT?
U 2044, 2045,0002,0500,4174,4007,0700,0000,0000,0000	; 5713	=0	Q_Q+[BR]		;YES--PUT IT IN
U 2045, 3300,3444,0303,4174,4047,0700,0000,0000,0000	; 5714		[AR]_[AR]*2 LONG, ASHC	;MAKE ROOM FOR MORE
U 3300, 2046,4553,1700,4374,4007,0321,0000,0010,0000	; 5715		TL [T1], #/100000	;ANOTHER BIT NEEDED
U 2046, 2047,0002,0500,4174,4007,0700,0000,0000,0000	; 5716	=0	Q_Q+[BR]		;YES--PUT IN LAST BIT
							; 5717	DNORM0:	READ [AR], NORM DISP,	;SEE WHAT WE NEED TO DO
U 2047, 0520,3333,0003,4174,4003,4701,1000,0041,0002	; 5718		FE_FE+S#, S#/2, J/DNORM	;ADJUST FOR INITIAL SHIFTS
							; 5719	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 155
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFDV					

							; 5720	.TOC	"FLOATING POINT -- DFDV"
							; 5721	
							; 5722		.DCODE
D 0113, 1105,1636,1100					; 5723	113:	DBL FL-R,	DAC,	J/DFDV
							; 5724		.UCODE
							; 5725	1636:
U 1636, 0132,3441,0406,4174,4007,0700,0000,0000,0000	; 5726	DFDV:	[BRX]_[ARX]		;COPY OPERAND (COULD SAVE TIME
							; 5727					; WITH SEPERATE A-READ FOR DFDV)
U 0132, 2075,4221,0017,4174,4007,0700,0010,0000,0000	; 5728	=1**10	[T1]_0, CALL [CLRSN]	;CLEAR FLAG
							; 5729		[BR]_[AR], SKIP AD.LE.0, ;SEE IF POSITIVE
U 0133, 2050,3441,0305,1174,4007,0421,0000,0000,1441	; 5730		AC[1]			;WARM UP RAM
							; 5731	=0
							; 5732	DFDV1:	[ARX]_(AC[1].AND.[MAG])*.5, ;POSITIVE--GET AC
U 2050, 3303,4557,0004,1274,4007,0700,0000,0000,1441	; 5733		J/DFDV2			; AND CONTINUE BELOW
U 2051, 3301,7441,1717,4174,4007,0700,0000,0000,0000	; 5734		[T1]_.NOT.[T1]		;DV'SOR NEGATIVE (OR ZERO)
U 3301, 3302,2441,0606,4174,4007,0700,4000,0000,0000	; 5735		[BRX]_-[BRX]		;NEGATE LOW WORD
							; 5736		AD/-B-.25, B/BR, DEST/AD, ;NEGATE HIGH WORD
							; 5737		MULTI PREC/1, 3T,	;ADDING IN CRY02
							; 5738		SKIP DP0, AC[1],	;SEE IF STILL NEGATIVE
U 3302, 2050,2331,0005,1174,4007,0521,0040,0000,1441	; 5739		J/DFDV1			; ..
							; 5740	DFDV2:	[AR]_AC*.5,		;GET AC AND SHIFT
							; 5741		FE_SC-EXP, 3T,		;COMPUTE NEW EXPONENT
U 3303, 2052,3777,0003,0274,4007,0521,1000,0030,2000	; 5742		SKIP DP0		;SEE IF NEGATIVE
U 2052, 2054,5547,0303,4374,4007,0701,0000,0077,7400	; 5743	=0	[AR]_+SIGN*.5, 3T, J/DFDV3	;POSITIVE
U 2053, 3304,7441,1717,4174,4007,0700,0000,0000,0000	; 5744		[T1]_.NOT.[T1]		;NEGATIVE OR ZERO
U 3304, 3305,3547,0303,4374,4007,0701,0000,0077,7400	; 5745		[AR]_-SIGN*.5, 3T	;SIGN SMEAR
U 3305, 3306,2442,0400,4174,4007,0700,4000,0000,0000	; 5746		Q_-[ARX]		;NEGATE OPERAND
							; 5747		[AR]_(-[AR]-.25)*.5 LONG, ;NEGATE HIGH WORD
							; 5748		MULTI PREC/1,		;USE SAVED CARRY
U 3306, 2055,2446,0303,4174,4047,0700,0040,0000,0000	; 5749		ASHC, J/DFDV4		;CONTINUE BELOW
							; 5750	=0
							; 5751	DFDV3:	Q_[ARX],		;COPY OPERAND
U 2054, 3061,3442,0400,4174,4007,0700,0010,0000,0000	; 5752		CALL [DDIVS]		;SHIFT OVER
U 2055, 2056,2113,0305,4174,4007,0521,4000,0000,0000	; 5753	DFDV4:	[AR]-[BR], 3T, SKIP DP0	;SEE IF OVERFLOW
U 2056, 0555,4443,0000,4174,4467,0700,0000,0071,1000	; 5754	=0	FL NO DIVIDE
U 2057, 0734,3221,0004,4174,4007,0700,0000,0000,0000	; 5755		[ARX]_Q			;START DIVISION
U 0734, 1302,4222,0000,4174,4007,0700,2010,0071,0032	; 5756	=0*	Q_0, SC_26., CALL [DBLDIV]
U 0736, 1054,3221,0016,4174,4007,0700,2000,0071,0043	; 5757		[T0]_Q, SC_35.
							; 5758	=0*	Q_Q.AND.NOT.[MAG],	;SEE IF ODD
							; 5759		SKIP AD.EQ.0,		;SKIP IF EVEN
U 1054, 1302,5002,0000,4174,4007,0621,0010,0000,0000	; 5760		CALL [DBLDIV]		;GO DIVIDE
U 1056, 3307,3446,1200,4174,4007,0700,0000,0000,0000	; 5761		Q_Q*.5			;MOVE ANSWER OVER
							; 5762	=
							; 5763		[T0]_[T0]*2 LONG, ASHC, ;DO FIRST NORM STEP
U 3307, 0513,3444,1616,4174,4046,2700,0000,0000,0000	; 5764		MUL DISP		; SEE IF A 1 FELL OUT
							; 5765	=1011
							; 5766	DFDV4A:	READ [T1], SKIP DP0,	;SHOULD RESULT BE NEGATIVE
							; 5767		FE_S#-FE, S#/202,	;CORRECT EXPONENT
U 0513, 2060,3333,0017,4174,4007,0520,1000,0031,0202	; 5768		J/DFDV4B		;LOOK BELOW
U 0517, 0513,0222,0000,4174,4007,0700,4000,0000,0000	; 5769		Q_Q+.25, J/DFDV4A	;PUT BACK THE BIT
							; 5770	=0
U 2060, 0520,3441,1603,4174,4003,4701,0000,0000,0000	; 5771	DFDV4B:	[AR]_[T0], NORM DISP, J/DNORM ;PLUS
U 2061, 0200,3441,1603,4174,4003,4701,0000,0000,0000	; 5772		[AR]_[T0], NORM DISP, J/DNNORM ;MINUS
							; 5773	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 156
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DOUBLE PRECISION NORMALIZE		

							; 5774	.TOC	"FLOATING POINT -- DOUBLE PRECISION NORMALIZE"
							; 5775	
							; 5776	;NORMALIZE AR!Q
							; 5777	;DNORM0:	READ [AR], NORM DISP,	;SEE WHAT WE NEED TO DO
							; 5778	;	FE_FE+S#, S#/2, J/DNORM	;ADJUST FOR INITIAL SHIFTS
							; 5779	=0000
							; 5780	DNORM:	[AR]_[AR]*2 LONG,	;SHIFT LEFT
							; 5781		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 0520, 0520,3444,0303,4174,4043,4701,1000,0041,1777	; 5782		NORM DISP, J/DNORM	;TRY AGAIN
U 0521, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5783		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5784		READ [AR], NORM DISP,	;SEE IF WE WENT TOO FAR
U 0522, 0322,3333,0003,4174,4003,4701,0010,0000,0000	; 5785		CALL [DROUND]		; AND ROUND ANSWER
U 0523, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5786		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5787		[AR]_[AR]*.5 LONG, ASHC,
U 0524, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5788		FE_FE+1, CALL [DROUND]
U 0525, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5789		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5790		[AR]_[AR]*.5 LONG, ASHC,
U 0526, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5791		FE_FE+1, CALL [DROUND]
U 0527, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5792		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5793		Q_[MAG].AND.Q,		;HIGH WORD IS ZERO
U 0530, 3311,4002,0000,4174,0007,0700,0000,0000,0000	; 5794		HOLD RIGHT, J/DNORM1	;GO TEST LOW WORD
U 0536, 3310,4221,0013,4174,4007,0700,0000,0000,0000	; 5795	=1110	[FLG]_0			;[122] CLEAR FLAG WORD
							; 5796	=
							; 5797		AC[1]_[ARX].AND.[MAG],	;STORE LOW WORD
U 3310, 1515,4113,0400,1174,4007,0700,0400,0000,1441	; 5798		J/STAC			;GO DO HIGH WORD
							; 5799	
							; 5800	
U 3311, 2062,3223,0000,4174,4007,0621,0000,0000,0000	; 5801	DNORM1:	READ Q, SKIP AD.EQ.0	;TEST LOW WORD
							; 5802	=0	[AR]_[AR]*2 LONG, 	;LOW WORD IS NON-ZERO
							; 5803		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 2062, 0520,3444,0303,4174,4043,4701,1000,0041,1777	; 5804		NORM DISP, J/DNORM	;KEEP LOOKING
U 2063, 1515,3440,0303,1174,4007,0700,0400,0000,1441	; 5805		AC[1]_[AR], J/STAC	;WHOLE ANSWER IS ZERO
							; 5806	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 157
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DOUBLE PRECISION NORMALIZE		

							; 5807	;HERE TO NORMALIZE NEGATIVE D.P. RESULTS
							; 5808	=0
U 2064, 3312,7222,0000,4174,4007,0700,0000,0000,0000	; 5809	DNEG:	Q_.NOT.Q, J/DNEG1	;ONES COMP
U 2065, 2066,2222,0000,4174,4007,0511,4000,0000,0000	; 5810		Q_-Q, SKIP CRY2, J/DNEG2
U 3312, 2066,4221,0013,4174,4007,0700,0000,0000,0000	; 5811	DNEG1:	[FLG]_0
							; 5812	=0
							; 5813	DNEG2:	[AR]_.NOT.[AR],		;NO CARRY
U 2066, 0200,7441,0303,4174,4003,4701,0000,0000,0000	; 5814		NORM DISP, J/DNNORM	;GO NORMALIZE
							; 5815		[AR]_-[AR],		;CARRY
U 2067, 0200,2441,0303,4174,4003,4701,4000,0000,0000	; 5816		NORM DISP, J/DNNORM	;NORMALIZE
							; 5817	
							; 5818	=000*
							; 5819	DNNORM:	[AR]_[AR]*2 LONG,	;SHIFT 1 PLACE
							; 5820		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 0200, 0200,3444,0303,4174,4043,4701,1000,0041,1777	; 5821		NORM DISP, J/DNNORM	;LOOP TILL DONE
							; 5822	=001*	READ [AR], NORM DISP,	;SEE IF WE WENT TOO FAR
U 0202, 0322,3333,0003,4174,4003,4701,0010,0000,0000	; 5823		CALL [DROUND]		; AND ROUND ANSWER
							; 5824	=010*	[AR]_[AR]*.5 LONG, ASHC,
U 0204, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5825		FE_FE+1, CALL [DROUND]
							; 5826	=011*	[AR]_[AR]*.5 LONG, ASHC,
U 0206, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5827		FE_FE+1, CALL [DROUND]
							; 5828	=100*	Q_[MAG].AND.Q,		;HIGH WORD IS ZERO
U 0210, 3315,4002,0000,4174,0007,0700,0000,0000,0000	; 5829		HOLD RIGHT, J/DNNRM1	;GO TEST LOW WORD
U 0216, 0650,4111,1204,4174,4007,0700,0000,0000,0000	; 5830	=111*	[ARX]_[ARX].AND.[MASK]	;REMOVE ROUNDING BIT
							; 5831	=
							; 5832	=00	[ARX]_[ARX].AND.[MAG],	;ALSO CLEAR SIGN
U 0650, 3316,4111,0004,4174,4007,0700,0010,0000,0000	; 5833		CALL [CHKSN]		;ONES COMP?
							; 5834	=10	[ARX]_[ARX].XOR.[MAG],	;YES--ONES COMP
U 0652, 3313,6111,0004,4174,4007,0700,0000,0000,0000	; 5835		J/DNN1			;CONTINUE BELOW
							; 5836	=11	[ARX]_-[ARX], 3T,	;NEGATE RESULT
U 0653, 2070,2441,0404,4174,4007,0561,4000,0000,0000	; 5837		SKIP CRY1, J/DNN2
							; 5838	=
U 3313, 2070,4221,0013,4174,4007,0700,0000,0000,0000	; 5839	DNN1:	[FLG]_0			;CLEAR FLAG
							; 5840	=0
U 2070, 3314,7333,0003,0174,4007,0700,0400,0000,0000	; 5841	DNN2:	AC_.NOT.[AR], J/DNORM2
U 2071, 3314,2443,0300,0174,4007,0701,4400,0000,0000	; 5842		AC_-[AR], 3T
							; 5843	DNORM2:	AC[1]_[ARX].AND.[MAG],	;STORE LOW WORD
U 3314, 0100,4113,0400,1174,4156,4700,0400,0000,1441	; 5844		NEXT INST		;ALL DONE
							; 5845	
U 3315, 2072,3223,0000,4174,4007,0621,0000,0000,0000	; 5846	DNNRM1:	READ Q, SKIP AD.EQ.0	;TEST LOW WORD
							; 5847	=0	[AR]_[AR]*2 LONG, 	;LOW WORD IS NON-ZERO
							; 5848		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 2072, 0200,3444,0303,4174,4043,4701,1000,0041,1777	; 5849		NORM DISP, J/DNNORM	;KEEP LOOKING
U 2073, 1515,3440,0303,1174,4007,0700,0400,0000,1441	; 5850		AC[1]_[AR], J/STAC	;WHOLE ANSWER IS ZERO
							; 5851	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 158
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DOUBLE PRECISION NORMALIZE		

U 3316, 0002,4553,1300,4374,4004,1321,0000,0000,2000	; 5852	CHKSN:	TL [FLG], FLG.SN/1, RETURN [2]
							; 5853	
							; 5854	;SUBROUTINE TO SET/CLEAR FLG.SN
							; 5855	;CALL WITH:
							; 5856	;	CALL [SETSN], SKIP IF WE SHOULD CLEAR
							; 5857	;RETURNS 23
							; 5858	=0
U 2074, 0023,3551,1313,4374,0004,1700,0000,0000,2000	; 5859	SETSN:	[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, RETURN [23]
U 2075, 0023,5551,1313,4374,0004,1700,0000,0000,2000	; 5860	CLRSN:	[FLG]_[FLG].AND.NOT.#, FLG.SN/1, HOLD RIGHT, RETURN [23]
							; 5861	
							; 5862	
							; 5863	;SUBROUTINE TO ROUND A FLOATING POINT NUMBER
							; 5864	;CALL WITH:
							; 5865	;	NUMBER IN AR!Q AND NORM DISP
							; 5866	;RETURNS 16 WITH ROUNDED NUMBER IN AR!ARX
							; 5867	;
							; 5868	=*01*
							; 5869	DROUND:	[ARX]_(Q+1)*.5,		;ROUND AND SHIFT
							; 5870		SKIP CRY2,		;SEE IF OVERFLOW
U 0322, 0462,0007,0704,4174,4007,0511,0000,0000,0000	; 5871		J/DRND1			;COMPLETE ROUNDING
							; 5872		[AR]_[AR]*.5 LONG,	;WE WENT TOO FAR
U 0326, 0322,3446,0303,4174,4047,0700,1000,0041,0001	; 5873		FE_FE+1, ASHC, J/DROUND	;SHIFT BACK AND ROUND
							; 5874	=*010
U 0462, 0016,3770,0303,4324,0454,1700,0000,0041,0000	; 5875	DRND1:	[AR]_EXP, RETURN [16]	;NO OVERFLOW
							; 5876	=011	[AR]_[AR]+.25,		;ADD CARRY (BITS 36 AND 37
							; 5877					; ARE COPIES OF Q BITS)
							; 5878		NORM DISP,		;SEE IF OVERFLOW
U 0463, 0462,0441,0303,4174,4003,4701,4000,0000,0000	; 5879		J/DRND1		; ..
							; 5880	=110	[AR]_[AR]*.5,		;SHIFT RIGHT
							; 5881		FE_FE+1,		;KEEP EXP RIGHT
U 0466, 0462,3447,0303,4174,4007,0700,1000,0041,0001	; 5882		J/DRND1		;ALL SET NOW
							; 5883	=
							; 5884	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 159
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DISPATCH ROM ENTRIES				

							; 5885	.TOC	"EXTEND -- DISPATCH ROM ENTRIES"
							; 5886	
							; 5887		.DCODE
D 0001, 0001,1740,2100					; 5888	001:	I,	SJCL,	J/L-CMS
D 0002, 0002,1740,2100					; 5889		I,	SJCE,	J/L-CMS
D 0003, 0003,1740,2100					; 5890		I,	SJCLE,	J/L-CMS
D 0004, 0002,1741,2100					; 5891		I,	B/2,	J/L-EDIT
D 0005, 0005,1740,2100					; 5892		I,	SJCGE,	J/L-CMS
D 0006, 0006,1740,2100					; 5893		I,	SJCN,	J/L-CMS
D 0007, 0007,1740,2100					; 5894		I,	SJCG,	J/L-CMS
							; 5895	
D 0010, 0001,1742,2100					; 5896	010:	I,	B/1,	J/L-DBIN	;CVTDBO
D 0011, 0004,1742,2100					; 5897		I,	B/4,	J/L-DBIN	;CVTDBT
D 0012, 0001,1743,2100					; 5898		I,	B/1,	J/L-BDEC	;CVTBDO
D 0013, 0000,1743,2100					; 5899		I,	B/0,	J/L-BDEC	;CVTBDT
							; 5900	
D 0014, 0001,1744,2100					; 5901	014:	I,	B/1,	J/L-MVS		;MOVSO
D 0015, 0000,1744,2100					; 5902		I,	B/0,	J/L-MVS		;MOVST
D 0016, 0002,1744,2100					; 5903		I,	B/2,	J/L-MVS		;MOVSLJ
D 0017, 0003,1744,2100					; 5904		I,	B/3,	J/L-MVS		;MOVSRJ	
							; 5905	
D 0020, 0000,1746,2100					; 5906	020:	I,		J/L-XBLT	;XBLT
D 0021, 0000,1747,2100					; 5907		I,		J/L-SPARE-A	;GSNGL
D 0022, 0000,1750,2100					; 5908		I,		J/L-SPARE-B	;GDBLE
D 0023, 0000,1751,2100					; 5909		I,	B/0,	J/L-SPARE-C	;GDFIX
D 0024, 0001,1751,2100					; 5910		I,	B/1,	J/L-SPARE-C	;GFIX
D 0025, 0002,1751,2100					; 5911		I,	B/2,	J/L-SPARE-C	;GDFIXR
D 0026, 0004,1751,2100					; 5912		I,	B/4,	J/L-SPARE-C	;GFIXR
D 0027, 0010,1751,2100					; 5913		I,	B/10,	J/L-SPARE-C	;DGFLTR
							; 5914	;30:					;GFLTR
							; 5915						;GFSC
							; 5916		.UCODE
							; 5917	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 160
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DISPATCH ROM ENTRIES				

							; 5918	1740:
U 1740, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5919	L-CMS:	LUUO
							; 5920	1741:
U 1741, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5921	L-EDIT:	LUUO
							; 5922	1742:
U 1742, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5923	L-DBIN:	LUUO
							; 5924	1743:
U 1743, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5925	L-BDEC:	LUUO
							; 5926	1744:
U 1744, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5927	L-MVS:	LUUO
							; 5928	1746:
U 1746, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5929	L-XBLT:	LUUO
							; 5930	1747:
U 1747, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5931	L-SPARE-A: LUUO
							; 5932	1750:
U 1750, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5933	L-SPARE-B: LUUO
							; 5934	1751:
U 1751, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5935	L-SPARE-C: LUUO
							; 5936	
							; 5937	;NOTE: WE DO NOT NEED TO RESERVE 3746 TO 3751 BECAUSE THE CODE
							; 5938	;	AT EXTEND DOES A RANGE CHECK.
							; 5939	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 161
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- INSTRUCTION SET DECODING			

							; 5940	.TOC	"EXTEND -- INSTRUCTION SET DECODING"
							; 5941	
							; 5942	;EACH INSTRUCTION IN THE RANGE 1-23 GOES TO 1 OF 2 PLACES
							; 5943	; 1740-1747 IF NOT UNDER EXTEND
							; 5944	; 3740-3747 IF UNDER EXTEND
							; 5945	
							; 5946		.DCODE
D 0123, 0000,1467,3100					; 5947	123:	I,READ/1,		J/EXTEND
							; 5948		.UCODE
							; 5949	
							; 5950	1467:
U 1467, 2100,3771,0005,4365,5007,0700,0200,0000,0002	; 5951	EXTEND:	MEM READ, [BR]_MEM	;FETCH INSTRUCTION
							; 5952	=0**	TL [BR], #/760740,	;IN RANGE 0-17 (AND AC#=0)
U 2100, 3556,4553,0500,4374,4007,0321,0010,0076,0740	; 5953		CALL [BITCHK]		;TRAP IF NON-ZERO BITS FOUND
							; 5954		[BRX]_[HR].AND.# CLR RH, ;SPLIT OUT AC NUMBER
U 2104, 3317,4521,0206,4374,4007,0700,0000,0000,0740	; 5955		#/000740		; FROM EXTEND INSTRUCTION
							; 5956		[BR]_[BR].OR.[BRX],	;LOAD IR AND AC #
U 3317, 3320,3111,0605,4174,0417,0700,0000,0000,0000	; 5957		HOLD RIGHT, LOAD IR	; ..
							; 5958		READ [BR], LOAD BYTE EA,	;LOAD XR #
U 3320, 3321,3333,0005,4174,4217,0700,0000,0000,0500	; 5959		    J/EXTEA0			;COMPUTE E1
							; 5960	
U 3321, 3322,3333,0003,7174,4007,0700,0400,0000,0240	; 5961	EXTEA0:	WORK[E0]_[AR]
U 3322, 0170,4443,0000,2174,4006,6700,0000,0000,0000	; 5962	EXTEA1:	EA MODE DISP
							; 5963	=100*
U 0170, 0172,0551,0505,2270,4007,0700,0000,0000,0000	; 5964	EXTEA:	[BR]_[BR]+XR
							; 5965	EXTDSP:	[BR]_EA FROM [BR], LOAD VMA,
U 0172, 0556,5741,0505,4174,4003,7700,0200,0000,0010	; 5966		B DISP, J/EXTEXT
U 0174, 3323,0551,0505,2270,4007,0700,0200,0004,0512	; 5967		[BR]_[BR]+XR, START READ, PXCT EXTEND EA, LOAD VMA, J/EXTIND
U 0176, 3323,3443,0500,4174,4007,0700,0200,0004,0512	; 5968		VMA_[BR], START READ, PXCT EXTEND EA
							; 5969	
U 3323, 3322,3771,0005,4361,5217,0700,0200,0000,0502	; 5970	EXTIND:	MEM READ, [BR]_MEM, HOLD LEFT, LOAD BYTE EA, J/EXTEA1
							; 5971	
							; 5972	;HERE TO EXTEND SIGN FOR OFFSET MODES
							; 5973	=1110
							; 5974	EXTEXT:	WORK[E1]_[BR],			;SAVE E1
U 0556, 3400,3333,0005,7174,4001,2700,0400,0000,0241	; 5975		DISP/DROM, J/3400		;GO TO EXTENDED EXECUTE CODE
U 0557, 2076,3333,0005,4174,4007,0530,0000,0000,0000	; 5976		READ [BR], SKIP DP18		;NEED TO EXTEND SIGN
							; 5977	=0	WORK[E1]_[BR],			;POSITIVE
U 2076, 3400,3333,0005,7174,4001,2700,0400,0000,0241	; 5978		DISP/DROM, J/3400
							; 5979		[BR]_#, #/777777, HOLD RIGHT,	;NEGATIVE
U 2077, 0556,3771,0005,4374,0007,0700,0000,0077,7777	; 5980		J/EXTEXT
							; 5981	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 162
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- SETUP				

							; 5982	.TOC	"EXTEND -- MOVE STRING -- SETUP"
							; 5983	
							; 5984	;HERE TO MOVE A STRING
							; 5985	;COME HERE WITH:
							; 5986	;	AR/ E0
							; 5987	;	BR/ E1
							; 5988	;
							; 5989	3744:
							; 5990	MVS:	[AR]_[AR]+1,		;GO FETCH FILL
							; 5991		LOAD VMA,		; BYTE
							; 5992		START READ,		; ..
U 3744, 3516,0111,0703,4174,4007,0700,0210,0004,0012	; 5993		CALL [GTFILL]		;SUBROUTINE TO COMPLETE
U 3754, 2101,3771,0005,1276,6007,0701,0000,0000,1443	; 5994	3754:	[BR]_AC[DLEN]		;GET DEST LENGTH AND FLAGS
							; 5995	=0**	TL [BR], #/777000,	;ANY FLAGS SET?
U 2101, 3556,4553,0500,4374,4007,0321,0010,0077,7000	; 5996		CALL [BITCHK]		;SEE IF ILLEGAL
U 2105, 2102,3771,0003,0276,6007,0700,0000,0000,0000	; 5997		[AR]_AC			;GET SRC LENGTH AND FLAGS
							; 5998	=0	[BRX]_[AR].AND.# CLR RH, ;COPY FLAGS TO BRX
							; 5999		#/777000,		; ..
U 2102, 3520,4521,0306,4374,4007,0700,0010,0077,7000	; 6000		CALL [CLRFLG]		;CLEAR FLAGS IN AR
							; 6001					;NEW DLEN IS <SRC LEN>-<DST LEN>
							; 6002		AC[DLEN]_[AR]-[BR], 3T,	;COMPUTE DIFFERENCE
U 2103, 2106,2113,0305,1174,4007,0521,4400,0000,1443	; 6003		SKIP DP0		;WHICH IS SHORTER?
							; 6004	=0	[AR]_.NOT.[BR], 	;DESTINATION
U 2106, 3324,7441,0503,4174,4007,0700,0000,0000,0000	; 6005		J/MVS1			;GET NEGATIVE LENGTH
U 2107, 3324,7441,0303,4174,4007,0700,0000,0000,0000	; 6006		[AR]_.NOT.[AR]		;SOURCE
							; 6007	MVS1:	WORK[SLEN]_[AR],	; ..
U 3324, 0574,3333,0003,7174,4003,7700,0400,0000,0242	; 6008		B DISP			;SEE WHAT TYPE OF MOVE
							; 6009	;SLEN NOW HAS -<LEN OF SHORTER STRING>-1
							; 6010	=1100
U 0574, 0500,3771,0013,4370,4007,0700,0000,0000,0003	; 6011		STATE_[SRC], J/MOVELP	;TRANSLATE--ALL SET
U 0575, 3325,3771,0005,1276,6007,0701,0000,0000,1444	; 6012		[BR]_AC[DSTP], J/MVSO	;OFFSET BUILD MASK
							; 6013		[ARX]_[AR],		;LEFT JUSTIFY
U 0576, 3345,3441,0304,4174,4007,0700,0000,0000,0000	; 6014		J/MOVST0		; ..
							; 6015		[ARX]_AC[DLEN],		;RIGHT JUSTIFY
							; 6016		SKIP DP0, 4T,		;WHICH IS SHORTER?
U 0577, 0750,3771,0004,1276,6007,0522,0000,0000,1443	; 6017		J/MOVRJ
							; 6018	
U 3325, 3326,3333,0005,4174,4007,0700,1000,0041,6020	; 6019	MVSO:	READ [BR], FE_S+2	;GET DST BYTE SIZE
U 3326, 2110,4222,0000,4174,4006,7701,1000,0041,1770	; 6020		Q_0, BYTE STEP		;BUILD AN S BIT MASK
							; 6021	=0*
U 2110, 2110,4224,0003,4174,4026,7701,1000,0041,1770	; 6022	MVSO1:	GEN MSK [AR], BYTE STEP, J/MVSO1
U 2112, 3327,7221,0003,4174,4007,0700,0000,0000,0000	; 6023		[AR]_.NOT.Q		;BITS WHICH MUST NOT BE SET
							; 6024		WORK[MSK]_[AR].AND.[MASK], ;SAVE FOR SRCMOD
U 3327, 0507,4113,0312,7174,4007,0700,0400,0000,0243	; 6025		J/MOVLP0		;GO ENTER LOOP
							; 6026	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 163
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- OFFSET/TRANSLATE		

							; 6027	.TOC	"EXTEND -- MOVE STRING -- OFFSET/TRANSLATE"
							; 6028	
							; 6029	;HERE IS THE LOOP FOR OFFSET AND TRANSLATED MOVES
							; 6030	=000
							; 6031	MOVELP:	[AR]_WORK[SLEN]+1,	;UPDATE STRING LENGTH
U 0500, 1120,0551,0703,7274,4007,0701,0010,0000,0242	; 6032		CALL [SRCMOD]		;GET A SOURCE BYTE
							; 6033	=001	[ARX]_[AR], SKIP DP0,	;(1) LENGTH EXHAUSTED
U 0501, 1030,3441,0304,4174,4007,0520,0000,0000,0000	; 6034		J/MOVST2		;    SEE IF FILL IS NEEDED
							; 6035	=100	[AR]_-WORK[SLEN],	;(4) ABORT
U 0504, 3330,1771,0003,7274,4007,0701,4000,0000,0242	; 6036		J/MVABT			; ..
							; 6037		STATE_[SRC+DST],	;(5) NORMAL--STORE DST BYTE
U 0505, 3510,3771,0013,4370,4007,0700,0010,0000,0005	; 6038		CALL [PUTDST]		;     ..
							; 6039	=111
U 0507, 0500,3771,0013,4370,4007,0700,0000,0000,0003	; 6040	MOVLP0:	STATE_[SRC], J/MOVELP	;(7) DPB DONE
							; 6041	=
							; 6042	
							; 6043	;HERE TO ABORT A STRING MOVE DUE TO TRANSLATE OR OFFSET FAILURE
							; 6044	
							; 6045	MVABT:	[BR]_AC[DLEN], 		;WHICH STRING IS LONGER
U 3330, 2114,3771,0005,1276,6007,0522,0000,0000,1443	; 6046		SKIP DP0, 4T
							; 6047	=0
U 2114, 3331,3440,0303,1174,4007,0700,0400,0000,1443	; 6048	MVABT1:	AC[DLEN]_[AR], J/MVABT2	;PUT AWAY DEST LEN
							; 6049		[AR]_[AR]-[BR],		;DEST LEN WAS GREATER
U 2115, 2114,1111,0503,4174,4007,0700,4000,0000,0000	; 6050		J/MVABT1		;STICK BACK IN AC
							; 6051	
U 3331, 3332,7771,0003,7274,4007,0701,0000,0000,0242	; 6052	MVABT2:	[AR]_.NOT.WORK[SLEN]	;GET UNDECREMENTED SLEN
U 3332, 2116,3333,0005,4174,4007,0520,0000,0000,0000	; 6053		READ [BR], SKIP DP0	;NEED TO FIXUP SRC?
U 2116, 2117,0111,0503,4174,4007,0700,0000,0000,0000	; 6054	=0	[AR]_[AR]+[BR]		;SRC LONGER BY (DLEN)
U 2117, 3333,3111,0603,4174,4007,0700,0000,0000,0000	; 6055	MVEND:	[AR]_[AR].OR.[BRX]	;PUT BACK SRC FLAGS
U 3333, 1515,4221,0013,4170,4007,0700,0000,0000,0000	; 6056		END STATE, J/STAC	;ALL DONE
							; 6057	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 164
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- MOVSRJ				

							; 6058	.TOC	"EXTEND -- MOVE STRING -- MOVSRJ"
							; 6059	
							; 6060	=00
U 0750, 3334,3771,0003,1276,6007,0701,0000,0000,1441	; 6061	MOVRJ:	[AR]_AC[SRCP], J/MVSKP	;SRC LONGER, SKIP OVER SOME
							; 6062		STATE_[DSTF],		;DST LONGER, FILL IT
U 0751, 2307,3771,0013,4370,4007,0700,0010,0000,0006	; 6063		CALL [MOVFIL]		; ..
							; 6064	=11	[ARX]_WORK[SLEN]+1,	;DONE FILLING
U 0753, 3346,0551,0704,7274,4007,0701,0000,0000,0242	; 6065		J/MOVST1		;GO MOVE STRING
							; 6066	
							; 6067	;HERE TO SKIP OVER EXTRA SOURCE BYTES
U 3334, 2120,3440,0303,1174,4007,0670,0400,0000,1441	; 6068	MVSKP:	AC[SRCP]_[AR], SKIP -1MS ;[121] Is there a timer interrupt?
U 2120, 3337,3333,0003,7174,4007,0700,0400,0000,0211	; 6069	=0	WORK[SV.AR]_[AR], J/MVSK2 ;[121][123] Yes, save regs for interrupt.
							; 6070		[ARX]_[ARX]-1, 3T,	;DONE SKIPPING?
U 2121, 2122,1111,0704,4174,4007,0521,4000,0000,0000	; 6071		SKIP DP0
							; 6072	=0	IBP DP, IBP SCAD,	;NO--START THE IBP
							; 6073		SCAD DISP, SKIP IRPT,	;4-WAY DISPATCH
U 2122, 1020,3770,0305,4334,4016,7371,0000,0033,6000	; 6074		3T, J/MVSKP1		;GO BUMP POINTER
							; 6075		AC[DLEN]_0,		;LENGTHS ARE NOW EQUAL
U 2123, 0546,4223,0000,1174,4007,0700,0400,0000,1443	; 6076		J/MOVST4		;GO MOVE STRING
							; 6077	
							; 6078	=00
U 1020, 3334,3441,0503,4174,4007,0700,0000,0000,0000	; 6079	MVSKP1:	[AR]_[BR], J/MVSKP	;NO OVERFLOW
							; 6080		[AR]_.NOT.WORK[SLEN],	;INTERRUPT
U 1021, 3335,7771,0003,7274,4007,0701,0000,0000,0242	; 6081		J/MVSK3			; ..
							; 6082		SET P TO 36-S,		;WORD OVERFLOW
U 1022, 3336,3770,0503,4334,4017,0700,0000,0032,6000	; 6083		J/MVSKP2		;FIXUP Y
U 1023, 3335,7771,0003,7274,4007,0701,0000,0000,0242	; 6084		[AR]_.NOT.WORK[SLEN]	;[121] INTERRUPT or timer.
U 3335, 2124,3440,0303,1174,4007,0700,0400,0000,1443	; 6085	MVSK3:	AC[DLEN]_[AR]		;RESET DLEN
							; 6086	=0	[AR]_[AR]+[ARX],
U 2124, 3724,0111,0403,4174,4007,0700,0010,0000,0000	; 6087		CALL [INCAR]		;ADD 1 TO AR
							; 6088		AC_[AR].OR.[BRX],	;PUT BACK FLAGS
U 2125, 3767,3113,0306,0174,4007,0700,0400,0000,0000	; 6089		J/ITRAP			;DO INTERRUPT TRAP
							; 6090	
							; 6091	MVSKP2:	[AR]_[AR]+1, HOLD LEFT,	;BUMP Y
U 3336, 3334,0111,0703,4170,4007,0700,0000,0000,0000	; 6092		J/MVSKP		;KEEP GOING
							; 6093	
							; 6094					;BEGIN EDIT [123]
U 3337, 3340,3333,0005,7174,4007,0700,0400,0000,0213	; 6095	MVSK2:	WORK[SV.BR]_[BR]	;SAVE ALL
U 3340, 3341,3333,0004,7174,4007,0700,0400,0000,0212	; 6096		WORK[SV.ARX]_[ARX]	;THE REGISTERS
U 3341, 2111,3333,0006,7174,4007,0700,0400,0000,0214	; 6097		WORK[SV.BRX]_[BRX]	;FOR THE TICK
U 2111, 3620,4443,0000,4174,4007,0700,0010,0000,0000	; 6098	=0*	CALL [TICK]		;UPDATE CLOCK AND SET INTERUPT
U 2113, 3342,3771,0003,7274,4007,0701,0000,0000,0211	; 6099		[AR]_WORK[SV.AR]	;NOW PUT
U 3342, 3343,3771,0005,7274,4007,0701,0000,0000,0213	; 6100		[BR]_WORK[SV.BR]	;THEM ALL
U 3343, 3344,3771,0004,7274,4007,0701,0000,0000,0212	; 6101		[ARX]_WORK[SV.ARX]	;BACK SO WE
							; 6102		[BRX]_WORK[SV.BRX],	;CAN CONTINUE
U 3344, 3334,3771,0006,7274,4007,0701,0000,0000,0214	; 6103			J/MVSKP
							; 6104					;END EDIT [123]
							; 6105	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 165
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- SIMPLE MOVE LOOP		

							; 6106	.TOC	"EXTEND -- MOVE STRING -- SIMPLE MOVE LOOP"
							; 6107	
							; 6108	;HERE FOR NO-MODIFICATION STRING MOVES
U 3345, 3346,0111,0704,4174,4007,0700,0000,0000,0000	; 6109	MOVST0:	[ARX]_[ARX]+1		;CANT DO [ARX]_[AR]+1
U 3346, 0540,3771,0013,4370,4007,0700,0000,0000,0003	; 6110	MOVST1:	STATE_[SRC]		;PREPARE FOR PAGE FAIL
							; 6111	=000
							; 6112		WORK[SLEN]_[ARX],	;GO GET A SOURCE BYTE
U 0540, 2320,3333,0004,7174,4007,0520,0410,0000,0242	; 6113		SKIP DP0, CALL [GSRC]	; ..
							; 6114	MOVSTX:	[ARX]_[AR],		;SHORT STRING RAN OUT
U 0541, 1030,3441,0304,4174,4007,0520,0000,0000,0000	; 6115		SKIP DP0, J/MOVST2	;GO SEE IF FILL NEEDED
							; 6116	=010	STATE_[SRC+DST],	;WILL NEED TO BACK UP BOTH POINTERS
U 0542, 3510,3771,0013,4370,4007,0700,0010,0000,0005	; 6117		CALL [PUTDST]		;STORE BYTE
							; 6118	=110
							; 6119	MOVST4:	[ARX]_WORK[SLEN]+1,	;COUNT DOWN LENGTH
U 0546, 3346,0551,0704,7274,4007,0701,0000,0000,0242	; 6120		J/MOVST1		;LOOP OVER STRING
							; 6121	=
							; 6122	=00
U 1030, 3347,4223,0000,1174,4007,0700,0400,0000,1443	; 6123	MOVST2:	AC[DLEN]_0, J/MOVST3	;CLEAR DEST LEN, REBUILD SRC
U 1031, 2307,3771,0013,4370,4007,0700,0010,0000,0004	; 6124		STATE_[DST], CALL [MOVFIL] ;FILL OUT DEST
U 1033, 2167,3440,0606,0174,4007,0700,0400,0000,0000	; 6125	=11	AC_[BRX], J/ENDSKP	;ALL DONE
							; 6126	
U 3347, 3350,3113,0406,0174,4007,0700,0400,0000,0000	; 6127	MOVST3:	AC_[ARX].OR.[BRX]	;REBUILD SRC
U 3350, 0252,4221,0013,4170,4007,0700,0000,0000,0000	; 6128		END STATE, J/SKIPE	; ..
							; 6129	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 166
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- COMPARE STRING				

							; 6130	.TOC	"EXTEND -- COMPARE STRING"
							; 6131	
							; 6132	3740:
U 3740, 2130,3771,0004,1276,6007,0701,0000,0000,1443	; 6133	CMS:	[ARX]_AC[DLEN]		;GET DEST LEN
U 2130, 3556,4553,0400,4374,4007,0321,0010,0077,7000	; 6134	=0**	TL [ARX], #/777000, CALL [BITCHK]
U 2134, 2131,3771,0006,0276,6007,0700,0000,0000,0000	; 6135		[BRX]_AC		;GET SRC LEN
U 2131, 3556,4553,0600,4374,4007,0321,0010,0077,7000	; 6136	=0**	TL [BRX], #/777000, CALL [BITCHK]
U 2135, 2126,2113,0604,4174,4007,0521,4000,0000,0000	; 6137		[BRX]-[ARX], 3T, SKIP DP0 ;WHICH STRING IS LONGER?
U 2126, 2127,0111,0703,4174,4007,0700,0000,0000,0000	; 6138	=0	[AR]_[AR]+1		;SRC STRING IS LONGER
U 2127, 2132,0111,0703,4170,4007,0700,0200,0004,0012	; 6139		VMA_[AR]+1, START READ	;DST STRING
							; 6140	=0	[AR]_0,			;FORCE FIRST COMPARE TO BE
							; 6141					;EQUAL
U 2132, 3722,4221,0003,4174,4007,0700,0010,0000,0000	; 6142		CALL [LOADQ]		;PUT FILL INTO Q
							; 6143		WORK[FILL]_Q,		;SAVE FILLER
U 2133, 3360,3223,0000,7174,4007,0700,0400,0000,0244	; 6144		J/CMS2			;ENTER LOOP
							; 6145	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 167
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- COMPARE STRING				

							; 6146	;HERE IS THE COMPARE LOOP.
							; 6147	; ARX/ CONATINS REMAINING DEST LENGTH
							; 6148	; BRX/ CONTAINS REMAINING SOURCE LENGTH
							; 6149	=0
							; 6150	CMS3:				;BYTES ARE NOT EQUAL
							; 6151		END STATE,		;NO MORE SPECIAL PAGE FAIL ACTION
U 2136, 0250,4221,0013,4170,4003,7700,0000,0000,0000	; 6152		SKIP-COMP DISP		;SEE SKIP-COMP-TABLE
U 2137, 3351,3771,0003,1276,6007,0701,0000,0000,1441	; 6153	CMS4:	[AR]_AC[SRCP]		;GET BYTE POINTER
U 3351, 1050,3333,0006,4174,4007,0520,0000,0000,0000	; 6154		READ [BRX], SKIP DP0	;MORE IN SOURCE STRING?
							; 6155	=00	STATE_[EDIT-SRC],	;PREPARE FOR PAGE FAIL
U 1050, 2321,3771,0013,4370,4007,0700,0010,0000,0011	; 6156		CALL [GETSRC]		; GO GET BYTE
							; 6157		READ [ARX], SKIP DP0,	;NO MORE SRC--SEE IF MORE DEST
U 1051, 2140,3333,0004,4174,4007,0520,0000,0000,0000	; 6158		J/CMS5			; ..
U 1052, 3352,3333,0003,7174,4007,0700,0400,0000,0245	; 6159		WORK[CMS]_[AR]		;SAVE SRC BYTE
							; 6160	=
U 3352, 3353,3440,0606,0174,4007,0700,0400,0000,0000	; 6161		AC_[BRX]		;PUT BACK SRC LEN
U 3353, 3354,3771,0013,4370,4007,0700,0000,0000,0010	; 6162		STATE_[COMP-DST]	;HAVE TO BACK UP IF DST FAILS
U 3354, 1074,3333,0004,4174,4007,0520,0000,0000,0000	; 6163		READ [ARX], SKIP DP0	;ANY MORE DEST?
							; 6164	=00
U 1074, 2142,4443,0000,4174,4007,0700,0010,0000,0000	; 6165	CMS6:	CALL [CMPDST]		;MORE DEST BYTES
							; 6166		[AR]_WORK[FILL],	;OUT OF DEST BYTES
U 1075, 3355,3771,0003,7274,4007,0701,0000,0000,0244	; 6167		J/CMS7			;GO DO COMPARE
U 1076, 3355,3440,0404,1174,4007,0700,0400,0000,1443	; 6168		AC[DLEN]_[ARX]		;GOT A BYTE, UPDATE LENGTH
							; 6169	=
							; 6170	CMS7:	[AR]_[AR].AND.[MASK],	;MAKE MAGNITUDES
U 3355, 3356,4111,1203,7174,4007,0700,0000,0000,0245	; 6171		WORK[CMS]		;WARM UP RAM
U 3356, 3357,4551,1205,7274,4007,0700,0000,0000,0245	; 6172		[BR]_[MASK].AND.WORK[CMS], 2T ;GET SRC MAGNITUDE
U 3357, 3360,2111,0503,4174,4007,0700,4000,0000,0000	; 6173		[AR]_[BR]-[AR] REV	;UNSIGNED COMPARE
U 3360, 3361,1111,0704,4174,4007,0700,4000,0000,0000	; 6174	CMS2:	[ARX]_[ARX]-1		;UPDATE LENGTHS
U 3361, 3362,1111,0706,4174,4007,0700,4000,0000,0000	; 6175		[BRX]_[BRX]-1		; ..
U 3362, 2136,3333,0003,4174,4007,0621,0000,0000,0000	; 6176		READ [AR], SKIP AD.EQ.0, J/CMS3 ;SEE IF EQUAL
							; 6177	
							; 6178	=0
U 2140, 3363,3772,0000,7274,4007,0701,0000,0000,0244	; 6179	CMS5:	Q_WORK[FILL], J/CMS8	;MORE DST--GET SRC FILL
U 2141, 2136,4221,0003,4174,4007,0700,0000,0000,0000	; 6180		[AR]_0, J/CMS3		;STRINGS ARE EQUAL
U 3363, 3364,3771,0013,4370,4007,0700,0000,0000,0012	; 6181	CMS8:	STATE_[EDIT-DST]	;JUST DST POINTER ON PAGE FAIL
U 3364, 1074,3223,0000,7174,4007,0700,0400,0000,0245	; 6182		WORK[CMS]_Q, J/CMS6	;MORE DST--SAVE SRC FILL
							; 6183	
							; 6184	=0
							; 6185	CMPDST:	[AR]_AC[DSTP],		;GET DEST POINTER
U 2142, 3511,3771,0003,1276,6007,0701,0010,0000,1444	; 6186		CALL [IDST]		;UPDATE IT
							; 6187		READ [AR],		;LOOK AT BYTE POINTER
							; 6188		FE_FE.AND.S#, S#/0770,	;MASK OUT BIT 6
U 2143, 0340,3333,0003,4174,4006,5701,1000,0051,0770	; 6189		BYTE DISP, J/LDB1	;GO LOAD BYTE
							; 6190	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 168
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6191	.TOC	"EXTEND -- DECIMAL TO BINARY CONVERSION"
							; 6192	
							; 6193	3742:
U 3742, 3365,4571,1203,4374,4007,0700,0000,0077,7777	; 6194	DBIN:	[AR]_[777777] XWD 0	;IF WE ARE IN OFFSET MODE
U 3365, 3366,3333,0003,7174,4007,0700,0400,0000,0243	; 6195		WORK[MSK]_[AR]		; ONLY ALLOW 18 BITS
							; 6196					;RANGE CHECKED (0-10) LATER
U 3366, 3367,3771,0003,0276,6007,0700,0000,0000,0000	; 6197		[AR]_AC			;GET SRC LENGTH
							; 6198		[BRX]_[AR].AND.# CLR RH, ;SPLIT OUT FLAGS
U 3367, 2144,4521,0306,4374,4007,0700,0000,0077,7000	; 6199		#/777000		; ..
							; 6200	=0*	[ARX]_AC[BIN1],		;GET LOW WORD
U 2144, 2240,3771,0004,1276,6007,0701,0010,0000,1444	; 6201		CALL [CLARX0]		;CLEAR BIT 0 OF ARX
U 2146, 2150,3440,0404,1174,4007,0700,0400,0000,1444	; 6202		AC[BIN1]_[ARX]		;STORE BACK
							; 6203	=0	READ [BRX], SKIP DP0,	;IS S ALREADY SET?
U 2150, 2174,3333,0006,4174,4007,0520,0010,0000,0000	; 6204		CALL [CLRBIN]		;GO CLEAR BIN IF NOT
							; 6205		[AR]_[AR].AND.#,	;CLEAR FLAGS FROM LENGTH
							; 6206		#/000777, HOLD RIGHT,	; ..
U 2151, 0616,4551,0303,4374,0003,7700,0000,0000,0777	; 6207		B DISP			;SEE IF OFFSET OR TRANSLATE
							; 6208	=1110
U 0616, 3370,3771,0013,4370,4007,0700,0000,0000,0007	; 6209	DBIN1:	STATE_[CVTDB], J/DBIN2	;TRANSLATE--LEAVE S ALONE
							; 6210		[BRX]_[BRX].OR.#,	;OFFSET--FORCE S TO 1
							; 6211		#/400000, HOLD RIGHT,
U 0617, 0616,3551,0606,4374,0007,0700,0000,0040,0000	; 6212		J/DBIN1
U 3370, 0460,7333,0003,7174,4007,0700,0400,0000,0242	; 6213	DBIN2:	WORK[SLEN]_.NOT.[AR]	;STORE -SLEN-1
							; 6214	
							; 6215	;HERE IS THE MAIN LOOP
							; 6216	=0*0
U 0460, 1120,0551,0703,7274,4007,0701,0010,0000,0242	; 6217	DBINLP:	[AR]_WORK[SLEN]+1, CALL [SRCMOD] ;(0) GET MODIFIED SRC BYTE
							; 6218		TL [BRX], #/100000,	;(1) DONE, IS M SET?
U 0461, 2162,4553,0600,4374,4007,0321,0000,0010,0000	; 6219		J/DBXIT
							; 6220		[AR]_.NOT.WORK[SLEN],	;(4) ABORT
U 0464, 3375,7771,0003,7274,4007,0701,0000,0000,0242	; 6221		J/DBABT			;	..
							; 6222		[AR]-#, #/10.,		;(5) NORMAL--SEE IF 0-9
U 0465, 2152,1553,0300,4374,4007,0532,4000,0000,0012	; 6223		4T, SKIP DP18		; ..
							; 6224	=0	[AR]_.NOT.WORK[SLEN],	;DIGIT TOO BIG
U 2152, 3375,7771,0003,7274,4007,0701,0000,0000,0242	; 6225		J/DBABT			;GO ABORT CVT
							; 6226	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 169
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6227	;HERE TO ADD IN A DIGIT
							; 6228		[BR]_AC[BIN0], 4T,	;GET HIGH BINARY
U 2153, 1114,3771,0005,1276,6007,0622,0000,0000,1443	; 6229		SKIP AD.EQ.0		;SEE IF SMALL
							; 6230	=00
							; 6231	DBSLO:	[ARX]_AC[BIN1],		;TOO BIG
U 1114, 0560,3771,0004,1276,6007,0701,0010,0000,1444	; 6232		CALL [DBSLOW]		;GO USE DOUBLE PRECISION PATHS
							; 6233		[BR]_AC[BIN1],		;GET LOW WORD
U 1115, 3371,3771,0005,1276,6007,0701,0000,0000,1444	; 6234		J/DBFAST		;MIGHT FIT IN 1 WORD
U 1116, 0460,4443,0000,4174,4007,0700,0000,0000,0000	; 6235		J/DBINLP		;RETURN FROM DBSLOW
							; 6236					;GO DO NEXT DIGIT
							; 6237	=
U 3371, 2154,4553,0500,4374,4007,0321,0000,0076,0000	; 6238	DBFAST:	TL [BR], #/760000	;WILL RESULT FIT IN 36 BITS?
U 2154, 1114,4443,0000,4174,4007,0700,0000,0000,0000	; 6239	=0	J/DBSLO			;MAY NOT FIT--USE DOUBLE WORD
U 2155, 3372,3775,0005,1276,6007,0701,0000,0000,1444	; 6240		[BR]_AC[BIN1]*2		;COMPUTE AC*2
U 3372, 2156,3445,0505,1174,4007,0700,0000,0000,1444	; 6241		[BR]_[BR]*2, AC[BIN1]	;COMPUTE AC*4
							; 6242	=0	[BR]_[BR]+AC[BIN1], 2T,	;COMPUTE AC*5
U 2156, 3725,0551,0505,1274,4007,0700,0010,0000,1444	; 6243		CALL [SBRL]		;COMPUTE AC*10
							; 6244		AC[BIN1]_[AR]+[BR], 3T,	;NEW BINARY RESULT
U 2157, 0460,0113,0305,1174,4007,0701,0400,0000,1444	; 6245		J/DBINLP		;DO NEXT DIGIT
							; 6246	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 170
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6247	;HERE IF NUMBER DOES NOT FIT IN ONE WORD
							; 6248	
							; 6249	=000
							; 6250	DBSLOW:	[BR]_AC[BIN0],		;FETCH HIGH WORD
U 0560, 0620,3771,0005,1276,6007,0701,0010,0000,1443	; 6251		CALL [MULBY4]		;MULTIPLY BY 4
							; 6252		[ARX]_[ARX]+AC[BIN1],	;COMPUTE VALUE * 5
							; 6253		SKIP CRY1, 4T,		;SEE IF OVERFLOW
U 0561, 2160,0551,0404,1274,4007,0562,0010,0000,1444	; 6254		CALL [ADDCRY]		;GO ADD CARRY
U 0565, 0600,0551,0505,1274,4007,0701,0000,0000,1443	; 6255	=101	[BR]_[BR]+AC[BIN0]	;ADD IN HIGH WORD
							; 6256	=
U 0600, 0621,4443,0000,4174,4007,0700,0010,0000,0000	; 6257	=000	CALL [DBLDBL]		;MAKE * 10
							; 6258		[ARX]_[ARX]+[AR], 3T,	;ADD IN NEW DIGIT
							; 6259		SKIP CRY1,		;SEE IF OVERFLOW
U 0601, 2160,0111,0304,4174,4007,0561,0010,0000,0000	; 6260		CALL [ADDCRY]		;ADD IN THE CARRY
U 0605, 3373,3440,0404,1174,4007,0700,0400,0000,1444	; 6261	=101	AC[BIN1]_[ARX]		;PUT BACK ANSWER
							; 6262	=
							; 6263		AC[BIN0]_[BR],		; ..
U 3373, 0002,3440,0505,1174,4004,1700,0400,0000,1443	; 6264		RETURN [2]		;GO DO NEXT BYTE
							; 6265	
							; 6266	;HERE TO DOUBLE BR!ARX
							; 6267	=000
U 0620, 0621,4443,0000,4174,4007,0700,0010,0000,0000	; 6268	MULBY4:	CALL [DBLDBL]		;DOUBLE TWICE
U 0621, 0622,0111,0505,4174,4007,0700,0000,0000,0000	; 6269	DBLDBL:	[BR]_[BR]+[BR]		;DOUBLE HIGH WORD FIRST
							; 6270					;(SO WE DON'T DOUBLE CARRY)
							; 6271		[ARX]_[ARX]+[ARX],	;DOUBLE LOW WORD
							; 6272		SKIP CRY1, 3T,		;SEE IF CARRY
U 0622, 2160,0111,0404,4174,4007,0561,0010,0000,0000	; 6273		CALL [ADDCRY]		;ADD IN CARRY
U 0626, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 6274	=110	RETURN [1]		;ALL DONE
							; 6275	=
							; 6276	
							; 6277	;HERE TO ADD THE CARRY
							; 6278	=0
U 2160, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 6279	ADDCRY:	RETURN [4]		;NO CARRY
U 2161, 3374,4551,0404,4374,0007,0700,0000,0037,7777	; 6280		CLEAR [ARX]0		;KEEP LOW WORD POSITIVE
							; 6281		[BR]_[BR]+1,		;ADD CARRY
U 3374, 0004,0111,0705,4174,4004,1700,0000,0000,0000	; 6282		RETURN [4]		;ALL DONE
							; 6283	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 171
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6284	;HERE TO ABORT CONVERSION
U 3375, 3376,3111,0306,4174,4007,0700,0000,0000,0000	; 6285	DBABT:	[BRX]_[BRX].OR.[AR]	;PUT BACK UNUSED LENGTH
							; 6286		[PC]_[PC]-1, HOLD LEFT,	;DO NOT SKIP
U 3376, 2163,1111,0701,4170,4007,0700,4000,0000,0000	; 6287		J/DBDONE		;GO FIX UP SIGN COPY
							; 6288	
							; 6289	;HERE AT END
							; 6290	=0
							; 6291	DBXIT:	[ARX]_AC[BIN1],		;GET LOW WORD
U 2162, 3401,3771,0004,1276,6007,0701,0000,0000,1444	; 6292		J/DBNEG			;GO NEGATE
U 2163, 3377,3771,0003,1276,6007,0701,0000,0000,1444	; 6293	DBDONE:	[AR]_AC[BIN1]		;FETCH LOW WORD
							; 6294		[BR]_AC[BIN0], 4T,	;GET HIGH WORD
U 3377, 2164,3771,0005,1276,6007,0522,0000,0000,1443	; 6295		SKIP DP0		;WHAT SIGN
U 2164, 3400,4551,0303,4374,0007,0700,0000,0037,7777	; 6296	=0	CLEAR [AR]0, J/DBDN1	;POSITIVE
U 2165, 3400,3551,0303,4374,0007,0700,0000,0040,0000	; 6297		[AR]_[AR].OR.#, #/400000, HOLD RIGHT
U 3400, 2166,3440,0303,1174,4007,0700,0400,0000,1444	; 6298	DBDN1:	AC[BIN1]_[AR]		;STORE AC BACK
							; 6299	=0	AC_[BRX] TEST,	;RETURN FLAGS
U 2166, 2174,3770,0606,0174,4007,0520,0410,0000,0000	; 6300		SKIP DP0, CALL [CLRBIN]	;CLEAR BIN IS S=0
U 2167, 0260,4221,0013,4170,4007,0700,0000,0000,0000	; 6301	ENDSKP:	END STATE, J/SKIP	;NO--ALL DONE
							; 6302	
U 3401, 3402,4551,0404,4374,0007,0700,0000,0037,7777	; 6303	DBNEG:	CLEAR ARX0		;CLEAR EXTRA SIGN BIT
							; 6304		[ARX]_-[ARX], 3T,	;NEGATE AND SEE IF
U 3402, 2170,2441,0404,1174,4007,0621,4000,0000,1443	; 6305		SKIP AD.EQ.0, AC[BIN0]	; ANY CARRY
U 2170, 2173,7771,0003,1274,4007,0700,0000,0000,1443	; 6306	=0	[AR]_.NOT.AC[BIN0], 2T, J/STAC34 ;NO CARRY
							; 6307		[AR]_-AC[BIN0], 3T,	;CARRY
U 2171, 2172,1771,0003,1274,4007,0621,4000,0000,1443	; 6308		SKIP AD.EQ.0		;SEE IF ALL ZERO
U 2172, 2173,4571,1204,4374,4007,0700,0000,0040,0000	; 6309	=0	[ARX]_[400000] XWD 0	;MAKE COPY OF SIGN
							; 6310					; UNLESS HIGH WORD IS ZERO
U 2173, 3403,3440,0303,1174,4007,0700,0400,0000,1443	; 6311	STAC34:	AC[BIN0]_[AR]		;PUT BACK ANSWER
U 3403, 2163,3440,0404,1174,4007,0700,0400,0000,1444	; 6312		AC[BIN1]_[ARX], J/DBDONE	; ..
							; 6313	
							; 6314	;HELPER SUBROUTINE TO CLEAR AC[BIN0] AND AC[BIN1] IF S=0
							; 6315	;CALL WITH:
							; 6316	;	READ [BRX], SKIP DP0, CALL [CLRBIN]
							; 6317	;RETURNS 1 ALWAYS
							; 6318	=0
U 2174, 3404,4223,0000,1174,4007,0700,0400,0000,1443	; 6319	CLRBIN:	AC[BIN0]_0, J/CLRB1
U 2175, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 6320		RETURN [1]
U 3404, 0001,4223,0000,1174,4004,1700,0400,0000,1444	; 6321	CLRB1:	AC[BIN1]_0, RETURN [1]
							; 6322	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 172
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6323	.TOC	"EXTEND -- BINARY TO DECIMAL CONVERSION"
							; 6324	
							; 6325	3743:
							; 6326	BDEC:	[BRX]_AC[DLEN],		;GET LENGTH AND FLAGS
U 3743, 2176,3771,0006,1276,6007,0351,0000,0000,1443	; 6327		SKIP FPD		;CONTINUE FROM INTERUPT?
							; 6328	=0	[BRX]_[BRX].AND.#,	;JUST KEEP THE FLAGS
							; 6329		#/777000,		; ..
U 2176, 3405,4551,0606,4374,4007,0700,0000,0077,7000	; 6330		J/BDEC0			;COMPUTE NEW FLAGS
U 2177, 3423,3771,0003,0276,6007,0700,0000,0000,0000	; 6331	DOCVT:	[AR]_AC, J/DOCVT1	;ALL SET PRIOR TO TRAP
U 3405, 3406,3771,0004,1276,6007,0701,0000,0000,1441	; 6332	BDEC0:	[ARX]_AC[1]		;GET LOW BINARY
U 3406, 2145,3771,0003,0276,6007,0700,2000,0071,0024	; 6333		[AR]_AC, SC_20.		;GET HIGH WORD, SET STEP COUNT
							; 6334	=0*	WORK[BDL]_[ARX],	;SAVE IN CASE OF ABORT
U 2145, 2240,3333,0004,7174,4007,0700,0410,0000,0250	; 6335		CALL [CLARX0]		;MAKE SURE BIT 0 IS OFF
							; 6336		WORK[BDH]_[AR],		;SAVE HIGH WORD AND
U 2147, 2200,3333,0003,7174,4007,0520,0400,0000,0247	; 6337		SKIP DP0		; TEST SIGN
							; 6338	=0
							; 6339	BDEC1:	[BRX]_0, HOLD LEFT,	;POSITIVE, CLEAR RH OF BRX
U 2200, 2210,4221,0006,4170,4007,0700,0000,0000,0000	; 6340		J/BDEC3			;COMPUTE # OF DIGITS REQUIRED
							; 6341		[BRX]_[BRX].OR.#, 	;NEGATIVE, SET M
U 2201, 2204,3551,0606,4374,0007,0700,0000,0010,0000	; 6342		#/100000, HOLD RIGHT	; ..
							; 6343	=0*
U 2204, 3110,4551,0404,4374,0007,0700,0010,0037,7777	; 6344	BDEC2:	CLEAR ARX0, CALL [DBLNG1] ;NEGATE AR!ARX
							; 6345		AC_[AR] TEST,		;PUT BACK ANSWER
U 2206, 2202,3770,0303,0174,4007,0520,0400,0000,0000	; 6346		SKIP DP0		;IF STILL MINUS WE HAVE
							; 6347					; 1B0, AND NO OTHER BITS
U 2202, 2200,3440,0404,1174,4007,0700,0400,0000,1441	; 6348	=0	AC[1]_[ARX], J/BDEC1	;POSITIVE NOW
U 2203, 3407,0111,0704,4174,4007,0700,0000,0000,0000	; 6349		[ARX]_[ARX]+1		;JUST 1B0--ADD 1
							; 6350		[BRX]_[BRX].OR.#,	;AND REMEMBER THAT WE DID
							; 6351		#/040000, HOLD RIGHT,	; IN LEFT HALF OF AC+3
U 3407, 2204,3551,0606,4374,0007,0700,0000,0004,0000	; 6352		J/BDEC2			; NEGATE IT AGAIN
							; 6353	=0
U 2210, 0441,3771,0003,0276,6007,0700,0000,0000,0000	; 6354	BDEC3:	[AR]_AC, J/BDEC4	;GET HIGH AC
							; 6355		[BRX]_[BRX].OR.#,	;NO LARGER POWER OF 10 FITS
							; 6356		#/200000,		;SET N FLAG (CLEARLY NOT 0)
U 2211, 2214,3551,0606,4374,0007,0700,0000,0020,0000	; 6357		HOLD RIGHT, J/BDEC5	;SETUP TO FILL, ETC.
							; 6358	=001
							; 6359	BDEC4:	[ARX]_AC[1],		;GET HIGH WORD
U 0441, 2234,3771,0004,1276,6007,0701,0010,0000,1441	; 6360		CALL [BDSUB]		;SEE IF 10**C(BRX) FITS
							; 6361	=011	[BRX]_[BRX]+1,	;NUMBER FITS--TRY A LARGER ONE
U 0443, 2210,0111,0706,4174,4007,0630,2000,0060,0000	; 6362		STEP SC, J/BDEC3	;UNLESS WE ARE OUT OF NUMBERS
U 0447, 2212,4553,0600,4374,4007,0331,0000,0077,7777	; 6363	=111	TR [BRX], #/777777	;ANY DIGITS REQUIRED?
							; 6364	=
							; 6365	=0	[BRX]_[BRX].OR.#,	;SOME DIGITS NEEDED,
							; 6366		#/200000, HOLD RIGHT,	; SET N FLAG
U 2212, 2214,3551,0606,4374,0007,0700,0000,0020,0000	; 6367		J/BDEC5			;CONTINUE BELOW
U 2213, 2214,0111,0706,4174,4007,0700,0000,0000,0000	; 6368		[BRX]_[BRX]+1		;ZERO--FORCE AT LEAST 1 DIGIT
							; 6369	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 173
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6370	=0
							; 6371	BDEC5:	[AR]_AC[DLEN],		;GET LENGTH
U 2214, 3520,3771,0003,1276,6007,0701,0010,0000,1443	; 6372		CALL [CLRFLG]		;REMOVE FLAGS FROM AR
U 2215, 3410,4221,0005,4174,4007,0700,0000,0000,0000	; 6373		[BR]_0
U 3410, 3411,3441,0605,4170,4007,0700,0000,0000,0000	; 6374		[BR]_[BRX], HOLD LEFT	;GET # OF DIGITS NEEDED
							; 6375		[BR]_[BR]-[AR],		;NUMBER OF FILLS NEEDED
U 3411, 2216,1111,0305,4174,4007,0421,4000,0000,0000	; 6376		SKIP AD.LE.0		;SEE IF ENOUGH ROOM
							; 6377	=0	[ARX]_WORK[BDL],	;DOES NOT FIT IN SPACE ALLOWED
U 2216, 3433,3771,0004,7274,4007,0701,0000,0000,0250	; 6378		J/BDABT			; DO NOT DO CONVERT
U 2217, 2220,3333,0006,4174,4007,0520,0000,0000,0000	; 6379		READ [BRX], SKIP DP0	;IS L ALREADY SET
							; 6380	=0	AC[DLEN]_[BRX],		;NO--NO FILLERS
U 2220, 2177,3440,0606,1174,4007,0700,0400,0000,1443	; 6381		J/DOCVT			;GO CHURN OUT THE NUMBER
							; 6382	
							; 6383	
							; 6384	;HERE TO STORE LEADING FILLERS
U 2221, 3412,3441,0603,4174,0007,0700,0000,0000,0000	; 6385		[AR]_[BRX], HOLD RIGHT	;MAKE SURE THE FLAGS GET SET
U 3412, 3413,3440,0303,1174,4007,0700,0400,0000,1443	; 6386		AC[DLEN]_[AR]		; BEFORE WE PAGE FAIL
U 3413, 3414,3771,0003,7274,4007,0701,0000,0000,0240	; 6387		[AR]_WORK[E0]		;ADDRESS OF FILL (-1)
							; 6388		[AR]_[AR]+1, LOAD VMA,	;FETCH FILLER
U 3414, 3415,0111,0703,4174,4007,0700,0200,0004,0012	; 6389		START READ
U 3415, 3416,3771,0016,4365,5007,0700,0200,0000,0002	; 6390		MEM READ, [T0]_MEM	;GET FILLER INTO AR
U 3416, 3417,3771,0013,4370,4007,0700,0000,0000,0012	; 6391		STATE_[EDIT-DST]	;PAGE FAILS BACKUP DST
U 3417, 3420,2113,0507,7174,4007,0701,4400,0000,0242	; 6392		WORK[SLEN]_[BR]-1, 3T	;SAVE # OF FILLERS
U 3420, 3421,3441,1603,7174,4007,0700,0000,0000,0242	; 6393	BDFILL:	[AR]_[T0], WORK[SLEN]	;RESTORE FILL BYTE AND
							; 6394					; WARM UP RAM FILE
							; 6395		[BR]_WORK[SLEN]+1, 3T,	;MORE FILLERS NEEDED?
U 3421, 0640,0551,0705,7274,4007,0521,0000,0000,0242	; 6396		SKIP DP0
U 0640, 2177,3440,0606,1174,4007,0700,0400,0000,1443	; 6397	=000	AC[DLEN]_[BRX], J/DOCVT	;ALL DONE FIX FLAGS AND CONVERT
							; 6398	=001	WORK[SLEN]_[BR],	;SAVE UPDATED LENGTH
U 0641, 3510,3333,0005,7174,4007,0700,0410,0000,0242	; 6399		CALL [PUTDST]		; AND STORE FILLER
U 0647, 3422,2551,0705,1274,4007,0701,4000,0000,1443	; 6400	=111	[BR]_AC[DLEN]-1		;COUNT DOWN STRING LENGTH
							; 6401	=
U 3422, 3420,3440,0505,1174,4007,0700,0400,0000,1443	; 6402		AC[DLEN]_[BR], J/BDFILL	;KEEP FILLING
							; 6403	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 174
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6404	;HERE TO STORE THE ANSWER
							; 6405	
							; 6406	DOCVT1:	[ARX]_AC[1],		;GET LOW WORD
U 3423, 3432,3771,0004,1276,6007,0701,0000,0000,1441	; 6407		J/DOCVT2		;ENTER LOOP FROM BOTTOM
							; 6408	=010
							; 6409	BDECLP:	[BR]_[BR]+1,		;COUNT DIGITS
U 0562, 2234,0111,0705,4174,4007,0700,0010,0000,0000	; 6410		CALL [BDSUB]		;KEEP SUBTRACTING 10**C(BRX)
U 0566, 3424,3333,0003,7174,4007,0700,0400,0000,0247	; 6411	=110	WORK[BDH]_[AR]		;SAVE BINARY
							; 6412	=
							; 6413		[AR]_[BR]+WORK[E1],	;OFFSET DIGIT
U 3424, 0636,0551,0503,7274,4003,7701,0000,0000,0241	; 6414		B DISP			;SEE WHICH MODE
							; 6415	=1110	READ [AR], LOAD VMA,	;TRANSLATE, START READING TABLE
U 0636, 2226,3333,0003,4174,4007,0700,0200,0004,0012	; 6416		START READ, J/BDTBL	; GO GET ENTRY FROM TABLE
U 0637, 0510,3333,0004,7174,4007,0700,0400,0000,0250	; 6417	BDSET:	WORK[BDL]_[ARX]		;SAVE LOW BINARY
U 0510, 3510,3771,0013,4370,4007,0700,0010,0000,0012	; 6418	=00*	STATE_[EDIT-DST], CALL [PUTDST]
U 0516, 3425,2551,0705,1274,4007,0701,4000,0000,1443	; 6419	=11*	[BR]_AC[DLEN]-1		;UPDATE STRING LENGTH
U 3425, 3426,3771,0003,7274,4007,0701,0000,0000,0247	; 6420		[AR]_WORK[BDH]
U 3426, 3427,3771,0004,7274,4007,0701,0000,0000,0250	; 6421		[ARX]_WORK[BDL]
U 3427, 2222,4553,0500,4374,4007,0321,0000,0004,0000	; 6422		TL [BR], #/040000	;ARE WE CONVERTING 1B0?
U 2222, 3434,0111,0704,4174,4007,0700,0000,0000,0000	; 6423	=0	[ARX]_[ARX]+1, J/BDCFLG	;YES--FIX THE NUMBER AND CLEAR FLAG
U 2223, 3430,3440,0303,0174,4007,0700,0400,0000,0000	; 6424	DOCVT3:	AC_[AR]
U 3430, 3431,3440,0404,1174,4007,0700,0400,0000,1441	; 6425		AC[1]_[ARX]
U 3431, 3432,3440,0505,1174,4007,0700,0400,0000,1443	; 6426		AC[DLEN]_[BR]		;STORE BACK NEW STRING LENGTH
U 3432, 2224,1111,0706,4174,4007,0531,4000,0000,0000	; 6427	DOCVT2:	[BRX]_[BRX]-1, 3T, SKIP DP18
U 2224, 0562,2441,0705,4174,4467,0701,4000,0003,0000	; 6428	=0	[BR]_-1, SET FPD, 3T, J/BDECLP
U 2225, 0260,4221,0013,4170,4467,0700,0000,0005,0000	; 6429		END STATE, CLR FPD, J/SKIP
							; 6430	
							; 6431	;HERE TO TRANSLATE 1 DIGIT
							; 6432	=0
							; 6433	BDTBL:	END STATE,		;DON'T CHANGE BYTE POINTER IF
							; 6434					; THIS PAGE FAILS
U 2226, 3720,4221,0013,4170,4007,0700,0010,0000,0000	; 6435		CALL [LOADAR]		;GO PUT WORD IN AR
U 2227, 2230,4553,0600,4374,4007,0331,0000,0077,7777	; 6436		TR [BRX], #/777777	;LAST DIGIT
U 2230, 0637,4221,0003,4174,0007,0700,0000,0000,0000	; 6437	=0	[AR]_0, HOLD RIGHT, J/BDSET
U 2231, 2232,4553,0600,4374,4007,0321,0000,0010,0000	; 6438		TL [BRX], #/100000	;AND NEGATIVE
U 2232, 2233,3770,0303,4344,4007,0700,0000,0000,0000	; 6439	=0	[AR]_[AR] SWAP		;LAST AND MINUS, USE LH
U 2233, 0637,4221,0003,4174,0007,0700,0000,0000,0000	; 6440		[AR]_0, HOLD RIGHT, J/BDSET
							; 6441	
U 3433, 1505,3771,0003,7274,4007,0701,0000,0000,0247	; 6442	BDABT:	[AR]_WORK[BDH], J/DAC
							; 6443	
							; 6444	BDCFLG:	[BR]_[BR].AND.NOT.#, 	;CLEAR FLAG THAT TELLS US
							; 6445		#/040000, HOLD RIGHT,	; TO SUBTRACT 1 AND
U 3434, 2223,5551,0505,4374,0007,0700,0000,0004,0000	; 6446		J/DOCVT3		; CONTINUE CONVERTING
							; 6447	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 175
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6448	;SUBROUTINE TO SUBRTACT A POWER OF 10 FROM AR!ARX
							; 6449	;CALL WITH:
							; 6450	;	AR!ARX/	NUMBER TO BE CONVERTED
							; 6451	;	BRX(RIGHT)/ POWER OF 10
							; 6452	;RETURNS:
							; 6453	;	2 RESULT IS STILL POSITIVE
							; 6454	;	6 RESULT WOULD HAVE BEEN NEGATIVE (RESTORE DONE)
							; 6455	=0
							; 6456	BDSUB:	[T0]_[BRX]+#, 3T, WORK/DECLO, ;ADDRESS OF LOW WORD
U 2234, 2205,0551,0616,4374,4007,0701,0000,0000,0344	; 6457		J/BDSUB1		;NO INTERRUPT
U 2235, 2717,4443,0000,4174,4007,0700,0000,0000,0000	; 6458		J/FIXPC			;INTERRUPT
							; 6459	=0*
							; 6460	BDSUB1:	[T1]_[T0], LOAD VMA,	;PUT IN VMA,
U 2205, 2240,3441,1617,4174,4007,0700,0210,0000,0010	; 6461		CALL [CLARX0]		;FIX UP SIGN OF LOW WORD
							; 6462		[ARX]_[ARX]-RAM, 3T,	;SUBTRACT
U 2207, 2236,1551,0404,6274,4007,0561,4000,0000,0000	; 6463		SKIP CRY1		;SEE IF OVERFLOW
U 2236, 2237,1111,0703,4174,4007,0700,4000,0000,0000	; 6464	=0	[AR]_[AR]-1		;PROCESS CARRY
U 2237, 3435,0551,0616,4374,4007,0701,0000,0000,0373	; 6465		[T0]_[BRX]+#, 3T, WORK/DECHI ;ADDRESS OF HIGH WORD
U 3435, 3436,3333,0016,4174,4007,0700,0200,0000,0010	; 6466		READ [T0], LOAD VMA	;PLACE IN VMA
							; 6467		[AR]_[AR]-RAM, 4T,	;SUBTRACT
U 3436, 2240,1551,0303,6274,4007,0522,4000,0000,0000	; 6468		SKIP DP0		;SEE IF IT FIT
							; 6469	=0
							; 6470	CLARX0:	CLEAR ARX0,		;IT FIT, KEEP LOW WORD +
U 2240, 0002,4551,0404,4374,0004,1700,0000,0037,7777	; 6471		RETURN [2]		; AND RETURN
U 2241, 3437,0551,0303,6274,4007,0700,0000,0000,0000	; 6472		[AR]_[AR]+RAM		;RESTORE
U 3437, 3440,3333,0017,4174,4007,0700,0200,0000,0010	; 6473		READ [T1], LOAD VMA
U 3440, 2242,0551,0404,6274,4007,0561,0000,0000,0000	; 6474		[ARX]_[ARX]+RAM, 3T, SKIP CRY1
							; 6475	=0
							; 6476	BDSUB2:	CLEAR ARX0,		;KEEP LOW WORD +
U 2242, 0006,4551,0404,4374,0004,1700,0000,0037,7777	; 6477		RETURN [6]		;RETURN OVERFLOW
							; 6478		[AR]_[AR]+1,		;ADD BACK THE CARRY
U 2243, 2242,0111,0703,4174,4007,0700,0000,0000,0000	; 6479		J/BDSUB2		;COMPLETE SUBTRACT
							; 6480	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 176
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- MAIN LOOP				

							; 6481	.TOC	"EXTEND -- EDIT -- MAIN LOOP"
							; 6482	
							; 6483	;HERE FOR EDIT INSTRUCTION
							; 6484	;CALL WITH:
							; 6485	;	AR/	E0	ADDRESS OF FILL, FLOAT, AND MESSAGE TABLE
							; 6486	;	BR/	E1	TRANSLATE TABLE
							; 6487	;
							; 6488	3741:
							; 6489	EDIT:	VMA_[AR]+1, START READ,	;FIRST GET FILL BYTE
U 3741, 3516,0111,0703,4170,4007,0700,0210,0004,0012	; 6490		CALL [GTFILL]		;GO GET IT
U 3751, 2250,3771,0006,0276,6007,0700,0000,0000,0000	; 6491	3751:	[BRX]_AC		;GET PATTERN POINTER
							; 6492	=0**	TL [BRX], #/047777,	;MAKE SURE SECTION 0
U 2250, 3556,4553,0600,4374,4007,0321,0010,0004,7777	; 6493		CALL [BITCHK]		; ..
U 2254, 3441,3443,0600,4174,4007,0700,0200,0004,0012	; 6494	EDITLP:	VMA_[BRX], START READ	;FETCH PATTERN WORD
U 3441, 3442,4221,0013,4170,4007,0700,0000,0000,0000	; 6495		END STATE		;NO SPECIAL PAGE FAIL ACTION
U 3442, 2244,3770,0605,4344,4007,0700,0000,0000,0000	; 6496		[BR]_[BRX] SWAP		;GET PBN IN BITS 20 & 21
							; 6497	=0	[BR]_[BR]*4,		; ..
U 2244, 3720,0115,0505,4174,4007,0700,0010,0000,0000	; 6498		CALL [LOADAR]		;GET PATTERN WORD
U 2245, 0654,3333,0005,4174,4003,1701,0000,0000,0000	; 6499		READ [BR], 3T, DISP/DP LEFT
							; 6500	=1100
U 0654, 2246,3770,0303,4344,4007,0700,2000,0071,0007	; 6501		[AR]_[AR] SWAP, SC_7, J/MOVPAT	;(0) BITS 0-8
U 0655, 2247,3770,0303,4344,4007,0700,0000,0000,0000	; 6502		[AR]_[AR] SWAP, J/MSKPAT	;(1) BITS 9-17
U 0656, 2246,3447,0303,4174,4007,0700,2000,0071,0006	; 6503		[AR]_[AR]*.5, SC_6, J/MOVPAT	;(2) BITS 18-27
U 0657, 3443,4551,0303,4374,4007,0700,0000,0000,0777	; 6504		[AR]_[AR].AND.#, #/777, J/EDISP	;(3) BITS 28-35
							; 6505	=0
U 2246, 2246,3447,0303,4174,4007,0630,2000,0060,0000	; 6506	MOVPAT:	[AR]_[AR]*.5, STEP SC, J/MOVPAT	;SHIFT OVER
U 2247, 3443,4551,0303,4374,4007,0700,0000,0000,0777	; 6507	MSKPAT:	[AR]_[AR].AND.#, #/777
							; 6508	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 177
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- MAIN LOOP				

							; 6509	;HERE WITH PATTERN BYTE RIGHT ADJUSTED IN AR
U 3443, 2252,3447,0305,4174,4007,0700,2000,0071,0002	; 6510	EDISP:	[BR]_[AR]*.5, SC_2	;SHIFT OVER
							; 6511	=0
U 2252, 2252,3447,0505,4174,4007,0630,2000,0060,0000	; 6512	EDISP1:	[BR]_[BR]*.5, STEP SC, J/EDISP1
U 2253, 0661,3333,0005,4174,4003,5701,0000,0000,0000	; 6513		READ [BR], 3T, DISP/DP	;LOOK AT HIGH 3 BITS
							; 6514	=0001				;(0) OPERATE GROUP
							; 6515		[AR]-#, #/5, 4T,	;	SEE IF 0-4
U 0661, 2256,1553,0300,4374,4007,0532,4000,0000,0005	; 6516		SKIP DP18, J/EDOPR
							; 6517					;(1) MESSAGE BYTE
							; 6518		READ [BRX], SKIP DP0,
U 0663, 2274,3333,0006,4174,4007,0520,0000,0000,0000	; 6519		J/EDMSG
							; 6520					;(2) UNDEFINED
U 0665, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6521		J/EDNOP
							; 6522					;(3) UNDEFINED
U 0667, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6523		J/EDNOP
							; 6524					;(4) UNDEFINED
U 0671, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6525		J/EDNOP
							; 6526					;(5) SKIP IF M SET
							; 6527		TL [BRX], #/100000,
U 0673, 2300,4553,0600,4374,4007,0321,0000,0010,0000	; 6528		J/EDSKP
							; 6529					;(6) SKIP IF N SET
							; 6530		TL [BRX], #/200000,
U 0675, 2300,4553,0600,4374,4007,0321,0000,0020,0000	; 6531		J/EDSKP
							; 6532					;(7) SKIP ALWAYS
U 0677, 2300,4443,0000,4174,4007,0700,0000,0000,0000	; 6533		J/EDSKP
							; 6534	
							; 6535	.TOC	"EXTEND -- EDIT -- DECODE OPERATE GROUP"
							; 6536	
							; 6537	;HERE FOR OPERATE GROUP. SKIP IF IN RANGE
							; 6538	=0
U 2256, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6539	EDOPR:	J/EDNOP			;OUT OF RANGE
U 2257, 0710,3333,0003,4174,4003,5701,0000,0000,0000	; 6540		READ [AR], 3T, DISP/DP	;DISPATCH ON TYPE
U 0710, 3444,0111,0701,4174,4007,0700,0000,0000,0000	; 6541	=1000	[PC]_[PC]+1, J/EDSTOP	;(0) STOP EDIT
							; 6542		STATE_[EDIT-SRC], 	;(1) SELECT SOURCE BYTE
U 0711, 2264,3771,0013,4370,4007,0700,0000,0000,0011	; 6543		J/EDSEL
							; 6544		READ [BRX], SKIP DP0,	;(2) START SIGNIFICANCE
U 0712, 0246,3333,0006,4174,4007,0520,0000,0000,0000	; 6545		J/EDSSIG
							; 6546		[BRX]_[BRX].AND.#,	;(3) FIELD SEPERATOR
							; 6547		#/77777, HOLD RIGHT,
U 0713, 3463,4551,0606,4374,0007,0700,0000,0007,7777	; 6548		J/EDNOP
U 0714, 0715,3771,0005,1276,6007,0701,0000,0000,1443	; 6549		[BR]_AC[MARK]		;(4) EXCHANGE MARK AND DEST
							; 6550		VMA_[BR], START READ,
U 0715, 2262,3443,0500,4174,4007,0700,0200,0004,0012	; 6551		J/EDEXMD
							; 6552	=
							; 6553	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 178
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- STOP EDIT				

							; 6554	.TOC	"EXTEND -- EDIT -- STOP EDIT"
							; 6555	
							; 6556	;HERE TO END AN EDIT OPERATION. PC IS SET TO SKIP IF NORMAL END
							; 6557	; OR NON-SKIP IF ABORT
							; 6558	EDSTOP:	[BR]_.NOT.[BRX],	;AD WILL NOT DO D.AND.NOT.A
U 3444, 3445,7441,0605,4174,4007,0700,1000,0071,0010	; 6559		FE_S#, S#/10		;PRESET FE
U 3445, 3446,3441,0603,4174,4007,0701,1000,0043,0000	; 6560		[AR]_[BRX], 3T, FE_FE+P	;MOVE POINTER, UPBATE PBN
							; 6561		[BR].AND.#, 3T,		;WAS OLD NUMBER 3?
U 3446, 2260,4553,0500,4374,4007,0321,0000,0003,0000	; 6562		#/030000, SKIP ADL.EQ.0	; ..
							; 6563	=0
U 2260, 1515,3770,0303,4334,4017,0700,0000,0041,0000	; 6564	EDSTP1:	[AR]_P, J/STAC		;NO--ALL DONE
							; 6565		[AR]_[AR]+1,		;YES--BUMP WORD #
							; 6566		FE_FE.AND.S#, S#/0700,	;KEEP ONLY FLAG BITS
U 2261, 2260,0111,0703,4174,4007,0700,1000,0051,0700	; 6567		J/EDSTP1		;GO STOP EDIT
							; 6568	
							; 6569	.TOC	"EXTEND -- EDIT -- START SIGNIFICANCE"
							; 6570	
							; 6571	;HERE WITH DST POINTER IN AR
							; 6572	=110
U 0246, 3452,4443,0000,4174,4007,0700,0010,0000,0000	; 6573	EDSSIG:	CALL [EDFLT]		;STORE FLT CHAR
U 0247, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6574		J/EDNOP			;DO NEXT PATTERN BYTE
							; 6575	
							; 6576	.TOC	"EXTEND -- EDIT -- EXCHANGE MARK AND DESTINATION"
							; 6577	
							; 6578	;HERE WITH ADDRESS OF MARK POINTER IN BR
							; 6579	=0
							; 6580	EDEXMD:	Q_AC[DSTP],		;GET DEST POINTER
U 2262, 3720,3772,0000,1275,5007,0701,0010,0000,1444	; 6581		CALL [LOADAR]		;GO PUT MARK IN AR
U 2263, 3447,4443,0000,4174,4007,0700,0200,0003,0002	; 6582		START WRITE		;START WRITE. SEPERATE STEP TO AVOID
							; 6583					; PROBLEM ON DPM5
U 3447, 3450,3223,0000,4174,4007,0701,0200,0000,0002	; 6584		MEM WRITE, MEM_Q	;PUT OLD DEST IN MARK
U 3450, 3463,3440,0303,1174,4007,0700,0400,0000,1444	; 6585		AC[DSTP]_[AR], J/EDNOP	;PUT BACK DEST POINTER
							; 6586	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 179
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- PROCESS SOURCE BYTE			

							; 6587	.TOC	"EXTEND -- EDIT -- PROCESS SOURCE BYTE"
							; 6588	
							; 6589	=0*
							; 6590	EDSEL:	[AR]_AC[SRCP],		;PICK UP SRC POINTER
U 2264, 2321,3771,0003,1276,6007,0701,0010,0000,1441	; 6591		CALL [GETSRC]		;GET SOURCE BYTE
U 2266, 0700,3447,0303,7174,4007,0700,0000,0000,0241	; 6592		[AR]_[AR]*.5, WORK[E1]	;PREPARE TO TRANSLATE
							; 6593	=000	[AR]_[AR]+WORK[E1],	;GO TRANSLATE BY HALFWORDS
U 0700, 3503,0551,0303,7274,4007,0700,0010,0000,0241	; 6594		2T, CALL [TRNAR]	; ..
							; 6595	=010
							; 6596	EDFILL:	READ [AR],		;(2) NO SIGNIFICANCE, GO FILL
							; 6597		SKIP AD.EQ.0,		;    SEE IF ANY FILLER
U 0702, 2270,3333,0003,4174,4007,0621,0000,0000,0000	; 6598		J/EDFIL1		;    GO TO IT
							; 6599		STATE_[EDIT-SRC],	;(3) SIG START, DO FLOAT CHAR
U 0703, 0606,3771,0013,4370,4007,0700,0000,0000,0011	; 6600		J/EDSFLT
U 0704, 3444,4443,0000,4174,4007,0700,0000,0000,0000	; 6601	=100	J/EDSTOP		;(4) ABORT
							; 6602	=101
							; 6603	EDSPUT:	STATE_[EDIT-S+D],	;(5) NORMAL, STORE AT DST
U 0705, 3510,3771,0013,4370,4007,0700,0010,0000,0013	; 6604		CALL [PUTDST]		;    ..
							; 6605	=111
U 0707, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6606		J/EDNOP			;(7) BYTE STORED
							; 6607	=
							; 6608	
							; 6609	;HERE TO COMPLETE STORING FILL
							; 6610	=0
U 2270, 0705,4443,0000,4174,4007,0700,0000,0000,0000	; 6611	EDFIL1:	J/EDSPUT		;STORE FILLER
U 2271, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6612		J/EDNOP			;NO FILLER TO STORE
							; 6613	
							; 6614	;HERE TO DO FLOAT BYTE
							; 6615	=110
							; 6616	EDSFLT:	WORK[FSIG]_[ARX],	;SAVE SIG CHAR
U 0606, 3452,3333,0004,7174,4007,0700,0410,0000,0246	; 6617		CALL [EDFLT]		;STORE FLOAT CHAR
U 0607, 3451,3771,0003,7274,4007,0701,0000,0000,0246	; 6618		[AR]_WORK[FSIG]		;RESTORE CHAR
							; 6619		[AR]_[AR].AND.# CLR LH,	;JUST KEEP THE BYTE IN CASE
							; 6620		#/77777,		; DEST BYTE .GT. 15 BITS
U 3451, 0705,4251,0303,4374,4007,0700,0000,0007,7777	; 6621		J/EDSPUT		;GO STORE CHAR WHICH STARTED THIS ALL
							; 6622	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 180
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- PROCESS SOURCE BYTE			

							; 6623	;SUBRUTINE TO PROCESS FLOAT CHAR
							; 6624	;CALL WITH:
							; 6625	;	AR/ POINTER TO STORE @ MARK
							; 6626	;RETURN 7 WITH FLOAT STORED
U 3452, 3453,3771,0005,1276,6007,0701,0000,0000,1443	; 6627	EDFLT:	[BR]_AC[MARK]		;ADDRESS OF MARK POINTER
U 3453, 3454,3443,0500,4174,4007,0700,0200,0003,0012	; 6628		VMA_[BR], START WRITE	;READY TO STORE
U 3454, 3455,3771,0005,1276,6007,0701,0000,0000,1444	; 6629		[BR]_AC[DSTP]		;GET DST POINTER
U 3455, 2272,3333,0005,4175,5007,0701,0200,0000,0002	; 6630		MEM WRITE, MEM_[BR]	;STORE POINTER
							; 6631	=0	[AR]_0 XWD [2],		;FETCH FLOAT CHAR
U 2272, 3457,4751,1203,4374,4007,0700,0010,0000,0002	; 6632		CALL [EDBYTE]		;GET TBL BYTE
							; 6633		MEM READ, [AR]_MEM,	;GET FLOAT CHAR
U 2273, 0740,3771,0003,4365,5007,0621,0200,0000,0002	; 6634		SKIP AD.EQ.0		;SEE IF NULL
							; 6635	=000
							; 6636		[FLG]_[FLG].OR.#,	;REMEMBER TO BACKUP DST POINTER
							; 6637		STATE/EDIT-DST,		; WILL ALSO BACKUP SRC IF CALLED
							; 6638		HOLD LEFT,		; FROM SELECT
U 0740, 3510,3551,1313,4370,4007,0700,0010,0000,0012	; 6639		CALL [PUTDST]		; STORE FLOAT
							; 6640	=001	[BRX]_[BRX].OR.#, #/400000,
U 0741, 3456,3551,0606,4374,0007,0700,0000,0040,0000	; 6641		HOLD RIGHT,  J/EDFLT1	;NULL
							; 6642	=110	[BRX]_[BRX].OR.#, #/400000,
U 0746, 3456,3551,0606,4374,0007,0700,0000,0040,0000	; 6643		HOLD RIGHT,  J/EDFLT1	;MARK STORED
							; 6644	=
							; 6645	EDFLT1:	AC_[BRX],		;SAVE FLAGS SO WE DON'T
							; 6646					;TRY TO DO THIS AGAIN IF
							; 6647					;NEXT STORE PAGE FAILS
U 3456, 0007,3440,0606,0174,4004,1700,0400,0000,0000	; 6648		RETURN [7]		;AND RETURN
							; 6649	
							; 6650	.TOC	"EXTEND -- EDIT -- MESSAGE BYTE"
							; 6651	
							; 6652	;HERE WITH SKIP ON S
							; 6653	=0
							; 6654	EDMSG:	[AR]_WORK[FILL],	;GET FILL BYTE
							; 6655		SKIP AD.EQ.0, 4T,	;SEE IF NULL
U 2274, 0760,3771,0003,7274,4007,0622,0000,0000,0244	; 6656		J/EDMSG1		;GO STORE
							; 6657		[AR]_[AR].AND.# CLR LH, ;GET OFFSET INTO TABLE
U 2275, 2276,4251,0303,4374,4007,0700,0000,0000,0077	; 6658		#/77
							; 6659	=0	[AR]_[AR]+1, WORK[E0],	;PLUS 1
U 2276, 3457,0111,0703,7174,4007,0700,0010,0000,0240	; 6660		CALL [EDBYTE]		;GET TBL BYTE
U 2277, 0760,3771,0003,4365,5007,0700,0200,0000,0002	; 6661		MEM READ, [AR]_MEM	;FROM MEMORY
							; 6662	=000
							; 6663	EDMSG1:	STATE_[EDIT-DST],	;WHAT TO DO ON PAGE FAILS
U 0760, 3510,3771,0013,4370,4007,0700,0010,0000,0012	; 6664		CALL [PUTDST]		;STORE MESSAGE BYTE
U 0761, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6665	=001	J/EDNOP			;NULL FILLER
U 0766, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6666	=110	J/EDNOP			;NEXT BYTE
							; 6667	=
							; 6668	
U 3457, 3460,0551,0303,7274,4007,0701,0000,0000,0240	; 6669	EDBYTE:	[AR]_[AR]+WORK[E0]	;GET OFFSET INTO TABLE
							; 6670		VMA_[AR], START READ,	;START MEMORY CYCLE
U 3460, 0001,3443,0300,4174,4004,1700,0200,0004,0012	; 6671		RETURN [1]		;RETURN TO CALLER
							; 6672	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 181
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- SKIP					

							; 6673	.TOC	"EXTEND -- EDIT -- SKIP"
							; 6674	
							; 6675	=0
							; 6676	;HERE TO SKIP ALWAYS
							; 6677	EDSKP:	[AR]_[AR].AND.#, #/77,	;JUST KEEP SKIP DISTANCE
U 2300, 3461,4551,0303,4374,4007,0700,0000,0000,0077	; 6678		J/EDSKP1		;CONTINUE BELOW
							; 6679	;HERE IF WE DO NOT WANT TO SKIP
U 2301, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6680		J/EDNOP
U 3461, 3462,0115,0703,4174,4007,0700,0000,0000,0000	; 6681	EDSKP1:	[AR]_([AR]+1)*2		;GIVE 1 EXTRA SKIP
							; 6682		READ [AR], SCAD/A*2,	;PUT THE ADJUSTMENT
							; 6683		SCADA/BYTE5, 3T, LOAD SC, ; THE SC
U 3462, 3464,3333,0003,4174,4007,0701,2000,0007,0000	; 6684		J/EDNOP1		;JOIN MAIN LOOP
							; 6685	
							; 6686	
							; 6687	.TOC	"EXTEND -- EDIT -- ADVANCE PATTERN POINTER"
							; 6688	
U 3463, 3464,4443,0000,4174,4007,0700,2000,0071,0000	; 6689	EDNOP:	SC_0			;NO SKIP
U 3464, 3465,3333,0006,4174,4007,0701,1000,0073,0000	; 6690	EDNOP1:	READ [BRX], 3T, FE_P	;PUT PBN IN FE
U 3465, 3466,4443,0000,4174,4007,0700,1000,0051,0030	; 6691		FE_FE.AND.S#, S#/30	;JUST BYTE #
U 3466, 3467,4443,0000,4174,4007,0700,1000,0040,0000	; 6692		FE_FE+SC		;ADD IN ANY SKIP DISTANCE
U 3467, 3470,4443,0000,4174,4007,0700,1000,0041,0010	; 6693		FE_FE+S#, S#/10		;BUMP PBN
							; 6694		[AR]_FE,		;GET NUMBER OF WORDS
U 3470, 3471,3777,0003,4334,4057,0700,2000,0041,0000	; 6695		LOAD SC			;PUT MSB WHERE IT CAN BE TESTED
							; 6696					; QUICKLY
							; 6697		[AR]_[AR].AND.# CLR LH,	;KEEP ONLY 1 COPY
U 3471, 2302,4251,0303,4374,4007,0630,0000,0000,0170	; 6698		#/170, SKIP/SC		; ..
							; 6699	=0
							; 6700	EDN1A:	[AR]_[AR]*.5, SC_0,
U 2302, 2304,3447,0303,4174,4007,0700,2000,0071,0000	; 6701		J/EDNOP2		;READY TO SHIFT OFF BYTE WITHIN
							; 6702					; WORD
							; 6703		[AR]_[AR].OR.#, #/200,	;GET THE SIGN BIT OF THE FE
							; 6704		HOLD LEFT,		; INTO THE AR. ONLY HAPPENS ON
U 2303, 2302,3551,0303,4370,4007,0700,0000,0000,0200	; 6705		J/EDN1A			; SKP 76 OR SKP 77
							; 6706	=0
U 2304, 2304,3447,0303,4174,4007,0630,2000,0060,0000	; 6707	EDNOP2:	[AR]_[AR]*.5, STEP SC, J/EDNOP2
							; 6708		[BRX]_[BRX]+[AR],	;UPDATE WORD ADDRESS
U 2305, 3472,0111,0306,4170,4007,0700,0000,0000,0000	; 6709		HOLD LEFT
U 3472, 3473,3770,0303,4334,4017,0700,0000,0041,0000	; 6710		[AR]_P			;PUT PBN BACK IN BRX
							; 6711		[BRX]_[BRX].AND.#,	;JUST KEEP FLAGS
							; 6712		#/700000,		; ..
U 3473, 3474,4551,0606,4374,0007,0700,0000,0070,0000	; 6713		HOLD RIGHT
							; 6714		[AR]_[AR].AND.#,	;JUST KEEP PBN
U 3474, 3475,4551,0303,4374,4007,0700,0000,0003,0000	; 6715		#/030000
							; 6716		[BRX]_[BRX].OR.[AR],	;FINAL ANSWER
U 3475, 3476,3111,0306,4174,0007,0700,0000,0000,0000	; 6717		HOLD RIGHT
U 3476, 2254,3440,0606,0174,4007,0700,0400,0000,0000	; 6718		AC_[BRX], J/EDITLP	;DO NEXT FUNCTION
							; 6719	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 182
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- FILL OUT DESTINATION		

							; 6720	.TOC	"EXTEND SUBROUTINES -- FILL OUT DESTINATION"
							; 6721	
							; 6722	;CALL WITH
							; 6723	;	AC[DLEN]/ NEGATIVE NUMBER OF BYTES LEFT IN DEST
							; 6724	;	FILL/  FILL BYTE
							; 6725	;	RETURN [2] WITH FILLERS STORED
							; 6726	;
							; 6727	;NOTE: THIS ROUTINE NEED NOT TEST FOR INTERRUPTS ON EACH BYTE
							; 6728	;	BECAUSE EVERY BYTE STORE DOES A MEMORY READ.
							; 6729	;
							; 6730	=01*
							; 6731	MOVF1:	[AR]_WORK[FILL], 2T,	;GET FILL BYTE
U 0332, 3510,3771,0003,7274,4007,0700,0010,0000,0244	; 6732		CALL [PUTDST]		;PLACE IN DEST
U 0336, 3477,3771,0003,1276,6007,0701,0000,0000,1443	; 6733		[AR]_AC[DLEN]		;AMOUNT LEFT
							; 6734		AC[DLEN]_[AR]+1, 3T,	;STORE UPDATED LEN
U 3477, 2306,0113,0703,1174,4007,0521,0400,0000,1443	; 6735		SKIP DP0		; AND SEE IF DONE
U 2306, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 6736	=0	RETURN [2]		;DONE
U 2307, 0332,4443,0000,7174,4007,0700,0000,0000,0244	; 6737	MOVFIL:	WORK[FILL], J/MOVF1	;DO ANOTHER BYTE
							; 6738					;ENTERING HERE SAVES 150NS
							; 6739					; PER BYTE BUT COSTS 300NS
							; 6740					; PER FIELD MOVED. I ASSUME (BUT DO
							; 6741					; NOT KNOW) THAT THIS SPEEDS
							; 6742					; THINGS UP.
							; 6743	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 183
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- GET MODIFIED SOURCE BYTE		

							; 6744	.TOC"EXTEND SUBROUTINES -- GET MODIFIED SOURCE BYTE"
							; 6745	
							; 6746	;CALL WITH:
							; 6747	;SLEN = MINUS LENGTH OF STRING
							; 6748	;MSK = MASK FOR BYTE SIZE (1 IF BIT MUST BE ZERO)
							; 6749	;E1 = EFFECTIVE ADDRESS OF OPERATION WORD (SIGN EXTENDED IF OFFSET)
							; 6750	;	[AR]_WORK[SLEN]+1, CALL [SRCMOD]
							; 6751	;RETURNS:
							; 6752	;	1 LENGTH EXHAUSTED
							; 6753	;	2 (EDIT ONLY) NO SIGNIFICANCE
							; 6754	;	3 (EDIT ONLY) SIGNIFICANCE START:
							; 6755	;	4 ABORT: OUT OF RANGE OR TRANSLATE FAILURE
							; 6756	;	5 NORMAL: BYTE IN AR
							; 6757	;
							; 6758	;DROM B SET AS FOLLOWS:
							; 6759	;	0 TRANSLATE
							; 6760	;	1 OFFSET
							; 6761	;	2 EDIT
							; 6762	;	4 CVTDBT
							; 6763	=00
							; 6764	SRCMOD:	WORK[SLEN]_[AR],	;PUT BACK SOURCE LENGTH
							; 6765		SKIP DP0,		;SEE IF DONE
U 1120, 2320,3333,0003,7174,4007,0520,0410,0000,0242	; 6766		CALL [GSRC]		;GET A SOURCE BYTE
U 1121, 0001,4221,0013,4170,4004,1700,0000,0000,0000	; 6767		END STATE, RETURN [1]	;DONE
U 1122, 0716,4443,0000,7174,4003,7700,0000,0000,0241	; 6768		WORK[E1], B DISP	;OFFSET OR TRANSLATE?
							; 6769	=
U 0716, 3502,3447,0303,4174,4007,0700,0000,0000,0000	; 6770	=1110	[AR]_[AR]*.5, J/XLATE	;TRANSLATE
U 0717, 3500,3770,0303,7174,0007,0700,0000,0000,0241	; 6771		FIX [AR] SIGN, WORK[E1]	;IF WE ARE PROCESSING FULL WORD
							; 6772					; BYTES, AND THEY ARE NEGATIVE,
							; 6773					; AND THE OFFSET IS POSITIVE THEN
							; 6774					; WE HAVE TO MAKE BITS -1 AND -2
							; 6775					; COPIES OF THE SIGN BIT.
U 3500, 3501,0551,0303,7274,4007,0700,0000,0000,0241	; 6776		[AR]_[AR]+WORK[E1], 2T	;OFFSET
							; 6777		[AR].AND.WORK[MSK],	;VALID BYTE?
							; 6778		SKIP AD.EQ.0, 4T,	;SKIP IF OK
U 3501, 0004,4553,0300,7274,4004,1622,0000,0000,0243	; 6779		RETURN [4]		;RETURN 4 IF BAD, 5 IF OK
							; 6780	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 184
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- TRANSLATE				

							; 6781	.TOC	"EXTEND SUBROUTINES -- TRANSLATE"
							; 6782	
							; 6783	;HERE WITH BYTE IN AR 1-36. FETCH TABLE ENTRY.
U 3502, 3503,0551,0303,7274,4007,0701,0000,0000,0241	; 6784	XLATE:	[AR]_[AR]+WORK[E1]	;COMPUTE ADDRESS
							; 6785	TRNAR:	READ [AR], LOAD VMA,	;FETCH WORD
U 3503, 2310,3333,0003,4174,4007,0700,0200,0004,0012	; 6786		START READ		; ..
							; 6787	=0	[AR]_[AR]*2,		;GET BACK LSB
							; 6788					;BIT 36 IS NOT PRESERVED 
							; 6789					; BY PAGE FAILS
U 2310, 3721,3445,0303,4174,4007,0700,0010,0000,0000	; 6790		CALL [LOADARX]		;PUT ENTRY IN ARX
U 2311, 2312,4553,0300,4374,4007,0331,0000,0000,0001	; 6791		TR [AR], #/1		;WHICH HALF?
							; 6792	=0
							; 6793	XLATE1:	[AR]_[ARX], 3T, 	;RH -- COPY TO AR
							; 6794		DISP/DP LEFT,		;DISPATCH ON CODE
U 2312, 0721,3441,0403,4174,4003,1701,0000,0000,0000	; 6795		J/TRNFNC		;DISPATCH TABLE
							; 6796		[ARX]_[ARX] SWAP,	;LH -- FLIP AROUND
U 2313, 2312,3770,0404,4344,4007,0700,0000,0000,0000	; 6797		J/XLATE1		;START SHIFT
							; 6798	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 185
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- TRANSLATE				

							; 6799	;HERE ON TRANSLATE OPERATION TO PERFORM FUNCTIONS REQUIRED BY
							; 6800	; THE 3 HIGH ORDER BITS OF THE TRANSLATE FUNCTION HALFWORD. WE
							; 6801	; DISPATCH ON FUNCTION AND HAVE:
							; 6802	;	BRX/	FLAGS
							; 6803	;	ARX/	TABLE ENTRY IN RH
							; 6804	;
							; 6805	=0001
							; 6806					;(0) NOP
							; 6807	TRNFNC:	READ [BRX], SKIP DP0,	;S FLAG ALREADY SET?
U 0721, 2314,3333,0006,4174,4007,0520,0000,0000,0000	; 6808		J/TRNRET		; ..
							; 6809					;(1) ABORT
U 0723, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 6810		RETURN [4]
							; 6811					;(2) CLEAR M FLAG
							; 6812		[BRX]_[BRX].AND.NOT.#,
							; 6813		#/100000, HOLD RIGHT,	
U 0725, 0721,5551,0606,4374,0007,0700,0000,0010,0000	; 6814		J/TRNFNC
							; 6815					;(3) SET M FLAG
							; 6816		[BRX]_[BRX].OR.#,
							; 6817		#/100000, HOLD RIGHT,
U 0727, 0721,3551,0606,4374,0007,0700,0000,0010,0000	; 6818		J/TRNFNC
							; 6819					;(4) SET N FLAG
							; 6820	TRNSIG:	[BRX]_[BRX].OR.#,
							; 6821		#/200000, HOLD RIGHT,
U 0731, 0721,3551,0606,4374,0007,0700,0000,0020,0000	; 6822		J/TRNFNC
							; 6823					;(5) SET N FLAG THEN ABORT
							; 6824		[BRX]_[BRX].OR.#,
							; 6825		#/200000, HOLD RIGHT,
U 0733, 0004,3551,0606,4374,0004,1700,0000,0020,0000	; 6826		RETURN [4]
							; 6827					;(6) CLEAR M THEN SET N
							; 6828		[BRX]_[BRX].AND.NOT.#,
							; 6829		#/100000, HOLD RIGHT,
U 0735, 0731,5551,0606,4374,0007,0700,0000,0010,0000	; 6830		J/TRNSIG
							; 6831					;(7) SET N AND M
							; 6832		[BRX]_[BRX].OR.#,	
							; 6833		#/300000, HOLD RIGHT,
U 0737, 0721,3551,0606,4374,0007,0700,0000,0030,0000	; 6834		J/TRNFNC
							; 6835	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 186
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- TRANSLATE				

							; 6836	;HERE TO COMPLETE A TRANSLATE
							; 6837	
							; 6838	=0
							; 6839	TRNRET:	READ [ARX], SKIP DP18,	;S-FLAG IS ZERO
							; 6840		B DISP, SKIP DP18,	;SEE IF EDIT OR SIG START
U 2314, 0754,3333,0004,4174,4003,7530,0000,0000,0000	; 6841		J/TRNSS			; ..
							; 6842	TRNSS1:	[AR]_[ARX].AND.# CLR LH, ;S IS SET, JUST RETURN BYTE
U 2315, 0005,4251,0403,4374,4004,1700,0000,0007,7777	; 6843		#/77777, RETURN [5]	; ..
							; 6844	
							; 6845	=1100
							; 6846	TRNSS:	[AR]_AC[DLEN],		;NO SIG ON MOVE OR D2B
U 0754, 0533,3771,0003,1276,6003,7701,0000,0000,1443	; 6847		B DISP, J/TRNNS1	;SEE IF D2B
							; 6848		[BRX]_[BRX].OR.#,	;SIG START ON MOVE OR D2B
							; 6849		#/400000, HOLD RIGHT,
U 0755, 2315,3551,0606,4374,0007,0700,0000,0040,0000	; 6850		J/TRNSS1		;RETURN BYTE
							; 6851		[AR]_WORK[FILL],	;EDIT--NO SIG RETURN FILL
U 0756, 0002,3771,0003,7274,4004,1701,0000,0000,0244	; 6852		RETURN [2]		; ..
							; 6853		[AR]_AC[DSTP],		;EDIT--START OF SIG
U 0757, 0003,3771,0003,1276,6004,1701,0000,0000,1444	; 6854		RETURN [3]		; ..
							; 6855	
							; 6856	=1011
U 0533, 3504,1111,0703,4174,4007,0700,4000,0000,0000	; 6857	TRNNS1:	[AR]_[AR]-1, J/TRNNS2	;COMPENSATE FOR IGNORING SRC
							; 6858		[AR]_WORK[SLEN]+1,	;DEC TO BIN HAS NO DEST LENGTH
U 0537, 1120,0551,0703,7274,4007,0701,0000,0000,0242	; 6859		J/SRCMOD		;JUST UPDATE SRC LENTH
							; 6860	TRNNS2:	AC[DLEN]_[AR] TEST,	;PUT BACK DLEN AND
U 3504, 2316,3770,0303,1174,4007,0520,0400,0000,1443	; 6861		SKIP DP0		; SEE WHICH IS NOW SHORTER
							; 6862	=0	[AR]_WORK[SLEN],	;DEST IS SHORTER. DO NOT CHANGE
U 2316, 1120,3771,0003,7274,4007,0701,0000,0000,0242	; 6863		J/SRCMOD		; AMOUNT LEFT
							; 6864		[AR]_WORK[SLEN]+1,	;GO LOOK AT NEXT BYTE
U 2317, 1120,0551,0703,7274,4007,0701,0000,0000,0242	; 6865		J/SRCMOD
							; 6866	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 187
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- GET UNMODIFIED SOURCE BYTE	

							; 6867	.TOC	"EXTEND SUBROUTINES -- GET UNMODIFIED SOURCE BYTE"
							; 6868	
							; 6869	;CALL:
							; 6870	;	GSRC WITH SKIP ON SOURCE LENGTH
							; 6871	;	GETSRC IF LENGHT IS OK
							; 6872	;WITH:
							; 6873	;	AC1/ SOURCE BYTE POINTER
							; 6874	;RETURNS:
							; 6875	;	1 IF LENGTH RAN OUT
							; 6876	;	2 IF OK (BYTE IN AR)
							; 6877	;
							; 6878	=0
							; 6879	GSRC:	[AR]_AC[DLEN],		;LENGTH RAN OUT
U 2320, 0001,3771,0003,1276,6004,1701,0000,0000,1443	; 6880		RETURN [1]		;RESTORE AR AND RETURN
U 2321, 3505,3771,0003,1276,6007,0701,0000,0000,1441	; 6881	GETSRC:	[AR]_AC[SRCP]		;GET SRC PTR
							; 6882		IBP DP,	IBP SCAD,	;UPDATE BYTE POINTER
U 3505, 0231,3770,0305,4334,4016,7701,0000,0033,6000	; 6883		SCAD DISP, 3T		;SEE IF OFLOW
U 0231, 3507,3441,0503,4174,4007,0700,0000,0000,0000	; 6884	=01	[AR]_[BR], J/GSRC1	;NO OFLOW
U 0233, 3506,3770,0503,4334,4017,0700,0000,0032,6000	; 6885		SET P TO 36-S		;RESET P
U 3506, 3507,0111,0703,4170,4007,0700,0000,0000,0000	; 6886		[AR]_[AR]+1, HOLD LEFT	;BUMP Y
							; 6887	
U 3507, 2322,3440,0303,1174,4007,0700,0400,0000,1441	; 6888	GSRC1:	AC[SRCP]_[AR]		;STORE UPDATED POINTER
							; 6889	=0	READ [AR], LOAD BYTE EA,;SETUP TO FIGURE OUT
U 2322, 3115,3333,0003,4174,4217,0701,1010,0073,0500	; 6890		FE_P, 3T, CALL [BYTEAS]	; EFFECTIVE ADDRESS
							; 6891		READ [AR],		;LOOK AT POINTER
							; 6892		BYTE DISP,		;SEE IF 7 BIT
							; 6893		FE_FE.AND.S#, S#/0770,	;MASK OUT P FIELD
U 2323, 0340,3333,0003,4174,4006,5701,1000,0051,0770	; 6894		J/LDB1			;GO GET THE BYTE
							; 6895	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 188
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- STORE BYTE IN DESTINATION STRING

							; 6896	.TOC	"EXTEND SUBROUTINES -- STORE BYTE IN DESTINATION STRING"
							; 6897	
							; 6898	;CALL WITH:
							; 6899	;	AR/ BYTE TO STORE
							; 6900	;	AC4/ DESTINATION BYTE POINTER
							; 6901	;RETURNS:
							; 6902	;	AR & AC4/ UPDATED BYTE POINTER
							; 6903	;	ARX/ BYTE TO STORE
							; 6904	;	BR/ WORD TO MERGE WITH
							; 6905	;	6 ALWAYS
							; 6906	;
U 3510, 2324,3441,0304,4174,4007,0700,0000,0000,0000	; 6907	PUTDST:	[ARX]_[AR]		;SAVE BYTE
							; 6908	=0	[AR]_AC[DSTP],		;GET DEST POINTER
U 2324, 3511,3771,0003,1276,6007,0701,0010,0000,1444	; 6909		CALL [IDST]		;BUMP DEST POINTER
							; 6910		AD/A+B, A/ARX, B/ARX,	;SHIFT 7-BIT BYTE TO
							; 6911		SCAD/A, 3T,		; NATURAL PLACE, AND PUT
U 2325, 2265,0113,0404,4174,4007,0701,1000,0077,0000	; 6912		SCADA/BYTE5, LOAD FE	; INTO FE
							; 6913	=0*	READ [AR], BYTE DISP,	;GO PUT BYTE IN MEMORY
U 2265, 0360,3333,0003,4174,4006,5701,0010,0000,0000	; 6914		CALL [DPB1]		; ..
U 2267, 0006,4443,0000,4174,4004,1700,0000,0000,0000	; 6915		RETURN [6]		;ALL DONE
							; 6916	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 189
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- UPDATE DEST STRING POINTERS	

							; 6917	.TOC	"EXTEND SUBROUTINES -- UPDATE DEST STRING POINTERS"
							; 6918	
							; 6919	
							; 6920	;SUBROUTINE TO BUMP DST POINTERS
							; 6921	;CALL WITH:
							; 6922	;	AR/	AC[DSTP]
							; 6923	;	RETURN 1 WITH UPDATED POINTER STORED
							; 6924	;
U 3511, 2330,3770,0305,4334,4016,7701,0000,0033,6000	; 6925	IDST:	IBP DP, IBP SCAD, SCAD DISP, 3T
U 2330, 3513,3441,0503,4174,4217,0700,0000,0000,0600	; 6926	=0*	[AR]_[BR], LOAD DST EA, J/IDSTX
U 2332, 3512,3770,0503,4334,4017,0700,0000,0032,6000	; 6927		SET P TO 36-S
U 3512, 3513,0111,0703,4170,4217,0700,0000,0000,0600	; 6928		[AR]_[AR]+1, HOLD LEFT, LOAD DST EA
							; 6929	IDSTX:	AC[DSTP]_[AR], 3T,	;STORE PTR BACK
U 3513, 0230,3440,0303,1174,4006,6701,1400,0073,1444	; 6930		FE_P, DISP/EAMODE	;SAVE P FOR CMPDST
							; 6931	=100*
U 0230, 3120,0553,0300,2274,4007,0701,0200,0004,0712	; 6932	DSTEA:	VMA_[AR]+XR, START READ, PXCT BYTE DATA, 3T, J/BYTFET
U 0232, 3120,3443,0300,4174,4007,0700,0200,0004,0712	; 6933		VMA_[AR], START READ, PXCT BYTE DATA, J/BYTFET
U 0234, 3514,0553,0300,2274,4007,0701,0200,0004,0612	; 6934		VMA_[AR]+XR, START READ, PXCT/BIS-DST-EA, 3T, J/DSTIND
U 0236, 3514,3443,0300,4174,4007,0700,0200,0004,0612	; 6935		VMA_[AR], START READ, PXCT/BIS-DST-EA, J/DSTIND
							; 6936	
U 3514, 3515,3771,0003,4361,5217,0700,0200,0000,0602	; 6937	DSTIND:	MEM READ, [AR]_MEM, HOLD LEFT, LOAD DST EA
U 3515, 0230,4443,0000,2174,4006,6700,0000,0000,0000	; 6938		EA MODE DISP, J/DSTEA
							; 6939	
							; 6940	
							; 6941	;HERE TO TEST ILLEGAL BITS SET
							; 6942	;CALL WITH:
							; 6943	;	SKIP IF ALL BITS LEGAL
							; 6944	;	RETURN [4] IF OK, ELSE DO UUO
							; 6945	;
							; 6946	3556:		;EXTEND OF 0 COMES HERE
U 3556, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 6947	BITCHK:	UUO
U 3557, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 6948	3557:	RETURN [4]
							; 6949	
							; 6950	;HERE TO PUT FILL IN [AR] AND WORK[FILL]
							; 6951	GTFILL:	MEM READ,		;WAIT FOR DATA
U 3516, 3517,3771,0003,4365,5007,0700,0200,0000,0002	; 6952		[AR]_MEM		;PLACE IN AR
							; 6953		WORK[FILL]_[AR],	;SAVE FOR LATER
U 3517, 0010,3333,0003,7174,4004,1700,0400,0000,0244	; 6954		RETURN [10]		;RETURN TO CALLER
							; 6955	
							; 6956	;SUBROUTINE TO CLEAR FLAGS IN AR
							; 6957	CLRFLG:	[AR]_[AR].AND.#,	;CLEAR FLAGS IN AR
							; 6958		#/000777,		; ..
U 3520, 0001,4551,0303,4374,0004,1700,0000,0000,0777	; 6959		HOLD RIGHT, RETURN [1]
							; 6960	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 190
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- PAGE FAIL CLEANUP				

							; 6961	.TOC	"EXTEND -- PAGE FAIL CLEANUP"
							; 6962	
							; 6963	;BACK UP SOURCE POINTER
							; 6964	=0
							; 6965	BACKS:	[AR]_AC[SRCP],
U 2326, 3533,3771,0003,1276,6007,0701,0010,0000,1441	; 6966		CALL [BACKBP]		;BACKUP BP
U 2327, 2720,3440,0505,1174,4007,0700,0400,0000,1441	; 6967		AC[SRCP]_[BR], J/CLDISP
							; 6968	
U 3521, 3522,3771,0003,7274,4007,0701,0000,0000,0214	; 6969	CMSDST:	[AR]_WORK[SV.BRX]	;GET OLD SRC LEN
U 3522, 2334,0113,0703,0174,4007,0701,0400,0000,0000	; 6970		AC_[AR]+1, 3T		;BACK UP
							; 6971	;BACK UP DESTINATION POINTER
							; 6972	=0
							; 6973	BACKD:	[AR]_AC[DSTP],
U 2334, 3533,3771,0003,1276,6007,0701,0010,0000,1444	; 6974		CALL [BACKBP]
U 2335, 2720,3440,0505,1174,4007,0700,0400,0000,1444	; 6975		AC[DSTP]_[BR], J/CLDISP
							; 6976	
							; 6977	;FAILURES DURING MOVE STRING (BACKUP LENGTHS)
U 3523, 3524,1771,0003,7274,4007,0701,4000,0000,0242	; 6978	STRPF:	[AR]_-WORK[SLEN]	;GET AMOUNT LEFT
							; 6979	STRPF0:	[BR]_AC[DLEN], 4T,	;WHICH STRING IS LONGER?
U 3524, 2336,3771,0005,1276,6007,0522,0000,0000,1443	; 6980		SKIP DP0
							; 6981	=0
U 2336, 3526,3440,0303,1174,4007,0700,0400,0000,1443	; 6982	STRPF1:	AC[DLEN]_[AR], J/STPF1A	;SRC LONGER
U 2337, 2340,3441,0304,4174,4007,0700,0000,0000,0000	; 6983		[ARX]_[AR]		;COPY SRC LENGTH
							; 6984	=0	[ARX]_[ARX].OR.WORK[SV.BRX], ;REBUILD FLAGS
U 2340, 3731,3551,0404,7274,4007,0701,0010,0000,0214	; 6985		CALL [AC_ARX]		;RESET AC]SLEN]
U 2341, 3525,1111,0503,4174,4007,0700,4000,0000,0000	; 6986		[AR]_[AR]-[BR]		;MAKE DEST LEN
							; 6987	STRPF3:	AC[DLEN]_[AR],		;PUT BACK DEST LEN
U 3525, 2720,3440,0303,1174,4007,0700,0400,0000,1443	; 6988		J/CLDISP		;DO NEXT CLEANUP
							; 6989	
U 3526, 3530,0111,0503,4174,4007,0700,0000,0000,0000	; 6990	STPF1A:	[AR]_[AR]+[BR], J/STRPF2
							; 6991	
U 3527, 3530,1771,0003,7274,4007,0701,4000,0000,0242	; 6992	PFDBIN:	[AR]_-WORK[SLEN]	;RESTORE LENGTH
U 3530, 3531,3551,0303,7274,4007,0701,0000,0000,0214	; 6993	STRPF2:	[AR]_[AR].OR.WORK[SV.BRX]
U 3531, 2720,3440,0303,0174,4007,0700,0400,0000,0000	; 6994	PFGAC0:	AC_[AR], J/CLDISP	;PUT BACK SRC LEN AND FLAGS
							; 6995	
U 3532, 3524,7771,0003,7274,4007,0701,0000,0000,0242	; 6996	STRPF4:	[AR]_.NOT.WORK[SLEN], J/STRPF0
							; 6997	
							; 6998	BACKBP:	IBP DP, SCAD/A+B, SCADA/BYTE1, SCADB/SIZE, ;P_P+S
U 3533, 0001,3770,0305,4334,4014,1700,0000,0043,6000	; 6999		RETURN [1]
							; 7000	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 191
; INOUT.MIC[1,2]	13:32 7-JAN-1986			TRAPS							

							; 7001		.TOC	"TRAPS"
							; 7002	
U 3534, 3535,3741,0104,4074,4007,0700,0000,0000,0000	; 7003	TRAP:	[ARX]_PC WITH FLAGS	;SAVE THE PC WHICH CAUSED THE
							; 7004		WORK[TRAPPC]_[ARX],	; TRAP
U 3535, 2342,3333,0004,7174,4007,0340,0400,0000,0425	; 7005		SKIP KERNEL		;SEE IF UBR OR EBR
							; 7006	=0	[AR]_[AR]+[UBR],	;ADDRESS OF INSTRUCTION
							; 7007		MEM READ,		;WAIT FOR PREFETCH TO GET INTO
							; 7008					; THE CACHE. MAY PAGE FAIL BUT
							; 7009					; THAT IS OK
							; 7010		START READ,		;START FETCH
							; 7011		VMA PHYSICAL,		;ABSOLUTE ADDRESSING
U 2342, 3536,0111,1103,4364,4007,0700,0200,0024,1016	; 7012		J/TRP1			;JOIN COMMON CODE
							; 7013	
							; 7014		[AR]_[AR]+[EBR],	;WE COME HERE IN EXEC MODE
							; 7015		MEM READ,		;WAIT FOR PREFETCH TO GET INTO
							; 7016					; THE CACHE. MAY PAGE FAIL BUT
							; 7017					; THAT IS OK
							; 7018		START READ,		;START FETCH
							; 7019		VMA PHYSICAL,		;ABSOLUTE ADDRESSING
U 2343, 3536,0111,1003,4364,4007,0700,0200,0024,1016	; 7020		J/TRP1			;JOIN COMMON CODE
							; 7021	
							; 7022	TRP1:	MEM READ, [HR]_MEM,	;PLACE INSTRUCTION IN HR
U 3536, 3537,3771,0002,4365,5617,0700,0200,0000,0002	; 7023		LOAD INST		;LOAD IR, XR, @
							; 7024		[HR].AND.#,		;TEST TO SEE IF THIS
							; 7025		#/700000, 3T,		; IS A UUO
U 3537, 2344,4553,0200,4374,4007,0321,0000,0070,0000	; 7026		SKIP ADL.EQ.0
							; 7027	=0	CHANGE FLAGS,		;NOT A UUO
							; 7028		HOLD USER/1,		;CLEAR TRAP FLAGS
U 2344, 2735,4443,0000,4174,4467,0700,0000,0001,0000	; 7029		J/XCT1			;DO THE INSTRUCTION
U 2345, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7030		UUO			;DO THE UUO
							; 7031	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 192
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES					

							; 7032		.TOC	"IO -- INTERNAL DEVICES"
							; 7033	
							; 7034		.DCODE
D 0700, 1200,1700,4100					; 7035	700:	IOT,AC DISP,	J/GRP700
D 0701, 1200,1720,4100					; 7036		IOT,AC DISP,	J/GRP701
							; 7037		.UCODE
							; 7038	
U 1701, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7039	1701:	UUO		;DATAI APR,
U 1702, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7040	1702:	UUO		;BLKO APR,
U 1703, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7041	1703:	UUO		;DATAO APR,
U 1706, 3542,3771,0005,4304,4007,0701,0000,0000,0000	; 7042	1706:	[BR]_APR, J/APRSZ ;CONSZ APR,
U 1707, 3540,3771,0005,4304,4007,0701,0000,0000,0000	; 7043	1707:	[BR]_APR, J/APRSO ;CONSO APR,
							; 7044	1710:
U 1710, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7045	RDERA:	UUO		;BLKI PI,
U 1711, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7046	1711:	UUO		;DATAI PI,
U 1712, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7047	1712:	UUO		;BLKO PI,
U 1713, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7048	1713:	UUO		;DATAO PI,
U 1716, 0136,3441,1405,4174,4007,0700,0000,0000,0000	; 7049	1716:	[BR]_[PI], J/CONSZ ;CONSZ PI,
U 1717, 3541,3441,1405,4174,4007,0700,0000,0000,0000	; 7050	1717:	[BR]_[PI], J/CONSO ;CONSO PI,
							; 7051	
							; 7052	1720:
U 1720, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7053	GRP701:	UUO		;BLKI PAG,
U 1726, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7054	1726:	UUO		;CONSZ PAG,
U 1727, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7055	1727:	UUO		;CONSO PAG,
							; 7056	
							; 7057	;680I AND CACHE SWEEP STUFF
U 1730, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7058	1730:	UUO
U 1731, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7059	1731:	UUO
U 1732, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7060	1732:	UUO
U 1733, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7061	1733:	UUO
U 1734, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7062	1734:	UUO
U 1735, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7063	1735:	UUO
U 1736, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7064	1736:	UUO
U 1737, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7065	1737:	UUO
							; 7066	
U 3540, 3541,4251,0505,4374,4007,0700,0000,0000,7770	; 7067	APRSO:	[BR]_[BR].AND.# CLR LH, #/7770
U 3541, 0260,4113,0305,4174,4007,0330,0000,0000,0000	; 7068	CONSO:	[BR].AND.[AR], SKIP ADR.EQ.0, J/SKIP
							; 7069	
U 3542, 0136,4251,0505,4374,4007,0700,0000,0000,7770	; 7070	APRSZ:	[BR]_[BR].AND.# CLR LH, #/7770
							; 7071	136:					;STANDARD LOCATION FOR VERSION INFO,
							; 7072						;ANY UWORD THAT HAS A FREE # FIELD CAN
							; 7073						;BE USED.
							; 7074	CONSZ:	[BR].AND.[AR], SKIP ADR.EQ.0, J/DONE,
							; 7075		MICROCODE RELEASE(MAJOR)/UCR,	;MAJOR VERSION #
U 0136, 1400,4113,0305,4174,4007,0330,0000,0000,0021	; 7076		MICROCODE RELEASE(MINOR)/UCR	;MINOR VERSION # (FOR ID ONLY)
							; 7077	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 193
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES					

							; 7078	1700:
							; 7079	GRP700:
							; 7080	APRID:	[BR]_#,
U 1700, 0137,3771,0005,4374,4007,0700,0000,0001,0001	; 7081		#/4097.
							; 7082	137:	[BR]_#,
							; 7083		MICROCODE OPTION(INHCST)/OPT,
							; 7084		MICROCODE OPTION(NOCST)/OPT,
							; 7085		MICROCODE OPTION(NONSTD)/OPT,
							; 7086		MICROCODE OPTION(UBABLT)/OPT,
							; 7087		MICROCODE OPTION(KIPAGE)/OPT,
							; 7088		MICROCODE OPTION(KLPAGE)/OPT,
							; 7089		MICROCODE VERSION/UCV,
							; 7090		HOLD RIGHT,
U 0137, 3653,3771,0005,4374,0007,0700,0000,0047,0130	; 7091		J/RTNREG
							; 7092	
							; 7093	1704:
U 1704, 3543,3771,0005,7274,4007,0701,0000,0000,0230	; 7094	WRAPR:	[BR]_WORK[APR]
							; 7095		[BR]_[BR].AND.NOT.#,	;CLEAR THE OLD PIA
U 3543, 3544,5551,0505,4370,4007,0700,0000,0000,0007	; 7096		#/7, HOLD LEFT		; ..
U 3544, 3545,4551,0304,4374,4007,0700,0000,0000,0007	; 7097		[ARX]_[AR].AND.#, #/7	;PUT NEW PIA IN ARX
U 3545, 3546,3111,0405,4174,4007,0700,0000,0000,0000	; 7098		[BR]_[BR].OR.[ARX]	;PUT NEW PIA IN BR
							; 7099		[ARX]_[AR].AND.#, 	;MASK THE DATA BITS
U 3546, 3547,4551,0304,4374,4007,0700,0000,0000,7760	; 7100		#/007760		; DOWN TO ENABLES
U 3547, 2346,4553,0300,4374,4007,0331,0000,0010,0000	; 7101		TR [AR], #/100000	;WANT TO ENABLE ANY?
U 2346, 2347,3111,0405,4174,4007,0700,0000,0000,0000	; 7102	=0	[BR]_[BR].OR.[ARX]	;YES--SET THEM
U 2347, 2350,4553,0300,4374,4007,0331,0000,0004,0000	; 7103		TR [AR], #/40000	;WANT TO DISABLE ANY?
U 2350, 2351,5111,0405,4174,4007,0700,0000,0000,0000	; 7104	=0	[BR]_[BR].AND.NOT.[ARX]	;YES--CLEAR THEM
U 2351, 3550,3771,0006,4304,4007,0701,0000,0000,0000	; 7105		[BRX]_APR		;GET CURRENT STATUS
U 3550, 2352,4553,0300,4374,4007,0331,0000,0002,0000	; 7106		TR [AR], #/20000	;WANT TO CLEAR FLAGS?
U 2352, 2353,5111,0406,4174,4007,0700,0000,0000,0000	; 7107	=0	[BRX]_[BRX].AND.NOT.[ARX] ;YES--CLEAR BITS
U 2353, 2354,4553,0300,4374,4007,0331,0000,0001,0000	; 7108		TR [AR], #/10000	;WANT TO SET ANY FLAGS?
U 2354, 2355,3111,0406,4174,4007,0700,0000,0000,0000	; 7109	=0	[BRX]_[BRX].OR.[ARX]	;YES--SET FLAGS
U 2355, 2356,4553,0300,4374,4007,0331,0000,0003,0000	; 7110		TR [AR], #/30000	;ANY CHANGE AT ALL?
							; 7111	=0	READ [BRX],		;YES--LOAD NEW FLAGS
U 2356, 3553,3333,0006,4174,4007,0700,0000,0000,0000	; 7112		J/WRAPR2		;TURN OFF INTERRUPT 8080
U 2357, 3551,3333,0005,4174,4007,0700,0000,0000,0000	; 7113	WRAPR1:	READ [BR]		;FIX DPM TIMING BUG
							; 7114		READ [BR], 		;ENABLE CONDITIONS
U 3551, 3552,3333,0005,4174,4257,0700,0000,0000,0000	; 7115		SET APR ENABLES
							; 7116		WORK[APR]_[BR],		;SAVE FOR RDAPR
U 3552, 1400,3333,0005,7174,4007,0700,0400,0000,0230	; 7117		J/DONE			;ALL DONE
							; 7118	
							; 7119	WRAPR2:	READ [BRX], 		;LOAD NEW FLAGS
U 3553, 3554,3333,0006,4174,4237,0700,0000,0000,0000	; 7120		SPEC/APR FLAGS		; ..
							; 7121		[BRX]_[BRX].AND.NOT.#,	;CLEAR INTERRUPT THE 8080
U 3554, 3555,5551,0606,4370,4007,0700,0000,0000,2000	; 7122		#/002000, HOLD LEFT	; FLAG
							; 7123		READ [BRX], 		;LOAD NEW FLAGS
							; 7124		SPEC/APR FLAGS,		; ..
U 3555, 2357,3333,0006,4174,4237,0700,0000,0000,0000	; 7125		J/WRAPR1		;LOOP BACK
							; 7126	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 194
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES					

							; 7127	1705:
U 1705, 3560,3771,0005,7274,4007,0701,0000,0000,0230	; 7128	RDAPR:	[BR]_WORK[APR]
							; 7129		[BR]_[BR] SWAP,		;PUT ENABLES IN BOTH
U 3560, 3561,3770,0505,4344,0007,0700,0000,0000,0000	; 7130		HOLD RIGHT		; HALVES
							; 7131		[BR]_[BR].AND.#,	;SAVE ENABLES IN LH
							; 7132		#/7760,			;
U 3561, 3562,4551,0505,4374,0007,0700,0000,0000,7760	; 7133		HOLD RIGHT
							; 7134		[BR]_[BR].AND.#,	;SAVE PIA IN RH
							; 7135		#/7,
U 3562, 3563,4551,0505,4370,4007,0700,0000,0000,0007	; 7136		HOLD LEFT
U 3563, 3564,3771,0004,4304,4007,0701,0000,0000,0000	; 7137		[ARX]_APR		;READ THE APR FLAGS
							; 7138		[ARX]_[ARX].AND.# CLR LH, ;MASK OUT JUNK
U 3564, 3565,4251,0404,4374,4007,0700,0000,0000,7770	; 7139		#/007770		;KEEP 8 FLAGS
							; 7140		[BR]_[BR].OR.[ARX],	;MASH THE STUFF TOGETHER
U 3565, 3653,3111,0405,4174,4007,0700,0000,0000,0000	; 7141		J/RTNREG		;RETURN
							; 7142	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 195
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7143	.TOC	"IO -- INTERNAL DEVICES -- EBR & UBR"
							; 7144	
							; 7145		;UBR FORMAT:
							; 7146		;BITS  0 & 2	LOAD FLAGS (RETURNED ON RDUBR)
							; 7147		;BITS  3 - 5	ZERO
							; 7148		;BITS  6 -11	AC BLOCKS SELECTED - CUR,PREV
							; 7149		;BITS 16 -35	UPT PHYSICAL ADDRESS
							; 7150	
							; 7151	1723:
							; 7152	WRUBR:	VMA_[AR],		;LOAD E INTO VMA
U 1723, 3566,3443,0300,4174,4007,0700,0200,0004,0012	; 7153		START READ		;START MEMORY
							; 7154		MEM READ,		;WAIT FOR DATA
							; 7155		[AR]_MEM, 3T,		;PUT IT INTO THE AR
U 3566, 2360,3771,0003,4365,5007,0521,0200,0000,0002	; 7156		SKIP DP0		;SEE IF WE WANT TO LOAD
							; 7157					; AC BLOCK NUMBERS
							; 7158	
							; 7159	=0	[AR]_[AR].AND.#,	;NO--CLEAR JUNK IN AR (ALL BUT LD UBR)
							; 7160		#/100000,		; LEAVE ONLY LOAD UBR
							; 7161		HOLD RIGHT,		; IN LEFT HALF
							; 7162		SKIP ADL.EQ.0, 3T,	;SEE IF WE WANT TO LOAD UBR
U 2360, 2362,4551,0303,4374,0007,0321,0000,0010,0000	; 7163		J/ACBSET		;SKIP AROUND UBR LOAD
							; 7164	
							; 7165		;HERE WHEN WE WANT TO LOAD AC BLOCK SELECTION
							; 7166		[UBR]_[UBR].AND.#,	;MASK OUT THE UBR'S OLD
							; 7167		#/770077,		; AC BLOCK NUMBERS
U 2361, 3567,4551,1111,4374,0007,0700,0000,0077,0077	; 7168		HOLD RIGHT		;IN THE LEFT HALF
							; 7169	
							; 7170		[AR]_[AR].AND.#,	;CLEAR ALL BUT NEW SELECTION
							; 7171		#/507700,		;AND LOAD BITS
U 3567, 3570,4551,0303,4374,0007,0700,0000,0050,7700	; 7172		HOLD RIGHT		;IN AR LEFT
							; 7173	
							; 7174		[AR].AND.#,		;SEE IF WE WANT TO LOAD
							; 7175		#/100000, 3T,		; UBR ALSO
U 3570, 2362,4553,0300,4374,4007,0321,0000,0010,0000	; 7176		SKIP ADL.EQ.0
							; 7177	
							; 7178		;HERE WITH AR LEFT = NEW AC BLOCKS OR ZERO, 
							; 7179		;SKIP IF DON'T LOAD UBR
							; 7180	=0
							; 7181	ACBSET: [BR]_[AR].AND.#,	;COPY UBR PAGE NUMBER
							; 7182		#/3777,			; INTO BR
U 2362, 3571,4551,0305,4374,4007,0700,0000,0000,3777	; 7183		J/SETUBR		;GO LOAD UBR
							; 7184	
							; 7185		[UBR]_[UBR].OR.[AR],	;DO NOT LOAD UBR
							; 7186					; PUT AC BLOCK # IN
							; 7187		HOLD RIGHT,		; THE LEFT HALF
							; 7188		LOAD AC BLOCKS,		;LOAD HARDWARE
U 2363, 1400,3111,0311,4174,0477,0700,0000,0000,0000	; 7189		J/DONE			;ALL DONE
							; 7190	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 196
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7191		;HERE WITH AR LEFT AS BEFORE, AR RIGHT = MASKED PAGE #
							; 7192	SETUBR: [BR]_0, 		;CLEAR BR LEFT
							; 7193		HOLD RIGHT,		;BR IS 0,,PAGE #
U 3571, 2364,4221,0005,4174,0007,0700,2000,0071,0007	; 7194		SC_7			;PUT THE COUNT IN SC
							; 7195	=0
							; 7196	STUBRS: [BR]_[BR]*2,		;SHIFT BR OVER
							; 7197		STEP SC,		; 9 PLACES
U 2364, 2364,3445,0505,4174,4007,0630,2000,0060,0000	; 7198		J/STUBRS		;PRODUCING UPT ADDRESS
							; 7199	
							; 7200		[UBR]_[UBR].AND.#,	;MASK OUT OLD UBR
							; 7201		#/777774,		; BITS IN
U 2365, 3572,4551,1111,4374,0007,0700,0000,0077,7774	; 7202		HOLD RIGHT		; LEFT HALF
							; 7203	
							; 7204		[UBR]_0,		;CLEAR RIGHT HALF
U 3572, 3573,4221,0011,4170,4007,0700,0000,0000,0000	; 7205		HOLD LEFT		;UBR IS FLGS+ACBLK+0,,0
							; 7206	
U 3573, 3574,3111,0511,4174,4007,0700,0000,0000,0000	; 7207		[UBR]_[UBR].OR.[BR]	;PUT IN PAGE TABLE ADDRESS
							; 7208	
							; 7209		[UBR]_[UBR].OR.[AR],	;PUT IN AC BLOCK #
							; 7210		HOLD RIGHT,		; IN LEFT HALF
							; 7211		LOAD AC BLOCKS,		;TELL HARDWARE
U 3574, 2432,3111,0311,4174,0477,0700,0000,0000,0000	; 7212		J/SWEEP			;CLEAR CACHE
							; 7213	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 197
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7214	1724:
U 1724, 2366,3445,0303,4174,4007,0700,2000,0071,0006	; 7215	WREBR:	[AR]_[AR]*2, SC_6	;DO A SHIFT OVER 8 MORE
							; 7216	=0
U 2366, 2366,3445,0303,4174,4007,0630,2000,0060,0000	; 7217	WREBR1:	[AR]_[AR]*2, STEP SC, J/WREBR1	;SKIP WHEN = -1
							; 7218	.IF/FULL			;DO NOT ENABLE PAGING IN SMALL
							; 7219					; MICROCODE.
U 2367, 3575,3771,0005,7274,4007,0701,0000,0000,0230	; 7220		[BR]_WORK[APR]
U 3575, 3576,4551,0505,4370,4007,0700,0000,0074,7777	; 7221		[BR]_[BR].AND.#, #/747777, HOLD LEFT
U 3576, 2370,4553,0300,4374,4007,0321,0000,0000,0020	; 7222		[AR].AND.#, #/20, 3T, SKIP ADL.EQ.0	;BIT 22 - TRAP ENABLE
U 2370, 2371,3551,0505,4370,4007,0700,0000,0003,0000	; 7223	=0	[BR]_[BR].OR.#, #/030000, HOLD LEFT	;SET - ALLOW TRAPS TO HAPPEN
U 2371, 3577,3333,0005,4174,4257,0700,0000,0000,0000	; 7224		READ [BR], SET APR ENABLES
U 3577, 3600,3333,0005,7174,4007,0700,0400,0000,0230	; 7225		WORK[APR]_[BR]
							; 7226	.ENDIF/FULL
							; 7227	
							; 7228	.IF/KIPAGE
							; 7229	.IF/KLPAGE
U 3600, 3601,3441,0310,4174,4007,0700,0000,0000,0000	; 7230		[EBR]_[AR]		;NOTE: SHIFTED LEFT 9 BITS
U 3601, 2372,4553,1000,4374,4007,0321,0000,0000,0040	; 7231		[EBR].AND.#, #/40, 3T, SKIP ADL.EQ.0	;BIT 21 - KL PAGING ENABLE
U 2372, 2432,3551,1010,4374,0007,0700,0000,0040,0000	; 7232	=0	[EBR]_[EBR].OR.#, #/400000, HOLD RIGHT, J/SWEEP ;YES, SET INTERNAL FLAG
U 2373, 2432,5551,1010,4374,0007,0700,0000,0040,0000	; 7233		[EBR]_[EBR].AND.NOT.#, #/400000, HOLD RIGHT, J/SWEEP ;NO, CLR BIT 0
							; 7234	.ENDIF/KLPAGE
							; 7235	.ENDIF/KIPAGE
							; 7236	
							;;7237	.IFNOT/KLPAGE			;MUST BE KI ONLY
							;;7238		[EBR]_[AR],J/SWEEP	;SO INTERNAL FLAG ISN'T USED
							; 7239	.ENDIF/KLPAGE
							; 7240	
							;;7241	.IFNOT/KIPAGE			;MUST BE KL ONLY
							;;7242		[EBR]_[AR],J/SWEEP	;SO INTERNAL FLAG ISN'T USED
							; 7243	.ENDIF/KIPAGE
							; 7244	
							; 7245	1725:
U 1725, 2374,3447,1005,4174,4007,0700,2000,0071,0006	; 7246	RDEBR:	[BR]_[EBR]*.5, SC_6
							; 7247	=0
U 2374, 2374,3447,0505,4174,4007,0630,2000,0060,0000	; 7248	RDEBR1:	[BR]_[BR]*.5, STEP SC, J/RDEBR1
U 2375, 3602,4551,0505,4374,4007,0700,0000,0006,3777	; 7249		[BR]_[BR].AND.#, #/63777 ;MASK TO JUST EBR
							; 7250		[BR]_0,			;CLEAR LEFT HALF
							; 7251		HOLD RIGHT,		; BITS
U 3602, 3653,4221,0005,4174,0007,0700,0000,0000,0000	; 7252		J/RTNREG		;RETURN ANSWER
							; 7253	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 198
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7254	1721:	
U 1721, 2376,4551,1105,4374,0007,0700,0000,0050,7700	; 7255	RDUBR:	[BR]_[UBR].AND.#,#/507700,HOLD RIGHT	;GET LOAD BITS AND AC BLOCKS
U 2376, 2400,3447,1106,4174,4007,0700,2010,0071,0006	; 7256	=0	[BRX]_[UBR]*.5, SC_6, CALL [GTPCW1]	;SET SC (9) START SHIFT,GET UBR
							; 7257		VMA_[AR],START WRITE,	;START TO
U 2377, 3654,3443,0300,4174,4007,0700,0200,0003,0012	; 7258		J/RTNRG1		;RETURN DATA
							; 7259	
							; 7260	
U 3603, 3604,4551,1105,4374,0007,0700,0000,0050,7700	; 7261	GETPCW:	[BR]_[UBR].AND.#,#/507700,HOLD RIGHT	;GET LOAD BITS AND AC BLOCKS
U 3604, 2400,3447,1106,4174,4007,0700,2000,0071,0006	; 7262		[BRX]_[UBR]*.5, SC_6			;SET SC (9) START SHIFT
							; 7263	
							; 7264	=0
U 2400, 2400,3447,0606,4174,4007,0630,2000,0060,0000	; 7265	GTPCW1:	[BRX]_[BRX]*.5, STEP SC, J/GTPCW1	;SHIFT UBR ADDR TO PAGE #
U 2401, 3605,4551,0606,4374,4007,0700,0000,0000,3777	; 7266		[BRX]_[BRX].AND.#, #/3777		;ONLY PAGE #
U 3605, 0001,3441,0605,4170,4004,1700,0000,0000,0000	; 7267		[BR]_[BRX], HOLD LEFT, RETURN [1]	;MOVE PAGE # TO RH OF RESULT
							; 7268	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 199
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- KL PAGING REGISTERS		

							; 7269	.TOC	"IO -- INTERNAL DEVICES -- KL PAGING REGISTERS"
							; 7270	
							; 7271		.DCODE
D 0702, 1216,1760,4700					; 7272	702:	IOT,AC DISP,	M,	J/GRP702
							; 7273		.UCODE
							; 7274	
							; 7275	1760:
							; 7276	GRP702:
U 1760, 3653,3771,0005,7274,4007,0701,0000,0000,0215	; 7277	RDSPB:	[BR]_WORK[SBR], J/RTNREG
							; 7278	1761:
U 1761, 3653,3771,0005,7274,4007,0701,0000,0000,0216	; 7279	RDCSB:	[BR]_WORK[CBR], J/RTNREG
							; 7280	1762:
U 1762, 3653,3771,0005,7274,4007,0701,0000,0000,0220	; 7281	RDPUR:	[BR]_WORK[PUR], J/RTNREG
							; 7282	1763:
U 1763, 3653,3771,0005,7274,4007,0701,0000,0000,0217	; 7283	RDCSTM:	[BR]_WORK[CSTM], J/RTNREG
							; 7284	1766:
U 1766, 3653,3771,0005,7274,4007,0701,0000,0000,0227	; 7285	RDHSB:	[BR]_WORK[HSBADR], J/RTNREG
U 1767, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7286	1767:	UUO
							; 7287	
							; 7288	1770:
U 1770, 3606,4443,0000,4174,4007,0703,0200,0006,0002	; 7289	WRSPB:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3606, 3607,3771,0003,4365,5007,0700,0200,0000,0002	; 7290		MEM READ, [AR]_MEM
U 3607, 1400,3333,0003,7174,4007,0700,0400,0000,0215	; 7291		WORK[SBR]_[AR], J/DONE
							; 7292	1771:
U 1771, 3610,4443,0000,4174,4007,0703,0200,0006,0002	; 7293	WRCSB:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3610, 3611,3771,0003,4365,5007,0700,0200,0000,0002	; 7294		MEM READ, [AR]_MEM
U 3611, 1400,3333,0003,7174,4007,0700,0400,0000,0216	; 7295		WORK[CBR]_[AR], J/DONE
							; 7296	1772:
U 1772, 3612,4443,0000,4174,4007,0703,0200,0006,0002	; 7297	WRPUR:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3612, 3613,3771,0003,4365,5007,0700,0200,0000,0002	; 7298		MEM READ, [AR]_MEM
U 3613, 1400,3333,0003,7174,4007,0700,0400,0000,0220	; 7299		WORK[PUR]_[AR], J/DONE
							; 7300	1773:
U 1773, 3614,4443,0000,4174,4007,0703,0200,0006,0002	; 7301	WRCSTM:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3614, 3615,3771,0003,4365,5007,0700,0200,0000,0002	; 7302		MEM READ, [AR]_MEM
U 3615, 1400,3333,0003,7174,4007,0700,0400,0000,0217	; 7303		WORK[CSTM]_[AR], J/DONE
							; 7304	1776:
U 1776, 3616,4443,0000,4174,4007,0703,0200,0006,0002	; 7305	WRHSB:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3616, 3617,3771,0003,4365,5007,0700,0200,0000,0002	; 7306		MEM READ, [AR]_MEM
U 3617, 1400,3333,0003,7174,4007,0700,0400,0000,0227	; 7307		WORK[HSBADR]_[AR], J/DONE
							; 7308	
U 1777, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7309	1777:	UUO
							; 7310	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 200
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- TIMER CONTROL			

							; 7311	.TOC	"IO -- INTERNAL DEVICES -- TIMER CONTROL"
							; 7312	
							; 7313	
							; 7314					;BEGIN [123]
							; 7315	TICK:	[AR]_WORK[TIME1],	;GET LOW WORD
U 3620, 3621,3771,0003,7274,4117,0701,0000,0000,0301	; 7316		SPEC/CLRCLK		;CLEAR CLOCK FLAG
							; 7317					;END [123]
U 3621, 3622,4751,1205,4374,4007,0700,0000,0001,0000	; 7318	TOCK:	[BR]_0 XWD [10000]	;2^12 UNITS PER MS
U 3622, 3623,0111,0503,4174,4007,0700,0000,0000,0000	; 7319		[AR]_[AR]+[BR]		;INCREMENT THE TIMER
U 3623, 2402,3770,0303,4174,0007,0520,0000,0000,0000	; 7320		FIX [AR] SIGN, SKIP DP0	;SEE IF IT OVERFLOWED
							; 7321	=0
							; 7322	TOCK1:	WORK[TIME1]_[AR],	;STORE THE NEW TIME
U 2402, 3624,3333,0003,7174,4007,0700,0400,0000,0301	; 7323		J/TOCK2			;SKIP OVER THE OVERFLOW CODE
U 2403, 2331,3771,0003,7274,4007,0701,0000,0000,0300	; 7324		[AR]_WORK[TIME0]	 ;GET HIGH WORD
							; 7325	=0*	[AR]_[AR]+1,		;BUMP IT
U 2331, 3632,0111,0703,4174,4007,0700,0010,0000,0000	; 7326		CALL [WRTIM1]		;STORE BACK IN RAM
							; 7327		[AR]_0,			;CAUSE LOW WORD WORD
U 2333, 2402,4221,0003,4174,4007,0700,0000,0000,0000	; 7328		J/TOCK1			; TO GET STORED
U 3624, 3625,3771,0003,7274,4007,0701,0000,0000,0303	; 7329	TOCK2:	[AR]_WORK[TTG]
							; 7330		[AR]_[AR]-[BR],		;COUNT DOWN TIME TO GO
U 3625, 2404,1111,0503,4174,4007,0421,4000,0000,0000	; 7331		SKIP AD.LE.0		;SEE IF IT TIMED OUT
							; 7332	=0
							; 7333	TOCK3:	WORK[TTG]_[AR],		;SAVE NEW TIME TO GO
U 2404, 0002,3333,0003,7174,4004,1700,0400,0000,0303	; 7334		RETURN [2]		;ALL DONE
U 2405, 3626,3771,0003,7274,4007,0701,0000,0000,0302	; 7335		[AR]_WORK[PERIOD]
U 3626, 3627,3771,0005,4304,4007,0701,0000,0000,0000	; 7336		[BR]_APR		;GET CURRENT FLAGS
U 3627, 3630,3551,0505,4374,4007,0700,0000,0000,0040	; 7337		[BR]_[BR].OR.#, #/40	;SET TIMER INTERRUPT FLAG
							; 7338		READ [BR],		;PLACE ON DP AND
							; 7339		SPEC/APR FLAGS,		; LOAD INTO HARDWARE
U 3630, 2404,3333,0005,4174,4237,0700,0000,0000,0000	; 7340		J/TOCK3			;ALL DONE
							; 7341	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 201
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- WRTIME & RDTIME		

							; 7342	.TOC	"IO -- INTERNAL DEVICES -- WRTIME & RDTIME"
							; 7343	
							; 7344	1774:
U 1774, 3631,4443,0000,4174,4007,0700,0200,0004,0002	; 7345	WRTIME:	START READ		;FETCH WORD AT E
							; 7346		MEM READ,		;WAIT FOR DATA
U 3631, 1124,3771,0003,4365,5007,0700,0200,0000,0002	; 7347		[AR]_MEM		;PUT WORD IN AR
							; 7348	=00	VMA_[HR]+1,		;BUMP E
							; 7349		START READ,		;START MEMORY
U 1124, 3721,0111,0702,4170,4007,0700,0210,0004,0012	; 7350		CALL [LOADARX]		;PUT DATA IN ARX
							; 7351		[ARX]_[ARX].AND.#,	;CLEAR PART HELD IN
							; 7352		#/770000,		; HARDWARE COUNTER
U 1125, 3632,4551,0404,4370,4007,0700,0010,0077,0000	; 7353		HOLD LEFT,  CALL [WRTIM1]
							; 7354	=11	WORK[TIME1]_[ARX],	;IN WORK SPACE
U 1127, 1400,3333,0004,7174,4007,0700,0400,0000,0301	; 7355		J/DONE			;NEXT INSTRUCTION
							; 7356	=
							; 7357	WRTIM1:	WORK[TIME0]_[AR],	;SAVE THE NEW VALUE
U 3632, 0002,3333,0003,7174,4004,1700,0400,0000,0300	; 7358		RETURN [2]
							; 7359	
							; 7360	1764:
U 1764, 3633,4451,1205,4324,4007,0700,0000,0000,0000	; 7361	RDTIME:	[BR]_TIME		;READ THE TIME
U 3633, 3634,4451,1204,4324,4007,0700,0000,0000,0000	; 7362		[ARX]_TIME		; AGAIN
U 3634, 3635,4451,1206,4324,4007,0700,0000,0000,0000	; 7363		[BRX]_TIME		; AGAIN
							; 7364		[BR].XOR.[ARX],		;SEE IF STABLE
U 3635, 2406,6113,0405,4174,4007,0621,0000,0000,0000	; 7365		SKIP AD.EQ.0		; ..
U 2406, 2407,3441,0604,4174,4007,0700,0000,0000,0000	; 7366	=0	[ARX]_[BRX]		;NO THEN NEXT TRY MUST BE OK
U 2407, 3636,3771,0005,7274,4007,0701,0000,0000,0300	; 7367		[BR]_WORK[TIME0]
							; 7368		[ARX]_[ARX]+WORK[TIME1], ;COMBINE PARTS
U 3636, 1130,0551,0404,7274,4007,0671,0000,0000,0301	; 7369		SKIP/-1 MS		;SEE IF OVERFLOW HAPPENED
							; 7370	=00	SPEC/CLRCLK,		;CLEAR CLOCK FLAG
							; 7371		[AR]_WORK[TIME1], 2T,	;GET LOW WORD FOR TOCK
U 1130, 3621,3771,0003,7274,4117,0700,0010,0000,0301	; 7372		CALL [TOCK]		;UPDATE CLOCKS
							; 7373		READ [HR], LOAD VMA,	;DID NOT OVERFLOW
U 1131, 3637,3333,0002,4174,4007,0700,0200,0003,0012	; 7374		START WRITE, J/RDTIM1	;STORE ANSWER
U 1132, 1764,4443,0000,4174,4007,0700,0000,0000,0000	; 7375		J/RDTIME		;TRY AGAIN
							; 7376	=
U 3637, 3640,3333,0005,4175,5007,0701,0200,0000,0002	; 7377	RDTIM1:	MEM WRITE, MEM_[BR]
U 3640, 3641,0111,0702,4170,4007,0700,0200,0003,0012	; 7378		VMA_[HR]+1, LOAD VMA, START WRITE
U 3641, 1400,3333,0004,4175,5007,0701,0200,0000,0002	; 7379		MEM WRITE, MEM_[ARX], J/DONE
							; 7380	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 202
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- WRINT & RDINT			

							; 7381	.TOC	"IO -- INTERNAL DEVICES -- WRINT & RDINT"
							; 7382	
							; 7383	
							; 7384	1775:
U 1775, 3642,4443,0000,4174,4007,0700,0200,0004,0002	; 7385	WRINT:	START READ
U 3642, 3643,3771,0003,4365,5007,0700,0200,0000,0002	; 7386		MEM READ, [AR]_MEM
U 3643, 3644,3333,0003,7174,4007,0700,0400,0000,0302	; 7387		WORK[PERIOD]_[AR]
							; 7388		WORK[TTG]_[AR],
U 3644, 1400,3333,0003,7174,4007,0700,0400,0000,0303	; 7389		J/DONE
							; 7390	
							; 7391	1765:
							; 7392	RDINT:	[BR]_WORK[PERIOD],
U 1765, 3653,3771,0005,7274,4007,0701,0000,0000,0302	; 7393		J/RTNREG
							; 7394	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 203
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- RDPI & WRPI			

							; 7395	.TOC	"IO -- INTERNAL DEVICES -- RDPI & WRPI"
							; 7396	
							; 7397	1715:
U 1715, 3653,3441,1405,4174,4007,0700,0000,0000,0000	; 7398	RDPI:	[BR]_[PI], J/RTNREG
							; 7399	
							; 7400	1714:
U 1714, 2410,4553,0300,4374,4007,0331,0000,0001,0000	; 7401	WRPI:	TR [AR], PI.CLR/1
U 2410, 2411,4221,0014,4174,4007,0700,0000,0000,0000	; 7402	=0	[PI]_0
U 2411, 2412,4553,0300,4374,4007,0331,0000,0074,0000	; 7403		TR [AR], PI.MBZ/17
U 2412, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7404	=0	UUO
U 2413, 3645,4551,0305,4374,4007,0700,0000,0000,0177	; 7405		[BR]_[AR].AND.#,#/177
U 3645, 3646,3770,0505,4344,0007,0700,0000,0000,0000	; 7406		[BR]_[BR] SWAP, HOLD RIGHT
U 3646, 2414,4553,0300,4374,4007,0331,0000,0002,0000	; 7407		TR [AR], PI.DIR/1
U 2414, 2415,5111,0514,4174,0007,0700,0000,0000,0000	; 7408	=0	[PI]_[PI].AND.NOT.[BR], HOLD RIGHT
U 2415, 2416,4553,0300,4374,4007,0331,0000,0000,4000	; 7409		TR [AR], PI.REQ/1
U 2416, 2417,3111,0514,4174,0007,0700,0000,0000,0000	; 7410	=0	[PI]_[PI].OR.[BR], HOLD RIGHT
U 2417, 2420,4553,0300,4374,4007,0331,0000,0000,0200	; 7411		TR [AR], PI.TSN/1
U 2420, 2421,3551,1414,4370,4007,0700,0000,0000,0200	; 7412	=0	[PI]_[PI].OR.#,PI.ON/1, HOLD LEFT
U 2421, 2422,4553,0300,4374,4007,0331,0000,0000,0400	; 7413		TR [AR], PI.TSF/1
U 2422, 2423,5551,1414,4370,4007,0700,0000,0000,0200	; 7414	=0	[PI]_[PI].AND.NOT.#,PI.ON/1, HOLD LEFT
U 2423, 2424,4553,0300,4374,4007,0331,0000,0000,2000	; 7415		TR [AR], PI.TCN/1
U 2424, 2425,3111,0514,4170,4007,0700,0000,0000,0000	; 7416	=0	[PI]_[PI].OR.[BR], HOLD LEFT
U 2425, 0304,4553,0300,4374,4007,0331,0000,0000,1000	; 7417		TR [AR], PI.TCF/1
U 0304, 0305,5111,0514,4170,4007,0700,0000,0000,0000	; 7418	=0**0	[PI]_[PI].AND.NOT.[BR], HOLD LEFT
U 0305, 3650,3770,1416,4344,4007,0700,0010,0000,0000	; 7419	PIEXIT:	CALL LOAD PI
							; 7420	=1**1
U 0315, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 7421		DONE
							; 7422	=
							; 7423	
							; 7424	;SUBROUTINE TO LOAD PI HARDWARE
							; 7425	;CALL WITH:
							; 7426	;	CALL LOAD PI
							; 7427	;RETURNS 10 WITH PI HARDWARE LOADED
							; 7428	;
U 3647, 3650,3770,1416,4344,4007,0700,0000,0000,0000	; 7429	LOADPI:	[T0]_[PI] SWAP		;PUT ACTIVE CHANS IN LH
U 3650, 3651,2441,0716,4170,4007,0700,4000,0000,0000	; 7430	LDPI2:	[T0]_-1, HOLD LEFT	;DONT MASK RH
U 3651, 3652,4111,1416,4174,4007,0700,0000,0000,0000	; 7431		[T0]_[T0].AND.[PI]	;ONLY REQUEST CHANS THAT ARE ON
							; 7432		.NOT.[T0], LOAD PI,	;RELOAD HARDWARE
U 3652, 0010,7443,1600,4174,4434,1700,0000,0000,0000	; 7433		 RETURN [10]		;RETURN TO CALLER
							; 7434	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 204
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7435	.TOC	"IO -- INTERNAL DEVICES -- SUBROUTINES"
							; 7436	
							; 7437	
							; 7438	;HERE WITH SOMETHING IN BR STORE IT @AR
U 3653, 3654,3443,0300,4174,4007,0700,0200,0003,0012	; 7439	RTNREG:	VMA_[AR], START WRITE
U 3654, 1400,3333,0005,4175,5007,0701,0200,0000,0002	; 7440	RTNRG1:	MEM WRITE, MEM_[BR], J/DONE
							; 7441	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 205
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7442	;CACHE SWEEP
							; 7443	
							; 7444	1722:
							; 7445	CLRPT:	VMA_[AR],		;PUT CORRECT ADDRESS IN VMA
U 1722, 3655,3443,0300,4174,4147,0700,0200,0000,0010	; 7446		LOAD PAGE TABLE		;GET SET TO WRITE PAGE TABLE
U 3655, 2426,4221,0003,4174,4007,0700,0000,0000,0000	; 7447		[AR]_0			;CLEAR ENTRY
							; 7448	=0	[AR]_#,#/377377,	;INITIAL VMA VALUE
U 2426, 3661,3771,0003,4374,4007,0700,0010,0037,7377	; 7449		CALL [SSWEEP]		;LOAD THE SC
							; 7450		[BR]_#, #/1001,		;CONSTANT TO KEEP ADDING
U 2427, 3656,3771,0005,4374,4247,0700,0000,0000,1001	; 7451		CLRCSH			;START TO CLEAR CACHE
U 3656, 2430,3333,0003,4174,4247,0700,0000,0000,1000	; 7452		READ [AR], CLRCSH	;FIRST THING TO CLEAR
							; 7453	=0
							; 7454	CLRPTL:	[AR]_[AR]-[BR],		;UPDATE AR (AND PUT ON DP)
							; 7455		CLRCSH,			;SWEEP ON NEXT STEP
							; 7456		STEP SC,		;SKIP IF WE ARE DONE
U 2430, 2430,1111,0503,4174,4247,0630,6000,0060,1000	; 7457		J/CLRPTL		;LOOP FOR ALL ENTRIES
U 2431, 2435,3333,0003,4174,4007,0700,0000,0000,0000	; 7458		READ [AR], J/ZAPPTA	;CLEAR LAST ENTRY
							; 7459	
							; 7460	=0
							; 7461	SWEEP:	[AR]_#,#/377377,	;INITIAL VMA VALUE
U 2432, 3661,3771,0003,4374,4007,0700,0010,0037,7377	; 7462		CALL [SSWEEP]		;LOAD NUMBER OF STEPS INTO SC
							; 7463		[BR]_#, #/1001,		;CONSTANT TO KEEP ADDING
U 2433, 3657,3771,0005,4374,4347,0700,0000,0000,1001	; 7464		SWEEP			;START SWEEP
U 3657, 2434,3333,0003,4174,4347,0700,0000,0000,1000	; 7465		READ [AR], SWEEP	;FIRST THING TO CLEAR
							; 7466	=0
							; 7467	SWEEPL:	[AR]_[AR]-[BR],		;UPDATE AR (AND PUT ON DP)
							; 7468		SWEEP,			;SWEEP ON NEXT STEP
							; 7469		STEP SC,		;SKIP IF WE ARE DONE
U 2434, 2434,1111,0503,4174,4347,0630,6000,0060,1000	; 7470		J/SWEEPL		;LOOP FOR ALL ENTRIES
							; 7471					;CLEAR LAST ENTRY AND
U 2435, 3660,4223,0000,7174,4007,0700,0400,0000,0424	; 7472	ZAPPTA:	WORK[PTA.U]_0		; FORGET PAGE TABLE ADDRESS
							; 7473		WORK[PTA.E]_0,		;FORGET PAGE TABLE ADDRESS
U 3660, 1400,4223,0000,7174,4007,0700,0400,0000,0423	; 7474		J/DONE			;ALL DONE
							; 7475	
							; 7476	SSWEEP:	SC_S#, S#/375,		;NUMBER OF STEPS
U 3661, 0001,4443,0000,4174,4004,1700,2000,0071,0375	; 7477		RETURN [1]		;RETURN
							; 7478	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 206
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7479	;WE COME HERE EITHER FROM NEXT INSTRUCTION DISPATCH OR PAGE FAIL
							; 7480	; LOGIC. IN ALL CASES, THE CURRENT INSTRUCTION IS CORRECTLY SETUP
							; 7481	; TO RESTART PROPERLY.
							; 7482	
							; 7483	;FIRST SET THE CORRECT PI IN PROGRESS BIT
							; 7484	;	[FLG]_[FLG].OR.#,FLG.PI/1, HOLD RIGHT,
							; 7485	;		J/PI		;SET PI CYCLE AND PROCESS PI
							; 7486	=1000
							; 7487	PI:	AD/D, DBUS/PI NEW,	;LOOK AT NEW LEVEL
							; 7488		DISP/DP LEFT, 3T,	;DISPATCH ON IT
U 0770, 0770,3773,0000,4074,4003,1701,0000,0000,0000	; 7489		J/PI			;GO TO 1 OF NEXT 7 PLACES
U 0771, 3662,3551,1414,4370,4007,0700,0000,0004,0000	; 7490	=1001	[PI]_[PI].OR.#, #/040000, HOLD LEFT, J/PIP1
U 0772, 3663,3551,1414,4370,4007,0700,0000,0002,0000	; 7491	=1010	[PI]_[PI].OR.#, #/020000, HOLD LEFT, J/PIP2
U 0773, 3664,3551,1414,4370,4007,0700,0000,0001,0000	; 7492	=1011	[PI]_[PI].OR.#, #/010000, HOLD LEFT, J/PIP3
U 0774, 3665,3551,1414,4370,4007,0700,0000,0000,4000	; 7493	=1100	[PI]_[PI].OR.#, #/004000, HOLD LEFT, J/PIP4
U 0775, 3666,3551,1414,4370,4007,0700,0000,0000,2000	; 7494	=1101	[PI]_[PI].OR.#, #/002000, HOLD LEFT, J/PIP5
U 0776, 3667,3551,1414,4370,4007,0700,0000,0000,1000	; 7495	=1110	[PI]_[PI].OR.#, #/001000, HOLD LEFT, J/PIP6
U 0777, 3670,3551,1414,4370,4007,0700,0000,0000,0400	; 7496	=1111	[PI]_[PI].OR.#, #/000400, HOLD LEFT, J/PIP7
U 3662, 3671,4751,1206,4374,4007,0700,0000,0000,0001	; 7497	PIP1:	[BRX]_0 XWD [1], J/PI10	;REMEMBER WE ARE AT LEVEL 1
U 3663, 3671,4751,1206,4374,4007,0700,0000,0000,0002	; 7498	PIP2:	[BRX]_0 XWD [2], J/PI10	;REMEMBER WE ARE AT LEVEL 2
U 3664, 3671,4751,1206,4374,4007,0700,0000,0000,0003	; 7499	PIP3:	[BRX]_0 XWD [3], J/PI10	;REMEMBER WE ARE AT LEVEL 3
U 3665, 3671,4751,1206,4374,4007,0700,0000,0000,0004	; 7500	PIP4:	[BRX]_0 XWD [4], J/PI10	;REMEMBER WE ARE AT LEVEL 4
U 3666, 3671,4751,1206,4374,4007,0700,0000,0000,0005	; 7501	PIP5:	[BRX]_0 XWD [5], J/PI10	;REMEMBER WE ARE AT LEVEL 5
U 3667, 3671,4751,1206,4374,4007,0700,0000,0000,0006	; 7502	PIP6:	[BRX]_0 XWD [6], J/PI10	;REMEMBER WE ARE AT LEVEL 6
U 3670, 3671,4751,1206,4374,4007,0700,0000,0000,0007	; 7503	PIP7:	[BRX]_0 XWD [7], J/PI10	;REMEMBER WE ARE AT LEVEL 7
							; 7504	
							; 7505	PI10:	[AR]_[PI].AND.# CLR LH,	;TURN OFF PI SYSTEM
U 3671, 3672,4251,1403,4374,4007,0700,0000,0007,7577	; 7506		#/077577		; TILL WE ARE DONE
U 3672, 3673,7443,0300,4174,4437,0700,0000,0000,0000	; 7507		.NOT.[AR], LOAD PI	;  ..
U 3673, 2436,4223,0000,4364,4277,0700,0200,0000,0010	; 7508		ABORT MEM CYCLE		;NO MORE TRAPS
							; 7509	=0	[AR]_VMA IO READ,	;SETUP TO READ WRU BITS
							; 7510		WRU CYCLE/1,		; ..
U 2436, 3726,4571,1203,4374,4007,0700,0010,0024,1300	; 7511		CALL [STRTIO]		;START THE CYCLE
							; 7512		MEM READ,		;WAIT FOR DATA
							; 7513		[AR]_IO DATA, 3T,	;PUT DATA IN AR
U 2437, 2440,3771,0003,4364,4007,0331,0200,0000,0002	; 7514		SKIP ADR.EQ.0		;SEE IF ANYONE THERE
U 2440, 3702,4221,0004,4174,4007,0700,0000,0000,0000	; 7515	=0	[ARX]_0, J/VECINT	;YES--VECTORED INTERRUPT
U 2441, 3674,3445,0603,4174,4007,0700,0000,0000,0000	; 7516		[AR]_[BRX]*2		;N*2
							; 7517		[AR]_[AR]+#, #/40, 3T,	;2*N+40
U 3674, 3675,0551,0303,4370,4007,0701,0000,0000,0040	; 7518		HOLD LEFT		; ..
							; 7519		[AR]_[AR]+[EBR],	;ABSOULTE ADDRESS OF 
U 3675, 3676,0111,1003,4174,4007,0700,0000,0000,0000	; 7520		J/PI40			; INTERRUPT INSTRUCTION
							; 7521	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 207
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7522	;HERE WITH ABSOLUTE ADDRESS OF INTERRUPT INSTRUCTION IN [AR]
U 3676, 3677,3443,0300,4174,4007,0700,0200,0024,1016	; 7523	PI40:	VMA_[AR], VMA PHYSICAL READ	;FETCH THE INSTRUCTION
							; 7524	PI50:	MEM READ, [AR]_MEM, LOAD VMA,	;FETCH INSTRUCTION
U 3677, 3700,3771,0003,4365,5007,0701,0200,0020,0012	; 7525		3T, FORCE EXEC			;E IS EXEC MODE
U 3700, 2442,6553,0300,4374,4007,0321,0000,0025,4340	; 7526		[AR].XOR.#, #/254340, 3T, SKIP ADL.EQ.0
U 2442, 2444,6553,0300,4374,4007,0321,0000,0026,4000	; 7527	=0	[AR].XOR.#, #/264000, SKIP ADL.EQ.0, 3T, J/PIJSR
U 2443, 3701,4521,1205,4074,4007,0700,0000,0000,0000	; 7528		[BR]_FLAGS			;SAVE FLAGS
							; 7529		AD/ZERO, LOAD FLAGS,
U 3701, 0060,4223,0000,4174,4467,0700,0000,0000,0004	; 7530		J/PIXPCW			;ENTER EXEC MODE AND ASSUME
							; 7531						; WE HAVE AN XPCW
							; 7532	;IF WE HALT HERE ON A VECTORED INTERRUPT, WE HAVE
							; 7533	;	T0/ WHAT WE READ FROM BUS AS VECTOR
							; 7534	;	ARX/ EPT+100+DEVICE
							; 7535	;	BR/  ADDRESS OF ILLEGAL INSTRUCTION
							; 7536	;	BRX/ VECTOR (MASKED AND SHIFTED)
							; 7537	=0
U 2444, 0104,4751,1217,4374,4007,0700,0000,0000,0101	; 7538	PIJSR:	HALT [ILLII]			;NOT A JSR OR XPCW
U 2445, 0470,4443,0000,4174,4007,0700,0200,0023,0002	; 7539		START WRITE, FORCE EXEC		;PREPARE TO STORE OLD PC
							; 7540	=0*0	[BR]_PC WITH FLAGS,		;OLD PC
U 0470, 3727,3741,0105,4074,4007,0700,0010,0000,0000	; 7541		CALL [STOBR]			;STORE OLD PC
							; 7542	=1*0	[AR]_#, #/0, HOLD RIGHT,		;PREPARE TO CLEAR FLAGS
U 0474, 3724,3771,0003,4374,0007,0700,0010,0000,0000	; 7543		CALL [INCAR]			;BUMP POINTER
							; 7544	=1*1	[PC]_[AR], LOAD FLAGS,		;NEW PC
U 0475, 2721,3441,0301,4174,4467,0700,0000,0000,0004	; 7545		J/PISET				;CLEAR PI CYCLE & START
							; 7546						; INTERRUPT PROGRAM
							; 7547	=
							; 7548	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 208
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7549	;HERE TO PROCESS A VECTORED INTERRUPT. AT THIS POINT:
							; 7550	;	AR/ WRU BITS (BIT 18 FOR DEVICE 0)
							; 7551	;	ARX/ 0
							; 7552	VECINT:	[AR]_[AR]*2,		;SHIFT LEFT (UNSHIFTED ON DP)
U 3702, 2446,3445,0303,4174,4007,0530,0000,0000,0000	; 7553		SKIP DP18		;ANYONE THERE?
							; 7554	=0	[ARX]_[ARX]+[XWD1],	;NO--BUMP BOTH HALVES
U 2446, 3702,0111,1504,4174,4007,0700,0000,0000,0000	; 7555		J/VECINT		;KEEP LOOKING
							; 7556		[AR]_VMA IO READ,	;SETUP FOR VECTOR CYCLE
U 2447, 2450,4571,1203,4374,4007,0700,0000,0024,1240	; 7557		VECTOR CYCLE/1		; ..
							; 7558	=0	[AR]_[AR].OR.[ARX],	;PUT IN UNIT NUMBER
U 2450, 3726,3111,0403,4174,4007,0700,0010,0000,0000	; 7559		CALL [STRTIO]		;START CYCLE
							; 7560		MEM READ,		;WAIT FOR VECTOR (SEE DPM5)
U 2451, 2452,3771,0016,4364,4007,0700,0200,0000,0002	; 7561		[T0]_IO DATA		;GET VECTOR
							; 7562	=0	[BR]_[EBR]+#, 3T, #/100,	;EPT+100
U 2452, 3723,0551,1005,4374,4007,0701,0010,0000,0100	; 7563		CALL [CLARXL]		;CLEAR ARX LEFT
							; 7564		[ARX]_[ARX]+[BR],	;EPT+100+DEVICE
U 2453, 3703,0111,0504,4174,4007,0700,0200,0024,1016	; 7565		VMA PHYSICAL READ	;FETCH WORD
							; 7566		MEM READ, [BR]_MEM, 3T,	;GET POINTER
U 3703, 2454,3771,0005,4365,5007,0331,0200,0000,0002	; 7567		SKIP ADR.EQ.0		;SEE IF NON-ZERO
							; 7568	=0	[BRX]_([T0].AND.#)*.5, 3T, ;OK--MAKE VECTOR MOD 400
U 2454, 3704,4557,1606,4374,4007,0701,0000,0000,0774	; 7569		#/774, J/VECIN1		; AND SHIFT OVER
U 2455, 0104,4751,1217,4374,4007,0700,0000,0000,0102	; 7570		HALT [ILLINT]
U 3704, 3705,3447,0606,4174,4007,0700,0000,0000,0000	; 7571	VECIN1:	[BRX]_[BRX]*.5		;SHIFT 1 MORE PLACE
							; 7572		[BR]_[BR]+[BRX],	;ADDRESS OF WORD TO USE
							; 7573		LOAD VMA, FORCE EXEC,	;FORCE EXEC VIRTUAL ADDRESS
U 3705, 3677,0111,0605,4174,4007,0700,0200,0024,0012	; 7574		START READ, J/PI50	;GO GET INSTRUCTION
							; 7575	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 209
; INOUT.MIC[1,2]	13:32 7-JAN-1986			PRIORITY INTERRUPTS -- DISMISS SUBROUTINE		

							; 7576	.TOC	"PRIORITY INTERRUPTS -- DISMISS SUBROUTINE"
							; 7577	
							; 7578	;SUBROUTINE TO DISMISS THE HIGHEST PI IN PROGRESS
							; 7579	;RETURNS 4 ALWAYS
							; 7580	
							; 7581	;DISMISS:
							; 7582	;	TR [PI], #/077400	;ANY PI IN PROGRESS?
							; 7583	=0
U 2456, 3706,3771,0005,4374,4007,0700,0000,0004,0000	; 7584	JEN1:	[BR]_#, PI.IP1/1, J/DSMS1 ;YES--START LOOP
U 2457, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 7585		RETURN [4]		;NO--JUST RETURN
							; 7586	
U 3706, 2460,4113,0514,4174,4007,0330,0000,0000,0000	; 7587	DSMS1:	[PI].AND.[BR], SKIP ADR.EQ.0
U 2460, 0004,5111,0514,4170,4004,1700,0000,0000,0000	; 7588	=0	[PI]_[PI].AND.NOT.[BR], HOLD LEFT, RETURN [4]
U 2461, 3706,3447,0505,4174,4007,0700,0000,0000,0000	; 7589		[BR]_[BR]*.5, J/DSMS1
							; 7590	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 210
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7591	.TOC	"EXTERNAL IO INSTRUCTIONS"
							; 7592	
							; 7593		.DCODE
D 0710, 1210,1614,0100					; 7594	710:	IOT,	WORD-TNE,	J/TIOX
D 0711, 1214,1614,0100					; 7595	711:	IOT,	WORD-TNN,	J/TIOX
D 0720, 1200,1614,0100					; 7596	720:	IOT,	TNE,		J/TIOX
D 0721, 1204,1614,0100					; 7597	721:	IOT,	TNN,		J/TIOX
							; 7598		.UCODE
							; 7599	
							; 7600	1614:
U 1614, 2462,4443,0000,4174,4007,0700,0010,0000,0000	; 7601	TIOX:	CALL [IORD]
U 1617, 0014,4551,0305,0274,4003,7700,0000,0000,0000	; 7602	1617:	[BR]_[AR].AND.AC, TEST DISP
							; 7603	
							; 7604		.DCODE
D 0712, 1210,1460,0100					; 7605	712:	IOT,	B/10,		J/RDIO
D 0713, 1210,1461,0100					; 7606	713:	IOT,	B/10,		J/WRIO
D 0722, 1200,1460,0100					; 7607	722:	IOT,	B/0,		J/RDIO
D 0723, 1200,1461,0100					; 7608	723:	IOT,	B/0,		J/WRIO
							; 7609		.UCODE
							; 7610	
							; 7611	1460:
U 1460, 2462,4443,0000,4174,4007,0700,0010,0000,0000	; 7612	RDIO:	CALL [IORD]
U 1463, 1400,3440,0303,0174,4007,0700,0400,0000,0000	; 7613	1463:	AC_[AR], J/DONE
							; 7614	
							; 7615	1461:
U 1461, 2472,3771,0005,0276,6007,0700,0000,0000,0000	; 7616	WRIO:	[BR]_AC, J/IOWR
							; 7617	
							; 7618		.DCODE
D 0714, 1210,1644,0100					; 7619	714:	IOT,		B/10,	J/BIXUB
D 0715, 1214,1644,0100					; 7620	715:	IOT,		B/14,	J/BIXUB
D 0724, 1200,1644,0100					; 7621	724:	IOT,		B/0,	J/BIXUB
D 0725, 1204,1644,0100					; 7622	725:	IOT,		B/4,	J/BIXUB
							; 7623		.UCODE
							; 7624	
							; 7625	1644:
							; 7626	BIXUB:	[BRX]_[AR],		;SAVE EFFECTIVE ADDRESS
U 1644, 2462,3441,0306,4174,4007,0700,0010,0000,0000	; 7627		CALL [IORD]		;GO GET THE DATA
							; 7628	1647:	[BR]_[AR],		;COPY DATA ITEM
U 1647, 1013,3441,0305,4174,4003,7700,0000,0000,0000	; 7629		B DISP			;SEE IF SET OR CLEAR
							; 7630	=1011	[BR]_[BR].OR.AC,	;SET BITS
U 1013, 3707,3551,0505,0274,4007,0700,0000,0000,0000	; 7631		J/BIXUB1		;GO DO WRITE
							; 7632		[BR]_[BR].AND.NOT.AC,	;CLEAR BITS
U 1017, 3707,5551,0505,0274,4007,0700,0000,0000,0000	; 7633		J/BIXUB1		;GO DO WRITE
							; 7634	
							; 7635	BIXUB1:	[AR]_[BRX],		;RESTORE ADDRESS
U 3707, 2472,3441,0603,4174,4007,0700,0000,0000,0000	; 7636		J/IOWR
							; 7637	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 211
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7638	;SUBROUTINE TO READ FROM AN IO DEVICE
							; 7639	;CALL WITH:
							; 7640	;	SECTION 0 EFFECTIVE ADDRESS IN AR
							; 7641	;	INSTRUCTION IN HR
							; 7642	;RETURN 3 WITH WORD OR BYTE IN AR
							; 7643	;
							; 7644	=0
							; 7645	IORD:	CLR IO BUSY,		;CLEAR BUSY
U 2462, 2502,4443,0000,4174,4137,0700,0010,0000,0000	; 7646		CALL [IOEA]		;COMPUTE IO EA
U 2463, 0067,4443,0000,4174,4003,7700,0000,0000,0000	; 7647		B DISP
							; 7648	=10111	[BR]_VMA IO READ,	;BYTE MODE
							; 7649		IO BYTE/1,		;SET BYTE FLAG
U 0067, 2464,4571,1205,4374,4007,0700,0000,0024,1220	; 7650		J/IORD1			;GO DO C/A CYCLE
U 0077, 2464,4571,1205,4374,4007,0700,0000,0024,1200	; 7651	=11111	[BR]_VMA IO READ	;WORD MODE
							; 7652	=
							; 7653	=0
							; 7654	IORD1:	VMA_[AR].OR.[BR] WITH FLAGS,
U 2464, 3716,3113,0305,4174,4007,0701,0210,0000,0036	; 7655		CALL [IOWAIT]		;WAIT FOR THINGS COMPLETE
							; 7656		MEM READ,		;MAKE SURE REALLY READY
							; 7657		[BR]_IO DATA,		;PUT DATA IN BR
U 2465, 1027,3771,0005,4364,4003,7700,0200,0000,0002	; 7658		B DISP			;SEE IF BYTE MODE
U 1027, 2466,4553,0300,4374,4007,0331,0000,0000,0001	; 7659	=0111	TR [AR], #/1, J/IORD2	;BYTE MODE SEE IF ODD
U 1037, 0003,3441,0503,4174,4004,1700,0000,0000,0000	; 7660		[AR]_[BR], RETURN [3]	;ALL DONE
							; 7661	
							; 7662	;HERE ON WORD MODE
							; 7663	=0
							; 7664	IORD2:	[BR]_[BR]*.5, SC_5,	;LEFT BYTE
U 2466, 2470,3447,0505,4174,4007,0700,2000,0071,0005	; 7665		J/IORD3			;GO SHIFT IT
							; 7666		[AR]_[BR].AND.#,	;MASK IT
U 2467, 0003,4551,0503,4374,4004,1700,0000,0000,0377	; 7667		#/377, RETURN [3]	;ALL DONE
							; 7668	
							; 7669	=0
							; 7670	IORD3:	[BR]_[BR]*.5,		;SHIFT OVER 
U 2470, 2470,3447,0505,4174,4007,0630,2000,0060,0000	; 7671		STEP SC, J/IORD3	; ..
							; 7672		[AR]_[BR].AND.#,	;MASK IT
U 2471, 0003,4551,0503,4374,4004,1700,0000,0000,0377	; 7673		#/377, RETURN [3]	;ALL DONE
							; 7674	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 212
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7675	;ROUTINE TO WRITE TO AN IO DEVICE
							; 7676	;CALL WITH:
							; 7677	;	SECTION 0 EFFECTIVE ADDRESS IN AR
							; 7678	;	INSTRUCTION IN HR
							; 7679	;	WORD OR BYTE IN BR
							; 7680	;RETURNS BACK TO USER
							; 7681	;
							; 7682	=0
							; 7683	IOWR:	CLR IO BUSY,		;CLEAR BUSY
U 2472, 2502,4443,0000,4174,4137,0700,0010,0000,0000	; 7684		CALL [IOEA]		;COMPUTE IO EA
U 2473, 0227,4443,0000,4174,4003,7700,0000,0000,0000	; 7685		B DISP
U 0227, 2476,4553,0300,4374,4007,0331,0000,0000,0001	; 7686	=10111	TR [AR], #/1, J/IOWR2	;BYTE MODE
U 0237, 3710,4571,1204,4374,4007,0700,0000,0021,1200	; 7687	=11111	[ARX]_VMA IO WRITE	;SETUP FLAGS
							; 7688	=
U 3710, 2474,3113,0304,4174,4007,0701,0200,0000,0036	; 7689	IOWR1:	VMA_[AR].OR.[ARX] WITH FLAGS
							; 7690	=0	MEM WRITE, MEM_[BR],	;SEND DATA
U 2474, 3716,3333,0005,4175,5007,0701,0210,0000,0002	; 7691		CALL [IOWAIT]		;WAIT FOR DATA
U 2475, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 7692		DONE			;RETURN
							; 7693	
							; 7694	;HERE FOR BYTE MODE
							; 7695	=0
							; 7696	IOWR2:	[BR]_[BR]*2, SC_5,	;ODD--MOVE LEFT
U 2476, 2500,3445,0505,4174,4007,0700,2000,0071,0005	; 7697		J/IOWR3			; ..
							; 7698		[ARX]_VMA IO WRITE,	;SETUP FLAGS
U 2477, 3710,4571,1204,4374,4007,0700,0000,0021,1220	; 7699		IO BYTE/1, J/IOWR1	; ..
							; 7700	
							; 7701	=0
							; 7702	IOWR3:	[BR]_[BR]*2, STEP SC,	;SHIFT LEFT
U 2500, 2500,3445,0505,4174,4007,0630,2000,0060,0000	; 7703		J/IOWR3			;KEEP SHIFTING
							; 7704		[ARX]_VMA IO WRITE,	;SETUP FLAGS
U 2501, 3710,4571,1204,4374,4007,0700,0000,0021,1220	; 7705		IO BYTE/1, J/IOWR1	; ..
							; 7706	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 213
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7707	;HERE TO COMPUTE IO EFFECTIVE ADDRESS
							; 7708	;CALL WITH:
							; 7709	;	SECTION 0 EFFECTIVE ADDRESS IN AR
							; 7710	;	INSTRUCTION IN HR
							; 7711	;RETURN 1 WITH EA IN AR
							; 7712	;
							; 7713	=0
							; 7714	IOEA:	VMA_[PC]-1,		;GET INSTRUCTION
							; 7715		START READ,		; ..
U 2502, 3720,1113,0701,4170,4007,0700,4210,0004,0012	; 7716		CALL [LOADAR]		;PUT WORD IN AR
U 2503, 3711,7441,0306,4174,4007,0700,0000,0000,0000	; 7717		[BRX]_.NOT.[AR]		;SEE IF IN RANGE 700-777
U 3711, 2504,4553,0600,4374,4007,0321,0000,0070,0000	; 7718		TL [BRX], #/700000	; ..
							; 7719	=0
U 2504, 2506,4553,0200,4374,4007,0321,0000,0000,0020	; 7720	IOEA1:	TL [HR], #/20, J/IOEA2	;INDIRECT?
							; 7721		WORK[YSAVE]_[AR] CLR LH, ;DIRECT IO INSTRUCTION
U 2505, 2504,4713,1203,7174,4007,0700,0400,0000,0422	; 7722		J/IOEA1			;SAVE Y FOR EA CALCULATION
							; 7723	=0
							; 7724	IOEA2:	[AR]_WORK[YSAVE],	;@--GET SAVED Y
U 2506, 3712,3771,0003,7274,4007,0701,0000,0000,0422	; 7725		J/IOEAI			;GET Y AND GO
U 2507, 1055,4443,0000,2174,4006,6700,0000,0000,0000	; 7726		EA MODE DISP		;WAS THERE INDEXING?
							; 7727	=1101	[ARX]_XR, SKIP ADL.LE.0, ;SEE IF LOCAL OR GLOBAL INDEXING
U 1055, 2512,3771,0004,2274,4007,0120,0000,0000,0000	; 7728		2T, J/IOEAX		; ..
							; 7729		[AR]_WORK[YSAVE],	;JUST PLAIN IO
U 1057, 0001,3771,0003,7274,4124,1701,0000,0000,0422	; 7730		CLR IO LATCH, RETURN [1]
							; 7731	
							; 7732	IOEAI:	READ [HR], DBUS/DP,	;LOAD XR FLOPS IN CASE
U 3712, 3713,3333,0002,4174,4217,0700,0000,0000,0000	; 7733		LOAD INST EA		; THERE IS INDEXING
U 3713, 2510,4553,0200,4374,4007,0321,0000,0000,0017	; 7734		TL [HR], #/17		;WAS THERE ALSO INDEXING
U 2510, 2511,0551,0303,2270,4007,0701,0000,0000,0000	; 7735	=0	[AR]_[AR]+XR, 3T, HOLD LEFT ;YES--ADD IN INDEX VALUE
U 2511, 3714,3443,0300,4174,4007,0700,0200,0004,0012	; 7736		VMA_[AR], START READ	;FETCH DATA WORD
							; 7737		MEM READ, [AR]_MEM,	;GO GET DATA WORD
U 3714, 0001,3771,0003,4365,5124,1700,0200,0000,0002	; 7738		CLR IO LATCH, RETURN [1]
							; 7739	
							; 7740	=0
							; 7741	IOEAX:	[AR]_[ARX]+WORK[YSAVE],	;GLOBAL INDEXING
U 2512, 0001,0551,0403,7274,4124,1701,0000,0000,0422	; 7742		CLR IO LATCH, RETURN [1]
U 2513, 3715,0551,0403,7274,4007,0701,0000,0000,0422	; 7743		[AR]_[ARX]+WORK[YSAVE]	;LOCAL INDEXING
							; 7744		[AR]_0, HOLD RIGHT,
U 3715, 0001,4221,0003,4174,0124,1700,0000,0000,0000	; 7745		CLR IO LATCH, RETURN [1]
							; 7746	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 214
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7747	;WAIT FOR IO TO COMPLETE
							; 7748	;RETURNS 1 OR PAGE FAILS
							; 7749	;
							; 7750	IOWAIT:	SC_S#, S#/200,		;DELAY
							; 7751		[T0]_VMA,		;GET VMA
U 3716, 1134,3771,0016,4354,4007,0650,2000,0071,0200	; 7752		SKIP/-IO BUSY		;SEE IF BUSY YET
							; 7753	=00
							; 7754	IOW1:	CLR IO LATCH,		;WENT BUSY
							; 7755		WORK[SV.VMA]_[T0],	;MAKE SURE SV.VMA IS SETUP
U 1134, 3717,3333,0016,7174,4127,0700,0400,0000,0210	; 7756		J/IOW2			;WAIT FOR IT TO CLEAR
							; 7757		SC_SC-1, SCAD DISP, 5T,	;SEE IF DONE YET
							; 7758		SKIP/-IO BUSY,		; ..
U 1135, 1134,4443,0000,4174,4006,7653,2000,0060,0000	; 7759		J/IOW1			;BACK TO LOOP
							; 7760		CLR IO LATCH,		;WENT BUSY AND TIMEOUT
							; 7761		WORK[SV.VMA]_[T0],	;MAKE SURE SV.VMA IS SETUP
U 1136, 3717,3333,0016,7174,4127,0700,0400,0000,0210	; 7762		J/IOW2			; ..
							; 7763		WORK[SV.VMA]_[T0],	;MAKE SURE SV.VMA IS SETUP
U 1137, 2517,3333,0016,7174,4007,0700,0400,0000,0210	; 7764		J/IOW5			;GO TRAP
							; 7765	
							; 7766	IOW2:	SC_S#, S#/777,		;GO TIME IO
U 3717, 2514,4443,0000,4174,4007,0650,2000,0071,0777	; 7767		SKIP/-IO BUSY		; ..
							; 7768	=0
							; 7769	IOW3:	CLR IO LATCH,		;TRY TO CLEAR LATCH
U 2514, 2516,4443,0000,4174,4127,0630,2000,0060,0000	; 7770		STEP SC, J/IOW4		;STILL BUSY
U 2515, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 7771		RETURN [1]		;IDLE
							; 7772	
							; 7773	=0
							; 7774	IOW4:	CLR IO LATCH, 5T,	;TRY TO CLEAR LATCH
							; 7775		SKIP/-IO BUSY,		;SEE IF STILL BUSY
U 2516, 2514,4443,0000,4174,4127,0653,0000,0000,0000	; 7776		J/IOW3			; ..
U 2517, 4043,4571,1206,4374,4007,0700,0000,0020,0000	; 7777	IOW5:	[BRX]_[200000] XWD 0, J/HARD
							; 7778	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 215
; INOUT.MIC[1,2]	13:32 7-JAN-1986			SMALL SUBROUTINES					

							; 7779	.TOC	"SMALL SUBROUTINES"
							; 7780	
							; 7781	;HERE ARE A COLLECTION ON 1-LINE SUBROUTINES
							; 7782	LOADAR:	MEM READ, [AR]_MEM,	;FROM MEMORY TO AR
U 3720, 0001,3771,0003,4365,5004,1700,0200,0000,0002	; 7783		RETURN [1]		;RETURN TO CALLER
							; 7784	
U 3721, 0001,3771,0004,4365,5004,1700,0200,0000,0002	; 7785	LOADARX: MEM READ, [ARX]_MEM, RETURN [1]
							; 7786	
U 3722, 0001,3772,0000,4365,5004,1700,0200,0000,0002	; 7787	LOADQ:	MEM READ, Q_MEM, RETURN [1]
							; 7788	
U 3723, 0001,4221,0004,4174,0004,1700,0000,0000,0000	; 7789	CLARXL:	[ARX]_0, HOLD RIGHT, RETURN [1]
							; 7790	
U 3724, 0001,0111,0703,4174,4004,1700,0000,0000,0000	; 7791	INCAR:	[AR]_[AR]+1, RETURN [1]
							; 7792	
U 3725, 0001,3445,0505,4174,4004,1700,0000,0000,0000	; 7793	SBRL:	[BR]_[BR]*2, RETURN [1]
							; 7794	
U 3726, 0001,3443,0300,4174,4004,1701,0200,0000,0036	; 7795	STRTIO:	VMA_[AR] WITH FLAGS, RETURN [1]
							; 7796	
U 3727, 0004,3333,0005,4175,5004,1701,0200,0000,0002	; 7797	STOBR:	MEM WRITE, MEM_[BR], RETURN [4]
							; 7798	
U 3730, 0001,3333,0001,4175,5004,1701,0200,0000,0002	; 7799	STOPC:	MEM WRITE, MEM_[PC], RETURN [1]
							; 7800	
U 3731, 0001,3440,0404,0174,4004,1700,0400,0000,0000	; 7801	AC_ARX:	AC_[ARX], RETURN [1]
							; 7802	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 216
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UNDEFINED IO INSTRUCTIONS				

							; 7803	.TOC	"UNDEFINED IO INSTRUCTIONS"
							; 7804	
							; 7805		.DCODE
D 0703, 0003,1650,2100					; 7806	703:	I,	B/3,	J/IOT700
D 0706, 0006,1650,2100					; 7807	706:	I,	B/6,	J/IOT700
D 0707, 0007,1650,2100					; 7808		I,	B/7,	J/IOT700
							; 7809	
D 0716, 0006,1651,2100					; 7810	716:	I,	B/6,	J/IOT710
D 0717, 0007,1651,2100					; 7811		I,	B/7,	J/IOT710
							; 7812	
D 0726, 0006,1652,2100					; 7813	726:	I,	B/6,	J/IOT720
D 0727, 0007,1652,2100					; 7814		I,	B/7,	J/IOT720
							; 7815	
D 0730, 0000,1653,2100					; 7816	730:	I,	B/0,	J/IOT730
D 0731, 0001,1653,2100					; 7817		I,	B/1,	J/IOT730
D 0732, 0002,1653,2100					; 7818		I,	B/2,	J/IOT730
D 0733, 0003,1653,2100					; 7819		I,	B/3,	J/IOT730
D 0734, 0004,1653,2100					; 7820		I,	B/4,	J/IOT730
D 0735, 0005,1653,2100					; 7821		I,	B/5,	J/IOT730
D 0736, 0006,1653,2100					; 7822		I,	B/6,	J/IOT730
D 0737, 0007,1653,2100					; 7823		I,	B/7,	J/IOT730
							; 7824	
D 0740, 0000,1654,2100					; 7825	740:	I,	B/0,	J/IOT740
D 0741, 0001,1654,2100					; 7826		I,	B/1,	J/IOT740
D 0742, 0002,1654,2100					; 7827		I,	B/2,	J/IOT740
D 0743, 0003,1654,2100					; 7828		I,	B/3,	J/IOT740
D 0744, 0004,1654,2100					; 7829		I,	B/4,	J/IOT740
D 0745, 0005,1654,2100					; 7830		I,	B/5,	J/IOT740
D 0746, 0006,1654,2100					; 7831		I,	B/6,	J/IOT740
D 0747, 0007,1654,2100					; 7832		I,	B/7,	J/IOT740
							; 7833	
D 0750, 0000,1655,2100					; 7834	750:	I,	B/0,	J/IOT750
D 0751, 0001,1655,2100					; 7835		I,	B/1,	J/IOT750
D 0752, 0002,1655,2100					; 7836		I,	B/2,	J/IOT750
D 0753, 0003,1655,2100					; 7837		I,	B/3,	J/IOT750
D 0754, 0004,1655,2100					; 7838		I,	B/4,	J/IOT750
D 0755, 0005,1655,2100					; 7839		I,	B/5,	J/IOT750
D 0756, 0006,1655,2100					; 7840		I,	B/6,	J/IOT750
D 0757, 0007,1655,2100					; 7841		I,	B/7,	J/IOT750
							; 7842	
D 0760, 0000,1656,2100					; 7843	760:	I,	B/0,	J/IOT760
D 0761, 0001,1656,2100					; 7844		I,	B/1,	J/IOT760
D 0762, 0002,1656,2100					; 7845		I,	B/2,	J/IOT760
D 0763, 0003,1656,2100					; 7846		I,	B/3,	J/IOT760
D 0764, 0004,1656,2100					; 7847		I,	B/4,	J/IOT760
D 0765, 0005,1656,2100					; 7848		I,	B/5,	J/IOT760
D 0766, 0006,1656,2100					; 7849		I,	B/6,	J/IOT760
D 0767, 0007,1656,2100					; 7850		I,	B/7,	J/IOT760
							; 7851	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 217
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UNDEFINED IO INSTRUCTIONS				

D 0770, 0000,1657,2100					; 7852	770:	I,	B/0,	J/IOT770
D 0771, 0001,1657,2100					; 7853		I,	B/1,	J/IOT770
D 0772, 0002,1657,2100					; 7854		I,	B/2,	J/IOT770
D 0773, 0003,1657,2100					; 7855		I,	B/3,	J/IOT770
D 0774, 0004,1657,2100					; 7856		I,	B/4,	J/IOT770
D 0775, 0005,1657,2100					; 7857		I,	B/5,	J/IOT770
D 0776, 0006,1657,2100					; 7858		I,	B/6,	J/IOT770
D 0777, 0007,1657,2100					; 7859		I,	B/7,	J/IOT770
							; 7860		.UCODE
							; 7861	
							; 7862	1650:
U 1650, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7863	IOT700:	UUO
							; 7864	1651:
							; 7865	IOT710:
							;;7866	.IFNOT/UBABLT
							;;7867		UUO
							; 7868	.IF/UBABLT
U 1651, 0674,4443,0000,4174,4007,0700,0000,0000,0000	; 7869		J/BLTX		;GO TO COMMON CODE FOR UBABLT INSTRS
							; 7870	.ENDIF/UBABLT
							; 7871	1652:
U 1652, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7872	IOT720:	UUO
							; 7873	1653:
U 1653, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7874	IOT730:	UUO
							; 7875	1654:
U 1654, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7876	IOT740:	UUO
							; 7877	1655:
U 1655, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7878	IOT750:	UUO
							; 7879	1656:
U 1656, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7880	IOT760:	UUO
							; 7881	1657:
U 1657, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7882	IOT770:	UUO
							; 7883	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 218
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UMOVE AND UMOVEM					

							; 7884	.TOC	"UMOVE AND UMOVEM"
							; 7885	
							; 7886		.DCODE
D 0704, 1200,1754,0100					; 7887	704:	IOT,	J/UMOVE
D 0705, 1200,1755,0100					; 7888		IOT,	J/UMOVEM
							; 7889		.UCODE
							; 7890	
							; 7891	1754:
							; 7892	UMOVE:	VMA_[AR],		;LOAD VMA
							; 7893		START READ,		;START MEMORY
U 1754, 3732,3443,0300,4174,4207,0700,0200,0004,0012	; 7894		SPEC/PREV		;FORCE PREVIOUS
							; 7895		MEM READ,		;WAIT FOR MEMORY
							; 7896		[AR]_MEM,		;PUT DATA IN AR
U 3732, 1515,3771,0003,4365,5007,0700,0200,0000,0002	; 7897		J/STAC			;GO PUT AR IN AC
							; 7898	
							; 7899	1755:
							; 7900	UMOVEM:	VMA_[AR],		;LOAD VMA
							; 7901		START WRITE,		;START MEMORY
U 1755, 3733,3443,0300,4174,4207,0700,0200,0003,0012	; 7902		SPEC/PREV		;FORCE PREVIOUS
							; 7903		[AR]_AC,		;FETCH AC
U 3733, 1516,3771,0003,0276,6007,0700,0000,0000,0000	; 7904		J/STMEM			;STORE IN MEMORY
							; 7905	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 219
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UMOVE AND UMOVEM					

							; 7906	;HERE WITH HALT CODE IN THE T1
							; 7907	=010*
							; 7908	HALTED:	WORK[SV.ARX]_[ARX],	;SAVE TEMP REGISTER
U 0104, 3736,3333,0004,7174,4007,0700,0410,0000,0212	; 7909		CALL [SAVVMA]		;PUT VMA IN WORK[SV.VMA]
							; 7910	=110*	ABORT MEM CYCLE,		;ABORT CYCLE IN PROGRESS
U 0114, 3735,4223,0000,4364,4277,0700,0210,0000,0010	; 7911		CALL [WRTHSB]		;WRITE HALT STATUS BLOCK
							; 7912	=111*
U 0116, 3734,4221,0004,4174,4007,0700,0200,0021,1016	; 7913	PWRON:	[ARX]_0, VMA PHYSICAL WRITE ;STORE HALT CODE
							; 7914	=
U 3734, 2520,3333,0017,4175,5007,0701,0200,0000,0002	; 7915		MEM WRITE, MEM_[T1]	; IN LOCATION 0
							; 7916	=0	NEXT [ARX] PHYSICAL WRITE,
U 2520, 3730,0111,0704,4170,4007,0700,0210,0023,1016	; 7917		CALL [STOPC]
U 2521, 0005,4443,0000,4174,4107,0700,0000,0000,0074	; 7918	H1:	SET HALT, J/HALTLP	;TELL CONSOLE WE HAVE HALTED
							; 7919	
							; 7920	
							; 7921	4:	UNHALT,			;RESET CONSOLE
U 0004, 2522,4443,0000,4174,4107,0640,0000,0000,0062	; 7922		SKIP EXECUTE, J/CONT	;SEE IF CO OR EX
							; 7923	5:
U 0005, 0004,4443,0000,4174,4007,0660,0000,0000,0000	; 7924	HALTLP:	SKIP/-CONTINUE, J/4	;WAIT FOR CONTINUE
							; 7925	
							; 7926	=0
							; 7927	CONT:	VMA_[PC],		;LOAD PC INTO VMA
							; 7928		FETCH,			;START READ
U 2522, 0117,3443,0100,4174,4007,0700,0200,0014,0012	; 7929		J/XCTGO			;DO THE INSTRUCTION
U 2523, 2524,4571,1203,4374,4007,0700,0000,0024,1200	; 7930		[AR]_VMA IO READ	;PUT FLAGS IN AR
							; 7931	=0	[AR]_[AR].OR.#,		;PUT IN ADDRESS
							; 7932		#/200000, HOLD LEFT,	; OF CSL REGISTER
U 2524, 3726,3551,0303,4370,4007,0700,0010,0020,0000	; 7933		CALL [STRTIO]
							; 7934	CONT1:	MEM READ,		;WAIT FOR DATA
							; 7935		[HR]_MEM,		;PUT IN HR
							; 7936		LOAD INST,		;LOAD IR, ETC.
U 2525, 2735,3771,0002,4365,5617,0700,0200,0000,0002	; 7937		J/XCT1			;GO DO THE INSTRUCTION
							; 7938	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 220
; INOUT.MIC[1,2]	13:32 7-JAN-1986			WRITE HALT STATUS BLOCK					

							; 7939	.TOC	"WRITE HALT STATUS BLOCK"
							; 7940	
							; 7941	;THE HALT STATUS BLOCK LOOKS LIKE:
							; 7942	
							; 7943	;	!=======================================================!
							; 7944	;	!00!                        MAG                         !
							; 7945	;	!-------------------------------------------------------!
							; 7946	;	!01!                         PC                         !
							; 7947	;	!-------------------------------------------------------!
							; 7948	;	!02!                         HR                         !
							; 7949	;	!-------------------------------------------------------!
							; 7950	;	!03!                         AR                         !
							; 7951	;	!-------------------------------------------------------!
							; 7952	;	!04!                        ARX                         !
							; 7953	;	!-------------------------------------------------------!
							; 7954	;	!05!                         BR                         !
							; 7955	;	!-------------------------------------------------------!
							; 7956	;	!06!                        BRX                         !
							; 7957	;	!-------------------------------------------------------!
							; 7958	;	!07!                        ONE                         !
							; 7959	;	!-------------------------------------------------------!
							; 7960	;	!10!                        EBR                         !
							; 7961	;	!-------------------------------------------------------!
							; 7962	;	!11!                        UBR                         !
							; 7963	;	!-------------------------------------------------------!
							; 7964	;	!12!                        MASK                        !
							; 7965	;	!-------------------------------------------------------!
							; 7966	;	!13!                        FLG                         !
							; 7967	;	!-------------------------------------------------------!
							; 7968	;	!14!                         PI                         !
							; 7969	;	!-------------------------------------------------------!
							; 7970	;	!15!                        XWD1                        !
							; 7971	;	!-------------------------------------------------------!
							; 7972	;	!16!                         T0                         !
							; 7973	;	!-------------------------------------------------------!
							; 7974	;	!17!                         T1                         !
							; 7975	;	!=======================================================!
							; 7976	;	!         VMA FLAGS         !            VMA            !
							; 7977	;	!=======================================================!
							; 7978	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 221
; INOUT.MIC[1,2]	13:32 7-JAN-1986			WRITE HALT STATUS BLOCK					

							; 7979	;START AT 1 TO DUMP 2901 REGISTERS INTO MAIN MEMORY
							; 7980	1:	WORK[SV.ARX]_[ARX],	;SAVE TEMP REGISTER
U 0001, 3736,3333,0004,7174,4007,0700,0410,0000,0212	; 7981		CALL [SAVVMA]		;WORK[SV.VMA]_VMA
U 0011, 0024,3771,0004,7274,4007,0701,0000,0000,0227	; 7982	11:	[ARX]_WORK[HSBADR]
U 0024, 3745,4223,0000,4364,4277,0700,0210,0000,0010	; 7983	=10*	ABORT MEM CYCLE, CALL [DUMP]
U 0026, 2521,4443,0000,4174,4107,0700,0000,0000,0074	; 7984		SET HALT, J/H1
							; 7985	
							; 7986	
							; 7987	WRTHSB:	[ARX]_WORK[HSBADR], ;GET ADDRESS OF HSB
U 3735, 2526,3771,0004,7274,4007,0422,0000,0000,0227	; 7988		SKIP AD.LE.0, 4T	;SEE IF VALID
							; 7989	=0	READ [MASK], LOAD PI,	;TURN OFF PI SYSTEM
U 2526, 3745,3333,0012,4174,4437,0700,0000,0000,0000	; 7990		J/DUMP			; AND GO TAKE DUMP
							; 7991		[ARX]_WORK[SV.ARX],
U 2527, 0002,3771,0004,7274,4004,1701,0000,0000,0212	; 7992		RETURN [2]		;DO NOT DUMP ANYTHING
							; 7993	
U 3736, 3737,3771,0004,4354,4007,0700,0000,0000,0000	; 7994	SAVVMA:	[ARX]_VMA
							; 7995		WORK[SV.VMA]_[ARX],
U 3737, 0010,3333,0004,7174,4004,1700,0400,0000,0210	; 7996		RETURN [10]
							; 7997	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 222
; INOUT.MIC[1,2]	13:32 7-JAN-1986			WRITE HALT STATUS BLOCK					

							; 7998	;DUMP OUT THE 2901
U 3745, 2530,3333,0004,4174,4007,0700,0200,0021,1016	; 7999	DUMP:	READ [ARX], VMA PHYSICAL WRITE
U 2530, 2765,3333,0000,4175,5007,0701,0210,0000,0002	; 8000	=0*	MEM WRITE, MEM_[MAG], CALL [NEXT]
U 2532, 3746,3333,0001,4175,5007,0701,0200,0000,0002	; 8001		MEM WRITE, MEM_[PC]
U 3746, 2531,0111,0704,4170,4007,0700,0200,0023,1016	; 8002		NEXT [ARX] PHYSICAL WRITE
U 2531, 2765,3333,0002,4175,5007,0701,0210,0000,0002	; 8003	=0*	MEM WRITE, MEM_[HR], CALL [NEXT]
U 2533, 2534,3333,0003,4175,5007,0701,0200,0000,0002	; 8004		MEM WRITE, MEM_[AR]
U 2534, 2765,3333,0003,7174,4007,0700,0410,0000,0211	; 8005	=0*	WORK[SV.AR]_[AR], CALL [NEXT]
U 2536, 2535,3771,0003,7274,4007,0701,0000,0000,0212	; 8006		[AR]_WORK[SV.ARX]
U 2535, 2765,3333,0003,4175,5007,0701,0210,0000,0002	; 8007	=0*	MEM WRITE, MEM_[AR], CALL [NEXT]
U 2537, 3747,3333,0005,4175,5007,0701,0200,0000,0002	; 8008		MEM WRITE, MEM_[BR]
U 3747, 2540,0111,0704,4170,4007,0700,0200,0023,1016	; 8009		NEXT [ARX] PHYSICAL WRITE
U 2540, 2765,3333,0006,4175,5007,0701,0210,0000,0002	; 8010	=0*	MEM WRITE, MEM_[BRX], CALL [NEXT]
U 2542, 3750,3333,0007,4175,5007,0701,0200,0000,0002	; 8011		MEM WRITE, MEM_[ONE]
U 3750, 2541,0111,0704,4170,4007,0700,0200,0023,1016	; 8012		NEXT [ARX] PHYSICAL WRITE
U 2541, 2765,3333,0010,4175,5007,0701,0210,0000,0002	; 8013	=0*	MEM WRITE, MEM_[EBR], CALL [NEXT]
U 2543, 3752,3333,0011,4175,5007,0701,0200,0000,0002	; 8014		MEM WRITE, MEM_[UBR]
U 3752, 2544,0111,0704,4170,4007,0700,0200,0023,1016	; 8015		NEXT [ARX] PHYSICAL WRITE
U 2544, 2765,3333,0012,4175,5007,0701,0210,0000,0002	; 8016	=0*	MEM WRITE, MEM_[MASK], CALL [NEXT]
U 2546, 3753,3333,0013,4175,5007,0701,0200,0000,0002	; 8017		MEM WRITE, MEM_[FLG]
U 3753, 2545,0111,0704,4170,4007,0700,0200,0023,1016	; 8018		NEXT [ARX] PHYSICAL WRITE
U 2545, 2765,3333,0014,4175,5007,0701,0210,0000,0002	; 8019	=0*	MEM WRITE, MEM_[PI], CALL [NEXT]
U 2547, 3755,3333,0015,4175,5007,0701,0200,0000,0002	; 8020		MEM WRITE, MEM_[XWD1]
U 3755, 2550,0111,0704,4170,4007,0700,0200,0023,1016	; 8021		NEXT [ARX] PHYSICAL WRITE
U 2550, 2765,3333,0016,4175,5007,0701,0210,0000,0002	; 8022	=0*	MEM WRITE, MEM_[T0], CALL [NEXT]
U 2552, 2551,3333,0017,4175,5007,0701,0200,0000,0002	; 8023		MEM WRITE, MEM_[T1]
U 2551, 2765,3771,0003,7274,4007,0701,0010,0000,0210	; 8024	=0*	[AR]_WORK[SV.VMA], CALL [NEXT]
U 2553, 3756,3333,0003,4175,5007,0701,0200,0000,0002	; 8025		MEM WRITE, MEM_[AR]
U 3756, 3757,3771,0003,7274,4007,0701,0000,0000,0211	; 8026	HSBDON:	[AR]_WORK[SV.AR]
U 3757, 3760,3771,0004,7274,4007,0701,0000,0000,0210	; 8027		[ARX]_WORK[SV.VMA]
U 3760, 3761,3443,0400,4174,4007,0700,0200,0000,0010	; 8028		VMA_[ARX]
							; 8029		[ARX]_WORK[SV.ARX],
U 3761, 0006,3771,0004,7274,4004,1701,0000,0000,0212	; 8030		RETURN [6]
							; 8031	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 223
; PAGEF.MIC[1,2]	11:16 17-APR-2015			WRITE HALT STATUS BLOCK					

							; 8032		.NOBIN
							; 8033		.TOC	"PAGE FAIL REFIL LOGIC"
							; 8034	
							; 8035	;WHEN THE CPU CAN NOT COMPLETE A MEMORY REFERENCE BECAUSE THE PAGE
							; 8036	; TABLE DOES NOT CONTAIN VALID INFORMATION FOR THE VIRTUAL PAGE INVOLVED
							; 8037	; THE HARDWARE CALLS THIS ROUTINE TO RELOAD THE HARDWARE PAGE TABLE.
							; 8038	;
							; 8039	;THIS CODE WILL EITHER DO THE RELOAD OR GENERATE A PAGE FAIL FOR THE
							; 8040	; SOFTWARE. THE INFORMATION LOADED CONSISTS OF THE PHYSICAL PAGE NUMBER,
							; 8041	; THE CACHE ENABLE BIT AND THE WRITE ENABLE BIT.
							; 8042	
							; 8043	;THIS LOGIC USES MANY VARIABLES. THEY ARE DESCRIBED BRIEFLY HERE:
							; 8044	
							; 8045	;THING			WHERE KEPT			USE
							; 8046	;OLD VMA		WORKSPACE WORD 210		SAVES VMA
							; 8047	;OLD AR 		WORKSPACE WORD 211		SAVES AR
							; 8048	;OLD ARX		WORKSPACE WORD 212		SAVES ARX
							; 8049	;OLD BR 		WORKSPACE WORD 213		SAVES BR
							; 8050	;OLD BRX		WORKSPACE WORD 214		SAVES BRX
							; 8051	;KL PAGING BIT		EBR BIT 1 (IN 2901)		INDICATES KL STYLE (TOPS-20) PAGING
							; 8052	;							INSTEAD OF KI STYLE (TOPS-10 AND DIAGNOSTIC)
							; 8053	;							MODE PAGING
							; 8054	;W BIT			FLG BIT 4			PAGE CAN BE WRITTEN
							; 8055	;C BIT			FLG BIT 6			DATA IN THIS PAGE MAY BE PUT
							; 8056	;							INTO CACHE
							; 8057	;PI CYCLE		FLG BIT 5			STORING OLD PC DURING PI
							; 8058	;MAP FLAG		FLG BIT 18			MAP INSTRUCTION IN PROGRESS
							; 8059	;CLEANUP CODE		FLG BITS 32-35			WHAT TO DO SO INSTRUCTION MAY BE
							; 8060	;							RESTARTED
							; 8061	;SPT BASE		WORKSPACE WORD 215		ADDRESS OF SHARED-POINTER-TABLE
							; 8062	;CST BASE		WORKSPACE WORD 216		ADDRESS OF CORE-STATUS-TABLE
							; 8063	;CST MASK		WORKSPACE WORD 217		BITS TO KEEP ON CST UPDATE
							; 8064	;CST DATA (PUR) 	WORKSPACE WORD 220		BITS TO SET ON CST UPDATE
							; 8065	;PAGE TABLE ADDRESS	AR				WHERE THIS PAGE TABLE IS LOCATED
							; 8066	;PHYSICAL PAGE # (PPN)	AR				RESULT OF THIS PROCESS
							; 8067	;CST ENTRY		AR				CORE STATUS TABLE ENTRY
							; 8068	;SPT ENTRY		AR				WORD FROM SPT
							; 8069	;PAGE TABLE ENTRY	AR				WORD FROM PT
							; 8070	;PAGE NUMBER		BR				INDEX INTO CURENT PAGE TABLE
							; 8071	;PAGE FAIL WORD 	BRX				WHAT HAPPENED (ALSO MAP RESULT)
							; 8072	
							; 8073	.IF/INHCST
							; 8074		SKIP NO CST	"AD/D,DBUS/RAM,RAMADR/#,WORK/CBR,DT/4T,SKIP/ADEQ0"
							; 8075	.ENDIF/INHCST
							; 8076	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 224
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8077	;
							; 8078	;
							; 8079	;
							; 8080	;		   KL10 PAGING - WORD FORMATS
							; 8081	;
							; 8082	;Section Pointer
							; 8083	;
							; 8084	;The section pointer is found in the user or exec section table.
							; 8085	;(Part of UPT or EPT.)
							; 8086	;
							; 8087	;Section pointer provides (via the SPT) the physical address  of
							; 8088	;the PAGE TABLE for the given section.
							; 8089	;
							; 8090	;	 Code:	 0	 No-access (trap)
							; 8091	;		 1	 Immediate
							; 8092	;		 2	 Share
							; 8093	;		 3	 Indirect
							; 8094	;		 4-7	 Unused, reserved
							; 8095	;
							; 8096	;	 0 1 2 3 4 5 6		 18			 35
							; 8097	;	 +----+-+-+-+-+---------+-------------------------+	
							; 8098	;	 !CODE!P!W! !C!/////////!  PAGE TABLE IDENTIFIER  !
							; 8099	;	 !010 ! ! ! ! !/////////!	 (SPT INDEX)	  !
							; 8100	;	 +----+-+-+-+-+---------+-------------------------+
							; 8101	;
							; 8102	;		NORMAL SECTION POINTER (Code = 2)
							; 8103	;
							; 8104	;	 0   2 3 4 5 6	   9	       18		      35
							; 8105	;	 +----+-+-+-+-+---+-----------+------------------------+
							; 8106	;	 !CODE!P!W! !C!///!SECTION    !SECTION TABLE IDENTIFIER!
							; 8107	;	 !011 ! ! ! ! !///!TABLE INDEX!       (SPT INDEX)      !
							; 8108	;	 +----+-+-+-+-+---+-----------+------------------------+
							; 8109	;
							; 8110	;	       INDIRECT SECTION POINTER (Code = 3)
							; 8111	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 225
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8112	;PAGE POINTERS
							; 8113	;
							; 8114	;FOUND IN PAGE TABLES
							; 8115	;
							; 8116	;	 0 1 2 3 4 5 6	    12				 35
							; 8117	;	 +----+-+-+-+-+----+------------------------------+
							; 8118	;	 !CODE!P!W! !C!////!   PHYSICAL ADDRESS OF PAGE   !
							; 8119	;	 !001 ! ! ! ! !////!				  !
							; 8120	;	 +----+-+-+-+-+----+------------------------------+
							; 8121	;
							; 8122	;		 IMMEDIATE POINTER (code field = 1)
							; 8123	;
							; 8124	;	 B12-35  give PHYSICAL ADDRESS OF PAGE
							; 8125	;	     if  B12-17 >< 0, page not in core-trap
							; 8126	;	     if  B12-17 =  0, B23-35 give CORE PAGE
							; 8127	;			      NUMBER of page, B18-22 MBZ
							; 8128	;
							; 8129	;
							; 8130	;
							; 8131	;
							; 8132	;
							; 8133	;	 0    2 3     6 	  18			 35
							; 8134	;	 +-----+-------+---------+------------------------+
							; 8135	;	 !CODE !SAME AS!/////////!	  SPT INDEX	  !
							; 8136	;	 !010  ! IMMED.!/////////!			  !
							; 8137	;	 +-----+-------+---------+------------------------+
							; 8138	;
							; 8139	;		 SHARED POINTER (code field = 2)
							; 8140	;
							; 8141	;	 B18-35  Give SPT INDEX (SPTX).  SPTX + SPT BASE
							; 8142	;		 ADDRESS = physical core address of word
							; 8143	;		 holding physical address of page.
							; 8144	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 226
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8145	;	 0 1 2 3      6     9	 17 18			 35
							; 8146	;	 +----+--------+---+-------+----------------------+
							; 8147	;	 !CODE!SAME AS !///! PAGE  ! PAGE TABLE IDENTIFIER!	
							; 8148	;	 !011 ! IMMED. !///!NUMBER !	 (SPT INDEX)	  !
							; 8149	;	 +----+--------+---+-------+----------------------+
							; 8150	;
							; 8151	;		 INDIRECT POINTER (code field = 3)
							; 8152	;
							; 8153	;	 This pointer type causes another pointer to be  fetched
							; 8154	;	 and  interpreted.   The  new pointer is found in word N
							; 8155	;	 (B9-17) of the page addressed by C(SPT + SPTX).
							; 8156	;
							; 8157	;
							; 8158	;
							; 8159	;	 SPT ENTRY
							; 8160	;
							; 8161	;	 Found in the SPT, i.e., when fetching C(SPT +SPTX)
							; 8162	;
							; 8163	;			       12			 35
							; 8164	;	 +--------------------+---------------------------+
							; 8165	;	 !////////////////////!  PHYSICAL ADDRESS OF PAGE !
							; 8166	;	 !////////////////////! 	 OR PAGE TABLE	  !
							; 8167	;	 +--------------------+---------------------------+
							; 8168	;
							; 8169	;		 B12-35  Give PHYSICAL ADDRESS of page.
							; 8170	;
							; 8171	;	 The base address (physical core  address)  of	the  SPT
							; 8172	;	 resides in one AC of the reserved AC block.
							; 8173	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 227
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8174	;PHYSICAL STORAGE ADDRESS
							; 8175	;
							; 8176	;Found in B12-35 of IMMEDIATE POINTERS and SPT ENTRIES.
							; 8177	;
							; 8178	;			 12	 17 18	 23		 35
							; 8179	;			 +---------+----+-----------------+
							; 8180	;			 !	   !MBZ ! CORE PAGE NUMBER!
							; 8181	;			 !	   !	!   IF B12-17 = 0 !
							; 8182	;			 +---------+----+-----------------+
							; 8183	;
							; 8184	;	 If B12-17 = 0, then B23-35 are CORE PAGE NUMBER  (i.e.,
							; 8185	;	 B14-26  of  physical  core  address) of page and B18-22
							; 8186	;	 MBZ.  If B12-17 >< 0, then  address  is  not  core  and
							; 8187	;	 pager traps.
							; 8188	;
							; 8189	;
							; 8190	;
							; 8191	;CORE STATUS TABLE ENTRY
							; 8192	;
							; 8193	;Found when fetching C(CBR + CORE PAGENO)
							; 8194	;
							; 8195	;	 0	5				  32  34 35
							; 8196	;	 +-------+-------------------------------+------+-+
							; 8197	;	 !  CODE !				 !	!M!
							; 8198	;	 +-------+-------------------------------+------+-+
							; 8199	;
							; 8200	;	 B0-5	 are code field:
							; 8201	;
							; 8202	;		 0 - unavailable, trap
							; 8203	;
							; 8204	;		 1-77 - available
							; 8205	;
							; 8206	;
							; 8207	;
							; 8208	;	 B32-34 reserved for future hardware specification.
							; 8209	;
							; 8210	;	 B35 is "modified" bit, set on any write ref to page.
							; 8211	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 228
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8212	;QUANTITIES IN HARDWARE REGISTERS
							; 8213	;
							; 8214	;SPT	 SPT Base Register
							; 8215	;
							; 8216	;			 14				 35
							; 8217	;			 +--------------------------------+
							; 8218	;			 !   PHYSICAL CORE WORD ADDRESS   !
							; 8219	;			 +--------------------------------+
							; 8220	;
							; 8221	;CBR	 CST Base Register
							; 8222	;
							; 8223	;			 14				 35
							; 8224	;			 +--------------------------------+
							; 8225	;			 !   PHYSICAL CORE WORD ADDRESS   !
							; 8226	;			 +--------------------------------+
							; 8227	;
							; 8228	;CSTMSK  CST Update Mask
							; 8229	;
							; 8230	;	 0					     32  35
							; 8231	;	 +------------------------------------------+---+-+
							; 8232	;	 !			 MASK		    !111!1!
							; 8233	;	 +------------------------------------------+---+-+
							; 8234	;
							; 8235	;		 ANDed with CST word during update
							; 8236	;
							; 8237	;(B32-35 must be all 1's to preserve existing CST information)
							; 8238	;
							; 8239	;CSTDATA CST Update Data
							; 8240	;
							; 8241	;	 0				      32 34 35	
							; 8242	;	 +------------------------------------------+---+-+
							; 8243	;	 !			 DATA		    !000!0!
							; 8244	;	 +------------------------------------------+---+-+
							; 8245	;
							; 8246	;		 IORed with CST word during update
							; 8247	;
							; 8248	;(B32-35 must be all 0's to preserve existing CST information)
							; 8249	;
							; 8250	;All  unspecified  bits  and  fields  are  reserved  for  future
							; 8251	;specification by DEC.
							; 8252	;
							; 8253	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 229
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8254		.BIN
							; 8255	
							; 8256		.DCODE
D 0257, 1215,1553,0100					; 8257	257:	IOT,	AC,	J/MAP
							; 8258		.UCODE
							; 8259	
							; 8260	1553:
							; 8261	MAP:	[AR]_[AR].OR.#,		;ASSUME PHYSICAL REF
							; 8262		#/160000,		;FAKE ANSWER
U 1553, 3762,3551,0303,4374,0007,0700,0000,0016,0000	; 8263		HOLD RIGHT		; ..
U 3762, 3763,3771,0006,4354,4007,0700,0000,0000,0000	; 8264		[BRX]_VMA		;PUT VMA AND FLAGS IN BRX
							; 8265		[BRX]_[BRX].AND.#,	;JUST KEEP USER BIT
U 3763, 3764,4551,0606,4374,0007,0700,0000,0040,0000	; 8266		#/400000, HOLD RIGHT	; ..
U 3764, 3765,3333,0006,7174,4007,0700,0400,0000,0210	; 8267		WORK[SV.VMA]_[BRX]	;SAVE IN WORKSPACE
U 3765, 3766,3771,0005,7274,4007,0701,0000,0000,0230	; 8268		[BR]_WORK[APR]		;GET APR FLAGS
U 3766, 2554,4553,0500,4374,4007,0331,0000,0003,0000	; 8269		TR [BR], #/030000	;PAGING ENABLED?
U 2554, 3776,3771,0013,4370,4007,0700,0000,0040,0002	; 8270	=0	STATE_[MAP], J/PFMAP	;YES--DO REAL MAP
U 2555, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 8271		AC_[AR], NEXT INST	;NO--RETURN VIRTUAL ADDRESS
							; 8272	
							; 8273	; HARDWARE COMES HERE ON PAGE TABLE NOT VALID (OR INTERRUPT) WHEN
							; 8274	; STARTING A MEMORY REFERENCE. MICOWORD ADDRESS OF INSTRUCTION DOING
							; 8275	; MEM WAIT IS SAVED ON THE STACK.
							; 8276	; THE PAGE-FAIL ENTRY POINT HAS ALL OF THE ADDRESS BITS SET.
							; 8277	; PAGE-FILE IS 3777 FOR A MACHINE THAT HAS 2K OF MICROCODE AND
							; 8278	; IS 7777 FOR A MACHINE THAT HAS 4K OF MICROCODE.
							; 8279	
							; 8280	
							; 8281	3777:
							; 8282	.IF/CRAM4K:
U 3777, 0104,4751,1217,4374,4007,0700,0000,0000,1776	; 8283		HALT [1776]
							; 8284	7777:
							; 8285	.ENDIF/CRAM4K
							; 8286	
							; 8287	PAGE-FAIL:
U 7777, 3767,3333,0003,7174,4007,0700,0400,0000,0211	; 8288		WORK[SV.AR]_[AR]
U 3767, 3770,3333,0006,7174,4007,0700,0400,0000,0214	; 8289	ITRAP:	WORK[SV.BRX]_[BRX]
U 3770, 3771,3771,0006,4354,4007,0700,0000,0000,0000	; 8290		[BRX]_VMA
U 3771, 3772,3333,0006,7174,4007,0700,0400,0000,0210	; 8291		WORK[SV.VMA]_[BRX]
							; 8292		WORK[SV.ARX]_[ARX],
U 3772, 1060,3333,0004,7174,4007,0370,0400,0000,0212	; 8293		SKIP IRPT		;SEE IF INTERRUPT (SAVE DISPATCH)
							; 8294	=0000
							; 8295	PFD:	DBM/PF DISP, DBUS/DBM,	;BRING CODE TO 2901'S
							; 8296		AD/D, DEST/PASS, 4T,	;PUT ON DP 18-21
U 1060, 1060,3773,0000,4304,4003,1702,0000,0000,0000	; 8297		DISP/DP LEFT, J/PFD	;DISPATCH ON IT
							; 8298	=0001				;(1) INTERRUPT
U 1061, 4045,3333,0005,7174,4007,0700,0400,0000,0213	; 8299		WORK[SV.BR]_[BR], J/PFPI1
							; 8300	=0011				;(3) BAD DATA FROM MEMORY
							; 8301		[BRX]_IO DATA,		;GET THE BAD DATA
							; 8302		AD PARITY OK/0,		; DO NOT LOOK AT PARITY
U 1063, 3773,3771,0006,4374,4007,0700,0000,0000,0000	; 8303		J/BADDATA		;SAVE IN AC BLK 7
							; 8304	=0101				;(5) NXM ERROR
U 1065, 4043,4571,1206,4374,4007,0700,0000,0037,0000	; 8305		[BRX]_[370000] XWD 0, J/HARD
							; 8306	=0111				;(7) NXM & BAD DATA
U 1067, 4043,4571,1206,4374,4007,0700,0000,0037,0000	; 8307		[BRX]_[370000] XWD 0, J/HARD
							; 8308	=1000				;(10) WRITE VIOLATION
U 1070, 3776,3333,0005,7174,4007,0700,0400,0000,0213	; 8309		WORK[SV.BR]_[BR], J/PFMAP; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 229-1
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8310	=1001				;[123] (11) 1 ms timer and movsrj
U 1071, 4045,3333,0005,7174,4007,0700,0400,0000,0213	; 8311		WORK[SV.BR]_[BR], J/PFPI1
							; 8312	=1010				;(12) PAGE NOT VALID
U 1072, 3776,3333,0005,7174,4007,0700,0400,0000,0213	; 8313		WORK[SV.BR]_[BR], J/PFMAP
							; 8314	=1011				;(13) EXEC/USER MISMATCH
U 1073, 3776,3333,0005,7174,4007,0700,0400,0000,0213	; 8315		WORK[SV.BR]_[BR], J/PFMAP
							; 8316	=
							; 8317	
							; 8318	BADDATA:
U 3773, 3774,3333,0006,7174,4007,0700,0400,0000,0160	; 8319		WORK[BADW0]_[BRX]	;SAVE BAD WORD
U 3774, 3775,3333,0006,7174,4007,0700,0400,0000,0161	; 8320		WORK[BADW1]_[BRX]	;AGAIN
U 3775, 4043,4571,1206,4374,4007,0700,0000,0036,0000	; 8321		[BRX]_[360000] XWD 0, J/HARD
							; 8322	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 230
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8323	;WE HAVE SAVED AR, ARX, BR AND BRX. WE MERGE IN HERE FROM MAP
							; 8324	; INSTRUCTION, SAVE THE VMA AND START THE PAGE FAIL WORD.
U 3776, 4000,4223,0000,4364,4277,0700,0200,0000,0010	; 8325	PFMAP:	ABORT MEM CYCLE		;CLEAR PAGE FAIL
							; 8326		[FLG]_[FLG].OR.#,	;PRESET W AND C TO 1
							; 8327		FLG.W/1, FLG.C/1,	;BITS INVOLVED
U 4000, 4001,3551,1313,4374,0007,0700,0000,0002,4000	; 8328		HOLD RIGHT		;LEAVE RH ALONE
U 4001, 2556,4553,0600,4374,4007,0321,0000,0002,0000	; 8329		TL [BRX], WRITE TEST/1	;IS THIS A WRITE TEST?
							; 8330	=0	[BRX]_[BRX].OR.#,
							; 8331		#/10000,
U 2556, 2557,3551,0606,4374,0007,0700,0000,0001,0000	; 8332		HOLD RIGHT		;YES--TURN INTO WRITE REF
							; 8333		[BRX]_[BRX].AND.#,	;START PAGE FAIL WORD
							; 8334		#/411000,		;SAVE 3 INTERESTING BITS
U 2557, 4002,4551,0606,4374,0007,0700,0000,0041,1000	; 8335		HOLD RIGHT		;SAVE VIRTUAL ADDRESS
							; 8336					;USER ADDR (400000)
							; 8337					;WRITE REF (010000)
							; 8338					;PAGED REF (001000)
							; 8339		[BRX]_[BRX].XOR.#,	;FIX BIT 8
U 4002, 4003,6551,0606,4374,0007,0700,0000,0000,1000	; 8340		#/1000, HOLD RIGHT
							; 8341		[BR]_[BRX],		;COPY VIRTUAL ADDRESS
U 4003, 2560,3441,0605,4174,4007,0700,2000,0071,0007	; 8342		SC_7			;PREPARE TO SHIFT 9 PLACES
							; 8343	=0
							; 8344	PF25:	[BR]_[BR]*.5,		;RIGHT ADJUST PAGE #
							; 8345		STEP SC,		;COUNT SHIFT STEPS
U 2560, 2560,3447,0505,4174,4007,0630,2000,0060,0000	; 8346		J/PF25			;LOOP FOR 9
							; 8347		[BR]_[BR].AND.# CLR LH,	;MASK TO 9 BITS
U 2561, 4004,4251,0505,4374,4007,0700,0000,0000,0777	; 8348		#/777			; ..
							; 8349	.IF/KLPAGE
							; 8350	.IF/KIPAGE
							; 8351		TL [EBR],		;KI MODE REFILL?
U 4004, 2562,4553,1000,4374,4007,0321,0000,0000,0040	; 8352		#/40			;FLAG BIT
							; 8353	=0
							; 8354	.ENDIF/KIPAGE
							; 8355		READ [BRX],		;USER REF? (KL MODE)
							; 8356		SKIP DP0,		; ..
U 2562, 2564,3333,0006,4174,4007,0520,0000,0000,0000	; 8357		J/PF30			;CONTINUE AT PF30
							; 8358	.ENDIF/KLPAGE
							; 8359	.IF/KIPAGE
							; 8360		[ARX]_[BR]*.5,		;KI10 MODE REFILL
U 2563, 4036,3447,0504,4174,4007,0700,0000,0000,0000	; 8361		J/KIFILL		;GO HANDLE EASY CASE
							; 8362	.ENDIF/KIPAGE
							; 8363	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 231
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8364	.IF/KLPAGE
							; 8365	;HERE IN TOPS-20 MODE
							; 8366	;PICK UP CORRECT SECTION POINTER
							; 8367	=0
							; 8368	PF30:	[ARX]_WORK[PTA.E],	;EXEC MODE
							; 8369		SKIP AD.EQ.0, 4T,	;SEE IF VALID
U 2564, 2570,3771,0004,7274,4007,0622,0000,0000,0423	; 8370		J/PF35			;CONTINUE BELOW
							; 8371		[ARX]_WORK[PTA.U],	;USER MODE
U 2565, 2566,3771,0004,7274,4007,0622,0000,0000,0424	; 8372		SKIP AD.EQ.0, 4T	;SEE IF VALID
							; 8373	=0	VMA_[ARX]+[BR],		;POINTER VALID
							; 8374		VMA PHYSICAL READ,	;START MEMORY
U 2566, 1140,0113,0405,4174,4007,0700,0200,0024,1016	; 8375		J/PF77			;CONTINUE BELOW
							; 8376		[AR]_[UBR]+#, 3T,	;USER MODE
							; 8377		#/540,			;OFFSET TO UPT
U 2567, 4005,0551,1103,4374,4007,0701,0000,0000,0540	; 8378		J/PF40			;GO GET POINTER
							; 8379	
							; 8380	=0
							; 8381	PF35:	VMA_[ARX]+[BR],		;POINTER VALID
							; 8382		VMA PHYSICAL READ,	;START MEMORY
U 2570, 1140,0113,0405,4174,4007,0700,0200,0024,1016	; 8383		J/PF77			;CONTINUE BELOW
							; 8384		[AR]_[EBR]+#, 3T,	;EXEC MODE
U 2571, 4005,0551,1003,4374,4007,0701,0000,0000,0540	; 8385		#/540			;OFFSET TO EPT
							; 8386	PF40:	VMA_[AR],		;LOAD THE VMA
							; 8387		START READ,		;START THE MEMORY CRANKING
U 4005, 4006,3443,0300,4174,4007,0700,0200,0024,1016	; 8388		VMA PHYSICAL		;ABSOLUTE ADDRESS
							; 8389		MEM READ,		;WAIT FOR MEMORY
U 4006, 1000,3771,0003,4365,5007,0700,0200,0000,0002	; 8390		[AR]_MEM		;POINT POINTER IN AR
							; 8391	;LOOK AT SECTION POINTER AND DISPATCH ON TYPE
							; 8392	=000
							; 8393	PF45:	SC_7,			;FETCH SECTION 0 POINTER
U 1000, 4031,4443,0000,4174,4007,0700,2010,0071,0007	; 8394		CALL [SETPTR]		;FIGURE OUT POINTER TYPE
							; 8395	SECIMM:	TL [AR],		;IMMEDIATE POINTER
							; 8396		#/77,			;TEST FOR 12-17 = 0
U 1001, 2574,4553,0300,4374,4007,0321,0000,0000,0077	; 8397		J/PF50			;CONTINUE AT PF50
							; 8398		[AR]_[AR]+WORK[SBR],	;SHARED SECTION
U 1002, 2251,0551,0303,7274,4007,0701,0000,0000,0215	; 8399		J/SECSHR		;GO FETCH POINTER FROM SPT
							; 8400		[AR]_[AR]+WORK[SBR],	;INDIRECT SECTION POINTER
U 1003, 4034,0551,0303,7274,4007,0701,0010,0000,0215	; 8401		CALL [RDPT]		;GO FETCH SPT ENTRY
							; 8402	=111	TL [AR],		;12 TO 17 = 0?
U 1007, 2572,4553,0300,4374,4007,0321,0000,0000,0077	; 8403		#/77			; ..
							; 8404	=
U 2572, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8405	=0	PAGE FAIL TRAP		;NO
							; 8406		[AR]_[AR]*2,		;FIRST SHIFT
U 2573, 1010,3445,0303,4174,4007,0630,2000,0060,0000	; 8407		STEP SC			;SC WAS LOADED AT PF45
							; 8408	=0*0
							; 8409	PF60:	[AR]_[AR]*2,		;CONVERT TO ADDRESS OF
							; 8410		STEP SC,		; SECTION TABLE
U 1010, 1010,3445,0303,4174,4007,0630,2000,0060,0000	; 8411		J/PF60
U 1011, 4034,4443,0000,4174,4007,0700,0010,0000,0000	; 8412		CALL [RDPT]		;READ SECTION TABLE
U 1015, 1000,4443,0000,4174,4007,0700,0000,0000,0000	; 8413	=1*1	J/PF45			;TRY AGAIN
							; 8414	=
							; 8415	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 232
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8416	;STILL .IF/KLPAGE
							; 8417	;HERE FOR SHARED SECTION. AR GETS THE ADDRESS OF PAGE TABLE
							; 8418	=0**
U 2251, 4034,4443,0000,4174,4007,0700,0010,0000,0000	; 8419	SECSHR:	CALL [RDPT]		;READ WORD FROM SPT
U 2255, 2574,4553,0300,4374,4007,0321,0000,0000,0077	; 8420		TL [AR], #/77		;TEST FOR BITS 12-17 = 0
							; 8421	
							; 8422	;HERE WITH ADDRESS OF PAGE TABLE IN AR AND SKIP ON
							; 8423	; BITS 12 THRU 17 EQUAL TO ZERO
							; 8424	=0
U 2574, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8425	PF50:	PAGE FAIL TRAP		;BITS 12-17 .NE. 0
							; 8426		[ARX]_[AR].AND.# CLR LH, ;PAGE NUMBER OF PAGE TABLE
U 2575, 2600,4251,0304,4374,4007,0700,0000,0000,3777	; 8427		#/3777			;11 BIT PHYSICAL PAGE #
							; 8428	.IFNOT/NOCST
							; 8429	=0*	[AR]_[ARX],		;COPY ADDRESS
U 2600, 4030,3441,0403,4174,4007,0700,0010,0000,0000	; 8430		CALL [UPCST]		;UPDATE CST0
U 2602, 2601,3551,0303,7274,4007,0701,0000,0000,0220	; 8431	PF70:	[AR]_[AR].OR.WORK[PUR]	;PUT IN NEW AGE AND
							; 8432					; USE BITS
							;;8433	.IFNOT/INHCST
							;;8434	=0**	START NO TEST WRITE,	;START MEMORY WRITE
							;;8435		CALL [IBPX]		;GO STORE IN MEMORY
							; 8436	.ENDIF/INHCST
							; 8437	.IF/INHCST
							; 8438	=0**	SKIP NO CST,		;SEE IF A CST
U 2601, 2646,3773,0000,7274,4007,0622,0010,0000,0216	; 8439		CALL [WRCST]		;AND GO WRITE IN MEMORY
							; 8440	.ENDIF/INHCST
U 2605, 2576,4443,0000,4174,4007,0700,2000,0071,0007	; 8441		SC_7			;THIS CAN BE BUMMED
							; 8442	=0
							; 8443	PF75:	[ARX]_[ARX]*2,		;CONVERT PAGE NUMBER TO
							; 8444		STEP SC,		; PAGE ADDRESS
U 2576, 2576,3445,0404,4174,4007,0630,2000,0060,0000	; 8445		J/PF75			;LOOP OVER 9 STEPS
							; 8446	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 233
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8447	;STILL .IF/KLPAGE
							; 8448	;WE NOW HAVE THE ADDRESS OF THE PAGE TABLE ENTRY. GO
							; 8449	; READ IT AND START ANALYSIS
							; 8450	
							; 8451	;IF WE ARE HERE FOR THE FIRST TIME FOR THE USER OR EXEC SAVE THE
							; 8452	; ADDRESS OF THE PAGE TABLE IN PTA.E OR PTA.U SO THAT WE DO NOT
							; 8453	; HAVE TO DO THE SECTION LOOKUP EVERY TIME.
U 2577, 1040,3333,0006,4174,4007,0520,0000,0000,0000	; 8454		READ [BRX], SKIP DP0	;USER OR EXEC REF?
							; 8455	=000	[AR]_WORK[PTA.E],	;EXEC MODE
							; 8456		SKIP AD.EQ.0, 4T,	;SEE IF SET YET
U 1040, 2662,3771,0003,7274,4007,0622,0010,0000,0423	; 8457		CALL [SHDREM]		;SHOULD WE REMEMBER PTR
							; 8458		[AR]_WORK[PTA.U],	;USER MODE
							; 8459		SKIP AD.EQ.0, 4T,	;SEE IF SET YET
U 1041, 2662,3771,0003,7274,4007,0622,0010,0000,0424	; 8460		CALL [SHDREM]		;SHOULD WE REMEMBER PTR
							; 8461		WORK[PTA.E]_[ARX],	;SAVE FOR EXEC
U 1042, 1047,3333,0004,7174,4007,0700,0400,0000,0423	; 8462		J/PF76			;CONTINUE BELOW
							; 8463		WORK[PTA.U]_[ARX],	;SAVE FOR USER
U 1043, 1047,3333,0004,7174,4007,0700,0400,0000,0424	; 8464		J/PF76			;CONTINUE BELOW
							; 8465	=111
							; 8466	PF76:	VMA_[ARX]+[BR], 	;READ PAGE POINTER
							; 8467		START READ,
U 1047, 1140,0113,0405,4174,4007,0700,0200,0024,1016	; 8468		VMA PHYSICAL
							; 8469	=
							; 8470	=00
							; 8471	PF77:	MEM READ,		;START ANALYSIS OF POINTER
							; 8472		[AR]_MEM,
U 1140, 4031,3771,0003,4365,5007,0700,0210,0000,0002	; 8473		CALL [SETPTR]
							; 8474	PTRIMM: TL [AR],		;IMMEDIATE POINTER
							; 8475		#/77,			;CHECK FOR BITS 0-5
U 1141, 1144,4553,0300,4374,4007,0321,0000,0000,0077	; 8476		J/PF80			;GO TO PF80
							; 8477		[AR]_[AR]+WORK[SBR],	;SHARED POINTER
U 1142, 2612,0551,0303,7274,4007,0701,0000,0000,0215	; 8478		J/PTRSHR		;GO TO READ SPT
							; 8479	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 234
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8480	;STILL .IF/KLPAGE
							; 8481	;INDIRECT POINTER. CHANGE PAGE # AND LOOK FOR PAGE TABLE
							; 8482	PTRIND:	[BR]_[AR] SWAP, 	;PUT IN RIGHT HALF
U 1143, 2606,3770,0305,4344,4007,0670,0000,0000,0000	; 8483		SKIP/-1 MS		;DID CLOCK GO OFF
							; 8484	=0	WORK[SV.AR1]_[AR],	;YES--UPDATE CLOCK
U 2606, 2624,3333,0003,7174,4007,0700,0400,0000,0426	; 8485		J/PFTICK		; ..
							; 8486		[BR]_[BR].AND.# CLR LH,	;UPDATE PAGE # AND RESTART
							; 8487		#/777,			;MASK FOR PAGE #
U 2607, 2610,4251,0505,4374,4007,0370,0000,0000,0777	; 8488		SKIP IRPT		;SEE IF THIS IS A LOOP
							; 8489	=0	[AR]_[AR].AND.#,	;CHANGE INDIRECT POINTER
							; 8490		#/277000,		; INTO SHARE POINTER
							; 8491		HOLD RIGHT,		; ..
U 2610, 1000,4551,0303,4374,0007,0700,0000,0027,7000	; 8492		J/PF45			;GO BACK AND TRY AGAIN
U 2611, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8493		PAGE FAIL TRAP		;POINTER LOOP
							; 8494	
							; 8495	=0**
U 2612, 4034,4443,0000,4174,4007,0700,0010,0000,0000	; 8496	PTRSHR:	CALL [RDPT]		;GO LOOK AT POINTER
							; 8497		TL [AR],		;BITS 12-17 .EQ. 0?
U 2616, 1144,4553,0300,4374,4007,0321,0000,0000,0077	; 8498		#/77
							; 8499	
							; 8500	;HERE WITH FINAL POINTER. SKIP IF 12-17 NOT EQUAL TO ZERO
							; 8501	.IFNOT/NOCST
							; 8502	=00
U 1144, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8503	PF80:	PAGE FAIL TRAP		;NO--TAKE A TRAP
							; 8504		[ARX]_[AR].AND.# CLR LH, ;SAVE PHYSICAL PAGE #
							; 8505		#/3777,			;MASK TO 13 BITS
U 1145, 4030,4251,0304,4374,4007,0700,0010,0000,3777	; 8506		CALL [UPCST]		;UPDATE CST0
							; 8507	=11
							;;8508	.IF/NOCST
							;;8509	=0
							;;8510	PF80:	PAGE FAIL TRAP		;NO--TAKE A TRAP
							; 8511	.ENDIF/NOCST
							; 8512	
							; 8513	;HERE WE HAVE CST ENTRY IN AR, PAGE FAIL WORD IN BRX. GO LOOK
							; 8514	; AT WRITABLE AND WRITTEN BITS
							; 8515	PF90:	[BRX]_[BRX].OR.#,	;TRANSLATION IS VALID
U 1147, 4007,3551,0606,4374,0007,0700,0000,0010,0000	; 8516		#/100000, HOLD RIGHT	; ..
U 4007, 2614,4553,1300,4374,4007,0321,0000,0002,0000	; 8517		TL [FLG], FLG.W/1	;IS THIS PAGE WRITABLE?
							; 8518	=0	[BRX]_[BRX].OR.#,	;YES--INDICATE THAT IN PFW
							; 8519		#/020000,
U 2614, 4010,3551,0606,4374,4007,0700,0000,0002,0000	; 8520		J/PF100			;NOT WRITE VIOLATION
							; 8521		TL [BRX],		;IS THIS A WRITE REF?
U 2615, 2620,4553,0600,4374,4007,0321,0000,0003,0000	; 8522		WRITE TEST/1, WRITE CYCLE/1
U 2620, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8523	=0	PAGE FAIL TRAP		;WRITE VIOLATION
							; 8524	PF107:
							; 8525	.IFNOT/NOCST
							; 8526		[AR]_[AR].OR.WORK[PUR],	;PUT IN NEW AGE
U 2621, 2613,3551,0303,7274,4007,0701,0000,0000,0220	; 8527		J/PF110			;GO TO STORE CST ENTRY
							; 8528	.ENDIF/NOCST
							;;8529	.IF/NOCST
							;;8530	PFDONE:	TR [FLG],
							;;8531		#/400000,
							;;8532		J/PF140
							; 8533	.ENDIF/NOCST
							; 8534	
							; 8535	=0*; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 234-1
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8536	PFTICK:	[AR]_WORK[TIME1],	;UPDATE TIMER
U 2624, 3621,3771,0003,7274,4117,0701,0010,0000,0301	; 8537		SPEC/CLRCLK, CALL [TOCK]
							; 8538		[AR]_WORK[SV.AR1],	;RESTORE AR
U 2626, 1143,3771,0003,7274,4007,0701,0000,0000,0426	; 8539		J/PTRIND		;GO TRY AGAIN
							; 8540	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 235
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8541	;STILL .IF/KLPAGE
							; 8542	;HERE IF PAGE IS WRITABLE
U 4010, 2622,4553,0600,4374,4007,0321,0000,0001,0000	; 8543	PF100:	TL [BRX], WRITE CYCLE/1	;IS THIS A WRITE REF?
							; 8544	=0	[AR]_[AR].OR.#, 	;YES--SET WRITTEN BIT
							; 8545		#/1,
							; 8546		HOLD LEFT,
U 2622, 2630,3551,0303,4370,4007,0700,0000,0000,0001	; 8547		J/PF105
							; 8548		TR [AR],		;NOT WRITE, ALREADY WRITTEN?
U 2623, 2630,4553,0300,4374,4007,0331,0000,0000,0001	; 8549		#/1
							; 8550	=0
							; 8551	PF105:	[BRX]_[BRX].OR.#,	;WRITTEN SET BIT
							; 8552		#/040000,		;MARK PAGE AS
							; 8553		HOLD RIGHT,		;WRITABLE
U 2630, 2621,3551,0606,4374,0007,0700,0000,0004,0000	; 8554		J/PF107			;STORE CST WORD
							; 8555		[FLG]_[FLG].AND.NOT.#,	;NOT WRITTEN, CAUSE TRAP ON
							; 8556		FLG.W/1,		; WRITE ATTEMPT
							; 8557		HOLD RIGHT,		;ONLY CLEAR LH
U 2631, 2621,5551,1313,4374,0007,0700,0000,0002,0000	; 8558		J/PF107
							; 8559	.IFNOT/NOCST
							; 8560	=0**
							; 8561	PF110:
							;;8562	.IFNOT/INHCST
							;;8563		START NO TEST WRITE,
							;;8564		CALL [IBPX]		;STORE CST ENTRY
							; 8565	.ENDIF/INHCST
							; 8566	.IF/INHCST
							; 8567		SKIP NO CST,
U 2613, 2646,3773,0000,7274,4007,0622,0010,0000,0216	; 8568		CALL [WRCST]
							; 8569	.ENDIF/INHCST
							; 8570	
							; 8571	.ENDIF/KLPAGE
							; 8572	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 236
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8573	
							; 8574	;HERE WHEN WE HAVE FIGURED OUT PHYSICAL ADDRESS (IN ARX) AND FLAGS
							; 8575	; (IN BRX) RELOAD PAGE TABLE.
							; 8576	PFDONE: TR [FLG],		;MAP INSTRUCTION?
U 2617, 2632,4553,1300,4374,4007,0331,0000,0040,0000	; 8577		#/400000
							; 8578	.ENDIF/NOCST
							; 8579	=0
							; 8580	PF140:	[AR]_[ARX],		;GET PHYSCIAL PAGE #
							; 8581		SC_7,			;PREPARE TO CONVERT TO
U 2632, 2634,3441,0403,4174,4007,0700,2000,0071,0007	; 8582		J/PF130			; WORD ADDRESS
							; 8583		[AR]_WORK[SV.VMA],	;RESTORE VMA
U 2633, 4015,3771,0003,7274,4007,0701,0000,0000,0210	; 8584		J/PF120
							; 8585	=0
							; 8586	PF130:	[AR]_[AR]*2,		;CONVERT TO WORD #
							; 8587		STEP SC,
U 2634, 2634,3445,0303,4174,4007,0630,2000,0060,0000	; 8588		J/PF130
							; 8589		[AR]_[AR].AND.#,	;JUST ADDRESS BITS
							; 8590		#/3,
U 2635, 4011,4551,0303,4374,0007,0700,0000,0000,0003	; 8591		HOLD RIGHT
U 4011, 4012,4221,0013,4170,4007,0700,0000,0000,0000	; 8592		END MAP 		;CLEAR MAP FLAGS
							; 8593		[BRX]_[BRX].OR.#,	;TURN ON THE TRANSLATION
							; 8594		#/100000,		; VALID BIT
U 4012, 4013,3551,0606,4374,0007,0700,0000,0010,0000	; 8595		HOLD RIGHT		; IN LEFT HALF ONLY
U 4013, 2636,4553,1300,4374,4007,0321,0000,0000,4000	; 8596		TL [FLG], FLG.C/1	;CACHE BIT SET?
							; 8597	=0	[BRX]_[BRX].OR.#,	;YES--SET IN MAP WORD
U 2636, 2637,3551,0606,4374,0007,0700,0000,0000,2000	; 8598		#/002000, HOLD RIGHT	; ..
							; 8599		[BRX]_[BRX].AND.#,	;PRESERVE WORD #
U 2637, 4014,4551,0606,4370,4007,0700,0000,0000,0777	; 8600		#/777, HOLD LEFT	; IN PAGE FAIL WORD
							; 8601		[AR]_[AR].OR.[BRX],	;COMPLETE MAP INSTRUCTION
U 4014, 1500,3111,0603,4174,4003,7700,0200,0003,0001	; 8602		EXIT
							; 8603	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 237
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

U 4015, 4016,3441,0305,4174,4007,0700,0000,0000,0000	; 8604	PF120:	[BR]_[AR]		;COPY PAGE FAIL WORD
							; 8605		[BR]_[AR].AND.NOT.#,	;CLEAR BITS WHICH START A CYCLE
							; 8606		READ CYCLE/1,		; ..
							; 8607		WRITE CYCLE/1,		; ..
							; 8608		WRITE TEST/1,		; ..
U 4016, 4017,5551,0305,4374,0007,0700,0000,0007,0000	; 8609		HOLD RIGHT		;JUST DO LEFT HALF
							; 8610		VMA_[BR], 3T,		;RESTORE VMA
U 4017, 4020,3443,0500,4174,4007,0701,0200,0000,0030	; 8611		DP FUNC/1		;SET USER ACCORDING TO WHAT IT WAS
							; 8612		[ARX]_[ARX].AND.# CLR LH, ;JUST KEEP PAGE #
U 4020, 4021,4251,0404,4374,4007,0700,0000,0000,3777	; 8613		#/3777			; ..
U 4021, 4022,3551,0406,4374,4007,0700,0000,0040,0000	; 8614		[BRX]_[ARX].OR.#, #/400000 ;SET VALID BITS
U 4022, 2640,4553,1300,4374,4007,0321,0000,0002,0000	; 8615		TL [FLG], FLG.W/1	;WANT WRITE SET?
U 2640, 2641,3551,0606,4374,4007,0700,0000,0004,0000	; 8616	=0	[BRX]_[BRX].OR.#, #/040000 ;SET WRITE BIT
							; 8617		TL [FLG], FLG.C/1,	;WANT CACHE SET?
U 2641, 2642,4553,1300,4374,4147,0321,0000,0000,4000	; 8618		LOAD PAGE TABLE		;LOAD PAGE TABLE ON NEXT
							; 8619					; MICRO INSTRUCTION
							; 8620	=0	[BRX]_[BRX].OR.#,	;SET CACHE BIT
U 2642, 4023,3551,0606,4374,4007,0700,0000,0002,0000	; 8621		#/020000, J/PF125	;CACHE BIT
U 2643, 4023,3333,0006,4174,4007,0700,0000,0000,0000	; 8622		READ [BRX]		;LOAD PAGE TABLE
U 4023, 4024,3771,0004,7274,4007,0701,0000,0000,0212	; 8623	PF125:	[ARX]_WORK[SV.ARX]
U 4024, 4025,3771,0005,7274,4007,0701,0000,0000,0213	; 8624		[BR]_WORK[SV.BR]
U 4025, 4026,3771,0006,7274,4007,0701,0000,0000,0214	; 8625		[BRX]_WORK[SV.BRX]
							; 8626		VMA_[AR],		;MAKE MEM REQUEST
							; 8627		DP FUNC/1, 3T,		;FROM DATA PATH
U 4026, 4027,3443,0300,4174,4007,0701,0200,0000,0032	; 8628		WAIT/1			;WAIT FOR PREVIOUS CYCLE TO
							; 8629					; COMPLETE. (NEED THIS TO 
							; 8630					; START ANOTHER CYCLE)
							; 8631		[AR]_WORK[SV.AR],
U 4027, 0000,3771,0003,7274,4004,1701,0000,0000,0211	; 8632		RETURN [0]
							; 8633	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 238
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8634	.IF/KLPAGE
							; 8635	.IFNOT/NOCST
							; 8636	;SUBROUTINE TO START CST UPDATE
							; 8637	;CALL WITH:
							; 8638	;	AR/ PHYSICAL PAGE NUMBER
							; 8639	;RETURN 2 WITH ENTRY IN AR, PAGE FAIL IF AGE TOO SMALL
							;;8640	.IFNOT/INHCST
							;;8641	=0**
							;;8642	UPCST:	[AR]_[AR]+WORK[CBR],	;ADDRESS OF CST0 ENTRY
							;;8643		CALL [RDPT]		;READ OLD VALUE
							;;8644		TL [AR],		;0 - 5 = 0?
							;;8645		#/770000		; ..
							;;8646	=0	[AR]_[AR].AND.WORK[CSTM],	;CLEAR AGE FIELD
							;;8647		RETURN [2]		;AGE IS NOT ZERO
							;;8648		PAGE FAIL TRAP		;AGE TOO SMALL
							; 8649	.ENDIF/INHCST
							; 8650	.IF/INHCST
U 4030, 1150,3773,0000,7274,4007,0622,0000,0000,0216	; 8651	UPCST:	SKIP NO CST		;SEE IF A CST IS PRESENT
							; 8652	=0*0	[AR]_[AR]+WORK[CBR],	;YES, ADDRESS OF CST0 ENTRY
U 1150, 4034,0551,0303,7274,4007,0701,0010,0000,0216	; 8653		CALL [RDPT]		;READ OLD VALUE
U 1151, 0002,4221,0003,4174,4004,1700,0000,0000,0000	; 8654		[AR]_0,RETURN [2]	;NO CST, RETURN
							; 8655		TL [AR],		;CHECK AGE FIELD
U 1154, 2644,4553,0300,4374,4007,0321,0000,0077,0000	; 8656		#/770000
							; 8657	=
							; 8658	=0	[AR]_[AR].AND.WORK[CSTM],	;CLEAR AGE FIELD
U 2644, 0002,4551,0303,7274,4004,1701,0000,0000,0217	; 8659		RETURN [2]		;AGE IS NOT ZERO
U 2645, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8660		PAGE FAIL TRAP		;AGE TOO SMALL
							; 8661	
							; 8662	=0
							; 8663	WRCST:	START NO TEST WRITE,
U 2646, 3114,4443,0000,4174,4007,0700,0200,0001,0002	; 8664		J/IBPX
U 2647, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 8665		RETURN [4]
							; 8666	.ENDIF/INHCST
							; 8667	.ENDIF/NOCST
							; 8668	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 239
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8669	;STILL .IF/KLPAGE
							; 8670	;SUBROUTINE TO LOOK AT PAGE POINTER
							; 8671	;CALL WITH POINTER IN AR
							; 8672	;RETURNS 1 IF TYPE 1
							; 8673	;RETURNS 2 IF TYPE 2
							; 8674	;RETURNS 3 IF TYPE 3
							; 8675	;GOES TO PFT IF TYPE 0 OR 4 THRU 7
							; 8676	SETPTR: [ARX]_[AR].OR.#,	;AND C AND W BITS
U 4031, 4032,3551,0304,4374,4007,0700,0000,0075,3777	; 8677		#/753777		; OF ALL POINTERS
							; 8678		[FLG]_[FLG].AND.[ARX],	; ..
U 4032, 4033,4111,0413,4174,0007,0700,0000,0000,0000	; 8679		HOLD RIGHT		;KEEP IN LH OF FLG
							; 8680		READ [AR],		;TYPE 4,5,6 OR 7?
U 4033, 2650,3333,0003,4174,4007,0520,0000,0000,0000	; 8681		SKIP DP0		; ..
							; 8682	=0	TL [AR],		;HERE WE TEST FOR TYPE
							; 8683		#/300000,		; ZERO POINTER
U 2650, 2652,4553,0300,4374,4007,0321,0000,0030,0000	; 8684		J/STPTR1		;CHECK AT STPTR1
U 2651, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8685		PAGE FAIL TRAP		;BAD TYPE
							; 8686	=0
							; 8687	STPTR1: TL [AR],		;NOT ZERO
							; 8688		#/100000,		;SEPERATE TYPE 2
U 2652, 2654,4553,0300,4374,4007,0321,0000,0010,0000	; 8689		J/STPTR2		; ..
U 2653, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8690		PAGE FAIL TRAP		;TYPE 0
							; 8691	
							; 8692	=0
							; 8693	STPTR2: TL [AR],		;SEPERATE TYPE 1
							; 8694		#/200000,		; AND 3
U 2654, 2656,4553,0300,4374,4007,0321,0000,0020,0000	; 8695		J/STPTR3		; ..
U 2655, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 8696		RETURN [2]		;TYPE 2
							; 8697	
							; 8698	=0
U 2656, 0003,4443,0000,4174,4004,1700,0000,0000,0000	; 8699	STPTR3: RETURN [3]		;TYPE 3
U 2657, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 8700		RETURN [1]		;TYPE 1
							; 8701	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 240
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8702	;STILL .IF/KLPAGE
							; 8703	;SUBROUTINE TO FETCH A PAGE POINTER OR CST ENTRY
							; 8704	;CALL WITH ADDRESS IN AR
							; 8705	;RETURN 4 WITH WORD IN AR
							; 8706	;
							; 8707	RDPT:	VMA_[AR],		;LOAD THE VMA
							; 8708		START READ,		;START MEM CYCLE
							; 8709		VMA PHYSICAL,		;ABSOLUTE ADDRESS
U 4034, 2660,3443,0300,4174,4007,0370,0200,0024,1016	; 8710		SKIP IRPT		;CHECK FOR INTERRUPTS
							; 8711	=0	MEM READ,		;NO INTERRUPTS
							; 8712		[AR]_MEM,		;PUT THE DATA INTO AR
U 2660, 0004,3771,0003,4365,5004,1700,0200,0000,0002	; 8713		RETURN [4]		;AND RETURN
U 2661, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8714		PAGE FAIL TRAP		;INTERRUPT
							; 8715	
							; 8716	
							; 8717	;SUBROUTINE TO SEE IF WE SHOULD REMEMBER AN EXEC SECTION PTR
							; 8718	;CALL WITH SKIP ON ADR.EQ.0
							; 8719	;RETURNS 2 IF WE SHOULD STORE AND 7 IF WE SHOULD NOT
							; 8720	;
							; 8721	=0
U 2662, 0007,4443,0000,4174,4004,1700,0000,0000,0000	; 8722	SHDREM:	RETURN [7]		;INDIRECT PTR
U 2663, 4035,7441,1303,4174,4007,0700,0000,0000,0000	; 8723		[AR]_.NOT.[FLG]		;FLIP BITS
U 4035, 2664,4553,0300,4374,4007,0321,0000,0002,4000	; 8724		TL [AR], FLG.W/1, FLG.C/1 ;BOTH BITS SET
U 2664, 0007,4443,0000,4174,4004,1700,0000,0000,0000	; 8725	=0	RETURN [7]		;NO--DON'T STORE
U 2665, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 8726		RETURN [2]		;STORE
							; 8727	
							; 8728	.ENDIF/KLPAGE
							; 8729	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 241
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8730	.IF/KIPAGE
							; 8731	;HERE IN KI10 MODE
							; 8732	;BR CONTAINS PAGE # AND ARX CONTAINS PAGE #/2
							; 8733	
							; 8734	KIFILL: READ [BRX],		;USER REF?
U 4036, 2666,3333,0006,4174,4007,0520,0000,0000,0000	; 8735		SKIP DP0		; ..
							; 8736	=0	[BR]-#, 		;EXEC--LESS THAN 340?
							; 8737		#/340,			; ..
							; 8738		SKIP DP18, 4T,		; ..
U 2666, 2670,1553,0500,4374,4007,0532,4000,0000,0340	; 8739		J/KIF10			;FOLLOW EXEC PATH
							; 8740	KIUPT:	[ARX]_[ARX]+[UBR],	;POINTER TO PAGE MAP ENTRY
							; 8741		LOAD VMA,		;PUT ADDRESS IN VMA
							; 8742		VMA PHYSICAL,		;ABSOLUTE ADDRESS
							; 8743		START READ,		;FETCH UPT WORD
U 2667, 4037,0111,1104,4174,4007,0700,0200,0024,1016	; 8744		J/KIF30			;JOIN COMMON CODE
							; 8745	=0
							; 8746	KIF10:	[BR]-#, 		;EXEC ADDRESS .GE. 340
							; 8747		#/400,			; SEE IF .GT. 400
							; 8748		SKIP DP18, 4T,		; ..
U 2670, 2672,1553,0500,4374,4007,0532,4000,0000,0400	; 8749		J/KIEPT			;LOOK AT KIF20
							; 8750		[ARX]_[ARX]+#, 3T,	;EXEC ADDRESS .LT. 340
							; 8751		#/600,			;IN EBR+600
U 2671, 2672,0551,0404,4374,4007,0701,0000,0000,0600	; 8752		J/KIEPT			;JOIN COMMON CODE
							; 8753	
							; 8754	=0
							; 8755	KIEPT:	[ARX]_[ARX]+[EBR],	;ADD OFFSET TO
							; 8756		LOAD VMA,		; EPT
							; 8757		START READ,		;START FETCH
							; 8758		VMA PHYSICAL,		;ABSOLUTE ADDRESS
U 2672, 4037,0111,1004,4174,4007,0700,0200,0024,1016	; 8759		J/KIF30			;GO GET POINTER
							; 8760		[ARX]_[ARX]+#,		;PER PROCESS PAGE
							; 8761		#/220, 3T,		; IS IN UPT + 400
U 2673, 2667,0551,0404,4374,4007,0701,0000,0000,0220	; 8762		J/KIUPT			;JOIN COMMON CODE
							; 8763	KIF30:	MEM READ,		;WAIT FOR DATA
U 4037, 4040,3771,0004,4365,5007,0700,0200,0000,0002	; 8764		[ARX]_MEM		;PLACE IT IN ARX
							; 8765		TR [BR],		;SEE IF EVEN OR ODD
U 4040, 2674,4553,0500,4374,4007,0331,0000,0000,0001	; 8766		#/1			; ..
							; 8767	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 242
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8768	;STILL .IF/KIPAGE
							; 8769	=0
							; 8770	KIF40:	READ [ARX],		;ODD
							; 8771		SKIP DP18,		;SEE IF VALID
U 2674, 2676,3333,0004,4174,4007,0530,0000,0000,0000	; 8772		J/KIF50			;JOIN COMMON CODE
							; 8773		[ARX]_[ARX] SWAP,	;EVEN--FLIP AROUND
U 2675, 2674,3770,0404,4344,4007,0700,0000,0000,0000	; 8774		J/KIF40			; AND CONTINUE
							; 8775	
							; 8776	.ENDIF/KIPAGE
							; 8777	=0
U 2676, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8778	KIF50:	PAGE FAIL TRAP
							; 8779	;AT THIS POINT WE HAVE THE PAGE MAP ENTRY IN RH OF AR
							; 8780		[FLG]_[FLG].AND.NOT.#,	;CLEAR W AND C
U 2677, 4041,5551,1313,4374,4007,0700,0000,0002,4000	; 8781		FLG.W/1, FLG.C/1	; FLAGS
U 4041, 2700,4553,0400,4374,4007,0331,0000,0002,0000	; 8782		TR [ARX], #/020000	;CACHE ENABLED?
							; 8783	=0	[FLG]_[FLG].OR.#,	;SET CACHE BITS
U 2700, 2701,3551,1313,4374,0007,0700,0000,0000,4000	; 8784		FLG.C/1, HOLD RIGHT	; ..
U 2701, 2702,4553,0400,4374,4007,0331,0000,0004,0000	; 8785		TR [ARX], #/040000	;DO NOT CACHE
							; 8786					;SEE IF CACHE BIT SET
							; 8787	=0	[BRX]_[BRX].OR.#,	;COPY BITS TO BRX
							; 8788		#/020000,
U 2702, 2703,3551,0606,4374,0007,0700,0000,0002,0000	; 8789		HOLD RIGHT
							; 8790		TR [ARX],		; ..
U 2703, 2704,4553,0400,4374,4007,0331,0000,0010,0000	; 8791		#/100000
							; 8792	=0	[FLG]_[FLG].OR.#,	;SAVE W
							; 8793		FLG.W/1,		; ..
							; 8794		HOLD RIGHT,		; ..
U 2704, 4042,3551,1313,4374,0007,0700,0000,0002,0000	; 8795		J/KIF90			;ALL DONE
							; 8796		TL [BRX],		;W=0, WRITE REF?
U 2705, 2706,4553,0600,4374,4007,0321,0000,0001,0000	; 8797		WRITE CYCLE/1
							; 8798	=0
							; 8799	KIF80:	[BRX]_[BRX].OR.#,	;WRITE FAILURE
							; 8800		#/100000, HOLD RIGHT,	;INDICATE THAT ACCESS WAS ON
U 2706, 2676,3551,0606,4374,0007,0700,0000,0010,0000	; 8801		J/KIF50			;GO PAGE FAIL
U 2707, 2617,4443,0000,4174,4007,0700,0000,0000,0000	; 8802		J/PFDONE		;ALL DONE
							; 8803	
							; 8804	KIF90:	[BRX]_[BRX].OR.#,	;PAGE IS WRITABLE
							; 8805		#/40000,		;TURN ON IN BRX
U 4042, 2617,3551,0606,4374,4007,0700,0000,0004,0000	; 8806		J/PFDONE		;ALL SET
							; 8807	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 243
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8808	;HERE ON HARD PAGE FAILURES
U 4043, 2710,3333,0005,7174,4007,0700,0400,0000,0213	; 8809	HARD:	WORK[SV.BR]_[BR]	;SAVE BR (CLEANUP MAY NEED IT)
							; 8810	=0	[BR]_VMA,		;BUILD PAGE FAIL WORD
U 2710, 4047,3771,0005,4354,4007,0700,0010,0000,0000	; 8811		CALL [ABORT]		;CLEAR ERROR
							; 8812		[BR]_[BR].AND.#,	;SAVE THE FLAGS
							; 8813		#/401237,		; ..
U 2711, 4044,4551,0505,4374,0007,0700,0000,0040,1237	; 8814		HOLD RIGHT		; ..
							; 8815		[BRX]_[BRX].OR.[BR],	;COMPLETE PAGE FAIL WORD
U 4044, 2676,3111,0506,4174,4007,0700,0000,0000,0000	; 8816		J/KIF50			;GO TRAP
							; 8817	
U 4045, 1160,4443,0000,4174,4007,0370,0000,0000,0000	; 8818	PFPI1:	SKIP IRPT		;TIMER TRAP?
							; 8819	=00
							; 8820		[AR]_WORK[TIME1],	;YES--GET LOW WORD
							; 8821		SPEC/CLRCLK,		;CLEAR CLOCK FLAG
U 1160, 3621,3771,0003,7274,4117,0701,0010,0000,0301	; 8822		CALL [TOCK]		;DO THE UPDATE
U 1161, 2713,4443,0000,4174,4007,0700,0000,0000,0000	; 8823		J/PFT1			;EXTERNAL INTERRUPT
U 1162, 4046,4223,0000,4364,4277,0700,0200,0000,0010	; 8824		ABORT MEM CYCLE		;CLEAR 1MS FLAGS
							; 8825	=
							; 8826	PFPI2:	[AR]_WORK[SV.VMA],	;RESTORE VMA
U 4046, 4023,3771,0003,7274,4007,0701,0000,0000,0210	; 8827		J/PF125
							; 8828	
							; 8829	
U 4047, 0001,4223,0000,4364,4274,1700,0200,0000,0010	; 8830	ABORT:	ABORT MEM CYCLE, RETURN [1]
							; 8831	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 244
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8832	;HERE ON PAGE FAIL TRAP
							; 8833	=0
U 2712, 0104,4751,1217,4374,4007,0700,0000,0000,0100	; 8834	PFT:	HALT [IOPF]		;IO PAGE FAILURE
							; 8835	PFT1:	[AR]_WORK[SV.VMA],
U 2713, 2714,3771,0003,7274,4007,0611,0000,0000,0210	; 8836		SKIP/TRAP CYCLE		;SEE IF TRAP CYCLE
							; 8837	=0	TL [AR], FETCH/1,	;IS THIS AN INSTRUCTION FETCH
U 2714, 2716,4553,0300,4374,4007,0321,0000,0010,0000	; 8838		J/PFT1A			;GO LOOK BELOW
U 2715, 4050,3771,0003,7274,4007,0701,0000,0000,0425	; 8839		[AR]_WORK[TRAPPC]	;RESTORE PC
U 4050, 2720,3333,0003,4174,4467,0700,0000,0000,0004	; 8840		READ [AR], LOAD FLAGS, J/CLDISP
							; 8841	=0
U 2716, 1100,4443,0000,4174,4007,0700,0000,0000,0000	; 8842	PFT1A:	J/CLEANED		;YES--NO PC TO BACK UP
U 2717, 2720,1111,0701,4170,4007,0700,4000,0000,0000	; 8843	FIXPC:	[PC]_[PC]-1, HOLD LEFT	;DATA FAILURE--BACKUP PC
							; 8844	=0
U 2720, 1100,3333,0013,4174,4003,5701,0000,0000,0000	; 8845	CLDISP:	CLEANUP DISP		;GO CLEANUP AFTER PAGE FAIL
							; 8846	=0000
							; 8847	CLEANUP:
							; 8848	CLEANED:			;(0) NORMAL CASE
							; 8849		END STATE, SKIP IRPT,	;NO MORE CLEANUP NEEDED
U 1100, 2722,4221,0013,4170,4007,0370,0000,0000,0000	; 8850		J/PFT2			;HANDLE PAGE FAIL OR INTERRUPT
							; 8851		[AR]_WORK[SV.ARX],	;(1) BLT
U 1101, 3206,3771,0003,7274,4007,0701,0000,0000,0212	; 8852		J/BLT-CLEANUP
							; 8853		[PC]_[PC]+1,		;(2) MAP
U 1102, 4053,0111,0701,4174,4007,0700,0000,0000,0000	; 8854		J/MAPDON
							; 8855		STATE_[EDIT-SRC],	;(3) SRC IN STRING MOVE
U 1103, 3523,3771,0013,4370,4007,0700,0000,0000,0011	; 8856		J/STRPF
							; 8857		STATE_[EDIT-DST],	;(4) DST IN STRING MOVE
U 1104, 3523,3771,0013,4370,4007,0700,0000,0000,0012	; 8858		J/STRPF
							; 8859		STATE_[SRC],		;(5) SRC+DST IN STRING MOVE
U 1105, 2334,3771,0013,4370,4007,0700,0000,0000,0003	; 8860		J/BACKD
							; 8861		STATE_[EDIT-DST],	;(6) FILL IN MOVSRJ
U 1106, 3532,3771,0013,4370,4007,0700,0000,0000,0012	; 8862		J/STRPF4
							; 8863		STATE_[EDIT-SRC],	;(7) DEC TO BIN
U 1107, 3527,3771,0013,4370,4007,0700,0000,0000,0011	; 8864		J/PFDBIN
							; 8865		STATE_[EDIT-SRC],	;(10) SRC+DST IN COMP
U 1110, 3521,3771,0013,4370,4007,0700,0000,0000,0011	; 8866		J/CMSDST
U 1111, 2326,4221,0013,4170,4007,0700,0000,0000,0000	; 8867		END STATE, J/BACKS	;(11) EDIT SRC FAIL
U 1112, 2334,4221,0013,4170,4007,0700,0000,0000,0000	; 8868		END STATE, J/BACKD	;(12) EDIT DST FAIL
							; 8869		STATE_[EDIT-SRC],	;(13) SRC+DST IN EDIT
U 1113, 2334,3771,0013,4370,4007,0700,0000,0000,0011	; 8870		J/BACKD
							; 8871	=
							; 8872	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 245
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8873	=0
							; 8874	PFT2:	[AR]_[UBR]+#,		;PREPARE TO STORE PFW
							; 8875		#/500, 3T,
U 2722, 4051,0551,1103,4374,4007,0701,0000,0000,0500	; 8876		J/PFT10
U 2723, 0770,3551,1313,4374,0007,0700,0000,0001,0000	; 8877	PFT3:	TAKE INTERRUPT		;PROCESS INTERRUPT
							; 8878	PFT10:	VMA_[AR],		;WHERE TO STORE PFW
U 4051, 2724,3443,0300,4174,4007,0700,0200,0021,1016	; 8879		VMA PHYSICAL WRITE
							; 8880	=0	MEM WRITE,		;STORE PFW
							; 8881		MEM_[BRX],
U 2724, 4055,3333,0006,4175,5007,0701,0210,0000,0002	; 8882		CALL [NEXTAR]		;ADVANCE POINTER TO
							; 8883					;PREPARE TO STORE PC
							; 8884	.IF/KLPAGE
							; 8885	.IF/KIPAGE
U 2725, 2726,4553,1000,4374,4007,0321,0000,0040,0000	; 8886		TL [EBR], #/400000	;KL PAGING?
							; 8887	=0
							; 8888	.ENDIF/KIPAGE
U 2726, 2732,4521,1205,4074,4007,0700,0000,0000,0000	; 8889		[BR]_FLAGS,J/EAPF	;YES--DO EXTENDED THING
							; 8890	.ENDIF/KLPAGE
							; 8891	
							; 8892	.IF/KIPAGE
U 2727, 4052,3741,0105,4074,4007,0700,0000,0000,0000	; 8893		[BR]_PC WITH FLAGS	;GET OLD PC
							; 8894		MEM WRITE,		;STORE OLD PC
							; 8895		MEM_[BR],
U 4052, 4054,3333,0005,4175,5007,0701,0200,0000,0002	; 8896		J/EAPF1
							; 8897	.ENDIF/KIPAGE
							; 8898	
							; 8899	MAPDON:	END STATE,		;CLEAR MAP BIT
U 4053, 2730,4221,0013,4170,4007,0370,0000,0000,0000	; 8900		SKIP IRPT		;ANY INTERRUPT?
							; 8901	=0	[AR]_[BRX],		;RETURN PAGE FAIL WORD
U 2730, 1500,3441,0603,4174,4003,7700,0200,0003,0001	; 8902		EXIT
U 2731, 2723,1111,0701,4174,4007,0700,4000,0000,0000	; 8903		[PC]_[PC]-1, J/PFT3	;INTERRUPTED OUT OF MAP
							; 8904					; RETRY INSTRUCTION
							; 8905	; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 246
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8906	
							; 8907	.IF/KLPAGE
							; 8908	=0
							; 8909	EAPF:	MEM WRITE, MEM_[BR],	;STORE FLAGS
U 2732, 4055,3333,0005,4175,5007,0701,0210,0000,0002	; 8910		CALL [NEXTAR]		;STORE PC WORD
U 2733, 4054,3333,0001,4175,5007,0701,0200,0000,0002	; 8911		MEM WRITE, MEM_[PC]	; ..
							; 8912	.ENDIF/KLPAGE
							; 8913	
							; 8914	EAPF1:	[AR]_[AR]+1,
							; 8915		VMA PHYSICAL READ,
U 4054, 2762,0111,0703,4174,4007,0700,0200,0024,1016	; 8916		J/GOEXEC
							; 8917	
U 4055, 0001,0111,0703,4170,4004,1700,0200,0023,1016	; 8918	NEXTAR:	NEXT [AR] PHYSICAL WRITE, RETURN [1]
							; 8919	


; Number of microwords used: 
;	D words= 512
;	U words= 2058, Highest= 4095

	END
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 247
; 								Cross Reference Listing					

(U) A				667 #
	AR			671 #	2425	2463	2493	2494	2557	2605	2613	2752	2754	2757	2760
				2763	2766	2850	2860	2875	2892	2902	2912	2922	2953	2963	2973
				3008	3020	3027	3031	3041	3042	3044	3046	3047	3055	3078	3079
				3305	3310	3312	3324	3327	3330	3335	3336	3406	3423	3425	3490
				3493	3561	3562	3568	3588	3615	3630	3666	3677	3689	3743	3766
				3771	3806	3850	3854	3863	3865	4026	4031	4061	4096	4110	4126
				4137	4140	4143	4157	4184	4185	4190	4207	4223	4243	4355	4364
				4369	4379	4385	4404	4408	4426	4454	4458	4460	4461	4480	4512
				4515	4518	4532	4557	4574	4575	4580	4585	4593	4595	4597	4668
				4678	4680	4685	4686	4731	4736	4746	4750	4788	4792	4796	4800
				4976	4989	5074	5077	5089	5092	5098	5104	5139	5214	5217	5319
				5325	5329	5330	5360	5366	5385	5391	5392	5393	5394	5403	5408
				5428	5429	5441	5443	5452	5453	5473	5478	5479	5485	5520	5524
				5526	5529	5532	5536	5538	5540	5542	5543	5544	5545	5551	5553
				5554	5563	5568	5584	5610	5618	5623	5625	5669	5682	5701	5710
				5714	5729	5743	5745	5747	5753	5780	5787	5790	5802	5805	5813
				5815	5819	5824	5826	5842	5847	5850	5872	5875	5876	5880	5998
				6002	6006	6013	6024	6033	6048	6068	6072	6085	6088	6114	6198
				6205	6222	6244	6258	6285	6296	6297	6298	6311	6345	6375	6386
				6424	6439	6467	6472	6501	6502	6503	6504	6506	6507	6510	6515
				6564	6585	6592	6593	6619	6657	6669	6670	6677	6697	6700	6703
				6707	6708	6710	6714	6716	6770	6771	6776	6777	6784	6787	6791
				6860	6882	6888	6907	6925	6929	6932	6933	6934	6935	6957	6982
				6983	6987	6993	6994	6998	7068	7074	7097	7099	7101	7103	7106
				7108	7110	7152	7159	7170	7174	7181	7185	7209	7215	7217	7222
				7230	7257	7320	7401	7403	7405	7407	7409	7411	7413	7415	7417
				7439	7445	7507	7517	7523	7526	7527	7544	7552	7602	7613	7626
				7628	7654	7659	7686	7689	7717	7735	7736	7795	7892	7900	7931
				8261	8271	8386	8395	8398	8400	8402	8406	8409	8420	8426	8431
				8474	8477	8482	8489	8497	8504	8526	8544	8548	8586	8589	8604
				8605	8626	8652	8655	8658	8676	8682	8687	8693	8707	8724	8837
				8878
	ARX			672 #	2525	2807	2808	3746	3748	3761	3790	4123	4135	4144	4145
				4162	4165	4167	4189	4209	4225	4245	4248	4268	4397	4425	4477
				4503	4504	4583	4675	4676	4684	4753	4943	4950	4951	4979	4982
				5003	5133	5155	5327	5365	5397	5583	5604	5607	5667	5684	5706
				5726	5746	5751	5797	5836	5843	6086	6127	6134	6168	6202	6252
				6261	6271	6280	6303	6304	6312	6344	6348	6425	6462	6470	6474
				6476	6793	6796	6842	6910	6984	7098	7102	7104	7107	7109	7138
				7140	7351	7364	7368	7558	7741	7743	7801	8028	8373	8381	8429
				8443	8466	8580	8612	8614	8678	8750	8760	8773	8782	8785	8790
	BR			673 #	2224	2421	2456	2458	2462	2943	3074	3107	3108	3111	3112
				3113	3114	3129	3132	3135	3138	3142	3145	3147	3179	3180	3183
				3184	3465	3468	3471	3474	3477	3480	3483	3486	3811	3816	3844
				3871	3880	3881	4028	4033	4131	4263	4428	4430	4438	4442	4505
				4508	4582	4586	4587	4588	4591	4596	4627	4769	4771	4830	4831
				4832	4833	4834	4841	4850	4854	4863	4924	4925	4926	4927	4928
				4949	4992	4998	5101	5141	5143	5153	5158	5242	5326	5333	5334
				5338	5339	5395	5398	5432	5483	5566	5590	5592	5602	5616	5695
				5713	5716	5952	5964	5965	5967	5968	5995	6004	6049	6054	6079
				6082	6173	6238	6241	6242	6255	6263	6269	6392	6402	6413	6422
				6426	6444	6497	6512	6550	6561	6628	6884	6885	6926	6927	6967
				6975	6986	6990	7067	7070	7095	7129	7131	7134	7196	7207	7221
				7223	7248	7249	7319	7330	7337	7406	7408	7410	7416	7418	7454
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 248
; 								Cross Reference Listing					

				7467	7564	7587	7588	7589	7630	7632	7660	7664	7666	7670	7672
				7696	7702	7793	8269	8344	8347	8360	8486	8610	8736	8746	8765
				8812	8815
	BRX			674 #	4159	4187	4193	4264	4287	4307	4311	4315	4319	4325	4329
				4333	4337	4414	4467	4507	4619	4622	4633	5080	5132	5161	5169
				5176	5200	5285	5288	5358	5359	5361	5400	5405	5595	5612	5678
				5692	5693	5735	5956	6055	6125	6136	6137	6161	6210	6218	6299
				6328	6341	6350	6355	6363	6365	6374	6380	6385	6397	6436	6438
				6456	6465	6492	6494	6496	6527	6530	6546	6558	6560	6640	6642
				6645	6711	6718	6812	6816	6820	6824	6828	6832	6848	7121	7265
				7266	7267	7366	7516	7571	7572	7635	7718	8265	8329	8330	8333
				8339	8341	8515	8518	8521	8543	8551	8593	8597	8599	8601	8616
				8620	8787	8796	8799	8804	8901
	EBR			676 #	7014	7231	7232	7233	7246	7519	7562	8351	8384	8755	8886
	FLG			679 #	3657	5547	5648	5649	5656	5783	5786	5789	5792	5852	5859
				5860	6636	8326	8405	8425	8493	8503	8517	8523	8555	8576	8596
				8615	8617	8660	8685	8690	8714	8723	8778	8780	8783	8792	8877
	HR			670 #	2325	2331	2337	2343	2352	2356	2365	2370	2471	2819	2824
				3565	3574	3577	3579	3580	3581	3600	3604	3614	3619	3622	3642
				3663	3676	3958	3960	3962	3964	3966	3968	3970	3972	3978	3998
				4076	5954	6947	7024	7030	7039	7040	7041	7045	7046	7047	7048
				7053	7054	7055	7058	7059	7060	7061	7062	7063	7064	7065	7286
				7309	7404	7720	7734	7863	7872	7874	7876	7878	7880	7882
	MAG			668 #	2460	4169	4172	4191	4194	4195	4208	4214	4216	4250	4252
				4254	4432	4450	4472	4476	4479	4520	4522	4523	4650	4655	4660
				4666	4667	5262	5263	5586	5677	5732	5758	5793	5828	5832	5834
	MASK			678 #	2186	2187	2188	2191	2194	2227	2238	2274	2278	2281	2284
				2293	2296	2299	2302	2553	2776	2797	3004	3052	3616	3664	3678
				3699	3982	3999	4022	4025	4070	4130	4266	4300	4434	4445	4473
				4598	4810	4930	4941	5247	5267	5268	5269	5283	5488	5548	5621
				5671	5761	5830	5919	5921	5923	5925	5927	5929	5931	5933	5935
				6170	6172	6194	6309	6631	7318	7361	7362	7363	7497	7498	7499
				7500	7501	7502	7503	7509	7528	7538	7556	7570	7648	7651	7687
				7698	7704	7721	7777	7930	8283	8305	8307	8321	8834	8889
	ONE			675 #	2216	2220	2265	2267	2312	2399	2450	2453	2983	3374	3440
				3456	3523	3537	3563	3572	3575	3650	3668	3671	4018	4065	4081
				4360	4775	5072	5140	5181	5183	5188	5205	5206	5290	5291	5475
				5487	5562	5711	5869	5990	6031	6064	6070	6091	6109	6119	6138
				6139	6174	6175	6217	6281	6286	6349	6361	6368	6388	6395	6400
				6409	6419	6423	6427	6428	6464	6478	6489	6541	6565	6659	6681
				6734	6857	6858	6864	6886	6928	6970	7325	7348	7378	7430	7714
				7791	7916	8002	8009	8012	8015	8018	8021	8843	8853	8903	8914
				8918
	PC			669 #	2264	2268	2286	2379	2441	2466	3362	3489	3494	3725	3842
				3848	3868	4054	4255	4257	4732	4741	7003	7421	7540	7692	7927
				8893
	PI			680 #	3628	3629	3643	7049	7050	7398	7412	7414	7419	7429	7431
				7490	7491	7492	7493	7494	7495	7496	7505
	T0			682 #	4235	4239	4475	4486	4493	4496	4498	4499	5603	5611	5637
				5639	5640	5641	5644	5652	5655	5657	5697	5763	5771	5772	6393
				6460	7432	7568
	T1			683 #	4452	4592	5258	5260	5264	5279	5282	5627	5712	5715	5734
				5744
	UBR			677 #	3984	4024	7006	7166	7200	7255	7256	7261	7262	8376	8740
				8874
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 249
; 								Cross Reference Listing					

	XWD1			681 #	3545	3715	7554
(D) A				1351 #
	DBLAC			1355 #	2811
	DFP			1361 #	5573	5574	5662	5723
	DREAD			1354 #	2802	2803	4118	4119	4202	4420
	DSHIFT			1357 #	2993	2994
	FP			1359 #	5299	5300	5301	5302	5304	5305	5307	5308	5309	5310	5312
				5313	5344	5345	5346	5348	5350	5351	5373	5374	5375	5377	5379
				5380	5458	5459
	FPI			1358 #	5303	5311	5349	5378
	IOT			1362 #	7035	7036	7272	7594	7595	7596	7597	7605	7606	7607	7608
				7619	7620	7621	7622	7887	7888	8257
	RD-PF			1360 #	2583	2588	2593	2598	2636	2641	2646	2651	2656	2661	2666
				2671	2678	2683	2688	2693	2698	2703	2708	2713	2843	2853	2863
				2868	2885	2895	2905	2915	2935	2946	2956	2966	4089	4103	4151
				4176	4343	4348
	READ			1352 #	2586	2591	2596	2601	2620	2638	2639	2643	2644	2649	2654
				2659	2664	2669	2674	2680	2681	2685	2686	2691	2696	2701	2706
				2711	2716	2845	2846	2855	2856	2865	2866	2870	2871	2878	2887
				2888	2897	2898	2907	2908	2917	2918	2937	2938	2948	2949	2958
				2959	2968	2969	3222	3223	3224	3225	3226	3227	3238	3239	3240
				3241	3242	3243	3244	3245	3256	3257	3258	3259	3260	3261	3262
				3263	3273	3274	3275	3276	3277	3278	3279	3280	3395	3396	3397
				3398	3399	3400	3401	3402	3412	3413	3414	3415	3416	3417	3418
				3419	3429	3430	3431	3432	3433	3434	3435	3436	3445	3446	3447
				3448	3449	3450	3451	3452	3683	4091	4092	4105	4106	4153	4154
				4178	4179	4345	4346	4350	4351	4721	4722	4723	4724	4725	5423
	SHIFT			1356 #	2988	2989	2990
	WRITE			1353 #	2585	2590	2595	2600	2648	2653	2658	2663	2668	2673	2690
				2695	2700	2705	2710	2715	2812	2880	2881
(U) ACALU			1249 #
	AC+N			1251 #	2209	2210	2217	2407	2419	2525	2808	2817	3058	3079	3123
				3153	4123	4135	4214	4216	4218	4226	4228	4235	4237	4249	4250
				4251	4252	4253	4254	4366	4450	4472	4476	4479	4493	4494	4496
				4499	4518	4520	4522	4523	4649	4650	4653	4654	4655	4658	4659
				4660	4666	4667	5586	5677	5730	5732	5738	5797	5805	5843	5850
				5994	6002	6012	6015	6045	6048	6061	6068	6075	6085	6123	6133
				6153	6168	6185	6200	6202	6228	6231	6233	6240	6241	6242	6244
				6250	6252	6255	6261	6263	6291	6293	6294	6298	6305	6306	6307
				6311	6312	6319	6321	6326	6332	6348	6359	6371	6380	6386	6397
				6400	6402	6406	6419	6425	6426	6549	6580	6585	6590	6627	6629
				6733	6734	6846	6853	6860	6879	6881	6888	6908	6929	6965	6967
				6973	6975	6979	6982	6987
	B			1250 #
(D) ACDISP			1382 #	3552	7035	7036	7272
(U) ACN				1252 #	2407	2419	2525	2808	2817	3058	3079	3123	3153	4123	4135
				4214	4216	4218	4226	4228	4235	4237	4249	4250	4251	4252	4253
				4254	4366	4450	4472	4476	4479	4493	4494	4496	4499	4518	4520
				4522	4523	4649	4650	4653	4654	4655	4658	4659	4660	4666	4667
				5586	5677	5730	5732	5738	5797	5805	5843	5850	6332	6348	6359
				6406	6425
	BIN0			1259 #	2209	6228	6250	6255	6263	6294	6305	6306	6307	6311	6319
	BIN1			1260 #	2210	2217	6200	6202	6231	6233	6240	6241	6242	6244	6252
				6261	6291	6293	6298	6312	6321
	DLEN			1256 #	5994	6002	6015	6045	6048	6075	6085	6123	6133	6168	6326
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 250
; 								Cross Reference Listing					

				6371	6380	6386	6397	6400	6402	6419	6426	6733	6734	6846	6860
				6879	6979	6982	6987
	DSTP			1257 #	6012	6185	6580	6585	6629	6853	6908	6929	6973	6975
	MARK			1258 #	6549	6627
	SRCLEN			1254 #
	SRCP			1255 #	6061	6068	6153	6590	6881	6888	6965	6967
(U) AD				564 #	2191	2194	2227	2238	2274	2278	2281	2284	2293	2296	2299
				2302	2356	2553	2774	2776	2795	2797	3616	3699	3982	4022	4070
				4434	4445	5260	5919	5921	5923	5925	5927	5929	5931	5933	5935
				5965	6194	6309	6631	7318	7361	7362	7363	7497	7498	7499	7500
				7501	7502	7503	7509	7538	7556	7570	7648	7651	7687	7698	7704
				7721	7777	7930	8283	8305	8307	8321	8834
	A			593 #	2186	2188	2264	2268	2286	2331	2343	2370	2379	2421	2462
				2463	2466	2525	2557	2808	2824	3008	3020	3027	3031	3041	3042
				3044	3046	3047	3055	3074	3079	3107	3108	3111	3112	3113	3114
				3129	3132	3135	3138	3142	3145	3179	3180	3183	3184	3336	3362
				3425	3465	3477	3489	3490	3493	3494	3561	3562	3568	3588	3604
				3615	3630	3666	3677	3689	3743	3746	3748	3766	3771	3844	3850
				3863	3868	3881	4157	4159	4162	4184	4185	4187	4189	4207	4209
				4223	4225	4243	4245	4257	4263	4264	4266	4287	4300	4355	4364
				4379	4385	4414	4426	4428	4430	4442	4454	4458	4473	4477	4480
				4493	4499	4503	4512	4532	4580	4585	4586	4587	4592	4593	4595
				4597	4668	4732	4741	4746	4753	4769	4792	4800	4854	4930	4943
				4979	4998	5003	5077	5080	5098	5133	5153	5161	5169	5217	5242
				5247	5262	5263	5267	5268	5269	5282	5283	5285	5325	5326	5327
				5338	5360	5361	5365	5366	5385	5393	5395	5400	5403	5408	5441
				5443	5473	5475	5478	5479	5485	5520	5524	5526	5532	5540	5542
				5543	5544	5562	5563	5568	5595	5602	5603	5607	5610	5611	5618
				5623	5625	5637	5639	5640	5641	5644	5652	5655	5657	5667	5669
				5671	5678	5682	5684	5695	5701	5706	5710	5711	5714	5726	5729
				5751	5761	5763	5771	5772	5780	5787	5790	5802	5805	5819	5824
				5826	5847	5850	5872	5880	5968	6013	6033	6048	6068	6079	6085
				6114	6125	6161	6168	6202	6241	6261	6263	6298	6311	6312	6348
				6374	6380	6385	6386	6393	6397	6402	6424	6425	6426	6460	6494
				6503	6506	6510	6512	6550	6560	6585	6592	6628	6645	6670	6700
				6707	6718	6770	6787	6793	6884	6888	6907	6926	6929	6933	6935
				6967	6975	6982	6983	6987	6994	7049	7050	7152	7196	7215	7217
				7230	7246	7248	7256	7257	7262	7265	7267	7366	7398	7421	7439
				7445	7516	7523	7544	7552	7571	7589	7613	7626	7628	7635	7660
				7664	7670	7692	7696	7702	7736	7793	7795	7801	7892	7900	7927
				8028	8271	8341	8344	8360	8386	8406	8409	8429	8443	8580	8586
				8604	8610	8626	8707	8878	8901
	A+B			566 #	2216	2220	2265	2267	2312	2399	2450	2453	2819	3147	3374
				3440	3650	3668	3671	3811	3816	3984	4018	4024	4065	4081	4235
				4239	4268	4324	4328	4408	4504	4505	4508	4518	4591	4596	4622
				4626	4632	4775	5181	5183	5188	5205	5206	5290	5291	5339	5483
				5487	5566	5616	5697	5990	6054	6086	6091	6109	6138	6139	6244
				6258	6269	6271	6281	6349	6361	6368	6388	6409	6423	6478	6489
				6497	6541	6565	6659	6681	6708	6734	6886	6910	6928	6970	6990
				7006	7014	7319	7325	7348	7378	7519	7554	7564	7572	7791	7916
				8002	8009	8012	8015	8018	8021	8373	8381	8466	8740	8755	8853
				8914	8918
	A+Q			565 #	4475	4486	4507	5140	5604	5612	5713	5716	5869
	A-.25			577 #
	A-B-.25			582 #	4404	4460	4461	5139	5158	5176	5200	5288	5397	5405	5753
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 251
; 								Cross Reference Listing					

				6002	6137	6173	6392
	A-D-.25			578 #	6222	6462	6467	6515	8736	8746
	A-Q-.25			581 #
	A.AND.B			598 #	4193	4208	4425	4496	4949	5548	5797	5830	5832	5843	6024
				6170	7068	7074	7431	7587	8678
	A.AND.Q			597 #	4191	4432	4476	4520	4522	4598	4650	4655	4660	4666	4667
				4863	4941	4950	5793	5828
	A.EQV.B			625 #
	A.EQV.Q			624 #	4169	4172	4194	4195	4250	4252	4254	4523
	A.OR.B			590 #	2943	4131	4951	5104	5956	6055	6088	6127	6285	6716	7098
				7102	7109	7140	7185	7207	7209	7410	7416	7558	7654	7689	8601
				8815
	A.OR.Q			589 #	5258	5279	5627
	A.XOR.B			617 #	5834	7364
	A.XOR.Q			616 #
	B			592 #	2196	2204	2206	2207	2210	2212	2219	2221	2412	2432	2531
				2563	2569	2574	2577	2608	2627	2772	2779	2786	2793	2823	3104
				3120	3176	3321	3365	3368	3371	3377	3380	3383	3442	3596	3644
				3655	3695	3731	3737	3776	3782	3853	3988	3992	4002	4006	4008
				4014	4036	4042	4053	4057	4073	4080	4161	4306	4310	4332	4336
				4367	4373	4387	4392	4394	4399	4466	4468	4485	4501	4510	4571
				4578	4599	4729	4738	4742	4757	4760	4776	4857	4923	4931	4939
				4988	5001	5021	5053	5060	5324	5328	5411	5413	5445	5449	5482
				5522	5541	5609	5708	5717	5766	5784	5822	5958	5961	5974	5976
				5977	6007	6019	6053	6069	6095	6096	6097	6112	6154	6157	6159
				6163	6176	6187	6195	6203	6334	6336	6379	6398	6411	6415	6417
				6466	6473	6499	6513	6518	6540	6544	6596	6616	6630	6682	6690
				6764	6785	6807	6839	6889	6891	6913	6953	7004	7111	7113	7114
				7116	7119	7123	7224	7225	7291	7295	7299	7303	7307	7322	7333
				7338	7354	7357	7373	7377	7379	7387	7388	7440	7452	7458	7465
				7690	7732	7755	7761	7763	7797	7799	7908	7915	7980	7989	7995
				7999	8000	8001	8003	8004	8005	8007	8008	8010	8011	8013	8014
				8016	8017	8019	8020	8022	8023	8025	8267	8288	8289	8291	8292
				8299	8309	8311	8313	8315	8319	8320	8355	8454	8461	8463	8484
				8622	8680	8734	8770	8809	8840	8845	8881	8895	8909	8911
	B-.25			576 #
	B-A-.25			574 #	3456	3563	3572	3575	4314	4318	4588	4619	6049	6070	6174
				6175	6286	6375	6427	6464	6857	6986	7330	7454	7467	7714	8843
				8903
	D			596 #	2185	2189	2214	2215	2217	2255	2305	2375	2389	2393	2398
				2402	2406	2407	2419	2420	2425	2430	2441	2447	2605	2624	2725
				2727	2752	2754	2757	2758	2760	2763	2764	2766	2781	2783	2788
				2790	2817	3001	3018	3024	3036	3039	3077	3123	3126	3305	3310
				3423	3468	3471	3474	3480	3483	3486	3509	3585	3592	3609	3624
				3629	3649	3653	3714	3725	3753	3759	3786	3795	3806	3808	3842
				3848	3865	3866	3879	3880	3884	3998	4041	4054	4143	4158	4167
				4186	4190	4228	4233	4248	4251	4253	4255	4356	4365	4366	4448
				4577	4731	4736	4750	4752	4756	4771	4804	4830	4831	4832	4833
				4834	4850	4924	4925	4926	4927	4928	4976	4985	4992	5006	5008
				5012	5016	5018	5022	5051	5056	5079	5092	5094	5132	5141	5145
				5152	5196	5214	5215	5240	5245	5322	5355	5387	5451	5529	5545
				5587	5597	5689	5740	5875	5951	5970	5979	5994	5997	6011	6012
				6015	6037	6040	6045	6061	6062	6072	6082	6099	6100	6101	6102
				6110	6116	6124	6133	6135	6153	6155	6162	6166	6179	6181	6185
				6197	6200	6209	6228	6231	6233	6240	6250	6291	6293	6294	6299
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 252
; 								Cross Reference Listing					

				6326	6331	6332	6333	6345	6354	6359	6371	6377	6387	6390	6391
				6406	6418	6420	6421	6439	6442	6491	6496	6501	6502	6542	6549
				6564	6580	6590	6599	6603	6618	6627	6629	6633	6654	6661	6663
				6694	6710	6731	6733	6771	6796	6846	6851	6853	6860	6862	6879
				6881	6882	6885	6908	6925	6927	6937	6952	6965	6969	6973	6979
				6998	7003	7022	7042	7043	7080	7082	7094	7105	7128	7129	7137
				7155	7220	7277	7279	7281	7283	7285	7290	7294	7298	7302	7306
				7315	7320	7324	7329	7335	7336	7347	7367	7371	7386	7392	7406
				7419	7429	7448	7450	7461	7463	7487	7513	7524	7540	7542	7561
				7566	7584	7616	7657	7724	7727	7729	7737	7751	7782	7785	7787
				7896	7903	7935	7982	7987	7991	7994	8006	8024	8026	8027	8029
				8264	8268	8270	8290	8296	8301	8368	8371	8390	8438	8455	8458
				8472	8482	8536	8538	8567	8583	8623	8624	8625	8631	8651	8712
				8764	8773	8810	8820	8826	8835	8839	8851	8855	8857	8859	8861
				8863	8865	8869	8893
	D+A			570 #	2325	2337	2352	2365	3523	3545	3600	3715	3761	3790	3854
				3871	4096	4123	4126	4788	4796	5074	5143	5155	5964	5967	6031
				6064	6119	6217	6242	6252	6255	6395	6413	6456	6465	6472	6474
				6593	6669	6776	6784	6858	6864	6932	6934	7368	7517	7562	7735
				7741	7743	8376	8384	8398	8400	8477	8652	8750	8760	8874
	D+Q			571 #	5024	5032	5063	5082
	D-.25			588 #
	D-A-.25			586 #	3406	3537	4110	4135	4137	4140	5089	6400	6419
	D-Q-.25			587 #
	D.AND.A			605 #	2458	2460	2471	2493	2807	2850	2973	3004	3052	3312	3335
				3565	3574	3577	3579	3580	3581	3614	3619	3622	3628	3642	3643
				3663	3664	3676	3678	3958	3960	3962	3964	3966	3968	3970	3972
				3978	3999	4025	4026	4031	4076	4144	4214	4216	4397	4450	4472
				4479	4675	4810	4982	4989	5101	5264	5329	5333	5358	5391	5428
				5432	5452	5547	5586	5677	5712	5715	5732	5783	5786	5789	5792
				5852	5952	5954	5995	5998	6134	6136	6172	6198	6205	6218	6238
				6280	6296	6303	6328	6344	6363	6422	6436	6438	6470	6476	6492
				6504	6507	6527	6530	6546	6561	6677	6711	6714	6777	6791	6947
				6957	7024	7030	7039	7040	7041	7045	7046	7047	7048	7053	7054
				7055	7058	7059	7060	7061	7062	7063	7064	7065	7097	7099	7101
				7103	7106	7108	7110	7131	7134	7159	7166	7170	7174	7181	7200
				7221	7222	7231	7249	7255	7261	7266	7286	7309	7351	7401	7403
				7404	7405	7407	7409	7411	7413	7415	7417	7528	7568	7602	7659
				7666	7672	7686	7718	7720	7734	7863	7872	7874	7876	7878	7880
				7882	8265	8269	8329	8333	8351	8395	8402	8405	8420	8425	8474
				8489	8493	8497	8503	8517	8521	8523	8543	8548	8576	8589	8596
				8599	8615	8617	8655	8658	8660	8682	8685	8687	8690	8693	8714
				8724	8765	8778	8782	8785	8790	8796	8812	8837	8886	8889
	D.AND.Q			606 #	3149	4550	5250	5256	5270	5276	5363	5672
	D.EQV.A			629 #	2922
	D.EQV.Q			630 #
	D.OR.A			594 #	2187	2456	2494	2902	3330	4028	4033	4145	4498	4583	5330
				5334	5359	5392	5453	5592	5648	5649	5656	5693	5745	5859	6210
				6297	6341	6350	6355	6365	6636	6640	6642	6703	6816	6820	6824
				6832	6848	6984	6993	7223	7232	7337	7412	7490	7491	7492	7493
				7494	7495	7496	7630	7931	8261	8326	8330	8431	8515	8518	8526
				8544	8551	8593	8597	8614	8616	8620	8676	8783	8787	8792	8799
				8804	8877
	D.OR.Q			595 #	3151	4435
	D.XOR.A			621 #	2224	2892	3327	4452	7526	7527	8339
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 253
; 								Cross Reference Listing					

	D.XOR.Q			622 #
	Q			591 #	3153	4163	4171	4218	4226	4226	4237	4249	4391	4446	4463
				4469	4474	4478	4484	4492	5011	5173	5199	5287	5410	5415	5486
				5528	5552	5646	5653	5673	5685	5696	5755	5757	5801	5846	6143
				6182	6584
	Q-.25			575 #
	Q-A-.25			573 #	4467	5072
	Q-D-.25			579 #	5015
	ZERO			602 #	2197	2197	2199	2202	2209	2211	2213	2230	2252	2436	2840
				3017	3058	3078	3307	3645	4009	4262	4288	4358	4494	4572	4839
				4852	4858	4859	4862	4934	4935	4938	4994	5137	5179	5203	5289
				5336	5407	5418	5430	5434	5436	5437	5450	5463	5555	5728	5756
				5795	5811	5839	6020	6022	6056	6075	6123	6128	6140	6151	6180
				6301	6319	6321	6339	6373	6429	6433	6437	6440	6495	6619	6657
				6697	6767	6842	7067	7070	7138	7192	7204	7250	7327	7402	7447
				7472	7473	7505	7508	7515	7529	7744	7789	7910	7913	7983	8325
				8347	8426	8486	8504	8592	8612	8654	8824	8830	8849	8867	8868
				8899
	-A-.25			585 #	2613	2983	4360	4438	4515	4557	4575	4582	4676	4680	4684
				4686	5319	5394	5398	5429	5538	5554	5583	5584	5735	5746	5747
				5815	5836	5842	6304	6428	7430
	-B-.25			584 #	5736
	-D-.25			580 #	4489	4649	4654	4659	4664	6035	6307	6978	6992
	-Q-.25			583 #	4437	4488	4514	4555	4556	4573	5416	5521	5523	5525	5527
				5810
	.NOT.A			628 #	2875	2912	2953	2963	3324	4130	4369	4574	4678	4685	5488
				5536	5551	5553	5734	5744	5813	6004	6006	6558	7432	7507	7717
				8723
	.NOT.A.AND.B		609 #	4165	5621	7104	7107	7408	7418	7588
	.NOT.A.AND.Q		608 #	5758
	.NOT.B			627 #	5841	6213
	.NOT.D			631 #	2932	2942	4653	4658	4663	6052	6080	6084	6220	6224	6306
				6996
	.NOT.D.AND.A		613 #	2860	3657	4061	5590	5692	5743	5860	6444	6812	6828	7095
				7121	7233	7414	7632	8555	8605	8780
	.NOT.D.AND.Q		614 #
	.NOT.Q			626 #	4948	5809	6023
	0+A			569 #	5876
	0+B			568 #
	0+D			572 #
	0+Q			567 #	5622	5769
(U) AD PARITY OK		741 #	2217	2393	2406	2407	2624	2725	2727	2758	2764	2817	3001
				3004	3018	3052	3509	3753	3786	3808	3866	3879	4186	4228	4365
				4756	5152	5240	5322	5355	5387	5451	5597	5994	5997	6012	6015
				6045	6061	6133	6135	6153	6185	6197	6200	6228	6231	6233	6240
				6250	6291	6293	6294	6326	6331	6332	6333	6354	6359	6371	6406
				6491	6549	6590	6627	6629	6733	6846	6853	6879	6881	6908	6965
				6973	6979	7616	7903	8302
(U) ADFLGS			1145 #	2614	3440	3456	3523	3537	4097	4111	4128	4138	4141	4268
				4679	4681
(U) AREAD			1179 #	2357
(U) B				687 #
	AR			691 #	2194	2196	2211	2274	2278	2281	2293	2296	2299	2356	2389
				2393	2398	2406	2412	2425	2430	2432	2441	2450	2450	2453	2453
				2462	2463	2493	2494	2531	2557	2563	2569	2574	2577	2605	2608
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 254
; 								Cross Reference Listing					

				2613	2725	2727	2752	2754	2757	2758	2760	2763	2764	2766	2772
				2774	2776	2779	2781	2783	2786	2788	2790	2793	2795	2797	2840
				2850	2860	2875	2892	2902	2912	2922	2932	2943	2943	2953	2963
				2973	2983	3001	3004	3008	3018	3020	3024	3027	3031	3036	3039
				3041	3042	3044	3046	3047	3077	3078	3079	3104	3120	3176	3305
				3310	3324	3327	3330	3335	3336	3365	3368	3371	3377	3380	3383
				3406	3423	3425	3440	3440	3442	3456	3650	3650	3668	3671	3671
				3678	3806	3811	3816	3866	3998	3999	4006	4025	4041	4042	4054
				4057	4061	4070	4073	4081	4096	4110	4126	4131	4131	4137	4140
				4143	4163	4169	4171	4172	4189	4190	4207	4255	4358	4360	4365
				4367	4392	4414	4448	4454	4458	4501	4505	4505	4508	4508	4512
				4515	4518	4532	4557	4571	4574	4575	4580	4585	4588	4591	4593
				4595	4596	4596	4597	4627	4663	4664	4668	4678	4680	4685	4686
				4729	4738	4742	4746	4757	4760	4769	4771	4775	4775	4776	4804
				4842	4857	4859	4862	4863	4923	4924	4925	4926	4927	4928	4931
				4939	4948	4949	4949	4951	4951	5006	5008	5018	5021	5022	5051
				5060	5074	5084	5089	5092	5094	5098	5176	5200	5214	5215	5217
				5288	5319	5326	5328	5329	5330	5339	5339	5365	5366	5387	5391
				5392	5403	5408	5410	5411	5413	5415	5416	5441	5443	5445	5449
				5451	5452	5453	5473	5478	5479	5482	5483	5483	5485	5487	5487
				5520	5522	5524	5526	5529	5532	5536	5538	5540	5541	5542	5543
				5544	5545	5548	5548	5551	5553	5554	5563	5566	5566	5568	5584
				5611	5616	5616	5618	5623	5625	5669	5706	5710	5714	5717	5740
				5743	5745	5747	5771	5772	5780	5784	5787	5790	5802	5805	5813
				5815	5819	5822	5824	5826	5841	5847	5850	5872	5875	5876	5880
				5919	5921	5923	5925	5927	5929	5931	5933	5935	5961	5990	5990
				5997	6004	6006	6007	6022	6023	6031	6035	6048	6049	6049	6052
				6054	6054	6055	6055	6061	6068	6069	6079	6080	6082	6084	6085
				6086	6086	6091	6091	6099	6138	6138	6139	6140	6153	6159	6166
				6170	6170	6173	6173	6176	6180	6185	6187	6194	6195	6197	6205
				6213	6217	6220	6224	6293	6296	6297	6298	6306	6307	6311	6331
				6333	6336	6345	6354	6371	6385	6386	6387	6388	6388	6393	6411
				6413	6415	6420	6424	6437	6439	6440	6442	6464	6467	6472	6478
				6478	6489	6501	6502	6503	6504	6506	6507	6540	6560	6564	6565
				6565	6585	6590	6592	6593	6596	6618	6619	6631	6633	6654	6657
				6659	6659	6661	6669	6677	6681	6681	6682	6694	6697	6700	6703
				6707	6710	6714	6731	6733	6734	6764	6770	6771	6776	6784	6785
				6787	6793	6842	6846	6851	6853	6857	6858	6860	6862	6864	6879
				6881	6884	6885	6886	6886	6888	6889	6891	6908	6913	6926	6927
				6928	6928	6929	6937	6952	6953	6957	6965	6969	6970	6973	6978
				6982	6986	6986	6987	6990	6990	6992	6993	6994	6996	7006	7006
				7014	7014	7155	7159	7170	7215	7217	7290	7291	7294	7295	7298
				7299	7302	7303	7306	7307	7315	7319	7319	7320	7322	7324	7325
				7325	7327	7329	7330	7330	7333	7335	7347	7357	7371	7386	7387
				7388	7447	7448	7452	7454	7454	7458	7461	7465	7467	7467	7505
				7509	7513	7516	7517	7519	7519	7524	7542	7552	7556	7558	7558
				7613	7635	7660	7666	7672	7721	7724	7729	7735	7737	7741	7743
				7744	7782	7791	7791	7896	7903	7930	7931	8004	8005	8006	8007
				8024	8025	8026	8261	8271	8288	8376	8384	8390	8398	8400	8406
				8409	8429	8431	8455	8458	8472	8477	8484	8489	8526	8536	8538
				8544	8580	8583	8586	8589	8601	8601	8631	8652	8654	8658	8680
				8712	8723	8820	8826	8835	8839	8840	8851	8874	8901	8914	8914
				8918
	ARX			692 #	2217	2221	2402	2407	2436	2460	2525	2807	2808	2817	2823
				3715	3746	3748	3753	3761	3786	3790	3865	3868	3982	3984	3984
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 255
; 								Cross Reference Listing					

				3992	4002	4018	4065	4123	4135	4144	4145	4161	4162	4167	4191
				4194	4195	4208	4208	4216	4226	4239	4239	4245	4248	4262	4268
				4288	4307	4311	4315	4319	4325	4329	4333	4337	4379	4391	4397
				4463	4469	4478	4572	4577	4583	4599	4619	4619	4622	4622	4633
				4675	4676	4684	4752	4756	4943	4950	4976	4979	4982	4985	4988
				5132	5181	5181	5206	5291	5325	5393	5394	5405	5583	5685	5697
				5697	5732	5755	5830	5830	5832	5832	5834	5834	5836	5869	6013
				6015	6033	6064	6070	6096	6101	6109	6109	6112	6114	6119	6133
				6137	6157	6163	6168	6174	6200	6202	6231	6252	6258	6258	6261
				6271	6271	6280	6291	6303	6304	6309	6312	6332	6334	6344	6348
				6349	6349	6359	6377	6406	6417	6421	6423	6423	6425	6462	6470
				6474	6476	6616	6796	6839	6907	6910	6983	6984	7003	7004	7097
				7099	7137	7138	7351	7354	7362	7366	7368	7379	7515	7554	7554
				7564	7564	7687	7689	7698	7704	7727	7785	7789	7801	7908	7913
				7916	7980	7982	7987	7991	7994	7995	7999	8002	8009	8012	8015
				8018	8021	8027	8029	8292	8360	8368	8371	8426	8443	8461	8463
				8504	8612	8623	8676	8740	8740	8750	8755	8755	8760	8764	8770
				8773
	BR			693 #	2219	2420	2421	2447	2456	2458	2624	2627	2942	3052	3074
				3107	3108	3111	3112	3113	3114	3126	3129	3132	3135	3138	3142
				3145	3147	3179	3180	3183	3184	3307	3312	3321	3465	3468	3471
				3474	3477	3480	3483	3486	3509	3523	3537	3545	3649	3655	3664
				3714	3725	3731	3737	3759	3776	3782	3808	3842	3844	3848	3853
				3863	3879	3880	3884	4022	4024	4024	4028	4033	4036	4130	4209
				4355	4364	4373	4387	4394	4399	4404	4408	4426	4428	4430	4438
				4442	4460	4461	4578	4582	4586	4587	4731	4736	4750	4810	4830
				4831	4832	4833	4834	4850	4852	4854	4989	4992	4994	4998	5001
				5016	5026	5053	5065	5101	5104	5140	5141	5143	5153	5155	5242
				5322	5324	5327	5333	5334	5338	5385	5429	5475	5488	5562	5587
				5590	5592	5603	5673	5711	5729	5736	5753	5951	5956	5956	5958
				5964	5965	5967	5970	5974	5976	5977	5979	5994	6002	6012	6019
				6045	6053	6072	6095	6100	6172	6228	6233	6240	6241	6242	6244
				6250	6255	6263	6269	6269	6281	6281	6294	6373	6374	6375	6375
				6395	6398	6400	6402	6409	6409	6419	6426	6428	6444	6496	6497
				6499	6510	6512	6513	6549	6558	6627	6629	6630	6882	6925	6967
				6975	6979	6998	7042	7043	7049	7050	7067	7068	7070	7074	7080
				7082	7094	7095	7098	7098	7102	7102	7104	7104	7113	7114	7116
				7128	7129	7131	7134	7140	7140	7181	7192	7196	7220	7221	7223
				7224	7225	7246	7248	7249	7250	7255	7261	7267	7277	7279	7281
				7283	7285	7318	7336	7337	7338	7361	7364	7367	7377	7392	7398
				7405	7406	7440	7450	7463	7528	7540	7562	7566	7572	7572	7584
				7589	7602	7616	7628	7630	7632	7648	7651	7654	7657	7664	7670
				7690	7696	7702	7793	7797	8008	8268	8299	8309	8311	8313	8315
				8341	8344	8347	8373	8381	8466	8482	8486	8604	8605	8624	8809
				8810	8812	8889	8893	8895	8909
	BRX			694 #	2215	2216	2216	4157	4159	4186	4187	4214	4233	4264	4287
				4385	4446	4504	5077	5080	5137	5139	5152	5158	5183	5188	5205
				5205	5240	5290	5290	5355	5358	5359	5361	5395	5397	5398	5400
				5586	5677	5678	5689	5692	5693	5726	5735	5954	5998	6088	6097
				6102	6125	6127	6135	6154	6161	6175	6198	6203	6210	6285	6285
				6299	6326	6328	6339	6341	6350	6355	6361	6361	6365	6368	6368
				6379	6380	6397	6427	6491	6518	6544	6546	6640	6642	6645	6690
				6708	6708	6711	6716	6716	6718	6807	6812	6816	6820	6824	6828
				6832	6848	7105	7107	7107	7109	7109	7111	7119	7121	7123	7256
				7262	7265	7266	7363	7497	7498	7499	7500	7501	7502	7503	7568
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 256
; 								Cross Reference Listing					

				7571	7626	7717	7777	8010	8264	8265	8267	8289	8290	8291	8301
				8305	8307	8319	8320	8321	8330	8333	8339	8355	8454	8515	8518
				8551	8593	8597	8599	8614	8616	8620	8622	8625	8734	8787	8799
				8804	8815	8815	8881
	EBR			696 #	2199	3988	7230	7232	7233	8013
	FLG			699 #	2202	2204	2206	2207	3657	5145	5179	5203	5289	5555	5648
				5649	5656	5795	5811	5839	5859	5860	6011	6037	6040	6056	6062
				6110	6116	6124	6128	6151	6155	6162	6181	6209	6301	6391	6418
				6429	6433	6495	6542	6599	6603	6636	6663	6767	8017	8270	8326
				8555	8592	8678	8678	8780	8783	8792	8845	8849	8855	8857	8859
				8861	8863	8865	8867	8868	8869	8877	8899
	HR			690 #	2214	2220	2220	2305	2337	2352	2365	2375	2399	2471	3565
				3574	3577	3579	3580	3581	3585	3596	3600	3609	3614	3619	3622
				3624	3642	3663	3676	3689	3695	3699	3958	3960	3962	3964	3966
				3968	3970	3972	3978	4009	4014	4053	4076	4080	4641	6947	7022
				7030	7039	7040	7041	7045	7046	7047	7048	7053	7054	7055	7058
				7059	7060	7061	7062	7063	7064	7065	7286	7309	7348	7373	7378
				7404	7732	7863	7872	7874	7876	7878	7880	7882	7935	8003
	MAG			688 #	2188	4266	4300	4425	4473	4496	4930	4935	4938	5247	5267
				5268	5269	5283	5671	5761	5797	5843	8000
	MASK			698 #	2185	2186	2187	3644	4165	5262	5263	6024	7989	8016
	ONE			695 #	2191	2210	2212	2819	6392	8011
	PC			689 #	2252	2265	2267	2312	2325	2331	3055	3374	3490	3493	3561
				3562	3563	3572	3575	3588	3615	3630	3653	3743	3795	3854	3871
				4008	6286	6541	6541	7544	7714	7799	8001	8843	8853	8853	8903
				8911
	PI			700 #	2230	7402	7408	7408	7410	7410	7412	7414	7416	7416	7418
				7418	7490	7491	7492	7493	7494	7495	7496	7587	7588	7588	8019
	T0			702 #	3629	4185	4193	4225	4228	4235	4474	4480	4484	4486	4488
				4493	4498	4499	5597	5602	5609	5610	5637	5639	5640	5641	5644
				5652	5655	5657	5684	5757	5763	6390	6456	6465	6466	7419	7429
				7430	7431	7431	7561	7751	7755	7761	7763	8022
	T1			703 #	2227	2238	2255	2284	2302	2553	3616	4434	4445	4452	4466
				4468	4485	4510	4592	5251	5259	5264	5271	5282	5621	5621	5646
				5653	5696	5708	5728	5734	5744	5766	6460	6473	7538	7570	7915
				8023	8283	8834
	UBR			697 #	2197	7166	7185	7185	7200	7204	7207	7207	7209	7209	8014
	XWD1			701 #	2189	8020
(D) B				1364 #	3213	3214	3215	3216	3217	3218	3222	3223	3224	3225	3226
				3227	3229	3230	3231	3232	3233	3234	3235	3236	3238	3239	3240
				3241	3242	3243	3244	3245	3247	3248	3249	3250	3251	3252	3253
				3254	3256	3257	3258	3259	3260	3261	3262	3263	3264	3265	3266
				3267	3268	3269	3270	3271	3273	3274	3275	3276	3277	3278	3279
				3280	3386	3387	3388	3389	3390	3391	3392	3393	3395	3396	3397
				3398	3399	3400	3401	3402	3412	3413	3414	3415	3416	3417	3418
				3419	3429	3430	3431	3432	3433	3434	3435	3436	3445	3446	3447
				3448	3449	3450	3451	3452	3498	3499	3500	3501	3502	3503	3504
				3505	3512	3513	3514	3515	3516	3517	3518	3519	3526	3527	3528
				3529	3530	3531	3532	3533	3540	3541	3705	3706	3707	3802	3891
				3892	3893	3894	3895	3896	3897	3898	3948	3949	3950	3951	3952
				3953	5888	5889	5890	5891	5892	5893	5894	5896	5897	5898	5899
				5901	5902	5903	5904	5909	5910	5911	5912	5913	7594	7595	7596
				7597	7605	7606	7607	7608	7619	7620	7621	7622	7806	7807	7808
				7810	7811	7813	7814	7816	7817	7818	7819	7820	7821	7822	7823
				7825	7826	7827	7828	7829	7830	7831	7832	7834	7835	7836	7837
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 257
; 								Cross Reference Listing					

				7838	7839	7840	7841	7843	7844	7845	7846	7847	7848	7849	7850
				7852	7853	7854	7855	7856	7857	7858	7859
	AC			1368 #	2583	2584	2588	2589	2593	2594	2598	2599	2620	2636	2637
				2641	2642	2646	2647	2651	2652	2656	2657	2661	2662	2666	2667
				2671	2672	2678	2679	2683	2684	2688	2689	2693	2694	2698	2699
				2703	2704	2708	2709	2713	2714	2803	2833	2834	2843	2844	2853
				2854	2863	2864	2868	2869	2885	2886	2895	2896	2905	2906	2915
				2916	2925	2926	2935	2936	2946	2947	2956	2957	2966	2967	2976
				2977	4089	4090	4103	4104	4151	4152	4721	8257
	BOTH			1370 #	2836	2846	2856	2866	2871	2888	2898	2908	2918	2928	2938
				2949	2959	2969	2979	4092	4106	4154
	DBLAC			1366 #	2802	4118	4119	4176	4177	4202	4343	4344	4348	4349	4420
				5662	5723
	DBLB			1367 #	4179	4346	4351
	MEM			1369 #	2585	2590	2595	2600	2638	2643	2648	2653	2658	2663	2668
				2673	2680	2685	2690	2695	2700	2705	2710	2715	2835	2845	2855
				2865	2870	2880	2881	2887	2897	2907	2917	2927	2937	2948	2958
				2968	2978	4091	4105	4153	4178	4345	4350	7272
	SELF			1365 #	2586	2591	2596	2601	2639	2644	2649	2654	2659	2664	2669
				2674	2681	2686	2691	2696	2701	2706	2711	2716
(U) BWRITE			1188 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	4097	4111	4163
				4169	4192	4194	5483	5487	5533	5555	8602	8902
(U) BYTE			847 #
	BYTE1			848 #	4731	4736	4750	4771	4924	6072	6082	6564	6710	6882	6885
				6925	6927	6998
	BYTE2			849 #	4925
	BYTE3			850 #	4926
	BYTE4			851 #	4927
	BYTE5			852 #	3077	4830	4831	4832	4833	4834	4928	6694
(U) CALL			999 #	2192	2218	2230	2435	2807	2817	3587	3626	3628	3629	3643
				3667	3670	3867	3870	3985	4001	4006	4010	4016	4019	4053	4055
				4160	4188	4215	4224	4234	4244	4267	4377	4398	4453	4459	4473
				4477	4483	4529	4553	4731	4736	4740	4745	4750	4759	4762	5010
				5020	5054	5081	5136	5152	5154	5241	5253	5255	5273	5275	5362
				5404	5407	5412	5414	5522	5524	5526	5541	5542	5543	5602	5610
				5638	5678	5683	5695	5702	5709	5728	5752	5756	5760	5785	5788
				5791	5823	5825	5827	5833	5953	5993	5996	6000	6032	6038	6063
				6087	6098	6113	6117	6124	6134	6136	6142	6156	6165	6186	6201
				6204	6217	6232	6243	6251	6254	6257	6260	6268	6273	6300	6335
				6344	6360	6372	6399	6410	6418	6435	6461	6490	6493	6498	6573
				6581	6591	6594	6604	6617	6632	6639	6660	6664	6732	6766	6790
				6890	6909	6914	6966	6974	6985	7256	7326	7350	7353	7372	7419
				7449	7462	7511	7541	7543	7559	7563	7601	7612	7627	7646	7655
				7684	7691	7716	7909	7911	7917	7933	7981	7983	8000	8003	8005
				8007	8010	8013	8016	8019	8022	8024	8394	8401	8412	8419	8430
				8439	8457	8460	8473	8496	8506	8537	8568	8653	8811	8822	8882
				8910
(U) CHKL			752 #	2305	2375	2389	2398	2402	2419	2430	2441	2447	2460	2531
				2563	2569	2574	2577	2627	2823	3123	3442	3585	3609	3624	3649
				3653	3714	3731	3737	3759	3776	3782	3795	3853	3884	4006	4008
				4014	4041	4053	4057	4080	4158	4251	4253	4356	4366	4450	4472
				4479	4776	4804	4810	4931	5196	5245	5951	5970	6390	6580	6630
				6633	6661	6937	6952	7022	7155	7290	7294	7298	7302	7306	7347
				7377	7379	7386	7440	7524	7566	7690	7737	7782	7785	7787	7797
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 258
; 								Cross Reference Listing					

				7799	7896	7915	7935	8000	8001	8003	8004	8007	8008	8010	8011
				8013	8014	8016	8017	8019	8020	8022	8023	8025	8390	8472	8712
				8764	8881	8895	8909	8911
(U) CHKR			759 #	2305	2375	2389	2398	2402	2419	2430	2441	2447	2460	2531
				2563	2569	2574	2577	2627	2823	3123	3442	3585	3609	3624	3649
				3653	3714	3731	3737	3759	3776	3782	3795	3853	3884	4006	4008
				4014	4041	4053	4057	4080	4158	4251	4253	4356	4366	4450	4472
				4479	4776	4804	4810	4931	5196	5245	5951	5970	6390	6580	6630
				6633	6661	6937	6952	7022	7155	7290	7294	7298	7302	7306	7347
				7377	7379	7386	7440	7524	7566	7690	7737	7782	7785	7787	7797
				7799	7896	7915	7935	8000	8001	8003	8004	8007	8008	8010	8011
				8013	8014	8016	8017	8019	8020	8022	8023	8025	8390	8472	8712
				8764	8881	8895	8909	8911
(U) CLKL			748 #	2265	2267	2312	2325	2326	2332	2337	2352	2353	2365	2376
				2399	2727	2758	2766	2788	2790	3374	3490	3493	3561	3562	3563
				3572	3575	3588	3600	3630	3654	3668	3796	3855	3869	3873	4018
				4030	4035	4065	4081	4132	4775	4805	5014	5073	5096	5145	5157
				5179	5183	5188	5203	5206	5216	5268	5269	5289	5291	5364	5627
				5964	5967	5970	6011	6037	6040	6056	6062	6091	6110	6116	6124
				6128	6139	6151	6155	6162	6181	6209	6286	6301	6339	6374	6391
				6418	6429	6433	6489	6495	6542	6599	6603	6638	6663	6704	6709
				6767	6886	6928	6937	7096	7122	7136	7205	7221	7223	7267	7348
				7353	7378	7412	7414	7416	7418	7430	7490	7491	7492	7493	7494
				7495	7496	7518	7588	7714	7735	7735	7916	7932	8002	8009	8012
				8015	8018	8021	8270	8546	8592	8600	8843	8849	8855	8857	8859
				8861	8863	8865	8867	8868	8869	8899	8918
(U) CLKR			755 #	2456	2458	2471	2493	2494	2725	2760	2764	2781	2783	2807
				3150	3152	3423	3565	3574	3577	3579	3580	3581	3614	3619	3622
				3642	3663	3676	3807	3958	3960	3962	3964	3966	3968	3970	3972
				3980	4000	4010	4062	4078	4143	4144	4145	4167	4190	4397	4436
				4498	4552	4675	4852	4987	4995	5058	5103	5138	5142	5329	5330
				5333	5334	5358	5359	5391	5392	5452	5453	5529	5545	5648	5649
				5656	5672	5794	5829	5859	5860	5875	5957	5979	6206	6211	6280
				6296	6297	6303	6342	6344	6351	6357	6366	6385	6437	6440	6445
				6470	6476	6547	6641	6643	6713	6717	6771	6813	6817	6821	6825
				6829	6833	6849	6947	6959	7030	7039	7040	7041	7045	7046	7047
				7048	7053	7054	7055	7058	7059	7060	7061	7062	7063	7064	7065
				7090	7130	7133	7161	7168	7172	7187	7193	7202	7210	7232	7233
				7251	7255	7261	7286	7309	7320	7404	7406	7408	7410	7542	7744
				7789	7863	7872	7874	7876	7878	7880	7882	8263	8266	8328	8332
				8335	8340	8491	8516	8553	8557	8591	8595	8598	8609	8679	8784
				8789	8794	8800	8814	8877
(U) CLRFPD			1117 #	3726	3843	3849	4246	4746	4763	6429
(D) COND FUNC			1387 #	2585	2586	2590	2591	2595	2596	2600	2601	2638	2639	2643
				2644	2648	2649	2653	2654	2658	2659	2663	2664	2668	2669	2673
				2674	2680	2681	2685	2686	2690	2691	2695	2696	2700	2701	2705
				2706	2710	2711	2715	2716	2835	2836	2845	2846	2855	2856	2865
				2866	2870	2871	2880	2881	2887	2888	2897	2898	2907	2908	2917
				2918	2927	2928	2937	2938	2948	2949	2958	2959	2968	2969	2978
				2979	4091	4092	4105	4106	4153	4154	4178	4179	4345	4346	4350
				4351	5300	5301	5304	5305	5308	5309	5312	5313	5345	5346	5350
				5351	5374	5375	5379	5380	7272
(U) CRY38			982 #	2613	2983	3406	3456	3537	3563	3572	3575	4110	4127	4135
				4140	4314	4318	4360	4404	4437	4460	4461	4467	4488	4514	4555
				4556	4557	4573	4575	4582	4588	4619	4649	4654	4659	4664	4676
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 259
; 								Cross Reference Listing					

				4680	4684	4686	5015	5072	5089	5139	5158	5176	5200	5288	5319
				5394	5397	5398	5405	5416	5429	5521	5523	5525	5527	5538	5554
				5583	5622	5735	5746	5753	5769	5810	5815	5836	5842	5876	6002
				6035	6049	6070	6137	6173	6174	6175	6222	6286	6304	6307	6375
				6392	6400	6419	6427	6428	6462	6464	6467	6515	6857	6978	6986
				6992	7330	7430	7454	7467	7714	8736	8746	8843	8903
(U) DBM				727 #
	APR FLAGS		730 #	7042	7043	7105	7137	7336
	BYTES			731 #
	DP			733 #	3077	4731	4736	4750	4771	4830	4831	4832	4833	4834	4924
				4925	4926	4927	4928	6072	6082	6564	6694	6710	6882	6885	6925
				6927	6998
	DP SWAP			734 #	2425	2605	2752	2754	2757	2760	2763	2766	3305	3310	3629
				3806	3865	3880	3998	4850	4976	4992	5092	5132	5141	5214	6439
				6496	6501	6502	6796	7129	7406	7419	7429	8482	8773
	EXP			732 #	5529	5545	5875	7361	7362	7363
	MEM			736 #	2197	2304	2375	2388	2397	2401	2429	2440	2446	2459	3584
				3608	3623	3645	3649	3653	3713	3758	3795	3883	4040	4803	4809
				5195	5244	5951	5970	6390	6633	6661	6937	6951	7007	7015	7022
				7154	7290	7294	7298	7302	7306	7346	7386	7508	7512	7524	7560
				7566	7656	7737	7782	7785	7787	7895	7910	7934	7983	8325	8389
				8471	8711	8763	8824	8830
	PF DISP			729 #	8295
	SCAD DIAG		728 #
	VMA			735 #	7751	7994	8264	8290	8810
	#			737 #	2185	2187	2189	2191	2194	2214	2215	2224	2227	2238	2255
				2274	2278	2281	2284	2293	2296	2299	2302	2456	2458	2471	2493
				2494	2553	2781	2783	2788	2790	2807	3078	3149	3151	3565	3574
				3577	3579	3580	3581	3614	3616	3619	3622	3628	3642	3643	3657
				3663	3676	3761	3790	3854	3871	3958	3960	3962	3964	3966	3968
				3970	3972	3978	3982	4022	4026	4028	4031	4033	4061	4070	4076
				4144	4145	4397	4434	4435	4445	4452	4498	4550	4577	4583	4675
				4840	4982	4985	4989	5008	5012	5018	5022	5051	5056	5089	5094
				5101	5145	5155	5251	5256	5264	5271	5276	5329	5330	5333	5334
				5358	5359	5363	5391	5392	5428	5432	5452	5453	5547	5590	5592
				5648	5649	5656	5672	5692	5693	5712	5715	5743	5745	5783	5786
				5789	5792	5852	5859	5860	5919	5921	5923	5925	5927	5929	5931
				5933	5935	5952	5954	5979	5995	5998	6011	6037	6040	6062	6110
				6116	6124	6134	6136	6155	6162	6181	6194	6198	6205	6209	6210
				6218	6222	6238	6280	6296	6297	6303	6309	6328	6341	6344	6350
				6355	6363	6365	6391	6418	6422	6436	6438	6444	6456	6465	6470
				6476	6492	6504	6507	6515	6527	6530	6542	6546	6561	6599	6603
				6619	6631	6636	6640	6642	6657	6663	6677	6697	6703	6711	6714
				6791	6812	6816	6820	6824	6828	6832	6842	6848	6947	6957	7024
				7030	7039	7040	7041	7045	7046	7047	7048	7053	7054	7055	7058
				7059	7060	7061	7062	7063	7064	7065	7067	7070	7080	7082	7095
				7097	7099	7101	7103	7106	7108	7110	7121	7131	7134	7138	7159
				7166	7170	7174	7181	7200	7221	7222	7223	7231	7232	7233	7249
				7255	7261	7266	7286	7309	7318	7337	7351	7401	7403	7404	7405
				7407	7409	7411	7412	7413	7414	7415	7417	7448	7450	7461	7463
				7490	7491	7492	7493	7494	7495	7496	7497	7498	7499	7500	7501
				7502	7503	7505	7509	7517	7526	7527	7538	7542	7556	7562	7568
				7570	7584	7648	7651	7659	7666	7672	7686	7687	7698	7704	7718
				7720	7734	7777	7863	7872	7874	7876	7878	7880	7882	7930	7931
				8261	8265	8269	8270	8283	8305	8307	8321	8326	8329	8330	8333
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 260
; 								Cross Reference Listing					

				8339	8347	8351	8376	8384	8395	8402	8405	8420	8425	8426	8474
				8486	8489	8493	8497	8503	8504	8515	8517	8518	8521	8523	8543
				8544	8548	8551	8555	8576	8589	8593	8596	8597	8599	8605	8612
				8614	8615	8616	8617	8620	8655	8660	8676	8682	8685	8687	8690
				8693	8714	8724	8736	8746	8750	8760	8765	8778	8780	8782	8783
				8785	8787	8790	8792	8796	8799	8804	8812	8834	8837	8855	8857
				8859	8861	8863	8865	8869	8874	8877	8886
(U) DBUS			718 #
	DBM			724 #	2185	2187	2189	2191	2194	2197	2214	2215	2224	2227	2238
				2255	2274	2278	2281	2284	2293	2296	2299	2302	2304	2305	2375
				2375	2388	2389	2397	2398	2401	2402	2425	2429	2430	2440	2441
				2446	2447	2456	2458	2459	2460	2471	2493	2494	2553	2605	2752
				2754	2757	2760	2763	2766	2781	2783	2788	2790	2807	3077	3078
				3149	3151	3305	3310	3565	3574	3577	3579	3580	3581	3584	3585
				3608	3609	3614	3616	3619	3622	3623	3624	3628	3629	3642	3643
				3645	3649	3649	3653	3653	3657	3663	3676	3713	3714	3758	3759
				3761	3790	3795	3795	3806	3854	3865	3871	3880	3883	3884	3958
				3960	3962	3964	3966	3968	3970	3972	3978	3982	3998	4022	4026
				4028	4031	4033	4040	4041	4061	4070	4076	4144	4145	4397	4434
				4435	4445	4452	4498	4550	4577	4583	4675	4731	4736	4750	4771
				4803	4804	4809	4810	4830	4831	4832	4833	4834	4840	4850	4924
				4925	4926	4927	4928	4976	4982	4985	4989	4992	5008	5012	5018
				5022	5051	5056	5089	5092	5094	5101	5132	5141	5145	5155	5195
				5196	5214	5244	5245	5250	5256	5264	5270	5276	5329	5330	5333
				5334	5358	5359	5363	5391	5392	5428	5432	5452	5453	5529	5545
				5547	5590	5592	5648	5649	5656	5672	5692	5693	5712	5715	5743
				5745	5783	5786	5789	5792	5852	5859	5860	5875	5919	5921	5923
				5925	5927	5929	5931	5933	5935	5951	5951	5952	5954	5970	5970
				5979	5995	5998	6011	6037	6040	6062	6072	6082	6110	6116	6124
				6134	6136	6155	6162	6181	6194	6198	6205	6209	6210	6218	6222
				6238	6280	6296	6297	6303	6309	6328	6341	6344	6350	6355	6363
				6365	6390	6390	6391	6418	6422	6436	6438	6439	6444	6456	6465
				6470	6476	6492	6496	6501	6502	6504	6507	6515	6527	6530	6542
				6546	6561	6564	6599	6603	6619	6631	6633	6633	6636	6640	6642
				6657	6661	6661	6663	6677	6694	6697	6703	6710	6711	6714	6791
				6796	6812	6816	6820	6824	6828	6832	6842	6848	6882	6885	6925
				6927	6937	6937	6947	6951	6952	6957	6998	7007	7015	7022	7022
				7024	7030	7039	7040	7041	7042	7043	7045	7046	7047	7048	7053
				7054	7055	7058	7059	7060	7061	7062	7063	7064	7065	7067	7070
				7080	7082	7095	7097	7099	7101	7103	7105	7106	7108	7110	7121
				7129	7131	7134	7137	7138	7154	7155	7159	7166	7170	7174	7181
				7200	7221	7222	7223	7231	7232	7233	7249	7255	7261	7266	7286
				7290	7290	7294	7294	7298	7298	7302	7302	7306	7306	7309	7318
				7336	7337	7346	7347	7351	7361	7362	7363	7386	7386	7401	7403
				7404	7405	7406	7407	7409	7411	7412	7413	7414	7415	7417	7419
				7429	7448	7450	7461	7463	7490	7491	7492	7493	7494	7495	7496
				7497	7498	7499	7500	7501	7502	7503	7505	7508	7509	7512	7513
				7517	7524	7524	7526	7527	7538	7542	7556	7560	7561	7562	7566
				7566	7568	7570	7584	7648	7651	7656	7657	7659	7666	7672	7686
				7687	7698	7704	7718	7720	7734	7737	7737	7751	7777	7782	7782
				7785	7785	7787	7787	7863	7872	7874	7876	7878	7880	7882	7895
				7896	7910	7930	7931	7934	7935	7983	7994	8261	8264	8265	8269
				8270	8283	8290	8295	8301	8305	8307	8321	8325	8326	8329	8330
				8333	8339	8347	8351	8376	8384	8389	8390	8395	8402	8405	8420
				8425	8426	8471	8472	8474	8482	8486	8489	8493	8497	8503	8504
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 261
; 								Cross Reference Listing					

				8515	8517	8518	8521	8523	8543	8544	8548	8551	8555	8576	8589
				8593	8596	8597	8599	8605	8612	8614	8615	8616	8617	8620	8655
				8660	8676	8682	8685	8687	8690	8693	8711	8712	8714	8724	8736
				8746	8750	8760	8763	8764	8765	8773	8778	8780	8782	8783	8785
				8787	8790	8792	8796	8799	8804	8810	8812	8824	8830	8834	8837
				8855	8857	8859	8861	8863	8865	8869	8874	8877	8886
	DP			722 #	2209	2210	2525	2531	2557	2563	2569	2574	2577	2627	2808
				2823	3058	3079	3114	3147	3153	3336	3423	3425	3442	3465	3468
				3468	3471	3471	3474	3474	3477	3480	3480	3483	3483	3486	3486
				3690	3731	3737	3746	3748	3776	3782	3811	3816	3844	3853	4006
				4008	4014	4053	4057	4080	4143	4167	4190	4218	4226	4235	4237
				4248	4248	4249	4250	4252	4254	4476	4492	4493	4494	4496	4499
				4518	4520	4523	4650	4655	4660	4666	4667	4668	4746	4776	4931
				5104	5153	5173	5199	5217	5242	5287	5479	5485	5797	5805	5841
				5842	5843	5850	6002	6048	6068	6075	6085	6088	6123	6125	6127
				6161	6168	6202	6244	6261	6263	6298	6299	6299	6311	6312	6319
				6321	6345	6345	6348	6380	6386	6397	6402	6424	6425	6426	6584
				6585	6630	6645	6718	6734	6771	6860	6860	6888	6929	6967	6975
				6982	6987	6994	7320	7377	7379	7440	7613	7690	7732	7797	7799
				7801	7915	8000	8001	8003	8004	8007	8008	8010	8011	8013	8014
				8016	8017	8019	8020	8022	8023	8025	8271	8845	8881	8895	8909
				8911
	PC FLAGS		719 #	3664	3678	3725	3842	3848	3999	4025	4054	4255	7003	7528
				7540	8889	8893
	PI NEW			720 #	7487
	RAM			723 #	2217	2325	2337	2352	2365	2393	2406	2407	2419	2420	2624
				2725	2727	2758	2764	2817	2850	2860	2892	2902	2922	2932	2942
				2973	3001	3004	3018	3024	3036	3039	3052	3123	3126	3312	3327
				3330	3335	3406	3509	3523	3537	3545	3592	3600	3715	3753	3786
				3808	3866	3879	4096	4110	4123	4126	4135	4137	4140	4158	4186
				4214	4216	4228	4233	4251	4253	4356	4365	4366	4448	4450	4472
				4479	4489	4649	4653	4654	4658	4659	4663	4664	4752	4756	4788
				4796	5006	5015	5016	5028	5032	5067	5074	5079	5087	5143	5152
				5215	5240	5322	5355	5387	5451	5586	5587	5597	5677	5689	5732
				5740	5964	5967	5994	5997	6012	6015	6031	6035	6045	6052	6061
				6064	6080	6084	6099	6100	6101	6102	6119	6133	6135	6153	6166
				6172	6179	6185	6197	6200	6217	6220	6224	6228	6231	6233	6240
				6242	6250	6252	6255	6291	6293	6294	6306	6307	6326	6331	6332
				6333	6354	6359	6371	6377	6387	6395	6400	6406	6413	6419	6420
				6421	6442	6462	6467	6472	6474	6491	6549	6580	6590	6593	6618
				6627	6629	6654	6669	6731	6733	6776	6777	6784	6846	6851	6853
				6858	6862	6864	6879	6881	6908	6932	6934	6965	6969	6973	6978
				6979	6984	6992	6993	6996	7094	7128	7220	7277	7279	7281	7283
				7285	7315	7324	7329	7335	7367	7368	7371	7392	7602	7616	7630
				7632	7724	7727	7729	7735	7741	7743	7903	7982	7987	7991	8006
				8024	8026	8027	8029	8268	8368	8371	8398	8400	8431	8438	8455
				8458	8477	8526	8536	8538	8567	8583	8623	8624	8625	8631	8651
				8652	8658	8820	8826	8835	8839	8851
(U) DEST			653 #
	A			654 #	2425	2441	2525	2557	2605	2752	2754	2757	2760	2763	2766
				2808	3079	3114	3305	3310	3336	3423	3425	3465	3468	3471	3474
				3477	3480	3483	3486	3629	3746	3748	3806	3844	3865	3880	3998
				4143	4167	4190	4248	4493	4499	4668	4731	4736	4746	4750	4771
				4830	4831	4832	4833	4834	4850	4924	4925	4926	4927	4928	4976
				4992	5092	5132	5141	5153	5214	5217	5242	5479	5485	5529	5545
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 262
; 								Cross Reference Listing					

				5805	5850	5875	6048	6068	6072	6082	6085	6125	6161	6168	6202
				6261	6263	6298	6299	6311	6312	6345	6348	6380	6386	6397	6402
				6424	6425	6426	6439	6496	6501	6502	6564	6585	6645	6710	6718
				6771	6796	6860	6882	6885	6888	6925	6927	6929	6967	6975	6982
				6987	6994	6998	7129	7320	7406	7419	7429	7613	7801	8271	8482
				8773
	AD			656 #	2185	2187	2189	2191	2194	2197	2199	2202	2211	2214	2215
				2216	2217	2220	2227	2230	2238	2252	2255	2265	2267	2274	2278
				2281	2284	2293	2296	2299	2302	2305	2312	2325	2331	2337	2352
				2356	2365	2375	2389	2393	2398	2399	2402	2406	2407	2430	2436
				2447	2450	2453	2456	2458	2471	2493	2494	2553	2613	2624	2725
				2727	2758	2764	2774	2776	2781	2783	2788	2790	2795	2797	2807
				2817	2840	2850	2860	2875	2892	2902	2912	2922	2932	2942	2943
				2953	2963	2973	2983	3001	3004	3018	3052	3055	3078	3307	3312
				3324	3327	3330	3335	3374	3406	3440	3456	3490	3493	3509	3523
				3537	3545	3561	3562	3565	3574	3577	3579	3580	3581	3585	3588
				3600	3609	3614	3615	3616	3619	3622	3624	3630	3642	3649	3650
				3653	3657	3663	3664	3668	3671	3676	3678	3689	3714	3715	3725
				3743	3753	3759	3761	3786	3790	3795	3808	3842	3848	3854	3863
				3866	3868	3871	3879	3884	3958	3960	3962	3964	3966	3968	3970
				3972	3978	3982	3984	3999	4009	4018	4022	4024	4025	4028	4033
				4041	4054	4061	4065	4070	4076	4081	4096	4110	4123	4126	4130
				4131	4135	4137	4140	4144	4145	4157	4163	4169	4171	4172	4185
				4186	4191	4194	4195	4209	4225	4239	4255	4262	4355	4358	4360
				4364	4365	4379	4385	4391	4397	4414	4434	4445	4446	4452	4463
				4469	4478	4486	4498	4505	4508	4557	4572	4574	4575	4577	4582
				4583	4596	4663	4664	4675	4676	4678	4680	4684	4685	4686	4756
				4769	4775	4804	4810	4852	4863	4948	4949	4950	4951	4985	4994
				5006	5008	5016	5018	5022	5025	5051	5064	5074	5077	5083	5094
				5101	5137	5140	5143	5145	5152	5155	5179	5181	5183	5188	5203
				5205	5206	5215	5240	5258	5264	5289	5290	5291	5319	5322	5325
				5326	5327	5329	5330	5333	5334	5339	5355	5358	5359	5365	5385
				5387	5391	5392	5393	5394	5429	5451	5452	5453	5483	5487	5488
				5536	5538	5548	5551	5553	5554	5555	5566	5583	5584	5597	5602
				5603	5610	5611	5621	5646	5648	5649	5653	5656	5673	5684	5696
				5697	5726	5728	5729	5734	5735	5736	5744	5755	5757	5771	5772
				5795	5811	5813	5815	5830	5832	5834	5836	5839	5859	5860	5876
				5919	5921	5923	5925	5927	5929	5931	5933	5935	5951	5954	5956
				5964	5965	5967	5970	5979	5990	5994	5997	5998	6004	6006	6011
				6012	6013	6015	6023	6031	6033	6035	6037	6040	6045	6049	6052
				6054	6055	6056	6061	6062	6064	6070	6079	6080	6084	6086	6091
				6099	6100	6101	6102	6109	6110	6114	6116	6119	6124	6128	6133
				6135	6138	6139	6140	6151	6153	6155	6162	6166	6170	6172	6173
				6174	6175	6180	6181	6185	6194	6197	6198	6200	6205	6209	6210
				6217	6220	6224	6228	6231	6233	6242	6250	6252	6255	6258	6269
				6271	6280	6281	6285	6286	6291	6293	6294	6296	6297	6301	6303
				6304	6306	6307	6309	6326	6328	6331	6332	6333	6339	6341	6344
				6349	6350	6354	6355	6359	6361	6365	6368	6371	6373	6374	6375
				6377	6385	6387	6388	6390	6391	6393	6395	6400	6406	6409	6413
				6418	6419	6420	6421	6423	6427	6428	6429	6433	6437	6440	6442
				6444	6456	6460	6462	6464	6465	6467	6470	6472	6474	6476	6478
				6489	6491	6495	6504	6507	6541	6542	6546	6549	6558	6560	6565
				6590	6593	6599	6603	6618	6619	6627	6629	6631	6633	6636	6640
				6642	6654	6657	6659	6661	6663	6669	6677	6697	6703	6708	6711
				6714	6716	6731	6733	6767	6776	6784	6793	6812	6816	6820	6824
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 263
; 								Cross Reference Listing					

				6828	6832	6842	6846	6848	6851	6853	6857	6858	6862	6864	6879
				6881	6884	6886	6907	6908	6926	6928	6937	6947	6952	6957	6965
				6969	6973	6978	6979	6983	6984	6986	6990	6992	6993	6996	7003
				7006	7014	7022	7030	7039	7040	7041	7042	7043	7045	7046	7047
				7048	7049	7050	7053	7054	7055	7058	7059	7060	7061	7062	7063
				7064	7065	7067	7070	7080	7082	7094	7095	7097	7098	7099	7102
				7104	7105	7107	7109	7121	7128	7131	7134	7137	7138	7140	7155
				7159	7166	7170	7181	7185	7192	7200	7204	7207	7209	7220	7221
				7223	7230	7232	7233	7249	7250	7255	7261	7266	7267	7277	7279
				7281	7283	7285	7286	7290	7294	7298	7302	7306	7309	7315	7318
				7319	7324	7325	7327	7329	7330	7335	7336	7337	7347	7348	7351
				7361	7362	7363	7366	7367	7368	7371	7378	7386	7392	7398	7402
				7404	7405	7408	7410	7412	7414	7416	7418	7430	7431	7447	7448
				7450	7454	7461	7463	7467	7490	7491	7492	7493	7494	7495	7496
				7497	7498	7499	7500	7501	7502	7503	7505	7509	7513	7515	7517
				7519	7524	7528	7538	7540	7542	7544	7554	7556	7558	7561	7562
				7564	7566	7570	7572	7584	7588	7602	7616	7626	7628	7630	7632
				7635	7648	7651	7657	7660	7666	7672	7687	7698	7704	7717	7724
				7727	7729	7735	7737	7741	7743	7744	7751	7777	7782	7785	7789
				7791	7863	7872	7874	7876	7878	7880	7882	7896	7903	7913	7916
				7930	7931	7935	7982	7987	7991	7994	8002	8006	8009	8012	8015
				8018	8021	8024	8026	8027	8029	8261	8264	8265	8268	8270	8283
				8290	8301	8305	8307	8321	8326	8330	8333	8339	8341	8347	8368
				8371	8376	8384	8390	8398	8400	8426	8429	8431	8455	8458	8472
				8477	8486	8489	8504	8515	8518	8526	8536	8538	8544	8551	8555
				8580	8583	8589	8592	8593	8597	8599	8601	8604	8605	8612	8614
				8616	8620	8623	8624	8625	8631	8652	8654	8658	8676	8678	8712
				8723	8740	8750	8755	8760	8764	8780	8783	8787	8792	8799	8804
				8810	8812	8815	8820	8826	8834	8835	8839	8843	8849	8851	8853
				8855	8857	8859	8861	8863	8865	8867	8868	8869	8874	8877	8889
				8893	8899	8901	8903	8914	8918
	AD*.5			663 #	2188	2460	2462	2463	3020	3024	3036	3039	3041	3042	3046
				3077	3129	3132	4207	4208	4214	4216	4226	4228	4233	4264	4426
				4448	4454	4585	4586	4587	4593	4843	4854	4930	4979	4982	4989
				4998	5400	5408	5410	5415	5416	5475	5524	5526	5542	5543	5562
				5563	5568	5586	5587	5590	5592	5677	5678	5685	5689	5692	5693
				5711	5732	5740	5743	5745	5869	5880	6503	6506	6510	6512	6592
				6694	6700	6707	6770	7246	7248	7256	7262	7265	7568	7571	7589
				7664	7670	8344	8360
	AD*2			661 #	2186	3008	3031	3044	3047	3074	4162	4189	4245	4488	4628
				4752	5089	5098	5251	5271	5282	5395	5398	5403	5478	6240	6241
				6497	6681	6787	7196	7215	7217	7516	7552	7696	7702	7793	8406
				8409	8443	8586
	PASS			658 #	2196	2204	2206	2207	2210	2212	2213	2219	2221	2264	2268
				2286	2343	2370	2379	2466	2531	2563	2569	2574	2577	2627	2823
				2824	3147	3362	3442	3489	3494	3568	3604	3666	3677	3699	3731
				3737	3766	3771	3776	3782	3811	3816	3850	3853	3881	4006	4008
				4014	4053	4057	4080	4165	4193	4235	4250	4252	4254	4257	4432
				4476	4496	4518	4520	4523	4650	4655	4660	4666	4667	4729	4732
				4741	4776	4792	4800	4931	4988	5001	5011	5021	5053	5133	5161
				5169	5285	5797	5841	5842	5843	5961	5968	5974	5977	6002	6007
				6024	6069	6095	6096	6097	6112	6143	6159	6182	6195	6213	6244
				6334	6336	6392	6398	6411	6417	6494	6550	6616	6628	6630	6670
				6734	6764	6933	6935	6953	6970	7004	7068	7074	7116	7152	7225
				7257	7291	7295	7299	7303	7307	7322	7333	7354	7357	7364	7377
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 264
; 								Cross Reference Listing					

				7379	7387	7388	7421	7439	7440	7445	7472	7473	7523	7587	7654
				7689	7690	7692	7721	7736	7755	7761	7763	7795	7797	7799	7892
				7900	7908	7915	7927	7980	7995	8000	8001	8003	8004	8005	8007
				8008	8010	8011	8013	8014	8016	8017	8019	8020	8022	8023	8025
				8028	8267	8288	8289	8291	8292	8296	8299	8309	8311	8313	8315
				8319	8320	8373	8381	8386	8461	8463	8466	8484	8610	8626	8707
				8809	8878	8881	8895	8909	8911
	Q_AD			657 #	2419	3017	3123	3149	3151	4158	4184	4223	4243	4251	4253
				4263	4356	4366	4425	4435	4437	4450	4472	4475	4477	4479	4490
				4503	4504	4507	4514	4522	4550	4555	4556	4573	4598	4649	4653
				4654	4658	4659	4858	4934	4941	5003	5012	5015	5032	5056	5072
				5079	5139	5196	5245	5256	5261	5276	5279	5336	5360	5363	5407
				5418	5430	5434	5436	5437	5450	5463	5521	5523	5525	5527	5595
				5604	5607	5612	5622	5627	5667	5672	5682	5695	5701	5713	5716
				5746	5751	5756	5758	5769	5793	5809	5810	5828	6020	6179	6580
				7787
	Q_Q*.5			662 #	2420	2421	3107	3126	3135	3179	4159	4187	4266	4287	4288
				4300	4307	4315	4325	4333	4428	4430	4438	4442	4458	4473	4480
				4532	4580	5080	5247	5267	5268	5269	5283	5338	5361	5366	5441
				5443	5473	5616	5641	5644	5652	5655	5657	5671	5706	5747	5761
				5787	5790	5824	5826	5872
	Q_Q*2			660 #	3027	3108	3111	3112	3113	3138	3142	3145	3180	3183	3184
				4311	4319	4329	4337	4474	4484	4512	4515	4588	4591	4592	4595
				4597	4619	4622	4634	4639	4859	4862	4935	4938	4943	5262	5263
				5520	5532	5540	5544	5618	5623	5625	5637	5639	5640	5669	5710
				5714	5763	5780	5802	5819	5847	6022
(U) DISP			892 #	4600
	ADISP			899 #
	AREAD			895 #	2357
	BDISP			900 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	3307	3313	3406
				3425	3426	3509	3523	3537	3547	3732	3739	3777	4097	4111	4163
				4169	4192	4194	5246	5475	5483	5487	5533	5545	5555	5562	5966
				6008	6152	6207	6414	6768	6840	6847	7602	7629	7647	7658	7685
				8602	8902
	BYTE			905 #	4744	4761	6189	6892	6913
	CONSOLE			893 #
	DP			898 #	4466	4468	4485	4510	6513	6540	8845
	DP LEFT			896 #	6499	6794	7488	8297
	DROM			894 #	2390	2394	2403	2408	2416	2437	2443	2467	2472	5975	5978
	EAMODE			906 #	2315	2381	3590	4783	4786	5962	6930	6938	7726
	MUL			902 #	4307	4315	4325	4333	5619	5645	5647	5764
	NICOND			904 #	2264	2265	2267	2268	2328	2334	2558	3079	3125	3153	3362
				3374	3465	3489	3490	3493	3494	3561	3562	3588	3630	3747	3823
				3830	4257	4521	4524	4732	5479	5485	5844	7421	7692	8271
	NORM			897 #	5339	5368	5445	5520	5522	5532	5536	5538	5540	5541	5544
				5566	5717	5771	5772	5782	5784	5804	5814	5816	5821	5822	5849
				5878
	PAGE FAIL		903 #
	RETURN			901 #	2493	2494	3595	3599	4063	4066	4269	4312	4320	4330	4338
				4532	4554	4555	4557	4641	4668	4770	4772	4776	4811	4844	4863
				4931	5145	5282	5283	5565	5567	5568	5657	5852	5859	5860	5875
				6264	6274	6279	6282	6320	6321	6471	6477	6648	6671	6736	6767
				6779	6810	6826	6843	6852	6854	6880	6915	6948	6954	6959	6999
				7267	7334	7358	7433	7477	7585	7588	7660	7667	7673	7730	7738
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 265
; 								Cross Reference Listing					

				7742	7745	7771	7783	7785	7787	7789	7791	7793	7795	7797	7799
				7801	7992	7996	8030	8632	8654	8659	8665	8696	8699	8700	8713
				8722	8725	8726	8830	8918
	SCAD0			907 #	4731	4736	4750	4826	5322	5465	5467	6020	6022	6073	6883
				6925	7757
(U) DIVIDE			993 #	4591	4592	4636	4640
(U) DONT CACHE			1163 #
(U) DP FUNC			1180 #	7654	7689	7795	8611	8627
(U) DT				962 #
	2T			965 #
	3T			966 #	2217	2407	2419	2420	2530	2562	2568	2573	2576	2626	2817
				2823	3024	3036	3039	3053	3123	3126	3368	3371	3380	3383	3442
				3471	3474	3483	3486	3628	3628	3643	3643	3730	3736	3775	3781
				3852	4005	4007	4013	4026	4031	4052	4056	4079	4123	4135	4161
				4166	4228	4233	4251	4253	4366	4368	4370	4374	4388	4427	4433
				4448	4450	4462	4472	4479	4492	4573	4649	4651	4653	4654	4656
				4658	4659	4661	4677	4684	4731	4736	4744	4750	4752	4761	4776
				4931	5002	5006	5015	5016	5031	5061	5074	5079	5143	5172	5198
				5215	5287	5339	5368	5385	5405	5411	5413	5445	5486	5520	5522
				5528	5532	5536	5538	5540	5541	5544	5547	5552	5566	5587	5689
				5708	5712	5715	5717	5729	5740	5759	5771	5772	5782	5783	5784
				5786	5789	5792	5801	5804	5810	5814	5816	5821	5822	5846	5849
				5852	5870	5878	5952	5994	5995	6012	6015	6031	6035	6045	6052
				6061	6064	6080	6084	6099	6100	6101	6102	6119	6133	6134	6136
				6153	6166	6172	6176	6179	6185	6189	6200	6217	6218	6220	6224
				6228	6229	6231	6233	6238	6240	6242	6250	6252	6255	6291	6293
				6294	6305	6306	6307	6308	6326	6332	6359	6363	6371	6376	6377
				6387	6395	6400	6406	6413	6419	6420	6421	6422	6436	6438	6442
				6492	6527	6530	6549	6580	6584	6590	6593	6597	6618	6627	6629
				6630	6634	6654	6655	6669	6731	6733	6776	6777	6778	6784	6791
				6846	6851	6853	6858	6862	6864	6879	6881	6892	6908	6913	6965
				6969	6973	6978	6979	6984	6992	6993	6996	7042	7043	7094	7101
				7103	7105	7106	7108	7110	7128	7137	7220	7277	7279	7281	7283
				7285	7315	7324	7329	7331	7335	7336	7365	7367	7368	7371	7377
				7379	7392	7401	7403	7407	7409	7411	7413	7415	7417	7440	7654
				7659	7686	7689	7690	7718	7720	7724	7727	7729	7734	7741	7743
				7795	7797	7799	7915	7982	7987	7988	7991	8000	8001	8003	8004
				8006	8007	8008	8010	8011	8013	8014	8016	8017	8019	8020	8022
				8023	8024	8025	8026	8027	8029	8268	8269	8329	8351	8368	8369
				8371	8372	8395	8398	8400	8402	8405	8420	8425	8431	8455	8456
				8458	8459	8474	8477	8493	8497	8503	8517	8521	8523	8526	8536
				8538	8543	8548	8576	8583	8596	8615	8617	8623	8624	8625	8631
				8652	8655	8658	8660	8682	8685	8687	8690	8693	8714	8724	8765
				8778	8782	8785	8790	8796	8820	8826	8835	8837	8839	8851	8880
				8886	8894	8909	8911
	4T			967 #	8438	8567	8651
	5T			968 #
(U) EXT ADR			1186 #	3994	4004	4018	4038	4065	7011	7019	7523	7565	7654	7689
				7795	7913	7916	7999	8002	8009	8012	8015	8018	8021	8374	8382
				8388	8468	8709	8742	8758	8879	8915	8918
(U) FETCH			1152 #	2264	2265	2267	2268	2287	2313	2327	2333	2380	2441	2466
				3056	3362	3374	3489	3490	3493	3494	3561	3562	3588	3630	3745
				4257	4732	4741	7421	7692	7928	8837
(D) FL-B			1375 #
	AC			1376 #	5299	5302	5303	5307	5310	5311	5344	5348	5349	5373	5377
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 266
; 								Cross Reference Listing					

				5378	5423	5424	5458	5459
	BOTH			1378 #	5301	5305	5309	5313	5346	5351	5375	5380
	MEM			1377 #	5300	5304	5308	5312	5345	5350	5374	5379
(U) FLG.C			1341 #	8327	8596	8617	8724	8781	8784
(U) FLG.PI			1340 #	3658	8405	8425	8493	8503	8523	8660	8685	8690	8714	8778
				8877
(U) FLG.SN			1342 #	5547	5648	5649	5656	5783	5786	5789	5792	5852	5859	5860
(U) FLG.W			1339 #	8327	8517	8556	8615	8724	8781	8793
(U) FMWRITE			988 #	2196	2204	2206	2207	2209	2210	2212	2213	2219	2221	2525
				2557	2808	3058	3079	3114	3147	3153	3336	3425	3465	3468	3471
				3474	3477	3480	3483	3486	3699	3746	3748	3811	3816	3844	4218
				4226	4235	4237	4248	4249	4250	4252	4254	4476	4492	4493	4494
				4496	4499	4518	4520	4523	4650	4655	4660	4666	4667	4668	4729
				4746	4988	5001	5011	5021	5053	5104	5153	5217	5242	5479	5485
				5797	5805	5841	5842	5843	5850	5961	5974	5977	6002	6007	6024
				6048	6068	6069	6075	6085	6088	6095	6096	6097	6112	6123	6125
				6127	6143	6159	6161	6168	6182	6195	6202	6213	6244	6261	6263
				6298	6299	6311	6312	6319	6321	6334	6336	6345	6348	6380	6386
				6392	6397	6398	6402	6411	6417	6424	6425	6426	6585	6616	6645
				6718	6734	6764	6860	6888	6929	6953	6967	6970	6975	6982	6987
				6994	7004	7116	7225	7291	7295	7299	7303	7307	7322	7333	7354
				7357	7387	7388	7472	7473	7613	7721	7755	7761	7763	7801	7908
				7980	7995	8005	8267	8271	8288	8289	8291	8292	8299	8309	8311
				8313	8315	8319	8320	8461	8463	8484	8809
(U) FORCE EXEC			1150 #	3994	4004	4018	4038	4065	7011	7019	7509	7523	7525	7539
				7556	7565	7573	7648	7651	7687	7698	7704	7913	7916	7930	7999
				8002	8009	8012	8015	8018	8021	8374	8382	8388	8468	8709	8742
				8758	8879	8915	8918
(U) FORCE USER			1149 #	3994	4004	4018	4038	4065	7011	7019	7509	7523	7556	7565
				7648	7651	7687	7698	7704	7913	7916	7930	7999	8002	8009	8012
				8015	8018	8021	8374	8382	8388	8468	8709	8742	8758	8879	8915
				8918
(U) GENL			750 #	2265	2267	2312	2325	2326	2332	2337	2352	2353	2365	2376
				2399	2727	2758	2766	2788	2790	3374	3490	3493	3561	3562	3563
				3572	3575	3588	3600	3630	3654	3668	3796	3855	3869	3873	4018
				4030	4035	4065	4081	4132	4775	4805	5014	5073	5096	5145	5157
				5179	5183	5188	5203	5206	5216	5268	5269	5289	5291	5364	5627
				5964	5967	5970	6011	6037	6040	6056	6062	6091	6110	6116	6124
				6128	6139	6151	6155	6162	6181	6209	6286	6301	6339	6374	6391
				6418	6429	6433	6489	6495	6542	6599	6603	6638	6663	6704	6709
				6767	6886	6928	6937	7096	7122	7136	7205	7221	7223	7267	7348
				7353	7378	7412	7414	7416	7418	7430	7490	7491	7492	7493	7494
				7495	7496	7518	7588	7714	7735	7735	7916	7932	8002	8009	8012
				8015	8018	8021	8270	8546	8592	8600	8843	8849	8855	8857	8859
				8861	8863	8865	8867	8868	8869	8899	8918
(U) GENR			757 #	2456	2458	2471	2493	2494	2725	2760	2764	2781	2783	2807
				3150	3152	3423	3565	3574	3577	3579	3580	3581	3614	3619	3622
				3642	3663	3676	3807	3958	3960	3962	3964	3966	3968	3970	3972
				3980	4000	4010	4062	4078	4143	4144	4145	4167	4190	4397	4436
				4498	4552	4675	4852	4987	4995	5058	5103	5138	5142	5329	5330
				5333	5334	5358	5359	5391	5392	5452	5453	5529	5545	5648	5649
				5656	5672	5794	5829	5859	5860	5875	5957	5979	6206	6211	6280
				6296	6297	6303	6342	6344	6351	6357	6366	6385	6437	6440	6445
				6470	6476	6547	6641	6643	6713	6717	6771	6813	6817	6821	6825
				6829	6833	6849	6947	6959	7030	7039	7040	7041	7045	7046	7047
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 267
; 								Cross Reference Listing					

				7048	7053	7054	7055	7058	7059	7060	7061	7062	7063	7064	7065
				7090	7130	7133	7161	7168	7172	7187	7193	7202	7210	7232	7233
				7251	7255	7261	7286	7309	7320	7404	7406	7408	7410	7542	7744
				7789	7863	7872	7874	7876	7878	7880	7882	8263	8266	8328	8332
				8335	8340	8491	8516	8553	8557	8591	8595	8598	8609	8679	8784
				8789	8794	8800	8814	8877
(U) HALT			1318 #	8283
	BW14			1328 #	2553
	CSL			1322 #	2284	2302
	HALT			1321 #	3616
	ILLII			1325 #	7538
	ILLINT			1326 #	7570
	IOPF			1324 #	8834
	MULERR			1330 #	2227
	NICOND 5		1329 #
	POWER			1320 #	2255
(U) HOLD USER			1119 #	2253	2614	3440	3456	3523	3537	3594	3598	3634	3656	3726
				3738	3794	3824	3828	3843	3849	4044	4097	4111	4128	4138	4141
				4171	4172	4196	4246	4258	4268	4271	4378	4413	4444	4530	4679
				4681	4746	4763	4785	5037	5389	5401	5466	5754	6428	6429	7028
(D) I				1383 #	2584	2589	2594	2599	2637	2642	2647	2652	2657	2662	2667
				2672	2679	2684	2689	2694	2699	2704	2709	2714	2833	2834	2835
				2836	2844	2854	2864	2869	2879	2886	2896	2906	2916	2925	2926
				2927	2928	2936	2947	2957	2967	2976	2977	2978	2979	2991	2992
				3211	3212	3213	3214	3215	3216	3217	3218	3220	3221	3229	3230
				3231	3232	3233	3234	3235	3236	3247	3248	3249	3250	3251	3252
				3253	3254	3264	3265	3266	3267	3268	3269	3270	3271	3386	3387
				3388	3389	3390	3391	3392	3393	3498	3499	3500	3501	3502	3503
				3504	3505	3512	3513	3514	3515	3516	3517	3518	3519	3526	3527
				3528	3529	3530	3531	3532	3533	3540	3541	3552	3554	3705	3706
				3707	3708	3802	3835	3836	3837	3838	3891	3892	3893	3894	3895
				3896	3897	3898	3902	3903	3904	3905	3906	3907	3908	3909	3910
				3911	3912	3913	3914	3915	3916	3917	3918	3919	3920	3921	3922
				3923	3924	3925	3926	3927	3928	3929	3930	3931	3932	3933	3937
				3938	3939	3940	3944	3945	3946	3947	3948	3949	3950	3951	3952
				3953	3954	4090	4104	4152	4177	4344	4349	5148	5424	5888	5889
				5890	5891	5892	5893	5894	5896	5897	5898	5899	5901	5902	5903
				5904	5906	5907	5908	5909	5910	5911	5912	5913	5947	7806	7807
				7808	7810	7811	7813	7814	7816	7817	7818	7819	7820	7821	7822
				7823	7825	7826	7827	7828	7829	7830	7831	7832	7834	7835	7836
				7837	7838	7839	7840	7841	7843	7844	7845	7846	7847	7848	7849
				7850	7852	7853	7854	7855	7856	7857	7858	7859
(U) I.CO3			1214 #
(U) I.CO4			1215 #
(U) I.CO5			1216 #
(U) I.CO6			1217 #
(U) I.CO7			1218 #
(U) IO BYTE			1199 #	7649	7699	7705
(U) IO CYCLE			1193 #	7509	7556	7648	7651	7687	7698	7704	7930
(U) J				555 #	2357	2390	2394	2403	2408	2416	2437	2443	2467	2472	2493
				2494	3595	3599	4063	4066	4269	4312	4320	4330	4338	4532	4554
				4555	4557	4601	4641	4668	4770	4772	4776	4811	4844	4863	4931
				5145	5282	5283	5565	5567	5568	5657	5852	5859	5860	5875	5975
				5978	6264	6274	6279	6282	6320	6321	6471	6477	6648	6671	6736
				6767	6779	6810	6826	6843	6852	6854	6880	6915	6948	6954	6959
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 268
; 								Cross Reference Listing					

				6999	7267	7334	7358	7433	7477	7585	7588	7660	7667	7673	7730
				7738	7742	7745	7771	7783	7785	7787	7789	7791	7793	7795	7797
				7799	7801	7924	7992	7996	8030	8632	8654	8659	8665	8696	8699
				8700	8713	8722	8725	8726	8830	8918
	ABORT			8830 #	3985	8811
	ACBSET			7181 #	7163
	AC_ARX			7801 #	3870	6985
	ADD			4096 #	4089	4090	4091	4092
	ADDCRY			6279 #	6254	6260	6273
	ADJBP			4976 #	4730
	ADJBP0			4979 #	4981
	ADJBP1			4998 #	5000
	ADJBP2			5008 #	5005
	ADJBP3			5051 #	5036
	ADJBP4			5063 #	5075
	ADJBP5			5077 #	5071
	ADJBP6			5098 #	5100
	ADJSP			3806 #	3802
	ADJSP1			3823 #	3815
	ADJSP2			3828 #	3820
	AND			2850 #	2843	2844	2845	2846	2875
	ANDCA			2860 #	2853	2854	2855	2856	2912
	ANDCB			2912 #	2905	2906	2907	2908
	ANDCM			2875 #	2868	2869	2870	2871
	AOBJ			3545 #	3540	3541
	AOJ			3523 #	3512	3513	3514	3515	3516	3517	3518	3519
	AOS			3440 #	3429	3430	3431	3432	3433	3434	3435	3436
	APRID			7080 #
	APRSO			7067 #	7043
	APRSZ			7070 #	7042
	ARSIGN			2493 #	2435
	ASH			3017 #	2988
	ASHC			3120 #	2992
	ASHC1			3126 #	3124
	ASHCL			3142 #	3131	3144
	ASHCQ1			3153 #	3114	3150
	ASHCR			3135 #	3137
	ASHCX			3147 #	3139
	ASHL			3027 #	3027
	ASHL0			3024 #	3017
	ASHR			3020 #	3006
	ASHX			3031 #	3044
	ASHXX			3044 #	3049
	BACKBP			6998 #	6966	6974
	BACKD			6973 #	8860	8868	8870
	BACKS			6965 #	8867
	BADDATA			8318 #	8303
	BDABT			6442 #	6378
	BDCFLG			6444 #	6423
	BDEC			6326 #
	BDEC0			6332 #	6330
	BDEC1			6339 #	6348
	BDEC2			6344 #	6352
	BDEC3			6354 #	6340	6362
	BDEC4			6359 #	6354
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 269
; 								Cross Reference Listing					

	BDEC5			6371 #	6357	6367
	BDECLP			6409 #	6428
	BDFILL			6393 #	6402
	BDSET			6417 #	6437	6440
	BDSUB			6456 #	6360	6410
	BDSUB1			6460 #	6457
	BDSUB2			6476 #	6479
	BDTBL			6433 #	6416
	BITCHK			6947 #	5953	5996	6134	6136	6493
	BIXUB			7626 #	7619	7620	7621	7622
	BIXUB1			7635 #	7631	7633
	BLT			5152 #	5148
	BLT-CLEANUP		5213 #	8852
	BLTBU1			5267 #	5248
	BLTCLR			5172 #	5187
	BLTGOT			5200 #	5175
	BLTGO			5198 #	5164	5192
	BLTLP			5195 #	5210
	BLTLP1			5161 #	5197
	BLTX			5240 #	7869
	BLTXLP			5244 #	5293
	BLTXV			5279 #	5265
	BLTXW			5285 #	5280
	BOTH			2365 #
	BWRITE			2504 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	4097	4111	4163
				4169	4192	4194	8602	8902
	BYTEAS			4783 #	4807	6890
	BYTEA			4785 #	4740	4759
	BYTEA0			4788 #	4784
	BYTFET			4809 #	4791	4795	6932	6933
	BYTIND			4803 #	4799
	CAIM			3406 #	3387	3388	3389	3390	3391	3392	3393	3395	3396	3397	3398
				3399	3400	3401	3402
	CHKSN			5852 #	5833
	CLARXL			7789 #	5136	7563
	CLARX0			6470 #	4679	4681	4685	4686	6201	6335	6461
	CLDISP			8845 #	6967	6975	6988	6994	8840
	CLEANED			8848 #	5218	8842
	CLEANUP			8847 #	8845
	CLRB1			6321 #	6319
	CLRBIN			6319 #	6204	6300
	CLRFLG			6957 #	6000	6372
	CLRPTL			7454 #	7457
	CLRPT			7445 #
	CLRSN			5860 #	5638	5728
	CMPDST			6185 #	6165
	CMS			6133 #
	CMS2			6174 #	6144
	CMS3			6150 #	6176	6180
	CMS4			6153 #
	CMS5			6179 #	6158
	CMS6			6165 #	6182
	CMS7			6170 #	6167
	CMS8			6181 #	6179
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 270
; 								Cross Reference Listing					

	CMSDST			6969 #	8866
	COM0			4668 #	4663	4664
	COM0A			4663 #	4667
	COM1			4667 #	4658
	COM1A			4658 #	4666
	COM2			4666 #	4653
	COM2A			4653 #
	CONSO			7068 #	7050
	CONSZ			7074 #	7049
	CONT			7927 #	7922
	CONT1			7934 #	4084
	CPYSGN			4143 #	4129	4139
	DAC			2525 #	2532	2802	6442
	DADD			4123 #	4118
	DADD1			4126 #	4132
	DBABT			6285 #	6221	6225
	DBDN1			6298 #	6296
	DBDONE			6293 #	6287	6312
	DBFAST			6238 #	6234
	DBIN			6194 #
	DBIN1			6209 #	6212
	DBIN2			6213 #	6209
	DBINLP			6217 #	6235	6245
	DBLDBL			6269 #	6257	6268
	DBLDIV			4619 #	4473	4483	5756	5760
	DBLMUL			4263 #	4234
	DBLNEG			4675 #	2817
	DBLNGA			4676 #	2807
	DBLNG1			4684 #	4398	6344
	DBNEG			6303 #	6292
	DBSLOW			6250 #	2218	6232
	DBSLO			6231 #	6239
	DBXIT			6291 #	6219
	DDIV			4425 #	4420
	DDIV1			4442 #	4429	4433
	DDIV2			4445 #	4443
	DDIV3A			4450 #	4455
	DDIV3			4446 #	4440
	DDIV4			4458 #	4451
	DDIV5A			4472 #	4463
	DDIV5B			4496 #	4487
	DDIV5C			4498 #	4493
	DDIV5			4466 #	4462
	DDIV6			4501 #	4494	4496
	DDIV7			4503 #
	DDIV8A			4512 #
	DDIV8			4510 #	4503
	DDIV9			4518 #	4513
	DDIVS			4532 #	4459	4477	5752
	DFAD			5586 #	5573
	DFADJ			5637 #	5602	5610
	DFADJ1			5644 #	5645
	DFADJ2			5646 #
	DFADJ3			5652 #	5648	5652
	DFADJ4			5653 #	5649
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 271
; 								Cross Reference Listing					

	DFADJ5			5655 #	5647	5656
	DFADJ6			5657 #	5655
	DFAS1			5595 #	5591	5593
	DFAS2			5602 #	5596
	DFAS3			5607 #	5598
	DFAS5			5616 #	5604	5612
	DFAS6			5621 #	5622
	DFAS7			5623 #	5621
	DFDV			5726 #	5723
	DFDV1			5732 #	5739
	DFDV2			5740 #	5733
	DFDV3			5751 #	5743
	DFDV4A			5766 #	5769
	DFDV4B			5771 #	5768
	DFDV4			5753 #	5749
	DFMP			5667 #	5662
	DFMP1			5669 #	5670
	DFMP2			5695 #	5692
	DFPR1			2458 #	2452
	DFPR2			2459 #	2457
	DFSB			5583 #	5574
	DIV			4364 #	4348	4349	4350	4351
	DIV1			4373 #	4359	4361	4415
	DIV2			4376 #	4389
	DIVA			4385 #	4371
	DIVB			4391 #	4386
	DIVC			4404 #	4396	4401
	DIVHI			4626 #	4620	4623	4637
	DIVIDE			4591 #	4591
	DIVSET			4585 #	4581
	DIVSGN			4571 #	4553	5407
	DIVSUB			4550 #	4377	5010	5020	5054
	DMLINT			4271 #	4236
	DMOVNM			2817 #	2812
	DMOVN			2807 #	2803
	DMOVN1			2819 #	2811
	DMTRAP			4255 #	4249
	DMUL			4207 #	4202
	DMUL1			4228 #	4217
	DMUL2			4233 #	4227
	DMULGO			4262 #	4215
	DNEG			5809 #	5783	5786	5789	5792
	DNEG1			5811 #	5809
	DNEG2			5813 #	5810
	DNN1			5839 #	5835
	DNN2			5841 #	5837
	DNNORM			5819 #	5772	5814	5816	5821	5849
	DNNRM1			5846 #	5829
	DNORM			5780 #	5718	5771	5782	5804
	DNORM0			5717 #	5627
	DNORM1			5801 #	5794
	DNORM2			5843 #	5841
	DOCVT			6331 #	6381	6397
	DOCVT1			6406 #	6331
	DOCVT2			6427 #	6407
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 272
; 								Cross Reference Listing					

	DOCVT3			6424 #	6446
	DONE			2264 #	2564	2578	2878	2879	3058	3211	3212	3220	3221	3321	3365
				3368	3371	3386	3498	3749	3857	3874	4258	4763	5105	5180	5204
				5289	7074	7117	7189	7291	7295	7299	7303	7307	7355	7379	7389
				7440	7474	7613
	DPB			4752 #	4725
	DPB1			4923 #	4762	6914
	DPB7			4930 #	4924	4925	4926	4927	4928	4952
	DPBSLO			4934 #	4923
	DRND1			5875 #	5871	5879	5882
	DROUND			5869 #	5785	5788	5791	5823	5825	5827	5873
	DSMS1			7587 #	7584	7589
	DSTEA			6932 #	6938
	DSTIND			6937 #	6934	6935
	DSUB			4135 #	4119
	DUMP			7999 #	7983	7990
	DVSUB1			4577 #	4574
	DVSUB2			4578 #	4572
	DVSUB3			4580 #	4584
	EACALC			2319 #	2382
	EAPF			8909 #	8889
	EAPF1			8914 #	8896
	EDBYTE			6669 #	6632	6660
	EDEXMD			6580 #	6551
	EDFILL			6596 #
	EDFIL1			6611 #	6598
	EDFLT			6627 #	6573	6617
	EDFLT1			6645 #	6641	6643
	EDISP			6510 #	6504
	EDISP1			6512 #	6512
	EDIT			6489 #
	EDITLP			6494 #	6718
	EDMSG			6654 #	6519
	EDMSG1			6663 #	6656
	EDN1A			6700 #	6705
	EDNOP			6689 #	6521	6523	6525	6539	6548	6574	6585	6606	6612	6665	6666
				6680
	EDNOP1			6690 #	6684
	EDNOP2			6707 #	6701	6707
	EDOPR			6539 #	6516
	EDSEL			6590 #	6543
	EDSFLT			6616 #	6600
	EDSKP			6677 #	6528	6531	6533
	EDSKP1			6681 #	6678
	EDSPUT			6603 #	6611	6621
	EDSSIG			6573 #	6545
	EDSTOP			6558 #	6541	6601
	EDSTP1			6564 #	6567
	ENDSKP			6301 #	6125
	EQV			2922 #	2915	2916	2917	2918
	EXCH			2624 #	2620
	EXTDSP			5965 #
	EXTEA			5964 #
	EXTEA0			5961 #	5959
	EXTEA1			5962 #	5970
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 273
; 								Cross Reference Listing					

	EXTEND			5951 #	5947
	EXTEXT			5974 #	5966	5980
	EXTIND			5970 #	5967
	FAD			5322 #	5299	5300	5301	5302	5303	5304	5305
	FAS1			5324 #
	FAS2			5333 #	5324
	FAS3			5336 #	5329	5330	5333	5334
	FAS4			5338 #	5338
	FDV			5385 #	5373	5374	5375	5377	5378	5379	5380
	FDV0			5391 #	5388
	FDV1			5393 #	5391
	FDV2			5394 #	5392
	FDV3			5395 #	5393	5394
	FDV4			5397 #	5398
	FDV5			5400 #	5397
	FDV6			5403 #	5400
	FDV7			5407 #	5408
	FDV8			5410 #
	FDV9			5418 #	5410	5415	5416
	FETIND			2375 #	2340	2345	2367
	FIX			5463 #	5458	5459
	FIX++			4595 #	4596
	FIX1++			4597 #	4595
	FIXL			5478 #	5468	5478
	FIXPC			8843 #	4271	6458
	FIXR			5473 #	5474
	FIXT			5485 #	5482
	FIXX			5482 #	5475
	FIXX1			5483 #	5489
	FL-BWRITE		2551 #	5483	5487	5533	5555
	FLEX			5533 #	5529
	FLTR			5428 #	5423
	FLTR1A			5436 #	5433
	FLTR1			5432 #	5429
	FLTR2			5441 #	5434	5436
	FLTR3			5443 #	5444
	FMP			5355 #	5344	5345	5346	5348	5349	5350	5351
	FMP1			5360 #	5358	5359
	FP-LONG			3970 #	3948	3949	3950	3951	3952	3953
	FPR0			2432 #	2426
	FPR1			2436 #
	FSB			5319 #	5307	5308	5309	5310	5311	5312	5313
	FSC			5449 #	5424
	GETPCW			7261 #	4016
	GETSRC			6881 #	6156	6591
	GOEXEC			4040 #	8916
	GRP700			7079 #	7035
	GRP701			7053 #	7036
	GRP702			7276 #	7272
	GSRC			6879 #	6113	6766
	GSRC1			6888 #	6884
	GTFILL			6951 #	5993	6490
	GTPCW1			7265 #	7256	7265
	H1			7918 #	7984
	HALT			3614 #	3566
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 274
; 								Cross Reference Listing					

	HALTED			7908 #	2227	2284	2302	2553	3616	7538	7570	8283	8834
	HALTLP			7924 #	7918
	HARD			8809 #	7777	8305	8307	8321
	HLL			2727 #	2636	2637	2680	2752
	HLLE			2793 #	2666	2667	2668	2669
	HLLO			2797 #	2656	2657	2658	2659
	HLLZ			2795 #	2646	2647	2648	2649
	HLR			2754 #	2683	2684
	HLRE			2786 #	2713	2714	2715	2716
	HLRM			2763 #	2685
	HLRO			2790 #	2703	2704	2705	2706
	HLRS			2766 #	2686
	HLRZ			2788 #	2693	2694	2695	2696
	HRL			2752 #	2641	2642
	HRLE			2779 #	2671	2672	2673	2674
	HRLM			2757 #	2643
	HRLO			2783 #	2661	2662	2663	2664
	HRLS			2760 #	2644
	HRLZ			2781 #	2651	2652	2653	2654
	HRR			2725 #	2638	2678	2679	2754
	HRRE			2772 #	2708	2709	2710	2711
	HRRO			2776 #	2698	2699	2700	2701
	HRRZ			2774 #	2688	2689	2690	2691
	HSBDON			8026 #
	IBP			4728 #	4721
	IBPS			4769 #	4731	4736	4750
	IBPX			4776 #	3867	4769	8664
	IDIV			4355 #	4343	4344	4345	4346
	IDPB			4750 #	4724
	IDST			6925 #	6186	6909
	IDSTX			6929 #	6926
	ILDB			4736 #	4722
	IMUL			4157 #	4151	4152	4153	4154
	IMUL1			4163 #	4380
	IMUL2			4165 #	4162
	IMUL3			4171 #	4168
	INCAR			7791 #	6087	7543
	INCPC			2312 #	2307
	INDEX			2352 #
	INDRCT			2370 #
	IOEA			7714 #	7646	7684
	IOEA1			7720 #	7722
	IOEA2			7724 #	7720
	IOEAI			7732 #	7725
	IOEAX			7741 #	7728
	IOR			2902 #	2895	2896	2897	2898	2963
	IORD			7645 #	7601	7612	7627
	IORD1			7654 #	7650
	IORD2			7664 #	7659
	IORD3			7670 #	7665	7671
	IOT700			7863 #	7806	7807	7808
	IOT710			7865 #	7810	7811
	IOT720			7872 #	7813	7814
	IOT730			7874 #	7816	7817	7818	7819	7820	7821	7822	7823
	IOT740			7876 #	7825	7826	7827	7828	7829	7830	7831	7832
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 275
; 								Cross Reference Listing					

	IOT750			7878 #	7834	7835	7836	7837	7838	7839	7840	7841
	IOT760			7880 #	7843	7844	7845	7846	7847	7848	7849	7850
	IOT770			7882 #	7852	7853	7854	7855	7856	7857	7858	7859
	IOW1			7754 #	7759
	IOW2			7766 #	7756	7762
	IOW3			7769 #	7776
	IOW4			7774 #	7770
	IOW5			7777 #	7764
	IOWAIT			7750 #	7655	7691
	IOWR			7683 #	7616	7636
	IOWR1			7689 #	7699	7705
	IOWR2			7696 #	7686
	IOWR3			7702 #	7697	7703
	ITRAP			8289 #	6089
	JEN			3622 #	3576
	JEN1			7584 #	3628	3643
	JEN2			3628 #	3620
	JFCL			3634 #	3554
	JFFO			3052 #	2991
	JFFO1			3060 #	3057
	JFFOL			3074 #	3076
	JMPA			3477 #	3885
	JRA			3879 #	3838
	JRST			3561 #	3502	3552
	JRST0			3590 #	3587	3611	3626
	JRST1			3608 #	3603	3607
	JRST10			3619 #	3573
	JRSTF			3584 #	3564
	JSA			3863 #	3837
	JSP			3842 #	3836
	JSR			3848 #	3835
	JSTAC			3743 #	3733	3740	3778
	JSTAC1			3746 #	3797
	JSYS			3964 #	3945
	JUMP			3509 #	3499	3500	3501	3503	3504	3505
	JUMP-TABLE		3462 #	3509	3523	3537	3547
	JUMP-			3489 #	3468	3471	3474	3637
	JUMPA			3493 #	3477	3480	3483	3486	3845	4046
	KIEPT			8755 #	8749	8752
	KIF10			8746 #	8739
	KIF30			8763 #	8744	8759
	KIF40			8770 #	8774
	KIF50			8778 #	8772	8801	8816
	KIF80			8799 #
	KIF90			8804 #	8795
	KIFILL			8734 #	8361
	KIMUUO			4052 #	3995
	KIUPT			8740 #	8762
	L-BDEC			5925 #	5898	5899
	L-CMS			5919 #	5888	5889	5890	5892	5893	5894
	L-DBIN			5923 #	5896	5897
	L-EDIT			5921 #	5891
	L-MVS			5927 #	5901	5902	5903	5904
	L-SPARE-A		5931 #	5907
	L-SPARE-B		5933 #	5908
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 276
; 								Cross Reference Listing					

	L-SPARE-C		5935 #	5909	5910	5911	5912	5913
	L-XBLT			5929 #	5906
	LDB			4738 #	4723
	LDB1			4825 #	4745	6189	6894
	LDB7			4839 #	4830	4831	4832	4833	4834
	LDBSH			4854 #	4849
	LDBSWP			4848 #	4827
	LDPI2			7430 #	3629	7419
	LOADAR			7782 #	6435	6498	6581	7716
	LOADARX			7785 #	6790	7350
	LOADPI			7429 #	2230
	LOADQ			7787 #	5154	6142
	LSH			3001 #	2990
	LSHC			3103 #	2994
	LSHCL			3111 #	3103	3111
	LSHCR			3107 #	3107
	LSHCX			3113 #	3108	3180	3185
	LSHL			3008 #	3003
	LUUO			4070 #	3891	3892	3893	3894	3895	3896	3897	3898
	LUUO1			4073 #	5919	5921	5923	5925	5927	5929	5931	5933	5935
	MAP			8261 #	8257
	MAPDON			8899 #	8854
	MOVE			2611 #	2585	2608	2615	2639	2681	2863	2864	2865	2866	2880	2881
				4144	4145	4171	4172	4196	5006
	MOVELP			6031 #	6011	6040
	MOVF1			6731 #	6737
	MOVFIL			6737 #	6063	6124
	MOVLP0			6040 #	6025
	MOVM			2608 #	2598	2600	2601
	MOVN			2613 #	2593	2594	2595	2596
	MOVPAT			6506 #	6501	6503	6506
	MOVRJ			6061 #	6017
	MOVS			2605 #	2588	2589	2590	2591	2758	2764	2781	2783	2788	2790
	MOVSTX			6114 #
	MOVST0			6109 #	6014
	MOVST1			6110 #	6065	6120
	MOVST2			6123 #	6034	6115
	MOVST3			6127 #	6123
	MOVST4			6119 #	6076
	MSKPAT			6507 #	6502
	MUL			4184 #	4176	4177	4178	4179
	MUL+			4306 #	4290	4302	4308	4326
	MUL-			4324 #	4316	4334
	MULBY4			6268 #	6251
	MULSB1			4288 #	5678
	MULSUB			4287 #	4160	4188	5081	5362
	MULTIPLY		4299 #	4267	5683	5695	5702
	MUUO			3977 #	3902	3903	3904	3905	3906	3907	3908	3909	3910	3911	3912
				3913	3914	3915	3916	3917	3918	3919	3920	3921	3922	3923	3924
				3925	3926	3927	3928	3929	3930	3931	3932	3933
	MVABT			6045 #	6036
	MVABT1			6048 #	6050
	MVABT2			6052 #	6048
	MVEND			6055 #
	MVS			5990 #
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 277
; 								Cross Reference Listing					

	MVS1			6007 #	6005
	MVSK2			6095 #	6069
	MVSK3			6085 #	6081
	MVSKP			6068 #	6061	6079	6092	6103
	MVSKP1			6079 #	6074
	MVSKP2			6091 #	6083
	MVSO			6019 #	6012
	MVSO1			6022 #	6022
	NEXT			4065 #	4006	4010	4053	8000	8003	8005	8007	8010	8013	8016	8019
				8022	8024
	NEXTAR			8918 #	8882	8910
	NICOND			2273 #	2558	3079	3125	3153	3465	3747	3823	3830	4521	4524	5479
				5485	5844	8271
	NICOND-FETCH		2292 #	2264	2265	2267	2268	2328	2334	3362	3374	3489	3490	3493
				3494	3561	3562	3588	3630	4257	4732	7421	7692
	NIDISP			3125 #	3825	3829	4378	4413	4444	4530	4747	5037	5389	5401	5466
				5754
	NODDIV			4529 #	4466	4468
	NODIV			4413 #	4407	4411
	NOMOD			2356 #
	NXTWRD			4775 #	4771
	ORCA			2942 #	2935	2936	2937	2938
	ORCB			2973 #	2966	2967	2968	2969
	ORCM			2963 #	2956	2957	2958	2959
	PAGE-FAIL		8287 #
	PF100			8543 #	8520
	PF105			8551 #	8547
	PF107			8524 #	8554	8558
	PF110			8561 #	8527
	PF120			8604 #	8584
	PF125			8623 #	8621	8827
	PF130			8586 #	8582	8588
	PF140			8580 #
	PF25			8344 #	8346
	PF30			8368 #	8357
	PF35			8381 #	8370
	PF40			8386 #	8378
	PF45			8393 #	8413	8492
	PF50			8425 #	8397
	PF60			8409 #	8411
	PF70			8431 #
	PF75			8443 #	8445
	PF76			8466 #	8462	8464
	PF77			8471 #	8375	8383
	PF80			8503 #	8476
	PF90			8515 #
	PFD			8295 #	8297
	PFDBIN			6992 #	8864
	PFDONE			8576 #	8802	8806
	PFGAC0			6994 #
	PFMAP			8325 #	8270	8309	8313	8315
	PFPI1			8818 #	8299	8311
	PFPI2			8826 #
	PFT			8834 #	8405	8425	8493	8503	8523	8660	8685	8690	8714	8778
	PFT1			8835 #	8823
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 278
; 								Cross Reference Listing					

	PFT10			8878 #	8876
	PFT1A			8842 #	8838
	PFT2			8874 #	8850
	PFT3			8877 #	8903
	PFTICK			8536 #	8485
	PI			7487 #	7489	8877
	PI10			7505 #	7497	7498	7499	7500	7501	7502	7503
	PI40			7523 #	7520
	PI50			7524 #	7574
	PIEXIT			7419 #	3658
	PIJSR			7538 #	7527
	PIP1			7497 #	7490
	PIP2			7498 #	7491
	PIP3			7499 #	7492
	PIP4			7500 #	7493
	PIP5			7501 #	7494
	PIP6			7502 #	7495
	PIP7			7503 #	7496
	PISET			3657 #	7545
	PIXPCW			3666 #	7530
	POP			3753 #	3707
	POPJ			3786 #	3708
	POPX1			3781 #	3769
	PTRIMM			8474 #
	PTRIND			8482 #	8539
	PTRSHR			8496 #	8478
	PUSH			3713 #	3706
	PUSH1			3715 #	3727
	PUSHJ			3725 #	3705
	PUTDST			6907 #	6038	6117	6399	6418	6604	6639	6664	6732
	PWRON			7913 #	2256
	QDNEG			4649 #	4453	4529
	QMULT			4266 #	4224	4244
	Q_RSH			5283 #	5255	5275
	RDAPR			7128 #
	RDCSB			7279 #
	RDCSTM			7283 #
	RDEBR			7246 #
	RDEBR1			7248 #	7248
	RDERA			7045 #
	RDHSB			7285 #
	RDINT			7392 #
	RDIO			7612 #	7605	7607
	RDPI			7398 #
	RDPT			8707 #	8401	8412	8419	8496	8653
	RDPUR			7281 #
	RDSPB			7277 #
	RDTIME			7361 #	7375
	RDTIM1			7377 #	7374
	RDUBR			7255 #
	ROT			3036 #	2989
	ROTC			3175 #	2993
	ROTCL			3183 #	3175	3183
	ROTCR			3179 #	3179
	ROTL			3046 #	3038
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 279
; 								Cross Reference Listing					

	RTNREG			7439 #	7091	7141	7252	7277	7279	7281	7283	7285	7393	7398
	RTNRG1			7440 #	7258
	SAVVMA			7994 #	7909	7981
	SBRL			7793 #	5404	6243
	SECIMM			8395 #
	SECSHR			8419 #	8399
	SETBLT			5132 #	5152	5241
	SETCA			2932 #	2925	2926	2927	2928
	SETCM			2953 #	2946	2947	2948	2949	2973
	SETO			2983 #	2976	2977	2978	2979
	SETPDL			3738 #	3783
	SETPTR			8676 #	8394	8473
	SETSN			5859 #	5412	5414	5709
	SETUBR			7192 #	7183
	SETZ			2840 #	2833	2834	2835	2836
	SFM			3676 #	3578
	SHDREM			8722 #	8457	8460
	SHIFT			2412 #	2422
	SKIP			2267 #	3377	3380	3383	6301	6429	7068
	SKIP-COMP-TABLE		3359 #	3406	3425	3426	6152
	SKIPE			3368 #	6128
	SKIPS			3423 #	3412	3413	3414	3415	3416	3417	3418	3419	3442
	SNNEG			5536 #	5521	5523	5525	5527
	SNNORM			5540 #	5536	5538	5540	5544
	SNNOT			5551 #	5547
	SNNOT1			5554 #	5549
	SNNOT2			5555 #	5551	5553	5554
	SNORM			5520 #	5339	5368	5445	5520	5532
	SNORM0			5445 #	5418	5430	5437	5452	5453
	SNORM1			5532 #	5528
	SOJ			3537 #	3526	3527	3528	3529	3530	3531	3532	3533
	SOS			3456 #	3445	3446	3447	3448	3449	3450	3451	3452
	SRCMOD			6764 #	6032	6217	6859	6863	6865
	SRND1			5565 #	5562
	SROUND			5562 #	5522	5524	5526	5541	5542	5543	5563
	SSWEEP			7476 #	7449	7462
	STAC			2557 #	2526	2570	2575	2583	2584	2599	2628	2808	3009	3022	3031
				5798	5805	5850	6056	6564	7897
	STAC34			6311 #	6306
	STBOTH			2568 #
	STBTH1			2573 #	2521
	STDBTH			2530 #
	STMAC			3730 #	3722
	STMEM			2562 #	7904
	STOBR			7797 #	3667	4019	7541
	STOPC			7799 #	3670	7917
	STORE			2576 #	2828	3678
	STPF1A			6990 #	6982
	STPTR1			8687 #	8684
	STPTR2			8693 #	8689
	STPTR3			8699 #	8695
	STRPF			6978 #	8856	8858
	STRPF0			6979 #	6996
	STRPF1			6982 #
	STRPF2			6993 #	6990
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 280
; 								Cross Reference Listing					

	STRPF3			6987 #
	STRPF4			6996 #	8862
	STRTIO			7795 #	7511	7559	7933
	STSELF			2520 #	2586
	STUBRS			7196 #	7198
	SUB			4110 #	4103	4104	4105	4106
	SWEEPL			7467 #	7470
	SWEEP			7461 #	7212	7232	7233
	T1LSH			5282 #	5253	5273
	TDONE			3336 #	3327	3330
	TDX			3307 #	3215	3224	3229	3233	3238	3242	3247	3251	3256	3260	3264
				3268	3273	3277
	TDXX			3312 #	3213	3217	3222	3226	3231	3235	3240	3244	3249	3253	3258
				3262	3266	3270	3275	3279
	TENLP			2216 #	2223
	TEST-TABLE		3318 #	3307	3313	7602
	TICK			7315 #	6098
	TIOX			7601 #	7594	7595	7596	7597
	TOCK			7318 #	7372	8537	8822
	TOCK1			7322 #	7328
	TOCK2			7329 #	7323
	TOCK3			7333 #	7340
	TRAP			7003 #	2277	2280	2283	2295	2298	2301
	TRNAR			6785 #	6594
	TRNFNC			6807 #	6795	6814	6818	6822	6834
	TRNNS1			6857 #	6847
	TRNNS2			6860 #	6857
	TRNRET			6839 #	6808
	TRNSIG			6820 #	6830
	TRNSS			6846 #	6841
	TRNSS1			6842 #	6850
	TRP1			7022 #	7012	7020
	TSX			3305 #	3216	3225	3230	3234	3239	3243	3248	3252	3257	3261	3265
				3269	3274	3278
	TSXX			3310 #	3214	3218	3223	3227	3232	3236	3241	3245	3250	3254	3259
				3263	3267	3271	3276	3280
	TXXX			3321 #	3336
	TXZX			3335 #	3324
	UMOVEM			7900 #	7888
	UMOVE			7892 #	7887
	UPCST			8651 #	8430	8506
	UUO			3976 #	3937	3944
	UUO101			3958 #	3938
	UUO102			3960 #	3939
	UUO103			3962 #	3940
	UUO106			3966 #	3946
	UUO107			3968 #	3947
	UUO247			3972 #	3954
	UUOFLG			4061 #	4001	4055
	UUOGO			3982 #	2471	3565	3574	3577	3579	3580	3581	3614	3619	3622	3642
				3663	3676	3958	3960	3962	3964	3966	3968	3970	3972	6947	7030
				7039	7040	7041	7045	7046	7047	7048	7053	7054	7055	7058	7059
				7060	7061	7062	7063	7064	7065	7286	7309	7404	7863	7872	7874
				7876	7878	7880	7882
	UUOPCW			4013 #	4058
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 281
; 								Cross Reference Listing					

	VECINT			7552 #	7515	7555
	VECIN1			7571 #	7569
	WRAPR			7094 #
	WRAPR1			7113 #	7125
	WRAPR2			7119 #	7112
	WRCSB			7293 #
	WRCSTM			7301 #
	WRCST			8663 #	8439	8568
	WREBR			7215 #
	WREBR1			7217 #	7217
	WRHSB			7305 #
	WRINT			7385 #
	WRIO			7616 #	7606	7608
	WRPI			7401 #
	WRPUR			7297 #
	WRSPB			7289 #
	WRTHSB			7987 #	7911
	WRTIME			7345 #
	WRTIM1			7357 #	7326	7353
	WRUBR			7152 #
	XCT			3687 #	3683
	XCT1			3699 #	3693	7029	7937
	XCT1A			3689 #	3697
	XCT2			2379 #	3700
	XCTGO			2304 #	2288	7929
	XJEN			3642 #	3570
	XJRSTF			3649 #	3569	3672
	XJRSTF0			3568 #	3646
	XLATE			6784 #	6770
	XLATE1			6793 #	6797
	XOR			2892 #	2885	2886	2887	2888
	XOS			3441 #	3456
	XPCW			3663 #	3571
	ZAPPTA			7472 #	7458
(D) J				1380 #
(U) JFCLFLG			1139 #	3634
(U) LD FLAGS			1143 #	2254	3593	3597	3655	4043	7529	7544	8840
(U) LD PCU			1131 #	4045
(U) LDVMA			1182 #	2197	2216	2220	2264	2264	2265	2267	2268	2268	2286	2312
				2327	2333	2339	2343	2366	2370	2379	2399	2441	2451	2454	2466
				2820	2824	2825	3056	3362	3362	3374	3489	3489	3490	3493	3494
				3494	3561	3562	3563	3568	3572	3575	3588	3601	3604	3630	3645
				3651	3666	3668	3668	3677	3717	3744	3754	3766	3771	3787	3850
				3881	3993	3994	3994	4003	4004	4004	4018	4018	4037	4038	4065
				4065	4074	4081	4082	4257	4257	4732	4732	4741	4788	4792	4796
				4800	5133	5161	5169	5183	5184	5188	5189	5206	5207	5285	5291
				5291	5965	5967	5968	5991	6139	6388	6415	6460	6466	6473	6489
				6494	6550	6628	6670	6785	6932	6933	6934	6935	7011	7019	7152
				7257	7348	7373	7378	7378	7421	7421	7439	7445	7508	7523	7523
				7523	7524	7565	7565	7573	7654	7689	7692	7692	7714	7736	7795
				7892	7900	7910	7913	7913	7916	7916	7927	7983	7999	7999	8002
				8002	8009	8009	8012	8012	8015	8015	8018	8018	8021	8021	8028
				8325	8373	8374	8374	8381	8382	8382	8386	8388	8466	8468	8610
				8626	8707	8709	8741	8742	8756	8758	8824	8830	8878	8879	8879
				8915	8915	8918	8918
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 282
; 								Cross Reference Listing					

(U) LOADFE			986 #	2415	2433	2448	3002	3005	3009	3019	3021	3037	3040	3043
				3048	3060	3075	3121	4739	4743	4755	4848	4853	4855	4857	4860
				4923	4936	4939	4940	4942	4944	5252	5254	5272	5274	5282	5283
				5328	5356	5365	5367	5387	5393	5394	5408	5430	5434	5436	5437
				5451	5520	5524	5526	5532	5540	5542	5543	5544	5563	5568	5609
				5624	5626	5690	5707	5718	5741	5767	5781	5788	5791	5803	5820
				5825	5827	5848	5873	5881	6019	6020	6022	6188	6559	6560	6566
				6690	6691	6692	6693	6890	6893	6912	6930
(U) LOADSC			984 #	2211	2221	2414	2433	2448	2464	3025	3027	3103	3104	3105
				3107	3111	3121	3130	3133	3137	3144	3175	3176	3177	3179	3183
				4158	4186	4223	4243	4263	4289	4301	4307	4315	4325	4333	4376
				4473	4481	4588	4591	4631	4977	4980	4993	4999	5004	5017	5033
				5078	5093	5099	5322	5326	5327	5336	5338	5360	5407	5441	5444
				5449	5467	5468	5469	5471	5474	5478	5588	5598	5608	5642	5645
				5652	5667	5670	5678	5682	5685	5695	5701	5756	5757	6333	6362
				6501	6503	6506	6510	6512	6683	6689	6695	6700	6707	7194	7197
				7215	7217	7246	7248	7256	7262	7265	7456	7469	7476	7664	7671
				7696	7702	7750	7757	7766	7770	8342	8345	8393	8407	8410	8441
				8444	8581	8587
(U) LSRC			636 #
(U) MACRO%
	ABORT MEM CYCLE		2035 #	2197	3645	7508	7910	7983	8325	8824	8830
	AC			1885 #	4157	4184	4355	4446	5385	5450	5591	5593
	AC[]			1886 #	4522	5730	5738	6241	6305
	AC[]_Q			1787 #	3153	4218	4226	4237	4249
	AC[]_Q.AND.[]		1776 #	4476	4520	4650	4655	4660	4666	4667
	AC[]_[]			1763 #	2525	2808	3079	4493	4499	5805	5850	6048	6068	6085	6168
				6202	6261	6263	6298	6311	6312	6348	6380	6386	6397	6402	6425
				6426	6585	6888	6929	6967	6975	6982	6987
	AC[]_[] TEST		1764 #	6860
	AC[]_[] VIA AD		1761 #
	AC[]_[]*2		1766 #	4235
	AC[]_[]+1		1765 #	6734
	AC[]_[]+Q		1771 #
	AC[]_[]+[]		1773 #	4518	6244
	AC[]_[]-[]		1772 #	6002
	AC[]_[].AND.[]		1775 #	4496	5797	5843
	AC[]_[].EQV.Q		1777 #	4250	4252	4254	4523
	AC[]_-Q			1783 #
	AC[]_-[]		1778 #
	AC[]_.NOT.[]		1781 #
	AC[]_0			1785 #	2209	3058	4494	6075	6123	6319	6321
	AC[]_1			1786 #	2210
	AC_-[]			1779 #	5842
	AC_.NOT.[]		1782 #	5841
	AC_Q			1784 #	4492
	AC_[]			1767 #	2557	3114	3336	3425	3465	3477	3746	3748	3844	4668	4746
				5153	5217	5242	5479	5485	6125	6161	6424	6645	6718	6994	7613
				7801	8271
	AC_[] TEST		1768 #	3468	3471	3474	3480	3483	3486	4248	6299	6345
	AC_[] VIA AD		1762 #
	AC_[]+1			1769 #	6970
	AC_[]+Q			1770 #
	AC_[]+[]		1774 #	3147	3811	3816
	AC_[].OR.[]		1780 #	5104	6088	6127
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 283
; 								Cross Reference Listing					

	AD FLAGS		2063 #	2614	3440	3456	3523	3537	4097	4111	4128	4138	4141	4268
				4679	4681
	AD FLAGS EXIT		2111 #	4097	4111
	AD PARITY		1989 #	2217	2393	2406	2407	2624	2725	2727	2758	2764	2817	3001
				3004	3018	3052	3509	3753	3786	3808	3866	3879	4186	4228	4365
				4756	5152	5240	5322	5355	5387	5451	5597	5994	5997	6012	6015
				6045	6061	6133	6135	6153	6185	6197	6200	6228	6231	6233	6240
				6250	6291	6293	6294	6326	6331	6332	6333	6354	6359	6371	6406
				6491	6549	6590	6627	6629	6733	6846	6853	6879	6881	6908	6965
				6973	6979	7616	7903
	ADD .25			2020 #	2613	2983	3406	3456	3537	3563	3572	3575	4110	4127	4135
				4140	4314	4318	4360	4404	4437	4460	4461	4467	4488	4514	4555
				4556	4557	4573	4575	4582	4588	4619	4649	4654	4659	4664	4676
				4680	4684	4686	5015	5072	5089	5139	5158	5176	5200	5288	5319
				5394	5397	5398	5405	5416	5429	5521	5523	5525	5527	5538	5554
				5583	5622	5735	5746	5753	5769	5810	5815	5836	5842	5876	6002
				6035	6049	6070	6137	6173	6174	6175	6222	6286	6304	6307	6375
				6392	6400	6419	6427	6428	6462	6464	6467	6515	6857	6978	6986
				6992	7330	7430	7454	7467	7714	8736	8746	8843	8903
	ADL PARITY		1982 #
	ADR PARITY		1986 #
	AREAD			2106 #	2357
	ASH			1997 #	2461	3021
	ASH AROV		2048 #	3027	3143	3146
	ASH36 LEFT		3014 #	3027
	ASHC			2002 #	3027	3136	3139	3143	3146	4307	4315	4325	4333	4439	4443
				4512	4516	4532	5338	5441	5443	5473	5617	5619	5623	5625	5641
				5645	5652	5655	5657	5669	5710	5714	5749	5763	5781	5787	5790
				5803	5820	5824	5826	5848	5873
	B DISP			2107 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	3307	3313	3406
				3425	3426	3509	3523	3537	3547	3732	3739	3777	4097	4111	4163
				4169	4192	4194	5246	5475	5483	5487	5533	5545	5555	5562	5966
				6008	6152	6207	6414	6768	6840	6847	7602	7629	7647	7658	7685
				8602	8902
	BAD PARITY		1991 #
	BASIC DIV STEP		4567 #	4588	4591
	BWRITE DISP		2108 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	4097	4111	4163
				4169	4192	4194	8602	8902
	BYTE DISP		2125 #	4744	4761	6189	6892	6913
	BYTE STEP		4716 #	6020	6022
	CALL IBP		4710 #	4731	4736	4750
	CALL LOAD PI		2131 #	3629	7419
	CALL []			2021 #	2218	2230	2435	2807	2817	3587	3626	3628	3629	3643	3667
				3670	3867	3870	3985	4001	4006	4010	4016	4019	4053	4055	4160
				4188	4215	4224	4234	4244	4267	4377	4398	4453	4459	4473	4477
				4483	4529	4553	4731	4736	4740	4745	4750	4759	4762	5010	5020
				5054	5081	5136	5152	5154	5241	5253	5255	5273	5275	5362	5404
				5407	5412	5414	5522	5524	5526	5541	5542	5543	5602	5610	5638
				5678	5683	5695	5702	5709	5728	5752	5756	5760	5785	5788	5791
				5823	5825	5827	5833	5953	5993	5996	6000	6032	6038	6063	6087
				6098	6113	6117	6124	6134	6136	6142	6156	6165	6186	6201	6204
				6217	6232	6243	6251	6254	6257	6260	6268	6273	6300	6335	6344
				6360	6372	6399	6410	6418	6435	6461	6490	6493	6498	6573	6581
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 284
; 								Cross Reference Listing					

				6591	6594	6604	6617	6632	6639	6660	6664	6732	6766	6790	6890
				6909	6914	6966	6974	6985	7256	7326	7350	7353	7372	7419	7449
				7462	7511	7541	7543	7559	7563	7601	7612	7627	7646	7655	7684
				7691	7716	7909	7911	7917	7933	7981	7983	8000	8003	8005	8007
				8010	8013	8016	8019	8022	8024	8394	8401	8412	8419	8430	8439
				8457	8460	8473	8496	8506	8537	8568	8653	8811	8822	8882	8910
	CHANGE FLAGS		2041 #	2253	2254	2614	3440	3456	3523	3537	3593	3594	3597	3598
				3634	3655	3656	3726	3738	3794	3824	3828	3843	3849	4043	4044
				4045	4097	4111	4128	4138	4141	4171	4172	4196	4246	4258	4268
				4271	4378	4413	4444	4530	4679	4681	4746	4763	4785	5037	5389
				5401	5466	5754	6428	6429	7027	7529	7544	8840
	CHK PARITY		1990 #	2305	2375	2389	2398	2402	2419	2430	2441	2447	2460	2531
				2563	2569	2574	2577	2627	2823	3123	3442	3585	3609	3624	3649
				3653	3714	3731	3737	3759	3776	3782	3795	3853	3884	4006	4008
				4014	4041	4053	4057	4080	4158	4251	4253	4356	4366	4450	4472
				4479	4776	4804	4810	4931	5196	5245	5951	5970	6390	6580	6630
				6633	6661	6937	6952	7022	7155	7290	7294	7298	7302	7306	7347
				7377	7379	7386	7440	7524	7566	7690	7737	7782	7785	7787	7797
				7799	7896	7915	7935	8000	8001	8003	8004	8007	8008	8010	8011
				8013	8014	8016	8017	8019	8020	8022	8023	8025	8390	8472	8712
				8764	8881	8895	8909	8911
	CHK PARITY L		1983 #
	CHK PARITY R		1987 #
	CLEANUP DISP		2133 #	8845
	CLEAR ARX0		1739 #	2807	4675	6303	6344	6470	6476
	CLEAR CONTINUE		2030 #
	CLEAR EXECUTE		2031 #
	CLEAR RUN		2032 #
	CLEAR []0		1738 #	2807	4397	4675	6280	6296	6303	6344	6470	6476
	CLR FPD			2050 #	3726	3843	3849	4246	4746	4763	6429
	CLR IO BUSY		2036 #	7645	7683
	CLR IO LATCH		2037 #	7730	7738	7742	7745	7754	7760	7769	7774
	CLRCSH			2027 #	7451	7452	7455
	DFADJ			5634 #	5645
	DISMISS			2130 #	3628	3643
	DIV			2005 #	4588	4591	4592	4639	5520	5532	5540	5544	5637	5639	5640
	DIV DISP		2124 #
	DIV STEP		4568 #	4591
	DONE			2116 #	2264	2268	3362	3489	3494	4257	4732	7421	7692
	DPB SCAD		4919 #	4924	4925	4926	4927	4928
	EA MODE DISP		2105 #	2315	2381	3590	4783	4786	5962	6938	7726
	END BLT			2073 #	5179	5203	5289
	END MAP			2074 #	8592
	END STATE		2071 #	5179	5203	5289	6056	6128	6151	6301	6429	6433	6495	6767
				8592	8849	8867	8868	8899
	EXIT			2110 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	4163	4169	4192
				4194	8602	8902
	EXP TEST		2062 #	5529	5545	5875
	FETCH			1842 #	2264	2265	2267	2268	2287	2327	2333	2441	2466	3056	3362
				3374	3489	3490	3493	3494	3561	3562	3588	3630	3745	4257	4732
				4741	7421	7692	7928
	FE_-1			1962 #
	FE_-12.			1960 #	3060
	FE_-2			1959 #
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 285
; 								Cross Reference Listing					

	FE_-FE			1946 #	4848	4942
	FE_-FE+200		1973 #	5393	5394
	FE_-FE+S#		1949 #	4853
	FE_-FE-1		1947 #	3002	3037
	FE_-S-10		1956 #	4857	4923
	FE_-S-20		1955 #
	FE_0			1961 #
	FE_EXP			1968 #	2433	2448	5328	5609
	FE_FE+1			1963 #	3005	3019	3040	5408	5524	5526	5542	5543	5563	5568	5788
				5791	5825	5827	5873	5881
	FE_FE+10		1965 #	4855	4860	4936	4944
	FE_FE+2			1964 #	5365
	FE_FE+4			1967 #	3075
	FE_FE+P			1971 #	6560
	FE_FE+S#		1974 #	5707	5718	6693
	FE_FE+SC		1950 #	6692
	FE_FE-1			1966 #	5520	5532	5540	5544	5624	5626	5781	5803	5820	5848
	FE_FE-19		1948 #
	FE_FE-200		1972 #	5367
	FE_FE.AND.S#		1951 #	4743	4940	6188	6566	6691	6893
	FE_P			1952 #	4739	4939	6690	6890	6930
	FE_S			1953 #
	FE_S#			1957 #	3060	5252	5254	5272	5274	5430	5434	5436	5437	6559
	FE_S#-FE		1958 #	5767
	FE_S+2			1954 #	6019
	FE_SC+EXP		1969 #	5356	5451	5690
	FE_SC-EXP		1970 #	5387	5741
	FIRST DIV STEP		4569 #	4588
	FIX [] SIGN		1752 #	3423	4143	4167	4190	6771	7320
	FL NO DIVIDE		2066 #	5389	5401	5754
	FL-EXIT			2112 #	5483	5487	5533	5555
	FM WRITE		1759 #	2196	2204	2206	2207	2209	2210	2212	2213	2219	2221	2525
				2557	2808	3058	3079	3114	3147	3153	3336	3425	3465	3468	3471
				3474	3477	3480	3483	3486	3699	3746	3748	3811	3816	3844	4218
				4226	4235	4237	4248	4249	4250	4252	4254	4476	4492	4493	4494
				4496	4499	4518	4520	4523	4650	4655	4660	4666	4667	4668	4729
				4746	4988	5001	5011	5021	5053	5104	5153	5217	5242	5479	5485
				5797	5805	5841	5842	5843	5850	5961	5974	5977	6002	6007	6024
				6048	6068	6069	6075	6085	6088	6095	6096	6097	6112	6123	6125
				6127	6143	6159	6161	6168	6182	6195	6202	6213	6244	6261	6263
				6298	6299	6311	6312	6319	6321	6334	6336	6345	6348	6380	6386
				6392	6397	6398	6402	6411	6417	6424	6425	6426	6585	6616	6645
				6718	6734	6764	6860	6888	6929	6953	6967	6970	6975	6982	6987
				6994	7004	7116	7225	7291	7295	7299	7303	7307	7322	7333	7354
				7357	7387	7388	7472	7473	7613	7721	7755	7761	7763	7801	7908
				7980	7995	8005	8267	8271	8288	8289	8291	8292	8299	8309	8311
				8313	8315	8319	8320	8461	8463	8484	8809
	FORCE EXEC		1822 #	7525	7539	7573
	GEN 17-FE		1977 #	4825
	GEN MSK []		1755 #	4859	4862	4935	4938	6022
	HALT []			2132 #	2227	2284	2302	2553	3616	7538	7570	8283	8834
	HOLD LEFT		1981 #	2265	2267	2312	2325	2326	2332	2337	2352	2353	2365	2376
				2399	2727	2758	2766	2788	2790	3374	3490	3493	3561	3562	3563
				3572	3575	3588	3600	3630	3654	3668	3796	3855	3869	3873	4018
				4030	4035	4065	4081	4132	4775	4805	5014	5073	5096	5145	5157
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 286
; 								Cross Reference Listing					

				5179	5183	5188	5203	5206	5216	5268	5269	5289	5291	5364	5627
				5964	5967	5970	6011	6037	6040	6056	6062	6091	6110	6116	6124
				6128	6139	6151	6155	6162	6181	6209	6286	6301	6339	6374	6391
				6418	6429	6433	6489	6495	6542	6599	6603	6638	6663	6704	6709
				6767	6886	6928	6937	7096	7122	7136	7205	7221	7223	7267	7348
				7353	7378	7412	7414	7416	7418	7430	7490	7491	7492	7493	7494
				7495	7496	7518	7588	7714	7735	7735	7916	7932	8002	8009	8012
				8015	8018	8021	8270	8546	8592	8600	8843	8849	8855	8857	8859
				8861	8863	8865	8867	8868	8869	8899	8918
	HOLD RIGHT		1985 #	2456	2458	2471	2493	2494	2725	2760	2764	2781	2783	2807
				3150	3152	3423	3565	3574	3577	3579	3580	3581	3614	3619	3622
				3642	3663	3676	3807	3958	3960	3962	3964	3966	3968	3970	3972
				3980	4000	4010	4062	4078	4143	4144	4145	4167	4190	4397	4436
				4498	4552	4675	4852	4987	4995	5058	5103	5138	5142	5329	5330
				5333	5334	5358	5359	5391	5392	5452	5453	5529	5545	5648	5649
				5656	5672	5794	5829	5859	5860	5875	5957	5979	6206	6211	6280
				6296	6297	6303	6342	6344	6351	6357	6366	6385	6437	6440	6445
				6470	6476	6547	6641	6643	6713	6717	6771	6813	6817	6821	6825
				6829	6833	6849	6947	6959	7030	7039	7040	7041	7045	7046	7047
				7048	7053	7054	7055	7058	7059	7060	7061	7062	7063	7064	7065
				7090	7130	7133	7161	7168	7172	7187	7193	7202	7210	7232	7233
				7251	7255	7261	7286	7309	7320	7404	7406	7408	7410	7542	7744
				7789	7863	7872	7874	7876	7878	7880	7882	8263	8266	8328	8332
				8335	8340	8491	8516	8553	8557	8591	8595	8598	8609	8679	8784
				8789	8794	8800	8814	8877
	IBP DP			4707 #	4731	4736	4750	6072	6882	6925	6998
	IBP SCAD		4708 #	4731	4736	4750	6072	6882	6925
	IBP SPEC		4709 #	4731	4736	4750
	INH CRY18		1993 #	3546	3716	3763	3792	3812	3817	5069	5144
	INST DISP		2109 #	2390	2394	2403	2408	2416	2437	2443	2467	2472
	INTERRUPT TRAP		2122 #
	JFCL FLAGS		2059 #	3634
	JUMP DISP		2115 #	3509	3523	3537	3547
	JUMPA			2117 #	3490	3493	3561	3562	3588	3630
	LDB SCAD		4821 #	4830	4831	4832	4833	4834
	LEAVE USER		2057 #	2253	4044
	LOAD AC BLOCKS		2025 #	2199	7188	7211
	LOAD BYTE EA		2016 #	4739	4758	4806	5958	5970	6889
	LOAD DST EA		2019 #	6926	6928	6937
	LOAD FE			1899 #	2415	2433	2448	3002	3005	3009	3019	3021	3037	3040	3043
				3048	3060	3075	3121	4739	4743	4755	4848	4853	4855	4857	4860
				4923	4936	4939	4940	4942	4944	5252	5254	5272	5274	5282	5283
				5328	5356	5365	5367	5387	5393	5394	5408	5430	5434	5436	5437
				5451	5520	5524	5526	5532	5540	5542	5543	5544	5563	5568	5609
				5624	5626	5690	5707	5718	5741	5767	5781	5788	5791	5803	5820
				5825	5827	5848	5873	5881	6019	6020	6022	6188	6559	6560	6566
				6690	6691	6692	6693	6890	6893	6912	6930
	LOAD FLAGS		2061 #	2254	3593	3597	3655	4043	7529	7544	8840
	LOAD IND EA		2017 #	2377
	LOAD INST		2014 #	2306	3691	7023	7936
	LOAD INST EA		2015 #	3586	3610	3625	7733
	LOAD IR			2010 #	5957
	LOAD PAGE TABLE		2024 #	7446	8618
	LOAD PCU		2055 #	4045
	LOAD PI			2028 #	3644	7432	7507	7989
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 287
; 								Cross Reference Listing					

	LOAD PXCT		2022 #	3696
	LOAD SC			1898 #	2211	2221	2414	2433	2448	2464	3025	3027	3103	3104	3105
				3107	3111	3121	3130	3133	3137	3144	3175	3176	3177	3179	3183
				4158	4186	4223	4243	4263	4289	4301	4307	4315	4325	4333	4376
				4473	4481	4588	4591	4631	4977	4980	4993	4999	5004	5017	5033
				5078	5093	5099	5322	5326	5327	5336	5338	5360	5407	5441	5444
				5449	5467	5468	5469	5471	5474	5478	5588	5598	5608	5642	5645
				5652	5667	5670	5678	5682	5685	5695	5701	5756	5757	6333	6362
				6501	6503	6506	6510	6512	6683	6689	6695	6700	6707	7194	7197
				7215	7217	7246	7248	7256	7262	7265	7456	7469	7476	7664	7671
				7696	7702	7750	7757	7766	7770	8342	8345	8393	8407	8410	8441
				8444	8581	8587
	LOAD SRC EA		2018 #
	LOAD VMA		1821 #	2197	2216	2220	2264	2264	2265	2267	2268	2268	2286	2312
				2327	2333	2339	2343	2366	2370	2379	2399	2441	2451	2454	2466
				2820	2824	2825	3056	3362	3362	3374	3489	3489	3490	3493	3494
				3494	3561	3562	3563	3568	3572	3575	3588	3601	3604	3630	3645
				3651	3666	3668	3668	3677	3717	3744	3754	3766	3771	3787	3850
				3881	3993	3994	3994	4003	4004	4004	4018	4018	4037	4038	4065
				4065	4074	4081	4082	4257	4257	4732	4732	4741	4788	4792	4796
				4800	5133	5161	5169	5183	5184	5188	5189	5206	5207	5285	5291
				5291	5965	5967	5968	5991	6139	6388	6415	6460	6466	6473	6489
				6494	6550	6628	6670	6785	6932	6933	6934	6935	7011	7019	7152
				7257	7348	7373	7378	7378	7421	7421	7439	7445	7508	7523	7523
				7523	7524	7565	7565	7573	7654	7689	7692	7692	7714	7736	7795
				7892	7900	7910	7913	7913	7916	7916	7927	7983	7999	7999	8002
				8002	8009	8009	8012	8012	8015	8015	8018	8018	8021	8021	8028
				8325	8373	8374	8374	8381	8382	8382	8386	8388	8466	8468	8610
				8626	8707	8709	8741	8742	8756	8758	8824	8830	8878	8879	8879
				8915	8915	8918	8918
	LSH			1998 #
	LSHC			2001 #	3107	3111	4620	4623
	LUUO			2119 #	5919	5921	5923	5925	5927	5929	5931	5933	5935
	MEM CYCLE		1818 #	2197	2216	2220	2264	2264	2264	2265	2265	2267	2267	2268
				2268	2268	2286	2287	2304	2312	2327	2327	2333	2333	2338	2339
				2343	2344	2366	2367	2370	2371	2375	2379	2388	2397	2399	2400
				2401	2429	2440	2441	2441	2451	2452	2454	2455	2459	2466	2466
				2530	2562	2568	2573	2576	2625	2626	2820	2821	2823	2824	2825
				2827	3056	3056	3362	3362	3362	3374	3374	3441	3442	3489	3489
				3489	3490	3490	3493	3493	3494	3494	3494	3561	3561	3562	3562
				3563	3563	3568	3568	3572	3572	3575	3575	3584	3588	3588	3601
				3602	3604	3605	3608	3623	3630	3630	3645	3649	3651	3652	3653
				3666	3666	3668	3668	3669	3672	3677	3677	3713	3717	3718	3730
				3736	3744	3745	3754	3755	3758	3766	3768	3771	3773	3775	3781
				3787	3789	3795	3850	3851	3852	3864	3881	3882	3883	3993	3994
				3994	4003	4004	4004	4005	4007	4013	4018	4018	4018	4037	4038
				4039	4040	4052	4056	4065	4065	4065	4074	4075	4079	4081	4082
				4083	4257	4257	4257	4732	4732	4732	4741	4741	4769	4775	4776
				4788	4789	4792	4793	4796	4797	4800	4801	4803	4809	4930	4931
				5133	5134	5161	5162	5169	5170	5172	5183	5184	5186	5188	5189
				5191	5195	5198	5206	5207	5209	5244	5285	5285	5287	5291	5291
				5292	5951	5965	5967	5967	5968	5968	5970	5991	5992	6139	6139
				6388	6389	6390	6415	6416	6460	6466	6473	6489	6489	6494	6494
				6550	6550	6582	6584	6628	6628	6630	6633	6661	6670	6670	6785
				6786	6932	6932	6933	6933	6934	6934	6935	6935	6937	6951	7007
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 288
; 								Cross Reference Listing					

				7010	7011	7015	7018	7019	7022	7152	7153	7154	7257	7257	7289
				7290	7293	7294	7297	7298	7301	7302	7305	7306	7345	7346	7348
				7349	7373	7374	7377	7378	7378	7378	7379	7385	7386	7421	7421
				7421	7439	7439	7440	7445	7508	7512	7523	7523	7523	7524	7524
				7539	7560	7565	7565	7566	7573	7574	7654	7656	7689	7690	7692
				7692	7692	7714	7715	7736	7736	7737	7782	7785	7787	7795	7797
				7799	7892	7893	7895	7900	7901	7910	7913	7913	7915	7916	7916
				7916	7927	7928	7934	7983	7999	7999	8000	8001	8002	8002	8002
				8003	8004	8007	8008	8009	8009	8009	8010	8011	8012	8012	8012
				8013	8014	8015	8015	8015	8016	8017	8018	8018	8018	8019	8020
				8021	8021	8021	8022	8023	8025	8028	8325	8373	8374	8374	8381
				8382	8382	8386	8387	8388	8389	8466	8467	8468	8471	8610	8626
				8663	8707	8708	8709	8711	8741	8742	8743	8756	8757	8758	8763
				8824	8830	8878	8879	8879	8880	8894	8909	8911	8915	8915	8918
				8918	8918
	MEM READ		1846 #	2304	2375	2388	2397	2401	2429	2440	2459	3584	3608	3623
				3649	3653	3713	3758	3795	3883	4040	4803	4809	5195	5244	5951
				5970	6390	6633	6661	6937	6951	7007	7015	7022	7154	7290	7294
				7298	7302	7306	7346	7386	7512	7524	7560	7566	7656	7737	7782
				7785	7787	7895	7934	8389	8471	8711	8763
	MEM WAIT		1845 #	2304	2375	2388	2397	2401	2429	2440	2459	2530	2562	2568
				2573	2576	2626	2823	3442	3584	3608	3623	3649	3653	3713	3730
				3736	3758	3775	3781	3795	3852	3883	4005	4007	4013	4040	4052
				4056	4079	4776	4803	4809	4931	5172	5195	5198	5244	5287	5951
				5970	6390	6584	6630	6633	6661	6937	6951	7007	7015	7022	7154
				7290	7294	7298	7302	7306	7346	7377	7379	7386	7440	7512	7524
				7560	7566	7656	7690	7737	7782	7785	7787	7797	7799	7895	7915
				7934	8000	8001	8003	8004	8007	8008	8010	8011	8013	8014	8016
				8017	8019	8020	8022	8023	8025	8389	8471	8711	8763	8880	8894
				8909	8911
	MEM WRITE		1847 #	2530	2562	2568	2573	2576	2626	2823	3442	3730	3736	3775
				3781	3852	4005	4007	4013	4052	4056	4079	4776	4931	5172	5198
				5287	6584	6630	7377	7379	7440	7690	7797	7799	7915	8000	8001
				8003	8004	8007	8008	8010	8011	8013	8014	8016	8017	8019	8020
				8022	8023	8025	8880	8894	8909	8911
	MEM_Q			1854 #	5173	5199	5287	6584
	MEM_[]			1853 #	2531	2563	2569	2574	2577	2627	2823	3442	3731	3737	3776
				3782	3853	4006	4008	4014	4053	4057	4080	4776	4931	6630	7377
				7379	7440	7690	7797	7799	7915	8000	8001	8003	8004	8007	8008
				8010	8011	8013	8014	8016	8017	8019	8020	8022	8023	8025	8881
				8895	8909	8911
	MUL DISP		2123 #	4307	4315	4325	4333	5619	5645	5647	5764
	MUL FINAL		4285 #	4311	4319	4329	4337
	MUL STEP		4284 #	4307	4315	4325	4333
	NEXT INST		2103 #	2558	3079	3125	3153	3465	3747	3823	3830	4521	4524	5479
				5485	5844	8271
	NEXT INST FETCH		2104 #	2264	2265	2267	2268	2328	2334	3362	3374	3489	3490	3493
				3494	3561	3562	3588	3630	4257	4732	7421	7692
	NEXT [] PHYSICAL WRI	1876 #	4018	4065	7916	8002	8009	8012	8015	8018	8021	8918
	NO DIVIDE		2065 #	4378	4413	4444	4530	5037
	NORM DISP		2129 #	5339	5368	5445	5520	5522	5532	5536	5538	5540	5541	5544
				5566	5717	5771	5772	5782	5784	5804	5814	5816	5821	5822	5849
				5878
	ONES			2004 #	4859	4862	4935	4938	6022
	PAGE FAIL TRAP		2120 #	8405	8425	8493	8503	8523	8660	8685	8690	8714	8778
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 289
; 								Cross Reference Listing					

	PI DISP			2128 #
	PXCT BLT DEST		1830 #	5163	5171	5185	5190	5286
	PXCT BLT SRC		1834 #	5135	5208	5292
	PXCT BYTE DATA		1832 #	4790	4794	6932	6933
	PXCT BYTE PTR EA	1831 #	4798	4802
	PXCT DATA		1829 #	2357	2399	2451	2454	2822	2826	3767	3772
	PXCT EA			1828 #	2366	2371	3606
	PXCT EXTEND EA		1835 #	5967	5968
	PXCT STACK WORD		1833 #	3719	3756	3788
	Q-[]			1703 #	4467
	Q.AND.NOT.[]		1704 #
	Q_#			1719 #	5012	5056
	Q_-1			1711 #
	Q_-AC[]			1712 #	4649	4654	4659
	Q_-Q			1713 #	4437	4514	4555	4556	4573	5521	5523	5525	5527	5810
	Q_-[]			1710 #	5746
	Q_.NOT.AC[]		1709 #	4653	4658
	Q_.NOT.Q		1718 #	5809
	Q_0			1720 #	3017	4858	4934	5336	5407	5418	5430	5434	5436	5437	5450
				5463	5756	6020
	Q_0 XWD []		1721 #
	Q_AC			1714 #	4158	4356
	Q_AC[]			1715 #	2419	3123	4251	4253	4366	6580
	Q_AC[].AND.MASK		1716 #
	Q_AC[].AND.[]		1717 #	4450	4472	4479
	Q_MEM			1864 #	5196	5245	7787
	Q_Q*.5			1726 #	4266	4300	4473	5247	5267	5268	5269	5283	5671	5761
	Q_Q*2			1727 #	5262	5263
	Q_Q+.25			1722 #	5622	5769
	Q_Q+1			1723 #
	Q_Q+AC			1725 #	5032
	Q_Q+[]			1732 #	4475	4507	5604	5612	5713	5716
	Q_Q-1			1724 #	5072
	Q_Q-WORK[]		1811 #	5015
	Q_Q.AND.#		1729 #	3149	4550	5256	5276	5363	5672
	Q_Q.AND.NOT.[]		1731 #	5758
	Q_Q.AND.[]		1730 #	4522	4941
	Q_Q.OR.#		1728 #	3151	4435
	Q_WORK[]		1793 #	5079	6179
	Q_[]			1705 #	4184	4223	4243	4263	4477	4503	5003	5360	5595	5607	5667
				5682	5695	5701	5751
	Q_[]+[]			1707 #	4504
	Q_[]-[]			1706 #	5139
	Q_[].AND.Q		1733 #	4598	5793	5828
	Q_[].AND.[]		1708 #	4425
	Q_[].OR.Q		1734 #	5279	5627
	RAM_[]			1814 #	2219	2221
	READ Q			1744 #	5486	5528	5552	5801	5846
	READ XR			1742 #	3592
	READ []			1743 #	2412	2432	2608	2772	2779	2786	2793	3104	3120	3176	3321
				3365	3368	3371	3377	3380	3383	3596	3644	3655	3695	3988	3992
				4002	4036	4042	4073	4161	4367	4373	4387	4392	4394	4399	4466
				4468	4485	4501	4510	4571	4578	4599	4738	4742	4757	4760	4857
				4923	4939	5060	5324	5328	5411	5413	5445	5449	5482	5522	5541
				5609	5708	5717	5766	5784	5822	5958	5976	6019	6053	6154	6157
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 290
; 								Cross Reference Listing					

				6163	6176	6187	6203	6379	6415	6466	6473	6499	6513	6518	6540
				6544	6596	6682	6690	6785	6807	6839	6889	6891	6913	7111	7113
				7114	7119	7123	7224	7338	7373	7452	7458	7465	7732	7989	7999
				8355	8454	8622	8680	8734	8770	8840	8845
	RETURN []		2127 #	2493	2494	3595	3599	4063	4066	4269	4312	4320	4330	4338
				4532	4554	4555	4557	4641	4668	4770	4772	4776	4811	4844	4863
				4931	5145	5282	5283	5565	5567	5568	5657	5852	5859	5860	5875
				6264	6274	6279	6282	6320	6321	6471	6477	6648	6671	6736	6767
				6779	6810	6826	6843	6852	6854	6880	6915	6948	6954	6959	6999
				7267	7334	7358	7433	7477	7585	7588	7660	7667	7673	7730	7738
				7742	7745	7771	7783	7785	7787	7789	7791	7793	7795	7797	7799
				7801	7992	7996	8030	8632	8654	8659	8665	8696	8699	8700	8713
				8722	8725	8726	8830	8918
	ROT			2000 #	3043	3048
	ROTC			2003 #	3179	3183
	SCAD DISP		2126 #	4731	4736	4750	4826	5322	5465	5467	6020	6022	6073	6883
				6925	7757
	SC_-1			1943 #
	SC_-2			1944 #
	SC_-SHIFT		1907 #
	SC_-SHIFT-1		1908 #	3104	3176
	SC_-SHIFT-2		1909 #
	SC_0			1942 #	6689	6700
	SC_1			1941 #
	SC_11.			1932 #
	SC_14.			1931 #
	SC_19.			1930 #	2211
	SC_2			1940 #	6510
	SC_20.			1929 #	6333
	SC_22.			1928 #
	SC_24.			1927 #
	SC_26.			1926 #	5756
	SC_27.			1925 #	5360	5407
	SC_28.			1924 #
	SC_3			1939 #	4993
	SC_34.			1923 #	4376	4473	4481	5004	5017	5033
	SC_35.			1922 #	4158	4186	4223	4243	4263	5078	5678	5682	5695	5701	5757
	SC_36.			1921 #
	SC_4			1938 #
	SC_5			1937 #	7664	7696
	SC_6			1936 #	5441	5667	6503	7215	7246	7256	7262
	SC_7			1935 #	6501	7194	8342	8393	8441	8581
	SC_8.			1934 #
	SC_9.			1933 #	4977	5093
	SC_EXP			1914 #	2433	2448	5326	5598
	SC_FE			1917 #	2464	5685
	SC_FE+S#		1916 #	3130	5467
	SC_S#			1918 #	2211	4158	4186	4223	4243	4263	4376	4473	4481	4977	4993
				5004	5017	5033	5078	5093	5360	5407	5441	5667	5678	5682	5695
				5701	5756	5757	6333	6501	6503	6510	6689	6700	7194	7215	7246
				7256	7262	7476	7664	7696	7750	7766	8342	8393	8441	8581
	SC_S#-FE		1915 #	3133	5469
	SC_SC-1			1903 #	7757
	SC_SC-EXP		1910 #
	SC_SC-EXP-1		1911 #	5322	5588
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 291
; 								Cross Reference Listing					

	SC_SC-FE		1913 #
	SC_SC-FE-1		1912 #	5327	5608
	SC_SHIFT		1904 #	3121	5449
	SC_SHIFT-1		1905 #	2414
	SC_SHIFT-2		1906 #
	SET APR ENABLES		2034 #	2202	7115	7224
	SET AROV		2043 #	4171	4172	4196	4258	5466
	SET FL NO DIVIDE	2046 #	5389	5401	5754
	SET FOV			2044 #
	SET FPD			2049 #	4271	4785	6428
	SET HALT		2029 #	7918	7984
	SET NO DIVIDE		2045 #	4378	4413	4444	4530	5037	5389	5401	5754
	SET PDL OV		2052 #	3738	3794	3824	3828
	SET P TO 36-S		4712 #	4771	6082	6885	6927
	SET TRAP1		2053 #
	SHIFT			1901 #	3009	3021	3043	3048	5282	5283
	SKIP AC REF		2097 #
	SKIP AD.EQ.0		2081 #	3053	3368	3380	3471	3483	4161	4166	4368	4370	4374	4388
				4433	4462	4492	4573	4651	4656	4661	4677	4684	5002	5031	5385
				5411	5413	5486	5528	5552	5708	5759	5801	5846	6176	6229	6305
				6308	6597	6634	6655	6778	7365	8369	8372	8456	8459
	SKIP AD.LE.0		2082 #	3371	3383	3474	3486	4427	5061	5405	5729	6376	7331	7988
	SKIP ADL.EQ.0		2093 #	2224	4026	4031	5428	5433	5547	5712	5715	5783	5786	5789
				5792	5852	5952	5995	6134	6136	6218	6238	6422	6438	6492	6527
				6530	6562	7026	7162	7176	7222	7231	7526	7527	7718	7720	7734
				8329	8351	8395	8402	8405	8420	8425	8474	8493	8497	8503	8517
				8521	8523	8543	8596	8615	8617	8655	8660	8682	8685	8687	8690
				8693	8714	8724	8778	8796	8837	8886
	SKIP ADL.LE.0		2084 #	7727
	SKIP ADR.EQ.0		2094 #	3122	3628	3643	5159	6363	6436	6791	7068	7074	7101	7103
				7106	7108	7110	7401	7403	7407	7409	7411	7413	7415	7417	7514
				7567	7587	7659	7686	8269	8548	8576	8765	8782	8785	8790
	SKIP CRY0		2089 #	3721	3764	3793	5397	5521	5523	5525	5527
	SKIP CRY1		2090 #	4124	4136	5837	6253	6259	6272	6463	6474
	SKIP CRY2		2091 #	5810	5870
	SKIP DP0		2079 #	2434	2449	2608	2786	2793	3076	3148	3365	3377	3468	3480
				3810	3813	3818	3989	4143	4168	4190	4193	4248	4256	4357	4393
				4395	4400	4405	4409	4431	4448	4460	4467	4482	4501	4519	4571
				4578	4593	5034	5178	5202	5288	5324	5328	5357	5387	5395	5429
				5451	5482	5589	5691	5738	5742	5753	5766	6003	6016	6033	6046
				6053	6071	6113	6115	6137	6154	6157	6163	6203	6295	6300	6337
				6346	6379	6396	6468	6518	6544	6735	6765	6807	6861	6980	7156
				7320	8356	8454	8681	8735
	SKIP DP18		2080 #	2413	2772	2779	5976	6223	6427	6516	6839	6840	7553	8738
				8748	8771
	SKIP EXECUTE		2098 #	7922
	SKIP FPD		2086 #	4210	4731	4736	4750	6327
	SKIP IF AC0		2078 #	2520	3424	4728
	SKIP IO LEGAL		2088 #	2470	3573	3576
	SKIP IRPT		2095 #	5182	6073	8293	8488	8710	8818	8849	8900
	SKIP JFCL		2092 #	3635
	SKIP KERNEL		2087 #	3566	3570	3571	3578	3687	7005
	SKIP NO CST		8074 #	8438	8567	8651
	SKIP -1MS		2096 #	6068
	SKIP-COMP DISP		2114 #	3406	3425	3426	6152
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 292
; 								Cross Reference Listing					

	SPEC MEM READ		1848 #	2446
	SPEC MEM WRITE		1849 #
	START NO TEST WRITE	1841 #	8663
	START READ		1839 #	2264	2265	2267	2268	2287	2327	2333	2338	2344	2367	2371
				2400	2441	2452	2455	2466	3056	3362	3374	3489	3490	3493	3494
				3561	3562	3563	3568	3572	3575	3588	3602	3605	3630	3652	3672
				3745	3755	3789	3882	4039	4083	4257	4732	4741	4789	4793	4797
				4801	5134	5209	5292	5967	5968	5992	6139	6389	6416	6489	6494
				6550	6670	6786	6932	6933	6934	6935	7010	7018	7153	7289	7293
				7297	7301	7305	7345	7349	7385	7421	7574	7692	7715	7736	7893
				7928	8387	8467	8708	8743	8757
	START WRITE		1840 #	2625	2821	2827	3441	3666	3669	3677	3718	3768	3773	3851
				3864	4018	4065	4075	4769	4775	4930	5162	5170	5186	5191	5285
				6582	6628	7257	7374	7378	7439	7539	7901	7916	8002	8009	8012
				8015	8018	8021	8918
	STATE_[]		2070 #	5145	6011	6037	6040	6062	6110	6116	6124	6155	6162	6181
				6209	6391	6418	6542	6599	6603	6663	8270	8855	8857	8859	8861
				8863	8865	8869
	STEP SC			1900 #	2221	3025	3027	3103	3105	3107	3111	3137	3144	3175	3177
				3179	3183	4289	4301	4307	4315	4325	4333	4588	4591	4631	4980
				4999	5099	5336	5338	5444	5468	5471	5474	5478	5642	5645	5652
				5670	6362	6506	6512	6707	7197	7217	7248	7265	7456	7469	7671
				7702	7770	8345	8407	8410	8444	8587
	SWEEP			2026 #	7464	7465	7468
	TAKE INTERRUPT		2121 #	8877
	TEST DISP		2113 #	3307	3313	7602
	TL []			1748 #	4026	4031	5547	5712	5715	5783	5786	5789	5792	5852	5952
				5995	6134	6136	6218	6238	6422	6438	6492	6527	6530	7718	7720
				7734	8329	8351	8395	8402	8405	8420	8425	8474	8493	8497	8503
				8517	8521	8523	8543	8596	8615	8617	8655	8660	8682	8685	8687
				8690	8693	8714	8724	8778	8796	8837	8886
	TR []			1747 #	3628	3643	6363	6436	6791	7101	7103	7106	7108	7110	7401
				7403	7407	7409	7411	7413	7415	7417	7659	7686	8269	8548	8576
				8765	8782	8785	8790
	TURN OFF PXCT		2023 #	2276	2279	2282	2294	2297	2300	2314
	TXXX TEST		2099 #	3321
	UNHALT			2033 #	7921
	UPDATE USER		2056 #	3594	3598	3656
	UUO			2118 #	2471	3565	3574	3577	3579	3580	3581	3614	3619	3622	3642
				3663	3676	3958	3960	3962	3964	3966	3968	3970	3972	6947	7030
				7039	7040	7041	7045	7046	7047	7048	7053	7054	7055	7058	7059
				7060	7061	7062	7063	7064	7065	7286	7309	7404	7863	7872	7874
				7876	7878	7880	7882
	VMA			1888 #
	VMA EXTENDED		1826 #
	VMA PHYSICAL		1823 #	3994	4004	4018	4038	4065	7011	7019	7523	7565	7913	7916
				7999	8002	8009	8012	8015	8018	8021	8374	8382	8388	8468	8709
				8742	8758	8879	8915	8918
	VMA PHYSICAL READ	1825 #	7523	7565	8374	8382	8915
	VMA PHYSICAL WRITE	1824 #	3994	4004	7913	7999	8879
	VMA_[]			1868 #	2264	2268	2286	2343	2370	2379	2466	2824	3362	3489	3494
				3568	3604	3666	3677	3766	3771	3850	3881	4257	4732	4741	4792
				4800	5133	5161	5169	5285	5968	6494	6550	6628	6670	6933	6935
				7152	7257	7421	7439	7445	7523	7692	7736	7892	7900	7927	8028
				8386	8610	8626	8707	8878
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 293
; 								Cross Reference Listing					

	VMA_[] WITH FLAGS	1869 #	7795
	VMA_[]+1		1871 #	2265	2267	2312	2399	3374	3668	4081	5183	5188	5206	5291
				6139	6489	7348	7378
	VMA_[]+XR		1873 #	4788	4796	6932	6934
	VMA_[]+[]		1874 #	8373	8381	8466
	VMA_[]-1		1872 #	3563	3572	3575	7714
	VMA_[].OR.[] WITH FL	1870 #	7654	7689
	WORK[]			1889 #	6171	6393	6592	6659	6737	6768	6771
	WORK[]_.NOT.[]		1799 #	6213
	WORK[]_0		1794 #	2213	7472	7473
	WORK[]_1		1795 #	2212
	WORK[]_Q		1792 #	5011	6143	6182
	WORK[]_[]		1796 #	2196	2204	2206	2207	4729	4988	5001	5021	5053	5961	5974
				5977	6007	6069	6095	6096	6097	6112	6159	6195	6334	6336	6398
				6411	6417	6616	6764	6953	7004	7116	7225	7291	7295	7299	7303
				7307	7322	7333	7354	7357	7387	7388	7755	7761	7763	7908	7980
				7995	8005	8267	8288	8289	8291	8292	8299	8309	8311	8313	8315
				8319	8320	8461	8463	8484	8809
	WORK[]_[] CLR LH	1797 #	3699	7721
	WORK[]_[]-1		1798 #	6392
	WORK[]_[].AND.[]	1800 #	6024
	WRITE TEST		1838 #	2625	2821	2827	3441	3666	3669	3677	3718	3768	3773	3851
				3864	4018	4065	4075	4769	4775	4930	5162	5170	5186	5191	5285
				6582	6628	7257	7289	7293	7297	7301	7305	7374	7378	7439	7539
				7901	7916	8002	8009	8012	8015	8018	8021	8918
	XR			1887 #
	[] LEFT_-1		1689 #	2776
	[] LEFT_0		1687 #	2774
	[] RIGHT_-1		1690 #	2797
	[] RIGHT_0		1688 #	2795
	[]+[]			1554 #	2819	4268	4408
	[]-#			1556 #	6222	6515	8736	8746
	[]-[]			1555 #	4404	4460	4461	5158	5176	5200	5288	5397	5405	5753	6137
	[].AND.#		1557 #	5428	5432	6561	7024	7174	7222	7231
	[].AND.NOT.WORK[]	1801 #
	[].AND.NOT.[]		1560 #	4165
	[].AND.Q		1558 #	4432
	[].AND.WORK[]		1802 #	6777
	[].AND.[]		1559 #	4193	7068	7074	7587
	[].OR.[]		1561 #
	[].XOR.#		1562 #	2224	7526	7527
	[].XOR.[]		1563 #	7364
	[]_#			1565 #	2185	2189	2214	2215	2255	2781	2783	2788	2790	4577	4985
				5008	5018	5022	5051	5094	5145	5979	6011	6037	6040	6062	6110
				6116	6124	6155	6162	6181	6209	6391	6418	6542	6599	6603	6663
				7080	7082	7448	7450	7461	7463	7542	7584	8270	8855	8857	8859
				8861	8863	8865	8869
	[]_#-[]			1564 #
	[]_(#-[])*2		1651 #	5089
	[]_(-[])*.5		1652 #
	[]_(-[]-.25)*.5 LONG	1653 #	4438	5747
	[]_(-[]-.25)*2 LONG	1654 #	4515
	[]_(AC[].AND.[])*.5	1649 #	4214	4216	5586	5677	5732
	[]_(MEM.AND.[])*.5	1863 #	2460
	[]_(Q+1)*.5		1650 #	5869
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 294
; 								Cross Reference Listing					

	[]_([]+#)*2		1664 #
	[]_([]+1)*2		1665 #	6681
	[]_([]+[])*.5 LONG	1666 #	5616
	[]_([]+[])*2 LONG	1667 #	4622
	[]_([]+[]+.25)*.5 LO	1670 #
	[]_([]-[])*.5 LONG	1668 #
	[]_([]-[])*2 LONG	1669 #	4619
	[]_([].AND.#)*.5	1656 #	4982	4989	7568
	[]_([].AND.#)*2		1657 #
	[]_([].AND.NOT.#)*.5	1658 #
	[]_([].AND.NOT.#)*2	1659 #
	[]_([].AND.[])*.5	1660 #	4208
	[]_([].AND.[])*2	1661 #
	[]_([].OR.#)*.5		1662 #
	[]_([].OR.#)*2		1663 #
	[]_+SIGN		1693 #	2458	2493	5329	5333	5358	5391	5452
	[]_+SIGN*.5		1698 #	5590	5692	5743
	[]_-1			1566 #	4360	6428	7430
	[]_-2			1567 #
	[]_-AC			1582 #	4664
	[]_-AC[]		1583 #	6307
	[]_-Q			1568 #
	[]_-Q*.5		1570 #	5416
	[]_-Q*2			1569 #	4488
	[]_-SIGN		1694 #	2456	2494	5330	5334	5359	5392	5453
	[]_-SIGN*.5		1699 #	5592	5693	5745
	[]_-WORK[]		1809 #	6035	6978	6992
	[]_-[]			1571 #	2613	2983	4557	4575	4582	4676	4680	4684	4686	5319	5394
				5429	5538	5554	5583	5735	5815	5836	6304
	[]_-[]*2		1573 #	5398
	[]_-[]-.25		1572 #	5584
	[]_.NOT.AC[]		1575 #	6306
	[]_.NOT.AC		1574 #	2932	2942	4663
	[]_.NOT.Q		1576 #	4948	6023
	[]_.NOT.WORK[]		1808 #	6052	6080	6084	6220	6224	6996
	[]_.NOT.[]		1577 #	2875	2912	2953	2963	3324	4130	4574	4678	4685	5488	5536
				5551	5553	5734	5744	5813	6004	6006	6558	7717	8723
	[]_0			1578 #	2197	2199	2202	2211	2230	2252	2436	2840	3307	4009	4262
				4358	4572	4852	4994	5137	5179	5203	5289	5555	5728	5795	5811
				5839	6056	6128	6140	6151	6180	6301	6339	6373	6429	6433	6437
				6440	6495	6767	7192	7204	7250	7327	7402	7447	7515	7744	7789
				7913	8592	8654	8849	8867	8868	8899
	[]_0 XWD []		1580 #	2191	2194	2238	2274	2278	2281	2293	2296	2299	3982	4022
				4070	4434	4445	5919	5921	5923	5925	5927	5929	5931	5933	5935
				6631	7318	7497	7498	7499	7500	7501	7502	7503
	[]_0*.5 LONG		1579 #	4288
	[]_AC[]			1597 #	2217	2407	2817	5994	6012	6015	6045	6061	6133	6153	6185
				6200	6228	6231	6233	6250	6291	6293	6294	6326	6332	6359	6371
				6406	6549	6590	6627	6629	6733	6846	6853	6879	6881	6908	6965
				6973	6979
	[]_AC[]*.5		1599 #	4228
	[]_AC[]*2		1598 #	6240
	[]_AC[]-1		1594 #	6400	6419
	[]_AC[]-[]		1593 #	4135
	[]_AC[].AND.[]		1595 #
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 295
; 								Cross Reference Listing					

	[]_AC			1581 #	2393	2406	2624	2725	2727	2758	2764	3001	3018	3509	3753
				3786	3808	3866	3879	4186	4365	4756	5152	5240	5322	5355	5387
				5451	5597	5997	6135	6197	6331	6333	6354	6491	7616	7903
	[]_AC*.5		1584 #	3024	3036	3039	4233	4448	5587	5689	5740
	[]_AC*.5 LONG		1585 #	2420	3126
	[]_AC*2			1586 #	4752
	[]_AC+1			1587 #	3523
	[]_AC+1000001		1588 #	3545	3715
	[]_AC+[]		1589 #	5143
	[]_AC-1			1590 #	3537
	[]_AC-[]		1591 #	3406	4110	4140
	[]_AC-[]-.25		1592 #	4137
	[]_AC.AND.MASK		1596 #	3004	3052
	[]_APR			1600 #	7042	7043	7105	7137	7336
	[]_CURRENT AC []	1601 #
	[]_EA			1604 #	2356
	[]_EA FROM []		1602 #	5965
	[]_EXP			1605 #	5529	5545	5875
	[]_FE			1606 #	3077	6694
	[]_FLAGS		1607 #	3664	3678	3999	4025	7528	8889
	[]_IO DATA		1858 #	7513	7561	7657	8301
	[]_MEM			1859 #	2305	2375	2389	2398	2402	2430	2447	3585	3609	3624	3649
				3653	3714	3759	3795	3884	4041	4804	5951	5970	6390	6633	6661
				6937	6952	7022	7155	7290	7294	7298	7302	7306	7347	7386	7524
				7566	7737	7782	7785	7896	7935	8390	8472	8712	8764
	[]_MEM THEN FETCH	1860 #	2441
	[]_MEM*.5		1861 #
	[]_MEM.AND.MASK		1862 #	4810
	[]_P			1608 #	6564	6710
	[]_PC WITH FLAGS	1609 #	3725	3842	3848	4054	4255	7003	7540	8893
	[]_Q			1610 #	4163	4171	4391	4446	4463	4469	4478	5646	5653	5673	5696
				5755	5757
	[]_Q*.5			1611 #	4226	5410	5415	5685
	[]_Q*2			1612 #
	[]_Q*2 LONG		1613 #	4474	4484
	[]_Q+1			1614 #	5140
	[]_RAM			1615 #
	[]_TIME			1616 #	7361	7362	7363
	[]_VMA			1617 #	7751	7994	8264	8290	8810
	[]_VMA FLAGS		1879 #	7509	7556	7648	7651	7687	7698	7704	7930
	[]_VMA IO READ		1880 #	7509	7556	7648	7651	7930
	[]_VMA IO WRITE		1881 #	7687	7698	7704
	[]_WORK[]		1807 #	5006	5016	5215	6099	6100	6101	6102	6166	6377	6387	6420
				6421	6442	6618	6654	6731	6851	6862	6969	7094	7128	7220	7277
				7279	7281	7283	7285	7315	7324	7329	7335	7367	7371	7392	7724
				7729	7982	7987	7991	8006	8024	8026	8027	8029	8268	8368	8371
				8455	8458	8536	8538	8583	8623	8624	8625	8631	8820	8826	8835
				8839	8851
	[]_WORK[]+1		1810 #	6031	6064	6119	6217	6395	6858	6864
	[]_XR			1618 #	7727
	[]_[]			1619 #	2331	3055	3490	3493	3561	3562	3588	3615	3630	3689	3743
				3863	3868	4157	4185	4209	4225	4355	4364	4379	4385	4414	4769
				5077	5325	5326	5327	5365	5385	5393	5602	5603	5610	5611	5684
				5726	5729	5771	5772	6013	6033	6079	6114	6374	6385	6393	6460
				6560	6793	6884	6907	6926	6983	7049	7050	7230	7267	7366	7398
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 296
; 								Cross Reference Listing					

				7544	7626	7628	7635	7660	8341	8429	8580	8604	8901
	[]_[] SWAP		1620 #	2425	2605	2752	2754	2757	2760	2763	2766	3305	3310	3629
				3806	3865	3880	3998	4850	4976	4992	5092	5132	5141	5214	6439
				6496	6501	6502	6796	7129	7406	7419	7429	8482	8773
	[]_[] XWD 0		1621 #	6194	6309	7777	8305	8307	8321
	[]_[]*.5		1622 #	2188	2462	2463	3020	3041	3042	3046	3129	3132	4207	4264
				4426	4454	4585	4586	4587	4593	4854	4930	4979	4998	5400	5408
				5475	5524	5526	5542	5543	5562	5563	5568	5678	5711	5880	6503
				6506	6510	6512	6592	6700	6707	6770	7246	7248	7256	7262	7265
				7571	7589	7664	7670	8344	8360
	[]_[]*.5 LONG		1623 #	2421	3107	3135	3179	4159	4187	4266	4287	4300	4428	4430
				4442	4458	4473	4480	4532	4580	5080	5247	5267	5268	5269	5283
				5338	5361	5366	5441	5443	5473	5641	5644	5652	5655	5657	5671
				5706	5761	5787	5790	5824	5826	5872
	[]_[]*2			1624 #	2186	3008	3031	3044	3047	3074	4162	4189	4245	5098	5282
				5395	5403	5478	6241	6787	7196	7215	7217	7516	7552	7696	7702
				7793	8406	8409	8443	8586
	[]_[]*2 LONG		1625 #	3027	3108	3111	3112	3113	3138	3142	3145	3180	3183	3184
				4512	4592	4595	4597	4943	5262	5263	5520	5532	5540	5544	5618
				5623	5625	5637	5639	5640	5669	5710	5714	5763	5780	5802	5819
				5847
	[]_[]*4			1626 #	6497
	[]_[]+#			1627 #	3761	3790	6456	6465	7517	7562	8376	8384	8750	8760	8874
	[]_[]+.25		1628 #	5876
	[]_[]+0			1629 #
	[]_[]+1			1630 #	2216	2220	2450	2453	3440	3650	3671	4775	5181	5205	5290
				5487	5990	6091	6109	6138	6281	6349	6361	6368	6388	6409	6423
				6478	6541	6565	6659	6886	6928	7325	7791	8853	8914
	[]_[]+1000001		1631 #	3854	3871	5155
	[]_[]+AC		1632 #	4096	4126
	[]_[]+AC[]		1633 #	4123	6242	6252	6255
	[]_[]+Q			1634 #	4486
	[]_[]+RAM		1635 #	6472	6474
	[]_[]+WORK[]		1803 #	5074	6413	6593	6669	6776	6784	7368	7741	7743	8398	8400
				8477	8652
	[]_[]+XR		1636 #	2325	2337	2352	2365	3600	5964	5967	7735
	[]_[]+[]		1637 #	3984	4024	4239	4505	4508	4596	5339	5483	5566	5697	6054
				6086	6258	6269	6271	6708	6990	7006	7014	7319	7519	7554	7564
				7572	8740	8755
	[]_[]+[]+.25		1638 #
	[]_[]-#			1639 #
	[]_[]-1			1640 #	3456	6070	6174	6175	6286	6427	6464	6857	8843	8903
	[]_[]-1000001		1641 #
	[]_[]-AC		1642 #
	[]_[]-RAM		1643 #	6462	6467
	[]_[]-WORK[]		1812 #
	[]_[]-[]		1644 #	6049	6375	6986	7330	7454	7467
	[]_[]-[] REV		1645 #	6173
	[]_[].AND.AC		1671 #	2850	2973	3312	3335	7602
	[]_[].AND.NOT.#		1672 #	3657	4061	5860	6444	6812	6828	7095	7121	7233	7414	8555
				8605	8780
	[]_[].AND.NOT.AC	1674 #	2860	7632
	[]_[].AND.NOT.WORK[]	1805 #
	[]_[].AND.NOT.[]	1673 #	5621	7104	7107	7408	7418	7588
	[]_[].AND.Q		1675 #	4191	4863	4950
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 297
; 								Cross Reference Listing					

	[]_[].AND.WORK[]	1804 #	6172	8658
	[]_[].AND.[]		1676 #	4949	5548	5830	5832	6170	7431	8678
	[]_[].AND.#		1646 #	2458	2471	2493	3565	3574	3577	3579	3580	3581	3614	3619
				3622	3642	3663	3676	3958	3960	3962	3964	3966	3968	3970	3972
				3978	4076	4144	5101	5329	5333	5358	5391	5452	6205	6328	6504
				6507	6546	6677	6711	6714	6947	6957	7030	7039	7040	7041	7045
				7046	7047	7048	7053	7054	7055	7058	7059	7060	7061	7062	7063
				7064	7065	7097	7099	7131	7134	7159	7166	7170	7181	7200	7221
				7249	7255	7261	7266	7286	7309	7351	7404	7405	7666	7672	7863
				7872	7874	7876	7878	7880	7882	8265	8333	8489	8589	8599	8812
	[]_[].AND.# CLR LH	1647 #	3078	6619	6657	6697	6842	7067	7070	7138	7505	8347	8426
				8486	8504	8612
	[]_[].AND.# CLR RH	1648 #	5264	5954	5998	6198
	[]_[].EQV.AC		1677 #	2922
	[]_[].EQV.Q		1678 #	4169	4172	4194	4195
	[]_[].OR.#		1679 #	2187	2456	2494	4028	4033	4145	4498	4583	5330	5334	5359
				5392	5453	5648	5649	5656	5859	6210	6297	6341	6350	6355	6365
				6636	6640	6642	6703	6816	6820	6824	6832	6848	7223	7232	7337
				7412	7490	7491	7492	7493	7494	7495	7496	7931	8261	8326	8330
				8515	8518	8544	8551	8593	8597	8614	8616	8620	8676	8783	8787
				8792	8799	8804	8877
	[]_[].OR.AC		1680 #	2902	3330	7630
	[]_[].OR.FLAGS		1681 #
	[]_[].OR.WORK[]		1806 #	6984	6993	8431	8526
	[]_[].OR.[]		1682 #	2943	4131	4951	5956	6055	6285	6716	7098	7102	7109	7140
				7185	7207	7209	7410	7416	7558	8601	8815
	[]_[].XOR.AC		1684 #	2892	3327
	[]_[].XOR.[]		1685 #	5834
	[]_[].XOR.#		1683 #	4452	8339
	.NOT.[]			1553 #	4369	7432	7507
	2T			1891 #	4448	4461	5328	5598	6172	6242	6306	6594	6731	6776	7371
				7728
	3T			1892 #	2224	2449	2459	2614	3147	3321	3406	3440	3456	3546	3636
				3720	3755	3763	3788	3792	3809	3814	3819	3856	3872	4097	4111
				4214	4216	4235	4269	4406	4410	4460	4466	4467	4468	4485	4489
				4510	4518	4599	4664	4681	4739	4754	4825	4843	4939	4983	4990
				5070	5086	5090	5156	5158	5177	5201	5288	5322	5356	5397	5428
				5429	5432	5464	5467	5521	5523	5525	5527	5586	5587	5590	5592
				5691	5692	5693	5737	5741	5743	5745	5753	5836	5842	6002	6020
				6022	6070	6074	6137	6244	6258	6272	6304	6307	6392	6395	6427
				6428	6456	6462	6465	6474	6499	6513	6540	6560	6561	6683	6690
				6734	6793	6883	6890	6911	6925	6929	6932	6934	6970	7025	7155
				7162	7175	7222	7231	7488	7513	7517	7525	7526	7527	7562	7566
				7568	7735	8376	8384	8610	8627	8750	8761	8845	8875
	4T			1893 #	3052	3523	3537	4123	4128	4135	4138	4140	5030	5035	6016
				6046	6223	6228	6253	6294	6467	6515	6655	6778	6979	7988	8296
				8369	8372	8456	8459	8738	8748
	5T			1894 #	7289	7293	7297	7301	7305	7757	7774
	7-BIT DPB		4920 #	4924	4925	4926	4927	4928
	7-BIT LDB		4822 #	4830	4831	4832	4833	4834
(D) MACRO%
	AC			2160 #	2583	2584	2588	2589	2593	2594	2598	2599	2620	2636	2637
				2641	2642	2646	2647	2651	2652	2656	2657	2661	2662	2666	2667
				2671	2672	2678	2679	2683	2684	2688	2689	2693	2694	2698	2699
				2703	2704	2708	2709	2713	2714	2803	2833	2834	2843	2844	2853
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 298
; 								Cross Reference Listing					

				2854	2863	2864	2868	2869	2885	2886	2895	2896	2905	2906	2915
				2916	2925	2926	2935	2936	2946	2947	2956	2957	2966	2967	2976
				2977	4089	4090	4103	4104	4151	4152	4721	8257
	AC DISP			2174 #	3552	7035	7036	7272
	B			2162 #	2836	2846	2856	2866	2871	2888	2898	2908	2918	2928	2938
				2949	2959	2969	2979	4092	4106	4154
	DAC			2164 #	2802	4118	4119	4176	4177	4202	4343	4344	4348	4349	4420
				5662	5723
	DBL AC			2149 #	2811
	DBL B			2165 #	4179	4346	4351
	DBL FL-R		2155 #	5573	5574	5662	5723
	DBL R			2148 #	2802	2803	4118	4119	4202	4420
	FL-AC			2166 #	5299	5302	5303	5307	5310	5311	5344	5348	5349	5373	5377
				5378	5423	5424	5458	5459
	FL-BOTH			2168 #	5301	5305	5309	5313	5346	5351	5375	5380
	FL-I			2154 #	5303	5311	5349	5378
	FL-MEM			2167 #	5300	5304	5308	5312	5345	5350	5374	5379
	FL-R			2152 #	5299	5302	5307	5310	5344	5348	5373	5377	5458	5459
	FL-RW			2153 #	5300	5301	5304	5305	5308	5309	5312	5313	5345	5346	5350
				5351	5374	5375	5379	5380
	I			2140 #	2879	2991	3211	3212	3213	3214	3215	3216	3217	3218	3220
				3221	3229	3230	3231	3232	3233	3234	3235	3236	3247	3248	3249
				3250	3251	3252	3253	3254	3264	3265	3266	3267	3268	3269	3270
				3271	3386	3387	3388	3389	3390	3391	3392	3393	3498	3499	3500
				3501	3502	3503	3504	3505	3513	3514	3515	3516	3517	3518	3519
				3527	3528	3529	3530	3531	3532	3533	3540	3541	3552	3554	3705
				3707	3708	3835	3836	3837	3838	3891	3892	3893	3894	3895	3896
				3897	3898	3902	3903	3904	3905	3906	3907	3908	3909	3910	3911
				3912	3913	3914	3915	3916	3917	3918	3919	3920	3921	3922	3923
				3924	3925	3926	3927	3928	3929	3930	3931	3932	3933	3937	3938
				3939	3940	3944	3945	3946	3947	3948	3949	3950	3951	3952	3953
				3954	5148	5424	5888	5889	5890	5891	5892	5893	5894	5896	5897
				5898	5899	5901	5902	5903	5904	5906	5907	5908	5909	5910	5911
				5912	5913	5947	7806	7807	7808	7810	7811	7813	7814	7816	7817
				7818	7819	7820	7821	7822	7823	7825	7826	7827	7828	7829	7830
				7831	7832	7834	7835	7836	7837	7838	7839	7840	7841	7843	7844
				7845	7846	7847	7848	7849	7850	7852	7853	7854	7855	7856	7857
				7858	7859
	I-PF			2141 #	2584	2589	2594	2599	2637	2642	2647	2652	2657	2662	2667
				2672	2679	2684	2689	2694	2699	2704	2709	2714	2833	2834	2844
				2854	2864	2869	2886	2896	2906	2916	2925	2926	2936	2947	2957
				2967	2976	2977	2992	3512	3526	3802	4090	4104	4152	4177	4344
				4349
	IOT			2156 #	7035	7036	7272	7594	7595	7596	7597	7605	7606	7607	7608
				7619	7620	7621	7622	7887	7888	8257
	IR			2147 #	3706
	IW			2146 #	2835	2836	2927	2928	2978	2979
	M			2161 #	2585	2590	2595	2600	2638	2643	2648	2653	2658	2663	2668
				2673	2680	2685	2690	2695	2700	2705	2710	2715	2835	2845	2855
				2865	2870	2880	2881	2887	2897	2907	2917	2927	2937	2948	2958
				2968	2978	4091	4105	4153	4178	4345	4350	7272
	R			2142 #	2620	2878	3222	3223	3224	3225	3226	3227	3238	3239	3240
				3241	3242	3243	3244	3245	3256	3257	3258	3259	3260	3261	3262
				3263	3273	3274	3275	3276	3277	3278	3279	3280	3395	3396	3397
				3398	3399	3400	3401	3402	3412	3413	3414	3415	3416	3417	3418
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 299
; 								Cross Reference Listing					

				3419	3683	4721	4722	4723	4724	4725	5423
	R-PF			2143 #	2583	2588	2593	2598	2636	2641	2646	2651	2656	2661	2666
				2671	2678	2683	2688	2693	2698	2703	2708	2713	2843	2853	2863
				2868	2885	2895	2905	2915	2935	2946	2956	2966	4089	4103	4151
				4176	4343	4348
	ROUND			2169 #	5302	5303	5304	5305	5310	5311	5312	5313	5348	5349	5350
				5351	5377	5378	5379	5380	5423	5459
	RW			2145 #	2586	2591	2596	2601	2638	2639	2643	2644	2649	2654	2659
				2664	2669	2674	2680	2681	2685	2686	2691	2696	2701	2706	2711
				2716	2845	2846	2855	2856	2865	2866	2870	2871	2887	2888	2897
				2898	2907	2908	2917	2918	2937	2938	2948	2949	2958	2959	2968
				2969	3429	3430	3431	3432	3433	3434	3435	3436	3445	3446	3447
				3448	3449	3450	3451	3452	4091	4092	4105	4106	4153	4154	4178
				4179	4345	4346	4350	4351
	S			2163 #	2586	2591	2596	2601	2639	2644	2649	2654	2659	2664	2669
				2674	2681	2686	2691	2696	2701	2706	2711	2716
	SH			2150 #	2988	2989	2990
	SHC			2151 #	2993	2994
	SJC-			3346 #	3386	3395	3412	3429	3445	3498	3512	3526
	SJCA			3350 #	3390	3399	3416	3433	3449	3502	3516	3530
	SJCE			3348 #	3388	3397	3414	3431	3447	3500	3514	3528	5889
	SJCG			3353 #	3393	3402	3419	3436	3452	3505	3519	3533	5894
	SJCGE			3351 #	3391	3400	3417	3434	3450	3503	3517	3531	3540	5892
	SJCL			3347 #	3387	3396	3413	3430	3446	3499	3513	3527	3541	5888
	SJCLE			3349 #	3389	3398	3415	3432	3448	3501	3515	3529	5890
	SJCN			3352 #	3392	3401	3418	3435	3451	3504	3518	3532	5893
	TC-			3202 #	3247	3248	3256	3257
	TCA			3204 #	3251	3252	3260	3261
	TCE			3203 #	3249	3250	3258	3259
	TCN			3205 #	3253	3254	3262	3263
	TN-			3192 #
	TNA			3195 #	3215	3216	3224	3225
	TNE			3193 #	3213	3214	3222	3223	7596
	TNN			3196 #	3217	3218	3226	3227	7597
	TO-			3206 #	3264	3265	3273	3274
	TOA			3208 #	3268	3269	3277	3278
	TOE			3207 #	3266	3267	3275	3276
	TON			3209 #	3270	3271	3279	3280
	TZ-			3198 #	3229	3230	3238	3239
	TZA			3200 #	3233	3234	3242	3243
	TZE			3199 #	3231	3232	3240	3241
	TZN			3201 #	3235	3236	3244	3245
	W			2144 #	2585	2590	2595	2600	2648	2653	2658	2663	2668	2673	2690
				2695	2700	2705	2710	2715	2812	2880	2881
	W TEST			2173 #	2620	4722	4724
	WORD-TNE		3194 #	7594
	WORD-TNN		3197 #	7595
(U) MEM				990 #	2197	2216	2220	2264	2264	2264	2265	2265	2267	2267	2268
				2268	2268	2286	2287	2304	2312	2327	2327	2333	2333	2338	2339
				2343	2344	2357	2366	2367	2370	2371	2375	2379	2388	2397	2399
				2400	2401	2429	2440	2441	2441	2451	2452	2454	2455	2459	2466
				2466	2530	2562	2568	2573	2576	2605	2611	2625	2626	2725	2727
				2760	2766	2774	2776	2795	2797	2820	2821	2823	2824	2825	2827
				2840	2850	2860	2892	2902	2922	2932	2943	2953	2983	3056	3056
				3362	3362	3362	3374	3374	3441	3442	3489	3489	3489	3490	3490
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 300
; 								Cross Reference Listing					

				3493	3493	3494	3494	3494	3561	3561	3562	3562	3563	3563	3568
				3568	3572	3572	3575	3575	3584	3588	3588	3601	3602	3604	3605
				3608	3623	3630	3630	3645	3649	3651	3652	3653	3666	3666	3668
				3668	3669	3672	3677	3677	3713	3717	3718	3730	3736	3744	3745
				3754	3755	3758	3766	3768	3771	3773	3775	3781	3787	3789	3795
				3850	3851	3852	3864	3881	3882	3883	3993	3994	3994	3994	4003
				4004	4004	4004	4005	4007	4013	4018	4018	4018	4037	4038	4039
				4040	4052	4056	4065	4065	4065	4074	4075	4079	4081	4082	4083
				4097	4111	4163	4169	4192	4194	4257	4257	4257	4732	4732	4732
				4741	4741	4769	4775	4776	4788	4789	4792	4793	4796	4797	4800
				4801	4803	4809	4930	4931	5133	5134	5161	5162	5169	5170	5172
				5183	5184	5186	5188	5189	5191	5195	5198	5206	5207	5209	5244
				5285	5285	5287	5291	5291	5292	5483	5487	5533	5555	5951	5965
				5967	5967	5968	5968	5970	5991	5992	6139	6139	6388	6389	6390
				6415	6416	6460	6466	6473	6489	6489	6494	6494	6550	6550	6582
				6584	6628	6628	6630	6633	6661	6670	6670	6785	6786	6932	6932
				6933	6933	6934	6934	6935	6935	6937	6951	7007	7010	7011	7015
				7018	7019	7022	7152	7153	7154	7257	7257	7289	7290	7293	7294
				7297	7298	7301	7302	7305	7306	7345	7346	7348	7349	7373	7374
				7377	7378	7378	7378	7379	7385	7386	7421	7421	7421	7439	7439
				7440	7445	7508	7512	7523	7523	7523	7523	7524	7524	7539	7560
				7565	7565	7565	7566	7573	7574	7654	7654	7656	7689	7689	7690
				7692	7692	7692	7714	7715	7736	7736	7737	7782	7785	7787	7795
				7795	7797	7799	7892	7893	7895	7900	7901	7910	7913	7913	7913
				7915	7916	7916	7916	7927	7928	7934	7983	7999	7999	7999	8000
				8001	8002	8002	8002	8003	8004	8007	8008	8009	8009	8009	8010
				8011	8012	8012	8012	8013	8014	8015	8015	8015	8016	8017	8018
				8018	8018	8019	8020	8021	8021	8021	8022	8023	8025	8028	8325
				8373	8374	8374	8374	8381	8382	8382	8382	8386	8387	8388	8389
				8466	8467	8468	8471	8602	8610	8626	8663	8707	8708	8709	8711
				8741	8742	8743	8756	8757	8758	8763	8824	8830	8878	8879	8879
				8879	8880	8894	8902	8909	8911	8915	8915	8915	8918	8918	8918
(U) MICROCODE OPTION(INH@	1270 #
	OPT			1272 #	7083
(U) MICROCODE OPTION(KIP@	1294 #
	OPT			1296 #	7087
(U) MICROCODE OPTION(KLP`	1300 #
	OPT			1302 #	7088
(U) MICROCODE OPTION(NOC`	1276 #
	OPT			1280 #	7084
(U) MICROCODE OPTION(NON	1282 #
	OPT			1286 #	7085
(U) MICROCODE OPTION(UBA 	1288 #
	OPT			1290 #	7086
(U) MICROCODE OPTIONS		1263 #
(U) MICROCODE RELEASE(MA	1310 #
	UCR			1311 #	7075
(U) MICROCODE RELEASE(MI`	1313 #
	UCR			1314 #	7076
(U) MICROCODE VERSION		1307 #
	UCV			1308 #	7089
(D) MODE			1374 #
(U) MULTI PREC			995 #	4439	4491	4506	4509	4516	4630	5584	5617	5737	5748
(U) MULTI SHIFT			997 #	3009	3021	3043	3048	4856	4861	4937	4945	5282	5283
(U) PHYSICAL			1164 #	3994	4004	4018	4038	4065	7011	7019	7451	7452	7455	7464
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 301
; 								Cross Reference Listing					

				7465	7468	7509	7523	7556	7565	7648	7651	7687	7698	7704	7913
				7916	7930	7999	8002	8009	8012	8015	8018	8021	8374	8382	8388
				8468	8709	8742	8758	8879	8915	8918
(U) PI.CLR			1223 #	7401
(U) PI.CO1			1212 #
(U) PI.CO2			1213 #
(U) PI.DIR			1222 #	7407
(U) PI.IP1			1204 #	7584
(U) PI.IP2			1205 #
(U) PI.IP3			1206 #
(U) PI.IP4			1207 #
(U) PI.IP5			1208 #
(U) PI.IP6			1209 #
(U) PI.IP7			1210 #
(U) PI.MBZ			1221 #	7403
(U) PI.ON			1211 #	7412	7414
(U) PI.REQ			1224 #	7409
(U) PI.SC1			1229 #
(U) PI.SC2			1230 #
(U) PI.SC3			1231 #
(U) PI.SC4			1232 #
(U) PI.SC5			1233 #
(U) PI.SC6			1234 #
(U) PI.SC7			1235 #
(U) PI.TCF			1226 #	7417
(U) PI.TCN			1225 #	7415
(U) PI.TSF			1227 #	7413
(U) PI.TSN			1228 #	7411
(U) PI.ZER			1203 #
(U) PXCT			1168 #
	BIS-DST-EA		1174 #	6926	6928	6934	6935	6937
	BIS-SRC-EA		1172 #
	CURRENT			1169 #	2264	2265	2267	2268	2287	2327	2333	2441	2466	3056	3362
				3374	3489	3490	3493	3494	3561	3562	3586	3588	3610	3625	3630
				3745	4257	4732	4741	7421	7692	7733	7928
	D1			1171 #	2357	2399	2451	2454	2822	2826	3767	3772	5163	5171	5185
				5190	5286
	D2			1175 #	3719	3756	3788	4790	4794	5135	5208	5292	6932	6933
	E1			1170 #	2366	2371	2377	3606	3692
	E2			1173 #	4739	4758	4798	4802	4806	5958	5967	5968	5970	6889
(U) RAMADR			707 #
	AC#			708 #	2393	2406	2420	2557	2624	2725	2727	2758	2764	2850	2860
				2892	2902	2922	2932	2942	2973	3001	3004	3018	3024	3036	3039
				3052	3114	3126	3147	3312	3327	3330	3335	3336	3406	3425	3465
				3468	3471	3474	3477	3480	3483	3486	3509	3523	3537	3545	3715
				3746	3748	3753	3786	3808	3811	3816	3844	3866	3879	4096	4110
				4126	4137	4140	4157	4158	4184	4186	4233	4248	4355	4356	4365
				4446	4448	4490	4492	4663	4664	4668	4746	4752	4756	5032	5104
				5143	5152	5153	5217	5240	5242	5322	5355	5385	5387	5450	5451
				5479	5485	5587	5591	5593	5597	5689	5740	5841	5842	5997	6088
				6125	6127	6135	6161	6197	6299	6331	6333	6345	6354	6424	6491
				6645	6718	6970	6994	7602	7613	7616	7630	7632	7801	7903	8271
	AC*#			709 #	2209	2210	2217	2407	2419	2525	2808	2817	3058	3079	3123
				3153	4123	4135	4214	4216	4218	4226	4228	4235	4237	4249	4250
				4251	4252	4253	4254	4366	4450	4472	4476	4479	4493	4494	4496
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 302
; 								Cross Reference Listing					

				4499	4518	4520	4522	4523	4649	4650	4653	4654	4655	4658	4659
				4660	4666	4667	5586	5677	5730	5732	5738	5797	5805	5843	5850
				5994	6002	6012	6015	6045	6048	6061	6068	6075	6085	6123	6133
				6153	6168	6185	6200	6202	6228	6231	6233	6240	6241	6242	6244
				6250	6252	6255	6261	6263	6291	6293	6294	6298	6305	6306	6307
				6311	6312	6319	6321	6326	6332	6348	6359	6371	6380	6386	6397
				6400	6402	6406	6419	6425	6426	6549	6580	6585	6590	6627	6629
				6733	6734	6846	6853	6860	6879	6881	6888	6908	6929	6965	6967
				6973	6975	6979	6982	6987
	RAM			712 #	2219	2221	6462	6467	6472	6474
	VMA			711 #	2197	2305	2375	2389	2398	2402	2430	2441	2447	2460	2531
				2563	2569	2574	2577	2627	2823	3442	3585	3609	3624	3645	3649
				3653	3714	3731	3737	3759	3776	3782	3795	3853	3884	4006	4008
				4014	4041	4053	4057	4080	4776	4804	4810	4931	5173	5196	5199
				5245	5287	5951	5970	6390	6584	6630	6633	6661	6937	6952	7022
				7155	7290	7294	7298	7302	7306	7347	7377	7379	7386	7440	7508
				7513	7524	7561	7566	7657	7690	7737	7782	7785	7787	7797	7799
				7896	7910	7915	7935	7983	8000	8001	8003	8004	8007	8008	8010
				8011	8013	8014	8016	8017	8019	8020	8022	8023	8025	8301	8325
				8390	8472	8712	8764	8824	8830	8881	8895	8909	8911
	XR#			710 #	2315	2325	2337	2352	2365	2381	3590	3592	3600	4783	4786
				4788	4796	5962	5964	5967	6932	6934	6938	7726	7727	7735
	#			713 #	2196	2204	2206	2207	2212	2213	3699	4729	4988	5001	5006
				5011	5015	5016	5021	5027	5053	5066	5074	5079	5085	5215	5961
				5974	5977	6007	6024	6031	6035	6052	6064	6069	6080	6084	6095
				6096	6097	6099	6100	6101	6102	6112	6119	6143	6159	6166	6171
				6172	6179	6182	6195	6213	6217	6220	6224	6334	6336	6377	6387
				6392	6393	6395	6398	6411	6413	6417	6420	6421	6442	6592	6593
				6616	6618	6654	6659	6669	6731	6737	6764	6768	6771	6776	6777
				6784	6851	6858	6862	6864	6953	6969	6978	6984	6992	6993	6996
				7004	7094	7116	7128	7220	7225	7277	7279	7281	7283	7285	7291
				7295	7299	7303	7307	7315	7322	7324	7329	7333	7335	7354	7357
				7367	7368	7371	7387	7388	7392	7472	7473	7721	7724	7729	7741
				7743	7755	7761	7763	7908	7980	7982	7987	7991	7995	8005	8006
				8024	8026	8027	8029	8267	8268	8288	8289	8291	8292	8299	8309
				8311	8313	8315	8319	8320	8368	8371	8398	8400	8431	8438	8455
				8458	8461	8463	8477	8484	8526	8536	8538	8567	8583	8623	8624
				8625	8631	8651	8652	8658	8809	8820	8826	8835	8839	8851
(D) READ			1385 #	2583	2584	2586	2588	2589	2591	2593	2594	2596	2598	2599
				2601	2620	2636	2637	2638	2639	2641	2642	2643	2644	2646	2647
				2649	2651	2652	2654	2656	2657	2659	2661	2662	2664	2666	2667
				2669	2671	2672	2674	2678	2679	2680	2681	2683	2684	2685	2686
				2688	2689	2691	2693	2694	2696	2698	2699	2701	2703	2704	2706
				2708	2709	2711	2713	2714	2716	2802	2803	2833	2834	2843	2844
				2845	2846	2853	2854	2855	2856	2863	2864	2865	2866	2868	2869
				2870	2871	2878	2885	2886	2887	2888	2895	2896	2897	2898	2905
				2906	2907	2908	2915	2916	2917	2918	2925	2926	2935	2936	2937
				2938	2946	2947	2948	2949	2956	2957	2958	2959	2966	2967	2968
				2969	2976	2977	2988	2989	2990	2992	2993	2994	3222	3223	3224
				3225	3226	3227	3238	3239	3240	3241	3242	3243	3244	3245	3256
				3257	3258	3259	3260	3261	3262	3263	3273	3274	3275	3276	3277
				3278	3279	3280	3395	3396	3397	3398	3399	3400	3401	3402	3412
				3413	3414	3415	3416	3417	3418	3419	3429	3430	3431	3432	3433
				3434	3435	3436	3445	3446	3447	3448	3449	3450	3451	3452	3512
				3526	3683	3706	3802	4089	4090	4091	4092	4103	4104	4105	4106
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 303
; 								Cross Reference Listing					

				4118	4119	4151	4152	4153	4154	4176	4177	4178	4179	4202	4343
				4344	4345	4346	4348	4349	4350	4351	4420	4721	4722	4723	4724
				4725	5299	5300	5301	5302	5303	5304	5305	5307	5308	5309	5310
				5311	5312	5313	5344	5345	5346	5348	5349	5350	5351	5373	5374
				5375	5377	5378	5379	5380	5423	5458	5459	5573	5574	5662	5723
				5947
(U) READ CYCLE			1156 #	2264	2265	2267	2268	2287	2327	2333	2338	2344	2367	2371
				2400	2441	2452	2455	2466	3056	3362	3374	3489	3490	3493	3494
				3561	3562	3563	3568	3572	3575	3588	3602	3605	3630	3652	3672
				3745	3755	3789	3882	4039	4083	4257	4732	4741	4789	4793	4797
				4801	5134	5209	5292	5967	5968	5992	6139	6389	6416	6489	6494
				6550	6670	6786	6932	6933	6934	6935	7010	7018	7153	7289	7293
				7297	7301	7305	7345	7349	7385	7421	7509	7523	7556	7565	7574
				7648	7651	7692	7715	7736	7893	7928	7930	8374	8382	8387	8467
				8606	8708	8743	8757	8915
(D) ROUND			1373 #	5302	5303	5304	5305	5310	5311	5312	5313	5348	5349	5350
				5351	5377	5378	5379	5380	5423	5459
(U) RSRC			641 #
	AB			643 #	3699	7721
	AQ			642 #
	D0			649 #	2795	6194	6309	7509	7556	7648	7651	7687	7698	7704	7777
				7930	8305	8307	8321
	DA			647 #	2191	2194	2227	2238	2274	2278	2281	2284	2293	2296	2299
				2302	2553	3078	3616	3982	4022	4070	4434	4445	4839	5919	5921
				5923	5925	5927	5929	5931	5933	5935	6619	6631	6657	6697	6842
				7067	7070	7138	7318	7361	7362	7363	7497	7498	7499	7500	7501
				7502	7503	7505	7538	7570	8283	8347	8426	8486	8504	8612	8834
	DQ			648 #
	0A			646 #	2356	2797	3725	3842	3848	4054	4255	5260	5590	5592	5692
				5693	5743	5745	5965	7003	7540	8893
	0B			645 #	2774	2776
	0Q			644 #	3664	3678	3999	4025	5264	5954	5998	6198	7528	8889
(U) S#				1031 #	2211	2414	2433	2433	2448	2448	2464	3002	3005	3009	3019
				3021	3037	3040	3043	3048	3060	3075	3077	3104	3121	3130	3133
				3176	4158	4186	4223	4243	4263	4376	4473	4481	4743	4825	4848
				4853	4855	4857	4860	4923	4924	4925	4926	4927	4928	4936	4940
				4942	4944	4977	4993	5004	5017	5033	5078	5093	5252	5254	5272
				5274	5282	5283	5326	5328	5360	5365	5367	5393	5394	5407	5408
				5430	5434	5436	5437	5441	5449	5464	5467	5469	5520	5524	5526
				5529	5532	5540	5542	5543	5544	5545	5563	5568	5598	5609	5624
				5626	5667	5678	5682	5685	5695	5701	5707	5718	5756	5757	5767
				5781	5788	5791	5803	5820	5825	5827	5848	5873	5875	5881	6019
				6020	6022	6188	6333	6501	6503	6510	6559	6564	6566	6689	6691
				6693	6694	6700	6710	6893	7194	7215	7246	7256	7262	7476	7664
				7696	7750	7766	8342	8393	8441	8581
(U) SCAD			1008 #
	A			1016 #	2211	3060	4158	4186	4223	4243	4263	4376	4473	4481	4739
				4753	4830	4831	4832	4833	4834	4939	4977	4993	5004	5017	5033
				5078	5093	5252	5254	5272	5274	5360	5407	5430	5434	5436	5437
				5441	5667	5678	5682	5695	5701	5756	5757	6333	6501	6503	6510
				6559	6689	6690	6700	6890	6911	6930	7194	7215	7246	7256	7262
				7476	7664	7696	7750	7766	8342	8393	8441	8581
	A*2			1009 #	6682
	A+B			1013 #	2414	2433	2433	2448	2448	3005	3009	3019	3021	3040	3043
				3048	3075	3077	3121	3130	4855	4860	4924	4925	4926	4927	4928
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 304
; 								Cross Reference Listing					

				4936	4944	5282	5283	5326	5328	5356	5365	5367	5408	5449	5451
				5463	5467	5520	5524	5526	5529	5532	5540	5542	5543	5544	5545
				5563	5568	5598	5609	5624	5626	5690	5707	5718	5781	5788	5791
				5803	5820	5825	5827	5848	5873	5875	5881	6019	6020	6022	6560
				6564	6692	6693	6694	6710	6998
	A-1			1015 #	2221	3025	3027	3103	3105	3107	3111	3137	3144	3175	3177
				3179	3183	4289	4301	4307	4315	4325	4333	4588	4591	4631	4980
				4999	5099	5336	5338	5444	5468	5471	5474	5478	5642	5645	5652
				5670	6362	6506	6512	6707	7197	7217	7248	7265	7456	7469	7671
				7702	7757	7770	8345	8407	8410	8444	8587
	A-B			1012 #	3002	3037	3104	3133	3176	4731	4736	4750	4771	4825	4848
				4853	4857	4923	4942	5387	5393	5394	5469	5741	5767	6072	6082
				6882	6885	6925	6927
	A-B-1			1011 #	5322	5327	5588	5608
	A.AND.B			1014 #	4743	4940	6188	6566	6691	6893
	A.OR.B			1010 #	2464	5685
(U) SCADA			1017 #
	BYTE1			1021 #	4731	4736	4739	4750	4830	4939	6072	6560	6690	6882	6890
				6925	6930	6998
	BYTE2			1022 #	4831
	BYTE3			1023 #	4832
	BYTE4			1024 #	4833
	BYTE5			1025 #	4754	4834	6683	6912
	PTR44			1020 #	4771	6082	6885	6927
	S#			1019 #	2211	2414	2433	2433	2448	2448	2464	3002	3005	3009	3019
				3021	3037	3040	3043	3048	3060	3075	3077	3104	3121	3130	3133
				3176	4158	4186	4223	4243	4263	4376	4473	4481	4743	4825	4848
				4853	4855	4857	4860	4923	4924	4925	4926	4927	4928	4936	4940
				4942	4944	4977	4993	5004	5017	5033	5078	5093	5252	5254	5272
				5274	5282	5283	5326	5328	5360	5365	5367	5393	5394	5407	5408
				5430	5434	5436	5437	5441	5449	5463	5467	5469	5520	5524	5526
				5529	5532	5540	5542	5543	5544	5545	5563	5568	5598	5609	5624
				5626	5667	5678	5682	5685	5695	5701	5707	5718	5756	5757	5767
				5781	5788	5791	5803	5820	5825	5827	5848	5873	5875	5881	6019
				6020	6022	6188	6333	6501	6503	6510	6559	6564	6566	6689	6691
				6693	6694	6700	6710	6893	7194	7215	7246	7256	7262	7476	7664
				7696	7750	7766	8342	8393	8441	8581
	SC			1018 #	2221	3025	3027	3103	3105	3107	3111	3137	3144	3175	3177
				3179	3183	4289	4301	4307	4315	4325	4333	4588	4591	4631	4980
				4999	5099	5322	5327	5336	5338	5356	5387	5444	5451	5468	5471
				5474	5478	5588	5608	5642	5645	5652	5670	5690	5741	6362	6506
				6512	6692	6707	7197	7217	7248	7265	7456	7469	7671	7702	7757
				7770	8345	8407	8410	8444	8587
(U) SCADB			1026 #
	EXP			1028 #	2433	2433	2448	2448	5322	5326	5328	5356	5387	5451	5588
				5598	5609	5690	5741
	FE			1027 #	2464	3002	3005	3009	3019	3021	3037	3040	3043	3048	3075
				3077	3130	3133	4743	4825	4848	4853	4855	4860	4924	4925	4926
				4927	4928	4936	4940	4942	4944	5282	5283	5327	5365	5367	5393
				5394	5408	5464	5467	5469	5520	5524	5526	5529	5532	5540	5542
				5543	5544	5545	5563	5568	5608	5624	5626	5685	5707	5718	5767
				5781	5788	5791	5803	5820	5825	5827	5848	5873	5875	5881	6020
				6022	6188	6560	6564	6566	6691	6692	6693	6694	6710	6893
	SHIFT			1029 #	2414	3104	3121	3176	5449
	SIZE			1030 #	4731	4736	4750	4771	4857	4923	6019	6072	6082	6882	6885
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 305
; 								Cross Reference Listing					

				6925	6927	6998
(U) SETFOV			1112 #	5389	5401	5754
(U) SETFPD			1118 #	4271	4785	6428
(U) SETNDV			1113 #	4378	4413	4444	4530	5037	5389	5401	5754
(U) SETOV			1110 #	4171	4172	4196	4258	4378	4413	4444	4530	5037	5389	5401
				5466	5754
(U) SHSTYLE			855 #
	ASHC			860 #	3027	3136	3139	3143	3146	4307	4315	4325	4333	4439	4443
				4512	4516	4532	5338	5441	5443	5473	5617	5619	5623	5625	5641
				5645	5652	5655	5657	5669	5710	5714	5749	5763	5781	5787	5790
				5803	5820	5824	5826	5848	5873
	DIV			862 #	4588	4591	4592	4635	4639	5520	5532	5540	5544	5637	5639
				5640
	LSHC			861 #	3107	3111	4620	4623
	NORM			856 #	2461	3021	4266	4300	4473	4629	5247	5262	5263	5267	5268
				5269	5283	5671	5761
	ONES			858 #	4859	4862	4935	4938	6022
	ROT			859 #	3043	3048
	ROTC			863 #	3179	3183
	ZERO			857 #
(U) SKIP			933 #
	AC0			941 #	2520	3424	4728
	ADEQ0			953 #	3053	3368	3380	3471	3483	4161	4166	4368	4370	4374	4388
				4433	4462	4492	4573	4651	4656	4661	4677	4684	5002	5031	5385
				5411	5413	5486	5528	5552	5708	5759	5801	5846	6176	6229	6305
				6308	6597	6634	6655	6778	7365	8369	8372	8438	8456	8459	8567
				8651
	ADLEQ0			937 #	2224	4026	4031	5428	5433	5547	5712	5715	5783	5786	5789
				5792	5852	5952	5995	6134	6136	6218	6238	6422	6438	6492	6527
				6530	6562	7026	7162	7176	7222	7231	7526	7527	7718	7720	7734
				8329	8351	8395	8402	8405	8420	8425	8474	8493	8497	8503	8517
				8521	8523	8543	8596	8615	8617	8655	8660	8682	8685	8687	8690
				8693	8714	8724	8778	8796	8837	8886
	ADREQ0			938 #	3122	3628	3643	5159	6363	6436	6791	7068	7074	7101	7103
				7106	7108	7110	7401	7403	7407	7409	7411	7413	7415	7417	7514
				7567	7587	7659	7686	8269	8548	8576	8765	8782	8785	8790
	CRY0			936 #	3721	3764	3793	5397	5521	5523	5525	5527
	CRY1			949 #	4124	4136	5837	6253	6259	6272	6463	6474
	CRY2			944 #	5810	5870
	DP0			945 #	2434	2449	2608	2786	2793	3076	3148	3365	3377	3468	3480
				3810	3813	3818	3989	4143	4168	4190	4193	4248	4256	4357	4393
				4395	4400	4405	4409	4431	4448	4460	4467	4482	4501	4519	4571
				4578	4593	5034	5178	5202	5288	5324	5328	5357	5387	5395	5429
				5451	5482	5589	5691	5738	5742	5753	5766	6003	6016	6033	6046
				6053	6071	6113	6115	6137	6154	6157	6163	6203	6295	6300	6337
				6346	6379	6396	6468	6518	6544	6735	6765	6807	6861	6980	7156
				7320	8356	8454	8681	8735
	DP18			946 #	2413	2772	2779	5976	6223	6427	6516	6839	6840	7553	8738
				8748	8771
	EXECUTE			955 #	7922
	FPD			940 #	4210	4731	4736	4750	6327
	INT			942 #	5182	6073	8293	8488	8710	8818	8849	8900
	IOLGL			934 #	2470	3573	3576
	IOT			947 #
	JFCL			948 #	3635
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 306
; 								Cross Reference Listing					

	KERNEL			939 #	3566	3570	3571	3578	3687	7005
	LE			943 #	3371	3383	3474	3486	4427	5061	5405	5729	6376	7331	7988
	LLE			935 #	7727
	SC			954 #	2221	3025	3027	3103	3105	3107	3111	3128	3137	3144	3175
				3177	3179	3183	4289	4301	4307	4315	4325	4333	4588	4591	4631
				4980	4999	5099	5336	5338	5444	5468	5471	5474	5478	5591	5593
				5642	5645	5652	5670	6362	6506	6512	6698	6707	7197	7217	7248
				7265	7456	7469	7671	7702	7770	8345	8407	8410	8444	8587
	TRAP CYCLE		951 #	8836
	TXXX			950 #	3321
	-1 MS			958 #	5174	6068	7369	8483
	-CONTINUE		957 #	7924
	-IO BUSY		956 #	7752	7758	7767	7775
(U) SPEC			819 #	2605	2611	2725	2727	2760	2766	2774	2776	2795	2797	2840
				2850	2860	2892	2902	2922	2932	2943	2953	2983	4163	4169	4192
				4194	8602	8902
	APR EN			833 #	2202	7115	7224
	APR FLAGS		831 #	7120	7124	7339
	ASHOV			840 #	3027	3143	3146
	CLR IO BUSY		823 #	7645	7683
	CLR IO LATCH		822 #	7730	7738	7742	7745	7754	7760	7769	7774
	CLRCLK			821 #	7316	7370	8537	8821
	CLRCSH			832 #	7451	7452	7455
	EXPTST			841 #	5529	5545	5875
	FLAGS			842 #	2253	2254	2614	3440	3456	3523	3537	3593	3594	3597	3598
				3634	3655	3656	3726	3738	3794	3824	3828	3843	3849	4043	4044
				4045	4097	4111	4128	4138	4141	4171	4172	4196	4246	4258	4268
				4271	4378	4413	4444	4530	4679	4681	4746	4763	4785	5037	5389
				5401	5466	5754	6428	6429	7027	7529	7544	8840
	INHCRY18		837 #	3546	3716	3763	3792	3812	3817	5069	5144
	LDACBLK			843 #	2199	7188	7211
	LDINST			844 #	2306	3691	7023	7936
	LDPAGE			824 #	7446	8618
	LDPI			839 #	3644	7432	7507	7989
	LDPXCT			826 #	3696
	LOADIR			838 #	5957
	LOADXR			829 #	2377	3586	3610	3625	4739	4758	4806	5958	5970	6889	6926
				6928	6937	7733
	MEMCLR			834 #	2197	3645	7508	7910	7983	8325	8824	8830
	NICOND			825 #	2264	2265	2267	2268	2328	2334	2558	3079	3125	3153	3362
				3374	3465	3489	3490	3493	3494	3561	3562	3588	3630	3747	3823
				3830	4257	4521	4524	4732	5479	5485	5844	7421	7692	8271
	PREV			828 #	7894	7902
	PXCT OFF		836 #	2276	2279	2282	2294	2297	2300	2314
	SWEEP			835 #	7464	7465	7468
	WAIT			827 #	2446
	#			820 #	7918	7921	7984
(U) STATE			1034 #
	BLT			1036 #	5145
	COMP-DST		1043 #	6162
	CVTDB			1042 #	6209
	DST			1039 #	6124
	DSTF			1041 #	6062
	EDIT-DST		1045 #	6181	6391	6418	6637	6663	8857	8861
	EDIT-S+D		1046 #	6603
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 307
; 								Cross Reference Listing					

	EDIT-SRC		1044 #	6155	6542	6599	8855	8863	8865	8869
	MAP			1037 #	8270
	SIMPLE			1035 #
	SRC			1038 #	6011	6040	6110	8859
	SRC+DST			1040 #	6037	6116
(U) SWITCH%
	CRAM4K			8	417	434	443	460	463	465	8282	8285
	FULL			408	1331	1333	2208	2228	2233	2237	4205	4273	4276	4423	4533
				4536	4604	4669	4955	5106	5110	7218	7226
	INHCST			10	411	1271	1273	1275	8073	8075	8433	8436	8437	8440	8562
				8565	8566	8569	8640	8649	8650	8666
	KIPAGE			423	439	441	1295	1297	1299	3986	3996	4048	4059	7228	7235
				7241	7243	8350	8354	8359	8362	8730	8776	8885	8888	8892	8897
	KLPAGE			426	436	438	1301	1303	1305	3987	3991	3997	4011	7229	7234
				7237	7239	8349	8358	8364	8571	8634	8728	8884	8890	8907	8912
	NOCST			414	446	448	1277	1279	1281	8428	8501	8508	8511	8525	8528
				8529	8533	8559	8578	8635	8667
	NONSTD			450	1283	1285	1287
	SIM			405	2246	2251	2258
	UBABLT			9	420	435	442	1289	1291	1293	5220	5294	7866	7868	7870
(U) T				971 #
	2T			974 #	4448	4461	5328	5598	6172	6242	6306	6594	6731	6776	7371
				7728
	3T			975 #	2224	2449	2459	2614	3147	3321	3406	3440	3456	3546	3636
				3720	3755	3763	3788	3792	3809	3814	3819	3856	3872	4097	4111
				4214	4216	4235	4269	4406	4410	4460	4466	4467	4468	4485	4489
				4510	4518	4599	4664	4681	4739	4754	4825	4843	4939	4983	4990
				5070	5086	5090	5156	5158	5177	5201	5288	5322	5356	5397	5428
				5429	5432	5464	5467	5521	5523	5525	5527	5586	5587	5590	5592
				5691	5692	5693	5737	5741	5743	5745	5753	5836	5842	6002	6020
				6022	6070	6074	6137	6244	6258	6272	6304	6307	6392	6395	6427
				6428	6456	6462	6465	6474	6499	6513	6540	6560	6561	6683	6690
				6734	6793	6883	6890	6911	6925	6929	6932	6934	6970	7025	7155
				7162	7175	7222	7231	7488	7513	7517	7525	7526	7527	7562	7566
				7568	7735	8376	8384	8610	8627	8750	8761	8845	8875
	4T			976 #	3052	3523	3537	4123	4128	4135	4138	4140	5030	5035	6016
				6046	6223	6228	6253	6294	6467	6515	6655	6778	6979	7988	8296
				8369	8372	8456	8459	8738	8748
	5T			977 #	7289	7293	7297	7301	7305	7757	7774
(D) TEST			1386 #	2585	2585	2586	2586	2590	2590	2591	2591	2595	2595	2596
				2596	2600	2600	2601	2601	2620	2638	2638	2639	2639	2643	2643
				2644	2644	2648	2648	2649	2649	2653	2653	2654	2654	2658	2658
				2659	2659	2663	2663	2664	2664	2668	2668	2669	2669	2673	2673
				2674	2674	2680	2680	2681	2681	2685	2685	2686	2686	2690	2690
				2691	2691	2695	2695	2696	2696	2700	2700	2701	2701	2705	2705
				2706	2706	2710	2710	2711	2711	2715	2715	2716	2716	2812	2835
				2835	2836	2836	2845	2845	2846	2846	2855	2855	2856	2856	2865
				2865	2866	2866	2870	2870	2871	2871	2880	2880	2881	2881	2887
				2887	2888	2888	2897	2897	2898	2898	2907	2907	2908	2908	2917
				2917	2918	2918	2927	2927	2928	2928	2937	2937	2938	2938	2948
				2948	2949	2949	2958	2958	2959	2959	2968	2968	2969	2969	2978
				2978	2979	2979	3429	3430	3431	3432	3433	3434	3435	3436	3445
				3446	3447	3448	3449	3450	3451	3452	4091	4091	4092	4092	4105
				4105	4106	4106	4153	4153	4154	4154	4178	4178	4179	4179	4345
				4345	4346	4346	4350	4350	4351	4351	4722	4724	5300	5300	5301
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 308
; 								Cross Reference Listing					

				5301	5304	5304	5305	5305	5308	5308	5309	5309	5312	5312	5313
				5313	5345	5345	5346	5346	5350	5350	5351	5351	5374	5374	5375
				5375	5379	5379	5380	5380	7272
(U) TRAP1			1127 #	4171	4172	4196	4258	4378	4413	4444	4530	5037	5389	5401
				5466	5754
(U) TRAP2			1126 #	3738	3794	3824	3828
(U) VECTOR CYCLE		1198 #	7557
(D) VMA				1388 #	2584	2589	2594	2599	2637	2642	2647	2652	2657	2662	2667
				2672	2679	2684	2689	2694	2699	2704	2709	2714	2833	2834	2844
				2854	2864	2869	2886	2896	2906	2916	2925	2926	2936	2947	2957
				2967	2976	2977	2988	2989	2990	2992	2993	2994	3512	3526	3552
				3802	4090	4104	4152	4177	4344	4349
(U) WAIT			1187 #	2264	2264	2265	2265	2267	2267	2268	2268	2287	2287	2304
				2327	2327	2333	2333	2338	2344	2357	2367	2371	2375	2388	2397
				2400	2401	2429	2440	2441	2441	2452	2455	2459	2466	2466	2530
				2562	2568	2573	2576	2625	2625	2626	2821	2821	2823	2827	2827
				3056	3056	3362	3362	3374	3374	3441	3441	3442	3489	3489	3490
				3490	3493	3493	3494	3494	3561	3561	3562	3562	3563	3568	3572
				3575	3584	3588	3588	3602	3605	3608	3623	3630	3630	3649	3652
				3653	3666	3666	3669	3669	3672	3677	3677	3713	3718	3718	3730
				3736	3745	3745	3755	3758	3768	3768	3773	3773	3775	3781	3789
				3795	3851	3851	3852	3864	3864	3882	3883	3994	4004	4005	4007
				4013	4018	4018	4039	4040	4052	4056	4065	4065	4075	4075	4079
				4083	4257	4257	4732	4732	4741	4741	4769	4769	4775	4775	4776
				4789	4793	4797	4801	4803	4809	4930	4930	4931	5134	5162	5162
				5170	5170	5172	5186	5186	5191	5191	5195	5198	5209	5244	5285
				5285	5287	5292	5951	5967	5968	5970	5992	6139	6389	6390	6416
				6489	6494	6550	6582	6582	6584	6628	6628	6630	6633	6661	6670
				6786	6932	6933	6934	6935	6937	6951	7007	7010	7015	7018	7022
				7153	7154	7257	7257	7289	7289	7290	7293	7293	7294	7297	7297
				7298	7301	7301	7302	7305	7305	7306	7345	7346	7349	7374	7374
				7377	7378	7378	7379	7385	7386	7421	7421	7439	7439	7440	7512
				7523	7524	7539	7539	7560	7565	7566	7574	7654	7656	7689	7690
				7692	7692	7715	7736	7737	7782	7785	7787	7795	7797	7799	7893
				7895	7901	7901	7913	7915	7916	7916	7928	7928	7934	7999	8000
				8001	8002	8002	8003	8004	8007	8008	8009	8009	8010	8011	8012
				8012	8013	8014	8015	8015	8016	8017	8018	8018	8019	8020	8021
				8021	8022	8023	8025	8374	8382	8387	8389	8467	8471	8628	8663
				8708	8711	8743	8757	8763	8879	8880	8894	8909	8911	8915	8918
				8918
(U) WORK			1050 #
	AC0			1091 #
	AC1			1092 #
	AC2			1093 #
	AC3			1094 #
	ADJBPW			1069 #	5053	5074
	ADJP			1064 #	4988	5015
	ADJPTR			1066 #	4729	5006	5068
	ADJQ1			1067 #	5011	5029
	ADJR2			1068 #	5021	5088
	ADJS			1065 #	5001	5016	5079
	APR			1071 #	2204	7094	7116	7128	7220	7225	8268
	BADW0			1051 #	8319
	BADW1			1052 #	8320
	BDH			1081 #	6336	6411	6420	6442
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 309
; 								Cross Reference Listing					

	BDL			1082 #	6334	6377	6417	6421
	CBR			1061 #	7279	7295	8438	8567	8651	8652
	CMS			1078 #	6159	6171	6172	6182
	CSTM			1062 #	7283	7303	8658
	DDIV SGN		1095 #
	DECHI			1100 #	2213	2215	6465
	DECLO			1099 #	2212	2214	6456
	DIV			1054 #
	DVSOR H			1096 #
	DVSOR L			1097 #
	E0			1073 #	5961	6387	6659	6669
	E1			1074 #	5974	5977	6413	6592	6593	6768	6771	6776	6784
	FILL			1077 #	6143	6166	6179	6654	6731	6737	6851	6953
	FSIG			1079 #	6616	6618
	HSBADR			1070 #	2196	7285	7307	7982	7987
	MSK			1076 #	6024	6195	6777
	MUL			1053 #
	PERIOD			1087 #	7335	7387	7392
	PTA.E			1103 #	7473	8368	8455	8461
	PTA.U			1104 #	7472	8371	8458	8463
	PUR			1063 #	7281	7299	8431	8526
	SBR			1060 #	7277	7291	8398	8400	8477
	SLEN			1075 #	6007	6031	6035	6052	6064	6080	6084	6112	6119	6213	6217
				6220	6224	6392	6393	6395	6398	6764	6858	6862	6864	6978	6992
				6996
	SV.ARX			1057 #	6096	6101	7908	7980	7991	8006	8029	8292	8623	8851
	SV.AR			1056 #	6069	6099	8005	8026	8288	8631
	SV.AR1			1106 #	8484	8538
	SV.BRX			1059 #	5215	6097	6102	6969	6984	6993	8289	8625
	SV.BR			1058 #	6095	6100	8299	8309	8311	8313	8315	8624	8809
	SV.VMA			1055 #	7755	7761	7763	7995	8024	8027	8267	8291	8583	8826	8835
	TIME0			1085 #	2206	7324	7357	7367
	TIME1			1086 #	2207	7315	7322	7354	7368	7371	8536	8820
	TRAPPC			1105 #	7004	8839
	TTG			1088 #	7329	7333	7388
	YSAVE			1102 #	3699	7721	7724	7729	7741	7743
(D) WRITE			1389 #
(U) WRITE CYCLE			1158 #	2605	2611	2625	2725	2727	2760	2766	2774	2776	2795	2797
				2821	2827	2840	2850	2860	2892	2902	2922	2932	2943	2953	2983
				3441	3666	3669	3677	3718	3768	3773	3851	3864	3994	4004	4018
				4065	4075	4097	4111	4163	4169	4192	4194	4769	4775	4930	5162
				5170	5186	5191	5285	5483	5487	5533	5555	6582	6628	7257	7374
				7378	7439	7539	7687	7698	7704	7901	7913	7916	7999	8002	8009
				8012	8015	8018	8021	8522	8543	8602	8607	8663	8797	8879	8902
				8918
(U) WRITE TEST			1157 #	2605	2611	2625	2725	2727	2760	2766	2774	2776	2795	2797
				2821	2827	2840	2850	2860	2892	2902	2922	2932	2943	2953	2983
				3441	3666	3669	3677	3718	3768	3773	3851	3864	3994	4004	4018
				4065	4075	4097	4111	4163	4169	4192	4194	4769	4775	4930	5162
				5170	5186	5191	5285	5483	5487	5533	5555	6582	6628	7257	7289
				7293	7297	7301	7305	7374	7378	7439	7509	7523	7539	7556	7565
				7648	7651	7687	7698	7704	7901	7913	7916	7930	7999	8002	8009
				8012	8015	8018	8021	8329	8374	8382	8522	8602	8608	8879	8902
				8915	8918
(U) WRU CYCLE			1194 #	7510
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 310
; 								Cross Reference Listing					

(U) #				1005 #	2185	2187	2189	2191	2194	2224	2238	2274	2278	2281	2293
				2296	2299	2456	2458	2471	2493	2494	2781	2783	2788	2790	2807
				3078	3149	3151	3565	3574	3577	3579	3580	3581	3614	3619	3622
				3628	3642	3643	3663	3676	3762	3791	3854	3871	3958	3960	3962
				3964	3966	3968	3970	3972	3979	3982	4022	4027	4029	4032	4034
				4062	4070	4077	4144	4145	4397	4434	4435	4445	4453	4498	4551
				4577	4584	4675	4840	4984	4986	4991	5009	5013	5019	5023	5052
				5057	5091	5095	5102	5155	5251	5256	5265	5271	5276	5329	5330
				5333	5334	5358	5359	5363	5391	5392	5428	5432	5452	5453	5590
				5592	5672	5692	5693	5712	5715	5743	5745	5919	5921	5923	5925
				5927	5929	5931	5933	5935	5952	5955	5979	5995	5999	6134	6136
				6194	6199	6206	6211	6218	6222	6238	6280	6296	6297	6303	6309
				6329	6342	6344	6351	6356	6363	6366	6422	6436	6438	6445	6470
				6476	6492	6504	6507	6515	6527	6530	6547	6562	6620	6631	6640
				6642	6658	6677	6698	6703	6712	6715	6791	6813	6817	6821	6825
				6829	6833	6843	6849	6947	6958	7025	7030	7039	7040	7041	7045
				7046	7047	7048	7053	7054	7055	7058	7059	7060	7061	7062	7063
				7064	7065	7067	7070	7081	7096	7097	7100	7101	7103	7106	7108
				7110	7122	7132	7135	7139	7160	7167	7171	7175	7182	7201	7221
				7222	7223	7231	7232	7233	7249	7255	7261	7266	7286	7309	7318
				7337	7352	7404	7405	7448	7450	7461	7463	7490	7491	7492	7493
				7494	7495	7496	7497	7498	7499	7500	7501	7502	7503	7506	7517
				7526	7527	7542	7562	7569	7659	7667	7673	7686	7718	7720	7734
				7777	7863	7872	7874	7876	7878	7880	7882	7918	7921	7932	7984
				8262	8266	8269	8305	8307	8321	8331	8334	8340	8348	8352	8377
				8385	8396	8403	8420	8427	8475	8487	8490	8498	8505	8516	8519
				8545	8549	8552	8577	8590	8594	8598	8600	8613	8614	8616	8621
				8656	8677	8683	8688	8694	8737	8747	8751	8761	8766	8782	8785
				8788	8791	8800	8805	8813	8875	8886
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 311
; 								Location / Line Number Index
; Dcode Loc'n	0	1	2	3	4	5	6	7						

D 0000		3944	5888	5889	5890	5891	5892	5893	5894
D 0010		5896	5897	5898	5899	5901	5902	5903	5904
D 0020		5906	5907	5908	5909	5910	5911	5912	5913
D 0030		3891	3892	3893	3894	3895	3896	3897	3898
D 0040		3902	3903	3904	3905	3906	3907	3908	3909
D 0050		3910	3911	3912	3913	3914	3915	3916	3917
D 0060		3918	3919	3920	3921	3922	3923	3924	3925
D 0070		3926	3927	3928	3929	3930	3931	3932	3933

D 0100		3937	3938	3939	3940	3945	3802	3946	3947
D 0110		5573	5574	5662	5723	4118	4119	4202	4420
D 0120		2802	2803	5458	5947	2811	2812	5459	5423
D 0130		3948	3949	5424	4721	4722	4723	4724	4725
D 0140		5299	3950	5300	5301	5302	5303	5304	5305
D 0150		5307	3951	5308	5309	5310	5311	5312	5313
D 0160		5344	3952	5345	5346	5348	5349	5350	5351
D 0170		5373	3953	5374	5375	5377	5378	5379	5380

D 0200		2583	2584	2585	2586	2588	2589	2590	2591
D 0210		2593	2594	2595	2596	2598	2599	2600	2601
D 0220		4151	4152	4153	4154	4176	4177	4178	4179
D 0230		4343	4344	4345	4346	4348	4349	4350	4351
D 0240		2988	2989	2990	2991	2992	2993	2994	3954
D 0250		2620	5148	3540	3541	3552	3554	3683	8257
D 0260		3705	3706	3707	3708	3835	3836	3837	3838
D 0270		4089	4090	4091	4092	4103	4104	4105	4106

D 0300		3386	3387	3388	3389	3390	3391	3392	3393
D 0310		3395	3396	3397	3398	3399	3400	3401	3402
D 0320		3498	3499	3500	3501	3502	3503	3504	3505
D 0330		3412	3413	3414	3415	3416	3417	3418	3419
D 0340		3512	3513	3514	3515	3516	3517	3518	3519
D 0350		3429	3430	3431	3432	3433	3434	3435	3436
D 0360		3526	3527	3528	3529	3530	3531	3532	3533
D 0370		3445	3446	3447	3448	3449	3450	3451	3452

D 0400		2833	2834	2835	2836	2843	2844	2845	2846
D 0410		2853	2854	2855	2856	2863	2864	2865	2866
D 0420		2868	2869	2870	2871	2878	2879	2880	2881
D 0430		2885	2886	2887	2888	2895	2896	2897	2898
D 0440		2905	2906	2907	2908	2915	2916	2917	2918
D 0450		2925	2926	2927	2928	2935	2936	2937	2938
D 0460		2946	2947	2948	2949	2956	2957	2958	2959
D 0470		2966	2967	2968	2969	2976	2977	2978	2979

D 0500		2636	2637	2638	2639	2641	2642	2643	2644
D 0510		2646	2647	2648	2649	2651	2652	2653	2654
D 0520		2656	2657	2658	2659	2661	2662	2663	2664
D 0530		2666	2667	2668	2669	2671	2672	2673	2674
D 0540		2678	2679	2680	2681	2683	2684	2685	2686
D 0550		2688	2689	2690	2691	2693	2694	2695	2696
D 0560		2698	2699	2700	2701	2703	2704	2705	2706
D 0570		2708	2709	2710	2711	2713	2714	2715	2716

; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 312
; 								Location / Line Number Index
; Dcode Loc'n	0	1	2	3	4	5	6	7						

D 0600		3211	3212	3213	3214	3215	3216	3217	3218
D 0610		3220	3221	3222	3223	3224	3225	3226	3227
D 0620		3229	3230	3231	3232	3233	3234	3235	3236
D 0630		3238	3239	3240	3241	3242	3243	3244	3245
D 0640		3247	3248	3249	3250	3251	3252	3253	3254
D 0650		3256	3257	3258	3259	3260	3261	3262	3263
D 0660		3264	3265	3266	3267	3268	3269	3270	3271
D 0670		3273	3274	3275	3276	3277	3278	3279	3280

D 0700		7035	7036	7272	7806	7887	7888	7807	7808
D 0710		7594	7595	7605	7606	7619	7620	7810	7811
D 0720		7596	7597	7607	7608	7621	7622	7813	7814
D 0730		7816	7817	7818	7819	7820	7821	7822	7823
D 0740		7825	7826	7827	7828	7829	7830	7831	7832
D 0750		7834	7835	7836	7837	7838	7839	7840	7841
D 0760		7843	7844	7845	7846	7847	7848	7849	7850
D 0770		7852	7853	7854	7855	7856	7857	7858	7859
; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 313
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 0000		2185:	7981:	2186 	2194:	7922:	7924:	5248=	5251=
U 0010		2218=	7982:	2219=	2187 	3321=	3324=	3327=	3330=
U 0020		4010=	4160=	4016=	4019=	7983=	4161=	7984=	4022=
U 0030		3595=	4188=	3599=	4529=	3603=	4189=	3607=	4530=
U 0040		2390:	2394:	2398:	2406:	2416:	2419:	2426:	2430:
U 0050		2443:	2449:	2470:	2188 	4451=	4453=	4487=	4488=
U 0060		3667=	2189 	5081=	5482=	3670=	3672=	5088=	7650=
U 0070		4791=	2192 	4795=	5483=	4799=	4455=	4802=	7651=

U 0100		2196 	2277=	2280=	2283=	7909=	2284=	2197 	2288=
U 0110		2199 	2295=	2298=	2301=	7911=	2302=	7913=	2307=
U 0120		4215=	4217=	4308=	4312=	4218=	2202 	4316=	4320=
U 0130		3867=	2204 	5728=	5730=	3870=	3874=	7076:	7091:
U 0140		2227=	2230=	4326=	4330=	5407=	5408=	4334=	4338=
U 0150		3587=	2238=	3588=	5638=	5410=	5412=	5414=	5415=
U 0160		4371=	4374=	2206 	5362=	4377=	4378=	4380=	5364=
U 0170		5964=	4224=	5966=	5639=	5967=	4225=	5968=	5416=

U 0200		5821=	2328=	5823=	2334=	5825=	2340=	5827=	2345=
U 0210		5829=	2353=	2207 	2357=	2209 	2367=	5830=	2371=
U 0220		3745=	3747=	3749=	2210 	2223=	2224=	2211 	7686=
U 0230		6932=	6884=	6933=	6885=	6934=	2212 	6935=	7687=
U 0240		4730=	4731=	2213 	5709=	2214 	4732=	6573=	6574=
U 0250		3362=	3365=	3368=	3371=	3374=	3377=	3380=	3383=
U 0260		2267=	2268=	5562=	5710=	4759=	4762=	5563=	4763=
U 0270		3465=	3468=	3471=	3474=	3477=	3480=	3483=	3486=

U 0300		3622=	3626=	5567=	3628=	7418=	7419=	5568=	3629=
U 0310		4053=	2215 	4055=	4058=	4006=	7421=	4008=	3630=
U 0320		3642=	3643=	5871=	2216 	2220 	3644=	5873=	5547=
U 0330		4396=	4398=	6732=	4401=	2221 	3646=	6733=	5549=
U 0340		4827=	4830=	4831=	2254 	4832=	4833=	2256 	4834=
U 0350		4769=	4770=	4771=	4772=	4473=	4513=	4474=	4514=
U 0360		4923=	4924=	4925=	2315 	4926=	4927=	2377 	4928=
U 0370		4553=	2382 	2435=	2437=	4554=	4555=	4556=	4557=

U 0400		4075:	2400 	2452=	2455=	2471=	2472=	2403 	5565=
U 0410		4234=	4236=	2493=	2494=	4237=	2408 	2420 	5566=
U 0420		5520=	5521=	5522=	5523=	5524=	5525=	5526=	5527=
U 0430		5528=	2422 	2457 	5621=	2575=	2578=	5529=	5622=
U 0440		5540=	6360=	5541=	6362=	5542=	2458 	5543=	6363=
U 0450		5544=	2461 	2462 	5655=	3027=	3031=	5545=	5656=
U 0460		6217=	6219=	5875=	5879=	6221=	6223=	5882=	2464 
U 0470		7541=	2467 	5645=	5647=	7543=	7545=	5648=	5649=

U 0500		6032=	6034=	3057=	3058=	6036=	6038=	2628 	6040=
U 0510		6418=	2758 	2764 	5768=	3076=	3077=	6419=	5769=
U 0520		5782=	5783=	5785=	5786=	5788=	5789=	5791=	5792=
U 0530		5794=	2823 	2828 	6857=	3107=	3108=	5795=	6859=
U 0540		6113=	6115=	6117=	4244=	3111=	3112=	6120=	4246=
U 0550		4849=	4483=	4850=	4484=	3124=	3125=	5975=	5976=
U 0560		6251=	6254=	6410=	4267=	2943 	6255=	6411=	4269=
U 0570		5052=	5054=	3009 	5058=	6011=	6012=	6014=	6017=

; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 314
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 0600		6257=	6260=	3131=	3133=	3022 	6261=	6617=	6618=
U 0610		5253=	5255=	3025 	5256=	3137=	3139=	6209=	6212=
U 0620		6268=	6269=	6273=	5678=	3144=	3146=	6274=	5682=
U 0630		5273=	5275=	3041 	5276=	3150=	3152=	6416=	6417=
U 0640		6397=	6399=	3179=	3180=	3183=	3185=	3043 	6400=
U 0650		5833=	3044 	5835=	5837=	6501=	6502=	6503=	6504=
U 0660		4745=	6516=	4747=	6519=	5010=	6521=	5011=	6523=
U 0670		5020=	6525=	5021=	6528=	5241=	6531=	5242=	6533=

U 0700		6594=	3046 	6598=	6600=	6601=	6604=	3049 	6606=
U 0710		6541=	6543=	6545=	6548=	6549=	6551=	6770=	6771=
U 0720		5324=	6808=	5325=	6810=	5466=	6814=	5467=	6818=
U 0730		5468=	6822=	5469=	6826=	5756=	6830=	5757=	6834=
U 0740		6639=	6641=	3425=	3426=	3489=	3490=	6643=	3060 
U 0750		6061=	6063=	3078 	6065=	6847=	6850=	6852=	6854=
U 0760		6664=	6665=	3493=	3494=	3614=	3615=	6666=	3079 
U 0770		7489=	7490=	7491=	7492=	7493=	7494=	7495=	7496=

U 1000		8394=	8397=	8399=	8401=	3619=	3620=	3105 	8403=
U 1010		8411=	8412=	5683=	7631=	3113 	8413=	5684=	7633=
U 1020		6079=	6081=	6083=	6084=	3663=	3664=	3114 	7659=
U 1030		6123=	6124=	5695=	6125=	3676=	3677=	5696=	7660=
U 1040		8457=	8460=	8462=	8464=	3693=	3697=	3128 	8468=
U 1050		6156=	6158=	6159=	3148 	5760=	7728=	5761=	7730=
U 1060		8297=	8299=	5702=	8303=	3153 	8305=	5707=	8307=
U 1070		8309=	8311=	8313=	8315=	6165=	6167=	6168=	3177 

U 1100		8850=	8852=	8854=	8856=	8858=	8860=	8862=	8864=
U 1110		8866=	8867=	8868=	8870=	6232=	6234=	6235=	3335 
U 1120		6766=	6767=	6768=	3336 	7350=	7353=	3441 	7355=
U 1130		7372=	7374=	7375=	3442 	7756=	7759=	7762=	7764=
U 1140		8473=	8476=	8478=	8483=	8503=	8506=	3590 	8516=
U 1150		8653=	8654=	3733=	3737=	8656=	3611 	3769=	3773=
U 1160		8822=	8823=	8824=	3616 	3794=	3797=	3815=	3820=
U 1170		3823=	3825=	3829=	3830=	3985=	3989=	3995=	3998=

U 1200		4001=	4004=	4030=	4032=	4035=	4039=	4129=	4130=
U 1210		4139=	4141=	4144=	4145=	4162=	4163=	4168=	4169=
U 1220		4171=	4172=	4192=	4193=	4194=	4196=	4249=	4250=
U 1230		4257=	4258=	4359=	4361=	4386=	4389=	4407=	4411=
U 1240		4413=	4415=	4429=	4431=	4433=	4434=	4443=	4444=
U 1250		4459=	4460=	4462=	4463=	4466=	4467=	4468=	4469=
U 1260		4477=	4478=	4493=	4494=	4503=	4504=	4521=	4522=
U 1270		4572=	4573=	4574=	4575=	4581=	4582=	4591=	4592=

U 1300		4595=	4596=	4620=	4623=	4637=	4641=	4653=	4654=
U 1310		4658=	4659=	4663=	4664=	4679=	4681=	4685=	4686=
U 1320		4981=	4984=	5000=	5002=	5005=	5006=	5036=	5037=
U 1330		5071=	5073=	5100=	5103=	5136=	5138=	5164=	5171=
U 1340		5175=	5178=	5180=	5182=	5187=	5192=	5204=	5205=
U 1350		5289=	5290=	5329=	5330=	5333=	5334=	5338=	5339=
U 1360		5358=	5359=	5388=	5389=	5391=	5392=	5397=	5398=
U 1370		5400=	5401=	5404=	5405=	5429=	5430=	5433=	5434=

; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 315
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 1400		2264:	2265:	2605:	2608:	2611:	2615:	2625:	2725:
U 1410		2727:	2752:	2754:	2757:	2760:	2763:	2766:	2772:
U 1420		2774:	2776:	2779:	2786:	2781:	2783:	2788:	2790:
U 1430		2793:	3440:	2795:	2797:	2807:		2808:	3456:
U 1440		3509:	2840:	2850:	2860:	2875:	2892:	2902:	2912:
U 1450		2922:	2932:	2942:	2953:	2963:	2973:	2983:	4124:
U 1460		7612:	7616:	3053:	7613:	3103:	3104:	3122:	5951:
U 1470		3175:	3176:	3305:	3307:	3310:	3313:	3406:	3424:

U 1500						2521:	2526:	2532:	
U 1510						2553:	2558:	2564:	2570:
U 1520		3561:	3562:	3564:	3565:	3566:	3569:	3570:	3571:
U 1530		3573:	3574:	3576:	3577:	3578:	3579:	3580:	3581:
U 1540		3637:	3687:	3537:	3714:	3727:	3756:	3789:	3547:
U 1550		3842:	3807:	3849:	8263:	3864:	3879:	3980:	4070:
U 1560		4097:	4111:				2817:	4207:	2822:
U 1570		5357:	4184:			5385:		5319:	5322:

U 1600		4355:	4364:						
U 1610		4728:	3523:	3003:	3006:	7601:	4136:	5428:	7602:
U 1620		4736:	5449:	3017:	3019:	4740:	4741:	5465:	4425:
U 1630		4750:	5667:	3038:	3040:	4752:	5583:	5726:	5586:
U 1640		5152:	4157:	5154:	5157:	7627:			7629:
U 1650		7863:	7869:	7872:	7874:	7876:	7878:	7880:	7882:
U 1660		3970:	3958:	3960:	3962:	3964:	3972:	3966:	3968:
U 1670									

U 1700		7081:	7039:	7040:	7041:	7094:	7128:	7042:	7043:
U 1710		7045:	7046:	7047:	7048:	7401:	7398:	7049:	7050:
U 1720		7053:	7255:	7446:	7153:	7215:	7246:	7054:	7055:
U 1730		7058:	7059:	7060:	7061:	7062:	7063:	7064:	7065:
U 1740		5919:	5921:	5923:	5925:	5927:		5929:	5931:
U 1750		5933:	5935:			7894:	7902:		
U 1760		7277:	7279:	7281:	7283:	7361:	7393:	7285:	7286:
U 1770		7289:	7293:	7297:	7301:	7345:	7385:	7305:	7309:

U 2000		5436=	5437=	5444=	5445=	5452=	5453=	5474=	5475=
U 2010		5478=	5479=	5485=	5486=	5487=	5489=	5532=	5533=
U 2020		5536=	5538=	5551=	5552=	5553=	5554=	5591=	5593=
U 2030		5596=	5598=	5602=	5603=	5610=	5611=	5652=	5653=
U 2040		5670=	5671=	5692=	5693=	5713=	5714=	5716=	5718=
U 2050		5733=	5734=	5743=	5744=	5752=	5753=	5754=	5755=
U 2060		5771=	5772=	5804=	5805=	5809=	5810=	5814=	5816=
U 2070		5841=	5842=	5849=	5850=	5859=	5860=	5978=	5980=

U 2100		5953=	5996=	6000=	6003=	5955=	5997=	6005=	6006=
U 2110		6022=	6098=	6023=	6099=	6048=	6050=	6054=	6055=
U 2120		6069=	6071=	6074=	6076=	6087=	6089=	6138=	6139=
U 2130		6134=	6136=	6142=	6144=	6135=	6137=	6152=	6153=
U 2140		6179=	6180=	6186=	6189=	6201=	6335=	6202=	6337=
U 2150		6204=	6207=	6225=	6229=	6239=	6240=	6243=	6245=
U 2160		6279=	6280=	6292=	6293=	6296=	6297=	6300=	6301=
U 2170		6306=	6308=	6309=	6311=	6319=	6320=	6330=	6331=

; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 316
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 2200		6340=	6342=	6348=	6349=	6344=	6461=	6346=	6463=
U 2210		6354=	6357=	6367=	6368=	6372=	6373=	6378=	6379=
U 2220		6381=	6385=	6423=	6424=	6428=	6429=	6435=	6436=
U 2230		6437=	6438=	6439=	6440=	6457=	6458=	6464=	6465=
U 2240		6471=	6472=	6477=	6479=	6498=	6499=	6506=	6507=
U 2250		6493=	8419=	6512=	6513=	6494=	8420=	6539=	6540=
U 2260		6564=	6567=	6581=	6582=	6591=	6914=	6592=	6915=
U 2270		6611=	6612=	6632=	6634=	6656=	6658=	6660=	6661=

U 2300		6678=	6680=	6701=	6705=	6707=	6709=	6736=	6737=
U 2310		6790=	6791=	6795=	6797=	6841=	6843=	6863=	6865=
U 2320		6880=	6881=	6890=	6894=	6909=	6912=	6966=	6967=
U 2330		6926=	7326=	6927=	7328=	6974=	6975=	6982=	6983=
U 2340		6985=	6986=	7012=	7020=	7029=	7030=	7102=	7103=
U 2350		7104=	7105=	7107=	7108=	7109=	7110=	7112=	7113=
U 2360		7163=	7168=	7183=	7189=	7198=	7202=	7217=	7220=
U 2370		7223=	7224=	7232=	7233=	7248=	7249=	7256=	7258=

U 2400		7265=	7266=	7323=	7324=	7334=	7335=	7366=	7367=
U 2410		7402=	7403=	7404=	7405=	7408=	7409=	7410=	7411=
U 2420		7412=	7413=	7414=	7415=	7416=	7417=	7449=	7451=
U 2430		7457=	7458=	7462=	7464=	7470=	7472=	7511=	7514=
U 2440		7515=	7516=	7527=	7528=	7538=	7539=	7555=	7557=
U 2450		7559=	7561=	7563=	7565=	7569=	7570=	7584=	7585=
U 2460		7588=	7589=	7646=	7647=	7655=	7658=	7665=	7667=
U 2470		7671=	7673=	7684=	7685=	7691=	7692=	7697=	7699=

U 2500		7703=	7705=	7716=	7717=	7720=	7722=	7725=	7726=
U 2510		7735=	7736=	7742=	7743=	7770=	7771=	7776=	7777=
U 2520		7917=	7918=	7929=	7930=	7933=	7937=	7990=	7992=
U 2530		8000=	8003=	8001=	8004=	8005=	8007=	8006=	8008=
U 2540		8010=	8013=	8011=	8014=	8016=	8019=	8017=	8020=
U 2550		8022=	8024=	8023=	8025=	8270=	8271=	8332=	8335=
U 2560		8346=	8348=	8357=	8361=	8370=	8372=	8375=	8378=
U 2570		8383=	8385=	8405=	8407=	8425=	8427=	8445=	8454=

U 2600		8430=	8439=	8431=	3649 	3652 	8441=	8485=	8488=
U 2610		8492=	8493=	8496=	8568=	8520=	8522=	8498=	8577=
U 2620		8523=	8527=	8547=	8549=	8537=	3654 	8539=	3656 
U 2630		8554=	8558=	8582=	8584=	8588=	8591=	8598=	8600=
U 2640		8616=	8618=	8621=	8622=	8659=	8660=	8664=	8665=
U 2650		8684=	8685=	8689=	8690=	8695=	8696=	8699=	8700=
U 2660		8713=	8714=	8722=	8723=	8725=	8726=	8739=	8744=
U 2670		8749=	8752=	8759=	8762=	8772=	8774=	8778=	8781=

U 2700		8784=	8785=	8789=	8791=	8795=	8797=	8801=	8802=
U 2710		8811=	8814=	8834=	8836=	8838=	8839=	8842=	8843=
U 2720		8845=	3658 	8876=	8877=	8882=	8886=	8889=	8893=
U 2730		8902=	8903=	8910=	8911=	3678 	3700 	3722 	3740 
U 2740		3759 	3764 	3778 	3783 	3793 	3810 	3845 	3851 
U 2750		3853 	3857 	3865 	3880 	3882 	3885 	3982 	4024 
U 2760		4025 	4027 	4041 	4046 	4063 	4066 	4078 	4080 
U 2770		4084 	4132 	4143 	4158 	4166 	4185 	4186 	4190 

; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 317
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 3000		4208 	4210 	4227 	4228 	4239 	4248 	4251 	4252 
U 3010		4253 	4254 	4256 	4262 	4263 	4264 	4271 	4287 
U 3020		4290 	4302 	4357 	4365 	4366 	4368 	4391 	4393 
U 3030		4427 	4436 	4437 	4440 	4445 	4446 	4448 	4472 
U 3040		4475 	4476 	4479 	4485 	4491 	4492 	4496 	4498 
U 3050		4499 	4501 	4506 	4507 	4509 	4510 	4516 	4519 
U 3060		4524 	4532 	4571 	4577 	4578 	4584 	4585 	4586 
U 3070		4587 	4588 	4593 	4597 	4598 	4601 	4631 	4649 

U 3100		4651 	4656 	4661 	4666 	4667 	4668 	4675 	4677 
U 3110		4684 	4755 	4756 	4775 	4776 	4784 	4786 	4807 
U 3120		4811 	4844 	4853 	4856 	4857 	4858 	4861 	4862 
U 3130		4863 	4930 	4931 	4934 	4937 	4938 	4939 	4940 
U 3140		4942 	4945 	4948 	4949 	4950 	4952 	4977 	4987 
U 3150		4988 	4991 	4993 	4995 	5014 	5015 	5016 	5017 
U 3160		5023 	5031 	5061 	5075 	5078 	5079 	5091 	5093 
U 3170		5096 	5105 	5132 	5139 	5140 	5142 	5144 	5145 

U 3200		5159 	5174 	5197 	5199 	5202 	5210 	5214 	5216 
U 3210		5218 	5246 	5259 	5261 	5262 	5263 	5265 	5267 
U 3220		5268 	5269 	5271 	5280 	5282 	5283 	5286 	5287 
U 3230		5288 	5293 	5326 	5327 	5328 	5336 	5360 	5365 
U 3240		5368 	5393 	5394 	5395 	5418 	5441 	5450 	5451 
U 3250		5471 	5555 	5584 	5589 	5604 	5608 	5609 	5612 
U 3260		5617 	5619 	5624 	5626 	5627 	5640 	5642 	5657 
U 3270		5672 	5673 	5677 	5685 	5691 	5697 	5711 	5712 

U 3300		5715 	5735 	5739 	5742 	5745 	5746 	5749 	5764 
U 3310		5798 	5801 	5811 	5839 	5844 	5846 	5852 	5957 
U 3320		5959 	5961 	5962 	5970 	6008 	6019 	6020 	6025 
U 3330		6046 	6052 	6053 	6056 	6068 	6085 	6092 	6095 
U 3340		6096 	6097 	6100 	6101 	6103 	6109 	6110 	6127 
U 3350		6128 	6154 	6161 	6162 	6163 	6171 	6172 	6173 
U 3360		6174 	6175 	6176 	6181 	6182 	6195 	6197 	6199 
U 3370		6213 	6238 	6241 	6264 	6282 	6285 	6287 	6295 

U 3400		6298 	6303 	6305 	6312 	6321 	6332 	6333 	6352 
U 3410		6374 	6376 	6386 	6387 	6389 	6390 	6391 	6392 
U 3420		6393 	6396 	6402 	6407 	6414 	6420 	6421 	6422 
U 3430		6425 	6426 	6427 	6442 	6446 	6466 	6468 	6473 
U 3440		6474 	6495 	6496 	6510 	6559 	6560 	6562 	6584 
U 3450		6585 	6621 	6627 	6628 	6629 	6630 	6648 	6669 
U 3460		6671 	6681 	6684 	6689 	6690 	6691 	6692 	6693 
U 3470		6695 	6698 	6710 	6713 	6715 	6717 	6718 	6735 

U 3500		6776 	6779 	6784 	6786 	6861 	6883 	6886 	6888 
U 3510		6907 	6925 	6928 	6930 	6937 	6938 	6952 	6954 
U 3520		6959 	6969 	6970 	6978 	6980 	6988 	6990 	6992 
U 3530		6993 	6994 	6996 	6999 	7003 	7005 	7023 	7026 
U 3540		7067 	7068 	7070 	7096 	7097 	7098 	7100 	7101 
U 3550		7106 	7115 	7117 	7120 	7122 	7125 	6947:	6948:
U 3560		7130 	7133 	7136 	7137 	7139 	7141 	7156 	7172 
U 3570		7176 	7194 	7205 	7207 	7212 	7221 	7222 	7225 

; CRAM4K.MCR[1,2]	11:20 17-APR-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 318
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 3600		7230 	7231 	7252 	7261 	7262 	7267 	7290 	7291 
U 3610		7294 	7295 	7298 	7299 	7302 	7303 	7306 	7307 
U 3620		7316 	7318 	7319 	7320 	7329 	7331 	7336 	7337 
U 3630		7340 	7347 	7358 	7362 	7363 	7365 	7369 	7377 
U 3640		7378 	7379 	7386 	7387 	7389 	7406 	7407 	7429 
U 3650		7430 	7431 	7433 	7439 	7440 	7447 	7452 	7465 
U 3660		7474 	7477 	7497 	7498 	7499 	7500 	7501 	7502 
U 3670		7503 	7506 	7507 	7508 	7518 	7520 	7523 	7525 

U 3700		7526 	7530 	7553 	7567 	7571 	7574 	7587 	7636 
U 3710		7689 	7718 	7733 	7734 	7738 	7745 	7752 	7767 
U 3720		7783 	7785 	7787 	7789 	7791 	7793 	7795 	7797 
U 3730		7799 	7801 	7897 	7904 	7915 	7988 	7994 	7996 
U 3740		6133:	6490:	6194:	6327:	5993:	7999 	8002 	8009 
U 3750		8012 	6491:	8015 	8018 	5994:	8021 	8026 	8027 
U 3760		8028 	8030 	8264 	8266 	8267 	8268 	8269 	8289 
U 3770		8290 	8291 	8293 	8319 	8320 	8321 	8325 	8283:

U 4000		8328 	8329 	8340 	8342 	8352 	8388 	8390 	8517 
U 4010		8543 	8592 	8595 	8596 	8602 	8604 	8609 	8611 
U 4020		8613 	8614 	8615 	8623 	8624 	8625 	8628 	8632 
U 4030		8651 	8677 	8679 	8681 	8710 	8724 	8735 	8764 
U 4040		8766 	8782 	8806 	8809 	8816 	8818 	8827 	8830 
U 4050		8840 	8879 	8896 	8900 	8916 	8918 		
U 4060 - 7767 Unused
U 7770									8288:

No errors detected
End of microcode assembly
323 pages of listing
Used 2.77 seconds, 120 pages of core
  Symbol table: 31P
  Text strings: 9P
  Loc'n assignment: 19P
  Cross reference: 53P
