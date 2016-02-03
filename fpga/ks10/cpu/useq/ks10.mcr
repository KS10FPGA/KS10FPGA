; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 1
; 								Table of Contents					

; 1		CRAM4K.MIC[1,2]	13:05 16-APR-2015
; 13		KS10.MIC[1,2]	23:44 29-MAY-2015
; 71	REVISION HISTORY
; 198	HOW TO READ THE MICROCODE
; 403	CONDITIONAL ASSEMBLY DEFINITIONS
; 468	2901 REGISTER USAGE
; 504	MICROCODE FIELDS -- LISTING FORMAT
; 552	MICROCODE FIELDS -- DATAPATH CHIP
; 704	MICROCODE FIELDS -- RAM FILE ADDRESS AND D-BUS
; 738	MICROCODE FIELDS -- PARITY GENERATION & HALF WORD CONTROL
; 761	MICROCODE FIELDS -- SPEC
; 864	MICROCODE FIELDS -- DISPATCH
; 908	MICROCODE FIELDS -- SKIP
; 959	MICROCODE FIELDS -- TIME CONTROL
; 979	MICROCODE FIELDS -- RANDOM CONTROL BITS
; 1001	MICROCODE FIELDS -- NUMBER FIELD
; 1345	DISPATCH ROM DEFINITIONS
; 1391	HOW TO READ MACROS
; 1550	MACROS -- DATA PATH CHIP -- GENERAL
; 1700	MACROS -- DATA PATH CHIP -- Q
; 1735	MACROS -- DATA PATH CHIP -- MISC.
; 1756	MACROS -- STORE IN AC
; 1788	MACROS -- MICROCODE WORK SPACE
; 1815	MACROS -- MEMORY CONTROL
; 1865	MACROS -- VMA
; 1882	MACROS -- TIME CONTROL
; 1895	MACROS -- SCAD, SC, FE LOGIC
; 1978	MACROS -- DATA PATH FIELD CONTROL
; 1994	MACROS -- SHIFT PATH CONTROL
; 2007	MACROS -- SPECIAL FUNCTIONS
; 2038	MACROS -- PC FLAGS
; 2067	MACROS -- PAGE FAIL FLAGS
; 2075	MACROS -- SINGLE SKIPS
; 2100	MACROS -- SPECIAL DISPATCH MACROS
; 2134	DISPATCH ROM MACROS
; 2175		SIMPLE.MIC[1,2]	16:49 11-NOV-1985
; 2177	POWER UP SEQUENCE
; 2259	THE INSTRUCTION LOOP -- START NEXT INSTRUCTION
; 2383	THE INSTRUCTION LOOP -- FETCH ARGUMENTS
; 2495	THE INSTRUCTION LOOP -- STORE ANSWERS
; 2579	MOVE GROUP
; 2616	EXCH
; 2631	HALFWORD GROUP
; 2798	DMOVE, DMOVN, DMOVEM, DMOVNM
; 2829	BOOLEAN GROUP
; 2984	ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO
; 3080	ROTATES AND LOGICAL SHIFTS -- LSHC
; 3115	ROTATES AND LOGICAL SHIFTS -- ASHC
; 3154	ROTATES AND LOGICAL SHIFTS -- ROTC
; 3186	TEST GROUP
; 3338	COMPARE -- CAI, CAM
; 3407	ARITHMETIC SKIPS -- AOS, SOS, SKIP
; 3457	CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ
; 3548	AC DECODE JUMPS -- JRST, JFCL
; 3638	EXTENDED ADDRESSING INSTRUCTIONS
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 2
; 								Table of Contents					

; 3679	XCT
; 3701	STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ
; 3798	STACK INSTRUCTIONS -- ADJSP
; 3831	SUBROUTINE CALL/RETURN -- JSR, JSP, JSA, JRA
; 3886	ILLEGAL INSTRUCTIONS AND UUO'S
; 4085	ARITHMETIC -- ADD, SUB
; 4114	ARITHMETIC -- DADD, DSUB
; 4147	ARITHMETIC -- MUL, IMUL
; 4198	ARITHMETIC -- DMUL
; 4339	ARITHMETIC -- DIV, IDIV
; 4416	ARITHMETIC -- DDIV
; 4537	ARITHMETIC -- DIVIDE SUBROUTINE
; 4602	ARITHMETIC -- DOUBLE DIVIDE SUBROUTINE
; 4642	ARITHMETIC -- SUBROUTINES FOR ARITHMETIC
; 4688	BYTE GROUP -- IBP, ILDB, LDB, IDPB, DPB
; 4765	BYTE GROUP -- INCREMENT BYTE POINTER SUBROUTINE
; 4778	BYTE GROUP -- BYTE EFFECTIVE ADDRESS EVALUATOR
; 4812	BYTE GROUP -- LOAD BYTE SUBROUTINE
; 4865	BYTE GROUP -- DEPOSIT BYTE IN MEMORY
; 4953	BYTE GROUP -- ADJUST BYTE POINTER
; 5112	BLT
; 5220	UBABLT - BLT BYTES TO/FROM UNIBUS FORMAT
; 5294		FLT.MIC[1,2]	01:46 20-MAR-1981
; 5295	FLOATING POINT -- FAD, FSB
; 5340	FLAOTING POINT -- FMP
; 5369	FLOATING POINT -- FDV
; 5419	FLOATING POINT -- FLTR, FSC
; 5454	FLOATING POINT -- FIX AND FIXR
; 5491	FLOATING POINT -- SINGLE PRECISION NORMALIZE
; 5558	FLOATING POINT -- ROUND ANSWER
; 5569	FLOATING POINT -- DFAD, DFSB
; 5658	FLOATING POINT -- DFMP
; 5719	FLOATING POINT -- DFDV
; 5773	FLOATING POINT -- DOUBLE PRECISION NORMALIZE
; 5883		EXTEND.MIC[1,2]	11:35 26-JULY-1984
; 5884	EXTEND -- DISPATCH ROM ENTRIES
; 5939	EXTEND -- INSTRUCTION SET DECODING
; 5981	EXTEND -- MOVE STRING -- SETUP
; 6026	EXTEND -- MOVE STRING -- OFFSET/TRANSLATE
; 6057	EXTEND -- MOVE STRING -- MOVSRJ
; 6105	EXTEND -- MOVE STRING -- SIMPLE MOVE LOOP
; 6129	EXTEND -- COMPARE STRING
; 6190	EXTEND -- DECIMAL TO BINARY CONVERSION
; 6322	EXTEND -- BINARY TO DECIMAL CONVERSION
; 6480	EXTEND -- EDIT -- MAIN LOOP
; 6534	EXTEND -- EDIT -- DECODE OPERATE GROUP
; 6553	EXTEND -- EDIT -- STOP EDIT
; 6568	EXTEND -- EDIT -- START SIGNIFICANCE
; 6575	EXTEND -- EDIT -- EXCHANGE MARK AND DESTINATION
; 6586	EXTEND -- EDIT -- PROCESS SOURCE BYTE
; 6649	EXTEND -- EDIT -- MESSAGE BYTE
; 6672	EXTEND -- EDIT -- SKIP
; 6686	EXTEND -- EDIT -- ADVANCE PATTERN POINTER
; 6719	EXTEND SUBROUTINES -- FILL OUT DESTINATION
; 6743	EXTEND SUBROUTINES -- GET MODIFIED SOURCE BYTE
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 3
; 								Table of Contents					

; 6780	EXTEND SUBROUTINES -- TRANSLATE
; 6866	EXTEND SUBROUTINES -- GET UNMODIFIED SOURCE BYTE
; 6895	EXTEND SUBROUTINES -- STORE BYTE IN DESTINATION STRING
; 6916	EXTEND SUBROUTINES -- UPDATE DEST STRING POINTERS
; 6960	EXTEND -- PAGE FAIL CLEANUP
; 6999		INOUT.MIC[1,2]	13:32 7-JAN-1986
; 7000	TRAPS
; 7031	IO -- INTERNAL DEVICES
; 7142	IO -- INTERNAL DEVICES -- EBR & UBR
; 7268	IO -- INTERNAL DEVICES -- KL PAGING REGISTERS
; 7310	IO -- INTERNAL DEVICES -- TIMER CONTROL
; 7341	IO -- INTERNAL DEVICES -- WRTIME & RDTIME
; 7380	IO -- INTERNAL DEVICES -- WRINT & RDINT
; 7394	IO -- INTERNAL DEVICES -- RDPI & WRPI
; 7434	IO -- INTERNAL DEVICES -- SUBROUTINES
; 7575	PRIORITY INTERRUPTS -- DISMISS SUBROUTINE
; 7590	EXTERNAL IO INSTRUCTIONS
; 7778	SMALL SUBROUTINES
; 7802	UNDEFINED IO INSTRUCTIONS
; 7883	UMOVE AND UMOVEM
; 7938	WRITE HALT STATUS BLOCK
; 8030		PAGEF.MIC[1,2]	11:16 17-APR-2015
; 8032	PAGE FAIL REFIL LOGIC
;	Cross Reference Index
;	DCODE Location / Line Number Index
;	UCODE Location / Line Number Index
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 4
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
							; 13	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 5
; KS10.MIC[1,2]	23:44 29-MAY-2015					CRAM4K.MIC[1,2]	13:05 16-APR-2015		

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
							; 69	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 5-1
; KS10.MIC[1,2]	23:44 29-MAY-2015					CRAM4K.MIC[1,2]	13:05 16-APR-2015		

							; 70	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 6
; KS10.MIC[1,2]	23:44 29-MAY-2015				REVISION HISTORY					

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
							; 124	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 7
; KS10.MIC[1,2]	23:44 29-MAY-2015				REVISION HISTORY					

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
							; 180	;	PASSAGE OF TIME.; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 7-1
; KS10.MIC[1,2]	23:44 29-MAY-2015				REVISION HISTORY					

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
							; 197	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 8
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ THE MICROCODE				

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
							; 248	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 9
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ THE MICROCODE				

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
							; 298	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 10
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ THE MICROCODE				

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
							; 354	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 11
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ THE MICROCODE				

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
							; 402	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 12
; KS10.MIC[1,2]	23:44 29-MAY-2015				CONDITIONAL ASSEMBLY DEFINITIONS			

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
							; 458	;CONFIGURE THE MICROCODE REGIONS.   KEEP STUFF OUT OF DROM SPACE; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 12-1
; KS10.MIC[1,2]	23:44 29-MAY-2015				CONDITIONAL ASSEMBLY DEFINITIONS			

							; 459	
							; 460	.IF/CRAM4K
							; 461		.REGION/0,1377/2000,7777/1400,1777
							;;462	.IFNOT/CRAM4K
							;;463		.REGION/0,1377/2000,3777/1400,1777
							; 464	.ENDIF/CRAM4K
							; 465	
							; 466	
							; 467	
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 13
; KS10.MIC[1,2]	23:44 29-MAY-2015				2901 REGISTER USAGE					

							; 468	.TOC	"2901 REGISTER USAGE"
							; 469	
							; 470	;	!=========================================================================!
							; 471	;0:	!                   MAG (ONES IN BITS 1-36, REST ZERO)                    !
							; 472	;	!-------------------------------------------------------------------------!
							; 473	;1:	!                 PC (ADDRESS OF CURRENT INSTRUCTION + 1)                 !
							; 474	;	!-------------------------------------------------------------------------!
							; 475	;2:	!                        HR (CURRENT INSTRUCTION)                         !
							; 476	;	!-------------------------------------------------------------------------!
							; 477	;3:	!                    AR (TEMP -- MEM OP AT INST START)                    !
							; 478	;	!-------------------------------------------------------------------------!
							; 479	;4:	!               ARX (TEMP -- LOW ORDER HALF OF DOUBLE PREC)               !
							; 480	;	!-------------------------------------------------------------------------!
							; 481	;5:	!                                BR (TEMP)                                !
							; 482	;	!-------------------------------------------------------------------------!
							; 483	;6:	!           BRX (TEMP -- LOW ORDER HALF OF DOUBLE PREC BR!BRX)            !
							; 484	;	!-------------------------------------------------------------------------!
							; 485	;7:	!                          ONE (THE CONSTANT 1)                           !
							; 486	;	!-------------------------------------------------------------------------!
							; 487	;10:	!                        EBR (EXEC BASE REGISTER)                         !
							; 488	;	!-------------------------------------------------------------------------!
							; 489	;11:	!                        UBR (USER BASE REGISTER)                         !
							; 490	;	!-------------------------------------------------------------------------!
							; 491	;12:	!           MASK (ONES IN BITS 0-35, ZERO IN -1, -2, 36 AND 37)           !
							; 492	;	!-------------------------------------------------------------------------!
							; 493	;13:	!          FLG (FLAG BITS)           !           PAGE FAIL CODE           !
							; 494	;	!-------------------------------------------------------------------------!
							; 495	;14:	!                  PI (PI SYSTEM STATUS REGISTER [RDPI])                  !
							; 496	;	!-------------------------------------------------------------------------!
							; 497	;15:	!                       XWD1 (1 IN EACH HALF WORD)                        !
							; 498	;	!-------------------------------------------------------------------------!
							; 499	;16:	!                                T0 (TEMP)                                !
							; 500	;	!-------------------------------------------------------------------------!
							; 501	;17:	!                                T1 (TEMP)                                !
							; 502	;	!=========================================================================!
							; 503	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 14
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- LISTING FORMAT			

							; 504		.TOC	"MICROCODE FIELDS -- LISTING FORMAT"
							; 505	
							; 506	;								; 3633	1561:
							; 507	;								; 3634	SUB:	[AR]_AC-[AR],
							; 508	;								; 3635		AD FLAGS, 3T,
							; 509	;	U 1561, 1500,2551,0303,0274,4463,7701,4200,0001,0001	; 3636		EXIT
							; 510	;	  [--]  [--] !!!! [][] !!![-][][-][]! !!!     [----]
							; 511	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!!        !
							; 512	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!!        +---- # (MAGIC NUMBER)
							; 513	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!!      
							; 514	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!+------------- MULTI PREC, MULTI SHIFT, CALL (4S, 2S, 1S)
							; 515	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !!
							; 516	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !+-------------- FM WRITE, MEM, DIVIDE (4S, 2S, 1S)
							; 517	;	  !     !    !!!! ! !  !!!!  ! !  ! ! !
							; 518	;	  !     !    !!!! ! !  !!!!  ! !  ! ! +--------------- CRY38, LOAD SC, LOAD FE (4S, 2S, 1S)
							; 519	;	  !     !    !!!! ! !  !!!!  ! !  ! !
							; 520	;	  !     !    !!!! ! !  !!!!  ! !  ! +----------------- T
							; 521	;	  !     !    !!!! ! !  !!!!  ! !  !
							; 522	;	  !     !    !!!! ! !  !!!!  ! !  +------------------- SKIP
							; 523	;	  !     !    !!!! ! !  !!!!  ! !
							; 524	;	  !     !    !!!! ! !  !!!!  ! +---------------------- DISP
							; 525	;	  !     !    !!!! ! !  !!!!  !
							; 526	;	  !     !    !!!! ! !  !!!!  +------------------------ SPEC
							; 527	;	  !     !    !!!! ! !  !!!!
							; 528	;	  !     !    !!!! ! !  !!!+--------------------------- CLOCKS & PARITY (CLKR, GENR, CHKR, CLKL, GENL, CHKL)
							; 529	;	  !     !    !!!! ! !  !!!
							; 530	;	  !     !    !!!! ! !  !!+---------------------------- DBM
							; 531	;	  !     !    !!!! ! !  !!
							; 532	;	  !     !    !!!! ! !  !+----------------------------- DBUS
							; 533	;	  !     !    !!!! ! !  !
							; 534	;	  !     !    !!!! ! !  +------------------------------ RAM ADDRESS
							; 535	;	  !     !    !!!! ! !
							; 536	;	  !     !    !!!! ! +--------------------------------- B
							; 537	;	  !     !    !!!! !
							; 538	;	  !     !    !!!! +----------------------------------- A
							; 539	;	  !     !    !!!!
							; 540	;	  !     !    !!!+------------------------------------- DEST
							; 541	;	  !     !    !!!
							; 542	;	  !     !    !!+-------------------------------------- RSRC
							; 543	;	  !     !    !!
							; 544	;	  !     !    !+--------------------------------------- LSRC   ]
							; 545	;	  !     !    !                                                ] - AD
							; 546	;	  !     !    +---------------------------------------- ALU    ]
							; 547	;	  !     !
							; 548	;	  !     +--------------------------------------------- J
							; 549	;	  !
							; 550	;	  LOCATION OF THIS MICRO WORD
							; 551	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 15
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- DATAPATH CHIP			

							; 552	.TOC	"MICROCODE FIELDS -- DATAPATH CHIP"
							; 553	
							; 554	J/=<0:11>+              ;CRA1
							; 555				;NEXT MICROCODE ADDRESS
							; 556	
							; 557	;ALU FUNCTIONS
							; 558	
							; 559	;NOTE: THE AD FIELD IS A 2 DIGIT FIELD. THE LEFT DIGIT IS THE
							; 560	; 2901 ALU FUNCTION. THE RIGHT DIGIT IS THE 2901 SRC CODE FOR
							; 561	; THE LEFT HALF. NORMALY THE RIGHT HALF SRC CODE IS THE SAME AS
							; 562	; THE LEFT HALF.
							; 563	AD/=<12:17>D,44       ;DPE1 & DPE2
							; 564		A+Q=00
							; 565		A+B=01
							; 566		0+Q=02
							; 567		0+B=03
							; 568		0+A=04
							; 569		D+A=05
							; 570		D+Q=06
							; 571		0+D=07
							; 572		Q-A-.25=10
							; 573		B-A-.25=11
							; 574		Q-.25=12
							; 575		B-.25=13
							; 576		A-.25=14
							; 577		A-D-.25=15
							; 578		Q-D-.25=16
							; 579		-D-.25=17
							; 580		A-Q-.25=20
							; 581		A-B-.25=21
							; 582		-Q-.25=22
							; 583		-B-.25=23
							; 584		-A-.25=24
							; 585		D-A-.25=25
							; 586		D-Q-.25=26
							; 587		D-.25=27
							; 588		A.OR.Q=30
							; 589		A.OR.B=31
							; 590		Q=32
							; 591		B=33
							; 592		A=34
							; 593		D.OR.A=35
							; 594		D.OR.Q=36
							; 595		D=37
							; 596		A.AND.Q=40
							; 597		A.AND.B=41
							; 598	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 16
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- DATAPATH CHIP			

							; 599	;MORE ALU FUNCTIONS
							; 600	
							; 601		ZERO=42
							; 602	;	ZERO=43
							; 603	;	ZERO=44
							; 604		D.AND.A=45
							; 605		D.AND.Q=46
							; 606	;	ZERO=47
							; 607		.NOT.A.AND.Q=50
							; 608		.NOT.A.AND.B=51
							; 609	;	Q=52
							; 610	;	B=53
							; 611	;	A=54
							; 612		.NOT.D.AND.A=55
							; 613		.NOT.D.AND.Q=56
							; 614	;	ZERO=57
							; 615		A.XOR.Q=60
							; 616		A.XOR.B=61
							; 617	;	Q=62
							; 618	;	B=63
							; 619	;	A=64
							; 620		D.XOR.A=65
							; 621		D.XOR.Q=66
							; 622	;	D=67
							; 623		A.EQV.Q=70
							; 624		A.EQV.B=71
							; 625		.NOT.Q=72
							; 626		.NOT.B=73
							; 627		.NOT.A=74
							; 628		D.EQV.A=75
							; 629		D.EQV.Q=76
							; 630		.NOT.D=77
							; 631	
							; 632	;THIS FIELD IS THE RIGHTMOST 3 BITS OF THE
							; 633	; AD FIELD. IT IS USED ONLY TO DEFAULT THE RSRC 
							; 634	; FIELD.
							; 635	LSRC/=<15:17>         ;DPE1
							; 636	
							; 637	;THIS IS THE SOURCE FOR THE RIGHT HALF OF THE
							; 638	; DATA PATH. IT LETS US MAKE THE RIGHT AND LEFT
							; 639	; HALF WORDS DO SLIGHTLY DIFFERENT THINGS.
							; 640	RSRC/=<18:20>F,LSRC	;DPE2
							; 641		AQ=0		;A  Q
							; 642		AB=1		;A  B
							; 643		0Q=2		;0  Q
							; 644		0B=3		;0  B
							; 645		0A=4		;0  A
							; 646		DA=5		;D  A
							; 647		DQ=6		;D  Q
							; 648		D0=7		;D  0
							; 649	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 17
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- DATAPATH CHIP			

							; 650	;DESTINATION CONTROL
							; 651	;SEE DPE1 AND DPE2 (2'S WEIGHT IS INVERTED ON DPE5)
							; 652	DEST/=<21:23>D,3      ;DPE1 & DPE2
							; 653		A=0		;A REG IS CHIP OUTPUT, AD IS WRITTEN
							; 654				; INTO REG FILE
							; 655		AD=1		;REG FILE GETS AD
							; 656		Q_AD=2		;REG FILE IS NOT LOADED
							; 657		PASS=3		;AD OUTPUT IS CHIP OUTPUT
							; 658				; Q AND REG FILE LEFT ALONE
							; 659		Q_Q*2=4		;ALSO REG FILE GETS AD*2
							; 660		AD*2=5		;AND Q IS LEFT ALONE
							; 661		Q_Q*.5=6	;ALSO REG FILE GETS AD*.5
							; 662		AD*.5=7		;AND Q IS LEFT ALONE
							; 663	
							; 664	;	<24:25>		;UNUSED
							; 665	
							; 666	A/=<26:29>            	;DPE1 & DPE2
							; 667		MAG=0
							; 668		PC=1
							; 669		HR=2
							; 670		AR=3
							; 671		ARX=4
							; 672		BR=5
							; 673		BRX=6
							; 674		ONE=7
							; 675		EBR=10
							; 676		UBR=11
							; 677		MASK=12
							; 678		FLG=13
							; 679		PI=14
							; 680		XWD1=15
							; 681		T0=16
							; 682		T1=17
							; 683	
							; 684	;	<30:31>		;UNUSED
							; 685	
							; 686	B/=<32:35>D,0         ;DPE1 & DPE2
							; 687		MAG=0
							; 688		PC=1
							; 689		HR=2
							; 690		AR=3
							; 691		ARX=4
							; 692		BR=5
							; 693		BRX=6
							; 694		ONE=7
							; 695		EBR=10
							; 696		UBR=11
							; 697		MASK=12
							; 698		FLG=13
							; 699		PI=14
							; 700		XWD1=15
							; 701		T0=16
							; 702		T1=17
							; 703	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 18
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- RAM FILE ADDRESS AND D-BUS		

							; 704	.TOC	"MICROCODE FIELDS -- RAM FILE ADDRESS AND D-BUS"
							; 705	
							; 706	RAMADR/=<36:38>D,4	;DPE6
							; 707		AC#=0		;AC NUMBER
							; 708		AC*#=1		;AC .FN. #
							; 709		XR#=2		;INDEX REGISTER
							; 710		VMA=4		;VIRTUAL MEMORY REFERENCE
							; 711		RAM=6		;VMA SUPPLIES 10-BIT RAM ADDRESS
							; 712		#=7		;ABSOLUTE RAM FILE REFERENCE
							; 713	
							; 714	;	<39:39>
							; 715	
							; 716	;LEFT HALF ON DPE3 AND RIGHT HALF ON DPE4
							; 717	DBUS/=<40:41>D,1      	;DPE3 & DPE4
							; 718		PC FLAGS=0	;PC FLAGS IN LEFT HALF
							; 719		PI NEW=0	;NEW PI LEVEL IN BITS 19-21
							; 720	;	VMA=0		;VMA IN BITS 27-35
							; 721		DP=1		;DATA PATH
							; 722		RAM=2		;CACHE, AC'S AND WORKSPACE
							; 723		DBM=3		;DBM MIXER
							; 724	
							; 725	;LEFT HALF ON DPM1 AND RIGHT HALF ON DPM2
							; 726	DBM/=<42:44>D,7       	;DPM1 & DPM2
							; 727		SCAD DIAG=0	;(LH) SCAD DIAGNOSTIC
							; 728		PF DISP=0	;PAGE FAIL DISP IN BITS 18-21
							; 729		APR FLAGS=0	;APR FLAGS IN BITS 22-35
							; 730		BYTES=1		;5 COPIES OF SCAD 1-7
							; 731		EXP=2		;LH=EXPONENT, RH=TIME FRACTION
							; 732		DP=3		;DATA PATH
							; 733		DP SWAP=4	;DATA PATH SWAPPED
							; 734		VMA=5		;VMA FLAGS,,VMA
							; 735		MEM=6		;MEMORY BUFFER
							; 736		#=7		;NUMBER FIELD IN BOTH HALVES
							; 737	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 19
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- PARITY GENERATION & HALF WORD CONTROL

							; 738	.TOC	"MICROCODE FIELDS -- PARITY GENERATION & HALF WORD CONTROL"
							; 739	
							; 740	AD PARITY OK/=<108>D,0  ;**NOT STORED IN CRAM**
							; 741				;THIS BIT IS A 1 IF THE ALU IS DOING
							; 742					; SOMETHING WHICH DOES NOT INVALIDATE
							; 743					; PARITY. IT DOES NOT APPEAR IN THE
							; 744					; REAL MACHINE. WE JUST USE IT TO SET
							; 745					; THE DEFAULT FOR GENR & GENL
							; 746	
							; 747	CLKL/=<45:45>D,1        ;DPE5
							; 748				;CLOCK THE LEFT HALF OF THE MACHINE
							; 749	GENL/=<46:46>F,AD PARITY OK ;DPE4 FROM CRM2 PARITY EN LEFT H
							; 750				;STORE PARITY FOR 2901 LEFT
							; 751	CHKL/=<47:47>           ;DPE4 FROM CRM2 PARITY CHK LEFT H
							; 752				;CHECK LEFT HALF DBUS PARITY
							; 753	
							; 754	CLKR/=<48:48>D,1        ;DPE5
							; 755				;CLOCK THE RIGHT HALF OF THE MACHINE
							; 756	GENR/=<49:49>F,AD PARITY OK ;DPE4 FROM CRM2 PARITY EN RIGHT H
							; 757				;STORE PARITY FOR 2901 RIGHT
							; 758	CHKR/=<50:50>           ;DPE4 FROM CRM2 PARITY CHK RIGHT H
							; 759				;CHECK RIGHT HALF DBUS PARITY
							; 760	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 20
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- SPEC				

							; 761	.TOC	"MICROCODE FIELDS -- SPEC"
							; 762	
							; 763	
							; 764	;
							; 765	;THE FOLLOWING SPECIAL FUNCTION ARE DECODED ON DPE1, DPE5, AND DPMA:
							; 766	;	!=========================================================================!
							; 767	;	!S!     EFFECT      !    CRA6 SPEC    !    CRA6 SPEC    !    CRA6 SPEC    !
							; 768	;	!P!    ON SHIFT     !      EN 40      !      EN 20      !      EN 10      !
							; 769	;	!E!      PATHS      !  E102 ON DPE5   !  E101 ON DPE5   !  E410 ON DPMA   !
							; 770	;	!C!   (SEE DPE1)    !                 !  E411 ON DPMA   !  E113 ON CRA2   !
							; 771	;	!=========================================================================!
							; 772	;	!0!     NORMAL      !   CRY 18 INH    !    PREVIOUS     !        #        !
							; 773	;	!-------------------------------------------------------------------------!
							; 774	;	!1!      ZERO       !     IR LOAD     !     XR LOAD     !   CLR 1 MSEC    !
							; 775	;	!-------------------------------------------------------------------------!
							; 776	;	!2!      ONES       !     <SPARE>     !     <SPARE>     !  CLR IO LATCH   !
							; 777	;	!-------------------------------------------------------------------------!
							; 778	;	!3!       ROT       !     PI LOAD     !    APR FLAGS    !   CLR IO BUSY   !
							; 779	;	!-------------------------------------------------------------------------!
							; 780	;	!4!      ASHC       !    ASH TEST     !    SET SWEEP    !   PAGE WRITE    !
							; 781	;	!-------------------------------------------------------------------------!
							; 782	;	!5!      LSHC       !    EXP TEST     !     APR EN      !     NICOND      !
							; 783	;	!-------------------------------------------------------------------------!
							; 784	;	!6!       DIV       !    PC FLAGS     !    PXCT OFF     !     PXCT EN     !
							; 785	;	!-------------------------------------------------------------------------!
							; 786	;	!7!      ROTC       !  AC BLOCKS EN   !     MEM CLR     !    MEM WAIT     !
							; 787	;	!=========================================================================!
							; 788	; THE DPM BOARD USES THE SPEC FIELD TO CONTROL THE
							; 789	;  DBM MIXER, AS FOLLOWS:
							; 790	;
							; 791	;	!=====================================!
							; 792	;	!  S  !                               !
							; 793	;	!  P  !        ACTION WHEN DBM        !
							; 794	;	!  E  !          SELECTS DP           !
							; 795	;	!  C  ! GET DP BITS  !  GET SCAD 1-7  !
							; 796	;	!=====================================!
							; 797	;	!  0  !     ALL      !      NONE      !
							; 798	;	!-------------------------------------!
							; 799	;	!  1  !     7-35     !      0-6       !
							; 800	;	!-------------------------------------!
							; 801	;	!  2  !0-6 AND 14-35 !      7-13      !
							; 802	;	!-------------------------------------!
							; 803	;	!  3  !0-13 AND 21-35!     14-20      !
							; 804	;	!-------------------------------------!
							; 805	;	!  4  !0-20 AND 28-35!     21-27      !
							; 806	;	!-------------------------------------!
							; 807	;	!  5  ! 0-27 AND 35  !     28-34      !
							; 808	;	!-------------------------------------!
							; 809	;	!  6  !         SAME AS ZERO          !
							; 810	;	!-------------------------------------!
							; 811	;	!  7  !         SAME AS ZERO          !
							; 812	;	!=====================================!
							; 813	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 21
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- SPEC				

							; 814	;THE SPEC FIELD IS DEFINED AS A 6-BIT FIELD. THE TOP 3 BITS
							; 815	; ARE SPEC SEL A, SPEC SEL B, AND SPEC SEL C. THE LOW 3 BITS ARE
							; 816	; THE SELECT CODE.
							; 817	
							; 818	SPEC/=<51:56>D,0      	;DPE1 & DPE5 & DPM1 & DPMA
							; 819		#=10		;DECODE # BITS 
							; 820		CLRCLK=11	;CLEAR 1MS NICOND FLAG
							; 821		CLR IO LATCH=12	;CLEAR IO LATCH
							; 822		CLR IO BUSY=13	;CLEAR IO BUSY
							; 823		LDPAGE=14	;WRITE PAGE TABLE
							; 824		NICOND=15	;DOING NICOND DISPATCH
							; 825		LDPXCT=16	;LOAD PXCT FLAGS
							; 826		WAIT=17		;MEM WAIT
							; 827		PREV=20		;FORCE PREVIOUS CONTEXT
							; 828		LOADXR=21	;LOAD XR #, USES PXCT FIELD TO SELECT 
							; 829				; CORRECT AC BLOCK
							; 830		APR FLAGS=23	;LOAD APR FLAGS
							; 831		CLRCSH=24	;CLEAR CACHE
							; 832		APR EN=25	;SET APR ENABLES
							; 833		MEMCLR=27	;CLEAR PAGE FAULT CONDITION
							; 834		SWEEP=34	;SET SWEEP
							; 835		PXCT OFF=36	;TURN OFF THE EFFECT OF PXCT
							; 836		INHCRY18=40	;INHIBIT CARRY INTO LEFT HALF
							; 837		LOADIR=41	;LOAD THE IR
							; 838		LDPI=43		;LOAD PI SYSTEM
							; 839		ASHOV=44	;TEST RESULT OF ASH
							; 840		EXPTST=45	;TEST RESULT OF FLOATING POINT
							; 841		FLAGS=46	;CHANGE PC FLAGS
							; 842		LDACBLK=47	;LOAD AC BLOCK NUMBERS
							; 843		LDINST=61	;LOAD INSTRUCTION
							; 844	
							; 845	;THE SPEC FIELD IS REDEFINED WHEN USED FOR BYTE MODE STUFF
							; 846	BYTE/=<54:56>         	;DPM1 (SPEC SEL)
							; 847		BYTE1=1
							; 848		BYTE2=2
							; 849		BYTE3=3
							; 850		BYTE4=4
							; 851		BYTE5=5
							; 852	
							; 853	;THE SPEC FIELD IS REDEFINED WHEN USED TO CONTROL SHIFT PATHS
							; 854	SHSTYLE/=<54:56>      	;DPE1 (SPEC SEL)
							; 855		NORM=0		;2 40-BIT REGISTERS
							; 856		ZERO=1		;SHIFT ZERO INTO 36 BITS (ASH TOP 2901)
							; 857		ONES=2		;SHIFT IN ONES
							; 858		ROT=3		;ROTATE
							; 859		ASHC=4		;ASHC
							; 860		LSHC=5		;LSHC
							; 861		DIV=6		;SPECIAL DIVIDE
							; 862		ROTC=7		;ROTATE DOUBLE
							; 863	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 22
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- DISPATCH				

							; 864	.TOC	"MICROCODE FIELDS -- DISPATCH"
							; 865	;	!=======================================================!
							; 866	;	! D !      CRA1      !      CRA1      !      DPEA       !
							; 867	;	! I !      DISP      !      DISP      !      DISP       !
							; 868	;	! S !       10       !       20       !       40        !
							; 869	;	! P !                !                !                 !
							; 870	;	!=======================================================!
							; 871	;	! 0 !    DIAG ADR    !    DIAG ADR    !        0        !
							; 872	;	!-------------------------------------------------------!
							; 873	;	! 1 !     RETURN     !     RETURN     !    DP 18-21     !
							; 874	;	!-------------------------------------------------------!
							; 875	;	! 2 !    MULTIPLY    !       J        !        J        !
							; 876	;	!-------------------------------------------------------!
							; 877	;	! 3 !   PAGE FAIL    !     AREAD     !     AREAD      !
							; 878	;	!-------------------------------------------------------!
							; 879	;	! 4 !     NICOND     !   NOT USABLE   !      NORM       !
							; 880	;	!-------------------------------------------------------!
							; 881	;	! 5 !      BYTE      !   NOT USABLE   !    DP 32-35     !
							; 882	;	!-------------------------------------------------------!
							; 883	;	! 6 !    EA MODE     !   NOT USABLE   !     DROM A      !
							; 884	;	!-------------------------------------------------------!
							; 885	;	! 7 !      SCAD      !   NOT USABLE   !     DROM B      !
							; 886	;	!=======================================================!
							; 887	;NOTE:	DISP EN 40 & DISP EN 10 ONLY CONTROL THE LOW 4 BITS OF THE
							; 888	;	JUMP ADDRESS. DISP EN 20 ONLY CONTROLS THE HI 7 BITS. TO DO
							; 889	;	SOMETHING TO ALL 11 BITS BOTH 20 & 40 OR 20 & 10 MUST BE ENABLED.
							; 890	
							; 891	DISP/=<57:62>D,70     	;CRA1 & DPEA
							; 892		CONSOLE=00	;CONSOLE DISPATCH
							; 893		DROM=12		;DROM
							; 894		AREAD=13	;AREAD
							; 895		DP LEFT=31	;DP 18-21
							; 896		NORM=34		;NORMALIZE
							; 897		DP=35		;DP 32-35
							; 898		ADISP=36	;DROM A FIELD
							; 899		BDISP=37	;DROM B FIELD
							; 900		RETURN=41	;RETURN
							; 901		MUL=62		;MULTIPLY
							; 902		PAGE FAIL=63	;PAGE FAIL
							; 903		NICOND=64	;NEXT INSTRUCTION DISPATCH
							; 904		BYTE=65		;BYTE SIZE AND POSITION
							; 905		EAMODE=66	;EFFECTIVE ADDRESS MODE
							; 906		SCAD0=67	;J!2 IF SCAD BIT 0 = 1
							; 907	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 23
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- SKIP				

							; 908	.TOC	"MICROCODE FIELDS -- SKIP"
							; 909	;	!=======================================================!
							; 910	;	! S !      CRA2      !      DPEA      !      DPEA       !
							; 911	;	! K !      SKIP      !      SKIP      !      SKIP       !
							; 912	;	! I !       10       !       20       !       40        !
							; 913	;	! P !                !                !                 !
							; 914	;	!=======================================================!
							; 915	;	! 0 !       0        !       0        !        0        !
							; 916	;	!-------------------------------------------------------!
							; 917	;	! 1 !   TRAP CYCLE   !     CRY 02     !    CARRY OUT    !
							; 918	;	!-------------------------------------------------------!
							; 919	;	! 2 !      AD=0      !    ADL SIGN    !      ADL=0      !
							; 920	;	!-------------------------------------------------------!
							; 921	;	! 3 !    SC SIGN     !    ADR SIGN    !      ADR=0      !
							; 922	;	!-------------------------------------------------------!
							; 923	;	! 4 !    EXECUTE     !    USER IOT    !      -USER      !
							; 924	;	!-------------------------------------------------------!
							; 925	;	! 5 !  -BUS IO BUSY  !   JFCL SKIP    !    FPD FLAG     !
							; 926	;	!-------------------------------------------------------!
							; 927	;	! 6 !   -CONTINUE    !     CRY 01     !  AC # IS ZERO   !
							; 928	;	!-------------------------------------------------------!
							; 929	;	! 7 !    -1 MSEC     !      TXXX      !  INTERRUPT REQ  !
							; 930	;	!=======================================================!
							; 931	
							; 932	SKIP/=<63:68>D,70     	;CRA2 & DPEA
							; 933		IOLGL=04	;(.NOT.USER)!(USER IOT)!(CONSOLE EXECUTE MODE)
							; 934		LLE=12		;AD LEFT .LE. 0
							; 935		CRY0=31		;AD CRY -2
							; 936		ADLEQ0=32	;ADDER LEFT = 0
							; 937		ADREQ0=33	;ADDER RIGHT = 0
							; 938		KERNEL=34	;.NOT. USER
							; 939		FPD=35		;FIRST PART DONE
							; 940		AC0=36		;AC NUMBER IS ZERO
							; 941		INT=37		;INTERRUPT REQUEST
							; 942		LE=42		;(AD SIGN)!(AD.EQ.0)
							; 943		CRY2=51		;AD CRY 02
							; 944		DP0=52		;AD SIGN
							; 945		DP18=53		;AD BIT 18
							; 946		IOT=54		;USER IOT
							; 947		JFCL=55		;JFCL SKIP
							; 948		CRY1=56		;AD CRY 1
							; 949		TXXX=57		;TEST INSTRUCTION SHOULD SKIP
							; 950		TRAP CYCLE=61	;THIS INSTRUCTION IS THE RESULT OF A
							; 951				; TRAP 1, 2, OR 3
							; 952		ADEQ0=62	;AD.EQ.0
							; 953		SC=63		;SC SIGN BIT
							; 954		EXECUTE=64	;CONSOLE EXECUTE MODE
							; 955		-IO BUSY=65	;.NOT. I/O LATCH
							; 956		-CONTINUE=66	;.NOT. CONTINUE
							; 957		-1 MS=67	;.NOT. 1 MS. TIMER
							; 958	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 24
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- TIME CONTROL			

							; 959	.TOC	"MICROCODE FIELDS -- TIME CONTROL"
							; 960	
							; 961	DT/=<109:111>D,0        ;**NOT STORED IN CRAM**
							; 962				;DEFAULT TIME FIELD (USED IN MACROS)
							; 963				; CAN BE OVERRIDDEN IN MACRO CALL
							; 964		2T=0
							; 965		3T=1
							; 966		4T=2
							; 967		5T=3
							; 968	
							; 969	
							; 970	T/=<69:71>F,DT          ;CSL5 (E601)
							; 971				;CLOCK TICKS MINUS TWO REQUIRED TO
							; 972				; DO A MICRO INSTRUCTION
							; 973		2T=0		;TWO TICKS
							; 974		3T=1		;THREE TICKS
							; 975		4T=2		;FOUR TICKS
							; 976		5T=3		;FIVE TICKS
							; 977	
							; 978	
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 25
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- RANDOM CONTROL BITS			

							; 979	.TOC	"MICROCODE FIELDS -- RANDOM CONTROL BITS"
							; 980	
							; 981	CRY38/=<72>             ;DPE5
							; 982				;INJECT A CARRY INTO THE 2901 ADDER
							; 983	LOADSC/=<73>            ;DPM4
							; 984				;LOAD THE STEP COUNTER FROM THE SCAD
							; 985	LOADFE/=<74>            ;DPM4
							; 986				;LOAD THE FE REGISTER FROM THE SCAD
							; 987	FMWRITE/=<75>           ;DPE5 (E302)
							; 988				;WRITE THE RAM FILE.
							; 989	MEM/=<76>               ;DPM5 (E612) & DPE5 (E205)
							; 990				;START (OR COMPLETE) A MEMORY OR I/O CYCLE UNDER
							; 991				; CONTROL OF THE NUMBER FIELD.
							; 992	DIVIDE/=<77>            ;DPE5
							; 993				;THIS MICROINSTRUCTION IS DOING A DIVIDE
							; 994	MULTI PREC/=<78>        ;DPE5
							; 995				;MULTIPRECISION STEP IN DIVIDE, DFAD, DFSB
							; 996	MULTI SHIFT/=<79>       ;CSL5 (HAS NOTHING TO DO WITH DPE5 MULTI SHIFT)
							; 997				;FAST SHIFT
							; 998	CALL/=<80>              ;CRA2 (STACK IS ON CRA3)
							; 999				;THIS IS A CALL
							; 1000	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 26
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1001	.TOC	"MICROCODE FIELDS -- NUMBER FIELD"
							; 1002	
							; 1003	;HERE IS THE GENERAL FIELD
							; 1004	#/=<90:107>           	;MANY PLACES
							; 1005	
							; 1006	;# REDEFINED WHEN USED AS SCAD CONTROL:
							; 1007	SCAD/=<90:92>         	;DPM3
							; 1008		A*2=0
							; 1009		A.OR.B=1
							; 1010		A-B-1=2
							; 1011		A-B=3
							; 1012		A+B=4
							; 1013		A.AND.B=5
							; 1014		A-1=6
							; 1015		A=7
							; 1016	SCADA/=<93:95>        	;DPM3
							; 1017		SC=0
							; 1018		S#=1
							; 1019		PTR44=2	;44 AND BIT 6 (SEE DPM3)
							; 1020		BYTE1=3
							; 1021		BYTE2=4
							; 1022		BYTE3=5
							; 1023		BYTE4=6
							; 1024		BYTE5=7
							; 1025	SCADB/=<96:97>        	;DPM3
							; 1026		FE=0
							; 1027		EXP=1
							; 1028		SHIFT=2
							; 1029		SIZE=3
							; 1030	S#/=<98:107>          	;DPM3
							; 1031	
							; 1032	;# REDEFINED WHEN USED AS STATE REGISTER CONTROL:
							; 1033	STATE/=<90:107>         ;NOT USED BY HARDWARE
							; 1034		SIMPLE=0	;SIMPLE INSTRUCTIONS
							; 1035		BLT=1		;BLT IN PROGRESS
							; 1036		MAP=400002	;MAP IN PROGRESS
							; 1037		SRC=3		;MOVE STRING SOURCE IN PROGRESS
							; 1038		DST=4		;MOVE STRING FILL IN PROGRESS
							; 1039		SRC+DST=5	;MOVE STRING DEST IN PROGRESS
							; 1040		DSTF=6		;FILLING DEST
							; 1041		CVTDB=7		;CONVERT DEC TO BIN
							; 1042		COMP-DST=10	;COMPARE DEST
							; 1043		EDIT-SRC=11	;EDIT SOURCE
							; 1044		EDIT-DST=12	;EDIT DEST
							; 1045		EDIT-S+D=13	;BOTH SRC AND DST POINTERS
							; 1046	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 27
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1047	;# REDEFINED WHEN USED AS WORSPACE ADDRESS
							; 1048	
							; 1049	WORK/=<98:107>        	;DPE6
							; 1050		BADW0=160	;AC BLK 7 WORD 0 (BAD DATA FROM MEMORY)
							; 1051		BADW1=161	;AC BLK 7 WORD 1 (BAD DATA FROM MEMORY)
							; 1052		MUL=200		;TEMP FOR MULTIPLY
							; 1053		DIV=201		;TEMP FOR DIVIDE
							; 1054		SV.VMA=210	;SAVE VMA
							; 1055		SV.AR=211	;SAVE AR
							; 1056		SV.ARX=212	;SAVE ARX
							; 1057		SV.BR=213	;SAVE BR
							; 1058		SV.BRX=214	;SAVE BRX
							; 1059		SBR=215		;SPT BASE REGISTER
							; 1060		CBR=216		;CST BASE ADDRESS
							; 1061		CSTM=217	;CST MASK
							; 1062		PUR=220		;PROCESS USE REGISTER
							; 1063		ADJP=221	;"P" FOR ADJBP
							; 1064		ADJS=222	;"S" FOR ADJBP
							; 1065		ADJPTR=223	;BYTE POINTER FOR ADJBP
							; 1066		ADJQ1=224	;TEMP FOR ADJBP
							; 1067		ADJR2=225	;TEMP FOR ADJBP
							; 1068		ADJBPW=226	;(BYTES/WORD) FOR ADJBP
							; 1069		HSBADR=227	;ADDRESS OF HALT STATUS BLOCK
							; 1070		APR=230		;APR ENABLES
							; 1071	;THE FOLLOWING WORDS ARE USED BY EXTEND INSTRUCTION
							; 1072		E0=240		;ORIGINAL EFFECTIVE ADDRESS
							; 1073		E1=241		;EFFECTIVE ADDRESS OF WORD AT E0
							; 1074		SLEN=242	;SOURCE LENGTH
							; 1075		MSK=243		;BYTE MASK
							; 1076		FILL=244	;FILL BYTE
							; 1077		CMS=245		;SRC BYTE IN STRING COMPARE
							; 1078		FSIG=246	;PLACE TO SAVE ARX WHILE STORING
							; 1079				; THE FLOAT CHAR
							; 1080		BDH=247		;BINARY BEING CONVERTED TO
							; 1081		BDL=250		; DECIMAL
							; 1082	
							; 1083	;TIMER STUFF
							; 1084		TIME0=300	;HIGH ORDER 36 BITS OF TIME
							; 1085		TIME1=301	;LOW ORDER 36 BITS OF TIME
							; 1086		PERIOD=302	;INTERRUPT PERIOD
							; 1087		TTG=303		;TIME TO GO TO NEXT INTERRUPT
							; 1088	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 28
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1089	;DDIV STUFF
							; 1090		AC0=314
							; 1091		AC1=315
							; 1092		AC2=316
							; 1093		AC3=317
							; 1094		DDIV SGN=320
							; 1095		DVSOR H=321
							; 1096		DVSOR L=322
							; 1097	;POWERS OF TEN
							; 1098		DECLO=344	;LOW WORD
							; 1099		DECHI=373	;HIGH WORD
							; 1100	
							; 1101		YSAVE=422	;Y OF LAST INDIRECT POINTER
							; 1102		PTA.E=423	;ADDRESS OF EXEC PAGE MAP (NOT PROCESS TABLE)
							; 1103		PTA.U=424	;ADDRESS OF USER PAGE MAP
							; 1104		TRAPPC=425	;SAVED PC FROM TRAP CYCLE
							; 1105		SV.AR1=426	;ANOTHER PLACE TO SAVE AR
							; 1106	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 29
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1107	;# REDEFINED WHEN USED AS PC FLAG CONTROL (ALL ON DPE9)
							; 1108	
							; 1109	SETOV/=<90>             ;DPE9
							; 1110				;SET ARITHMETIC OVERFLOW
							; 1111	SETFOV/=<91>            ;SET FLOATING OVERFLOW
							; 1112	SETNDV/=<92>            ;SET NO DIVIDE
							; 1113	
							; 1114	;---------------------------------------------------------------------
							; 1115	
							; 1116	CLRFPD/=<93>            ;CLEAR FIRST PART DONE
							; 1117	SETFPD/=<94>            ;SET FIRST PART DONE
							; 1118	HOLD USER/=<95>         ;WHEN THIS BIT IS SET IT:
							; 1119				; 1. PREVENTS SETTING USER IOT IN USER MODE
							; 1120				; 2. PREVENTS CLEARING USER IN USER MODE
							; 1121	
							; 1122	;---------------------------------------------------------------------
							; 1123	
							; 1124	;	<96>		;SPARE
							; 1125	TRAP2/=<97>             ;SET TRAP 2
							; 1126	TRAP1/=<98>             ;SET TRAP 1
							; 1127	
							; 1128	;---------------------------------------------------------------------
							; 1129	
							; 1130	LD PCU/=<99>            ;LOAD PCU FROM USER
							; 1131	;	<100>		;SPARE
							; 1132	;	<101>		;SPARE
							; 1133	
							; 1134	;---------------------------------------------------------------------
							; 1135	
							; 1136	;	<102>		;SPARE
							; 1137	;	<103>		;SPARE
							; 1138	JFCLFLG/=<104>          ;DO A JFCL INSTRUCTION
							; 1139	
							; 1140	;---------------------------------------------------------------------
							; 1141	
							; 1142	LD FLAGS/=<105>         ;LOAD FLAGS FROM DP
							; 1143	;	<106>
							; 1144	ADFLGS/=<107>           ;UPDATE CARRY FLAGS
							; 1145	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 30
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1146	;# REDEFINED WHEN USED AS MEMORY CYCLE CONTROL
							; 1147	
							; 1148	FORCE USER/=<90>        ;FORCE USER MODE REFERENCE
							; 1149	FORCE EXEC/=<91>        ;FORCE EXEC MODE REFERENCE
							; 1150				; (DOES NOT WORK UNDER PXCT)
							; 1151	FETCH/=<92>             ;THIS IS AN INSTRUCTION FETCH
							; 1152	
							; 1153	;---------------------------------------------------------------------
							; 1154	
							; 1155	READ CYCLE/=<93>        ;SELECT A READ CYCLE
							; 1156	WRITE TEST/=<94>        ;PAGE FAILE IF NOT WRITTEN
							; 1157	WRITE CYCLE/=<95>       ;SELECT A MEMORY WRITE CYCLE
							; 1158	
							; 1159	;---------------------------------------------------------------------
							; 1160	
							; 1161	;	<96>		;SPARE BIT
							; 1162	DONT CACHE/=<97>        ;DO NOT LOOK IN CACHE
							; 1163	PHYSICAL/=<98>          ;DO NOT INVOKE PAGING HARDWARE
							; 1164	
							; 1165	;---------------------------------------------------------------------
							; 1166	
							; 1167	PXCT/=<99:101>          ;WHICH PXCT BITS TO LOOK AT
							; 1168		CURRENT=0
							; 1169		E1=1
							; 1170		D1=3
							; 1171		BIS-SRC-EA=4
							; 1172		E2=5
							; 1173		BIS-DST-EA=6
							; 1174		D2=7
							; 1175	
							; 1176	;---------------------------------------------------------------------
							; 1177	
							; 1178	AREAD/=<102>            ;LET DROM SELECT SYSLE TYPE AND VMA LOAD
							; 1179	DP FUNC/=<103>          ;IGNORE # BITS 0-11 AND USE DP 0-13 INSTEAD
							; 1180				; DP9 MEANS "FORCE PREVIOUS"
							; 1181	LDVMA/=<104>            ;LOAD THE VMA
							; 1182	
							; 1183	;---------------------------------------------------------------------
							; 1184	
							; 1185	EXT ADR/=<105>          ;PUT VMA BITS 14-17 ONTO BUS
							; 1186	WAIT/=<106>             ;START A MEMORY OR I/O CYCLE
							; 1187	BWRITE/=<107>           ;START A MEMORY CYCLE IF DROM ASKS FOR IT
							; 1188	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 31
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1189	;THESE BITS ARE USED ONLY TO SETUP DP FOR A DP FUNCTION
							; 1190	
							; 1191	;	<99>		;PREVIOUS
							; 1192	IO CYCLE/=<100>         ;THIS IS AN I/O CYCLE
							; 1193	WRU CYCLE/=<101>        ;WHO ARE YOU CYCLE
							; 1194	
							; 1195	;---------------------------------------------------------------------
							; 1196	
							; 1197	VECTOR CYCLE/=<102>     ;READ INTERRUPT VECTOR
							; 1198	IO BYTE/=<103>          ;BYTE CYCLE
							; 1199	;	<104>
							; 1200	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 32
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1201	;# REDEFINED WHEN USED AS PI RIGHT BITS
							; 1202	PI.ZER/=<90:92>         ;ZEROS
							; 1203	PI.IP1/=<93>            ;PI 1 IN PROG
							; 1204	PI.IP2/=<94>
							; 1205	PI.IP3/=<95>
							; 1206	PI.IP4/=<96>
							; 1207	PI.IP5/=<97>
							; 1208	PI.IP6/=<98>
							; 1209	PI.IP7/=<99>
							; 1210	PI.ON/=<100>            ;SYSTEM IS ON
							; 1211	PI.CO1/=<101>           ;CHAN 1 IS ON
							; 1212	PI.CO2/=<102>
							; 1213	I.CO3/=<103>
							; 1214	I.CO4/=<104>
							; 1215	I.CO5/=<105>
							; 1216	I.CO6/=<106>
							; 1217	I.CO7/=<107>
							; 1218	
							; 1219	;# REDEFINED WHEN USED AS WRPI DATA
							; 1220	PI.MBZ/=<90:93>         ;MUST BE ZERO
							; 1221	PI.DIR/=<94>            ;DROP INTERRUPT REQUESTS
							; 1222	PI.CLR/=<95>            ;CLEAR SYSTEM
							; 1223	PI.REQ/=<96>            ;REQUEST INTERRUPT
							; 1224	PI.TCN/=<97>            ;TURN CHANNEL ON
							; 1225	PI.TCF/=<98>            ;TURN CHANNEL OFF
							; 1226	PI.TSF/=<99>            ;TURN SYSTEM OFF
							; 1227	PI.TSN/=<100>           ;TURN SYSTEM ON
							; 1228	PI.SC1/=<101>           ;SELECT CHANNEL 1
							; 1229	PI.SC2/=<102>
							; 1230	PI.SC3/=<103>
							; 1231	PI.SC4/=<104>
							; 1232	PI.SC5/=<105>
							; 1233	PI.SC6/=<106>
							; 1234	PI.SC7/=<107>
							; 1235	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 33
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1236	;# REDEFINED WHEN USED AS AC CONTROL
							; 1237	
							; 1238	
							; 1239	;THIS FIELD CONTROLS THE INPUT TO A 74LS181 ON DPE6. THE NUMBER
							; 1240	; FIELD HAS THIS FORMAT IN <98:107>:
							; 1241	;
							; 1242	;	!-----!-----!-----!-----!-----!-----!-----!-----!-----!-----!
							; 1243	;	!CARRY! S8  !  S4 ! S2  !  S1 ! MODE! B8  ! B4  !  B2 ! B1  !
							; 1244	;	!  IN !       FUNCTION        !     !      DATA INPUTS      !
							; 1245	;	!-----!-----------------------!-----!-----------------------!
							; 1246	;
							; 1247	
							; 1248	ACALU/=<98:103>       	
							; 1249		B=25
							; 1250		AC+N=62
							; 1251	ACN/=<104:107>
							; 1252				;AC NAMES FOR STRING INSTRUCTIONS
							; 1253		SRCLEN=0	;SOURCE LENGTH
							; 1254		SRCP=1		;SOURCE POINTER
							; 1255		DLEN=3		;DEST LENGTH
							; 1256		DSTP=4		;DEST POINTER
							; 1257		MARK=3		;POINTER TO MARK
							; 1258		BIN0=3		;HIGH WORD OF BINARY
							; 1259		BIN1=4		;LOW WORD OF BINARY
							; 1260	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 34
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1261	;# FIELD REDEFINED WHEN USE AS APRID DATA
							; 1262	MICROCODE OPTIONS/=<90:98>
							; 1263	;100	- NON-STANDARD MICROCODE
							; 1264	;200	- NO CST AT ALL
							; 1265	;400	- INHIBIT CST UPDATE IS AVAILABLE
							; 1266	;040	- UBABLT INSTRUCTIONS ARE PRESENT
							; 1267	;020	- KI PAGING IS PRESENT
							; 1268	;010	- KL PAGING IS PRESENT
							; 1269	MICROCODE OPTION(INHCST)/=<90>
							; 1270	.IF/INHCST
							; 1271		OPT=1
							;;1272	.IFNOT/INHCST
							;;1273		OPT=0
							; 1274	.ENDIF/INHCST
							; 1275	MICROCODE OPTION(NOCST)/=<91>
							;;1276	.IF/NOCST
							;;1277		OPT=1
							; 1278	.IFNOT/NOCST
							; 1279		OPT=0
							; 1280	.ENDIF/NOCST
							; 1281	MICROCODE OPTION(NONSTD)/=<92>
							;;1282	.IF/NONSTD
							;;1283		OPT=1
							; 1284	.IFNOT/NONSTD
							; 1285		OPT=0
							; 1286	.ENDIF/NONSTD
							; 1287	MICROCODE OPTION(UBABLT)/=<93>
							; 1288	.IF/UBABLT
							; 1289		OPT=1
							;;1290	.IFNOT/UBABLT
							;;1291		OPT=0
							; 1292	.ENDIF/UBABLT
							; 1293	MICROCODE OPTION(KIPAGE)/=<94>
							; 1294	.IF/KIPAGE
							; 1295		OPT=1
							;;1296	.IFNOT/KIPAGE
							;;1297		OPT=0
							; 1298	.ENDIF/KIPAGE
							; 1299	MICROCODE OPTION(KLPAGE)/=<95>
							; 1300	.IF/KLPAGE
							; 1301		OPT=1
							;;1302	.IFNOT/KLPAGE
							;;1303		OPT=0
							; 1304	.ENDIF/KLPAGE
							; 1305	
							; 1306	MICROCODE VERSION/=<99:107>
							; 1307		UCV=130
							; 1308	
							; 1309	MICROCODE RELEASE(MAJOR)/=<99:104>
							; 1310		UCR=2		;MAJOR VERSION NUMBER (1,2,3,....)
							; 1311	
							; 1312	MICROCODE RELEASE(MINOR)/=<105:107>
							; 1313		UCR=1		;MINOR VERSION NUMBER (.1,.2,.3,...)
							; 1314	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 35
; KS10.MIC[1,2]	23:44 29-MAY-2015				MICROCODE FIELDS -- NUMBER FIELD			

							; 1315	;# FIELD REDEFINED WHEN USED AS A HALT CODE
							; 1316	
							; 1317	HALT/=<90:107>
							; 1318				;CODES 0 TO 77 ARE "NORMAL" HALTS
							; 1319		POWER=0		;POWER UP
							; 1320		HALT=1		;HALT INSTRUCTION
							; 1321		CSL=2		;CONSOLE HALT
							; 1322				;CODES 100 TO 777 ARE SOFTWARE ERRORS
							; 1323		IOPF=100	;I/O PAGE FAIL
							; 1324		ILLII=101	;ILLEGAL INTERRUPT INSTRUCTION
							; 1325		ILLINT=102	;BAD POINTER TO UNIBUS INTERRUPT VECTOR
							; 1326				;CODES 1000 TO 1777 ARE HARDWARE ERRORS
							; 1327		BW14=1000	;ILLEGAL BWRITE FUNCTION (BAD DROM)
							; 1328		NICOND 5=1004	;ILLEGAL NICOND DISPATCH
							; 1329		MULERR=1005	;VALUE COMPUTED FOR 10**21 WAS WRONG
							;;1330	.IFNOT/FULL
							;;1331		PAGEF=1777	;PAGE FAIL IN SMALL MICROCODE
							; 1332	.ENDIF/FULL
							; 1333	
							; 1334	
							; 1335	
							; 1336	;# FIELD REDEFINED WHEN USED AS FLG BITS
							; 1337	
							; 1338	FLG.W/=<94>             ;W BIT FROM PAGE MAP
							; 1339	FLG.PI/=<95>            ;PI CYCLE
							; 1340	FLG.C/=<96>             ;CACHE BIT FROM PAGE MAP
							; 1341	FLG.SN/=<97>		;SPECIAL NEGATE IN FDV & DFDV
							; 1342	
							; 1343	;RIGHT HALF OF FLG USED TO RECOVER FROM PAGE FAILS
							; 1344	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 36
; KS10.MIC[1,2]	23:44 29-MAY-2015				DISPATCH ROM DEFINITIONS				

							; 1345	.TOC	"DISPATCH ROM DEFINITIONS"
							; 1346	
							; 1347	;ALL ON DPEA
							; 1348	
							; 1349		.DCODE
							; 1350	A/=<2:5>                ;OPERAND FETCH MODE
							; 1351		READ=0		;READ
							; 1352		WRITE=1		;WRITE
							; 1353		DREAD=2		;DOUBLE READ
							; 1354		DBLAC=3		;DOUBLE AC
							; 1355		SHIFT=4		;SIMPLE SHIFT
							; 1356		DSHIFT=5	;DOUBLE SHIFT
							; 1357		FPI=6		;FLOATING POINT IMMEDIATE
							; 1358		FP=7		;FLOATING POINT
							; 1359		RD-PF=10	;READ, THEN START PREFETCH
							; 1360		DFP=11		;DOUBLE FLOATING POINT
							; 1361		IOT=12		;CHECK FOR IO LEGAL THEN SAME AS I
							; 1362	
							; 1363	B/=<8:11>               ;STORE RESULTS AS
							; 1364		SELF=4		;SELF
							; 1365		DBLAC=5		;DOUBLE AC
							; 1366		DBLB=6		;DOUBLE BOTH
							; 1367		AC=15		;AC
							; 1368		MEM=16		;MEMORY
							; 1369		BOTH=17		;BOTH
							; 1370	
							; 1371	;B-FIELD WHEN USED IN FLOATING POINT OPERATIONS
							; 1372	ROUND/=<8>              ;ROUND THE RESULT
							; 1373	MODE/=<9>               ;SEPARATE ADD/SUB & MUL/DIV ETC.
							; 1374	FL-B/=<10:11>           ;STORE RESULTS AS
							; 1375		AC=1		;AC
							; 1376		MEM=2		;MEMORY
							; 1377		BOTH=3		;BOTH
							; 1378	
							; 1379	J/=<12:23>              ;DISPATCH ADDRESS (MUST BE 1400 TO 1777)
							; 1380	
							; 1381	ACDISP/=<24>            ;DISPATCH ON AC FIELD
							; 1382	I/=<25>                 ;IMMEDIATE DISPATCH. DISP/AREAD DOES A DISP/DROM
							; 1383				; IF THIS BIT IS SET.
							; 1384	READ/=<26>              ;START A READ AT AREAD
							; 1385	TEST/=<27>              ;START A WRITE TEST  AT AREAD
							; 1386	COND FUNC/=<28>       	;START A MEMORY CYCLE ON BWRITE
							; 1387	VMA/=<29>D,1            ;LOAD THE VMA ON AREAD
							; 1388	WRITE/=<30>           	;START A WRITE ON AREAD
							; 1389		.UCODE
							; 1390	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 37
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ MACROS					

							; 1391	.TOC	"HOW TO READ MACROS"
							; 1392	;		
							; 1393	;		1.0  REGISTER TRANSFER MACROS
							; 1394	;		
							; 1395	;		MOST MACROS USED IN THE KS10 ARE USED TO OPERATE ON DATA IN  (OR  FROM/TO)  2901
							; 1396	;		REGISTERS.   THE  NAMES  OF  THE  2901  REGISTERS  ARE  MACRO PARAMETERS AND ARE
							; 1397	;		ENCLOSED IN [].  A TYPICAL MACRO IS:
							; 1398	;		
							; 1399	;		        [AR]_[AR]+[BR]
							; 1400	;		
							; 1401	;		THE SYMBOL _ IS PRONOUNCED "GETS".  THE ABOVE MACRO WOULD BE READ "THE  AR  GETS
							; 1402	;		THE AR PLUS THE BR".
							; 1403	;		
							; 1404	;		IF A MACRO DOES NOT HAVE A _ IN IT, THERE IS NO RESULT STORED.  THUS,  [AR]-[BR]
							; 1405	;		JUST COMPARES THE AR AND THE BR AND ALLOWS FOR SKIPS ON THE VARIOUS ALU BITS.
							; 1406	;		
							; 1407	;		
							; 1408	;		
							; 1409	;		1.1  SPECIAL SYMBOLS
							; 1410	;		
							; 1411	;		THERE ARE A BUNCH OF SYMBOLS USED IN THE MACROS WHICH ARE  NOT  2901  REGISTERS.
							; 1412	;		THEY ARE DEFINED HERE:
							; 1413	;		
							; 1414	;		     1.  AC -- THE AC SELECTED BY THE CURRENT INSTRUCTION.  SEE DPEA
							; 1415	;		
							; 1416	;		     2.  AC[] -- AC+N.  AC[1] IS AC+1, AC[2] IS AC+2, ETC.
							; 1417	;		
							; 1418	;		     3.  APR -- THE APR FLAGS FROM DPMA
							; 1419	;		
							; 1420	;		     4.  EA -- THE EFFECTIVE ADDRESS.  THAT IS, 0  IN  THE  LEFT  HALF  AND  THE
							; 1421	;		         CONTENTS OF THE HR IN THE RIGHT HALF.
							; 1422	;		
							; 1423	;		     5.  EXP -- THE F.P.  EXPONENT  FROM  THE  SCAD.   [AR]_EXP  WILL  TAKE  THE
							; 1424	;		         EXPONENT OUT OF THE FE AND PUT IT BACK INTO THE NUMBER IN THE AR.
							; 1425	;		
							; 1426	;		     6.  FE -- THE FE REGISTER
							; 1427	;		
							; 1428	;		     7.  FLAGS -- THE PC FLAGS (FROM DPE9) IN THE LEFT HALF.
							; 1429	;		
							; 1430	;		     8.  Q -- THE Q REGISTER
							; 1431	;		
							; 1432	;		     9.  RAM -- THE RAM FILE, RAM ADDRESS IS IN THE VMA.
							; 1433	;		
							; 1434	;		    10.  P -- THE P FIELD OF THE BYTE POINTER.  SAME IDEA AS EXP.
							; 1435	;		
							; 1436	;		    11.  TIME -- THE 1MS.  TIMER
							; 1437	;		
							; 1438	;		    12.  VMA -- THE VMA.  WHEN READ IT INCLUDES THE VMA FLAGS
							; 1439	;		
							; 1440	;		    13.  XR -- INDEX REGISTER
							; 1441	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 38
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ MACROS					

							; 1442	;		    14.  XWD -- HALF WORD.  USED TO GENERATE CONSTANTS.  FOR EXAMPLE, [AR]_0 XWD
							; 1443	;		         [40] WOULD LOAD THE CONSTANT 40 (OCTAL) INTO THE AR.
							; 1444	;		
							; 1445	;		    15.  +SIGN AND -SIGN -- SIGN BITS USED TO SIGN  SMEAR  F.P.   NUMBERS.   FOR
							; 1446	;		         EXAMPLE, [AR]_+SIGN WOULD CLEAR AR BITS 0 TO 8.
							; 1447	;		
							; 1448	;		    16.  WORK[] -- LOCATIONS IN  THE  WORKSPACE  USED  AS  SCRATCH  SPACE.   FOR
							; 1449	;		         EXAMPLE,  [AR]_WORK[CSTM]  WOULD LOAD THE AR WITH THE CST MASK FROM THE
							; 1450	;		         RAM.  CSTM IS A SYMBOL DEFINED IN THE WORK FIELD.
							; 1451	;		
							; 1452	;		
							; 1453	;		
							; 1454	;		
							; 1455	;		1.2  LONG
							; 1456	;		
							; 1457	;		LONG IS USED ON SHIFT OPERATIONS  TO  INDICATE  THAT  THE  Q  REGISTER  IS  ALSO
							; 1458	;		SHIFTED.  THIS SAYS NOTHING ABOUT HOW THE SHIFT PATHS ARE CONNECTED UP.
							; 1459	;		
							; 1460	;		
							; 1461	;		
							; 1462	;		2.0  MEMORY MACROS
							; 1463	;		
							; 1464	;		MEMORY IS INDICATED BY THE SYMBOL "MEM".  WHEN WE  ARE  WAITING  FOR  DATA  FROM
							; 1465	;		MEMORY  THE  "MEM  READ" MACRO IS USED.  WHEN WE ARE SENDING DATA TO MEMORY, THE
							; 1466	;		"MEM WRITE" MACRO IS USED.  EXAMPLE,
							; 1467	;		        MEM READ,               ;WAIT FOR MEMORY
							; 1468	;		        [AR]_MEM                ;LOAD DATA INTO AR
							; 1469	;		VMA_ IS USED THE LOAD THE VMA.  THUS, VMA_[PC] LOADS THE VMA FROM THE PC.
							; 1470	;		
							; 1471	;		
							; 1472	;		
							; 1473	;		3.0  TIME CONTROL
							; 1474	;		
							; 1475	;		THERE ARE 2 SETS OF MACROS USED FOR TIME CONTROL.  THE FIRST,  SELECTS  THE  RAM
							; 1476	;		ADDRESS  TO  SPEED UP THE NEXT INSTRUCTION.  THESE MACROS ARE AC, AC[], XR, VMA,
							; 1477	;		WORK[].  THE SECOND, SETS THE TIME FIELD.  THESE ARE  2T,  3T,  4T,  AND  5T  TO
							; 1478	;		SELECT 2, 3, 4, OR 5 TICKS.
							; 1479	;		
							; 1480	;		
							; 1481	;		
							; 1482	;		4.0  SCAD MACROS
							; 1483	;		
							; 1484	;		THE SCAD MACROS LOOK LIKE THE 2901 MACROS EXECPT NO [] ARE REQUIRED.  THERE  ARE
							; 1485	;		ONLY A FEW SYMBOLS USED.
							; 1486	;		
							; 1487	;		     1.  FE -- THE FE REGISTER
							; 1488	;		
							; 1489	;		     2.  SC -- THE SC REGISTER
							; 1490	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 39
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ MACROS					

							; 1491	;		     3.  EXP -- THE EXPONENT FROM A F.P.  NUMBER.  FOR EXAMPLE FE_EXP LOADS  THE
							; 1492	;		         FE FROM DP BITS 1-8.
							; 1493	;		
							; 1494	;		     4.  SHIFT -- THE SHIFT COUNT FROM SHIFT INSTRUCTIONS.  THAT IS DP  BITS  18
							; 1495	;		         AND 28-35.
							; 1496	;		
							; 1497	;		     5.  S# -- THE SMALL NUMBER.  THE 10 BIT MAGIC NUMBER  INPUT  TO  THE  SCADA
							; 1498	;		         MIXER.
							; 1499	;		
							; 1500	;		
							; 1501	;		
							; 1502	;		
							; 1503	;		5.0  CONTROL MACROS
							; 1504	;		
							; 1505	;		ALL CONTROL MACROS LOOK LIKE ENGLISH COMMANDS.  SOME EXAMPLES,
							; 1506	;		        HOLD LEFT               ;DO NOT CLOCK LEFT HALF OF DP
							; 1507	;		        SET APR ENABLES         ;LOAD APR ENABLES FROM DP
							; 1508	;		        SET NO DIVIDE           ;SET NO DIVIDE PC FLAG
							; 1509	;		
							; 1510	;		
							; 1511	;		
							; 1512	;		6.0  SKIPS
							; 1513	;		
							; 1514	;		ALL SKIPS CAUSE THE NEXT MICRO INSTRUCTION TO COME  FROM  THE  ODD  WORD  OF  AN
							; 1515	;		EVEN/ODD PAIR.  THE MACROS HAVE THE FORMAT OF SKIP COND.  THEY SKIP IF CONDITION
							; 1516	;		IS TRUE.  SOME EXAMPLES,
							; 1517	;		        SKIP AD.EQ.0            ;SKIP IF ADDER OUTPUT IS ZERO
							; 1518	;		        SKIP IRPT               ;SKIP IF INTERRUPT IS PENDING
							; 1519	;		
							; 1520	;		
							; 1521	;		
							; 1522	;		7.0  DISPATCH MACROS
							; 1523	;		
							; 1524	;		DISPATCH MACROS CAUSE THE MACHINE TO GO TO ONE OF MANY PLACES.   IN  MOST  CASES
							; 1525	;		THEY HAVE THE WORD "DISP" IN THE NAME OF THE MACRO.  FOR EXAMPLE, MUL DISP, BYTE
							; 1526	;		DISP.
							; 1527	;		
							; 1528	;		
							; 1529	;		
							; 1530	;		8.0  SUPER MACROS
							; 1531	;		
							; 1532	;		THERE ARE PLACES WHERE ONE MICRO  INSTRUCTION  IS  USED  IN  MANY  PLACES.   FOR
							; 1533	;		EXAMPLE,  MANY  PLACES  DETECT ILLEGAL OPERATIONS AND WANT TO GENERATE A TRAP TO
							; 1534	;		THE MONITOR.  WE COULD WRITE
							; 1535	;		        J/UUO
							; 1536	;		BUT THIS WASTES A MICRO STEP DOING A USELESS JUMP.  INSTEAD WE WRITE,
							; 1537	;		        UUO
							; 1538	;		THIS MACRO IS THE FIRST STEP  OF  THE  UUO  ROUTINE  AND  JUMPS  TO  THE  SECOND
							; 1539	;		INSTRUCTION.   WE  WRITE THE EXPANSION OF THE UUO MACRO AS THE FIRST INSTRUCTION
							; 1540	;		OF THE UUO ROUTINE SO THAT THE READER CAN SEE WHAT IT DOES.   SOME  EXAMPLES  OF
							; 1541	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 40
; KS10.MIC[1,2]	23:44 29-MAY-2015				HOW TO READ MACROS					

							; 1542	;		SUPER MACROS ARE:
							; 1543	;		        PAGE FAIL TRAP          ;GENERATE A PAGE FAIL TRAP
							; 1544	;		        DONE                    ;THIS INSTRUCTION IS NOW COMPLETE
							; 1545	;		                                ; USED WITH A SKIP OR DISP WHERE
							; 1546	;		                                ; SOME PATHS ARE NOP'S
							; 1547	;		        HALT []                 ;JUMP TO HALT LOOP. ARGUMENT IS A
							; 1548	;		                                ; CODE
							; 1549	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 41
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- DATA PATH CHIP -- GENERAL			

							; 1550	.TOC	"MACROS -- DATA PATH CHIP -- GENERAL"
							; 1551	
							; 1552	.NOT.[] 	"AD/.NOT.A,A/@1"
							; 1553	[]+[]		"AD/A+B,A/@1,B/@2"
							; 1554	[]-[]		"AD/A-B-.25,A/@1,B/@2,ADD .25"
							; 1555	[]-#		"AD/A-D-.25,DBUS/DBM,DBM/#,A/@1,ADD .25"
							; 1556	[].AND.#	"AD/D.AND.A,DBUS/DBM,DBM/#,A/@1"
							; 1557	[].AND.Q	"AD/A.AND.Q,A/@1,DEST/PASS"
							; 1558	[].AND.[]	"AD/A.AND.B,A/@2,B/@1,DEST/PASS"
							; 1559	[].AND.NOT.[]	"AD/.NOT.A.AND.B,A/@2,B/@1,DEST/PASS"
							; 1560	[].OR.[]	"AD/A.OR.B,A/@2,B/@1,DEST/PASS"
							; 1561	[].XOR.#	"AD/D.XOR.A,DBUS/DBM,DBM/#,A/@1"
							; 1562	[].XOR.[]	"AD/A.XOR.B,A/@2,B/@1,DEST/PASS"
							; 1563	[]_#-[]		"AD/D-A-.25,DEST/AD,A/@2,B/@1,DBUS/DBM,DBM/#,ADD .25"
							; 1564	[]_#		"AD/D,DBUS/DBM,DBM/#,DEST/AD,B/@1"
							; 1565	[]_-1		"AD/-A-.25,A/ONE,DEST/AD,B/@1,ADD .25"
							; 1566	[]_-2		"AD/-A-.25,DEST/AD*2,A/ONE,B/@1,ADD .25"
							; 1567	[]_-Q		"AD/-Q-.25,DEST/AD,B/@1,ADD .25"
							; 1568	[]_-Q*2		"AD/-Q-.25,DEST/AD*2,B/@1,ADD .25"
							; 1569	[]_-Q*.5	"AD/-Q-.25,DEST/AD*.5,B/@1,ADD .25"
							; 1570	[]_-[]		"AD/-A-.25,A/@2,DEST/AD,B/@1,ADD .25"
							; 1571	[]_-[]-.25	"AD/-A-.25,A/@2,DEST/AD,B/@1"
							; 1572	[]_-[]*2	"AD/-A-.25,A/@2,DEST/AD*2,B/@1,ADD .25"
							; 1573	[]_.NOT.AC	"AD/.NOT.D,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1"
							; 1574	[]_.NOT.AC[]	"AD/.NOT.D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,DT/3T"
							; 1575	[]_.NOT.Q	"AD/.NOT.Q,DEST/AD,B/@1"
							; 1576	[]_.NOT.[]	"AD/.NOT.A,A/@2,DEST/AD,B/@1"
							; 1577	[]_0		"AD/ZERO,DEST/AD,B/@1"
							; 1578	[]_0*.5 LONG	"AD/ZERO,DEST/Q_Q*.5,B/@1"
							; 1579	[]_0 XWD []	"AD/47,DEST/AD,B/@1,DBM/#,DBUS/DBM,#/@2,RSRC/DA,A/MASK"
							; 1580	[]_AC		"AD/D,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,AD PARITY"
							; 1581	[]_-AC		"AD/-D-.25,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,ADD .25"
							; 1582	[]_-AC[]	"AD/-D-.25,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,ADD .25,DT/3T"
							; 1583	[]_AC*.5	"AD/D,DBUS/RAM,RAMADR/AC#,DEST/AD*.5,B/@1,DT/3T"
							; 1584	[]_AC*.5 LONG	"AD/D,DBUS/RAM,RAMADR/AC#,DEST/Q_Q*.5,B/@1,DT/3T"
							; 1585	[]_AC*2 	"AD/D,DBUS/RAM,RAMADR/AC#,DEST/AD*2,B/@1,DT/3T"
							; 1586	[]_AC+1 	"AD/D+A,DBUS/RAM,RAMADR/AC#,A/ONE,DEST/AD,B/@1"
							; 1587	[]_AC+1000001	"AD/D+A,DBUS/RAM,RAMADR/AC#,A/XWD1,DEST/AD,B/@1"
							; 1588	[]_AC+[]	"AD/D+A,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,DT/3T"
							; 1589	[]_AC-1 	"AD/D-A-.25,DBUS/RAM,RAMADR/AC#,A/ONE,DEST/AD,B/@1,ADD .25"
							; 1590	[]_AC-[]	"AD/D-A-.25,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,ADD .25"
							; 1591	[]_AC-[]-.25	"AD/D-A-.25,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1"
							; 1592	[]_AC[]-[]	"AD/D-A-.25,A/@3,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,ADD .25,DT/3T"
							; 1593	[]_AC[]-1	"AD/D-A-.25,A/ONE,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,ADD .25,DT/3T"
							; 1594	[]_AC[].AND.[]	"AD/D.AND.A,A/@3,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,DT/3T"
							; 1595	[]_AC.AND.MASK	"AD/D.AND.A,A/MASK,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,AD PARITY"
							; 1596	[]_AC[]		"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD,B/@1,AD PARITY,DT/3T"
							; 1597	[]_AC[]*2	"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD*2,B/@1,AD PARITY,DT/3T"
							; 1598	[]_AC[]*.5	"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@2,DEST/AD*.5,B/@1,AD PARITY,DT/3T"
							; 1599	[]_APR		"AD/D,DBUS/DBM,DBM/APR FLAGS,DEST/AD,B/@1,DT/3T"
							; 1600	[]_CURRENT AC [] "AD/D,DBUS/RAM,RAMADR/#,ACALU/B,ACN/@2,DEST/AD,B/@1,AD PARITY,DT/3T"
							; 1601	[]_EA FROM []	"AD/57,RSRC/0A,A/@2,DEST/AD,B/@1"
							; 1602	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 42
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- DATA PATH CHIP -- GENERAL			

							; 1603	[]_EA		"AD/57,RSRC/0A,A/HR,DEST/AD,B/@1"
							; 1604	[]_EXP		"AD/D,DBUS/DBM,DBM/EXP,A/@1,B/@1,DEST/A,SCAD/A+B,SCADA/S#,S#/0,SCADB/FE,HOLD RIGHT,EXP TEST"
							; 1605	[]_FE		"AD/D,DEST/AD*.5,B/@1,DBUS/DBM,DBM/DP,SCAD/A+B,SCADA/S#,S#/0,SCADB/FE,BYTE/BYTE5"
							; 1606	[]_FLAGS	"AD/D.AND.A,DBUS/PC FLAGS,A/MASK,DEST/AD,B/@1,RSRC/0Q"
							; 1607	[]_P		"AD/D,DEST/A,A/@1,B/@1,DBUS/DBM,DBM/DP,BYTE/BYTE1,SCAD/A+B,SCADA/S#,S#/0,SCADB/FE"
							; 1608	[]_PC WITH FLAGS "AD/D,DBUS/PC FLAGS,RSRC/0A,A/PC,DEST/AD,B/@1"
							; 1609	[]_Q		"AD/Q,DEST/AD,B/@1"
							; 1610	[]_Q*.5		"AD/Q,DEST/AD*.5,B/@1"
							; 1611	[]_Q*2		"AD/Q,DEST/AD*2,B/@1"
							; 1612	[]_Q*2 LONG	"AD/Q,DEST/Q_Q*2,B/@1"
							; 1613	[]_Q+1		"AD/A+Q,A/ONE,DEST/AD,B/@1"
							; 1614	[]_RAM		"AD/D,DBUS/RAM,RAMADR/RAM,DEST/AD,B/@1,AD PARITY"
							; 1615	[]_TIME		"AD/44,RSRC/DA,A/MASK,DBUS/DBM,DBM/EXP,DEST/AD,B/@1"
							; 1616	[]_VMA		"AD/D,DEST/AD,B/@1,DBUS/DBM,DBM/VMA"
							; 1617	[]_XR		"AD/D,DBUS/RAM,RAMADR/XR#,DEST/AD,B/@1"
							; 1618	[]_[]		"AD/A,A/@2,DEST/AD,B/@1"
							; 1619	[]_[] SWAP	"AD/D,DBUS/DBM,DBM/DP SWAP,DEST/A,A/@2,B/@1"
							; 1620	[]_[] XWD 0	"AD/45,DEST/AD,B/@1,DBM/#,DBUS/DBM,#/@2,RSRC/D0,A/MASK"
							; 1621	[]_[]*.5	"AD/A,A/@2,DEST/AD*.5,B/@1"
							; 1622	[]_[]*.5 LONG	"AD/A,A/@2,DEST/Q_Q*.5,B/@1"
							; 1623	[]_[]*2 	"AD/A,A/@2,DEST/AD*2,B/@1"
							; 1624	[]_[]*2 LONG	"AD/A,A/@2,DEST/Q_Q*2,B/@1"
							; 1625	[]_[]*4 	"AD/A+B,A/@2,B/@1,DEST/AD*2"
							; 1626	[]_[]+# 	"AD/D+A,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1"
							; 1627	[]_[]+.25	"AD/0+A,A/@2,DEST/AD,B/@1, ADD .25"
							; 1628	[]_[]+0		"AD/0+A,A/@2,DEST/AD,B/@1"
							; 1629	[]_[]+1 	"AD/A+B,A/ONE,B/@1,B/@2,DEST/AD"
							; 1630	[]_[]+1000001	"AD/D+A,A/@2,DBUS/DBM,DBM/#,#/1,DEST/AD,B/@1"
							; 1631	[]_[]+AC	"AD/D+A,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1"
							; 1632	[]_[]+AC[]	"AD/D+A,A/@2,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@3,DEST/AD,B/@1,DT/3T"
							; 1633	[]_[]+Q		"AD/A+Q,A/@2,DEST/AD,B/@1"
							; 1634	[]_[]+RAM	"AD/D+A,A/@2,DBUS/RAM,RAMADR/RAM,DEST/AD,B/@1"
							; 1635	[]_[]+XR	"AD/D+A,DBUS/RAM,RAMADR/XR#,A/@2,DEST/AD,B/@1,HOLD LEFT"
							; 1636	[]_[]+[]	"AD/A+B,A/@3,B/@1,B/@2,DEST/AD"
							; 1637	[]_[]+[]+.25	"AD/A+B,A/@3,B/@1,B/@2,DEST/AD, ADD .25"
							; 1638	[]_[]-# 	"AD/A-D-.25,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1, ADD .25"
							; 1639	[]_[]-1 	"AD/B-A-.25,B/@1,A/ONE,DEST/AD,ADD .25"
							; 1640	[]_[]-1000001	"AD/A-D-.25,A/@2,DBUS/DBM,DBM/#,#/1,DEST/AD,B/@1,ADD .25"
							; 1641	[]_[]-AC	"AD/A-D-.25,A/@2,DBUS/RAM,RAMADR/AC#,DEST/AD,B/@1,ADD .25"
							; 1642	[]_[]-RAM	"AD/A-D-.25,A/@2,DBUS/RAM,RAMADR/RAM,DEST/AD,B/@1,ADD .25"
							; 1643	[]_[]-[]	"AD/B-A-.25,B/@1,B/@2,A/@3,DEST/AD,ADD .25"
							; 1644	[]_[]-[] REV	"AD/A-B-.25,B/@1,B/@3,A/@2,DEST/AD,ADD .25"
							; 1645	[]_[].AND.#	"AD/D.AND.A,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1646	[]_[].AND.# CLR LH "AD/ZERO,RSRC/DA,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1647	[]_[].AND.# CLR RH "AD/D.AND.A,RSRC/0Q,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1648	[]_(AC[].AND.[])*.5 "AD/D.AND.A,DEST/AD*.5,A/@3,B/@1,RAMADR/AC*#,DBUS/RAM,ACALU/AC+N,ACN/@2"
							; 1649	[]_(Q+1)*.5	"AD/A+Q,A/ONE,DEST/AD*.5,B/@1"
							; 1650	[]_(#-[])*2	"AD/D-A-.25,DEST/AD*2,A/@2,B/@1,DBUS/DBM,DBM/#,ADD .25"
							; 1651	[]_(-[])*.5	"AD/-A-.25,A/@2,DEST/AD*.5,B/@1,ADD .25"
							; 1652	[]_(-[]-.25)*.5 LONG "AD/-A-.25,A/@2,DEST/Q_Q*.5,B/@1"
							; 1653	[]_(-[]-.25)*2 LONG "AD/-A-.25,A/@2,DEST/Q_Q*2,B/@1"
							; 1654	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 43
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- DATA PATH CHIP -- GENERAL			

							; 1655	[]_([].AND.#)*.5 "AD/D.AND.A,DBUS/DBM,DBM/#,DEST/AD*.5,A/@2,B/@1"
							; 1656	[]_([].AND.#)*2	"AD/D.AND.A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1657	[]_([].AND.NOT.#)*.5 "AD/.NOT.D.AND.A,DBUS/DBM,DBM/#,DEST/AD*.5,A/@2,B/@1"
							; 1658	[]_([].AND.NOT.#)*2	"AD/.NOT.D.AND.A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1659	[]_([].AND.[])*.5 "AD/A.AND.B,DEST/AD*.5,A/@3,B/@1,B/@2"
							; 1660	[]_([].AND.[])*2 "AD/A.AND.B,DEST/AD*2,A/@3,B/@1,B/@2"
							; 1661	[]_([].OR.#)*.5 "AD/D.OR.A,DBUS/DBM,DBM/#,DEST/AD*.5,A/@2,B/@1"
							; 1662	[]_([].OR.#)*2	"AD/D.OR.A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1663	[]_([]+#)*2	"AD/D+A,DBUS/DBM,DBM/#,DEST/AD*2,A/@2,B/@1"
							; 1664	[]_([]+1)*2 	"AD/A+B,A/ONE,B/@1,B/@2,DEST/AD*2"
							; 1665	[]_([]+[])*.5 LONG	"AD/A+B,A/@3,B/@1,B/@2,DEST/Q_Q*.5"
							; 1666	[]_([]+[])*2 LONG	"AD/A+B,A/@3,B/@1,B/@2,DEST/Q_Q*2"
							; 1667	[]_([]-[])*.5 LONG	"AD/B-A-.25,A/@3,B/@1,B/@2,DEST/Q_Q*.5, ADD .25"
							; 1668	[]_([]-[])*2 LONG	"AD/B-A-.25,A/@3,B/@1,B/@2,DEST/Q_Q*2, ADD .25"
							; 1669	[]_([]+[]+.25)*.5 LONG	"AD/A+B,A/@3,B/@1,B/@2,DEST/Q_Q*.5, ADD .25"
							; 1670	[]_[].AND.AC	"AD/D.AND.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1671	[]_[].AND.NOT.# "AD/.NOT.D.AND.A,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1"
							; 1672	[]_[].AND.NOT.[] "AD/.NOT.A.AND.B,DEST/AD,B/@1,B/@2,A/@3"
							; 1673	[]_[].AND.NOT.AC "AD/.NOT.D.AND.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1674	[]_[].AND.Q	"AD/A.AND.Q,A/@2,DEST/AD,B/@1"
							; 1675	[]_[].AND.[]	"AD/A.AND.B,A/@3,B/@1,B/@2,DEST/AD"
							; 1676	[]_[].EQV.AC	"AD/D.EQV.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1677	[]_[].EQV.Q	"AD/A.EQV.Q,A/@2,DEST/AD,B/@1"
							; 1678	[]_[].OR.#	"AD/D.OR.A,DBUS/DBM,DBM/#,A/@2,DEST/AD,B/@1"
							; 1679	[]_[].OR.AC	"AD/D.OR.A,DBUS/RAM,RAMADR/AC#,A/@2,DEST/AD,B/@1"
							; 1680	[]_[].OR.FLAGS	"AD/D.OR.A,DBUS/PC FLAGS,RSRC/0A,A/@1,DEST/AD,B/@1"
							; 1681	[]_[].OR.[]	"AD/A.OR.B,A/@3,B/@2,B/@1,DEST/AD"
							; 1682	[]_[].XOR.#	"AD/D.XOR.A,DBUS/DBM,DBM/#,DEST/AD,A/@2,B/@1"
							; 1683	[]_[].XOR.AC	"AD/D.XOR.A,DBUS/RAM,RAMADR/AC#,A/@1,DEST/AD,B/@2"
							; 1684	[]_[].XOR.[]	"AD/A.XOR.B,A/@3,B/@1,B/@2,DEST/AD"
							; 1685	
							; 1686	[] LEFT_0	"AD/57,RSRC/0B,DEST/AD,B/@1"
							; 1687	[] RIGHT_0	"AD/53,RSRC/D0,DEST/AD,B/@1"
							; 1688	[] LEFT_-1	"AD/54,RSRC/0B,DEST/AD,A/MASK,B/@1"
							; 1689	[] RIGHT_-1	"AD/53,RSRC/0A,DEST/AD,A/MASK,B/@1"
							; 1690	
							; 1691	
							; 1692	[]_+SIGN	"[@1]_[@1].AND.#, #/777, HOLD RIGHT"
							; 1693	[]_-SIGN	"[@1]_[@1].OR.#, #/777000, HOLD RIGHT"
							; 1694	;THE FOLLOWING 2 MACROS ARE USED IN DOUBLE FLOATING STUFF
							; 1695	; THEY ASSUME THAT THE OPERAND HAS BEEN SHIFTED RIGHT 1 PLACE.
							; 1696	; THEY SHIFT 1 MORE PLACE
							; 1697	[]_+SIGN*.5	"AD/.NOT.D.AND.A,A/@1,B/@1,DEST/AD*.5,DBUS/DBM,DBM/#,#/777400,RSRC/0A"
							; 1698	[]_-SIGN*.5	"AD/D.OR.A,A/@1,B/@1,DEST/AD*.5,DBUS/DBM,DBM/#,#/777400,RSRC/0A"
							; 1699	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 44
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- DATA PATH CHIP -- Q				

							; 1700	.TOC	"MACROS -- DATA PATH CHIP -- Q"
							; 1701	
							; 1702	Q-[]		"AD/Q-A-.25,A/@1,ADD .25"
							; 1703	Q.AND.NOT.[]	"AD/.NOT.A.AND.Q,A/@1,DEST/PASS"
							; 1704	Q_[]		"AD/A,DEST/Q_AD,A/@1"
							; 1705	Q_[]-[] 	"AD/A-B-.25,A/@1,B/@2,DEST/Q_AD,ADD .25"
							; 1706	Q_[]+[] 	"AD/A+B,A/@1,B/@2,DEST/Q_AD"
							; 1707	Q_[].AND.[]	"AD/A.AND.B,A/@1,B/@2,DEST/Q_AD"
							; 1708	Q_.NOT.AC[]	"AD/.NOT.D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,DT/3T"
							; 1709	Q_-[]		"AD/-A-.25,DEST/Q_AD,A/@1, ADD .25"
							; 1710	Q_-1		"Q_-[ONE]"
							; 1711	Q_-AC[]	"AD/-D-.25,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,ADD .25,DT/3T"
							; 1712	Q_-Q		"AD/-Q-.25,ADD .25,DEST/Q_AD"
							; 1713	Q_AC		"AD/D,DBUS/RAM,RAMADR/AC#,DEST/Q_AD,CHK PARITY"
							; 1714	Q_AC[]		"AD/D,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,CHK PARITY,DT/3T"
							; 1715	Q_AC[].AND.MASK	"AD/D.AND.A,A/MASK,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,CHK PARITY,DT/3T"
							; 1716	Q_AC[].AND.[]	"AD/D.AND.A,A/@2,DBUS/RAM,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DEST/Q_AD,CHK PARITY,DT/3T"
							; 1717	Q_.NOT.Q		"AD/.NOT.Q,DEST/Q_AD"
							; 1718	Q_#		"AD/D,DBUS/DBM,DBM/#,DEST/Q_AD"
							; 1719	Q_0		"AD/ZERO,DEST/Q_AD"
							; 1720	Q_0 XWD []	"AD/47,DEST/Q_AD,DBM/#,DBUS/DBM,#/@1,RSRC/DA,A/MASK"
							; 1721	Q_Q+.25		"AD/0+Q,DEST/Q_AD,ADD .25"
							; 1722	Q_Q+1		"AD/A+Q,A/ONE,DEST/Q_AD"
							; 1723	Q_Q-1		"AD/Q-A-.25,A/ONE,DEST/Q_AD, ADD .25"
							; 1724	Q_Q+AC		"AD/D+Q,DBUS/RAM,RAMADR/AC#,DEST/Q_AD"
							; 1725	Q_Q*.5		"[MAG]_[MASK]*.5 LONG, SHSTYLE/NORM"
							; 1726	Q_Q*2		"[MASK]_[MAG]*2 LONG, SHSTYLE/NORM"
							; 1727	Q_Q.OR.#	"AD/D.OR.Q,DBUS/DBM,DBM/#,DEST/Q_AD"
							; 1728	Q_Q.AND.#	"AD/D.AND.Q,DBUS/DBM,DBM/#,DEST/Q_AD"
							; 1729	Q_Q.AND.[]	"AD/A.AND.Q,A/@1,DEST/Q_AD"
							; 1730	Q_Q.AND.NOT.[]	"AD/.NOT.A.AND.Q,A/@1,DEST/Q_AD"
							; 1731	Q_Q+[]		"AD/A+Q,A/@1,DEST/Q_AD"
							; 1732	Q_[].AND.Q	"AD/A.AND.Q,A/@1,DEST/Q_AD"
							; 1733	Q_[].OR.Q	"AD/A.OR.Q,A/@1,DEST/Q_AD"
							; 1734	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 45
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- DATA PATH CHIP -- MISC.			

							; 1735	.TOC	"MACROS -- DATA PATH CHIP -- MISC."
							; 1736	
							; 1737	CLEAR []0	"AD/D.AND.A,A/@1,DBUS/DBM,DBM/#,#/377777,DEST/AD,B/@1,HOLD RIGHT"
							; 1738	CLEAR ARX0	"CLEAR [ARX]0"
							; 1739	
							; 1740	;CYCLE CHIP REGISTERS THRU AD SO WE CAN TEST BITS
							; 1741	READ XR		"AD/D,DBUS/RAM,RAMADR/XR#"
							; 1742	READ [] 	"AD/B,B/@1"
							; 1743	READ Q		"AD/Q"
							; 1744	
							; 1745	;TEST BITS IN REGISTERS (SKIP IF ZERO)
							; 1746	TR []		"AD/D.AND.A,DBUS/DBM,DBM/#,A/@1,SKIP ADR.EQ.0,DT/3T"
							; 1747	TL []		"AD/D.AND.A,DBUS/DBM,DBM/#,A/@1,SKIP ADL.EQ.0,DT/3T"
							; 1748	
							; 1749	
							; 1750	;CAUSE BITS -2 AND -1 TO MATCH BIT 0. 
							; 1751	FIX [] SIGN	"AD/D,DEST/A,A/@1,B/@1,DBUS/DP,HOLD RIGHT"
							; 1752	
							; 1753	;GENERATE A MASK IN Q AND ZERO A 2901 REGISTER
							; 1754	GEN MSK []	"AD/ZERO,DEST/Q_Q*2,B/@1,ONES"
							; 1755	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 46
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- STORE IN AC					

							; 1756	.TOC	"MACROS -- STORE IN AC"
							; 1757	
							; 1758	FM WRITE	"FMWRITE/1"
							; 1759	
							; 1760	AC[]_[] VIA AD	"AD/B,DEST/PASS,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,CHK PARITY"
							; 1761	AC_[] VIA AD	"AD/B,DEST/PASS,B/@1,RAMADR/AC#,DBUS/DP,FM WRITE,CHK PARITY"
							; 1762	AC[]_[]		"AD/A,DEST/A,B/@2,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1763	AC[]_[] TEST	"AD/D,DBUS/DP,DEST/A,B/@2,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1764	AC[]_[]+1	"AD/A+B,DEST/PASS,A/ONE,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1765	AC[]_[]*2	"AD/A+B,DEST/PASS,A/@2,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1766	AC_[]		"AD/A,DEST/A,B/@1,A/@1,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1767	AC_[] TEST	"AD/D,DBUS/DP,DEST/A,B/@1,A/@1,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1768	AC_[]+1		"AD/A+B,DEST/PASS,A/ONE,B/@1,RAMADR/AC#, FM WRITE"
							; 1769	AC_[]+Q		"AD/A+Q,DEST/PASS,A/@1,B/@1,RAMADR/AC#, FM WRITE"
							; 1770	AC[]_[]+Q	"AD/A+Q,DEST/PASS,A/@2,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1, FM WRITE"
							; 1771	AC[]_[]-[]	"AD/A-B-.25,DEST/PASS,B/@3,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,ADD .25"
							; 1772	AC[]_[]+[]	"AD/A+B,DEST/PASS,B/@3,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1773	AC_[]+[]	"AD/A+B,DEST/PASS,B/@2,A/@1,RAMADR/AC#,DBUS/DP,FM WRITE"
							; 1774	AC[]_[].AND.[]	"AD/A.AND.B,DEST/PASS,B/@3,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1775	AC[]_Q.AND.[]	"AD/A.AND.Q,DEST/PASS,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1776	AC[]_[].EQV.Q	"AD/A.EQV.Q,DEST/PASS,A/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1777	AC[]_-[]	"AD/-B-.25,DEST/PASS,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,ADD .25"
							; 1778	AC_-[]		"AD/-A-.25,DEST/PASS,A/@1,RAMADR/AC#,DBUS/DP, ADD .25,FM WRITE"
							; 1779	AC_[].OR.[]	"AD/A.OR.B,A/@1,B/@2,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1780	AC[]_.NOT.[]	"AD/.NOT.B,DEST/PASS,B/@2,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1781	AC_.NOT.[]	"AD/.NOT.B,DEST/PASS,B/@1,RAMADR/AC#,DBUS/DP,FM WRITE"
							; 1782	AC[]_-Q		"AD/-Q-.25,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE,ADD .25"
							; 1783	AC_Q		"AD/Q,RAMADR/AC#,DBUS/DP, FM WRITE"
							; 1784	AC[]_0		"AD/ZERO,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1785	AC[]_1		"AD/B,DEST/PASS,B/ONE,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP,FM WRITE"
							; 1786	AC[]_Q		"AD/Q,RAMADR/AC*#,ACALU/AC+N,ACN/@1,DBUS/DP, FM WRITE"
							; 1787	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 47
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- MICROCODE WORK SPACE				

							; 1788	.TOC	"MACROS -- MICROCODE WORK SPACE"
							; 1789	
							; 1790	
							; 1791	WORK[]_Q	"AD/Q,DEST/PASS,RAMADR/#,WORK/@1,FM WRITE"
							; 1792	Q_WORK[]	"AD/D,DEST/Q_AD,RAMADR/#,DBUS/RAM,WORK/@1,DT/3T"
							; 1793	WORK[]_0	"AD/ZERO,DEST/PASS,RAMADR/#,WORK/@1,FM WRITE"
							; 1794	WORK[]_1	"AD/B,DEST/PASS,RAMADR/#,WORK/@1,B/ONE,FM WRITE"
							; 1795	WORK[]_[]	"AD/B,DEST/PASS,RAMADR/#,WORK/@1,B/@2,FM WRITE"
							; 1796	WORK[]_[] CLR LH "AD/47,RSRC/AB,DEST/PASS,RAMADR/#,WORK/@1,B/@2,A/MASK,FM WRITE"
							; 1797	WORK[]_[]-1	"AD/A-B-.25,A/@2,B/ONE,DEST/PASS,RAMADR/#,WORK/@1,FM WRITE, ADD .25"
							; 1798	WORK[]_.NOT.[]	"AD/.NOT.B,DEST/PASS,RAMADR/#,WORK/@1,B/@2,FM WRITE"
							; 1799	WORK[]_[].AND.[] "AD/A.AND.B,DEST/PASS,RAMADR/#,WORK/@1,A/@2,B/@3,FM WRITE"
							; 1800	[].AND.NOT.WORK[] "AD/.NOT.D.AND.A,A/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1801	[].AND.WORK[]	"AD/D.AND.A,A/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1802	[]_[]+WORK[]	"AD/D+A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1803	[]_[].AND.WORK[] "AD/D.AND.A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1804	[]_[].AND.NOT.WORK[] "AD/.NOT.D.AND.A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1805	[]_[].OR.WORK[]	"AD/D.OR.A,A/@2,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,DT/3T"
							; 1806	[]_WORK[]	"AD/D,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1807	[]_.NOT.WORK[]	"AD/.NOT.D,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1808	[]_-WORK[]	"AD/-D-.25,ADD .25,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1809	[]_WORK[]+1	"AD/D+A,A/ONE,DEST/AD,B/@1,DBUS/RAM,RAMADR/#,WORK/@2,DT/3T"
							; 1810	Q_Q-WORK[]	"AD/Q-D-.25,DEST/Q_AD,DBUS/RAM,RAMADR/#,WORK/@1,ADD .25,DT/3T"
							; 1811	[]_[]-WORK[]	"AD/A-D-.25,DEST/AD,A/@2,B/@1,DBUS/RAM,RAMADR/#,WORK/@3,ADD .25,DT/3T"
							; 1812	
							; 1813	RAM_[]		"AD/B,DEST/PASS,RAMADR/RAM,B/@1,FM WRITE"
							; 1814	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 48
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- MEMORY CONTROL				

							; 1815	.TOC		"MACROS -- MEMORY CONTROL"
							; 1816	
							; 1817	MEM CYCLE		"MEM/1"
							; 1818	
							; 1819	;THE FOLLOWING MACROS CONTROL MEMORY ADDRESS
							; 1820	LOAD VMA		"MEM CYCLE,LDVMA/1"
							; 1821	FORCE EXEC		"FORCE EXEC/1"
							; 1822	VMA PHYSICAL		"PHYSICAL/1,FORCE EXEC/1,FORCE USER/0,EXT ADR/1,LOAD VMA"
							; 1823	VMA PHYSICAL WRITE	"LOAD VMA,VMA PHYSICAL,WAIT/1,MEM/1,WRITE CYCLE/1,WRITE TEST/0"
							; 1824	VMA PHYSICAL READ	"LOAD VMA,VMA PHYSICAL,WAIT/1,MEM/1,READ CYCLE/1,WRITE TEST/0"
							; 1825	VMA EXTENDED		"EXT ADR/1"
							; 1826	
							; 1827	PXCT EA			"PXCT/E1"
							; 1828	PXCT DATA		"PXCT/D1"
							; 1829	PXCT BLT DEST		"PXCT/D1"
							; 1830	PXCT BYTE PTR EA 	"PXCT/E2"
							; 1831	PXCT BYTE DATA		"PXCT/D2"
							; 1832	PXCT STACK WORD		"PXCT/D2"
							; 1833	PXCT BLT SRC		"PXCT/D2"
							; 1834	PXCT EXTEND EA		"PXCT/E2"
							; 1835	
							; 1836	;THE FOLLOWING MACROS GET MEMORY CYCLES STARTED
							; 1837	WRITE TEST		"WRITE TEST/1,WAIT/1"
							; 1838	START READ		"MEM CYCLE,READ CYCLE/1,WAIT/1"
							; 1839	START WRITE		"MEM CYCLE,WRITE TEST,WRITE CYCLE/1,WAIT/1"
							; 1840	START NO TEST WRITE	"MEM CYCLE,WRITE CYCLE/1,WAIT/1"
							; 1841	FETCH			"START READ,FETCH/1,PXCT/CURRENT,WAIT/1"
							; 1842	
							; 1843	;THE FOLLOWING MACROS COMPLETE MEMORY CYCLES
							; 1844	MEM WAIT		"MEM CYCLE,WAIT/1"
							; 1845	MEM READ		"MEM WAIT,DBUS/DBM,DBM/MEM"
							; 1846	MEM WRITE		"MEM WAIT,DT/3T"
							; 1847	SPEC MEM READ		"SPEC/WAIT,DBUS/DBM,DBM/MEM"
							; 1848	SPEC MEM WRITE		"SPEC/WAIT,DT/3T"
							; 1849	
							; 1850	
							; 1851	;THINGS WHICH WRITE MEMORY
							; 1852	MEM_[]			"AD/B,DEST/PASS,B/@1,DBUS/DP,RAMADR/VMA,CHK PARITY"
							; 1853	MEM_Q			"AD/Q,DBUS/DP,RAMADR/VMA"
							; 1854	
							; 1855	
							; 1856	;THINGS WHICH READ MEMORY
							; 1857	[]_IO DATA		"AD/D,DBUS/DBM,RAMADR/VMA,DEST/AD,B/@1"
							; 1858	[]_MEM			"AD/D,DBUS/DBM,RAMADR/VMA,DEST/AD,B/@1,CHK PARITY"
							; 1859	[]_MEM THEN FETCH	"AD/D,DBUS/DBM,RAMADR/VMA,DEST/A,A/PC,B/@1,CHK PARITY, FETCH, LOAD VMA"
							; 1860	[]_MEM*.5		"AD/D,DBUS/DBM,RAMADR/VMA,DEST/AD*.5,B/@1,CHK PARITY"
							; 1861	[]_MEM.AND.MASK		"AD/D.AND.A,A/MASK,DBUS/DBM,RAMADR/VMA,DEST/AD,B/@1,CHK PARITY"
							; 1862	[]_(MEM.AND.[])*.5	"AD/D.AND.A,A/@2,DBUS/DBM,RAMADR/VMA,DEST/AD*.5,B/@1,CHK PARITY"
							; 1863	Q_MEM			"AD/D,DBUS/DBM,RAMADR/VMA,DEST/Q_AD,CHK PARITY"
							; 1864	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 49
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- VMA						

							; 1865	.TOC	"MACROS -- VMA"
							; 1866	
							; 1867	VMA_[]			"AD/A,A/@1,DEST/PASS,LOAD VMA"
							; 1868	VMA_[] WITH FLAGS	"AD/A,A/@1,DEST/PASS,LOAD VMA,WAIT/1, MEM/1, EXT ADR/1, DP FUNC/1, DT/3T"
							; 1869	VMA_[].OR.[] WITH FLAGS	"AD/A.OR.B,A/@1,B/@2,DEST/PASS,LOAD VMA,WAIT/1, MEM/1, EXT ADR/1, DP FUNC/1, DT/3T"
							; 1870	VMA_[]+1		"AD/A+B,A/ONE,B/@1,DEST/AD,HOLD LEFT,LOAD VMA"
							; 1871	VMA_[]-1		"AD/B-A-.25,A/ONE,B/@1,ADD .25,HOLD LEFT,LOAD VMA"
							; 1872	VMA_[]+XR		"AD/D+A,DBUS/RAM,RAMADR/XR#,A/@1,LOAD VMA"
							; 1873	VMA_[]+[]		"AD/A+B,DEST/PASS,A/@1,B/@2,LOAD VMA"
							; 1874	
							; 1875	NEXT [] PHYSICAL WRITE "AD/A+B,A/ONE,B/@1,DEST/AD,HOLD LEFT,LOAD VMA, VMA PHYSICAL, START WRITE"
							; 1876	
							; 1877	;MACROS TO LOAD A 2901 REGISTER WITH VMA FLAG BITS
							; 1878	[]_VMA FLAGS	"AD/45,DEST/AD,B/@1,DBM/#,DBUS/DBM,RSRC/D0,A/MASK"
							; 1879	[]_VMA IO READ	"[@1]_VMA FLAGS,READ CYCLE/1,IO CYCLE/1,WRITE TEST/0, PHYSICAL/1, FORCE EXEC/1, FORCE USER/0"
							; 1880	[]_VMA IO WRITE	"[@1]_VMA FLAGS,WRITE CYCLE/1,IO CYCLE/1,WRITE TEST/0, PHYSICAL/1, FORCE EXEC/1, FORCE USER/0"
							; 1881	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 50
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- TIME CONTROL					

							; 1882	.TOC	"MACROS -- TIME CONTROL"
							; 1883	
							; 1884	AC		"RAMADR/AC#"
							; 1885	AC[]		"RAMADR/AC*#,ACALU/AC+N,ACN/@1"
							; 1886	XR		"RAMADR/XR#"
							; 1887	VMA		"RAMADR/VMA"
							; 1888	WORK[]		"RAMADR/#, WORK/@1"
							; 1889	
							; 1890	2T		"T/2T"
							; 1891	3T		"T/3T"
							; 1892	4T		"T/4T"
							; 1893	5T		"T/5T"
							; 1894	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 51
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- SCAD, SC, FE LOGIC				

							; 1895	.TOC	"MACROS -- SCAD, SC, FE LOGIC"
							; 1896	
							; 1897	LOAD SC		"LOADSC/1"
							; 1898	LOAD FE		"LOADFE/1"
							; 1899	STEP SC		"SCAD/A-1,SCADA/SC,LOAD SC,SKIP/SC"
							; 1900	SHIFT		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/1, LOAD FE, MULTI SHIFT/1"
							; 1901	
							; 1902	SC_SC-1		"SCAD/A-1,SCADA/SC,LOAD SC"
							; 1903	SC_SHIFT	"SCAD/A+B,SCADA/S#,S#/0,SCADB/SHIFT,LOAD SC"
							; 1904	SC_SHIFT-1	"SCAD/A+B,SCADA/S#,S#/1777,SCADB/SHIFT,LOAD SC"
							; 1905	SC_SHIFT-2	"SCAD/A+B,SCADA/S#,S#/1776,SCADB/SHIFT,LOAD SC"
							; 1906	SC_-SHIFT	"SCAD/A-B,SCADA/S#,S#/0000,SCADB/SHIFT,LOAD SC"
							; 1907	SC_-SHIFT-1	"SCAD/A-B,SCADA/S#,SCADB/SHIFT,S#/1777,LOAD SC"
							; 1908	SC_-SHIFT-2	"SCAD/A-B,SCADA/S#,SCADB/SHIFT,S#/1776,LOAD SC"
							; 1909	SC_SC-EXP	"SCAD/A-B,SCADA/SC,SCADB/EXP,LOAD SC"
							; 1910	SC_SC-EXP-1	"SCAD/A-B-1,SCADA/SC,SCADB/EXP,LOAD SC"
							; 1911	SC_SC-FE-1	"SCAD/A-B-1,SCADA/SC,SCADB/FE,LOAD SC"
							; 1912	SC_SC-FE	"SCAD/A-B,SCADA/SC,SCADB/FE,LOAD SC"
							; 1913	SC_EXP		"SCAD/A+B,SCADA/S#,S#/0,SCADB/EXP,LOAD SC"
							; 1914	SC_S#-FE	"SCAD/A-B,SCADA/S#,SCADB/FE,LOAD SC"
							; 1915	SC_FE+S#	"SCAD/A+B,SCADA/S#,SCADB/FE,LOAD SC"
							; 1916	SC_FE		"SCAD/A.OR.B,SCADA/S#,S#/0,SCADB/FE,LOAD SC"
							; 1917	SC_S#		"SCAD/A,SCADA/S#,LOAD SC"
							; 1918	
							; 1919	
							; 1920	SC_36.		"SC_S#,S#/36."
							; 1921	SC_35.		"SC_S#,S#/35."
							; 1922	SC_34.		"SC_S#,S#/34."
							; 1923	SC_28.		"SC_S#,S#/28."
							; 1924	SC_27.		"SC_S#,S#/27."
							; 1925	SC_26.		"SC_S#,S#/26."
							; 1926	SC_24.		"SC_S#,S#/24."
							; 1927	SC_22.		"SC_S#,S#/22."
							; 1928	SC_20.		"SC_S#,S#/20."
							; 1929	SC_19.		"SC_S#,S#/19."
							; 1930	SC_14.		"SC_S#,S#/14."
							; 1931	SC_11.		"SC_S#,S#/11."
							; 1932	SC_9.		"SC_S#,S#/9."
							; 1933	SC_8.		"SC_S#,S#/8."
							; 1934	SC_7		"SC_S#,S#/7"
							; 1935	SC_6		"SC_S#,S#/6"
							; 1936	SC_5		"SC_S#,S#/5"
							; 1937	SC_4		"SC_S#,S#/4"
							; 1938	SC_3		"SC_S#,S#/3"
							; 1939	SC_2		"SC_S#,S#/2"
							; 1940	SC_1		"SC_S#,S#/1"
							; 1941	SC_0		"SC_S#,S#/0."
							; 1942	SC_-1		"SC_S#,S#/1777"
							; 1943	SC_-2		"SC_S#,S#/1776"
							; 1944	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 52
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- SCAD, SC, FE LOGIC				

							; 1945	FE_-FE		"SCAD/A-B,SCADA/S#,S#/0,SCADB/FE,LOAD FE"
							; 1946	FE_-FE-1	"SCAD/A-B,SCADA/S#,S#/1777,SCADB/FE,LOAD FE"
							; 1947	FE_FE-19	"SCAD/A+B,SCADB/FE,SCADA/S#,S#/1550,LOAD FE"
							; 1948	FE_-FE+S#	"SCAD/A-B,SCADA/S#,SCADB/FE,LOAD FE"
							; 1949	FE_FE+SC	"SCAD/A+B,SCADA/SC,SCADB/FE, LOAD FE"
							; 1950	FE_FE.AND.S#	"SCAD/A.AND.B,SCADA/S#,SCADB/FE, LOAD FE"
							; 1951	FE_P		"SCAD/A,SCADA/BYTE1, LOAD FE"
							; 1952	FE_S		"SCAD/A+B, SCADA/S#, S#/0 ,SCADB/SIZE, LOAD FE"
							; 1953	FE_S+2		"SCAD/A+B, SCADA/S#, S#/20, SCADB/SIZE, LOAD FE"
							; 1954	FE_-S-20	"SCAD/A-B,SCADA/S#,S#/1760,SCADB/SIZE, LOAD FE"
							; 1955	FE_-S-10	"SCAD/A-B,SCADA/S#,S#/1770,SCADB/SIZE, LOAD FE"
							; 1956	FE_S#		"SCAD/A,SCADA/S#,LOAD FE"
							; 1957	FE_S#-FE	"SCAD/A-B,SCADA/S#,SCADB/FE,LOAD FE"
							; 1958	FE_-2		"FE_S#,S#/1776"
							; 1959	FE_-12.		"FE_S#,S#/1764"
							; 1960	FE_0		"FE_S#,S#/0"
							; 1961	FE_-1		"FE_S#,S#/1777"
							; 1962	FE_FE+1		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/1,LOAD FE"
							; 1963	FE_FE+2		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/2,LOAD FE"
							; 1964	FE_FE+10		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/10,LOAD FE"
							; 1965	FE_FE-1		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/1777,LOAD FE"
							; 1966	FE_FE+4		"SCAD/A+B,SCADA/S#,SCADB/FE,S#/4,LOAD FE"
							; 1967	FE_EXP		"SCAD/A+B,SCADA/S#,S#/0,SCADB/EXP,LOAD FE"
							; 1968	FE_SC+EXP	"SCAD/A+B,SCADA/SC,SCADB/EXP,LOAD FE"
							; 1969	FE_SC-EXP	"SCAD/A-B,SCADA/SC,SCADB/EXP,LOAD FE"
							; 1970	FE_FE+P		"SCAD/A+B,SCADA/BYTE1,SCADB/FE, LOAD FE"
							; 1971	FE_FE-200	"SCAD/A+B,SCADA/S#,S#/1600,SCADB/FE,LOAD FE"
							; 1972	FE_-FE+200	"SCAD/A-B,SCADA/S#,S#/200,SCADB/FE,LOAD FE"
							; 1973	FE_FE+S#	"SCAD/A+B,SCADA/S#,SCADB/FE,LOAD FE"
							; 1974	
							; 1975	
							; 1976	GEN 17-FE	"SCAD/A-B,SCADA/S#,S#/210,SCADB/FE"
							; 1977	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 53
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- DATA PATH FIELD CONTROL			

							; 1978	.TOC	"MACROS -- DATA PATH FIELD CONTROL"
							; 1979	
							; 1980	HOLD LEFT	"CLKL/0,GENL/0"
							; 1981	ADL PARITY	"GENL/1"
							; 1982	CHK PARITY L	"CHKL/1"
							; 1983	
							; 1984	HOLD RIGHT	"CLKR/0,GENR/0"
							; 1985	ADR PARITY	"GENR/1"
							; 1986	CHK PARITY R	"CHKR/1"
							; 1987	
							; 1988	AD PARITY	"AD PARITY OK/1"
							; 1989	CHK PARITY	"CHKL/1,CHKR/1"
							; 1990	BAD PARITY	"CHKL/0,CHKR/0"
							; 1991	
							; 1992	INH CRY18	"SPEC/INHCRY18"
							; 1993	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 54
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- SHIFT PATH CONTROL				

							; 1994	.TOC	"MACROS -- SHIFT PATH CONTROL"
							; 1995	
							; 1996	ASH		"SHSTYLE/NORM"	;ASH SHIFT
							; 1997	LSH		"SHSTYLE/NORM"	;LSH SHIFT (SAME HARDWARE AS ASH BUT
							; 1998					; BITS -2 AND -1 ARE PRESET TO ZERO)
							; 1999	ROT		"SHSTYLE/ROT"
							; 2000	LSHC		"SHSTYLE/LSHC"
							; 2001	ASHC		"SHSTYLE/ASHC"
							; 2002	ROTC		"SHSTYLE/ROTC"
							; 2003	ONES		"SHSTYLE/ONES"	;SHIFT IN 1 BITS
							; 2004	DIV		"SHSTYLE/DIV"	;SPECIAL PATH FOR DIVIDE (LIKE ROTC BUT
							; 2005					; COMPLEMENT BIT AS IT GOES AROUND)
							; 2006	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 55
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- SPECIAL FUNCTIONS				

							; 2007	.TOC	"MACROS -- SPECIAL FUNCTIONS"
							; 2008	
							; 2009	LOAD IR		"SPEC/LOADIR"	;LOAD INSTRUCTION REG FROM
							; 2010					; DBUS0-DBUS8, LOAD AC# FROM
							; 2011					; DBUS9-DBUS12
							; 2012					; UPDATE LAST-INST-PUBLIC PC FLAG
							; 2013	LOAD INST	"SPEC/LDINST"
							; 2014	LOAD INST EA	"SPEC/LOADXR,PXCT/CURRENT"
							; 2015	LOAD BYTE EA	"SPEC/LOADXR,PXCT/E2"
							; 2016	LOAD IND EA	"SPEC/LOADXR,PXCT/E1"
							; 2017	LOAD SRC EA	"SPEC/LOADXR,PXCT/BIS-SRC-EA"
							; 2018	LOAD DST EA	"SPEC/LOADXR,PXCT/BIS-DST-EA"
							; 2019	ADD .25		"CRY38/1"	;GENERATE CARRY IN TO BIT 37
							; 2020	CALL []		"CALL/1,J/@1"	;CALL A SUBROUTINE
							; 2021	LOAD PXCT	"SPEC/LDPXCT"	;LOAD PXCT FLAGS IF EXEC MODE
							; 2022	TURN OFF PXCT	"SPEC/PXCT OFF"
							; 2023	LOAD PAGE TABLE	"SPEC/LDPAGE"
							; 2024	LOAD AC BLOCKS	"SPEC/LDACBLK"
							; 2025	SWEEP		"SPEC/SWEEP,PHYSICAL/1"
							; 2026	CLRCSH		"SPEC/CLRCSH,PHYSICAL/1"
							; 2027	LOAD PI		"SPEC/LDPI"
							; 2028	SET HALT	"SPEC/#,#/74"
							; 2029	CLEAR CONTINUE	"SPEC/#,#/40"
							; 2030	CLEAR EXECUTE	"SPEC/#,#/20"
							; 2031	CLEAR RUN	"SPEC/#,#/10"
							; 2032	UNHALT		"SPEC/#,#/62"
							; 2033	SET APR ENABLES	"SPEC/APR EN"
							; 2034	ABORT MEM CYCLE	"DBUS/DBM,RAMADR/VMA,DBM/MEM,AD/ZERO,SPEC/MEMCLR,LOAD VMA"
							; 2035	CLR IO BUSY	"SPEC/CLR IO BUSY"
							; 2036	CLR IO LATCH	"SPEC/CLR IO LATCH"
							; 2037	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 56
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- PC FLAGS					

							; 2038	.TOC	"MACROS -- PC FLAGS"
							; 2039	
							; 2040	CHANGE FLAGS	"SPEC/FLAGS"
							; 2041	
							; 2042	SET AROV	"CHANGE FLAGS, HOLD USER/1, SETOV/1, TRAP1/1"
							; 2043	SET FOV		"CHANGE FLAGS, HOLD USER/1, SETFOV/1, TRAP1/1"
							; 2044	SET NO DIVIDE	"CHANGE FLAGS, HOLD USER/1, SETOV/1, SETNDV/1, TRAP1/1"
							; 2045	SET FL NO DIVIDE "SET NO DIVIDE, SETFOV/1"
							; 2046	
							; 2047	ASH AROV	"SPEC/ASHOV"
							; 2048	SET FPD		"CHANGE FLAGS, HOLD USER/1, SETFPD/1"
							; 2049	CLR FPD		"CHANGE FLAGS, HOLD USER/1, CLRFPD/1"
							; 2050	
							; 2051	SET PDL OV	"CHANGE FLAGS, HOLD USER/1, TRAP2/1"
							; 2052	SET TRAP1	"CHANGE FLAGS, HOLD USER/1, TRAP1/1"
							; 2053	
							; 2054	LOAD PCU	"CHANGE FLAGS, LD PCU/1"
							; 2055	UPDATE USER	"CHANGE FLAGS, HOLD USER/1"
							; 2056	LEAVE USER	"CHANGE FLAGS, HOLD USER/0"
							; 2057	
							; 2058	JFCL FLAGS	"CHANGE FLAGS, HOLD USER/1, JFCLFLG/1"
							; 2059	
							; 2060	LOAD FLAGS	"CHANGE FLAGS, LD FLAGS/1"
							; 2061	EXP TEST	"SPEC/EXPTST"
							; 2062	AD FLAGS	"CHANGE FLAGS, ADFLGS/1, HOLD USER/1"
							; 2063	
							; 2064	NO DIVIDE	"SET NO DIVIDE, J/NIDISP"
							; 2065	FL NO DIVIDE	"SET FL NO DIVIDE, J/NIDISP"
							; 2066	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 57
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- PAGE FAIL FLAGS				

							; 2067	.TOC	"MACROS -- PAGE FAIL FLAGS"
							; 2068	
							; 2069	STATE_[]	"[FLG]_#,STATE/@1,HOLD LEFT"
							; 2070	END STATE	"[FLG]_0, HOLD LEFT"
							; 2071	
							; 2072	END BLT		"END STATE"
							; 2073	END MAP		"END STATE"
							; 2074	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 58
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- SINGLE SKIPS					

							; 2075	.TOC	"MACROS -- SINGLE SKIPS"
							; 2076					;SKIPS IF:
							; 2077	SKIP IF AC0	"SKIP/AC0"	;THE AC NUMBER IS ZERO
							; 2078	SKIP DP0	"SKIP/DP0"	;DP BIT 0=1
							; 2079	SKIP DP18	"SKIP/DP18"	;DP BIT 18=1
							; 2080	SKIP AD.EQ.0	"SKIP/ADEQ0,DT/3T" ;ADDER OUTPUT IS ZERO
							; 2081	SKIP AD.LE.0	"SKIP/LE,DT/3T" ;ADDER OUTPUT IS LESS THAN OR EQUAL
							; 2082					; TO ZERO.
							; 2083	SKIP ADL.LE.0	"SKIP/LLE,DT/3T" ;ADDER LEFT IS LESS THAN OR EQUAL
							; 2084					; TO ZERO.
							; 2085	SKIP FPD	"SKIP/FPD"	;FIRST-PART-DONE PC FLAG IS SET
							; 2086	SKIP KERNEL	"SKIP/KERNEL"	;USER=0
							; 2087	SKIP IO LEGAL	"SKIP/IOLGL"	;USER=0 OR USER IOT=1
							; 2088	SKIP CRY0	"SKIP/CRY0"	;ADDER BIT CRY0=1 (NOT PC FLAG BIT)
							; 2089	SKIP CRY1	"SKIP/CRY1"	;ADDER BIT CRY1=1 (NOT PC FLAG BIT)
							; 2090	SKIP CRY2	"SKIP/CRY2,DT/3T"	;ADDER BIT CRY2=1
							; 2091	SKIP JFCL	"SKIP/JFCL"	;IF JFCL SHOULD JUMP
							; 2092	SKIP ADL.EQ.0	"SKIP/ADLEQ0"	;ALU BITS -2 TO 17 = 0
							; 2093	SKIP ADR.EQ.0	"SKIP/ADREQ0"	;ALU BITS 18-35 = 0
							; 2094	SKIP IRPT	"SKIP/INT"	;INTERRUPT IS PENDING
							; 2095	SKIP -1MS	"SKIP/-1 MS"	;DON'T SKIP IF 1MS TIMER HAS EXPIRED.
							; 2096	SKIP AC REF	"SKIP/ACREF"	;VMA IS 0-17
							; 2097	SKIP EXECUTE	"SKIP/EXECUTE"	;CONSOLE EXECUTE
							; 2098	TXXX TEST	"SKIP/TXXX"	;TEST INSTRUCTION SHOULD SKIP
							; 2099	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 59
; KS10.MIC[1,2]	23:44 29-MAY-2015				MACROS -- SPECIAL DISPATCH MACROS			

							; 2100	.TOC		"MACROS -- SPECIAL DISPATCH MACROS"
							; 2101	
							; 2102	NEXT INST	"DISP/NICOND,SPEC/NICOND,J/NICOND"
							; 2103	NEXT INST FETCH	"DISP/NICOND,SPEC/NICOND,J/NICOND-FETCH"
							; 2104	EA MODE DISP	"DISP/EAMODE,RAMADR/XR#"
							; 2105	AREAD		"DISP/AREAD,WAIT/1,AREAD/1,MEM/1,J/0"
							; 2106	B DISP		"DISP/BDISP"
							; 2107	BWRITE DISP	"B DISP,MEM/1,BWRITE/1,WRITE CYCLE/1,J/BWRITE"
							; 2108	INST DISP	"DISP/DROM,J/0"
							; 2109	EXIT		"BWRITE DISP,SPEC/0, WRITE TEST/1"
							; 2110	AD FLAGS EXIT	"BWRITE DISP, WRITE TEST/0, AD FLAGS"
							; 2111	FL-EXIT		"WRITE CYCLE/1,WRITE TEST/1,MEM/1,BWRITE/1,B DISP,J/FL-BWRITE"
							; 2112	TEST DISP	"B DISP,J/TEST-TABLE"
							; 2113	SKIP-COMP DISP	"B DISP,J/SKIP-COMP-TABLE"
							; 2114	JUMP DISP	"B DISP,J/JUMP-TABLE"
							; 2115	DONE		"VMA_[PC],LOAD VMA, FETCH, NEXT INST FETCH"
							; 2116	JUMPA		"[PC]_[AR],HOLD LEFT,LOAD VMA,FETCH,NEXT INST FETCH"
							; 2117	UUO		"[HR]_[HR].AND.#,#/777740,HOLD RIGHT,J/UUOGO"
							; 2118	LUUO		"[AR]_0 XWD [40], J/LUUO1"
							; 2119	PAGE FAIL TRAP	"TL [FLG], FLG.PI/1, J/PFT"
							; 2120	TAKE INTERRUPT	"[FLG]_[FLG].OR.#,FLG.PI/1,HOLD RIGHT,J/PI"
							; 2121	INTERRUPT TRAP	"WORK[SV.AR]_[AR], J/ITRAP"
							; 2122	MUL DISP	"DISP/MUL"
							; 2123	DIV DISP	"DISP/DIV"
							; 2124	BYTE DISP	"DISP/BYTE, DT/3T"
							; 2125	SCAD DISP	"DISP/SCAD0"	;SKIP (2'S WEIGHT) IS SCAD IS MINUS
							; 2126	RETURN []	"DISP/RETURN,J/@1"
							; 2127	PI DISP		"DISP/PI"
							; 2128	NORM DISP	"DISP/NORM,DT/3T"
							; 2129	DISMISS		"TR [PI], #/077400, CALL [JEN1],DT/3T"
							; 2130	CALL LOAD PI	"[T0]_[PI] SWAP, CALL [LDPI2]"
							; 2131	HALT []		"AD/47,DEST/AD,B/T1,DBM/#,DBUS/DBM,HALT/@1,RSRC/DA,A/MASK, J/HALTED"
							; 2132	CLEANUP DISP	"READ [FLG], DBUS/DP, DISP/DP, 3T, J/CLEANUP"
							; 2133	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 60
; KS10.MIC[1,2]	23:44 29-MAY-2015				DISPATCH ROM MACROS					

							; 2134	.TOC		"DISPATCH ROM MACROS"
							; 2135		.DCODE
							; 2136	
							; 2137	;"A FIELD" MACROS SAY HOW TO FETCH ARGUMENTS
							; 2138	
							; 2139	I	"I/1"
							; 2140	I-PF	"I/1,VMA/0,READ/1"
							; 2141	R	"A/READ,READ/1"
							; 2142	R-PF	"A/RD-PF,READ/1"
							; 2143	W	"A/WRITE,TEST/1"
							; 2144	RW	"A/READ,TEST/1,READ/1"
							; 2145	IW	"I/1,TEST/1"	;IMMED WHICH STORE IN E. (SETZM, ETC.)
							; 2146	IR	"I/1,READ/1"	;START READ A GO TO EXECUTE CODE
							; 2147	DBL R	"A/DREAD,READ/1"	;AR!ARX _ E!E+1
							; 2148	DBL AC	"A/DBLAC"
							; 2149	SH	"A/SHIFT,VMA/0,READ/1"
							; 2150	SHC	"A/DSHIFT,VMA/0,READ/1"
							; 2151	FL-R	"A/FP,READ/1"	;FLOATING POINT READ
							; 2152	FL-RW	"A/FP,READ/1,TEST/1"
							; 2153	FL-I	"A/FPI,READ/0"	;FLOATING POINT IMMEDIATE
							; 2154	DBL FL-R "A/DFP,READ/1"
							; 2155	IOT	"A/IOT"		;CHECK FOR IO LEGAL
							; 2156	
							; 2157	;"B FIELD" MACROS SAY HOW TO STORE RESULTS
							; 2158	
							; 2159	AC	"B/AC"
							; 2160	M	"B/MEM,TEST/1,COND FUNC/1"
							; 2161	B	"B/BOTH,TEST/1,COND FUNC/1"
							; 2162	S	"B/SELF,TEST/1,COND FUNC/1"
							; 2163	DAC	"B/DBLAC"
							; 2164	DBL B	"B/DBLB,TEST/1,COND FUNC/1"
							; 2165	FL-AC	"FL-B/AC"			;FLOATING POINT
							; 2166	FL-MEM	"FL-B/MEM,TEST/1,COND FUNC/1"	;FLOATING POINT TO MEMORY
							; 2167	FL-BOTH	"FL-B/BOTH,TEST/1,COND FUNC/1"	;FLOATING POINT TO BOTH
							; 2168	ROUND	"ROUND/1"			;FLOATING POINT ROUNDED
							; 2169	
							; 2170	
							; 2171	;CONTROL BITS
							; 2172	W TEST	"TEST/1"
							; 2173	AC DISP	"ACDISP/1"
							; 2174		.UCODE
							; 2175	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 61
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			DISPATCH ROM MACROS					

							; 2176		.BIN
							; 2177	.TOC	"POWER UP SEQUENCE"
							; 2178	
							; 2179		.UCODE
							; 2180	
							; 2181	;HERE IS WHERE WE FIRE THE MACHINE UP DURING POWER ON
							; 2182	
							; 2183	
U 0000, 0002,3771,0012,4374,4007,0700,0000,0037,7777	; 2184	0:	[MASK]_#, #/377777	;BUILD A MASK WITH
U 0002, 0013,3445,1212,4174,4007,0700,0000,0000,0000	; 2185		[MASK]_[MASK]*2 	; A ONE IN 36-BITS AND 0
U 0013, 0053,3551,1212,4374,4007,0700,0000,0000,0001	; 2186		[MASK]_[MASK].OR.#,#/1	; IN BITS -2,-1,36,37
U 0053, 0061,3447,1200,4174,4007,0700,0000,0000,0000	; 2187		[MAG]_[MASK]*.5 	;MAKE CONSTANT
U 0061, 0071,3771,0015,4374,4007,0700,0000,0000,0001	; 2188		[XWD1]_#, #/1		;CONSTANT WITH 1 IN EACH
							; 2189					; HALF WORD
							; 2190		[ONE]_0 XWD [1],	;THE CONSTANT 1
U 0071, 0003,4751,1207,4374,4007,0700,0010,0000,0001	; 2191		CALL/1			;RESET STACK (CAN NEVER RETURN
							; 2192					; TO WHERE MR LEFT US)
U 0003, 0100,4751,1203,4374,4007,0700,0000,0037,6000	; 2193	3:	[AR]_0 XWD [376000]	;ADDRESS OF HALT STATUS
							; 2194					; BLOCK
U 0100, 0106,3333,0003,7174,4007,0700,0400,0000,0227	; 2195		WORK[HSBADR]_[AR]	;SAVE FOR HALT LOOP
U 0106, 0110,4221,0011,4364,4277,0700,0200,0000,0010	; 2196		[UBR]_0, ABORT MEM CYCLE ;CLEAR THE UBR AND RESET
							; 2197					; MEMORY CONTROL LOGIC
U 0110, 0125,4221,0010,4174,4477,0700,0000,0000,0000	; 2198		[EBR]_0, LOAD AC BLOCKS ;CLEAR THE EBR AND FORCE
							; 2199					; PREVIOUS AND CURRENT AC
							; 2200					; BLOCKS TO ZERO
U 0125, 0131,4221,0013,4174,4257,0700,0000,0000,0000	; 2201		[FLG]_0, SET APR ENABLES ;CLEAR THE STATUS FLAGS AND
							; 2202					; DISABLE ALL APR CONDITIONS
U 0131, 0162,3333,0013,7174,4007,0700,0400,0000,0230	; 2203		WORK[APR]_[FLG] 	;ZERO REMEMBERED ENABLES
							; 2204	
U 0162, 0212,3333,0013,7174,4007,0700,0400,0000,0300	; 2205		WORK[TIME0]_[FLG]	;CLEAR TIME BASE
U 0212, 0214,3333,0013,7174,4007,0700,0400,0000,0301	; 2206		WORK[TIME1]_[FLG]	; ..
							; 2207	.IF/FULL
U 0214, 0223,4223,0000,1174,4007,0700,0400,0000,1443	; 2208		AC[BIN0]_0		;COMPUTE A TABLE OF POWERS OF
U 0223, 0226,3333,0007,1174,4007,0700,0400,0000,1444	; 2209		AC[BIN1]_1		; TEN
U 0226, 0235,4221,0003,4174,4007,0700,2000,0071,0023	; 2210		[AR]_0, SC_19.		;WE WANT TO GET 22 NUMBERS
U 0235, 0242,3333,0007,7174,4007,0700,0400,0000,0344	; 2211		WORK[DECLO]_1		;STARTING WITH 1
U 0242, 0244,4223,0000,7174,4007,0700,0400,0000,0373	; 2212		WORK[DECHI]_0		; ..
U 0244, 0311,3771,0002,4374,4007,0700,0000,0000,0344	; 2213		[HR]_#, WORK/DECLO	;ADDRESS OF LOW WORD
U 0311, 0323,3771,0006,4374,4007,0700,0000,0000,0373	; 2214		[BRX]_#, WORK/DECHI	;ADDRESS OF HIGH WORD
U 0323, 0010,0111,0706,4174,4007,0700,0200,0000,0010	; 2215	TENLP:	[BRX]_[BRX]+1, LOAD VMA ;ADDRESS THE HIGH WORD
							; 2216	=0*	[ARX]_AC[BIN1], 	;LOW WORD TO ARX
U 0010, 0560,3771,0004,1276,6007,0701,0010,0000,1444	; 2217		CALL [DBSLOW]		;MULTIPLY BY TEN
U 0012, 0324,3333,0005,6174,4007,0700,0400,0000,0000	; 2218		RAM_[BR]		;SAVE HIGH WORD
U 0324, 0334,0111,0702,4174,4007,0700,0200,0000,0010	; 2219		[HR]_[HR]+1, LOAD VMA	;WHERE TO STORE LOW WORD
U 0334, 0224,3333,0004,6174,4007,0630,2400,0060,0000	; 2220		RAM_[ARX], STEP SC	;STORE LOW WORD AND SEE IF
							; 2221					; WE ARE DONE
U 0224, 0323,4443,0000,4174,4007,0700,0000,0000,0000	; 2222	=0	J/TENLP 		;NOT YET--KEEP GOING
U 0225, 0140,6553,0500,4374,4007,0321,0000,0033,0656	; 2223		[BR].XOR.#, 3T, SKIP ADL.EQ.0, #/330656
							; 2224					;DID WE GET THE RIGHT ANSWER
							; 2225					; IN THE TOP 18 BITS?
U 0140, 0104,4751,1217,4374,4007,0700,0000,0000,1005	; 2226	=0**0	HALT [MULERR]		;NO--CPU IS BROKEN
							; 2227	.ENDIF/FULL
							; 2228	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 62
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			POWER UP SEQUENCE					

U 0141, 3647,4221,0014,4174,4007,0700,0010,0000,0000	; 2229	=0**1	[PI]_0, CALL [LOADPI]	;CLEAR PI STATE
							; 2230	=1**1				;CLEAR REGISTERS SO NO
							; 2231					;PARITY ERROR HAPPEN
							;;2232	.IFNOT/FULL
							;;2233		[ARX]_0 		;WRITTEN WHILE COMPUTING POWERS
							;;2234		[BR]_0			;OF 10
							;;2235		[BRX]_0
							; 2236	.ENDIF/FULL
U 0151, 0343,4751,1217,4374,4007,0700,0000,0000,0120	; 2237		[T1]_0 XWD [120]	;RH OF 120 CONTAINS START ADDRESS
							; 2238					; FOR SIMULATOR. FOR THE REAL
							; 2239					; MACHINE IT IS JUST DATA WITH
							; 2240					; GOOD PARITY.
							; 2241	=
							; 2242	;THE CODE UNDER .IF/SIM MUST USE THE SAME ADDRESS AS THE CODE
							; 2243	; UNDER .IFNOT/SIM SO THAT MICROCODE ADDRESSES DO NOT CHANGE BETWEEN
							; 2244	; VERSIONS
							;;2245	.IF/SIM
							;;2246		VMA_[T1], START READ	;READ THE WORD
							;;2247		MEM READ, [PC]_MEM, HOLD LEFT, J/START
							;;2248					;GO FIRE UP SIMULATOR AT THE
							;;2249					; PROGRAMS STARTING ADDRESS
							; 2250	.IFNOT/SIM
							; 2251		[PC]_0, 		;CLEAR LH OF PC
							; 2252		LEAVE USER,		;ENTER EXEC MODE
U 0343, 0346,4221,0001,4174,4467,0700,0000,0000,0004	; 2253		LOAD FLAGS		;CLEAR TRAP FLAGS
							; 2254		[T1]_#, HALT/POWER,	;LOAD T1 WITH POWER UP CODE
U 0346, 0116,3771,0017,4374,4007,0700,0000,0000,0000	; 2255		J/PWRON			;ENTER HALT LOOP. DO NOT STORE
							; 2256					; HALT STATUS BLOCK
							; 2257	.ENDIF/SIM
							; 2258	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 63
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- START NEXT INSTRUCTION		

							; 2259	.TOC	"THE INSTRUCTION LOOP -- START NEXT INSTRUCTION"
							; 2260	
							; 2261	;ALL INSTRUCTIONS EXCEPT JUMP'S AND UUO'S END UP HERE
							; 2262	1400:
U 1400, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 2263	DONE:	DONE
U 1401, 0110,0111,0701,4170,4156,4700,0200,0014,0012	; 2264	1401:	VMA_[PC]+1, NEXT INST FETCH, FETCH
							; 2265	=0
U 0260, 0110,0111,0701,4170,4156,4700,0200,0014,0012	; 2266	SKIP:	VMA_[PC]+1, NEXT INST FETCH, FETCH
U 0261, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 2267		DONE
							; 2268	
							; 2269	
							; 2270	;16-WAY DISPATCH BASED ON NEXT INSTRUCTION
							; 2271	=0000
							; 2272	NICOND:
							; 2273	=0001	[AR]_0 XWD [423],	;TRAP TYPE 3
							; 2274					; GET ADDRESS OF TRAP INST
							; 2275		TURN OFF PXCT,		;CLEAR PXCT
U 0101, 3534,4751,1203,4374,4367,0700,0000,0000,0423	; 2276		J/TRAP			;PROCESS TRAP (INOUT.MIC)
							; 2277	=0010	[AR]_0 XWD [422],	;TRAP TYPE 2
							; 2278		TURN OFF PXCT,		;CLEAR PXCT
U 0102, 3534,4751,1203,4374,4367,0700,0000,0000,0422	; 2279		J/TRAP			;GO TRAP
							; 2280	=0011	[AR]_0 XWD [421],	;TRAP TYPE 1
							; 2281		TURN OFF PXCT,		;TURN OF PXCT
U 0103, 3534,4751,1203,4374,4367,0700,0000,0000,0421	; 2282		J/TRAP			;GO TRAP
U 0105, 0104,4751,1217,4374,4007,0700,0000,0000,0002	; 2283	=0101	HALT [CSL]		;"HA" COMMAND TO 8080
							; 2284	=0111
							; 2285		VMA_[PC],		;LOAD VMA
							; 2286		FETCH,			;INDICATE INSTRUCTION FETCH
U 0107, 0117,3443,0100,4174,4007,0700,0200,0014,0012	; 2287		J/XCTGO 		;GO GET INSTRUCTION
							; 2288	;THE NEXT SET OF CASES ARE USED WHEN THERE IS A FETCH
							; 2289	; IN PROGESS
							; 2290	=1000
							; 2291	NICOND-FETCH:
							; 2292	=1001	[AR]_0 XWD [423],	;TRAP TYPE 3
							; 2293		TURN OFF PXCT,
U 0111, 3534,4751,1203,4374,4367,0700,0000,0000,0423	; 2294		J/TRAP
							; 2295	=1010	[AR]_0 XWD [422],	;TRAP TYPE 2
							; 2296		TURN OFF PXCT,
U 0112, 3534,4751,1203,4374,4367,0700,0000,0000,0422	; 2297		J/TRAP
							; 2298	=1011	[AR]_0 XWD [421],	;TRAP TYPE 1
							; 2299		TURN OFF PXCT,
U 0113, 3534,4751,1203,4374,4367,0700,0000,0000,0421	; 2300		J/TRAP
U 0115, 0104,4751,1217,4374,4007,0700,0000,0000,0002	; 2301	=1101	HALT [CSL]		;"HA" COMMAND TO 8080
							; 2302	=1111
							; 2303	XCTGO:	MEM READ,		;WAIT FOR MEMORY
							; 2304		[HR]_MEM,		;PUT DATA IN HR
							; 2305		LOAD INST,		;LOAD IR & AC #
U 0117, 0363,3771,0002,4365,5617,0700,0200,0000,0002	; 2306		J/INCPC 		;GO BUMP PC
							; 2307	=
							; 2308	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 64
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- START NEXT INSTRUCTION		

							; 2309	;HERE WE POINT PC TO NEXT INSTRUCTION WHILE WE WAIT FOR
							; 2310	; EFFECTIVE ADDRESS LOGIC TO SETTLE
							; 2311	INCPC:	VMA_[PC]+1,		;ADDRESS OF NEXT INSTRUCTION
							; 2312		FETCH/1,		;INSTRUCTION FETCH
							; 2313		TURN OFF PXCT,		;CLEAR EFFECT OF PXCT
U 0363, 0201,0111,0701,2170,4366,6700,0200,0010,0010	; 2314		EA MODE DISP		;DISPACTH OF INDEXING AND @
							; 2315	
							; 2316	;MAIN EFFECTIVE ADDRESS CALCULATION
							; 2317	=0001
							; 2318	EACALC:
							; 2319	;
							; 2320	;	THE FIRST 4 CASES ARE USED ONLY FOR JRST
							; 2321	;
							; 2322	
							; 2323	;CASE 0 -- JRST 0,FOO(XR)
							; 2324		[PC]_[HR]+XR,		;UPDATE PC
							; 2325		HOLD LEFT,		;ONLY RH
							; 2326		LOAD VMA, FETCH,	;START GETTING IT
U 0201, 0110,0551,0201,2270,4156,4700,0200,0014,0012	; 2327		NEXT INST FETCH 	;START NEXT INST
							; 2328	
							; 2329	;CASE 2 -- JRST 0,FOO
							; 2330		[PC]_[HR],		;NEW PC
							; 2331		HOLD LEFT,		;ONLY RH
							; 2332		LOAD VMA, FETCH,	;START GETTING IT
U 0203, 0110,3441,0201,4170,4156,4700,0200,0014,0012	; 2333		NEXT INST FETCH 	;START NEXT INST
							; 2334	
							; 2335	;CASE 4 -- JRST 0,@FOO(XR)
							; 2336		[HR]_[HR]+XR,		;ADD IN INDEX
							; 2337		START READ,		;START TO FETCH @ WORD
							; 2338		LOAD VMA,		;PUT ADDRESS IN VMA
U 0205, 0366,0551,0202,2270,4007,0700,0200,0004,0012	; 2339		J/FETIND		;GO DO MEM WAIT (FORGET ABOUT JRST)
							; 2340	
							; 2341	;CASE 6 -- JRST 0,@FOO
							; 2342		VMA_[HR],		;LOAD UP ADDRESS
							; 2343		START READ,		;START TO FETCH @ WORD
U 0207, 0366,3443,0200,4174,4007,0700,0200,0004,0012	; 2344		J/FETIND		;GO DO MEM WAIT (FORGET ABOUT JRST)
							; 2345	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 65
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- START NEXT INSTRUCTION		

							; 2346	;
							; 2347	;THESE 4 ARE FOR THE NON-JRST CASE
							; 2348	;
							; 2349	
							; 2350	;CASE 10 -- JUST INDEXING
							; 2351	INDEX:	[HR]_[HR]+XR,		;ADD IN INDEX REGISTER
U 0211, 0213,0551,0202,2270,4007,0700,0000,0000,0000	; 2352		HOLD LEFT		;JUST DO RIGHT HALF
							; 2353	
							; 2354	;CASE 12 -- NO INDEXING OR INDIRECT
							; 2355	NOMOD:	[AR]_EA,		;PUT 0,,E IN AR
U 0213, 0000,5741,0203,4174,4001,3700,0200,0000,0342	; 2356		PXCT DATA, AREAD	;DO ONE OR MORE OF THE FOLLWING
							; 2357					; ACCORDING TO THE DROM:
							; 2358					;1. LOAD VMA
							; 2359					;2. START READ OR WRITE
							; 2360					;3. DISPATCH TO 40-57
							; 2361					;   OR DIRECTLY TO EXECUTE CODE
							; 2362	
							; 2363	;CASE 14 -- BOTH INDEXING AND INDIRECT
							; 2364	BOTH:	[HR]_[HR]+XR,		;ADD IN INDEX REGISTER
							; 2365		LOAD VMA, PXCT EA,	;PUT ADDRESS IN VMA
U 0215, 0366,0551,0202,2270,4007,0700,0200,0004,0112	; 2366		START READ, J/FETIND	;START CYCLE AND GO WAIT FOR DATA
							; 2367	
							; 2368	;CASE 16 -- JUST INDIRECT
							; 2369	INDRCT: VMA_[HR],		;LOAD ADDRESS OF @ WORD
U 0217, 0366,3443,0200,4174,4007,0700,0200,0004,0112	; 2370		START READ, PXCT EA	;START CYCLE
							; 2371	
							; 2372	
							; 2373	;HERE TO FETCH INDIRECT WORD
							; 2374	FETIND: MEM READ, [HR]_MEM,	;GET DATA WORD
							; 2375		HOLD LEFT,		;JUST RIGHT HALF
U 0366, 0371,3771,0002,4361,5217,0700,0200,0000,0102	; 2376		LOAD IND EA		;RELOAD @ AND INDEX FLOPS
							; 2377	
							; 2378	XCT2:	VMA_[PC],		;PUT PC BACK IN VMA
							; 2379		FETCH/1,		;TURN ON FETCH FLAG
							; 2380		EA MODE DISP,		;REDO CALCULATION FOR
U 0371, 0201,3443,0100,2174,4006,6700,0200,0010,0010	; 2381		J/EACALC		; NEW WORD
							; 2382	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 66
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- FETCH ARGUMENTS			

							; 2383	.TOC	"THE INSTRUCTION LOOP -- FETCH ARGUMENTS"
							; 2384	;HERE ON AREAD DISP TO HANDLE VARIOUS CASES OF ARGUMENT FETCH
							; 2385	
							; 2386	;CASE 0 -- READ (E)
							; 2387	40:	MEM READ,		;WAIT FOR DATA
							; 2388		[AR]_MEM,		;PUT WORD IN AR
U 0040, 0000,3771,0003,4365,5001,2700,0200,0000,0002	; 2389		INST DISP		;GO TO EXECUTE CODE
							; 2390	
							; 2391	;CASE 1 -- WRITE (E)
							; 2392	41:	[AR]_AC,		;PUT AC IN AR
U 0041, 0000,3771,0003,0276,6001,2700,0000,0000,0000	; 2393		INST DISP		;GO TO EXECUTE CODE
							; 2394	
							; 2395	;CASE 2 -- DOUBLE READ
							; 2396	42:	MEM READ,		;WAIT FOR DATA
U 0042, 0401,3771,0003,4365,5007,0700,0200,0000,0002	; 2397		[AR]_MEM		;PUT HI WORD IN AR
							; 2398		VMA_[HR]+1, PXCT DATA,	;POINT TO E+1
U 0401, 0406,0111,0702,4170,4007,0700,0200,0004,0312	; 2399		START READ		;START MEMORY CYCLE
							; 2400		MEM READ,		;WAIT FOR DATA
							; 2401		[ARX]_MEM,		;LOW WORD IN ARX
U 0406, 0000,3771,0004,4365,5001,2700,0200,0000,0002	; 2402		INST DISP		;GO TO EXECUTE CODE
							; 2403	
							; 2404	;CASE 3 -- DOUBLE AC
U 0043, 0415,3771,0003,0276,6007,0700,0000,0000,0000	; 2405	43:	[AR]_AC 		;GET HIGH AC
							; 2406		[ARX]_AC[1],		;PUT C(AC+1) IN ARX
U 0415, 0000,3771,0004,1276,6001,2701,0000,0000,1441	; 2407		INST DISP		;GO TO EXECUTE CODE
							; 2408	
							; 2409	;CASE 4 -- SHIFT
							; 2410	44:
							; 2411	SHIFT:	READ [AR],		;LOOK AT EFFECTIVE ADDRESS
							; 2412		SKIP DP18,		;SEE IF LEFT OR RIGHT
							; 2413		SC_SHIFT-1,		;PUT NUMBER OF PLACES TO SHIFT IN
							; 2414		LOAD FE,		; SC AND FE
U 0044, 0000,3333,0003,4174,4001,2530,3000,0041,5777	; 2415		INST DISP		;GO DO THE SHIFT
							; 2416	
							; 2417	;CASE 5 -- SHIFT COMBINED
U 0045, 0416,3772,0000,1275,5007,0701,0000,0000,1441	; 2418	45:	Q_AC[1] 		;PUT LOW WORD IN Q
U 0416, 0431,3776,0005,0274,4007,0701,0000,0000,0000	; 2419		[BR]_AC*.5 LONG 	;PUT AC IN BR & SHIFT BR!Q RIGHT
							; 2420		[BR]_[BR]*.5 LONG,	;SHIFT BR!Q 1 MORE PLACE RIGHT
U 0431, 0044,3446,0505,4174,4007,0700,0000,0000,0000	; 2421		J/SHIFT 		;GO DO SHIFT SETUP
							; 2422	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 67
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- FETCH ARGUMENTS			

							; 2423	;CASE 6 -- FLOATING POINT IMMEDIATE
							; 2424	46:	[AR]_[AR] SWAP,		;FLIP BITS TO LEFT HALF
U 0046, 0372,3770,0303,4344,4007,0700,0000,0000,0000	; 2425		J/FPR0			;JOIN COMMON F.P. CODE
							; 2426	
							; 2427	;CASE 7 -- FLOATING POINT
							; 2428	47:	MEM READ,		;WAIT FOR MEMORY (SPEC/MEM WAIT)
U 0047, 0372,3771,0003,4365,5007,0700,0200,0000,0002	; 2429		[AR]_MEM		;DATA INTO AR
							; 2430	=0
							; 2431	FPR0:	READ [AR],		;LOOK AT NUMBER
							; 2432		SC_EXP, FE_EXP, 	;PUT EXPONENT IN SC & FE
							; 2433		SKIP DP0,		;SEE IF NEGATIVE
U 0372, 0412,3333,0003,4174,4007,0520,3010,0041,2000	; 2434		CALL [ARSIGN]		;EXTEND AR SIGN
							; 2435	FPR1:	[ARX]_0,		;ZERO ARX
U 0373, 0000,4221,0004,4174,4001,2700,0000,0000,0000	; 2436		INST DISP		;GO TO EXECUTE CODE
							; 2437	
							; 2438	;CASE 10 -- READ THEN PREFETCH
							; 2439	50:	MEM READ,		;WAIT FOR DATA
							; 2440		[AR]_MEM THEN FETCH,	;PUT DATA IN AR AND START A READ
							; 2441					; VMA HAS PC+1.
U 0050, 0000,3770,0103,4365,5001,2700,0200,0014,0012	; 2442		INST DISP		;GO DO IT
							; 2443	
							; 2444	;CASE 11 -- DOUBLE FLOATING READ
							; 2445	51:	SPEC MEM READ,		;WAIT FOR DATA
							; 2446		[BR]_MEM,		;HOLD IN BR
							; 2447		SC_EXP, FE_EXP, 	;SAVE EXPONENT
U 0051, 0402,3771,0005,4365,5177,0521,3000,0041,2000	; 2448		SKIP DP0, 3T		;SEE IF MINUS
							; 2449	=0	[AR]_[AR]+1,		;POINT TO E+1
							; 2450		LOAD VMA, PXCT DATA,	;PUT IN VMA
U 0402, 0445,0111,0703,4174,4007,0700,0200,0004,0312	; 2451		START READ, J/DFPR1	;GO GET POSITIVE DATA
							; 2452		[AR]_[AR]+1,		;POINT TO E+1
							; 2453		LOAD VMA, PXCT DATA,	;PUT IN VMA
U 0403, 0432,0111,0703,4174,4007,0700,0200,0004,0312	; 2454		START READ		;GO GET NEGATIVE DATA
							; 2455		[BR]_-SIGN,		;SMEAR MINUS SIGN
U 0432, 0451,3551,0505,4374,0007,0700,0000,0077,7000	; 2456		J/DFPR2 		;CONTINUE BELOW
U 0445, 0451,4551,0505,4374,0007,0700,0000,0000,0777	; 2457	DFPR1:	[BR]_+SIGN		;SMEAR PLUS SIGN
							; 2458	DFPR2:	MEM READ, 3T,		;WAIT FOR MEMORY
							; 2459		[ARX]_(MEM.AND.[MAG])*.5,
U 0451, 0452,4557,0004,4365,5007,0701,0200,0000,0002	; 2460		ASH			;SET SHIFT PATHS
U 0452, 0467,3447,0503,4174,4007,0700,0000,0000,0000	; 2461		[AR]_[BR]*.5		;SHIFT AR
							; 2462		[AR]_[AR]*.5,		;COMPLETE SHIFTING
U 0467, 0471,3447,0303,4174,4007,0700,2000,0011,0000	; 2463		SC_FE			;PAGE FAIL MAY HAVE ZAPPED
							; 2464					; THE SC.
							; 2465		VMA_[PC], FETCH,	;GET NEXT INST
U 0471, 0000,3443,0100,4174,4001,2700,0200,0014,0012	; 2466		INST DISP		;DO THIS ONE
							; 2467	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 68
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- FETCH ARGUMENTS			

							; 2468	;CASE 12 -- TEST FOR IO LEGAL
U 0052, 0404,4443,0000,4174,4007,0040,0000,0000,0000	; 2469	52:	SKIP IO LEGAL		;IS IO LEGAL?
U 0404, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 2470	=0	UUO			;NO
U 0405, 0000,4443,0000,4174,4001,2700,0000,0000,0000	; 2471		INST DISP		;YES--DO THE INSTRUCTION
							; 2472	
							; 2473	
							; 2474	;CASE 13 -- RESERVED
							; 2475	;53:
							; 2476	
							; 2477	;CASE 14 -- RESERVED
							; 2478	;54:
							; 2479	
							; 2480	;CASE 15 -- RESERVED
							; 2481	;55:
							; 2482	
							; 2483	;CASE 16 -- RESERVED
							; 2484	;56:
							; 2485	
							; 2486	;CASE 17 -- RESERVED
							; 2487	;57:
							; 2488	
							; 2489	;EXTEND AR SIGN.
							; 2490	;CALL WITH SKIP ON AR0, RETURNS 1 ALWAYS
							; 2491	=0
U 0412, 0001,4551,0303,4374,0004,1700,0000,0000,0777	; 2492	ARSIGN:	[AR]_+SIGN, RETURN [1]	;EXTEND + SIGN
U 0413, 0001,3551,0303,4374,0004,1700,0000,0077,7000	; 2493		[AR]_-SIGN, RETURN [1]	;EXTEND - SIGN
							; 2494	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 69
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- STORE ANSWERS			

							; 2495	.TOC	"THE INSTRUCTION LOOP -- STORE ANSWERS"
							; 2496	
							; 2497	;NOTE:	INSTRUCTIONS WHICH STORE IN BOTH AC AND MEMORY
							; 2498	;	(E.G. ADDB, AOS)  MUST STORE IN MEMORY FIRST
							; 2499	;	SO THAT IF A PAGE FAIL HAPPENS THE  AC IS
							; 2500	;	STILL INTACT.
							; 2501	
							; 2502	1500:
							; 2503	BWRITE: ;BASE ADDRESS OF BWRITE DISPATCH
							; 2504	
							; 2505	;CASE 0 -- RESERVED
							; 2506	;1500:
							; 2507	
							; 2508	;CASE 1  --  RESERVED
							; 2509	;1501:
							; 2510	
							; 2511	;CASE 2  --  RESERVED
							; 2512	;1502:
							; 2513	
							; 2514	;CASE 3  --  RESERVED
							; 2515	;1503:
							; 2516	
							; 2517	;CASE 4 -- STORE SELF
							; 2518	1504:
							; 2519	STSELF: SKIP IF AC0,		;IS AC # ZERO?
U 1504, 0434,4443,0000,4174,4007,0360,0000,0000,0000	; 2520		J/STBTH1		;GO TO STORE BOTH CASE
							; 2521	
							; 2522	;CASE 5 -- STORE DOUBLE AC
							; 2523	1505:
							; 2524	DAC:	AC[1]_[ARX],		;STORE AC 1
U 1505, 1515,3440,0404,1174,4007,0700,0400,0000,1441	; 2525		J/STAC			;GO STORE AC
							; 2526	
							; 2527	;CASE 6 -- STORE DOUBLE BOTH (KA10 STYLE MEM_AR ONLY)
							; 2528	1506:
							; 2529	STDBTH: MEM WRITE,		;WAIT FOR MEMORY
							; 2530		MEM_[AR],		;STORE AR
U 1506, 1505,3333,0003,4175,5007,0701,0200,0000,0002	; 2531		J/DAC			;NOW STORE AC & AC+1
							; 2532	
							; 2533	;CASE 7 -- RESERVED
							; 2534	;1507:
							; 2535	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 70
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			THE INSTRUCTION LOOP -- STORE ANSWERS			

							; 2536	;CASE 10  --  RESERVED
							; 2537	;1510:
							; 2538	
							; 2539	;CASE 11  --  RESERVED
							; 2540	;1511:
							; 2541	
							; 2542	;CASE 12  --  RESERVED
							; 2543	;1512:
							; 2544	
							; 2545	;CASE 13  --  RESERVED
							; 2546	;1513:
							; 2547	
							; 2548	;CASE 14  --  RESERVED
							; 2549	1514:
							; 2550	FL-BWRITE:			;THE NEXT 4 CASES ARE ALSO 
							; 2551					;USED IN FLOATING POINT
U 1514, 0104,4751,1217,4374,4007,0700,0000,0000,1000	; 2552		HALT	[BW14]
							; 2553	
							; 2554	;CASE 15 -- STORE AC
							; 2555	1515:
							; 2556	STAC:	AC_[AR],		;STORE AC
U 1515, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 2557		NEXT INST		;DO NEXT INSTRUCTION
							; 2558	
							; 2559	;CASE 16 -- STORE IN MEMORY
							; 2560	1516:
							; 2561	STMEM:	MEM WRITE,		;WAIT FOR MEMORY
							; 2562		MEM_[AR],		;STORE AR
U 1516, 1400,3333,0003,4175,5007,0701,0200,0000,0002	; 2563		J/DONE			;START FETCH OF NEXT
							; 2564	
							; 2565	;CASE 17 -- STORE BOTH
							; 2566	1517:
							; 2567	STBOTH: MEM WRITE,		;WAIT FOR MEMORY
							; 2568		MEM_[AR],		;STORE AR
U 1517, 1515,3333,0003,4175,5007,0701,0200,0000,0002	; 2569		J/STAC			;NOW STORE AC
							; 2570	
							; 2571	=0
							; 2572	STBTH1: MEM WRITE,		;WAIT FOR MEMORY
							; 2573		MEM_[AR],		;STORE AR
U 0434, 1515,3333,0003,4175,5007,0701,0200,0000,0002	; 2574		J/STAC			;NOW STORE AC
							; 2575	STORE:	MEM WRITE,		;WAIT FOR MEMORY
							; 2576		MEM_[AR],		;STORE AC
U 0435, 1400,3333,0003,4175,5007,0701,0200,0000,0002	; 2577		J/DONE			;START NEXT INST
							; 2578	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 71
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			MOVE GROUP						

							; 2579	.TOC	"MOVE GROUP"
							; 2580	
							; 2581		.DCODE
D 0200, 1015,1515,1100					; 2582	200:	R-PF,	AC,	J/STAC		;MOVE
D 0201, 0015,1515,3000					; 2583		I-PF,	AC,	J/STAC		;MOVEI
D 0202, 0116,1404,0700					; 2584		W,	M,	J/MOVE		;MOVEM
D 0203, 0004,1504,1700					; 2585		RW,	S,	J/STSELF	;MOVES
							; 2586	
D 0204, 1015,1402,1100					; 2587	204:	R-PF,	AC,	J/MOVS		;MOVS
D 0205, 0015,1402,3000					; 2588		I-PF,	AC,	J/MOVS		;MOVSI
D 0206, 0116,1402,0700					; 2589		W,	M,	J/MOVS		;MOVSM
D 0207, 0004,1402,1700					; 2590		RW,	S,	J/MOVS		;MOVSS
							; 2591	
D 0210, 1015,1405,1100					; 2592	210:	R-PF,	AC,	J/MOVN		;MOVN
D 0211, 0015,1405,3000					; 2593		I-PF,	AC,	J/MOVN		;MOVNI
D 0212, 0116,1405,0700					; 2594		W,	M,	J/MOVN		;MOVNM
D 0213, 0004,1405,1700					; 2595		RW,	S,	J/MOVN		;MOVNS
							; 2596	
D 0214, 1015,1403,1100					; 2597	214:	R-PF,	AC,	J/MOVM		;MOVM
D 0215, 0015,1515,3000					; 2598		I-PF,	AC,	J/STAC		;MOVMI
D 0216, 0116,1403,0700					; 2599		W,	M,	J/MOVM		;MOVMM
D 0217, 0004,1403,1700					; 2600		RW,	S,	J/MOVM		;MOVNS
							; 2601		.UCODE
							; 2602	
							; 2603	1402:
U 1402, 1500,3770,0303,4344,4003,7700,0200,0003,0001	; 2604	MOVS:	[AR]_[AR] SWAP,EXIT
							; 2605	
							; 2606	1403:
U 1403, 1404,3333,0003,4174,4007,0520,0000,0000,0000	; 2607	MOVM:	READ [AR], SKIP DP0, J/MOVE
							; 2608	
							; 2609	1404:
U 1404, 1500,4443,0000,4174,4003,7700,0200,0003,0001	; 2610	MOVE:	EXIT
							; 2611	1405:
							; 2612	MOVN:	[AR]_-[AR],		;NEGATE NUMBER
							; 2613		AD FLAGS, 3T,		;UPDATE FLAGS
U 1405, 1404,2441,0303,4174,4467,0701,4000,0001,0001	; 2614		J/MOVE			;STORE ANSWER
							; 2615	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 72
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			EXCH							

							; 2616	.TOC	"EXCH"
							; 2617	
							; 2618		.DCODE
D 0250, 0015,1406,1500					; 2619	250:	R,W TEST,	AC,	J/EXCH
							; 2620		.UCODE
							; 2621	
							; 2622	1406:
							; 2623	EXCH:	[BR]_AC,		;COPY AC TO THE BR
U 1406, 0506,3771,0005,0276,6007,0700,0200,0003,0002	; 2624		START WRITE		;START A WRITE CYCLE
							; 2625		MEM WRITE,		;COMPLETE WRITE CYCLE
							; 2626		MEM_[BR],		;STORE BR (AC) IN MEMORY
U 0506, 1515,3333,0005,4175,5007,0701,0200,0000,0002	; 2627		J/STAC			;STORE THE AR IN AC. NOTE: AR
							; 2628					; WAS LOADED WITH MEMORY OPERAND
							; 2629					; AS PART OF INSTRUCTION DISPATCH
							; 2630	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 73
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2631	.TOC	"HALFWORD GROUP"
							; 2632	;	DESTINATION LEFT HALF
							; 2633	
							; 2634		.DCODE
D 0500, 1015,1410,1100					; 2635	500:	R-PF,	AC,	J/HLL
D 0501, 0015,1410,3000					; 2636		I-PF,	AC,	J/HLL
D 0502, 0016,1407,1700					; 2637		RW,	M,	J/HRR		;HLLM = HRR EXCEPT FOR STORE
D 0503, 0004,1404,1700					; 2638		RW,	S,	J/MOVE		;HLLS = MOVES
							; 2639	
D 0504, 1015,1411,1100					; 2640		R-PF,	AC,	J/HRL
D 0505, 0015,1411,3000					; 2641		I-PF,	AC,	J/HRL
D 0506, 0016,1413,1700					; 2642		RW,	M,	J/HRLM
D 0507, 0004,1414,1700					; 2643		RW,	S,	J/HRLS
							; 2644	
D 0510, 1015,1432,1100					; 2645	510:	R-PF,	AC,	J/HLLZ
D 0511, 0015,1432,3000					; 2646		I-PF,	AC,	J/HLLZ
D 0512, 0116,1432,0700					; 2647		W,	M,	J/HLLZ
D 0513, 0004,1432,1700					; 2648		RW,	S,	J/HLLZ
							; 2649	
D 0514, 1015,1424,1100					; 2650		R-PF,	AC,	J/HRLZ
D 0515, 0015,1424,3000					; 2651		I-PF,	AC,	J/HRLZ
D 0516, 0116,1424,0700					; 2652		W,	M,	J/HRLZ
D 0517, 0004,1424,1700					; 2653		RW,	S,	J/HRLZ
							; 2654	
D 0520, 1015,1433,1100					; 2655	520:	R-PF,	AC,	J/HLLO
D 0521, 0015,1433,3000					; 2656		I-PF,	AC,	J/HLLO
D 0522, 0116,1433,0700					; 2657		W,	M,	J/HLLO
D 0523, 0004,1433,1700					; 2658		RW,	S,	J/HLLO
							; 2659	
D 0524, 1015,1425,1100					; 2660		R-PF,	AC,	J/HRLO
D 0525, 0015,1425,3000					; 2661		I-PF,	AC,	J/HRLO
D 0526, 0116,1425,0700					; 2662		W,	M,	J/HRLO
D 0527, 0004,1425,1700					; 2663		RW,	S,	J/HRLO
							; 2664	
D 0530, 1015,1430,1100					; 2665	530:	R-PF,	AC,	J/HLLE
D 0531, 0015,1430,3000					; 2666		I-PF,	AC,	J/HLLE
D 0532, 0116,1430,0700					; 2667		W,	M,	J/HLLE
D 0533, 0004,1430,1700					; 2668		RW,	S,	J/HLLE
							; 2669	
D 0534, 1015,1422,1100					; 2670		R-PF,	AC,	J/HRLE
D 0535, 0015,1422,3000					; 2671		I-PF,	AC,	J/HRLE
D 0536, 0116,1422,0700					; 2672		W,	M,	J/HRLE
D 0537, 0004,1422,1700					; 2673		RW,	S,	J/HRLE
							; 2674	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 74
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2675	;	DESTINATION RIGHT HALF
							; 2676	
D 0540, 1015,1407,1100					; 2677	540:	R-PF,	AC,	J/HRR
D 0541, 0015,1407,3000					; 2678		I-PF,	AC,	J/HRR
D 0542, 0016,1410,1700					; 2679		RW,	M,	J/HLL		;HRRM = HLL EXCEPT FOR STORE
D 0543, 0004,1404,1700					; 2680		RW,	S,	J/MOVE		;HRRS = MOVES
							; 2681	
D 0544, 1015,1412,1100					; 2682		R-PF,	AC,	J/HLR
D 0545, 0015,1412,3000					; 2683		I-PF,	AC,	J/HLR
D 0546, 0016,1415,1700					; 2684		RW,	M,	J/HLRM
D 0547, 0004,1416,1700					; 2685		RW,	S,	J/HLRS
							; 2686	
D 0550, 1015,1420,1100					; 2687	550:	R-PF,	AC,	J/HRRZ
D 0551, 0015,1420,3000					; 2688		I-PF,	AC,	J/HRRZ
D 0552, 0116,1420,0700					; 2689		W,	M,	J/HRRZ
D 0553, 0004,1420,1700					; 2690		RW,	S,	J/HRRZ
							; 2691	
D 0554, 1015,1426,1100					; 2692		R-PF,	AC,	J/HLRZ
D 0555, 0015,1426,3000					; 2693		I-PF,	AC,	J/HLRZ
D 0556, 0116,1426,0700					; 2694		W,	M,	J/HLRZ
D 0557, 0004,1426,1700					; 2695		RW,	S,	J/HLRZ
							; 2696	
D 0560, 1015,1421,1100					; 2697	560:	R-PF,	AC,	J/HRRO
D 0561, 0015,1421,3000					; 2698		I-PF,	AC,	J/HRRO
D 0562, 0116,1421,0700					; 2699		W,	M,	J/HRRO
D 0563, 0004,1421,1700					; 2700		RW,	S,	J/HRRO
							; 2701	
D 0564, 1015,1427,1100					; 2702		R-PF,	AC,	J/HLRO
D 0565, 0015,1427,3000					; 2703		I-PF,	AC,	J/HLRO
D 0566, 0116,1427,0700					; 2704		W,	M,	J/HLRO
D 0567, 0004,1427,1700					; 2705		RW,	S,	J/HLRO
							; 2706	
D 0570, 1015,1417,1100					; 2707	570:	R-PF,	AC,	J/HRRE
D 0571, 0015,1417,3000					; 2708		I-PF,	AC,	J/HRRE
D 0572, 0116,1417,0700					; 2709		W,	M,	J/HRRE
D 0573, 0004,1417,1700					; 2710		RW,	S,	J/HRRE
							; 2711	
D 0574, 1015,1423,1100					; 2712		R-PF,	AC,	J/HLRE
D 0575, 0015,1423,3000					; 2713		I-PF,	AC,	J/HLRE
D 0576, 0116,1423,0700					; 2714		W,	M,	J/HLRE
D 0577, 0004,1423,1700					; 2715		RW,	S,	J/HLRE
							; 2716	
							; 2717		.UCODE
							; 2718	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 75
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2719	;FIRST THE GUYS THAT LEAVE THE OTHER HALF ALONE
							; 2720	
							; 2721	;THE AR CONTAINS THE MEMORY OPERAND. SO WE WANT TO PUT THE LH OF
							; 2722	; AC INTO AR TO DO A HRR. OBVIOUS THING FOR HLL.
							; 2723	1407:
U 1407, 1500,3771,0003,0276,0003,7700,0200,0003,0001	; 2724	HRR:	[AR]_AC,HOLD RIGHT,EXIT
							; 2725	1410:
U 1410, 1500,3771,0003,0270,6003,7700,0200,0003,0001	; 2726	HLL:	[AR]_AC,HOLD LEFT,EXIT
							; 2727	
							; 2728	;HRL FLOW:
							; 2729	;AT HRL AR CONTAINS:
							; 2730	;
							; 2731	;	!------------------!------------------!
							; 2732	;	!     LH OF (E)    !	 RH OF (E)    !
							; 2733	;	!------------------!------------------!
							; 2734	;
							; 2735	;AR_AR SWAP GIVES:
							; 2736	;
							; 2737	;	!------------------!------------------!
							; 2738	;	!     RH OF (E)    !	 LH OF (E)    !
							; 2739	;	!------------------!------------------!
							; 2740	;
							; 2741	;AT HLL, AR_AC,HOLD LEFT GIVES:
							; 2742	;
							; 2743	;	!------------------!------------------!
							; 2744	;	!     RH OF (E)    !	 RH OF AC     !
							; 2745	;	!------------------!------------------!
							; 2746	;
							; 2747	;THE EXIT MACRO CAUSES THE AR TO BE STORED IN AC (AT STAC).
							; 2748	; THE REST OF THE HALF WORD IN THIS GROUP ARE VERY SIMILAR.
							; 2749	
							; 2750	1411:
U 1411, 1410,3770,0303,4344,4007,0700,0000,0000,0000	; 2751	HRL:	[AR]_[AR] SWAP,J/HLL
							; 2752	1412:
U 1412, 1407,3770,0303,4344,4007,0700,0000,0000,0000	; 2753	HLR:	[AR]_[AR] SWAP,J/HRR
							; 2754	
							; 2755	1413:
U 1413, 0511,3770,0303,4344,4007,0700,0000,0000,0000	; 2756	HRLM:	[AR]_[AR] SWAP
U 0511, 1402,3771,0003,0270,6007,0700,0000,0000,0000	; 2757		[AR]_AC,HOLD LEFT,J/MOVS
							; 2758	1414:
U 1414, 1500,3770,0303,4344,0003,7700,0200,0003,0001	; 2759	HRLS:	[AR]_[AR] SWAP,HOLD RIGHT,EXIT
							; 2760	
							; 2761	1415:
U 1415, 0512,3770,0303,4344,4007,0700,0000,0000,0000	; 2762	HLRM:	[AR]_[AR] SWAP
U 0512, 1402,3771,0003,0276,0007,0700,0000,0000,0000	; 2763		[AR]_AC,HOLD RIGHT,J/MOVS
							; 2764	1416:
U 1416, 1500,3770,0303,4340,4003,7700,0200,0003,0001	; 2765	HLRS:	[AR]_[AR] SWAP,HOLD LEFT,EXIT
							; 2766	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 76
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			HALFWORD GROUP						

							; 2767	;NOW THE HALFWORD OPS WHICH CONTROL THE "OTHER" HALF.
							; 2768	; ENTER WITH 0,,E (E) OR (AC) IN AR
							; 2769	
							; 2770	1417:
U 1417, 1420,3333,0003,4174,4007,0530,0000,0000,0000	; 2771	HRRE:	READ [AR],SKIP DP18
							; 2772	1420:
U 1420, 1500,5731,0003,4174,4003,7700,0200,0003,0001	; 2773	HRRZ:	[AR] LEFT_0, EXIT
							; 2774	1421:
U 1421, 1500,5431,1203,4174,4003,7700,0200,0003,0001	; 2775	HRRO:	[AR] LEFT_-1, EXIT
							; 2776	
							; 2777	1422:
U 1422, 1424,3333,0003,4174,4007,0530,0000,0000,0000	; 2778	HRLE:	READ [AR],SKIP DP18
							; 2779	1424:
U 1424, 1402,3771,0003,4374,0007,0700,0000,0000,0000	; 2780	HRLZ:	[AR]_#,#/0,HOLD RIGHT,J/MOVS
							; 2781	1425:
U 1425, 1402,3771,0003,4374,0007,0700,0000,0077,7777	; 2782	HRLO:	[AR]_#,#/777777,HOLD RIGHT,J/MOVS
							; 2783	
							; 2784	1423:
U 1423, 1426,3333,0003,4174,4007,0520,0000,0000,0000	; 2785	HLRE:	READ [AR],SKIP DP0
							; 2786	1426:
U 1426, 1402,3771,0003,4370,4007,0700,0000,0000,0000	; 2787	HLRZ:	[AR]_#,#/0,HOLD LEFT,J/MOVS
							; 2788	1427:
U 1427, 1402,3771,0003,4370,4007,0700,0000,0077,7777	; 2789	HLRO:	[AR]_#,#/777777,HOLD LEFT,J/MOVS
							; 2790	
							; 2791	1430:
U 1430, 1432,3333,0003,4174,4007,0520,0000,0000,0000	; 2792	HLLE:	READ [AR],SKIP DP0
							; 2793	1432:
U 1432, 1500,5371,0003,4174,4003,7700,0200,0003,0001	; 2794	HLLZ:	[AR] RIGHT_0, EXIT
							; 2795	1433:
U 1433, 1500,5341,1203,4174,4003,7700,0200,0003,0001	; 2796	HLLO:	[AR] RIGHT_-1, EXIT
							; 2797	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 77
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			DMOVE, DMOVN, DMOVEM, DMOVNM				

							; 2798	.TOC	"DMOVE, DMOVN, DMOVEM, DMOVNM"
							; 2799	
							; 2800		.DCODE
D 0120, 0205,1505,1100					; 2801	120:	DBL R,	DAC,	J/DAC
D 0121, 0215,1434,1100					; 2802		DBL R,	AC,	J/DMOVN
							; 2803		.UCODE
							; 2804	
							; 2805	1434:
U 1434, 3107,4551,0404,4374,0007,0700,0010,0037,7777	; 2806	DMOVN:	CLEAR ARX0, CALL [DBLNGA]
U 1436, 1515,3440,0404,1174,4007,0700,0400,0000,1441	; 2807	1436:	AC[1]_[ARX], J/STAC
							; 2808	
							; 2809		.DCODE
D 0124, 0300,1567,0100					; 2810	124:	DBL AC, 	J/DMOVN1
D 0125, 0100,1565,0500					; 2811		W,		J/DMOVNM
							; 2812		.UCODE
							; 2813	
							; 2814	
							; 2815	1565:
U 1565, 3106,3771,0004,1276,6007,0701,0010,0000,1441	; 2816	DMOVNM: [ARX]_AC[1],CALL [DBLNEG]
							; 2817	1567:
							; 2818	DMOVN1: [HR]+[ONE],		;GET E+1
							; 2819		LOAD VMA,		;PUT THAT IN VMA
							; 2820		START WRITE,		;STORE IN E+1
U 1567, 0531,0113,0207,4174,4007,0700,0200,0003,0312	; 2821		PXCT DATA		;DATA CYCLE
U 0531, 0532,3333,0004,4175,5007,0701,0200,0000,0002	; 2822		MEM WRITE, MEM_[ARX]	;STORE LOW WORD
							; 2823		VMA_[HR],		;GET E
							; 2824		LOAD VMA,		;SAVE IN VMA
							; 2825		PXCT DATA,		;OPERAND STORE
							; 2826		START WRITE,		;START MEM CYCLE
U 0532, 0435,3443,0200,4174,4007,0700,0200,0003,0312	; 2827		J/STORE 		;GO STORE AR
							; 2828	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 78
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BOOLEAN GROUP						

							; 2829	.TOC	"BOOLEAN GROUP"
							; 2830	
							; 2831		.DCODE
D 0400, 0015,1441,3000					; 2832	400:	I-PF,	AC,	J/SETZ
D 0401, 0015,1441,3000					; 2833		I-PF,	AC,	J/SETZ
D 0402, 0016,1441,2700					; 2834		IW,	M,	J/SETZ
D 0403, 0017,1441,2700					; 2835		IW,	B,	J/SETZ
							; 2836		.UCODE
							; 2837	
							; 2838	1441:
U 1441, 1500,4221,0003,4174,4003,7700,0200,0003,0001	; 2839	SETZ:	[AR]_0, EXIT
							; 2840	
							; 2841		.DCODE
D 0404, 1015,1442,1100					; 2842	404:	R-PF,	AC,	J/AND
D 0405, 0015,1442,3000					; 2843		I-PF,	AC,	J/AND
D 0406, 0016,1442,1700					; 2844		RW,	M,	J/AND
D 0407, 0017,1442,1700					; 2845		RW,	B,	J/AND
							; 2846		.UCODE
							; 2847	
							; 2848	1442:
U 1442, 1500,4551,0303,0274,4003,7700,0200,0003,0001	; 2849	AND:	[AR]_[AR].AND.AC,EXIT
							; 2850	
							; 2851		.DCODE
D 0410, 1015,1443,1100					; 2852	410:	R-PF,	AC,	J/ANDCA
D 0411, 0015,1443,3000					; 2853		I-PF,	AC,	J/ANDCA
D 0412, 0016,1443,1700					; 2854		RW,	M,	J/ANDCA
D 0413, 0017,1443,1700					; 2855		RW,	B,	J/ANDCA
							; 2856		.UCODE
							; 2857	
							; 2858	1443:
U 1443, 1500,5551,0303,0274,4003,7700,0200,0003,0001	; 2859	ANDCA:	[AR]_[AR].AND.NOT.AC,EXIT
							; 2860	
							; 2861		.DCODE
D 0414, 1015,1404,1100					; 2862	414:	R-PF,	AC,	J/MOVE	 ;SETM = MOVE
D 0415, 0015,1404,3000					; 2863		I-PF,	AC,	J/MOVE
D 0416, 0016,1404,1700					; 2864		RW,	M,	J/MOVE	 ;SETMM = NOP THAT WRITES MEMORY
D 0417, 0017,1404,1700					; 2865		RW,	B,	J/MOVE	 ;SETMB = MOVE THAT WRITES MEMORY
							; 2866	
D 0420, 1015,1444,1100					; 2867	420:	R-PF,	AC,	J/ANDCM
D 0421, 0015,1444,3000					; 2868		I-PF,	AC,	J/ANDCM
D 0422, 0016,1444,1700					; 2869		RW,	M,	J/ANDCM
D 0423, 0017,1444,1700					; 2870		RW,	B,	J/ANDCM
							; 2871		.UCODE
							; 2872	
							; 2873	1444:
U 1444, 1442,7441,0303,4174,4007,0700,0000,0000,0000	; 2874	ANDCM:	[AR]_.NOT.[AR],J/AND
							; 2875	
							; 2876		.DCODE
D 0424, 0000,1400,1100					; 2877	424:	R,		J/DONE
D 0425, 0000,1400,2100					; 2878		I,		J/DONE
D 0426, 0116,1404,0700					; 2879		W,	M,	J/MOVE		;SETAM = MOVEM
D 0427, 0116,1404,0700					; 2880		W,	M,	J/MOVE		;SETAB, TOO
							; 2881		.UCODE
							; 2882	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 79
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BOOLEAN GROUP						

							; 2883		.DCODE
D 0430, 1015,1445,1100					; 2884	430:	R-PF,	AC,	J/XOR
D 0431, 0015,1445,3000					; 2885		I-PF,	AC,	J/XOR
D 0432, 0016,1445,1700					; 2886		RW,	M,	J/XOR
D 0433, 0017,1445,1700					; 2887		RW,	B,	J/XOR
							; 2888		.UCODE
							; 2889	
							; 2890	1445:
U 1445, 1500,6551,0303,0274,4003,7700,0200,0003,0001	; 2891	XOR:	[AR]_[AR].XOR.AC,EXIT
							; 2892	
							; 2893		.DCODE
D 0434, 1015,1446,1100					; 2894	434:	R-PF,	AC,	J/IOR
D 0435, 0015,1446,3000					; 2895		I-PF,	AC,	J/IOR
D 0436, 0016,1446,1700					; 2896		RW,	M,	J/IOR
D 0437, 0017,1446,1700					; 2897		RW,	B,	J/IOR
							; 2898		.UCODE
							; 2899	
							; 2900	1446:
U 1446, 1500,3551,0303,0274,4003,7700,0200,0003,0001	; 2901	IOR:	[AR]_[AR].OR.AC,EXIT
							; 2902	
							; 2903		.DCODE
D 0440, 1015,1447,1100					; 2904	440:	R-PF,	AC,	J/ANDCB
D 0441, 0015,1447,3000					; 2905		I-PF,	AC,	J/ANDCB
D 0442, 0016,1447,1700					; 2906		RW,	M,	J/ANDCB
D 0443, 0017,1447,1700					; 2907		RW,	B,	J/ANDCB
							; 2908		.UCODE
							; 2909	
							; 2910	1447:
U 1447, 1443,7441,0303,4174,4007,0700,0000,0000,0000	; 2911	ANDCB:	[AR]_.NOT.[AR],J/ANDCA
							; 2912	
							; 2913		.DCODE
D 0444, 1015,1450,1100					; 2914	444:	R-PF,	AC,	J/EQV
D 0445, 0015,1450,3000					; 2915		I-PF,	AC,	J/EQV
D 0446, 0016,1450,1700					; 2916		RW,	M,	J/EQV
D 0447, 0017,1450,1700					; 2917		RW,	B,	J/EQV
							; 2918		.UCODE
							; 2919	
							; 2920	1450:
U 1450, 1500,7551,0303,0274,4003,7700,0200,0003,0001	; 2921	EQV:	[AR]_[AR].EQV.AC,EXIT
							; 2922	
							; 2923		.DCODE
D 0450, 0015,1451,3000					; 2924	450:	I-PF,	AC,	J/SETCA
D 0451, 0015,1451,3000					; 2925		I-PF,	AC,	J/SETCA
D 0452, 0016,1451,2700					; 2926		IW,	M,	J/SETCA
D 0453, 0017,1451,2700					; 2927		IW,	B,	J/SETCA
							; 2928		.UCODE
							; 2929	
							; 2930	1451:
U 1451, 1500,7771,0003,0274,4003,7700,0200,0003,0001	; 2931	SETCA:	[AR]_.NOT.AC,EXIT
							; 2932	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 80
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BOOLEAN GROUP						

							; 2933		.DCODE
D 0454, 1015,1452,1100					; 2934	454:	R-PF,	AC,	J/ORCA
D 0455, 0015,1452,3000					; 2935		I-PF,	AC,	J/ORCA
D 0456, 0016,1452,1700					; 2936		RW,	M,	J/ORCA
D 0457, 0017,1452,1700					; 2937		RW,	B,	J/ORCA
							; 2938		.UCODE
							; 2939	
							; 2940	1452:
U 1452, 0564,7771,0005,0274,4007,0700,0000,0000,0000	; 2941	ORCA:	[BR]_.NOT.AC
U 0564, 1500,3111,0503,4174,4003,7700,0200,0003,0001	; 2942		[AR]_[AR].OR.[BR],EXIT
							; 2943	
							; 2944		.DCODE
D 0460, 1015,1453,1100					; 2945	460:	R-PF,	AC,	J/SETCM
D 0461, 0015,1453,3000					; 2946		I-PF,	AC,	J/SETCM
D 0462, 0016,1453,1700					; 2947		RW,	M,	J/SETCM
D 0463, 0017,1453,1700					; 2948		RW,	B,	J/SETCM
							; 2949		.UCODE
							; 2950	
							; 2951	1453:
U 1453, 1500,7441,0303,4174,4003,7700,0200,0003,0001	; 2952	SETCM:	[AR]_.NOT.[AR],EXIT
							; 2953	
							; 2954		.DCODE
D 0464, 1015,1454,1100					; 2955	464:	R-PF,	AC,	J/ORCM
D 0465, 0015,1454,3000					; 2956		I-PF,	AC,	J/ORCM
D 0466, 0016,1454,1700					; 2957		RW,	M,	J/ORCM
D 0467, 0017,1454,1700					; 2958		RW,	B,	J/ORCM
							; 2959		.UCODE
							; 2960	
							; 2961	1454:
U 1454, 1446,7441,0303,4174,4007,0700,0000,0000,0000	; 2962	ORCM:	[AR]_.NOT.[AR],J/IOR
							; 2963	
							; 2964		.DCODE
D 0470, 1015,1455,1100					; 2965	470:	R-PF,	AC,	J/ORCB
D 0471, 0015,1455,3000					; 2966		I-PF,	AC,	J/ORCB
D 0472, 0016,1455,1700					; 2967		RW,	M,	J/ORCB
D 0473, 0017,1455,1700					; 2968		RW,	B,	J/ORCB
							; 2969		.UCODE
							; 2970	
							; 2971	1455:
U 1455, 1453,4551,0303,0274,4007,0700,0000,0000,0000	; 2972	ORCB:	[AR]_[AR].AND.AC,J/SETCM
							; 2973	
							; 2974		.DCODE
D 0474, 0015,1456,3000					; 2975	474:	I-PF,	AC,	J/SETO
D 0475, 0015,1456,3000					; 2976		I-PF,	AC,	J/SETO
D 0476, 0016,1456,2700					; 2977		IW,	M,	J/SETO
D 0477, 0017,1456,2700					; 2978		IW,	B,	J/SETO
							; 2979		.UCODE
							; 2980	
							; 2981	1456:
U 1456, 1500,2441,0703,4174,4003,7700,4200,0003,0001	; 2982	SETO:	[AR]_-[ONE], EXIT
							; 2983	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 81
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 2984	.TOC	"ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO"
							; 2985	
							; 2986		.DCODE
D 0240, 0400,1622,1000					; 2987	240:	SH,		J/ASH
D 0241, 0400,1632,1000					; 2988		SH,		J/ROT
D 0242, 0400,1612,1000					; 2989		SH,		J/LSH
D 0243, 0000,1462,2100					; 2990		I,		J/JFFO
D 0244, 0000,1466,3000					; 2991		I-PF,		J/ASHC
D 0245, 0500,1470,1000					; 2992	245:	SHC,		J/ROTC
D 0246, 0500,1464,1000					; 2993		SHC,		J/LSHC
							; 2994		.UCODE
							; 2995	
							; 2996	
							; 2997	;HERE IS THE CODE FOR LOGICAL SHIFT. THE EFFECTIVE ADDRESS IS
							; 2998	; IN AR.
							; 2999	1612:
							; 3000	LSH:	[AR]_AC,		;PICK UP AC
							; 3001		FE_-FE-1,		;NEGATIVE SHIFT
U 1612, 0572,3771,0003,0276,6007,0700,1000,0031,1777	; 3002		J/LSHL			;SHIFT LEFT
							; 3003	1613:	[AR]_AC.AND.MASK,	;MAKE IT LOOK POSITIVE
							; 3004		FE_FE+1, 		;UNDO -1 AT SHIFT
U 1613, 0604,4551,1203,0276,6007,0700,1000,0041,0001	; 3005		J/ASHR			;GO SHIFT RIGHT
							; 3006	
							; 3007	LSHL:	[AR]_[AR]*2,		;SHIFT LEFT
U 0572, 1515,3445,0303,4174,4007,0700,1020,0041,0001	; 3008		SHIFT, J/STAC		;FAST SHIFT & GO STORE AC
							; 3009	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 82
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 3010	;HERE IS THE CODE FOR ARITHMETIC SHIFT. THE EFFECTIVE ADDRESS IS
							; 3011	; IN AR.
							; 3012	
							; 3013	ASH36 LEFT	"[AR]_[AR]*2 LONG, ASHC, STEP SC, ASH AROV"
							; 3014	
							; 3015	1622:
U 1622, 0612,4222,0000,4174,4007,0700,0000,0000,0000	; 3016	ASH:	Q_0, J/ASHL0		;HARDWARE ONLY DOES ASHC
							; 3017	1623:	[AR]_AC,		;GET THE ARGUMENT
U 1623, 0604,3771,0003,0276,6007,0700,1000,0041,0001	; 3018		FE_FE+1 		;FE HAS NEGATIVE SHIFT COUNT
							; 3019	ASHR:	[AR]_[AR]*.5,		;SHIFT RIGHT
							; 3020		ASH, SHIFT,		;FAST SHIFT
U 0604, 1515,3447,0303,4174,4007,0700,1020,0041,0001	; 3021		J/STAC			;STORE AC WHEN DONE
							; 3022	
							; 3023	ASHL0:	[AR]_AC*.5,		;GET INTO 9 CHIPS
U 0612, 0454,3777,0003,0274,4007,0631,2000,0060,0000	; 3024		STEP SC 		;SEE IF NULL SHIFT
							; 3025	=0
U 0454, 0454,3444,0303,4174,4447,0630,2000,0060,0000	; 3026	ASHL:	ASH36 LEFT, J/ASHL	;SHIFT LEFT
							; 3027					;SLOW BECAUSE WE HAVE TO
							; 3028					; TEST FOR OVERFLOW
							; 3029	
U 0455, 1515,3445,0303,4174,4007,0700,0000,0000,0000	; 3030	ASHX:	[AR]_[AR]*2, J/STAC	;SHIFT BACK INTO 10 CHIPS
							; 3031	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 83
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 3032	;HERE IS THE CODE FOR ROTATE. THE EFFECTIVE ADDRESS IS
							; 3033	; IN AR.
							; 3034	1632:
							; 3035	ROT:	[AR]_AC*.5,		;PICK UP THE AC (& SHIFT)
							; 3036		FE_-FE-1,		;NEGATIVE SHIFT COUNT
U 1632, 0701,3777,0003,0274,4007,0701,1000,0031,1777	; 3037		J/ROTL			;ROTATE LEFT
							; 3038	1633:	[AR]_AC*.5,		;PICK UP THE AC (& SHIFT)
U 1633, 0632,3777,0003,0274,4007,0701,1000,0041,0001	; 3039		FE_FE+1 		;NEGATIVE SHIFT COUNT
U 0632, 0646,3447,0303,4174,4007,0700,0000,0000,0000	; 3040		[AR]_[AR]*.5		;PUT IN 9 DIPS
							; 3041		[AR]_[AR]*.5,		;SHIFT RIGHT
U 0646, 0651,3447,0303,4174,4037,0700,1020,0041,0001	; 3042		ROT, SHIFT		;FAST SHIFT
U 0651, 0455,3445,0303,4174,4007,0700,0000,0000,0000	; 3043	ASHXX:	[AR]_[AR]*2,J/ASHX	;SHIFT TO STD PLACE
							; 3044	
U 0701, 0706,3447,0303,4174,4007,0700,0000,0000,0000	; 3045	ROTL:	[AR]_[AR]*.5		;PUT IN RIGHT 36-BITS
							; 3046		[AR]_[AR]*2,		;ROTATE LEFT
							; 3047		ROT, SHIFT,		;FAST SHIFT
U 0706, 0651,3445,0303,4174,4037,0700,1020,0041,0001	; 3048		J/ASHXX 		;ALL DONE--SHIFT BACK
							; 3049	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 84
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROT, LSH, JFFO		

							; 3050	1462:
							; 3051	JFFO:	[BR]_AC.AND.MASK, 4T,	;GET AC WITH NO SIGN
U 1462, 0502,4551,1205,0276,6007,0622,0000,0000,0000	; 3052		SKIP AD.EQ.0		; EXTENSION. SKIP IF
							; 3053					; ZERO.
							; 3054	=0	[PC]_[AR],		;NOT ZERO--JUMP
							; 3055		LOAD VMA, FETCH,	;GET NEXT INST
U 0502, 0747,3441,0301,4174,4007,0700,0200,0014,0012	; 3056		J/JFFO1 		;ENTER LOOP
U 0503, 1400,4223,0000,1174,4007,0700,0400,0000,1441	; 3057		AC[1]_0, J/DONE 	;ZERO--DONE
							; 3058	
U 0747, 0514,4443,0000,4174,4007,0700,1000,0071,1764	; 3059	JFFO1:	FE_-12. 		;WHY -12.? WELL THE
							; 3060					; HARDWARE LOOKS AT
							; 3061					; BIT -2 SO THE FIRST
							; 3062					; 2 STEPS MOVE THE BR
							; 3063					; OVER. WE ALSO LOOK AT
							; 3064					; THE DATA BEFORE THE SHIFT
							; 3065					; SO WE END UP GOING 1 PLACE
							; 3066					; TOO MANY. THAT MEANS THE
							; 3067					; FE SHOULD START AT -3.
							; 3068					; HOWEVER, WE COUNT THE FE BY
							; 3069					; 4  (BECAUSE THE 2 LOW ORDER
							; 3070					; BITS DO NOT COME BACK) SO
							; 3071					; FE_-12.
							; 3072	=0
							; 3073	JFFOL:	[BR]_[BR]*2,		;SHIFT LEFT
							; 3074		FE_FE+4,		;COUNT UP BIT NUMBER
U 0514, 0514,3445,0505,4174,4007,0520,1000,0041,0004	; 3075		SKIP DP0, J/JFFOL	;LOOP TILL WE FIND THE BIT
U 0515, 0752,3777,0003,4334,4057,0700,0000,0041,0000	; 3076		[AR]_FE 		;GET ANSWER BACK
U 0752, 0767,4251,0303,4374,4007,0700,0000,0000,0077	; 3077		[AR]_[AR].AND.# CLR LH,#/77 ;MASK TO 1 COPY
U 0767, 0100,3440,0303,1174,4156,4700,0400,0000,1441	; 3078		AC[1]_[AR], NEXT INST	;STORE AND EXIT
							; 3079	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 85
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- LSHC			

							; 3080	.TOC	"ROTATES AND LOGICAL SHIFTS -- LSHC"
							; 3081	
							; 3082	;SHIFT CONNECTIONS WHEN THE SPECIAL FUNCTION "LSHC" IS DONE:
							; 3083	;
							; 3084	;   !-!   !----!------------------------------------!
							; 3085	;   !0!-->!0000!	 HIGH ORDER 36 BITS	    !  RAM FILE
							; 3086	;   !-!   !----!------------------------------------!
							; 3087	;						   ^
							; 3088	;						   :
							; 3089	;		....................................
							; 3090	;		:
							; 3091	;	  !----!------------------------------------!
							; 3092	;	  !0000!	  LOW ORDER 36 BITS	    !  Q-REGISTER
							; 3093	;	  !----!------------------------------------!
							; 3094	;						   ^
							; 3095	;						   :
							; 3096	;						  !-!
							; 3097	;						  !0!
							; 3098	;						  !-!
							; 3099	;
							; 3100	
							; 3101	1464:
U 1464, 0544,4443,0000,4174,4007,0630,2000,0060,0000	; 3102	LSHC:	STEP SC, J/LSHCL
U 1465, 1006,3333,0003,4174,4007,0700,2000,0031,5777	; 3103	1465:	READ [AR], SC_-SHIFT-1
U 1006, 0534,4443,0000,4174,4007,0630,2000,0060,0000	; 3104		STEP SC
							; 3105	=0
U 0534, 0534,3446,0505,4174,4057,0630,2000,0060,0000	; 3106	LSHCR:	[BR]_[BR]*.5 LONG,STEP SC,LSHC,J/LSHCR
U 0535, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3107		[BR]_[BR]*2 LONG,J/LSHCX
							; 3108	
							; 3109	=0
U 0544, 0544,3444,0505,4174,4057,0630,2000,0060,0000	; 3110	LSHCL:	[BR]_[BR]*2 LONG,LSHC,STEP SC,J/LSHCL
U 0545, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3111		[BR]_[BR]*2 LONG
U 1014, 1026,3444,0505,4174,4007,0700,0000,0000,0000	; 3112	LSHCX:	[BR]_[BR]*2 LONG
U 1026, 1064,3440,0505,0174,4007,0700,0400,0000,0000	; 3113		AC_[BR], J/ASHCQ1
							; 3114	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 86
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ASHC			

							; 3115	.TOC	"ROTATES AND LOGICAL SHIFTS -- ASHC"
							; 3116	
							; 3117	
							; 3118	1466:
							; 3119	ASHC:	READ [AR],		;PUT AR ON DP
							; 3120		SC_SHIFT, LOAD FE,	;PUT SHIFT IN BOTH SC AND FE
U 1466, 0554,3333,0003,4174,4007,0330,3000,0041,4000	; 3121		SKIP ADR.EQ.0		;SEE IF NULL SHIFT
							; 3122	=0	Q_AC[1],		;NOT NULL--GET LOW WORD
U 0554, 1046,3772,0000,1275,5007,0701,0000,0000,1441	; 3123		J/ASHC1 		;CONTINUE BELOW
U 0555, 0100,4443,0000,4174,4156,4700,0000,0000,0000	; 3124	NIDISP: NEXT INST		;NULL--ALL DONE
							; 3125	ASHC1:	[BR]_AC*.5 LONG,	;GET HIGH WORD
							; 3126					;AND SHIFT Q
U 1046, 0602,3776,0005,0274,4007,0631,0000,0000,0000	; 3127		SKIP/SC 		;SEE WHICH DIRECTION
							; 3128	=0	[BR]_[BR]*.5,		;ADJUST POSITION
							; 3129		SC_FE+S#, S#/1776,	;SUBRTACT 2 FROM FE
U 0602, 0624,3447,0505,4174,4007,0700,2000,0041,1776	; 3130		J/ASHCL 		;GO LEFT
							; 3131		[BR]_[BR]*.5,		;ADJUST POSITION
U 0603, 0614,3447,0505,4174,4007,0700,2000,0031,1776	; 3132		SC_S#-FE, S#/1776	;SC_-2-FE, SC_+# OF STEPS
							; 3133	=0				;HERE TO GO RIGHT
							; 3134	ASHCR:	[BR]_[BR]*.5 LONG,	;GO RIGHT
							; 3135		ASHC,			;SET DATA PATHS FOR ASHC (SEE DPE1)
U 0614, 0614,3446,0505,4174,4047,0630,2000,0060,0000	; 3136		STEP SC, J/ASHCR	;COUNT THE STEP AND KEEP LOOPING
							; 3137		[BR]_[BR]*2 LONG,	;PUT BACK WHERE IT GOES
U 0615, 1053,3444,0505,4174,4047,0700,0000,0000,0000	; 3138		ASHC, J/ASHCX		;COMPLETE INSTRUCTION
							; 3139	
							; 3140	=0
							; 3141	ASHCL:	[BR]_[BR]*2 LONG,	;GO LEFT
							; 3142		ASHC, ASH AROV, 	;SEE IF OVERFLOW
U 0624, 0624,3444,0505,4174,4447,0630,2000,0060,0000	; 3143		STEP SC, J/ASHCL	;LOOP OVER ALL PLACES
							; 3144		[BR]_[BR]*2 LONG,	;SHIFT BACK WHERE IT GOES
U 0625, 1053,3444,0505,4174,4447,0700,0000,0000,0000	; 3145		ASHC, ASH AROV		;CAN STILL OVERFLOW
							; 3146	ASHCX:	AC_[BR]+[BR], 3T,	;PUT BACK HIGH WORD
U 1053, 0634,0113,0505,0174,4007,0521,0400,0000,0000	; 3147		SKIP DP0		;SEE HOW TO FIX LOW SIGN
							; 3148	=0	Q_Q.AND.#, #/377777,	;POSITIVE, CLEAR LOW SIGN
U 0634, 1064,4662,0000,4374,0007,0700,0000,0037,7777	; 3149		HOLD RIGHT, J/ASHCQ1	;GO STORE ANSWER
							; 3150		Q_Q.OR.#, #/400000,	;NEGATIVE, SET LOW SIGN
U 0635, 1064,3662,0000,4374,0007,0700,0000,0040,0000	; 3151		HOLD RIGHT		;IN LEFT HALF
U 1064, 0100,3223,0000,1174,4156,4700,0400,0000,1441	; 3152	ASHCQ1: AC[1]_Q, NEXT INST	;PUT BACK Q AND EXIT
							; 3153	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 87
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ROTATES AND LOGICAL SHIFTS -- ROTC			

							; 3154	.TOC	"ROTATES AND LOGICAL SHIFTS -- ROTC"
							; 3155	
							; 3156	;SHIFT CONNECTIONS WHEN THE SPECIAL FUNCTION "ROTC" IS DONE:
							; 3157	;
							; 3158	;	  !----!------------------------------------!
							; 3159	;   .....>!0000!	 HIGH ORDER 36 BITS	    !  RAM FILE
							; 3160	;   :	  !----!------------------------------------!
							; 3161	;   :						   ^
							; 3162	;   :						   :
							; 3163	;   :	............................................
							; 3164	;   :	:
							; 3165	;   :	: !----!------------------------------------!
							; 3166	;   :	..!0000!	  LOW ORDER 36 BITS	    !  Q-REGISTER
							; 3167	;   :	  !----!------------------------------------!
							; 3168	;   :						   ^
							; 3169	;   :						   :
							; 3170	;   :..............................................:
							; 3171	;
							; 3172	
							; 3173	1470:
U 1470, 0644,4443,0000,4174,4007,0630,2000,0060,0000	; 3174	ROTC:	STEP SC, J/ROTCL
U 1471, 1077,3333,0003,4174,4007,0700,2000,0031,5777	; 3175	1471:	READ [AR], SC_-SHIFT-1
U 1077, 0642,4443,0000,4174,4007,0630,2000,0060,0000	; 3176		STEP SC
							; 3177	=0
U 0642, 0642,3446,0505,4174,4077,0630,2000,0060,0000	; 3178	ROTCR:	[BR]_[BR]*.5 LONG,STEP SC,ROTC,J/ROTCR
U 0643, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3179		[BR]_[BR]*2 LONG,J/LSHCX
							; 3180	
							; 3181	=0
U 0644, 0644,3444,0505,4174,4077,0630,2000,0060,0000	; 3182	ROTCL:	[BR]_[BR]*2 LONG,ROTC,STEP SC,J/ROTCL
							; 3183		[BR]_[BR]*2 LONG,
U 0645, 1014,3444,0505,4174,4007,0700,0000,0000,0000	; 3184		J/LSHCX
							; 3185	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 88
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

							; 3186	.TOC	"TEST GROUP"
							; 3187	
							; 3188		.DCODE
							; 3189	
							; 3190	;SPECIAL MACROS USED ONLY IN B-FIELD OF TEST INSTRUCTIONS
							; 3191	TN-		"B/4"
							; 3192	TNE		"B/0"
							; 3193	WORD-TNE	"B/10"	;USED IN TIOE
							; 3194	TNA		"B/0"
							; 3195	TNN		"B/4"
							; 3196	WORD-TNN	"B/14"	;USED IN TION
							; 3197	TZ-		"B/5"
							; 3198	TZE		"B/1"
							; 3199	TZA		"B/1"
							; 3200	TZN		"B/5"
							; 3201	TC-		"B/6"
							; 3202	TCE		"B/2"
							; 3203	TCA		"B/2"
							; 3204	TCN		"B/6"
							; 3205	TO-		"B/7"
							; 3206	TOE		"B/3"
							; 3207	TOA		"B/3"
							; 3208	TON		"B/7"
							; 3209	
D 0600, 0000,1400,2100					; 3210	600:	I,		J/DONE		;TRN- IS NOP
D 0601, 0000,1400,2100					; 3211		I,		J/DONE		;SO IS TLN-
D 0602, 0000,1475,2100					; 3212		I,	TNE,	J/TDXX
D 0603, 0000,1474,2100					; 3213		I,	TNE,	J/TSXX
D 0604, 0000,1473,2100					; 3214		I,	TNA,	J/TDX
D 0605, 0000,1472,2100					; 3215		I,	TNA,	J/TSX
D 0606, 0004,1475,2100					; 3216		I,	TNN,	J/TDXX
D 0607, 0004,1474,2100					; 3217		I,	TNN,	J/TSXX
							; 3218	
D 0610, 0000,1400,2100					; 3219	610:	I,		J/DONE		;TDN- IS A NOP
D 0611, 0000,1400,2100					; 3220		I,		J/DONE		;TSN- ALSO
D 0612, 0000,1475,1100					; 3221		R,	TNE,	J/TDXX
D 0613, 0000,1474,1100					; 3222		R,	TNE,	J/TSXX
D 0614, 0000,1473,1100					; 3223		R,	TNA,	J/TDX
D 0615, 0000,1472,1100					; 3224		R,	TNA,	J/TSX
D 0616, 0004,1475,1100					; 3225		R,	TNN,	J/TDXX
D 0617, 0004,1474,1100					; 3226		R,	TNN,	J/TSXX
							; 3227	
D 0620, 0005,1473,2100					; 3228	620:	I,	TZ-,	J/TDX
D 0621, 0005,1472,2100					; 3229		I,	TZ-,	J/TSX
D 0622, 0001,1475,2100					; 3230		I,	TZE,	J/TDXX
D 0623, 0001,1474,2100					; 3231		I,	TZE,	J/TSXX
D 0624, 0001,1473,2100					; 3232		I,	TZA,	J/TDX
D 0625, 0001,1472,2100					; 3233		I,	TZA,	J/TSX
D 0626, 0005,1475,2100					; 3234		I,	TZN,	J/TDXX
D 0627, 0005,1474,2100					; 3235		I,	TZN,	J/TSXX
							; 3236	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 89
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

D 0630, 0005,1473,1100					; 3237	630:	R,	TZ-,	J/TDX
D 0631, 0005,1472,1100					; 3238		R,	TZ-,	J/TSX
D 0632, 0001,1475,1100					; 3239		R,	TZE,	J/TDXX
D 0633, 0001,1474,1100					; 3240		R,	TZE,	J/TSXX
D 0634, 0001,1473,1100					; 3241		R,	TZA,	J/TDX
D 0635, 0001,1472,1100					; 3242		R,	TZA,	J/TSX
D 0636, 0005,1475,1100					; 3243		R,	TZN,	J/TDXX
D 0637, 0005,1474,1100					; 3244		R,	TZN,	J/TSXX
							; 3245	
D 0640, 0006,1473,2100					; 3246	640:	I,	TC-,	J/TDX
D 0641, 0006,1472,2100					; 3247		I,	TC-,	J/TSX
D 0642, 0002,1475,2100					; 3248		I,	TCE,	J/TDXX
D 0643, 0002,1474,2100					; 3249		I,	TCE,	J/TSXX
D 0644, 0002,1473,2100					; 3250		I,	TCA,	J/TDX
D 0645, 0002,1472,2100					; 3251		I,	TCA,	J/TSX
D 0646, 0006,1475,2100					; 3252		I,	TCN,	J/TDXX
D 0647, 0006,1474,2100					; 3253		I,	TCN,	J/TSXX
							; 3254	
D 0650, 0006,1473,1100					; 3255	650:	R,	TC-,	J/TDX
D 0651, 0006,1472,1100					; 3256		R,	TC-,	J/TSX
D 0652, 0002,1475,1100					; 3257		R,	TCE,	J/TDXX
D 0653, 0002,1474,1100					; 3258		R,	TCE,	J/TSXX
D 0654, 0002,1473,1100					; 3259		R,	TCA,	J/TDX
D 0655, 0002,1472,1100					; 3260		R,	TCA,	J/TSX
D 0656, 0006,1475,1100					; 3261		R,	TCN,	J/TDXX
D 0657, 0006,1474,1100					; 3262		R,	TCN,	J/TSXX
D 0660, 0007,1473,2100					; 3263	660:	I,	TO-,	J/TDX
D 0661, 0007,1472,2100					; 3264		I,	TO-,	J/TSX
D 0662, 0003,1475,2100					; 3265		I,	TOE,	J/TDXX
D 0663, 0003,1474,2100					; 3266		I,	TOE,	J/TSXX
D 0664, 0003,1473,2100					; 3267		I,	TOA,	J/TDX
D 0665, 0003,1472,2100					; 3268		I,	TOA,	J/TSX
D 0666, 0007,1475,2100					; 3269		I,	TON,	J/TDXX
D 0667, 0007,1474,2100					; 3270		I,	TON,	J/TSXX
							; 3271	
D 0670, 0007,1473,1100					; 3272	670:	R,	TO-,	J/TDX
D 0671, 0007,1472,1100					; 3273		R,	TO-,	J/TSX
D 0672, 0003,1475,1100					; 3274		R,	TOE,	J/TDXX
D 0673, 0003,1474,1100					; 3275		R,	TOE,	J/TSXX
D 0674, 0003,1473,1100					; 3276		R,	TOA,	J/TDX
D 0675, 0003,1472,1100					; 3277		R,	TOA,	J/TSX
D 0676, 0007,1475,1100					; 3278		R,	TON,	J/TDXX
D 0677, 0007,1474,1100					; 3279		R,	TON,	J/TSXX
							; 3280	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 90
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

							; 3281		.UCODE
							; 3282	
							; 3283	;THESE 64 INSTRUCTIONS ARE DECODED BY MASK MODE(IMMEDIATE OR MEMORY)
							; 3284	; IN THE A FIELD, DISPATCH TO HERE ON THE J FIELD, AND RE-DISPATCH
							; 3285	; FOR THE MODIFICATION ON THE B FIELD.
							; 3286	
							; 3287	; ENTER WITH 0,E OR (E) IN AR, B FIELD BITS 2 AND 3 AS FOLLOWS:
							; 3288	; 0 0	NO MODIFICATION
							; 3289	; 0 1	0S
							; 3290	; 1 0	COMPLEMENT
							; 3291	; 1 1	ONES
							; 3292	;   THIS ORDER HAS NO SIGNIFICANCE EXCEPT THAT IT CORRESPONDS TO THE
							; 3293	;   ORDER OF INSTRUCTIONS AT TGROUP.
							; 3294	
							; 3295	;THE BIT 1 OF THE B FIELD IS USED TO DETERMINE THE SENSE
							; 3296	; OF THE SKIP
							; 3297	; 1	SKIP IF AC.AND.MASK .NE. 0 (TXX- AND TXXN)
							; 3298	; 0	SKIP IF AC.AND.MASK .EQ. 0 (TXXA AND TXXE)
							; 3299	
							; 3300	;BIT 0 IS UNUSED AND MUST BE ZERO
							; 3301	
							; 3302	
							; 3303	1472:
U 1472, 1473,3770,0303,4344,4007,0700,0000,0000,0000	; 3304	TSX:	[AR]_[AR] SWAP		;TSXX AND TLXX
							; 3305	1473:
U 1473, 0014,4221,0005,4174,4003,7700,0000,0000,0000	; 3306	TDX:	[BR]_0,TEST DISP	; ALWAYS AND NEVER SKIP CASES
							; 3307	
							; 3308	1474:
U 1474, 1475,3770,0303,4344,4007,0700,0000,0000,0000	; 3309	TSXX:	[AR]_[AR] SWAP		;TSXE, TSXN, TLXE, TLXN
							; 3310	1475:
							; 3311	TDXX:	[BR]_[AR].AND.AC,	;TDXE, TDXN, TRXE, TRXN
U 1475, 0014,4551,0305,0274,4003,7700,0000,0000,0000	; 3312		TEST DISP
							; 3313	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 91
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			TEST GROUP						

							; 3314	;TEST DISP DOES AN 8 WAY BRANCH BASED ON THE B-FIELD OF DROM
							; 3315	
							; 3316	=1100
							; 3317	TEST-TABLE:
							; 3318	
							; 3319	;CASE 0 & 4	-- TXNX
U 0014, 1400,3333,0005,4174,4007,0571,0000,0000,0000	; 3320	TXXX:	READ [BR], TXXX TEST, 3T, J/DONE
							; 3321	
							; 3322	;CASE 1 & 5 -- TXZ AND TXZX
U 0015, 1117,7441,0303,4174,4007,0700,0000,0000,0000	; 3323		[AR]_.NOT.[AR],J/TXZX
							; 3324	
							; 3325	;CASE 2 & 6 -- TXC AND TXCX
U 0016, 1123,6551,0303,0274,4007,0700,0000,0000,0000	; 3326		[AR]_[AR].XOR.AC,J/TDONE
							; 3327	
							; 3328	;CASE 3 & 7 -- TXO AND TXOX
U 0017, 1123,3551,0303,0274,4007,0700,0000,0000,0000	; 3329		[AR]_[AR].OR.AC,J/TDONE
							; 3330	
							; 3331	;THE SPECIAL FUNCTION TXXX TEST CAUSES A MICROCODE SKIP IF
							; 3332	; AD.EQ.0 AND DROM B IS 0-3 OR AD.NE.0 AND DROM B IS 4-7.
							; 3333	
U 1117, 1123,4551,0303,0274,4007,0700,0000,0000,0000	; 3334	TXZX:	[AR]_[AR].AND.AC
U 1123, 0014,3440,0303,0174,4007,0700,0400,0000,0000	; 3335	TDONE:	AC_[AR],J/TXXX
							; 3336	;	READ BR,TXXX TEST,J/DONE
							; 3337	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 92
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			COMPARE -- CAI, CAM					

							; 3338	.TOC	"COMPARE -- CAI, CAM"
							; 3339	
							; 3340		.DCODE
							; 3341	
							; 3342	;SPECIAL B-FIELD ENCODING USED BY SKIP-JUMP-COMPARE CLASS
							; 3343	; INSTRUCTIONS:
							; 3344	
							; 3345	SJC-	"B/0"	;NEVER
							; 3346	SJCL	"B/1"	;LESS
							; 3347	SJCE	"B/2"	;EQUAL
							; 3348	SJCLE	"B/3"	;LESS EQUAL
							; 3349	SJCA	"B/4"	;ALWAYS
							; 3350	SJCGE	"B/5"	;GREATER THAN OR EQUAL
							; 3351	SJCN	"B/6"	;NOT EQUAL
							; 3352	SJCG	"B/7"	;GREATER
							; 3353	
							; 3354		.UCODE
							; 3355	
							; 3356	;COMPARE TABLE
							; 3357	=1000
							; 3358	SKIP-COMP-TABLE:
							; 3359	
							; 3360	;CASE 0 -- NEVER
U 0250, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 3361		DONE
							; 3362	
							; 3363	;CASE 1 -- LESS
U 0251, 1400,3333,0003,4174,4007,0520,0000,0000,0000	; 3364		READ [AR], SKIP DP0,J/DONE
							; 3365	
							; 3366	;CASE 2 -- EQUAL
U 0252, 1400,3333,0003,4174,4007,0621,0000,0000,0000	; 3367	SKIPE:	READ [AR], SKIP AD.EQ.0,J/DONE
							; 3368	
							; 3369	;CASE 3 -- LESS OR EQUAL
U 0253, 1400,3333,0003,4174,4007,0421,0000,0000,0000	; 3370		READ [AR], SKIP AD.LE.0,J/DONE
							; 3371	
							; 3372	;CASE 4 -- ALWAYS
U 0254, 0110,0111,0701,4170,4156,4700,0200,0014,0012	; 3373		VMA_[PC]+1, NEXT INST FETCH, FETCH
							; 3374	
							; 3375	;CASE 5 -- GREATER THAN OR EQUAL
U 0255, 0260,3333,0003,4174,4007,0520,0000,0000,0000	; 3376		READ [AR], SKIP DP0,J/SKIP
							; 3377	
							; 3378	;CASE 6 -- NOT EQUAL
U 0256, 0260,3333,0003,4174,4007,0621,0000,0000,0000	; 3379		READ [AR], SKIP AD.EQ.0,J/SKIP
							; 3380	
							; 3381	;CASE 7 -- GREATER
U 0257, 0260,3333,0003,4174,4007,0421,0000,0000,0000	; 3382		READ [AR], SKIP AD.LE.0,J/SKIP
							; 3383	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 93
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			COMPARE -- CAI, CAM					

							; 3384		.DCODE
D 0300, 0000,1400,2100					; 3385	300:	I,	SJC-,	J/DONE	;CAI
D 0301, 0001,1476,2100					; 3386		I,	SJCL,	J/CAIM
D 0302, 0002,1476,2100					; 3387		I,	SJCE,	J/CAIM
D 0303, 0003,1476,2100					; 3388		I,	SJCLE,	J/CAIM
D 0304, 0004,1476,2100					; 3389		I,	SJCA,	J/CAIM
D 0305, 0005,1476,2100					; 3390		I,	SJCGE,	J/CAIM
D 0306, 0006,1476,2100					; 3391		I,	SJCN,	J/CAIM
D 0307, 0007,1476,2100					; 3392		I,	SJCG,	J/CAIM
							; 3393	
D 0310, 0000,1476,1100					; 3394	310:	R,	SJC-,	J/CAIM	;CAM
D 0311, 0001,1476,1100					; 3395		R,	SJCL,	J/CAIM
D 0312, 0002,1476,1100					; 3396		R,	SJCE,	J/CAIM
D 0313, 0003,1476,1100					; 3397		R,	SJCLE,	J/CAIM
D 0314, 0004,1476,1100					; 3398		R,	SJCA,	J/CAIM
D 0315, 0005,1476,1100					; 3399		R,	SJCGE,	J/CAIM
D 0316, 0006,1476,1100					; 3400		R,	SJCN,	J/CAIM
D 0317, 0007,1476,1100					; 3401		R,	SJCG,	J/CAIM
							; 3402		.UCODE
							; 3403	
							; 3404	1476:
U 1476, 0250,2551,0303,0274,4003,7701,4000,0000,0000	; 3405	CAIM:	[AR]_AC-[AR], 3T, SKIP-COMP DISP
							; 3406	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 94
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC SKIPS -- AOS, SOS, SKIP			

							; 3407	.TOC	"ARITHMETIC SKIPS -- AOS, SOS, SKIP"
							; 3408	;ENTER WITH (E) IN AR
							; 3409	
							; 3410		.DCODE
D 0330, 0000,1477,1100					; 3411	330:	R,	SJC-,	J/SKIPS ;NOT A NOP IF AC .NE. 0
D 0331, 0001,1477,1100					; 3412		R,	SJCL,	J/SKIPS
D 0332, 0002,1477,1100					; 3413		R,	SJCE,	J/SKIPS
D 0333, 0003,1477,1100					; 3414		R,	SJCLE,	J/SKIPS
D 0334, 0004,1477,1100					; 3415		R,	SJCA,	J/SKIPS
D 0335, 0005,1477,1100					; 3416		R,	SJCGE,	J/SKIPS
D 0336, 0006,1477,1100					; 3417		R,	SJCN,	J/SKIPS
D 0337, 0007,1477,1100					; 3418		R,	SJCG,	J/SKIPS
							; 3419		.UCODE
							; 3420	
							; 3421	1477:
							; 3422	SKIPS:	FIX [AR] SIGN,
U 1477, 0742,3770,0303,4174,0007,0360,0000,0000,0000	; 3423		SKIP IF AC0
U 0742, 0250,3440,0303,0174,4003,7700,0400,0000,0000	; 3424	=0	AC_[AR],SKIP-COMP DISP
U 0743, 0250,4443,0000,4174,4003,7700,0000,0000,0000	; 3425		SKIP-COMP DISP
							; 3426	
							; 3427		.DCODE
D 0350, 0000,1431,1500					; 3428	350:	RW,	SJC-,	J/AOS
D 0351, 0001,1431,1500					; 3429		RW,	SJCL,	J/AOS
D 0352, 0002,1431,1500					; 3430		RW,	SJCE,	J/AOS
D 0353, 0003,1431,1500					; 3431		RW,	SJCLE,	J/AOS
D 0354, 0004,1431,1500					; 3432		RW,	SJCA,	J/AOS
D 0355, 0005,1431,1500					; 3433		RW,	SJCGE,	J/AOS
D 0356, 0006,1431,1500					; 3434		RW,	SJCN,	J/AOS
D 0357, 0007,1431,1500					; 3435		RW,	SJCG,	J/AOS
							; 3436		.UCODE
							; 3437	
							; 3438	1431:
U 1431, 1126,0111,0703,4174,4467,0701,0000,0001,0001	; 3439	AOS:	[AR]_[AR]+1, 3T, AD FLAGS
U 1126, 1133,4443,0000,4174,4007,0700,0200,0003,0002	; 3440	XOS:	START WRITE
U 1133, 1477,3333,0003,4175,5007,0701,0200,0000,0002	; 3441		MEM WRITE,MEM_[AR],J/SKIPS
							; 3442	
							; 3443		.DCODE
D 0370, 0000,1437,1500					; 3444	370:	RW,	SJC-,	J/SOS
D 0371, 0001,1437,1500					; 3445		RW,	SJCL,	J/SOS
D 0372, 0002,1437,1500					; 3446		RW,	SJCE,	J/SOS
D 0373, 0003,1437,1500					; 3447		RW,	SJCLE,	J/SOS
D 0374, 0004,1437,1500					; 3448		RW,	SJCA,	J/SOS
D 0375, 0005,1437,1500					; 3449		RW,	SJCGE,	J/SOS
D 0376, 0006,1437,1500					; 3450		RW,	SJCN,	J/SOS
D 0377, 0007,1437,1500					; 3451		RW,	SJCG,	J/SOS
							; 3452		.UCODE
							; 3453	
							; 3454	1437:
U 1437, 1126,1111,0703,4174,4467,0701,4000,0001,0001	; 3455	SOS:	[AR]_[AR]-1, 3T, AD FLAGS, J/XOS
							; 3456	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 95
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ		

							; 3457	.TOC	"CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ"
							; 3458	; ENTER WITH E IN AR
							; 3459	
							; 3460	=1000
							; 3461	JUMP-TABLE:
							; 3462	
							; 3463	;CASE 0 -- NEVER
U 0270, 0100,3440,0505,0174,4156,4700,0400,0000,0000	; 3464		AC_[BR], NEXT INST
							; 3465	
							; 3466	;CASE 1 -- LESS
U 0271, 0744,3770,0505,0174,4007,0520,0400,0000,0000	; 3467		AC_[BR] TEST, SKIP DP0, J/JUMP-
							; 3468	
							; 3469	;CASE 2 -- EQUAL
U 0272, 0744,3770,0505,0174,4007,0621,0400,0000,0000	; 3470		AC_[BR] TEST, SKIP AD.EQ.0, J/JUMP-
							; 3471	
							; 3472	;CASE 3 -- LESS THAN OR EQUAL
U 0273, 0744,3770,0505,0174,4007,0421,0400,0000,0000	; 3473		AC_[BR] TEST, SKIP AD.LE.0, J/JUMP-
							; 3474	
							; 3475	;CASE 4 -- ALWAYS
U 0274, 0762,3440,0505,0174,4007,0700,0400,0000,0000	; 3476	JMPA:	AC_[BR], J/JUMPA
							; 3477	
							; 3478	;CASE 5 -- GREATER THAN OR EQUAL TO
U 0275, 0762,3770,0505,0174,4007,0520,0400,0000,0000	; 3479		AC_[BR] TEST, SKIP DP0, J/JUMPA
							; 3480	
							; 3481	;CASE 6 -- NOT EQUAL
U 0276, 0762,3770,0505,0174,4007,0621,0400,0000,0000	; 3482		AC_[BR] TEST, SKIP AD.EQ.0, J/JUMPA
							; 3483	
							; 3484	;CASE 7 -- GREATER
U 0277, 0762,3770,0505,0174,4007,0421,0400,0000,0000	; 3485		AC_[BR] TEST, SKIP AD.LE.0, J/JUMPA
							; 3486	
							; 3487	=0
U 0744, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 3488	JUMP-:	DONE
U 0745, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3489		JUMPA
							; 3490	
							; 3491	=0
U 0762, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3492	JUMPA:	JUMPA
U 0763, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 3493		DONE
							; 3494	
							; 3495	
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 96
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			CONDITIONAL JUMPS -- JUMP, AOJ, SOJ, AOBJ		

							; 3496		.DCODE
D 0320, 0000,1400,2100					; 3497	320:	I,	SJC-,	J/DONE
D 0321, 0001,1440,2100					; 3498		I,	SJCL,	J/JUMP
D 0322, 0002,1440,2100					; 3499		I,	SJCE,	J/JUMP
D 0323, 0003,1440,2100					; 3500		I,	SJCLE,	J/JUMP
D 0324, 0004,1520,2100					; 3501		I,	SJCA,	J/JRST
D 0325, 0005,1440,2100					; 3502		I,	SJCGE,	J/JUMP
D 0326, 0006,1440,2100					; 3503		I,	SJCN,	J/JUMP
D 0327, 0007,1440,2100					; 3504		I,	SJCG,	J/JUMP
							; 3505		.UCODE
							; 3506	
							; 3507	1440:
U 1440, 0270,3771,0005,0276,6003,7700,0000,0000,0000	; 3508	JUMP:	[BR]_AC,JUMP DISP
							; 3509	
							; 3510		.DCODE
D 0340, 0000,1611,3000					; 3511	340:	I-PF,	SJC-,	J/AOJ
D 0341, 0001,1611,2100					; 3512		I,	SJCL,	J/AOJ
D 0342, 0002,1611,2100					; 3513		I,	SJCE,	J/AOJ
D 0343, 0003,1611,2100					; 3514		I,	SJCLE,	J/AOJ
D 0344, 0004,1611,2100					; 3515		I,	SJCA,	J/AOJ
D 0345, 0005,1611,2100					; 3516		I,	SJCGE,	J/AOJ
D 0346, 0006,1611,2100					; 3517		I,	SJCN,	J/AOJ
D 0347, 0007,1611,2100					; 3518		I,	SJCG,	J/AOJ
							; 3519		.UCODE
							; 3520	
							; 3521	1611:
U 1611, 0270,0551,0705,0274,4463,7702,0000,0001,0001	; 3522	AOJ:	[BR]_AC+1, AD FLAGS, 4T, JUMP DISP
							; 3523	
							; 3524		.DCODE
D 0360, 0000,1542,3000					; 3525	360:	I-PF,	SJC-,	J/SOJ
D 0361, 0001,1542,2100					; 3526		I,	SJCL,	J/SOJ
D 0362, 0002,1542,2100					; 3527		I,	SJCE,	J/SOJ
D 0363, 0003,1542,2100					; 3528		I,	SJCLE,	J/SOJ
D 0364, 0004,1542,2100					; 3529		I,	SJCA,	J/SOJ
D 0365, 0005,1542,2100					; 3530		I,	SJCGE,	J/SOJ
D 0366, 0006,1542,2100					; 3531		I,	SJCN,	J/SOJ
D 0367, 0007,1542,2100					; 3532		I,	SJCG,	J/SOJ
							; 3533		.UCODE
							; 3534	
							; 3535	1542:
U 1542, 0270,2551,0705,0274,4463,7702,4000,0001,0001	; 3536	SOJ:	[BR]_AC-1, AD FLAGS, 4T, JUMP DISP
							; 3537	
							; 3538		.DCODE
D 0252, 0005,1547,2100					; 3539	252:	I,	SJCGE,	J/AOBJ
D 0253, 0001,1547,2100					; 3540		I,	SJCL,	J/AOBJ
							; 3541		.UCODE
							; 3542	
							; 3543	1547:
							; 3544	AOBJ:	[BR]_AC+1000001,	;ADD 1 TO BOTH HALF WORDS
							; 3545		INH CRY18, 3T,		;NO CARRY INTO LEFT HALF
U 1547, 0270,0551,1505,0274,4403,7701,0000,0000,0000	; 3546		JUMP DISP		;HANDLE EITHER AOBJP OR AOBJN
							; 3547	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 97
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			AC DECODE JUMPS -- JRST, JFCL				

							; 3548	.TOC	"AC DECODE JUMPS -- JRST, JFCL"
							; 3549	
							; 3550		.DCODE
D 0254, 0000,1520,6000					; 3551	254:	I,VMA/0, AC DISP,	J/JRST	;DISPATCHES TO 1 OF 16
							; 3552						; PLACES ON AC BITS
D 0255, 0000,1540,2100					; 3553		I,			J/JFCL
							; 3554		.UCODE
							; 3555	
							; 3556	;JRST DISPATCHES TO ONE OF 16 LOC'NS ON AC BITS
							; 3557	
							; 3558	=0000
							; 3559	1520:
U 1520, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3560	JRST:	JUMPA			;(0) JRST 0,
U 1521, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3561	1521:	JUMPA			;(1) PORTAL IS SAME AS JRST
							; 3562	1522:	VMA_[PC]-1, START READ, ;(2) JRSTF
U 1522, 0150,1113,0701,4170,4007,0700,4200,0004,0012	; 3563		J/JRSTF
U 1523, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3564	1523:	UUO			;(3)
U 1524, 0764,4443,0000,4174,4007,0340,0000,0000,0000	; 3565	1524:	SKIP KERNEL, J/HALT	;(4) HALT
							; 3566	1525:
							; 3567	XJRSTF0: VMA_[AR], START READ, ;(5) XJRSTF
U 1525, 2603,3443,0300,4174,4007,0700,0200,0004,0012	; 3568		J/XJRSTF
U 1526, 0320,4443,0000,4174,4007,0340,0000,0000,0000	; 3569	1526:	SKIP KERNEL, J/XJEN	;(6) XJEN
U 1527, 1024,4443,0000,4174,4007,0340,0000,0000,0000	; 3570	1527:	SKIP KERNEL, J/XPCW	;(7) XPCW
							; 3571	1530:	VMA_[PC]-1, START READ, ;(10)
U 1530, 1004,1113,0701,4170,4007,0040,4200,0004,0012	; 3572		 SKIP IO LEGAL, J/JRST10
U 1531, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3573	1531:	UUO			;(11)
							; 3574	1532:	VMA_[PC]-1, START READ, ;(12) JEN
U 1532, 0300,1113,0701,4170,4007,0040,4200,0004,0012	; 3575		 SKIP IO LEGAL, J/JEN
U 1533, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3576	1533:	UUO			;(13)
U 1534, 1034,4443,0000,4174,4007,0340,0000,0000,0000	; 3577	1534:	SKIP KERNEL, J/SFM	;(14) SFM
U 1535, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3578	1535:	UUO			;(15)
U 1536, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3579	1536:	UUO			;(16)
U 1537, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3580	1537:	UUO			;(17)
							; 3581	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 98
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			AC DECODE JUMPS -- JRST, JFCL				

							; 3582	=0*
							; 3583	JRSTF:	MEM READ,		;WAIT FOR DATA
							; 3584		[HR]_MEM,		;STICK IN HR
							; 3585		LOAD INST EA,		;LOAD @ AND XR
U 0150, 1146,3771,0002,4365,5217,0700,0210,0000,0002	; 3586		CALL [JRST0]		;COMPUTE EA AGAIN
U 0152, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3587		JUMPA			;JUMP
							; 3588	
U 1146, 0030,4443,0000,2174,4006,6700,0000,0000,0000	; 3589	JRST0:	EA MODE DISP		;WHAT TYPE OF EA?
							; 3590	=100*
							; 3591		READ XR,		;INDEXED
							; 3592		LOAD FLAGS,		;GET FLAGS FROM XR
							; 3593		UPDATE USER,		;ALLOW USER TO SET
U 0030, 0002,3773,0000,2274,4464,1700,0000,0001,0004	; 3594		RETURN [2]		;ALL DONE
							; 3595		READ [HR],		;PLAIN
							; 3596		LOAD FLAGS,		;LOAD FLAGS FROM INST
							; 3597		UPDATE USER,		;ALLOW USER TO SET
U 0032, 0002,3333,0002,4174,4464,1700,0000,0001,0004	; 3598		RETURN [2]		;RETURN
							; 3599		[HR]_[HR]+XR,		;BOTH
							; 3600		LOAD VMA,		;FETCH IND WORD
							; 3601		START READ,		;START MEM CYCLE
U 0034, 1155,0551,0202,2270,4007,0700,0200,0004,0012	; 3602		J/JRST1 		;CONTINUE BELOW
							; 3603		VMA_[HR],		;INDIRECT
							; 3604		START READ,		;FETCH IND WORD
							; 3605		PXCT EA,		;SETUP PXCT STUFF
U 0036, 1155,3443,0200,4174,4007,0700,0200,0004,0112	; 3606		J/JRST1 		;CONTINUE BELOW
							; 3607	JRST1:	MEM READ,		;WAIT FOR DATA
							; 3608		[HR]_MEM,		;LOAD THE HR
							; 3609		LOAD INST EA,		;LOAD @ AND XR
U 1155, 1146,3771,0002,4365,5217,0700,0200,0000,0002	; 3610		J/JRST0 		;LOOP BACK
							; 3611	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 99
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			AC DECODE JUMPS -- JRST, JFCL				

							; 3612	=0
U 0764, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3613	HALT:	UUO			;USER MODE
U 0765, 1163,3441,0301,4174,4007,0700,0000,0000,0000	; 3614		[PC]_[AR]		;EXEC MODE--CHANGE PC
U 1163, 0104,4751,1217,4374,4007,0700,0000,0000,0001	; 3615		HALT [HALT]		;HALT INSTRUCTION
							; 3616	
							; 3617	=0
U 1004, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3618	JRST10: UUO
U 1005, 0303,4443,0000,4174,4007,0700,0000,0000,0000	; 3619		J/JEN2			;DISMISS INTERRUPT
							; 3620	=0000
U 0300, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3621	JEN:	UUO			; FLAGS
							; 3622		MEM READ,
							; 3623		[HR]_MEM,		;GET INST
							; 3624		LOAD INST EA,		;LOAD XR & @
U 0301, 1146,3771,0002,4365,5217,0700,0210,0000,0002	; 3625		CALL [JRST0]		;COMPUTE FLAGS
							; 3626	=0011
U 0303, 2456,4553,1400,4374,4007,0331,0010,0007,7400	; 3627	JEN2:	DISMISS 		;DISMISS INTERRUPT
U 0307, 3650,3770,1416,4344,4007,0700,0010,0000,0000	; 3628	=0111	CALL LOAD PI		;RELOAD PI HARDWARE
U 0317, 0110,3441,0301,4170,4156,4700,0200,0014,0012	; 3629	=1111	JUMPA			;GO JUMP
							; 3630	=
							; 3631	
							; 3632	1540:
							; 3633	JFCL:	JFCL FLAGS,		;ALL DONE IN HARDWARE
							; 3634		SKIP JFCL,		;SEE IF SKIPS
							; 3635		3T,			;ALLOW TIME
U 1540, 0744,4443,0000,4174,4467,0551,0000,0001,0010	; 3636		J/JUMP- 		;JUMP IF WE SHOULD
							; 3637	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 100
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			EXTENDED ADDRESSING INSTRUCTIONS			

							; 3638	.TOC	"EXTENDED ADDRESSING INSTRUCTIONS"
							; 3639	
							; 3640	=0000
U 0320, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3641	XJEN:	UUO			;HERE IF USER MODE
U 0321, 2456,4553,1400,4374,4007,0331,0010,0007,7400	; 3642		DISMISS 		;CLEAR HIGHEST INTERRUPT
U 0325, 0335,3333,0012,4174,4437,0700,0000,0000,0000	; 3643	=0101	READ [MASK], LOAD PI	;NO MORE INTERRUPTS
							; 3644	=1101	ABORT MEM CYCLE,	;AVOID INTERRUPT PAGE FAIL
U 0335, 1525,4223,0000,4364,4277,0700,0200,0000,0010	; 3645		J/XJRSTF0		;START READING FLAG WORD
							; 3646	=
							; 3647	
U 2603, 2604,3771,0005,4365,5007,0700,0200,0000,0002	; 3648	XJRSTF: MEM READ, [BR]_MEM	;PUT FLAGS IN BR
							; 3649		[AR]_[AR]+1,		;INCREMENT ADDRESS
							; 3650		LOAD VMA,		;PUT RESULT IN VMA
U 2604, 2625,0111,0703,4174,4007,0700,0200,0004,0012	; 3651		START READ		;START MEMORY
							; 3652		MEM READ, [PC]_MEM,	;PUT DATA IN PC
U 2625, 2627,3771,0001,4361,5007,0700,0200,0000,0002	; 3653		HOLD LEFT		;IGNORE SECTION NUMBER
							; 3654		READ [BR], LOAD FLAGS,	;LOAD NEW FLAGS
U 2627, 2721,3333,0005,4174,4467,0700,0000,0001,0004	; 3655		UPDATE USER		;BUT HOLD USER FLAG
							; 3656	PISET:	[FLG]_[FLG].AND.NOT.#,	;CLEAR PI CYCLE
U 2721, 0305,5551,1313,4374,4007,0700,0000,0001,0000	; 3657		 FLG.PI/1, J/PIEXIT	;RELOAD PI HARDWARE
							; 3658					; INCASE THIS IS AN
							; 3659					; INTERRUPT INSTRUCTION
							; 3660	
							; 3661	=0
U 1024, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3662	XPCW:	UUO			;USER MODE
U 1025, 0060,4521,1205,4074,4007,0700,0000,0000,0000	; 3663		[BR]_FLAGS		;PUT FLAGS IN BR
							; 3664	=0*0
							; 3665	PIXPCW: VMA_[AR], START WRITE,	;STORE FLAGS
U 0060, 3727,3443,0300,4174,4007,0700,0210,0003,0012	; 3666		CALL [STOBR]		;PUT BR IN MEMORY
							; 3667	=1*0	VMA_[AR]+1, LOAD VMA,
							; 3668		START WRITE,		;PREPEARE TO STORE PC
U 0064, 3730,0111,0703,4170,4007,0700,0210,0003,0012	; 3669		CALL [STOPC]		;PUT PC IN MEMORY
							; 3670	=1*1	[AR]_[AR]+1,		;DO NEW PC PART
U 0065, 2603,0111,0703,4174,4007,0700,0200,0004,0002	; 3671		START READ, J/XJRSTF
							; 3672	=
							; 3673	
							; 3674	=0
U 1034, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3675	SFM:	UUO
U 1035, 2734,3443,0300,4174,4007,0700,0200,0003,0012	; 3676		VMA_[AR], START WRITE	;STORE FLAGS
U 2734, 0435,4521,1203,4074,4007,0700,0000,0000,0000	; 3677		[AR]_FLAGS, J/STORE	;STORE AND EXIT
							; 3678	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 101
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			XCT							

							; 3679	.TOC	"XCT"
							; 3680	
							; 3681		.DCODE
D 0256, 0000,1541,1100					; 3682	256:	R,		J/XCT	;OPERAND FETCHED AS DATA
							; 3683		.UCODE
							; 3684	
							; 3685	1541:
U 1541, 1044,4443,0000,4174,4007,0340,0000,0000,0000	; 3686	XCT:	SKIP KERNEL		;SEE IF MAY BE PXCT
							; 3687	=0
							; 3688	XCT1A:	[HR]_[AR],		;STUFF INTO HR
							; 3689		DBUS/DP,		;PLACE ON DBUS FOR IR
							; 3690		LOAD INST,		;LOAD IR, AC, XR, ETC.
							; 3691		PXCT/E1,		;ALLOW XR TO BE PREVIOUS
U 1044, 2735,3441,0302,4174,4617,0700,0000,0000,0100	; 3692		J/XCT1			;CONTINUE BELOW
							; 3693	
							; 3694		READ [HR],		;LOAD PXCT FLAGS
							; 3695		LOAD PXCT,		; ..
U 1045, 1044,3333,0002,4174,4167,0700,0000,0000,0000	; 3696		J/XCT1A			;CONTINUE WITH NORMAL FLOW
							; 3697	
							; 3698	XCT1:	WORK[YSAVE]_[HR] CLR LH,;SAVE FOR IO INSTRUCTIONS
U 2735, 0371,4713,1202,7174,4007,0700,0400,0000,0422	; 3699		J/XCT2			;GO EXECUTE IT
							; 3700	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 102
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ		

							; 3701	.TOC	"STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ"
							; 3702	
							; 3703		.DCODE
D 0260, 0000,1544,2100					; 3704	260:	I,	B/0,	J/PUSHJ
D 0261, 0002,1543,3100					; 3705		IR,	B/2,	J/PUSH
D 0262, 0002,1545,2100					; 3706		I,	B/2,	J/POP
D 0263, 0000,1546,2100					; 3707		I,		J/POPJ
							; 3708		.UCODE
							; 3709	
							; 3710	;ALL START WITH E IN AR
							; 3711	1543:
							; 3712	PUSH:	MEM READ,		;PUT MEMOP IN BR
U 1543, 2736,3771,0005,4365,5007,0700,0200,0000,0002	; 3713		[BR]_MEM		; ..
							; 3714	PUSH1:	[ARX]_AC+1000001,	;BUMP BOTH HALVES OF AC
							; 3715		INH CRY18,		;NO CARRY
							; 3716		LOAD VMA,		;START TO STORE ITEM
							; 3717		START WRITE,		;START MEM CYCLE
							; 3718		PXCT STACK WORD,	;THIS IS THE STACK DATA WORD
							; 3719		3T,			;ALLOW TIME
							; 3720		SKIP CRY0,		;GO TO STMAC, SKIP IF PDL OV
U 2736, 1152,0551,1504,0274,4407,0311,0200,0003,0712	; 3721		J/STMAC 		; ..
							; 3722	
							; 3723	1544:
							; 3724	PUSHJ:	[BR]_PC WITH FLAGS,	;COMPUTE UPDATED FLAGS
							; 3725		CLR FPD,		;CLEAR FIRST-PART-DONE
U 1544, 2736,3741,0105,4074,4467,0700,0000,0005,0000	; 3726		J/PUSH1 		; AND JOIN PUSH CODE
							; 3727	
							; 3728	=0
							; 3729	STMAC:	MEM WRITE,		;WAIT FOR MEMORY
							; 3730		MEM_[BR],		;STORE BR ON STACK
							; 3731		B DISP, 		;SEE IF PUSH OR PUSHJ
U 1152, 0220,3333,0005,4175,5003,7701,0200,0000,0002	; 3732		J/JSTAC 		;BELOW
							; 3733	;WE MUST STORE THE STACK WORD PRIOR TO SETTING PDL OV IN CASE OF
							; 3734	; PAGE FAIL.
							; 3735		MEM WRITE,		;WAIT FOR MEMORY
U 1153, 2737,3333,0005,4175,5007,0701,0200,0000,0002	; 3736		MEM_[BR]		;STORE BR
							; 3737	SETPDL: SET PDL OV,		;OVERFLOW
							; 3738		B DISP, 		;SEE IF PUSH OR PUSHJ
U 2737, 0220,4443,0000,4174,4463,7700,0000,0001,2000	; 3739		J/JSTAC 		;BELOW
							; 3740	
							; 3741	=00
							; 3742	JSTAC:	[PC]_[AR],		;PUSHJ--LOAD PC
							; 3743		LOAD VMA,		;LOAD ADDRESS
U 0220, 0221,3441,0301,4174,4007,0700,0200,0014,0012	; 3744		FETCH			;GET NEXT INST
							; 3745	JSTAC1: AC_[ARX],		;STORE BACK STACK PTR
U 0221, 0100,3440,0404,0174,4156,4700,0400,0000,0000	; 3746		NEXT INST		;DO NEXT INST
							; 3747		AC_[ARX],		;UPDATE STACK POINTER
U 0222, 1400,3440,0404,0174,4007,0700,0400,0000,0000	; 3748		J/DONE			;DO NEXT INST
							; 3749	=
							; 3750	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 103
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			STACK INSTRUCTIONS -- PUSHJ, PUSH, POP, POPJ		

							; 3751	1545:
							; 3752	POP:	[ARX]_AC,		;GET POINTER
							; 3753		LOAD VMA,		;ADDRESS OF STACK WORD
							; 3754		START READ, 3T,		;START CYCLE
U 1545, 2740,3771,0004,0276,6007,0701,0200,0004,0712	; 3755		PXCT STACK WORD 	;FOR PXCT
							; 3756	
							; 3757		MEM READ,		;LOAD BR (QUIT IF PAGE FAIL)
U 2740, 2741,3771,0005,4365,5007,0700,0200,0000,0002	; 3758		[BR]_MEM		;STACK WORD TO BR
							; 3759	
							; 3760		[ARX]_[ARX]+#,		;UPDATE POINTER
							; 3761		#/777777,		;-1 IN EACH HALF
							; 3762		INH CRY18, 3T,		;BUT NO CARRY
U 2741, 1156,0551,0404,4374,4407,0311,0000,0077,7777	; 3763		SKIP CRY0		;SEE IF OVERFLOW
							; 3764	
							; 3765	=0	VMA_[AR],		;EFFECTIVE ADDRESS
							; 3766		PXCT DATA,		;FOR PXCT
							; 3767		START WRITE,		;WHERE TO STORE RESULT
U 1156, 2743,3443,0300,4174,4007,0700,0200,0003,0312	; 3768		J/POPX1			;OVERFLOW
							; 3769	
							; 3770		VMA_[AR],		;EFFECTIVE ADDRESS
							; 3771		PXCT DATA,		;FOR PXCT
U 1157, 2742,3443,0300,4174,4007,0700,0200,0003,0312	; 3772		START WRITE		;WHERE TO STORE RESULT
							; 3773	
							; 3774		MEM WRITE,		;WAIT FOR MEM
							; 3775		MEM_[BR],		;STORE BR
							; 3776		B DISP, 		;POP OR POPJ?
U 2742, 0220,3333,0005,4175,5003,7701,0200,0000,0002	; 3777		J/JSTAC 		;STORE POINTER
							; 3778	
							; 3779	
							; 3780	POPX1:	MEM WRITE,		;WAIT FOR MEMORY
							; 3781		MEM_[BR],		;STORE BR
U 2743, 2737,3333,0005,4175,5007,0701,0200,0000,0002	; 3782		J/SETPDL		;GO SET PDL OV
							; 3783	
							; 3784	1546:
							; 3785	POPJ:	[ARX]_AC,		;GET POINTER
							; 3786		LOAD VMA,		;POINT TO STACK WORD
							; 3787		PXCT STACK WORD, 3T,	;FOR PXCT
U 1546, 2744,3771,0004,0276,6007,0701,0200,0004,0712	; 3788		START READ		;START READ
							; 3789		[ARX]_[ARX]+#,		;UPDATE POINTER
							; 3790		#/777777,		;-1 IN BOTH HALFS
							; 3791		INH CRY18, 3T,		;INHIBIT CARRY 18
U 2744, 1164,0551,0404,4374,4407,0311,0000,0077,7777	; 3792		SKIP CRY0		;SEE IF OVERFLOW
U 1164, 1165,4443,0000,4174,4467,0700,0000,0001,2000	; 3793	=0	SET PDL OV		;SET OVERFLOW
							; 3794		MEM READ, [PC]_MEM,	;STICK DATA IN PC
							; 3795		HOLD LEFT,		;NO FLAGS
U 1165, 0221,3771,0001,4361,5007,0700,0200,0000,0002	; 3796		J/JSTAC1		;STORE POINTER
							; 3797	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 104
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			STACK INSTRUCTIONS -- ADJSP				

							; 3798	.TOC	"STACK INSTRUCTIONS -- ADJSP"
							; 3799	
							; 3800		.DCODE
D 0105, 0000,1551,3000					; 3801	105:	I-PF,	B/0,		J/ADJSP
							; 3802		.UCODE
							; 3803	
							; 3804	1551:
							; 3805	ADJSP:	[AR]_[AR] SWAP, 	;MAKE 2 COPIES OF RH
U 1551, 2745,3770,0303,4344,0007,0700,0000,0000,0000	; 3806		HOLD RIGHT
							; 3807		[BR]_AC,		;READ AC, SEE IF MINUS
							; 3808		3T,
U 2745, 1166,3771,0005,0276,6007,0521,0000,0000,0000	; 3809		SKIP DP0
							; 3810	=0	AC_[BR]+[AR],		;UPDATE AC
							; 3811		INH CRY18,		;NO CARRY
							; 3812		SKIP DP0,		;SEE IF STILL OK
							; 3813		3T,			;ALLOW TIME
U 1166, 1170,0113,0503,0174,4407,0521,0400,0000,0000	; 3814		J/ADJSP1		;TEST FOR OFLO
							; 3815		AC_[BR]+[AR],		;UPDATE AC
							; 3816		INH CRY18,		;NO CARRY
							; 3817		SKIP DP0,		;SEE IF STILL MINUS
							; 3818		3T,			;ALLOW TIME FOR SKIP
U 1167, 1172,0113,0503,0174,4407,0521,0400,0000,0000	; 3819		J/ADJSP2		;CONTINUE BELOW
							; 3820	
							; 3821	=0
U 1170, 0100,4443,0000,4174,4156,4700,0000,0000,0000	; 3822	ADJSP1: NEXT INST		;NO OVERFLOW
							; 3823		SET PDL OV,		;SET PDL OV
U 1171, 0555,4443,0000,4174,4467,0700,0000,0001,2000	; 3824		J/NIDISP		;GO DO NICOND DISP
							; 3825	
							; 3826	=0
							; 3827	ADJSP2: SET PDL OV,		;SET PDL OV
U 1172, 0555,4443,0000,4174,4467,0700,0000,0001,2000	; 3828		J/NIDISP		;GO DO NICOND DISP
U 1173, 0100,4443,0000,4174,4156,4700,0000,0000,0000	; 3829		NEXT INST		;NO OVERFLOW
							; 3830	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 105
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			SUBROUTINE CALL/RETURN -- JSR, JSP, JSA, JRA		

							; 3831	.TOC	"SUBROUTINE CALL/RETURN -- JSR, JSP, JSA, JRA"
							; 3832	
							; 3833		.DCODE
D 0264, 0000,1552,2100					; 3834	264:	I,		J/JSR
D 0265, 0000,1550,2100					; 3835		I,		J/JSP
D 0266, 0000,1554,2100					; 3836		I,		J/JSA
D 0267, 0000,1555,2100					; 3837		I,		J/JRA
							; 3838		.UCODE
							; 3839	
							; 3840	1550:
U 1550, 2746,3741,0105,4074,4007,0700,0000,0000,0000	; 3841	JSP:	[BR]_PC WITH FLAGS	;GET PC WITH FLAGS
							; 3842		CLR FPD,		;CLEAR FIRST-PART-DONE
							; 3843		AC_[BR],		;STORE FLAGS
U 2746, 0762,3440,0505,0174,4467,0700,0400,0005,0000	; 3844		J/JUMPA 		;GO JUMP
							; 3845	
							; 3846	1552:
							; 3847	JSR:	[BR]_PC WITH FLAGS,	;GET PC WITH FLAGS
U 1552, 2747,3741,0105,4074,4467,0700,0000,0005,0000	; 3848		CLR FPD 		;CLEAR FIRST-PART-DONE
							; 3849		VMA_[AR],		;EFFECTIVE ADDRESS
U 2747, 2750,3443,0300,4174,4007,0700,0200,0003,0012	; 3850		START WRITE		;STORE OLD PC WORD
							; 3851		MEM WRITE,		;WAIT FOR MEMORY
U 2750, 2751,3333,0005,4175,5007,0701,0200,0000,0002	; 3852		MEM_[BR]		;STORE
							; 3853		[PC]_[AR]+1000001,	;PC _ E+1
							; 3854		HOLD LEFT,		;NO JUNK IN LEFT
							; 3855		3T,			;ALLOW TIME FOR DBM
U 2751, 1400,0551,0301,4370,4007,0701,0000,0000,0001	; 3856		J/DONE	 		;[127] START AT E+1
							; 3857					;[127] MUST NICOND TO CLEAR TRAP CYCLE
							; 3858	
							; 3859	
							; 3860	
							; 3861	1554:
							; 3862	JSA:	[BR]_[AR],		;SAVE E
U 1554, 2752,3441,0305,4174,4007,0700,0200,0003,0002	; 3863		START WRITE		;START TO STORE
U 2752, 0130,3770,0304,4344,4007,0700,0000,0000,0000	; 3864		[ARX]_[AR] SWAP 	;ARX LEFT _ E
							; 3865	=0*0	[AR]_AC, 		;GET OLD AC
U 0130, 3114,3771,0003,0276,6007,0700,0010,0000,0000	; 3866		CALL [IBPX]		;SAVE AR IN MEMORY
							; 3867	=1*0	[ARX]_[PC],		;ARX NOW HAS E,,PC
							; 3868		HOLD LEFT,		; ..
U 0134, 3731,3441,0104,4170,4007,0700,0010,0000,0000	; 3869		CALL [AC_ARX]		;GO PUT ARX IN AC
							; 3870	=1*1	[PC]_[BR]+1000001,	;NEW PC
							; 3871		3T,			;ALLOW TIME
							; 3872		HOLD LEFT,		;NO JUNK IN PC LEFT
U 0135, 1400,0551,0501,4370,4007,0701,0000,0000,0001	; 3873		J/DONE	 		;[127] START AT E+1
							; 3874					;[127] NICOND MUST CLEAR TRAP CYCLE
							; 3875	=
							; 3876	
							; 3877	1555:
U 1555, 2753,3771,0005,0276,6007,0700,0000,0000,0000	; 3878	JRA:	[BR]_AC 		;GET AC
U 2753, 2754,3770,0505,4344,4007,0700,0000,0000,0000	; 3879		[BR]_[BR] SWAP		;OLD E IN BR RIGHT
							; 3880		VMA_[BR],		;LOAD VMA
U 2754, 2755,3443,0500,4174,4007,0700,0200,0004,0012	; 3881		START READ		;FETCH SAVED AC
							; 3882		MEM READ,		;WAIT FOR MEMORY
							; 3883		[BR]_MEM,		;LOAD BR WITH SAVE AC
U 2755, 0274,3771,0005,4365,5007,0700,0200,0000,0002	; 3884		J/JMPA			;GO JUMP
							; 3885	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 106
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 3886	.TOC	"ILLEGAL INSTRUCTIONS AND UUO'S"
							; 3887	;LUUO'S TRAP TO CURRENT CONTEXT
							; 3888	
							; 3889		.DCODE
D 0030, 0000,1557,2100					; 3890	030:	I,	B/0,	J/LUUO
D 0031, 0001,1557,2100					; 3891		I,	B/1,	J/LUUO
D 0032, 0002,1557,2100					; 3892		I,	B/2,	J/LUUO
D 0033, 0003,1557,2100					; 3893		I,	B/3,	J/LUUO
D 0034, 0004,1557,2100					; 3894		I,	B/4,	J/LUUO
D 0035, 0005,1557,2100					; 3895		I,	B/5,	J/LUUO
D 0036, 0006,1557,2100					; 3896		I,	B/6,	J/LUUO
D 0037, 0007,1557,2100					; 3897		I,	B/7,	J/LUUO
							; 3898	
							; 3899	;MONITOR UUO'S -- TRAP TO EXEC
							; 3900	
D 0040, 0000,1556,2100					; 3901	040:	I,		J/MUUO		;CALL
D 0041, 0000,1556,2100					; 3902		I,		J/MUUO		;INIT
D 0042, 0000,1556,2100					; 3903		I,		J/MUUO
D 0043, 0000,1556,2100					; 3904		I,		J/MUUO
D 0044, 0000,1556,2100					; 3905		I,		J/MUUO
D 0045, 0000,1556,2100					; 3906		I,		J/MUUO
D 0046, 0000,1556,2100					; 3907		I,		J/MUUO
D 0047, 0000,1556,2100					; 3908		I,		J/MUUO		;CALLI
D 0050, 0000,1556,2100					; 3909		I,		J/MUUO		;OPEN
D 0051, 0000,1556,2100					; 3910		I,		J/MUUO		;TTCALL
D 0052, 0000,1556,2100					; 3911		I,		J/MUUO
D 0053, 0000,1556,2100					; 3912		I,		J/MUUO
D 0054, 0000,1556,2100					; 3913		I,		J/MUUO
D 0055, 0000,1556,2100					; 3914		I,		J/MUUO		;RENAME
D 0056, 0000,1556,2100					; 3915		I,		J/MUUO		;IN
D 0057, 0000,1556,2100					; 3916		I,		J/MUUO		;OUT
D 0060, 0000,1556,2100					; 3917		I,		J/MUUO		;SETSTS
D 0061, 0000,1556,2100					; 3918		I,		J/MUUO		;STATO
D 0062, 0000,1556,2100					; 3919		I,		J/MUUO		;GETSTS
D 0063, 0000,1556,2100					; 3920		I,		J/MUUO		;STATZ
D 0064, 0000,1556,2100					; 3921		I,		J/MUUO		;INBUF
D 0065, 0000,1556,2100					; 3922		I,		J/MUUO		;OUTBUF
D 0066, 0000,1556,2100					; 3923		I,		J/MUUO		;INPUT
D 0067, 0000,1556,2100					; 3924		I,		J/MUUO		;OUTPUT
D 0070, 0000,1556,2100					; 3925		I,		J/MUUO		;CLOSE
D 0071, 0000,1556,2100					; 3926		I,		J/MUUO		;RELEAS
D 0072, 0000,1556,2100					; 3927		I,		J/MUUO		;MTAPE
D 0073, 0000,1556,2100					; 3928		I,		J/MUUO		;UGETF
D 0074, 0000,1556,2100					; 3929		I,		J/MUUO		;USETI
D 0075, 0000,1556,2100					; 3930		I,		J/MUUO		;USETO
D 0076, 0000,1556,2100					; 3931		I,		J/MUUO		;LOOKUP
D 0077, 0000,1556,2100					; 3932		I,		J/MUUO		;ENTER
							; 3933	
							; 3934	;EXPANSION OPCODES
							; 3935	
D 0100, 0000,1556,2100					; 3936	100:	I,		J/UUO		;UJEN
D 0101, 0000,1661,2100					; 3937		I,		J/UUO101
D 0102, 0000,1662,2100					; 3938		I,		J/UUO102	;GFAD
D 0103, 0000,1663,2100					; 3939		I,		J/UUO103	;GFSB
							; 3940	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 107
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 3941	;RESERVED OPCODES
							; 3942	
D 0000, 0000,1556,2100					; 3943	000:	I,		J/UUO
D 0104, 0000,1664,2100					; 3944	104:	I,		J/JSYS		;JSYS
D 0106, 0000,1666,2100					; 3945	106:	I,		J/UUO106	;GFMP
D 0107, 0000,1667,2100					; 3946		I,		J/UUO107	;GFDV
D 0130, 0000,1660,2100					; 3947	130:	I,	B/0,	J/FP-LONG	;UFA
D 0131, 0001,1660,2100					; 3948		I,	B/1,	J/FP-LONG	;DFN
D 0141, 0002,1660,2100					; 3949	141:	I,	B/2,	J/FP-LONG	;FADL
D 0151, 0003,1660,2100					; 3950	151:	I,	B/3,	J/FP-LONG	;FSBL
D 0161, 0004,1660,2100					; 3951	161:	I,	B/4,	J/FP-LONG	;FMPL
D 0171, 0005,1660,2100					; 3952	171:	I,	B/5,	J/FP-LONG	;FDVL
D 0247, 0000,1665,2100					; 3953	247:	I,		J/UUO247	;RESERVED
							; 3954		.UCODE
							; 3955	
							; 3956	1661:
U 1661, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3957	UUO101: UUO
							; 3958	1662:
U 1662, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3959	UUO102: UUO
							; 3960	1663:
U 1663, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3961	UUO103: UUO
							; 3962	1664:
U 1664, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3963	JSYS:	UUO
							; 3964	1666:
U 1666, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3965	UUO106: UUO
							; 3966	1667:
U 1667, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3967	UUO107: UUO
							; 3968	1660:
U 1660, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3969	FP-LONG:UUO
							; 3970	1665:
U 1665, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3971	UUO247: UUO
							; 3972	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 108
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 3973	;HERE FOR UUO'S WHICH TRAP TO EXEC
							; 3974	1556:
							; 3975	UUO:	;THIS TAG IS USED FOR ILLEGAL THINGS WHICH DO UUO TRAPS
							; 3976	MUUO:	;THIS TAG IS USED FOR MONITOR CALL INSTRUCTIONS
							; 3977		[HR]_[HR].AND.#,	;MASK OUT @ AND XR
							; 3978		#/777740,		;MASK
U 1556, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 3979		HOLD RIGHT		;KEEP RIGHT
							; 3980	;THE UUO MACRO DOES THE ABOVE INSTRUCTION AND GOES TO UUOGO
U 2756, 1174,4751,1204,4374,4007,0700,0000,0000,0424	; 3981	UUOGO:	[ARX]_0 XWD [424]	;HERE FROM UUO MACRO
							; 3982					;GET OFFSET TO UPT
							; 3983	=0	[ARX]_[ARX]+[UBR],	;ADDRESS OF MUUO WORD
U 1174, 4047,0111,1104,4174,4007,0700,0010,0000,0000	; 3984		CALL [ABORT]		;STOP MEMORY
							; 3985	.IF/KIPAGE
							; 3986	.IF/KLPAGE
							; 3987		READ [EBR],		;IF BOTH POSSIBLE, SEE WHICH IS ENABLED
U 1175, 1176,3333,0010,4174,4007,0520,0000,0000,0000	; 3988		SKIP DP0		;KL PAGING ??
							; 3989	=0
							; 3990	.ENDIF/KLPAGE
							; 3991		READ [ARX],		;GET THE ADDRESS
							; 3992		LOAD VMA,		;START WRITE
							; 3993		VMA PHYSICAL WRITE,	;ABSOLUTE ADDRESS
U 1176, 0310,3333,0004,4174,4007,0700,0200,0021,1016	; 3994		J/KIMUUO		;GO STORE KI STYLE
							; 3995	.ENDIF/KIPAGE
							; 3996	.IF/KLPAGE
U 1177, 1200,3770,0203,4344,4007,0700,0000,0000,0000	; 3997		[AR]_[HR] SWAP		;PUT IN RIGHT HALF
							; 3998	=0	[AR]_FLAGS,		;FLAGS IN LEFT HALF
							; 3999		HOLD RIGHT,		;JUST WANT FLAGS
U 1200, 2764,4521,1203,4074,0007,0700,0010,0000,0000	; 4000		CALL [UUOFLG]		;CLEAR TRAP FLAGS
							; 4001		READ [ARX],		;LOOK AT ADDRESS
							; 4002		LOAD VMA,		;LOAD THE VMA
U 1201, 0314,3333,0004,4174,4007,0700,0200,0021,1016	; 4003		VMA PHYSICAL WRITE	;STORE FLAG WORD
							; 4004	=0*	MEM WRITE,		;WAIT FOR MEMORY
U 0314, 2765,3333,0003,4175,5007,0701,0210,0000,0002	; 4005		MEM_[AR], CALL [NEXT]	;STORE
							; 4006		MEM WRITE,		;WAIT FOR MEMORY
U 0316, 0020,3333,0001,4175,5007,0701,0200,0000,0002	; 4007		MEM_[PC]		;STORE FULL WORD PC
							; 4008	=000	[HR]_0, 		;SAVE E
U 0020, 2765,4221,0002,4174,0007,0700,0010,0000,0000	; 4009		HOLD RIGHT, CALL [NEXT]	;BUT CLEAR OPCODE
							; 4010	.ENDIF/KLPAGE
							; 4011	=010
							; 4012	UUOPCW: MEM WRITE,		;WAIT FOR MEMORY
							; 4013		MEM_[HR],		;STORE INSTRUCTION IN KI
							; 4014					; OR FULL WORD E IN KL
U 0022, 3603,3333,0002,4175,5007,0701,0210,0000,0002	; 4015		CALL [GETPCW]		;GET PROCESS-CONTEXT-WORD
							; 4016	
							; 4017	=011	NEXT [ARX] PHYSICAL WRITE, ;POINT TO NEXT WORD
U 0023, 3727,0111,0704,4170,4007,0700,0210,0023,1016	; 4018		CALL [STOBR]		;STORE PROCESS CONTEXT WORD
							; 4019	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 109
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 4020	;NOW WE MUST PICK ONE OF 8 NEW PC WORDS BASED ON PC FLAGS
U 0027, 2757,4751,1205,4374,4007,0700,0000,0000,0430	; 4021	=111	[BR]_0 XWD [430]	;OFFSET INTO UPT
							; 4022	=
U 2757, 2760,0111,1105,4174,4007,0700,0000,0000,0000	; 4023		[BR]_[BR]+[UBR] 	;ADDRESS OF WORD
U 2760, 2761,4521,1203,4074,4007,0700,0000,0000,0000	; 4024		[AR]_FLAGS		;GET FLAGS
							; 4025		TL [AR],		;LOOK AT FLAGS
U 2761, 1202,4553,0300,4374,4007,0321,0000,0000,0600	; 4026		#/600			;TRAP SET?
							; 4027	=0	[BR]_[BR].OR.#, 	;YES--POINT TO TRAP CASE
							; 4028		#/1,			; ..
U 1202, 1203,3551,0505,4370,4007,0700,0000,0000,0001	; 4029		HOLD LEFT		;LEAVE LEFT ALONE
							; 4030		TL [AR],		;USER OR EXEC
U 1203, 1204,4553,0300,4374,4007,0321,0000,0001,0000	; 4031		#/10000 		; ..
							; 4032	=0	[BR]_[BR].OR.#, 	;USER
							; 4033		#/4,			;POINT TO USER WORDS
U 1204, 1205,3551,0505,4370,4007,0700,0000,0000,0004	; 4034		HOLD LEFT
							; 4035		READ [BR],		;LOOK AT ADDRESS
							; 4036		LOAD VMA,		;PLACE IN VMA
							; 4037		VMA PHYSICAL,		;PHYSICAL ADDRESS
U 1205, 2762,3333,0005,4174,4007,0700,0200,0024,1016	; 4038		START READ		;GET NEW PC WORD
							; 4039	GOEXEC: MEM READ,		;WAIT FOR DATA
U 2762, 2763,3771,0003,4365,5007,0700,0200,0000,0002	; 4040		[AR]_MEM		;STICK IN AR
							; 4041		READ [AR],		;LOOK AT DATA
							; 4042		LOAD FLAGS,		;LOAD NEW FLAGS
							; 4043		LEAVE USER,		;ALLOW USER TO LOAD
							; 4044		LOAD PCU,		;SET PCU FROM USER
U 2763, 0762,3333,0003,4174,4467,0700,0000,0000,0404	; 4045		J/JUMPA 		;JUMP
							; 4046	
							; 4047	.IF/KIPAGE
							; 4048	;HERE FOR TOPS-10 STYLE PAGING
							; 4049	
							; 4050	=00
							; 4051	KIMUUO: MEM WRITE,		;STORE INSTRUCTION
U 0310, 2765,3333,0002,4175,5007,0701,0210,0000,0002	; 4052		MEM_[HR], CALL [NEXT]	;IN MEMORY
							; 4053	=10	[AR]_PC WITH FLAGS,	;GET PC WORD
U 0312, 2764,3741,0103,4074,4007,0700,0010,0000,0000	; 4054		CALL [UUOFLG]		;CLEAR TRAP FLAGS
							; 4055	=11	MEM WRITE,		;STORE PC WORD
							; 4056		MEM_[AR],		; ..
U 0313, 0022,3333,0003,4175,5007,0701,0200,0000,0002	; 4057		J/UUOPCW		;GO STORE PROCESS CONTEXT
							; 4058	.ENDIF/KIPAGE
							; 4059	
							; 4060	UUOFLG:	[AR]_[AR].AND.NOT.#,	;CLEAR TRAP FLAGS
							; 4061		#/600, HOLD RIGHT,	; IN WORD TO SAVE
U 2764, 0001,5551,0303,4374,0004,1700,0000,0000,0600	; 4062		RETURN [1]		; BACK TO CALLER
							; 4063	
							; 4064	NEXT:	NEXT [ARX] PHYSICAL WRITE, ;POINT TO NEXT WORD
U 2765, 0002,0111,0704,4170,4004,1700,0200,0023,1016	; 4065		RETURN [2]
							; 4066	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 110
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ILLEGAL INSTRUCTIONS AND UUO'S				

							; 4067	;HERE FOR LUUO'S
							; 4068	1557:
U 1557, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 4069	LUUO:	[AR]_0 XWD [40] 	;AR GET CONSTANT 40
							; 4070	;THE LUUO MACRO DOES THE ABOVE INSTRUCTION AND GOES TO LUUO1
							; 4071	400:				;FOR SIMULATOR
							; 4072	LUUO1:	READ [AR],		;LOAD 40 INTO
							; 4073		LOAD VMA,		; THE VMA AND
U 0400, 2766,3333,0003,4174,4007,0700,0200,0003,0012	; 4074		START WRITE		; PREPARE TO STORE
							; 4075		[HR]_[HR].AND.#,	;CLEAR OUT INDEX AND @
							; 4076		#/777740,		; ..
U 2766, 2767,4551,0202,4374,0007,0700,0000,0077,7740	; 4077		HOLD RIGHT
							; 4078		MEM WRITE,		;STORE LUUO IN 40
U 2767, 2770,3333,0002,4175,5007,0701,0200,0000,0002	; 4079		MEM_[HR]
							; 4080		VMA_[AR]+1,		;POINT TO 41
							; 4081		LOAD VMA,		;PUT 41 IN VMA
							; 4082		START READ,		;START FETCH
U 2770, 2525,0111,0703,4170,4007,0700,0200,0004,0012	; 4083		J/CONT1 		;GO EXECUTE THE INSTRUCTION
							; 4084	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 111
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- ADD, SUB					

							; 4085	.TOC	"ARITHMETIC -- ADD, SUB"
							; 4086	
							; 4087		.DCODE
D 0270, 1015,1560,1100					; 4088	270:	R-PF,	AC,	J/ADD
D 0271, 0015,1560,3000					; 4089		I-PF,	AC,	J/ADD
D 0272, 0016,1560,1700					; 4090		RW,	M,	J/ADD
D 0273, 0017,1560,1700					; 4091		RW,	B,	J/ADD
							; 4092		.UCODE
							; 4093	
							; 4094	1560:
							; 4095	ADD:	[AR]_[AR]+AC,		;DO THE ADD
U 1560, 1500,0551,0303,0274,4463,7701,0200,0001,0001	; 4096		AD FLAGS EXIT, 3T	;UPDATE CARRY FLAGS
							; 4097					;STORE ANSWER
							; 4098					;MISSES 3-TICKS BY 3 NS.
							; 4099	
							; 4100	
							; 4101		.DCODE
D 0274, 1015,1561,1100					; 4102	274:	R-PF,	AC,	J/SUB
D 0275, 0015,1561,3000					; 4103		I-PF,	AC,	J/SUB
D 0276, 0016,1561,1700					; 4104		RW,	M,	J/SUB
D 0277, 0017,1561,1700					; 4105		RW,	B,	J/SUB
							; 4106		.UCODE
							; 4107	
							; 4108	1561:
							; 4109	SUB:	[AR]_AC-[AR],		;DO THE SUBTRACT
U 1561, 1500,2551,0303,0274,4463,7701,4200,0001,0001	; 4110		AD FLAGS EXIT, 3T	;UPDATE PC CARRY FLAGS
							; 4111					;ALL DONE
							; 4112					;MISSES 3-TICKS BY 3 NS.
							; 4113	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 112
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DADD, DSUB				

							; 4114	.TOC	"ARITHMETIC -- DADD, DSUB"
							; 4115	
							; 4116		.DCODE
D 0114, 0205,1457,1100					; 4117	114:	DBL R,	DAC,	J/DADD
D 0115, 0205,1615,1100					; 4118		DBL R,	DAC,	J/DSUB
							; 4119		.UCODE
							; 4120	
							; 4121	1457:
							; 4122	DADD:	[ARX]_[ARX]+AC[1], 4T,	;ADD LOW WORDS
U 1457, 1206,0551,0404,1274,4007,0562,0000,0000,1441	; 4123		SKIP CRY1		;SEE IF CARRY TO HIGH WORD
							; 4124	=0
							; 4125	DADD1:	[AR]_[AR]+AC,		;ADD HIGH WORDS
							; 4126		ADD .25,		;ADD IN ANY CARRY FROM LOW WORD
							; 4127		AD FLAGS, 4T,		;UPDATE PC FLAGS
U 1206, 2772,0551,0303,0274,4467,0702,4000,0001,0001	; 4128		J/CPYSGN		;COPY SIGN TO LOW WORD
U 1207, 2771,7441,1205,4174,4007,0700,0000,0000,0000	; 4129		[BR]_.NOT.[MASK]	;SET BITS 35 AND 36 IN
							; 4130		[AR]_[AR].OR.[BR],	; AR SO THAT ADD .25 WILL
U 2771, 1206,3111,0503,4170,4007,0700,0000,0000,0000	; 4131		HOLD LEFT, J/DADD1	; ADD 1.
							; 4132	
							; 4133	1615:
							; 4134	DSUB:	[ARX]_AC[1]-[ARX], 4T,	;SUBTRACT LOW WORD
U 1615, 1210,2551,0404,1274,4007,0562,4000,0000,1441	; 4135		SKIP CRY1		;SEE IF CARRY
							; 4136	=0	[AR]_AC-[AR]-.25,	;NO CARRY
							; 4137		AD FLAGS, 4T,		;UPDATE PC FLAGS
U 1210, 2772,2551,0303,0274,4467,0702,0000,0001,0001	; 4138		J/CPYSGN		;GO COPY SIGN
							; 4139		[AR]_AC-[AR], 4T,	;THERE WAS A CARRY
U 1211, 2772,2551,0303,0274,4467,0702,4000,0001,0001	; 4140		AD FLAGS		;UPDATE CARRY FLAGS
							; 4141	
U 2772, 1212,3770,0303,4174,0007,0520,0000,0000,0000	; 4142	CPYSGN: FIX [AR] SIGN, SKIP DP0
U 1212, 1404,4551,0404,4374,0007,0700,0000,0037,7777	; 4143	=0	[ARX]_[ARX].AND.#, #/377777, HOLD RIGHT, J/MOVE
U 1213, 1404,3551,0404,4374,0007,0700,0000,0040,0000	; 4144		[ARX]_[ARX].OR.#, #/400000, HOLD RIGHT, J/MOVE
							; 4145	
							; 4146	
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 113
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- MUL, IMUL					

							; 4147	.TOC	"ARITHMETIC -- MUL, IMUL"
							; 4148	
							; 4149		.DCODE
D 0220, 1015,1641,1100					; 4150	220:	R-PF,	AC,	J/IMUL
D 0221, 0015,1641,3000					; 4151		I-PF,	AC,	J/IMUL
D 0222, 0016,1641,1700					; 4152		RW,	M,	J/IMUL
D 0223, 0017,1641,1700					; 4153		RW,	B,	J/IMUL
							; 4154		.UCODE
							; 4155	1641:
U 1641, 2773,3441,0306,0174,4007,0700,0000,0000,0000	; 4156	IMUL:	[BRX]_[AR], AC		;COPY C(E)
U 2773, 0021,3772,0000,0275,5007,0700,2000,0071,0043	; 4157		Q_AC, SC_35.		;GET THE AC
							; 4158	=0**	[BRX]_[BRX]*.5 LONG,	;SHIFT RIGHT
U 0021, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 4159		CALL [MULSUB]		;MULTIPLY
U 0025, 1214,3333,0004,4174,4007,0621,0000,0000,0000	; 4160		READ [ARX], SKIP AD.EQ.0 ;SEE IF FITS
U 1214, 2774,3445,0404,4174,4007,0700,0000,0000,0000	; 4161	=0	[ARX]_[ARX]*2, J/IMUL2	;NOT ZERO--SHIFT LEFT
U 1215, 1500,3221,0003,4174,4003,7700,0200,0003,0001	; 4162	IMUL1:	[AR]_Q, EXIT		;POSITIVE
							; 4163	
							; 4164	IMUL2:	[MASK].AND.NOT.[ARX],	;SEE IF ALL SIGN BITS
U 2774, 1216,5113,0412,4174,4007,0621,0000,0000,0000	; 4165		SKIP AD.EQ.0		; ..
							; 4166	=0	FIX [ARX] SIGN, 	;NOT ALL SIGN BITS
U 1216, 1220,3770,0404,4174,0007,0520,0000,0000,0000	; 4167		SKIP DP0, J/IMUL3	;GIVE + OR - OVERFLOW
U 1217, 1500,7001,0003,4174,4003,7700,0200,0003,0001	; 4168		[AR]_[MAG].EQV.Q, EXIT	;NEGATIVE
							; 4169	=0
U 1220, 1404,3221,0003,4174,4467,0700,0000,0041,1000	; 4170	IMUL3:	[AR]_Q, SET AROV, J/MOVE
U 1221, 1404,7001,0003,4174,4467,0700,0000,0041,1000	; 4171		[AR]_[MAG].EQV.Q, SET AROV, J/MOVE
							; 4172	
							; 4173	
							; 4174		.DCODE
D 0224, 1005,1571,1100					; 4175	224:	R-PF,	DAC,	J/MUL
D 0225, 0005,1571,3000					; 4176		I-PF,	DAC,	J/MUL
D 0226, 0016,1571,1700					; 4177		RW,	M,	J/MUL
D 0227, 0006,1571,1700					; 4178		RW,	DBL B,	J/MUL
							; 4179		.UCODE
							; 4180	
							; 4181	
							; 4182	1571:
U 1571, 2775,3442,0300,0174,4007,0700,0000,0000,0000	; 4183	MUL:	Q_[AR], AC		;COPY C(E)
U 2775, 2776,3441,0316,4174,4007,0700,0000,0000,0000	; 4184		[T0]_[AR]		;SAVE FOR OVERFLOW TEST
U 2776, 0031,3771,0006,0276,6007,0700,2000,0071,0043	; 4185		[BRX]_AC, SC_35.	;GET THE AC
							; 4186	=0**	[BRX]_[BRX]*.5 LONG,	;SHIFT OVER
U 0031, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 4187		CALL [MULSUB]		;MULTIPLY
U 0035, 2777,3445,0403,4174,4007,0700,0000,0000,0000	; 4188		[AR]_[ARX]*2		;SHIFT OVER
U 2777, 1222,3770,0303,4174,0007,0520,0000,0000,0000	; 4189		FIX [AR] SIGN, SKIP DP0 ;SEE IF NEGATIVE
							; 4190	=0	[ARX]_[MAG].AND.Q,	;POSITIVE
U 1222, 1500,4001,0004,4174,4003,7700,0200,0003,0001	; 4191		EXIT
U 1223, 1224,4113,0616,4174,4007,0520,0000,0000,0000	; 4192		[T0].AND.[BRX], SKIP DP0 ;TRIED TO SQUARE 1B0?
U 1224, 1500,7001,0004,4174,4003,7700,0200,0003,0001	; 4193	=0	[ARX]_[MAG].EQV.Q, EXIT	;NO
							; 4194		[ARX]_[MAG].EQV.Q, 	;YES 
U 1225, 1404,7001,0004,4174,4467,0700,0000,0041,1000	; 4195		SET AROV, J/MOVE
							; 4196	
							; 4197	
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 114
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

							; 4198	.TOC	"ARITHMETIC -- DMUL"
							; 4199	
							; 4200		.DCODE
D 0116, 0205,1566,1100					; 4201	116:	DBL R,	DAC,		J/DMUL
							; 4202		.UCODE
							; 4203	
							; 4204	.IF/FULL
							; 4205	1566:
U 1566, 3000,3447,0303,4174,4007,0700,0000,0000,0000	; 4206	DMUL:	[AR]_[AR]*.5		;SHIFT MEM OPERAND RIGHT
U 3000, 3001,4117,0004,4174,4007,0700,0000,0000,0000	; 4207		[ARX]_([ARX].AND.[MAG])*.5
							; 4208		[BR]_[ARX],		;COPY LOW WORD
U 3001, 0120,3441,0405,4174,4007,0350,0000,0000,0000	; 4209		SKIP FPD		;SEE IF FIRST PART DONE
							; 4210	;
							; 4211	; BRX * BR ==> C(E+1) * C(AC+1)
							; 4212	;
							; 4213	=000	[BRX]_(AC[1].AND.[MAG])*.5, 3T, ;GET LOW AC
U 0120, 3013,4557,0006,1274,4007,0701,0010,0000,1441	; 4214		CALL [DMULGO]		;START MULTIPLY
							; 4215		[ARX]_(AC[2].AND.[MAG])*.5, 3T, ;FIRST PART DONE
U 0121, 3003,4557,0004,1274,4007,0701,0000,0000,1442	; 4216		J/DMUL1 		;GO DO SECOND PART
U 0124, 0171,3223,0000,1174,4007,0700,0400,0000,1443	; 4217	=100	AC[3]_Q 		;SALT AWAY 1 WORD OF PRODUCT
							; 4218	=
							; 4219	;
							; 4220	; BRX * Q ==> C(E) * C(AC+1)
							; 4221	;
							; 4222	=0**	Q_[AR], SC_35., 	;GO MULT NEXT HUNK
U 0171, 0563,3442,0300,4174,4007,0700,2010,0071,0043	; 4223		CALL [QMULT]		; ..
U 0175, 3002,3441,0416,4174,4007,0700,0000,0000,0000	; 4224		[T0]_[ARX]		;SAVE PRODUCT
							; 4225		AC[2]_Q, [ARX]_Q*.5,	;SAVE PRODUCT
U 3002, 0410,3227,0004,1174,4007,0700,0400,0000,1442	; 4226		J/DMUL2			;GO DO HIGH HALF
U 3003, 0410,3777,0016,1276,6007,0701,0000,0000,1441	; 4227	DMUL1:	[T0]_AC[1]*.5		;RESTORE T0
							; 4228	=0*0
							; 4229	;
							; 4230	; BRX * BR ==> C(AC) * C(E+1)
							; 4231	;
							; 4232	DMUL2:	[BRX]_AC*.5,		;PREPARE TO DO HIGH HALF
U 0410, 3014,3777,0006,0274,4007,0701,0010,0000,0000	; 4233		CALL [DBLMUL]		; GO DO IT
							; 4234		AC[1]_[T0]*2, 3T,	;INTERRUPT, SAVE T0
U 0411, 3016,0113,1616,1174,4007,0701,0400,0000,1441	; 4235		J/DMLINT		;SET FPD AND INTERRUPT
U 0414, 3004,3223,0000,1174,4007,0700,0400,0000,1442	; 4236		AC[2]_Q 		;SAVE PRODUCT
							; 4237	=
U 3004, 0543,0111,1604,4174,4007,0700,0000,0000,0000	; 4238		[ARX]_[ARX]+[T0]	;PREPARE FOR LAST MUL
							; 4239	;
							; 4240	; BRX * Q ==> C(AC) * C(E)
							; 4241	;
							; 4242	=0**	Q_[AR], SC_35., 	;DO THE LAST MULTIPLY
U 0543, 0563,3442,0300,4174,4007,0700,2010,0071,0043	; 4243		CALL [QMULT]		; GO DO IT
							; 4244		[ARX]_[ARX]*2,		;SHIFT BACK
U 0547, 3005,3445,0404,4174,4467,0700,0000,0005,0000	; 4245		CLR FPD 		;CLEAR FPD
							; 4246	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 115
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

U 3005, 1226,3770,0404,0174,4007,0520,0400,0000,0000	; 4247		AC_[ARX] TEST, SKIP DP0 ;PUT BACK INTO AC
U 1226, 3012,3223,0000,1174,4007,0700,0400,0000,1441	; 4248	=0	AC[1]_Q, J/DMTRAP	;POSITIVE
U 1227, 3006,7003,0000,1174,4007,0700,0400,0000,1441	; 4249		AC[1]_[MAG].EQV.Q	;NEGATIVE
U 3006, 3007,3772,0000,1275,5007,0701,0000,0000,1442	; 4250		Q_AC[2]
U 3007, 3010,7003,0000,1174,4007,0700,0400,0000,1442	; 4251		AC[2]_[MAG].EQV.Q
U 3010, 3011,3772,0000,1275,5007,0701,0000,0000,1443	; 4252		Q_AC[3]
U 3011, 3012,7003,0000,1174,4007,0700,0400,0000,1443	; 4253		AC[3]_[MAG].EQV.Q
							; 4254	DMTRAP: [AR]_PC WITH FLAGS,	;LOOK AT FLAGS
U 3012, 1230,3741,0103,4074,4007,0520,0000,0000,0000	; 4255		SKIP DP0		;SEE IF AROV SET?
U 1230, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 4256	=0	DONE			;NO--ALL DONE
U 1231, 1400,4443,0000,4174,4467,0700,0000,0041,1000	; 4257		SET AROV, J/DONE	;YES--FORCE TRAP 1 ALSO
							; 4258	
							; 4259	
							; 4260	;WAYS TO CALL MULTIPLY
U 3013, 3014,4221,0004,4174,4007,0700,0000,0000,0000	; 4261	DMULGO: [ARX]_0 		;CLEAR ARX
U 3014, 3015,3442,0500,4174,4007,0700,2000,0071,0043	; 4262	DBLMUL: Q_[BR], SC_35.
U 3015, 0563,3447,0606,4174,4007,0700,0000,0000,0000	; 4263		[BRX]_[BRX]*.5
							; 4264	=0**
							; 4265	QMULT:	Q_Q*.5,
U 0563, 3021,3446,1200,4174,4007,0700,0010,0000,0000	; 4266		CALL [MULTIPLY]
							; 4267		[ARX]+[ARX], AD FLAGS,	;TEST FOR OVERFLOW
U 0567, 0004,0113,0404,4174,4464,1701,0000,0001,0001	; 4268		3T, RETURN [4]		;AND RETURN
							; 4269	
U 3016, 2717,4443,0000,4174,4467,0700,0000,0003,0000	; 4270	DMLINT: SET FPD, J/FIXPC	;SET FPD, BACKUP PC
							; 4271					; INTERRUPT
							;;4272	.IFNOT/FULL
							;;4273	1566:
							;;4274	DMUL:	UUO
							; 4275	.ENDIF/FULL
							; 4276	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 116
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

							; 4277	;MULTIPLY SUBROUTINE
							; 4278	;ENTERED WITH:
							; 4279	;	MULTIPLIER IN Q
							; 4280	;	MULTIPLICAND IN BRX
							; 4281	;RETURNS 4 WITH PRODUCT IN ARX!Q
							; 4282	
							; 4283	MUL STEP	"A/BRX,B/ARX,DEST/Q_Q*.5,ASHC,STEP SC,MUL DISP"
							; 4284	MUL FINAL	"A/BRX,B/ARX,DEST/Q_Q*2"
							; 4285	
U 3017, 3020,3446,0606,4174,4007,0700,0000,0000,0000	; 4286	MULSUB: [BRX]_[BRX]*.5 LONG
							; 4287	MULSB1: [ARX]_0*.5 LONG,	;CLEAR ARX AND SHIFT Q
							; 4288		STEP SC,		;COUNT FIRST STEP
U 3020, 0122,4226,0004,4174,4007,0630,2000,0060,0000	; 4289		J/MUL+			;ENTER LOOP
							; 4290	
							; 4291	;MULTIPLY SUBROUTINE
							; 4292	;ENTERED WITH:
							; 4293	;	MULTIPLIER IN Q
							; 4294	;	MULTIPLICAND IN BRX
							; 4295	;	PARTIAL PRODUCT IN ARX
							; 4296	;RETURNS 4 WITH Q*BRX+ARX IN ARX!Q
							; 4297	
							; 4298	MULTIPLY:
							; 4299		Q_Q*.5, 		;SHIFT Q
							; 4300		STEP SC,		;COUNT FIRST STEP
U 3021, 0122,3446,1200,4174,4007,0630,2000,0060,0000	; 4301		J/MUL+			;ENTER LOOP
							; 4302	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 117
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DMUL					

							; 4303	;HERE FOR POSITIVE STEPS
							; 4304	=010				;0 IN A POSITIVE STEP
							; 4305	MUL+:	AD/B,			;DON'T ADD
							; 4306		MUL STEP,		;SHIFT
U 0122, 0122,3336,0604,4174,4046,2630,2000,0060,0000	; 4307		J/MUL+			;KEEP POSITIVE
							; 4308	=011				;DONE
							; 4309		AD/B,			;DON'T ADD
							; 4310		MUL FINAL,		;SHIFT
U 0123, 0004,3334,0604,4174,4004,1700,0000,0000,0000	; 4311		RETURN [4]		;SHIFT Q AND RETURN
							; 4312	=110				;1 IN A POSITIVE STEP
							; 4313		AD/B-A-.25, ADD .25,	;SUBTRACT
							; 4314		MUL STEP,		;SHIFT AND COUNT
U 0126, 0142,1116,0604,4174,4046,2630,6000,0060,0000	; 4315		J/MUL-			;NEGATIVE NOW
							; 4316	=111				;DONE
							; 4317		AD/B-A-.25, ADD .25,	;SUBTRACT
							; 4318		MUL FINAL,		;SHIFT
U 0127, 0004,1114,0604,4174,4004,1700,4000,0000,0000	; 4319		RETURN [4]		; AND RETURN
							; 4320	
							; 4321	;HERE FOR NEGATIVE STEPS
							; 4322	=010				;0 IN NEGATIVE STEP
							; 4323	MUL-:	AD/A+B, 		;ADD
							; 4324		MUL STEP,		;SHIFT AND COUNT
U 0142, 0122,0116,0604,4174,4046,2630,2000,0060,0000	; 4325		J/MUL+			;POSITIVE NOW
							; 4326	=011				;DONE
							; 4327		AD/A+B, 		;ADD
							; 4328		MUL FINAL,		;SHIFT
U 0143, 0004,0114,0604,4174,4004,1700,0000,0000,0000	; 4329		RETURN [4]			;FIX Q AND RETURN
							; 4330	=110				;1 IN NEGATIVE STEP
							; 4331		AD/B,			;DON'T ADD
							; 4332		MUL STEP,		;SHIFT AND COUNT
U 0146, 0142,3336,0604,4174,4046,2630,2000,0060,0000	; 4333		J/MUL-			;STILL NEGATIVE
							; 4334	=111				;DONE
							; 4335		AD/B,			;DON'T ADD
							; 4336		MUL FINAL,		;SHIFT
U 0147, 0004,3334,0604,4174,4004,1700,0000,0000,0000	; 4337		RETURN [4]			;FIX Q AND RETURN
							; 4338	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 118
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIV, IDIV					

							; 4339	.TOC	"ARITHMETIC -- DIV, IDIV"
							; 4340	
							; 4341		.DCODE
D 0230, 1005,1600,1100					; 4342	230:	R-PF,	DAC,	J/IDIV
D 0231, 0005,1600,3000					; 4343		I-PF,	DAC,	J/IDIV
D 0232, 0016,1600,1700					; 4344		RW,	M,	J/IDIV
D 0233, 0006,1600,1700					; 4345		RW,	DBL B,	J/IDIV
							; 4346	
D 0234, 1005,1601,1100					; 4347	234:	R-PF,	DAC,	J/DIV
D 0235, 0005,1601,3000					; 4348		I-PF,	DAC,	J/DIV
D 0236, 0016,1601,1700					; 4349		RW,	M,	J/DIV
D 0237, 0006,1601,1700					; 4350		RW,	DBL B,	J/DIV
							; 4351		.UCODE
							; 4352	
							; 4353	1600:
U 1600, 3022,3441,0305,0174,4007,0700,0000,0000,0000	; 4354	IDIV:	[BR]_[AR], AC		;COPY MEMORY OPERAND
							; 4355		Q_AC,			;LOAD Q
U 3022, 1232,3772,0000,0275,5007,0520,0000,0000,0000	; 4356		SKIP DP0		;SEE IF MINUS
							; 4357	=0	[AR]_0, 		;EXTEND + SIGN
U 1232, 0161,4221,0003,4174,4007,0700,0000,0000,0000	; 4358		J/DIV1			;NOW SAME AS DIV
							; 4359		[AR]_-1,		;EXTEND - SIGN
U 1233, 0161,2441,0703,4174,4007,0700,4000,0000,0000	; 4360		J/DIV1			;SAME AS DIV
							; 4361	
							; 4362	1601:
U 1601, 3023,3441,0305,4174,4007,0700,0000,0000,0000	; 4363	DIV:	[BR]_[AR]		;COPY MEM OPERAND
U 3023, 3024,3771,0003,0276,6007,0700,0000,0000,0000	; 4364		[AR]_AC 		;GET AC
U 3024, 3025,3772,0000,1275,5007,0701,0000,0000,1441	; 4365		Q_AC[1] 		;AND AC+1
							; 4366		READ [AR],		;TEST FOR NO DIVIDE
U 3025, 0160,3333,0003,4174,4007,0621,0000,0000,0000	; 4367		SKIP AD.EQ.0
							; 4368	=000	.NOT.[AR],		;SEE IF ALL SIGN BITS IN AR
							; 4369		SKIP AD.EQ.0,		; ..
U 0160, 1234,7443,0300,4174,4007,0621,0000,0000,0000	; 4370		J/DIVA			;CONTINUE BELOW
							; 4371	=001
							; 4372	DIV1:	READ [BR],		;SEE IF DIVIDE BY
U 0161, 0164,3333,0005,4174,4007,0621,0000,0000,0000	; 4373		SKIP AD.EQ.0		; ZERO
							; 4374	=100
							; 4375	DIV2:	SC_34., 		;NOT ZERO--LOAD STEP COUNT
U 0164, 0370,4443,0000,4174,4007,0700,2010,0071,0042	; 4376		CALL [DIVSUB]		;DIVIDE
U 0165, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4377	=101	NO DIVIDE		;DIVIDE BY ZERO
							; 4378	=110	[ARX]_[AR],		;COPY REMAINDER
U 0166, 1215,3441,0304,4174,4007,0700,0000,0000,0000	; 4379		J/IMUL1 		;STORE ANSWER
							; 4380	=
							; 4381	
							; 4382	
							; 4383	=0
							; 4384	DIVA:	[BRX]_[AR],		;HIGH WORD IS NOT SIGNS
U 1234, 3026,3441,0306,4174,4007,0700,0000,0000,0000	; 4385		J/DIVB			;GO TEST FOR NO DIVIDE
							; 4386		READ [BR],		;ALL SIGN BITS
							; 4387		SKIP AD.EQ.0,		;SEE IF ZERO DIVIDE
U 1235, 0164,3333,0005,4174,4007,0621,0000,0000,0000	; 4388		J/DIV2			;BACK TO MAIN FLOW
							; 4389	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 119
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIV, IDIV					

U 3026, 3027,3221,0004,4174,4007,0700,0000,0000,0000	; 4390	DIVB:	[ARX]_Q 		;MAKE ABS VALUES
							; 4391		READ [AR],		;SEE IF +
U 3027, 0330,3333,0003,4174,4007,0520,0000,0000,0000	; 4392		SKIP DP0
							; 4393	=00	READ [BR],		;SEE IF +
							; 4394		SKIP DP0,
U 0330, 1236,3333,0005,4174,4007,0520,0000,0000,0000	; 4395		J/DIVC			;CONTINUE BELOW
							; 4396		CLEAR [ARX]0,		;FLUSH DUPLICATE SIGN
U 0331, 3110,4551,0404,4374,0007,0700,0010,0037,7777	; 4397		CALL [DBLNG1]		;NEGATE AR!ARX
							; 4398	=11	READ [BR],		;SEE IF TOO BIG
							; 4399		SKIP DP0,
U 0333, 1236,3333,0005,4174,4007,0520,0000,0000,0000	; 4400		J/DIVC
							; 4401	=
							; 4402	=0
							; 4403	DIVC:	[AR]-[BR],		;COMPUTE DIFFERENCE
							; 4404		SKIP DP0,		;SEE IF IT GOES
							; 4405		3T,			;ALLOW TIME
U 1236, 1240,2113,0305,4174,4007,0521,4000,0000,0000	; 4406		J/NODIV 		;TEST
							; 4407		[AR]+[BR],
							; 4408		SKIP DP0,		;SAME TEST FOR -VE BR
							; 4409		3T,
U 1237, 1240,0113,0305,4174,4007,0521,0000,0000,0000	; 4410		J/NODIV
							; 4411	=0
U 1240, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4412	NODIV:	NO DIVIDE		;TOO BIG
							; 4413		[AR]_[BRX],		;FITS
U 1241, 0161,3441,0603,4174,4007,0700,0000,0000,0000	; 4414		J/DIV1			;GO BACK AND DIVIDE
							; 4415	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 120
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DDIV					

							; 4416	.TOC	"ARITHMETIC -- DDIV"
							; 4417	
							; 4418		.DCODE
D 0117, 0205,1627,1100					; 4419	117:	DBL R,	DAC,	J/DDIV
							; 4420		.UCODE
							; 4421	
							; 4422	.IF/FULL
							; 4423	1627:
U 1627, 3030,4112,0400,4174,4007,0700,0000,0000,0000	; 4424	DDIV:	Q_[ARX].AND.[MAG]	;COPY LOW WORD
							; 4425		[BR]_[AR]*.5,		;COPY MEMORY OPERAND
U 3030, 1242,3447,0305,4174,4007,0421,0000,0000,0000	; 4426		SKIP AD.LE.0		;SEE IF POSITIVE
							; 4427	=0	[BR]_[BR]*.5 LONG,	;POSITIVE
U 1242, 1246,3446,0505,4174,4007,0700,0000,0000,0000	; 4428		J/DDIV1 		;CONTINUE BELOW
							; 4429		[BR]_[BR]*.5 LONG,	;NEGATIVE OR ZERO
U 1243, 1244,3446,0505,4174,4007,0520,0000,0000,0000	; 4430		SKIP DP0		;SEE WHICH?
							; 4431	=0	[MAG].AND.Q,		;SEE IF ALL ZERO
U 1244, 1246,4003,0000,4174,4007,0621,0000,0000,0000	; 4432		SKIP AD.EQ.0, J/DDIV1	;CONTINUE BELOW
U 1245, 3031,4751,1217,4374,4007,0700,0000,0000,0005	; 4433		[T1]_0 XWD [5]		;NEGATE MEM OP
							; 4434		Q_Q.OR.#, #/600000,	;SIGN EXTEND THE LOW
U 3031, 3032,3662,0000,4374,0007,0700,0000,0060,0000	; 4435		HOLD RIGHT		; WORD
U 3032, 3033,2222,0000,4174,4007,0700,4000,0000,0000	; 4436		Q_-Q			;MAKE Q POSITIVE
							; 4437		[BR]_(-[BR]-.25)*.5 LONG, ;NEGATE HIGH WORD
							; 4438		ASHC, MULTI PREC/1,	;USE CARRY FROM LOW WORD
U 3033, 3035,2446,0505,4174,4047,0700,0040,0000,0000	; 4439		J/DDIV3 		;CONTINUE BELOW
							; 4440	=0
							; 4441	DDIV1:	[BR]_[BR]*.5 LONG,	;SHIFT OVER 1 PLACE
U 1246, 3034,3446,0505,4174,4047,0700,0000,0000,0000	; 4442		ASHC, J/DDIV2		;CONTINUE BELOW
U 1247, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4443		NO DIVIDE		;DIVIDE BY ZERO
U 3034, 3035,4751,1217,4374,4007,0700,0000,0000,0004	; 4444	DDIV2:	[T1]_0 XWD [4]		;MEM OPERAND IS POSITIVE
U 3035, 3036,3221,0006,0174,4007,0700,0000,0000,0000	; 4445	DDIV3:	[BRX]_Q, AC		;COPY Q
							; 4446	
U 3036, 0054,3777,0003,0274,4007,0520,0000,0000,0000	; 4447		[AR]_AC*.5, 2T, SKIP DP0 ;GET AC--SEE IF NEGATIVE
							; 4448	=0*1*0
							; 4449	DDIV3A:	Q_AC[1].AND.[MAG],	;POSITIVE (OR ZERO)
U 0054, 1250,4552,0000,1275,5007,0701,0000,0000,1441	; 4450		J/DDIV4 		;CONTINUE BELOW
							; 4451		[T1]_[T1].XOR.#,	;NEGATIVE
U 0055, 3077,6551,1717,4374,4007,0700,0010,0000,0007	; 4452		#/7, CALL [QDNEG]	;UPDATE SAVED FLAGS
							; 4453	=1*1*1	[AR]_[AR]*.5,		;SHIFT AR OVER
U 0075, 0054,3447,0303,4174,4007,0700,0000,0000,0000	; 4454		J/DDIV3A		;GO BACK AND LOAD Q
							; 4455	=
							; 4456	=0
							; 4457	DDIV4:	[AR]_[AR]*.5 LONG,	;SHIFT AR OVER
U 1250, 3061,3446,0303,4174,4007,0700,0010,0000,0000	; 4458		CALL [DDIVS]		;SHIFT 1 MORE PLACE
U 1251, 1252,2113,0305,4174,4007,0521,4000,0000,0000	; 4459		[AR]-[BR], 3T, SKIP DP0 ;TEST MAGNITUDE
							; 4460	=0	[AR]-[BR], 2T,
U 1252, 1254,2113,0305,4174,4007,0620,4000,0000,0000	; 4461		SKIP AD.EQ.0, J/DDIV5
U 1253, 3037,3221,0004,4174,4007,0700,0000,0000,0000	; 4462		[ARX]_Q, J/DDIV5A	;ANSWER FITS
							; 4463	
							; 4464	=0
U 1254, 0033,3333,0017,4174,4003,5701,0000,0000,0000	; 4465	DDIV5:	READ [T1], 3T, DISP/DP, J/NODDIV
U 1255, 1256,1003,0600,4174,4007,0521,4000,0000,0000	; 4466		Q-[BRX], 3T, SKIP DP0
U 1256, 0033,3333,0017,4174,4003,5701,0000,0000,0000	; 4467	=0	READ [T1], 3T, DISP/DP, J/NODDIV
U 1257, 3037,3221,0004,4174,4007,0700,0000,0000,0000	; 4468		[ARX]_Q 		;COPY LOW WORD
							; 4469	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 121
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DDIV					

							; 4470	;HERE WITH EVERYTHING SETUP AND READY TO GO
U 3037, 0354,4552,0000,1275,5007,0701,0000,0000,1442	; 4471	DDIV5A: Q_AC[2].AND.[MAG]
U 0354, 1302,3446,1200,4174,4007,0700,2010,0071,0042	; 4472	=0*	Q_Q*.5, SC_34., CALL [DBLDIV]
U 0356, 3040,3224,0016,4174,4007,0700,0000,0000,0000	; 4473		[T0]_Q*2 LONG
U 3040, 3041,0002,1600,4174,4007,0700,0000,0000,0000	; 4474		Q_Q+[T0]
U 3041, 1260,4003,0000,1174,4007,0700,0400,0000,1440	; 4475		AC[0]_Q.AND.[MAG]	;STORE ANSWER
U 1260, 3061,3442,0400,4174,4007,0700,0010,0000,0000	; 4476	=0	Q_[ARX], CALL [DDIVS]	;SHIFT OUT EXTRA ZERO BIT
U 1261, 3042,3221,0004,4174,4007,0700,0000,0000,0000	; 4477		[ARX]_Q 		; ..
U 3042, 0551,4552,0000,1275,5007,0701,0000,0000,1443	; 4478		Q_AC[3].AND.[MAG]
							; 4479	=0*	[T0]_[AR]*.5 LONG,	;SHIFT Q, PUT AR ON DP
							; 4480		SC_34., 		;LOAD SHIFT COUNT
							; 4481		SKIP DP0,		;LOOK AT AR SIGN
U 0551, 1302,3446,0316,4174,4007,0520,2010,0071,0042	; 4482		CALL [DBLDIV]		;GO DIVIDE
U 0553, 3043,3224,0016,4174,4007,0700,0000,0000,0000	; 4483		[T0]_Q*2 LONG
U 3043, 0056,3333,0017,4174,4003,5701,0000,0000,0000	; 4484		READ [T1], 3T, DISP/DP	;WHAT SIGN IS QUO
							; 4485	=1110	[T0]_[T0]+Q,		;POSITIVE QUO
U 0056, 3046,0001,1616,4174,4007,0700,0000,0000,0000	; 4486		J/DDIV5B		;CONTINUE BELOW
U 0057, 3044,2225,0016,4174,4007,0700,4000,0000,0000	; 4487		[T0]_-Q*2		;NEGATIVE QUO
							; 4488		AD/-D-.25, DBUS/RAM, 3T,
							; 4489		RAMADR/AC#, DEST/Q_AD,
U 3044, 3045,1772,0000,0274,4007,0701,0040,0000,0000	; 4490		MULTI PREC/1
U 3045, 1262,3223,0000,0174,4007,0621,0400,0000,0000	; 4491		AC_Q, SKIP AD.EQ.0
U 1262, 3047,3440,1616,1174,4007,0700,0400,0000,1441	; 4492	=0	AC[1]_[T0], J/DDIV5C
U 1263, 3051,4223,0000,1174,4007,0700,0400,0000,1441	; 4493		AC[1]_0, J/DDIV6
							; 4494	
U 3046, 3051,4113,1600,1174,4007,0700,0400,0000,1441	; 4495	DDIV5B: AC[1]_[T0].AND.[MAG], J/DDIV6	;STORE LOW WORD IN + CASE
							; 4496	
U 3047, 3050,3551,1616,4374,0007,0700,0000,0040,0000	; 4497	DDIV5C: [T0]_[T0].OR.#, #/400000, HOLD RIGHT
U 3050, 3051,3440,1616,1174,4007,0700,0400,0000,1441	; 4498		AC[1]_[T0]
							; 4499	
U 3051, 1264,3333,0003,4174,4007,0520,0000,0000,0000	; 4500	DDIV6:	READ [AR], SKIP DP0	;LOOK AT AR SIGN
							; 4501	=0
U 1264, 3055,3442,0400,4174,4007,0700,0000,0000,0000	; 4502	DDIV7:	Q_[ARX], J/DDIV8
U 1265, 3052,0112,0406,4174,4007,0700,0000,0000,0000	; 4503		Q_[ARX]+[BRX]
							; 4504		[AR]_[AR]+[BR],
U 3052, 3053,0111,0503,4174,4007,0700,0040,0000,0000	; 4505		MULTI PREC/1
U 3053, 3054,0002,0600,4174,4007,0700,0000,0000,0000	; 4506		Q_Q+[BRX]
							; 4507		[AR]_[AR]+[BR],
U 3054, 3055,0111,0503,4174,4007,0700,0040,0000,0000	; 4508		MULTI PREC/1
U 3055, 0355,3333,0017,4174,4003,5701,0000,0000,0000	; 4509	DDIV8:	READ [T1], 3T, DISP/DP
							; 4510	=1101
							; 4511	DDIV8A: [AR]_[AR]*2 LONG, ASHC, ;POSITIVE REMAINDER
U 0355, 3057,3444,0303,4174,4047,0700,0000,0000,0000	; 4512		J/DDIV9 		;CONTINUE BELOW
U 0357, 3056,2222,0000,4174,4007,0700,4000,0000,0000	; 4513		Q_-Q			;NEGATE REMAINDER IN AR!Q
							; 4514		[AR]_(-[AR]-.25)*2 LONG,
U 3056, 3057,2444,0303,4174,4047,0700,0040,0000,0000	; 4515		MULTI PREC/1, ASHC
							; 4516	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 122
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DDIV					

							; 4517	DDIV9:	AC[2]_[AR]+[AR], 3T,
U 3057, 1266,0113,0303,1174,4007,0521,0400,0000,1442	; 4518		SKIP DP0
							; 4519	=0	AC[3]_Q.AND.[MAG],
U 1266, 0100,4003,0000,1174,4156,4700,0400,0000,1443	; 4520		NEXT INST
U 1267, 3060,4002,0000,1174,4007,0700,0000,0000,1443	; 4521		Q_Q.AND.[MAG], AC[3]
							; 4522		AC[3]_[MAG].EQV.Q,
U 3060, 0100,7003,0000,1174,4156,4700,0400,0000,1443	; 4523		NEXT INST
							; 4524	
							; 4525	
							; 4526	;HERE IF WE WANT TO SET NO DIVIDE
							; 4527	=11011
U 0033, 3077,4443,0000,4174,4007,0700,0010,0000,0000	; 4528	NODDIV: CALL [QDNEG]		;FIXUP AC TO AC+3
U 0037, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 4529		NO DIVIDE		;ABORT DIVIDE
							; 4530	
U 3061, 0001,3446,0303,4174,4044,1700,0000,0000,0000	; 4531	DDIVS:	[AR]_[AR]*.5 LONG, ASHC, RETURN [1]
							;;4532	.IFNOT/FULL
							;;4533	1627:
							;;4534	DDIV:	UUO
							; 4535	.ENDIF/FULL
							; 4536	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 123
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIVIDE SUBROUTINE				

							; 4537	.TOC	"ARITHMETIC -- DIVIDE SUBROUTINE"
							; 4538	
							; 4539	;HERE IS THE SUBROUTINE TO DO DIVIDE
							; 4540	;ENTER WITH:
							; 4541	;	AR!Q = D'END
							; 4542	;	BR = D'SOR
							; 4543	;RETURN 2 WITH:
							; 4544	;	AR = REMAINDER
							; 4545	;	Q = QUOTIENT
							; 4546	;CALLER MUST CHECK FOR ZERO DIVIDE PRIOR TO CALL
							; 4547	;
							; 4548	=1000
							; 4549	DIVSUB:	Q_Q.AND.#,		;CLEAR SIGN BIT IN
							; 4550		#/377777,		;MASK
							; 4551		HOLD RIGHT,		;JUST CLEAR BIT 0
U 0370, 3062,4662,0000,4374,0007,0700,0010,0037,7777	; 4552		CALL [DIVSGN]		;DO REAL DIVIDE
U 0374, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 4553	=1100	RETURN [2]		;ALL POSITIVE
U 0375, 0002,2222,0000,4174,4004,1700,4000,0000,0000	; 4554	=1101	Q_-Q, RETURN [2]	;-QUO +REM
U 0376, 0377,2222,0000,4174,4007,0700,4000,0000,0000	; 4555	=1110	Q_-Q			;ALL NEGATIVE
U 0377, 0002,2441,0303,4174,4004,1700,4000,0000,0000	; 4556	=1111	[AR]_-[AR], RETURN [2]	;NEGATIVE REMAINDER
							; 4557	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 124
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DIVIDE SUBROUTINE				

							; 4558	;HERE IS THE INNER DIVIDE SUBROUTINE
							; 4559	;SAME SETUP AS DIVSUB
							; 4560	;RETURNS WITH AR AND Q POSITIVE AND
							; 4561	;	14 IF ALL POSITIVE
							; 4562	;	15 IF -QUO
							; 4563	;	16 IF ALL NEGATIVE
							; 4564	;	17 IF NEGATIVE REMAINDER
							; 4565	
							; 4566	BASIC DIV STEP	"DEST/Q_Q*2, DIV, A/BR, B/AR, STEP SC"
							; 4567	DIV STEP	"BASIC DIV STEP, AD/A+B, DIVIDE/1"
							; 4568	FIRST DIV STEP	"BASIC DIV STEP, AD/B-A-.25, ADD .25"
							; 4569	
U 3062, 1270,3333,0003,4174,4007,0520,0000,0000,0000	; 4570	DIVSGN:	READ [AR], SKIP DP0
U 1270, 3064,4221,0004,4174,4007,0700,0000,0000,0000	; 4571	=0	[ARX]_0, J/DVSUB2	;REMAINDER IS POSITIVE
U 1271, 1272,2222,0000,4174,4007,0621,4000,0000,0000	; 4572		Q_-Q, SKIP AD.EQ.0	;COMPLEMENT LOW WORD
U 1272, 3063,7441,0303,4174,4007,0700,0000,0000,0000	; 4573	=0	[AR]_.NOT.[AR], J/DVSUB1 ;COMPLEMENT HI WORD
U 1273, 3063,2441,0303,4174,4007,0700,4000,0000,0000	; 4574		[AR]_-[AR]		;TWO'S COMPLEMENT HI WORD SINCE
							; 4575					; LOW WORD WAS ZERO
U 3063, 3064,3771,0004,4374,4007,0700,0000,0010,0000	; 4576	DVSUB1: [ARX]_#, #/100000	;REMAINDER IS NEGATIVE
U 3064, 1274,3333,0005,4174,4007,0520,0000,0000,0000	; 4577	DVSUB2: READ [BR], SKIP DP0	;IS THE DIVISOR NEGATIVE
							; 4578	=0
							; 4579	DVSUB3: [AR]_[AR]*.5 LONG,	;START TO PUT IN 9-CHIPS
U 1274, 3066,3446,0303,4174,4007,0700,0000,0000,0000	; 4580		J/DIVSET		;JOIN MAIN STREAM
U 1275, 3065,2441,0505,4174,4007,0700,4000,0000,0000	; 4581		[BR]_-[BR]		;COMPLEMENT DIVISOR
							; 4582		[ARX]_[ARX].OR.#, 	;ADJUST SIGN OF QUOTIENT
U 3065, 1274,3551,0404,4374,4007,0700,0000,0004,0000	; 4583		#/40000, J/DVSUB3	;USE 9 CHIPS
U 3066, 3067,3447,0303,4174,4007,0700,0000,0000,0000	; 4584	DIVSET: [AR]_[AR]*.5
U 3067, 3070,3447,0505,4174,4007,0700,0000,0000,0000	; 4585		[BR]_[BR]*.5
U 3070, 3071,3447,0505,4174,4007,0700,0000,0000,0000	; 4586		[BR]_[BR]*.5
U 3071, 1276,1114,0503,4174,4067,0630,6000,0060,0000	; 4587		FIRST DIV STEP
							; 4588	;HERE IS THE MAIN DIVIDE LOOP
							; 4589	=0
U 1276, 1276,0114,0503,4174,4067,0630,2100,0060,0000	; 4590	DIVIDE: DIV STEP, J/DIVIDE
U 1277, 3072,3444,1717,4174,4067,0700,0100,0000,0000	; 4591		[T1]_[T1]*2 LONG, DIVIDE/1, DIV
U 3072, 1300,3447,0303,4174,4007,0520,0000,0000,0000	; 4592		[AR]_[AR]*.5, SKIP DP0
							; 4593	=0
U 1300, 3073,3444,0303,4174,4007,0700,0000,0000,0000	; 4594	FIX++:	[AR]_[AR]*2 LONG, J/FIX1++
U 1301, 1300,0111,0503,4174,4007,0700,0000,0000,0000	; 4595		[AR]_[AR]+[BR], J/FIX++
U 3073, 3074,3444,0303,4174,4007,0700,0000,0000,0000	; 4596	FIX1++: [AR]_[AR]*2 LONG
U 3074, 3075,4002,1200,4174,4007,0700,0000,0000,0000	; 4597		Q_[MASK].AND.Q
							; 4598		READ [ARX], 3T,		;RETURN TO 1 OF 4 PLACES
							; 4599		DISP/1,			;BASED ON SIGN OF RESULT
U 3075, 0014,3333,0004,4174,4000,1701,0000,0000,0000	; 4600		J/14			;RETURN
							; 4601	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 125
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- DOUBLE DIVIDE SUBROUTINE			

							; 4602	.TOC	"ARITHMETIC -- DOUBLE DIVIDE SUBROUTINE"
							; 4603	.IF/FULL
							; 4604	;CALL WITH:
							; 4605	;	AR!ARX!Q = 3 WORD DV'END
							; 4606	;	BR!BRX	 = 2 WORD DV'SOR
							; 4607	;RETURN 2 WITH:
							; 4608	;	AR!ARX	 = 2 WORD REMAINDER
							; 4609	;			CORRECT IF POSITIVE (Q IS ODD)
							; 4610	;			WRONG (BY BR!BRX) IF NEGATIVE (Q IS EVEN)
							; 4611	;	Q	 = 1 WORD QUOTIENT
							; 4612	;CALLER MUST CHECK FOR ZERO DIVIDE PRIOR TO CALL
							; 4613	;
							; 4614	;NOTE: THIS SUBROUTINE ONLY WORKS FOR POSITIVE NUMBERS
							; 4615	;
							; 4616	=0
							; 4617	;HERE FOR NORMAL STARTUP
							; 4618	DBLDIV: [ARX]_([ARX]-[BRX])*2 LONG, ;SUBTRACT LOW WORD
U 1302, 3076,1114,0604,4174,4057,0700,4000,0000,0000	; 4619		LSHC, J/DIVHI		;GO ENTER LOOP
							; 4620	;SKIP ENTRY POINT IF FINAL STEP IN PREVIOUS ENTRY WAS IN ERROR
							; 4621		[ARX]_([ARX]+[BRX])*2 LONG, ;CORRECTION STEP
U 1303, 3076,0114,0604,4174,4057,0700,0000,0000,0000	; 4622		LSHC, J/DIVHI		;GO ENTER LOOP
							; 4623	
							; 4624	;HERE IS DOUBLE DIVIDE LOOP
							; 4625	DIVHI:	AD/A+B, 		;ADD (HARDWARE MAY OVERRIDE)
							; 4626		A/BR, B/AR,		;OPERANDS ARE AR AND BR
							; 4627		DEST/AD*2,		;SHIFT LEFT
							; 4628		SHSTYLE/NORM,		;SET SHIFT PATHS (SEE DPE1)
							; 4629		MULTI PREC/1,		;INJECT SAVED BITS
U 3076, 1304,0115,0503,4174,4007,0630,2040,0060,0000	; 4630		STEP SC 		;COUNT DOWN LOOP
							; 4631	=0	AD/A+B, 		;ADD (HARDWARE MAY OVERRIDE)
							; 4632		A/BRX, B/ARX,		;LOW WORDS
							; 4633		DEST/Q_Q*2,		;SHIFT WHOLE MESS LEFT
							; 4634		SHSTYLE/DIV,		;SET SHIFT PATHS (SEE DPE1)
							; 4635		DIVIDE/1,		;SAVE BITS
U 1304, 3076,0114,0604,4174,4067,0700,0100,0000,0000	; 4636		J/DIVHI 		;KEEP LOOPING
							; 4637	;HERE WHEN ALL DONE
							; 4638		DEST/Q_Q*2, DIV,	;SHIFT IN LAST Q BIT
							; 4639		DIVIDE/1,		;GENERATE BIT
U 1305, 0002,4444,0002,4174,4064,1700,0100,0000,0000	; 4640		B/HR, RETURN [2]	;ZERO HR AND RETURN
							; 4641	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 126
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- SUBROUTINES FOR ARITHMETIC		

							; 4642	.TOC	"ARITHMETIC -- SUBROUTINES FOR ARITHMETIC"
							; 4643	
							; 4644	;QUAD WORD NEGATE
							; 4645	;ARGUMENT IN AC!AC1!AC2!AC3
							; 4646	;LEAVES COPY OF AC!AC1 IN AR!Q
							; 4647	;RETURNS TO CALL!24
U 3077, 3100,1772,0000,1274,4007,0701,4000,0000,1443	; 4648	QDNEG:	Q_-AC[3]
							; 4649		AC[3]_Q.AND.[MAG],	;PUT BACK LOW WORD
U 3100, 1306,4003,0000,1174,4007,0621,0400,0000,1443	; 4650		SKIP AD.EQ.0		;SEE IF ANY CARRY
							; 4651	=0
U 1306, 3103,7772,0000,1274,4007,0701,0000,0000,1442	; 4652	COM2A:	Q_.NOT.AC[2], J/COM2	;CARRY--DO 1'S COMPLEMENT
U 1307, 3101,1772,0000,1274,4007,0701,4000,0000,1442	; 4653		Q_-AC[2]		;NEXT WORD
							; 4654		AC[2]_Q.AND.[MAG],	;PUT BACK WORD
U 3101, 1310,4003,0000,1174,4007,0621,0400,0000,1442	; 4655		SKIP AD.EQ.0
							; 4656	=0
U 1310, 3104,7772,0000,1274,4007,0701,0000,0000,1441	; 4657	COM1A:	Q_.NOT.AC[1], J/COM1
U 1311, 3102,1772,0000,1274,4007,0701,4000,0000,1441	; 4658		Q_-AC[1]
							; 4659		AC[1]_Q.AND.[MAG],
U 3102, 1312,4003,0000,1174,4007,0621,0400,0000,1441	; 4660		SKIP AD.EQ.0
							; 4661	=0
U 1312, 3105,7771,0003,0274,4007,0700,0000,0000,0000	; 4662	COM0A:	[AR]_.NOT.AC, J/COM0
U 1313, 3105,1771,0003,0274,4007,0701,4000,0000,0000	; 4663		[AR]_-AC, 3T, J/COM0
							; 4664	
U 3103, 1310,4003,0000,1174,4007,0700,0400,0000,1442	; 4665	COM2:	AC[2]_Q.AND.[MAG], J/COM1A
U 3104, 1312,4003,0000,1174,4007,0700,0400,0000,1441	; 4666	COM1:	AC[1]_Q.AND.[MAG], J/COM0A
U 3105, 0024,3440,0303,0174,4004,1700,0400,0000,0000	; 4667	COM0:	AC_[AR], RETURN [24]
							; 4668	.ENDIF/FULL
							; 4669	
							; 4670	;DOUBLE WORD NEGATE
							; 4671	;ARGUMENT IN AR AND ARX
							; 4672	;RETURNS TO CALL!2
							; 4673	
U 3106, 3107,4551,0404,4374,0007,0700,0000,0037,7777	; 4674	DBLNEG: CLEAR ARX0		;FLUSH DUPLICATE SIGN
							; 4675	DBLNGA: [ARX]_-[ARX],		;FLIP LOW WORD
U 3107, 1314,2441,0404,4174,4007,0621,4000,0000,0000	; 4676		SKIP AD.EQ.0		;SEE IF CARRY
							; 4677	=0	[AR]_.NOT.[AR], 	;NO CARRY-- 1 COMP
U 1314, 2240,7441,0303,4174,4467,0700,0000,0001,0001	; 4678		AD FLAGS, J/CLARX0	;CLEAR LOW SIGN
							; 4679		[AR]_-[AR],		;CARRY
U 1315, 2240,2441,0303,4174,4467,0701,4000,0001,0001	; 4680		AD FLAGS, 3T, J/CLARX0
							; 4681	
							; 4682	;SAME THING BUT DOES NOT SET PC FLAGS
U 3110, 1316,2441,0404,4174,4007,0621,4000,0000,0000	; 4683	DBLNG1: [ARX]_-[ARX], SKIP AD.EQ.0
U 1316, 2240,7441,0303,4174,4007,0700,0000,0000,0000	; 4684	=0	[AR]_.NOT.[AR], J/CLARX0
U 1317, 2240,2441,0303,4174,4007,0700,4000,0000,0000	; 4685		[AR]_-[AR], J/CLARX0
							; 4686	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 127
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			ARITHMETIC -- SUBROUTINES FOR ARITHMETIC		

							; 4687		.NOBIN
							; 4688	.TOC	"BYTE GROUP -- IBP, ILDB, LDB, IDPB, DPB"
							; 4689	
							; 4690	
							; 4691	;ALL FIVE INSTRUCTIONS OF THIS GROUP ARE CALLED WITH THE BYTE POINTER
							; 4692	;IN THE AR.  ALL INSTRUCTIONS SHARE COMMON SUBROUTINES.
							; 4693	
							; 4694	;IBP OR ADJBP
							; 4695	;IBP IF AC#0, ADJBP OTHERWISE
							; 4696	; HERE WITH THE BASE POINTER IN AR
							; 4697	
							; 4698	;HERE IS A MACRO TO DO IBP. WHAT HAPPENS IS:
							; 4699	;	THE AR IS PUT ON THE DP.
							; 4700	;	THE BR IS LOADED FROM THE DP WITH BITS 0-5 FROM SCAD
							; 4701	;	THE SCAD COMPUTES P-S
							; 4702	;	IBPS IS CALLED WITH A 4-WAY DISPATCH ON SCAD0 AND FIRST-PART-DONE
							; 4703	;THE MACRO IS WRITTEN WITH SEVERAL SUB-MACROS BECAUSE OF RESTRICTIONS
							; 4704	; IN THE MICRO ASSEMBLER
							; 4705	
							; 4706	IBP DP		"AD/D, DEST/A, A/AR, B/BR, DBUS/DBM, DBM/DP, BYTE/BYTE1"
							; 4707	IBP SCAD	"SCAD/A-B, SCADA/BYTE1, SCADB/SIZE"
							; 4708	IBP SPEC	"SCAD DISP, SKIP FPD"
							; 4709	CALL IBP	"IBP DP, IBP SCAD, IBP SPEC, CALL [IBPS], DT/3T"
							; 4710	
							; 4711	SET P TO 36-S	"AD/D,DEST/A,A/BR,B/AR,DBUS/DBM,DBM/DP,SCAD/A-B,SCADB/SIZE,BYTE/BYTE1,SCADA/PTR44"
							; 4712	
							; 4713	;THE FOLLOWING MACRO IS USED FOR COUNTING SHIFTS IN THE BYTE ROUTINES. IT
							; 4714	; USES THE FE AND COUNTS BY 8. NOTE: BYTE STEP IS A 2S WEIGHT SKIP NOT 1S.
							; 4715	BYTE STEP	"SCAD/A+B,SCADA/S#,S#/1770,SCADB/FE,LOAD FE, 3T,SCAD DISP"
							; 4716	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 128
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- IBP, ILDB, LDB, IDPB, DPB			

							; 4717		.BIN
							; 4718	
							; 4719		.DCODE
D 0133, 0015,1610,1100					; 4720	133:	R,	AC,	J/IBP		;OR ADJBP
D 0134, 0000,1620,1500					; 4721	134:	R,W TEST,	J/ILDB		;CAN'T USE RPW BECAUSE OF FPD
D 0135, 0000,1624,1100					; 4722		R,		J/LDB
D 0136, 0000,1630,1500					; 4723		R,W TEST,	J/IDPB
D 0137, 0000,1634,1100					; 4724		R,		J/DPB
							; 4725		.UCODE
							; 4726	1610:
U 1610, 0240,4443,0000,4174,4007,0360,0000,0000,0000	; 4727	IBP:	SKIP IF AC0		;SEE IF ADJBP
							; 4728	=000	WORK[ADJPTR]_[AR],	;SAVE POINTER
U 0240, 3146,3333,0003,7174,4007,0700,0400,0000,0223	; 4729		J/ADJBP 		;GO ADJUST BYTE POINTER
U 0241, 0350,3770,0305,4334,4016,7351,0010,0033,6000	; 4730	=001	CALL IBP		;BUMP BYTE POINTER
U 0245, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 4731	=101	DONE			;POINTER STORED
							; 4732	=
							; 4733	
							; 4734	1620:
U 1620, 0350,3770,0305,4334,4016,7351,0010,0033,6000	; 4735	ILDB:	CALL IBP		;BUMP BYTE POINTER
							; 4736	1624:
							; 4737	LDB:	READ [AR],		;LOOK AT POINTER
							; 4738		LOAD BYTE EA, FE_P, 3T, ;GET STUFF OUT OF POINTER
U 1624, 3116,3333,0003,4174,4217,0701,1010,0073,0500	; 4739		CALL [BYTEA]		;COMPUTE EFFECTIVE ADDRESS
U 1625, 0660,3443,0100,4174,4007,0700,0200,0014,0012	; 4740	1625:	VMA_[PC], FETCH 	;START FETCH OF NEXT INST
							; 4741	=0*	READ [AR],		;LOOK AT POINTER
							; 4742		FE_FE.AND.S#, S#/0770,	;MASK OUT JUNK IN FE
							; 4743		BYTE DISP,		;DISPATCH ON BYTE SIZE
U 0660, 0340,3333,0003,4174,4006,5701,1010,0051,0770	; 4744		CALL [LDB1]		;GET BYTE
							; 4745		AC_[AR], CLR FPD,	;STORE AC
U 0662, 0555,3440,0303,0174,4467,0700,0400,0005,0000	; 4746		J/NIDISP		;GO DO NEXT INST
							; 4747	
							; 4748	1630:
U 1630, 0350,3770,0305,4334,4016,7351,0010,0033,6000	; 4749	IDPB:	CALL IBP		;BUMP BYTE POINTER
							; 4750	1634:
U 1634, 3111,3775,0004,0274,4007,0701,0000,0000,0000	; 4751	DPB:	[ARX]_AC*2		;PUT 7 BIT BYTE IN 28-34
							; 4752		AD/A, A/ARX, SCAD/A,	;PUT THE BYTE INTO
							; 4753		SCADA/BYTE5, 3T,	; INTO THE FE REGISTER
U 3111, 3112,3443,0400,4174,4007,0701,1000,0077,0000	; 4754		LOAD FE 		; FE REGISTER
U 3112, 0264,3771,0004,0276,6007,0700,0000,0000,0000	; 4755		[ARX]_AC		;PUT BYTE IN ARX
							; 4756	=100	READ [AR],		;LOOK AT BYTE POINTER
							; 4757		LOAD BYTE EA,		;LOAD UP EFFECTIVE ADDRESS
U 0264, 3116,3333,0003,4174,4217,0700,0010,0000,0500	; 4758		CALL [BYTEA]		;COMPUTE EFFECTIVE ADDRESS
							; 4759		READ [AR],		;LOOK AT POINTER AGAIN
							; 4760		BYTE DISP,		;DISPATCH ON SIZE
U 0265, 0360,3333,0003,4174,4006,5701,0010,0000,0000	; 4761		CALL [DPB1]		;GO STORE BYTE
U 0267, 1400,4443,0000,4174,4467,0700,0000,0005,0000	; 4762	=111	CLR FPD, J/DONE 	;ALL DONE
							; 4763	=
							; 4764	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 129
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- INCREMENT BYTE POINTER SUBROUTINE		

							; 4765	.TOC	"BYTE GROUP -- INCREMENT BYTE POINTER SUBROUTINE"
							; 4766	
							; 4767	=00
U 0350, 3114,3441,0503,4174,4007,0700,0200,0003,0002	; 4768	IBPS:	[AR]_[BR], START WRITE, J/IBPX	;NO OVERFLOW, BR HAS ANSWER
U 0351, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 4769		RETURN [4]			;FIRST PART DONE SET
U 0352, 3113,3770,0503,4334,4017,0700,0000,0032,6000	; 4770		SET P TO 36-S, J/NXTWRD 	;WORD OVERFLOW
U 0353, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 4771		RETURN [4]			;FPD WAS SET IGNORE OVERFLOW
							; 4772						; AND RETURN
							; 4773	
U 3113, 3114,0111,0703,4170,4007,0700,0200,0003,0002	; 4774	NXTWRD: [AR]_[AR]+1, HOLD LEFT, START WRITE	;BUMP Y AND RETURN
U 3114, 0004,3333,0003,4175,5004,1701,0200,0000,0002	; 4775	IBPX:	MEM WRITE, MEM_[AR], RETURN [4]
							; 4776	
							; 4777	
							; 4778	.TOC	"BYTE GROUP -- BYTE EFFECTIVE ADDRESS EVALUATOR"
							; 4779	
							; 4780	;ENTER WITH POINTER IN AR
							; 4781	;RETURN1 WITH (EA) IN VMA AND WORD IN BR
							; 4782	BYTEAS: EA MODE DISP,		;HERE TO AVOID FPD
U 3115, 0070,4443,0000,2174,4006,6700,0000,0000,0000	; 4783		J/BYTEA0		;GO COMPUTE EA
							; 4784	BYTEA:	SET FPD,		;SET FIRST-PART-DONE
U 3116, 0070,4443,0000,2174,4466,6700,0000,0003,0000	; 4785		EA MODE DISP		;DISPATCH
							; 4786	=100*
							; 4787	BYTEA0: VMA_[AR]+XR,		;INDEXING
							; 4788		START READ,		;FETCH DATA WORD
							; 4789		PXCT BYTE DATA, 	;FOR PXCT
U 0070, 3120,0553,0300,2274,4007,0700,0200,0004,0712	; 4790		J/BYTFET		;GO WAIT
							; 4791		VMA_[AR],		;PLAIN
							; 4792		START READ,		;START CYCLE
							; 4793		PXCT BYTE DATA, 	;FOR PXCT
U 0072, 3120,3443,0300,4174,4007,0700,0200,0004,0712	; 4794		J/BYTFET		;GO WAIT
							; 4795		VMA_[AR]+XR,		;BOTH
							; 4796		START READ,		;START CYCLE
							; 4797		PXCT BYTE PTR EA,	;FOR PXCT
U 0074, 3117,0553,0300,2274,4007,0700,0200,0004,0512	; 4798		J/BYTIND		;GO DO INDIRECT
							; 4799		VMA_[AR],		;JUST @
							; 4800		START READ,		;START READ
U 0076, 3117,3443,0300,4174,4007,0700,0200,0004,0512	; 4801		PXCT BYTE PTR EA	;FOR PXCT
							; 4802	BYTIND: MEM READ,		;WAIT FOR @ WORD
							; 4803		[AR]_MEM,		;PUT IN AR
							; 4804		HOLD LEFT,		;JUST IN RH (SAVE P & S)
							; 4805		LOAD BYTE EA,		;LOOP BACK
U 3117, 3115,3771,0003,4361,5217,0700,0200,0000,0502	; 4806		J/BYTEAS		; ..
							; 4807	
							; 4808	BYTFET: MEM READ,		;WAIT FOR BYTE DATA
							; 4809		[BR]_MEM.AND.MASK,	; WORD. UNSIGNED
U 3120, 0001,4551,1205,4365,5004,1700,0200,0000,0002	; 4810		RETURN [1]		;RETURN TO CALLER
							; 4811	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 130
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- LOAD BYTE SUBROUTINE			

							; 4812	.TOC	"BYTE GROUP -- LOAD BYTE SUBROUTINE"
							; 4813	
							; 4814	;CALL WITH:
							; 4815	;	WORD IN BR
							; 4816	;	POINTER IN AR
							; 4817	;	P IN FE
							; 4818	;	BYTE DISPATCH
							; 4819	;RETURN2 WITH BYTE IN AR
							; 4820	LDB SCAD	"SCAD/A,BYTE/BYTE5"
							; 4821	7-BIT LDB	"AD/D,DBUS/DBM,DBM/DP,DEST/A,A/BR,B/BR, LDB SCAD"
							; 4822	
							; 4823	=000
							; 4824	LDB1:	GEN 17-FE, 3T,		;GO SEE IF ALL THE BITS
							; 4825		SCAD DISP,		; ARE IN THE LEFT HALF
U 0340, 0550,4443,0000,4174,4006,7701,0000,0031,0210	; 4826		J/LDBSWP		;GO TO LDBSWP & SKIP IF LH
							; 4827	
							; 4828	;HERE ARE THE 7-BIT BYTES
U 0341, 3121,3770,0505,4334,4057,0700,0000,0073,0000	; 4829	=001	7-BIT LDB, SCADA/BYTE1, J/LDB7
U 0342, 3121,3770,0505,4334,4057,0700,0000,0074,0000	; 4830	=010	7-BIT LDB, SCADA/BYTE2, J/LDB7
U 0344, 3121,3770,0505,4334,4057,0700,0000,0075,0000	; 4831	=100	7-BIT LDB, SCADA/BYTE3, J/LDB7
U 0345, 3121,3770,0505,4334,4057,0700,0000,0076,0000	; 4832	=101	7-BIT LDB, SCADA/BYTE4, J/LDB7
U 0347, 3121,3770,0505,4334,4057,0700,0000,0077,0000	; 4833	=111	7-BIT LDB, SCADA/BYTE5, J/LDB7
							; 4834	=
							; 4835	
							; 4836	;FOR 7-BIT BYTES WE HAVE BYTE IN BR 28-35 AND JUNK IN REST OF BR.
							; 4837	; WE JUST MASK THE SELECTED BYTE AND SHIFT ONE PLACE RIGHT.
							; 4838	LDB7:	AD/ZERO,RSRC/DA,	;LH_ZERO, RH_D.AND.A
							; 4839		DBUS/DBM,DBM/#,#/376,	;D INPUT IS 376
							; 4840		A/BR,			;A IS BR
							; 4841		B/AR,			;PUT RESULT IN AR
							; 4842		DEST/AD*.5, 3T, 	;SHIFT RESULT 1 PLACE
U 3121, 0002,4257,0503,4374,4004,1701,0000,0000,0376	; 4843		RETURN [2]		;RETURN TO CALLER
							; 4844	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 131
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- LOAD BYTE SUBROUTINE			

							; 4845	;HERE FOR NORMAL BYTES
							; 4846	=00
							; 4847	LDBSWP: FE_-FE, 		;MAKE P NEGATIVE
U 0550, 3123,4443,0000,4174,4007,0700,1000,0031,0000	; 4848		J/LDBSH 		;JOIN MAIN LDB LOOP
U 0552, 3122,3770,0505,4344,4007,0700,0000,0000,0000	; 4849	=10	[BR]_[BR] SWAP		;SHIFT 18 STEPS
							; 4850	=
							; 4851		[BR]_0, HOLD RIGHT,	;PUT ZERO IN LH
U 3122, 3123,4221,0005,4174,0007,0700,1000,0031,0220	; 4852		FE_-FE+S#, S#/220	;UPDATE FE
							; 4853	LDBSH:	[BR]_[BR]*.5,		;SHIFT RIGHT
							; 4854		FE_FE+10,		;UPDATE THE FE
U 3123, 3124,3447,0505,4174,4007,0700,1020,0041,0010	; 4855		MULTI SHIFT/1		;FAST SHIFT
U 3124, 3125,3333,0003,4174,4007,0700,1000,0031,7770	; 4856		READ [AR], FE_-S-10	;GET SIZE
U 3125, 3126,4222,0000,4174,4007,0700,0000,0000,0000	; 4857		Q_0			;CLEAR Q
							; 4858		GEN MSK [AR],		;PUT MASK IN Q (WIPEOUT AR)
							; 4859		FE_FE+10,		;COUNT UP ALL STEPS
U 3126, 3127,4224,0003,4174,4027,0700,1020,0041,0010	; 4860		MULTI SHIFT/1		;FAST SHIFT
U 3127, 3130,4224,0003,4174,4027,0700,0000,0000,0000	; 4861		GEN MSK [AR]		;ONE MORE BIT
U 3130, 0002,4001,0503,4174,4004,1700,0000,0000,0000	; 4862		[AR]_[BR].AND.Q, RETURN [2]
							; 4863	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 132
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- LOAD BYTE SUBROUTINE			

							; 4864		.NOBIN
							; 4865	.TOC	"BYTE GROUP -- DEPOSIT BYTE IN MEMORY"
							; 4866	
							; 4867	;FLOW FOR DPB (NOT 7-BIT BYTE)
							; 4868	;
							; 4869	;FIRST SET ARX TO -1 AND Q TO ZERO AND ROTATE LEFT
							; 4870	; S PLACES GIVING:
							; 4871	
							; 4872	;		ARX		  Q
							; 4873	;	+------------------!------------------+
							; 4874	;	!111111111111000000!000000000000111111!
							; 4875	;	+------------------!------------------+
							; 4876	;					!<--->!
							; 4877	;					S BITS
							; 4878	;
							; 4879	
							; 4880	;NOW THE AC IS LOAD INTO THE ARX AND BOTH THE ARX AND Q
							; 4881	; ARE SHIFTED LEFT P BITS GIVING:
							; 4882	
							; 4883	;	+------------------!------------------+
							; 4884	;	!??????BBBBBB000000!000000111111000000!
							; 4885	;	+------------------!------------------+
							; 4886	;	 <----><---->		  <----><---->
							; 4887	;	  JUNK	BYTE		   MASK P BITS
							; 4888	;
							; 4889	
							; 4890	;AT THIS POINT WE ARE ALMOST DONE. WE NEED TO AND
							; 4891	; THE BR WITH .NOT. Q TO ZERO THE BITS FOR THE BYTE
							; 4892	; AND AND ARX WITH Q TO MASK OUT THE JUNK THIS GIVES:
							; 4893	;
							; 4894	;		ARX
							; 4895	;	+------------------+
							; 4896	;	!000000BBBBBB000000!
							; 4897	;	+------------------!
							; 4898	;
							; 4899	;		AR
							; 4900	;	+------------------+
							; 4901	;	!DDDDDD000000DDDDDD!
							; 4902	;	+------------------+
							; 4903	;
							; 4904	;WE NOW OR THE AR WITH ARX TO GENERATE THE ANSWER.
							; 4905	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 133
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- DEPOSIT BYTE IN MEMORY			

							; 4906		.BIN
							; 4907	
							; 4908	;DEPOSIT BYTE SUBROUTINE
							; 4909	;CALL WITH:
							; 4910	;	BYTE POINTER IN AR
							; 4911	;	BYTE TO STORE IN ARX
							; 4912	;	WORD TO MERGE WITH IN BR
							; 4913	;	(E) OF BYTE POINTER IN VMA
							; 4914	;	7-BIT BYTE IN FE
							; 4915	;	BYTE DISPATCH
							; 4916	;RETURN2 WITH BYTE IN MEMORY
							; 4917	;
							; 4918	DPB SCAD	"SCAD/A+B,SCADA/S#,SCADB/FE,S#/0"
							; 4919	7-BIT DPB	"AD/D,DEST/A,A/BR,DBUS/DBM,DBM/DP,B/AR, DPB SCAD"
							; 4920	
							; 4921	=000
U 0360, 3133,3333,0003,4174,4007,0700,1000,0031,7770	; 4922	DPB1:	READ [AR], FE_-S-10, J/DPBSLO	;NOT SPECIAL
U 0361, 3131,3770,0503,4334,4017,0700,0000,0041,0000	; 4923	=001	7-BIT DPB, BYTE/BYTE1, J/DPB7
U 0362, 3131,3770,0503,4334,4027,0700,0000,0041,0000	; 4924	=010	7-BIT DPB, BYTE/BYTE2, J/DPB7
U 0364, 3131,3770,0503,4334,4037,0700,0000,0041,0000	; 4925	=100	7-BIT DPB, BYTE/BYTE3, J/DPB7
U 0365, 3131,3770,0503,4334,4047,0700,0000,0041,0000	; 4926	=101	7-BIT DPB, BYTE/BYTE4, J/DPB7
U 0367, 3131,3770,0503,4334,4057,0700,0000,0041,0000	; 4927	=111	7-BIT DPB, BYTE/BYTE5, J/DPB7
							; 4928	=
U 3131, 3132,3447,1200,4174,4007,0700,0200,0003,0002	; 4929	DPB7:	[MAG]_[MASK]*.5, START WRITE
U 3132, 0002,3333,0003,4175,5004,1701,0200,0000,0002	; 4930		MEM WRITE, MEM_[AR], RETURN [2]
							; 4931	
							; 4932	
U 3133, 3134,4222,0000,4174,4007,0700,0000,0000,0000	; 4933	DPBSLO: Q_0			;CLEAR Q
							; 4934		GEN MSK [MAG],		;GENERATE MASK IN Q (ZAP MAG)
							; 4935		FE_FE+10,		;COUNT STEPS
U 3134, 3135,4224,0000,4174,4027,0700,1020,0041,0010	; 4936		MULTI SHIFT/1		;FAST SHIFT
U 3135, 3136,4224,0000,4174,4027,0700,0000,0000,0000	; 4937		GEN MSK [MAG]		;ONE MORE BITS
U 3136, 3137,3333,0003,4174,4007,0701,1000,0073,0000	; 4938		READ [AR], 3T, FE_P	;AMOUNT TO SHIFT
U 3137, 3140,4443,0000,4174,4007,0700,1000,0051,0770	; 4939		FE_FE.AND.S#, S#/0770	;MASK OUT JUNK
							; 4940		Q_Q.AND.[MASK], 	;CLEAR BITS 36 AND 37
U 3140, 3141,4002,1200,4174,4007,0700,1000,0031,0000	; 4941		FE_-FE			;MINUS NUMBER OF STEPS
							; 4942		[ARX]_[ARX]*2 LONG,	;SHIFT BYTE AND MASK
							; 4943		FE_FE+10,		;COUNT OUT STEPS
U 3141, 3142,3444,0404,4174,4007,0700,1020,0041,0010	; 4944		MULTI SHIFT/1		;FAST SHIFT
							; 4945	;AT THIS POINT WE HAVE DONE ALL THE SHIFTING WE NEED. THE BYTE IS
							; 4946	; IN ARX AND THE MASK IS IN Q.
U 3142, 3143,7221,0003,4174,4007,0700,0000,0000,0000	; 4947		[AR]_.NOT.Q
U 3143, 3144,4111,0503,4174,4007,0700,0000,0000,0000	; 4948		[AR]_[AR].AND.[BR]
U 3144, 3145,4001,0404,4174,4007,0700,0000,0000,0000	; 4949		[ARX]_[ARX].AND.Q
							; 4950		[AR]_[AR].OR.[ARX],
U 3145, 3131,3111,0403,4174,4007,0700,0000,0000,0000	; 4951		J/DPB7
							; 4952	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 134
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 4953	.TOC	"BYTE GROUP -- ADJUST BYTE POINTER"
							; 4954	.IF/FULL
							; 4955	;FIRST THE NUMBER OF BYTES PER WORD IS COMPUTED FROM THE
							; 4956	; FOLLOWING FORMULA:
							; 4957	;
							; 4958	;		       (  P  )	    ( 36-P )
							; 4959	;  BYTES PER WORD = INT( --- ) + INT( ---- )
							; 4960	;		       (  S  )	    (  S   )
							; 4961	;
							; 4962	;THIS GIVES 2 BYTES PER WORD FOR THE FOLLOWING 12 BIT BYTE:
							; 4963	;	!=====================================!
							; 4964	;	!  6  !////////////!	12     !  6   !
							; 4965	;	!=====================================!
							; 4966	;		P=18 AND S=12
							; 4967	;
							; 4968	;WE GET 3 BYTES/WORD IF THE BYTES FALL IN THE NATURAL PLACE:
							; 4969	;	!=====================================!
							; 4970	;	!    12     !\\\\\\\\\\\\!     12     !
							; 4971	;	!=====================================!
							; 4972	;	       P=12 AND S=12
							; 4973	
							; 4974	;WE COME HERE WITH THE BYTE POINTER IN AR, AND ADJPTR
							; 4975	ADJBP:	[ARX]_[AR] SWAP,	;MOVE SIZE OVER
U 3146, 1320,3770,0304,4344,4007,0700,2000,0071,0011	; 4976		SC_9.			;READY TO SHIFT
							; 4977	=0
							; 4978	ADJBP0: [ARX]_[ARX]*.5, 	;SHIFT P OVER
							; 4979		STEP SC,		; ..
U 1320, 1320,3447,0404,4174,4007,0630,2000,0060,0000	; 4980		J/ADJBP0		; ..
							; 4981		[ARX]_([ARX].AND.#)*.5, ;SHIFT AND MASK
							; 4982		3T,			;WAIT
U 1321, 3147,4557,0404,4374,4007,0701,0000,0000,0176	; 4983		#/176			;6 BIT MASK
							; 4984		[ARX]_#,		;CLEAR LH
							; 4985		#/0,			; ..
U 3147, 3150,3771,0004,4374,0007,0700,0000,0000,0000	; 4986		HOLD RIGHT		; ..
U 3150, 3151,3333,0004,7174,4007,0700,0400,0000,0221	; 4987		WORK[ADJP]_[ARX]	;SAVE P
							; 4988		[BR]_([AR].AND.#)*.5,	;START ON S
							; 4989		3T,			;EXTRACT S
U 3151, 3152,4557,0305,4374,4007,0701,0000,0000,7700	; 4990		#/007700		; ..
							; 4991		[BR]_[BR] SWAP, 	;SHIFT 18 PLACES
U 3152, 3153,3770,0505,4344,4007,0700,2000,0071,0003	; 4992		SC_3			; ..
							; 4993		[BR]_0, 		;CLEAR LH
U 3153, 1322,4221,0005,4174,0007,0700,0000,0000,0000	; 4994		HOLD RIGHT		; ..
							; 4995	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 135
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 4996	=0
							; 4997	ADJBP1: [BR]_[BR]*.5,		;SHIFT S OVER
							; 4998		STEP SC,		; ..
U 1322, 1322,3447,0505,4174,4007,0630,2000,0060,0000	; 4999		J/ADJBP1		; ..
							; 5000		WORK[ADJS]_[BR],	;SALT S AWAY
U 1323, 1324,3333,0005,7174,4007,0621,0400,0000,0222	; 5001		SKIP AD.EQ.0		;SEE IF ZERO
							; 5002	=0	Q_[ARX],		;DIVIDE P BY S
							; 5003		SC_34.,			;STEP COUNT
U 1324, 0664,3442,0400,4174,4007,0700,2000,0071,0042	; 5004		J/ADJBP2		;SKIP NEXT WORD
U 1325, 1404,3771,0003,7274,4007,0701,0000,0000,0223	; 5005		[AR]_WORK[ADJPTR], J/MOVE	;S=0 -- SAME AS MOVE
							; 5006	=0*
							; 5007	ADJBP2: [AR]_#, 		;FILL AR WITH SIGN BITS
							; 5008		#/0,			;POSITIVE
U 0664, 0370,3771,0003,4374,4007,0700,0010,0000,0000	; 5009		CALL [DIVSUB]		;GO DIVIDE
U 0666, 3154,3223,0000,7174,4007,0700,0400,0000,0224	; 5010		WORK[ADJQ1]_Q		;SAVE QUOTIENT
							; 5011		Q_#,			;COMPUTE (36-P)/S
							; 5012		#/36.,			; ..
U 3154, 3155,3772,0000,4370,4007,0700,0000,0000,0044	; 5013		HOLD LEFT		;SMALL ANSWER
U 3155, 3156,1662,0000,7274,4007,0701,4000,0000,0221	; 5014		Q_Q-WORK[ADJP]		;SUBTRACT P
U 3156, 3157,3771,0005,7274,4007,0701,0000,0000,0222	; 5015		[BR]_WORK[ADJS]		;DIVIDE BY S
U 3157, 0670,4443,0000,4174,4007,0700,2000,0071,0042	; 5016		SC_34.			;STEP COUNT
							; 5017	=0*	[AR]_#,			;MORE SIGN BITS
							; 5018		#/0,			; ..
U 0670, 0370,3771,0003,4374,4007,0700,0010,0000,0000	; 5019		CALL [DIVSUB]		;GO DIVIDE
U 0672, 3160,3333,0003,7174,4007,0700,0400,0000,0225	; 5020		WORK[ADJR2]_[AR]	;SAVE REMAINDER
							; 5021		[AR]_#, 		;ASSUME NEGATIVE ADJ
U 3160, 3161,3771,0003,4374,4007,0700,0000,0077,7777	; 5022		#/777777		;EXTEND SIGN
							; 5023		AD/D+Q, 		;BR_(P/S)+((36-P)/S)
							; 5024		DEST/AD,		; ..
							; 5025		B/BR,			; ..
							; 5026		RAMADR/#,		; ..
							; 5027		DBUS/RAM,		; ..
							; 5028		WORK/ADJQ1,		; ..
							; 5029		4T,			; ..
U 3161, 1326,0661,0005,7274,4007,0622,0000,0000,0224	; 5030		SKIP AD.EQ.0		;SEE IF ZERO
							; 5031	=0	Q_Q+AC, 		;GET ADJUSTMENT
							; 5032		SC_34.,			;STEP COUNT
							; 5033		SKIP DP0,		;GO DO DIVIDE
							; 5034		4T,			;WAIT FOR DP
U 1326, 0570,0662,0000,0274,4007,0522,2000,0071,0042	; 5035		J/ADJBP3		;BELOW
U 1327, 0555,4443,0000,4174,4467,0700,0000,0051,1000	; 5036		NO DIVIDE		;0 BYTES/WORD
							; 5037	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 136
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 5038	;WE NOW DIVIDE THE ADJUSTMENT BY THE BYTES PER WORD AND FORCE THE
							; 5039	; REMAINDER (R) TO BE A POSITIVE NUMBER (MUST NOT BE ZERO). THE
							; 5040	; QUOTIENT IS ADDED TO THE Y FIELD IN THE BYTE POINTER AND THE NEW
							; 5041	; P FIELD IS COMPUTED BY:
							; 5042	;
							; 5043	;	     (		     ( 36-P ))
							; 5044	; NEW P = 36-((R * S) +  RMDR( ---- ))
							; 5045	;	     (		     (	 S  ))
							; 5046	;
							; 5047	;WE NOW HAVE BYTES/WORD IN BR AND ADJUSTMENT IN Q. DIVIDE TO GET
							; 5048	; WORDS TO ADJUST BY.
							; 5049	=00
							; 5050	ADJBP3: [AR]_#, 		;POSITIVE ADJUSTMENT
U 0570, 0571,3771,0003,4374,4007,0700,0000,0000,0000	; 5051		#/0.
							; 5052		WORK[ADJBPW]_[BR],	;SAVE BYTES/WORD & COMPUTE
U 0571, 0370,3333,0005,7174,4007,0700,0410,0000,0226	; 5053		CALL [DIVSUB]		; ADJ/(BYTES/WORD)
							; 5054	;WE NOW WANT TO ADJUST THE REMAINDER SO THAT IT IS POSITIVE
							; 5055	=11	Q_#,			;ONLY RIGHT HALF
							; 5056		#/0,			; ..
U 0573, 3162,3772,0000,4374,0007,0700,0000,0000,0000	; 5057		HOLD RIGHT		; ..
							; 5058	=
							; 5059		READ [AR],		;ALREADY +
U 3162, 1330,3333,0003,4174,4007,0421,0000,0000,0000	; 5060		SKIP AD.LE.0		; ..
							; 5061	=0
							; 5062	ADJBP4: AD/D+Q, 		;ADD Q TO POINTER AND STORE
							; 5063		DEST/AD,		; ..
							; 5064		B/BR,			;RESULT TO BR
							; 5065		RAMADR/#,		;PTR IS IN RAM
							; 5066		DBUS/RAM,		; ..
							; 5067		WORK/ADJPTR,		; ..
							; 5068		INH CRY18,		;JUST RH
							; 5069		3T,			;WAIT FOR RAM
U 1330, 3164,0661,0005,7274,4407,0701,0000,0000,0223	; 5070		J/ADJBP5		;CONTINUE BELOW
							; 5071		Q_Q-1,			;NO--MAKE Q SMALLER
U 1331, 3163,1002,0700,4170,4007,0700,4000,0000,0000	; 5072		HOLD LEFT		; ..
							; 5073		[AR]_[AR]+WORK[ADJBPW], ;MAKE REM BIGGER
U 3163, 1330,0551,0303,7274,4007,0701,0000,0000,0226	; 5074		J/ADJBP4		;NOW HAVE + REMAINDER
							; 5075	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 137
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 5076	ADJBP5: [BRX]_[AR],		;COMPUTE R*S
U 3164, 3165,3441,0306,4174,4007,0700,2000,0071,0043	; 5077		SC_35.			;STEP COUNT
U 3165, 0062,3772,0000,7274,4007,0701,0000,0000,0222	; 5078		Q_WORK[ADJS]		;GET S
							; 5079	=01*	[BRX]_[BRX]*.5 LONG,	;SHIFT OVER
U 0062, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 5080		CALL [MULSUB]		; ..
							; 5081		AD/D+Q, 		;AR_(R*S)+RMDR(36-P)/S
							; 5082		DEST/AD,		; ..
							; 5083		B/AR,			; ..
							; 5084		RAMADR/#,		; ..
							; 5085		3T,			; ..
							; 5086		DBUS/RAM,		; ..
U 0066, 3166,0661,0003,7274,4007,0701,0000,0000,0225	; 5087		WORK/ADJR2		; ..
							; 5088		[AR]_(#-[AR])*2,	;COMPUTE 36-AR
							; 5089		3T,			;AND START LEFT
U 3166, 3167,2555,0303,4374,4007,0701,4000,0000,0044	; 5090		#/36.			; ..
							; 5091		[AR]_[AR] SWAP, 	;PUT THE POSITION BACK
U 3167, 3170,3770,0303,4344,4007,0700,2000,0071,0011	; 5092		SC_9.			; ..
							; 5093		[AR]_#, 		;CLEAR JUNK FROM RH
							; 5094		#/0,			; ..
U 3170, 1332,3771,0003,4370,4007,0700,0000,0000,0000	; 5095		HOLD LEFT		; ..
							; 5096	=0
							; 5097	ADJBP6: [AR]_[AR]*2,		;LOOP OVER ALL BITS
							; 5098		STEP SC,		; ..
U 1332, 1332,3445,0303,4174,4007,0630,2000,0060,0000	; 5099		J/ADJBP6		; ..
							; 5100		[BR]_[BR].AND.#,	; ..
							; 5101		#/007777,		; ..
U 1333, 3171,4551,0505,4374,0007,0700,0000,0000,7777	; 5102		HOLD RIGHT		; ..
							; 5103		AC_[AR].OR.[BR],	;ALL DONE
U 3171, 1400,3113,0305,0174,4007,0700,0400,0000,0000	; 5104		J/DONE
							;;5105	.IFNOT/FULL
							;;5106	
							;;5107	ADJBP:	UUO			;NO ADJBP IN SMALL
							;;5108						; MICROCODE
							; 5109	.ENDIF/FULL
							; 5110	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 138
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BYTE GROUP -- ADJUST BYTE POINTER			

							; 5111		.NOBIN
							; 5112	.TOC	"BLT"
							; 5113	
							; 5114	;THIS CODE PROVIDES A GUARANTEED RESULT IN AC ON COMPLETION OF
							; 5115	; THE TRANSFER (EXCEPT IN THE CASE AC IS PART OF BUT NOT THE LAST WORD
							; 5116	; OF THE DESTINATION BLOCK).  WHEN AC IS NOT PART OF THE DESTINATION
							; 5117	; BLOCK, IT IS LEFT CONTAINING THE ADDRESSES OF THE FIRST WORD FOLLOWING
							; 5118	; THE SOURCE BLOCK (IN THE LH), AND THE FIRST WORD FOLLOWING THE DEST-
							; 5119	; INATION BLOCK (IN THE RH).  IF AC IS THE LAST WORD OF THE DESTINATION
							; 5120	; BLOCK, IT WILL BE A COPY OF THE LAST WORD OF THE SOURCE BLOCK.
							; 5121	
							; 5122	;IN ADDITION, A SPECIAL-CASE CHECK IS MADE FOR THE CASE IN WHICH EACH
							; 5123	; WORD STORED IS USED AS THE SOURCE OF THE NEXT TRANSFER.  IN THIS CASE,
							; 5124	; ONLY ONE READ NEED BE PERFORMED, AND THAT DATA MAY BE STORED FOR EACH
							; 5125	; TRANSFER.  THUS THE COMMON USE OF BLT TO CLEAR CORE IS SPEEDED UP.
							; 5126	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 139
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BLT							

							; 5127		.BIN
							; 5128	
							; 5129	;HERE TO SETUP FOR A BLT/UBABLT
							; 5130	
U 3172, 1334,3770,0604,4344,4007,0700,0000,0000,0000	; 5131	SETBLT:	[ARX]_[BRX] SWAP	;COPY TO ARX (SRC IN RH)
							; 5132	=0	VMA_[ARX],		;ADDRESS OF FIRST WORD
							; 5133		START READ,
							; 5134		PXCT BLT SRC,
U 1334, 3723,3443,0400,4174,4007,0700,0210,0004,0712	; 5135		CALL [CLARXL]		;CLEAR THE LEFT HALF OF
							; 5136		[BRX]_0,		; BOTH SRC AND DEST
U 1335, 3173,4221,0006,4174,0007,0700,0000,0000,0000	; 5137		HOLD RIGHT
U 3173, 3174,2112,0306,4174,4007,0700,4000,0000,0000	; 5138		Q_[AR]-[BRX]		;NUMBER OF WORDS TO MOVE
U 3174, 3175,0001,0705,4174,4007,0700,0000,0000,0000	; 5139		[BR]_Q+1		;LENGTH +1
							; 5140		[BR]_[BR] SWAP, 	;COPY TO BOTH HALFS
U 3175, 3176,3770,0505,4344,0007,0700,0000,0000,0000	; 5141		HOLD RIGHT
							; 5142		[BR]_AC+[BR],		;FINAL AC
U 3176, 3177,0551,0505,0274,4407,0701,0000,0000,0000	; 5143		INH CRY18		;KEEP AC CORRECT IF DEST IS 777777
U 3177, 0002,3771,0013,4370,4004,1700,0000,0000,0001	; 5144		STATE_[BLT],RETURN [2]	;SET PAGE FAIL FLAGS
							; 5145	
							; 5146		.DCODE
D 0251, 0000,1640,2100					; 5147	251:	I,		J/BLT
							; 5148		.UCODE
							; 5149	
							; 5150	1640:
U 1640, 3172,3771,0006,0276,6007,0700,0010,0000,0000	; 5151	BLT:	[BRX]_AC,CALL [SETBLT]	;FETCH THE AC (DEST IN RH)
							; 5152	1642:	AC_[BR],		;STORE BACK IN AC
U 1642, 3722,3440,0505,0174,4007,0700,0410,0000,0000	; 5153		CALL [LOADQ]		;LOAD FIRST WORD INTO Q
							; 5154	1643:	[BR]_[ARX]+1000001,	;SRC+1
							; 5155		3T,
U 1643, 3200,0551,0405,4370,4007,0701,0000,0000,0001	; 5156		HOLD LEFT
							; 5157		[BR]-[BRX], 3T,		;IS THIS THE CORE CLEAR CASE
U 3200, 1336,2113,0506,4174,4007,0331,4000,0000,0000	; 5158		SKIP ADR.EQ.0
							; 5159	=0
							; 5160	BLTLP1: VMA_[BRX],		;NO, GET DEST ADR
							; 5161		START WRITE,		;START TO STORE NEXT WORD
							; 5162		PXCT BLT DEST,		;WHERE TO STORE
U 1336, 3203,3443,0600,4174,4007,0700,0200,0003,0312	; 5163		J/BLTGO
							; 5164	
							; 5165		;SKIP TO NEXT PAGE IF CLEARING CORE
							; 5166	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 140
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BLT							

							; 5167	;CLEAR CORE CASE
							; 5168		VMA_[BRX],
							; 5169		START WRITE,
U 1337, 3201,3443,0600,4174,4007,0700,0200,0003,0312	; 5170		PXCT BLT DEST
							; 5171	BLTCLR: MEM WRITE,		;STORE WORD
							; 5172		MEM_Q,
U 3201, 1340,3223,0000,4174,4007,0671,0200,0000,0002	; 5173		SKIP/-1 MS		;1 MS TIMER UP
U 1340, 3204,4443,0000,4174,4007,0700,0000,0000,0000	; 5174	=0	J/BLTGOT		;GO TAKE INTERRUPT
							; 5175		[BRX]-[AR],		;BELOW E?
							; 5176		3T,
U 1341, 1342,2113,0603,4174,4007,0521,4000,0000,0000	; 5177		SKIP DP0
							; 5178	=0	END BLT,		;NO--STOP BLT
U 1342, 1400,4221,0013,4170,4007,0700,0000,0000,0000	; 5179		J/DONE
							; 5180		[ARX]_[ARX]+1,		;FOR PAGE FAIL LOGIC
U 1343, 1344,0111,0704,4174,4007,0370,0000,0000,0000	; 5181		SKIP IRPT
							; 5182	=0	VMA_[BRX]+1,
							; 5183		LOAD VMA,
							; 5184		PXCT BLT DEST,
							; 5185		START WRITE,		;YES--KEEP STORING
U 1344, 3201,0111,0706,4170,4007,0700,0200,0003,0312	; 5186		J/BLTCLR
							; 5187		VMA_[BRX]+1,		;INTERRUPT
							; 5188		LOAD VMA,
							; 5189		PXCT BLT DEST,
							; 5190		START WRITE,
U 1345, 3203,0111,0706,4170,4007,0700,0200,0003,0312	; 5191		J/BLTGO
							; 5192	
							; 5193	;HERE FOR NORMAL BLT
							; 5194	BLTLP:	MEM READ,		;FETCH
							; 5195		Q_MEM,
U 3202, 1336,3772,0000,4365,5007,0700,0200,0000,0002	; 5196		J/BLTLP1
							; 5197	BLTGO:	MEM WRITE,		;STORE
U 3203, 3204,3223,0000,4174,4007,0701,0200,0000,0002	; 5198		MEM_Q
							; 5199	BLTGOT:	[BRX]-[AR],		;BELOW E?
							; 5200		3T,
U 3204, 1346,2113,0603,4174,4007,0521,4000,0000,0000	; 5201		SKIP DP0
							; 5202	=0	END BLT,		;NO--STOP BLT
U 1346, 1400,4221,0013,4170,4007,0700,0000,0000,0000	; 5203		J/DONE
U 1347, 3205,0111,0706,4174,4007,0700,0000,0000,0000	; 5204		[BRX]_[BRX]+1		;UPDATE DEST ADDRESS
							; 5205		VMA_[ARX]+1,
							; 5206		LOAD VMA,
							; 5207		PXCT BLT SRC,
							; 5208		START READ,		;YES--MOVE 1 MORE WORD
U 3205, 3202,0111,0704,4170,4007,0700,0200,0004,0712	; 5209		J/BLTLP
							; 5210	
							; 5211	;HERE TO CLEAN UP AFTER BLT PAGE FAILS
							; 5212	BLT-CLEANUP:
U 3206, 3207,3770,0303,4344,4007,0700,0000,0000,0000	; 5213		[AR]_[AR] SWAP		;PUT SRC IN LEFT HALF
							; 5214		[AR]_WORK[SV.BRX],
U 3207, 3210,3771,0003,7270,4007,0701,0000,0000,0214	; 5215		HOLD LEFT
							; 5216		AC_[AR],		;STORE THE AC AND RETURN
U 3210, 1100,3440,0303,0174,4007,0700,0400,0000,0000	; 5217		J/CLEANED
							; 5218	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 141
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			BLT							

							; 5219	.IF/UBABLT
							; 5220	.TOC	"UBABLT - BLT BYTES TO/FROM UNIBUS FORMAT"
							; 5221	
							; 5222	;THESE INSTRUCTION MOVE WORDS FROM BYTE TO UNIBUS AND UNIBUS TO BYTE
							; 5223	;FORMAT.  FORMATS ARE:
							; 5224	;
							; 5225	;BYTE FORMAT:
							; 5226	;
							; 5227	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5228	; ;; BYTE 0 ;; BYTE 1 ;; BYTE 2 ;; BYTE 3 ;; 4 BITS ;;
							; 5229	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5230	;
							; 5231	;UNIBUS FORMAT:
							; 5232	;
							; 5233	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5234	; ;; 2 BITS ;; BYTE 1 ;; BYTE 0 ;; 2 BITS ;; BYTE 3 ;; BYTE 2 ;;
							; 5235	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							; 5236	;
							; 5237	
							; 5238	=0*
							; 5239	BLTX:	[BRX]_AC,		;FETCH THE AC (DEST IN RH)
U 0674, 3172,3771,0006,0276,6007,0700,0010,0000,0000	; 5240		CALL [SETBLT]		;DO THE REST OF THE SETUP
U 0676, 3211,3440,0505,0174,4007,0700,0400,0000,0000	; 5241		AC_[BR]			;STORE THE FINAL AC IN AC
							; 5242	
							; 5243	BLTXLP:	MEM READ,		;READ THE SOURCE WORD
							; 5244		Q_MEM,			;FROM MEMORY
U 3211, 0006,3772,0000,4365,5003,7700,0200,0000,0002	; 5245		B DISP			;SKIP IF BLTUB (OPCODE 717)
							; 5246	=110	Q_Q*.5,			;BLTBU (OPCODE 716) - SHIFT RIGHT 1 BIT
U 0006, 3217,3446,1200,4174,4007,0700,0000,0000,0000	; 5247		J/BLTBU1		;CONTINUE INSTRUCTION
							; 5248	
							; 5249		AD/D.AND.Q,DBUS/DBM,	;BLTUB - MASK LOW BYTES, SHIFT LEFT
U 0007, 0610,4665,0017,4374,4007,0700,0000,0000,0377	; 5250		DBM/#,#/377,DEST/AD*2,B/T1	;AND STORE RESULT
							; 5251	=00	FE_S#,S#/1767,		;-9 MORE BITS TO PUT LOW BYTE OF LH
U 0610, 3224,4443,0000,4174,4007,0700,1010,0071,1767	; 5252		CALL [T1LSH]		; IN TOP OF LH SHIFT LEFT
							; 5253	=01	FE_S#,S#/1772,		;-6 BITS TO PUT HI BYTE TO RIGHT
U 0611, 3225,4443,0000,4174,4007,0700,1010,0071,1772	; 5254		CALL [Q_RSH]		; OF LOW BYTE.  
U 0613, 3212,4662,0000,4374,4007,0700,0000,0000,1774	; 5255	=11	Q_Q.AND.#,#/001774	;KEEP ONLY HI BYTES
							; 5256	=
							; 5257		AD/A.OR.Q,A/T1,DEST/AD,	;MERGE PAIRS OF BYTES. NOW SWAPPED,
U 3212, 3213,3001,1717,4174,4007,0700,0000,0000,0000	; 5258		B/T1			;BUT STILL IN HALF-WORDS
							; 5259		AD/57,RSRC/0A,A/T1,	;CLEAR LH OF Q WHILE LOADING
U 3213, 3214,5742,1700,4174,4007,0700,0000,0000,0000	; 5260		DEST/Q_AD		;RH WITH LOW WORD
U 3214, 3215,3444,0012,4174,4007,0700,0000,0000,0000	; 5261		Q_Q*2			;SHIFT LOW WORD ACROSS 1/2 WORD
U 3215, 3216,3444,0012,4174,4007,0700,0000,0000,0000	; 5262		Q_Q*2			;AND INTO FINAL POSITION
							; 5263		[T1]_[T1].AND.# CLR RH,	;CLEAR ALL BUT HIGH 16-BIT WORD
U 3216, 3223,4521,1717,4374,4007,0700,0000,0077,7774	; 5264		#/777774,J/BLTXV	;FROM T1 AND CONTINUE
							; 5265	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 142
; SIMPLE.MIC[1,2]	16:49 11-NOV-1985			UBABLT - BLT BYTES TO/FROM UNIBUS FORMAT		

U 3217, 3220,3446,1200,4174,4007,0700,0000,0000,0000	; 5266	BLTBU1:	Q_Q*.5			;NOW IN 1/2 WORDS
U 3220, 3221,3446,1200,4170,4007,0700,0000,0000,0000	; 5267		Q_Q*.5,HOLD LEFT	;INSERT A NULL BIT IN RH
U 3221, 3222,3446,1200,4170,4007,0700,0000,0000,0000	; 5268		Q_Q*.5,HOLD LEFT	;ONE MORE - NOW IN HALF WORDS
							; 5269		AD/D.AND.Q,DBUS/DBM,	;BUT NOT SWAPPED.  COPY RIGHT BYTE
U 3222, 0630,4665,0017,4374,4007,0700,0000,0000,0377	; 5270		DBM/#,#/377,DEST/AD*2,B/T1	;TO T1 AND SHIFT LEFT 1 POSITION
							; 5271	=00	FE_S#,S#/1771,		;-7 BITS MORE
U 0630, 3224,4443,0000,4174,4007,0700,1010,0071,1771	; 5272		CALL [T1LSH]		;TO FINAL RESTING PLACE
							; 5273	=01	FE_S#,S#/1770,		;-8. LEFT BYTES MOVE RIGHT
U 0631, 3225,4443,0000,4174,4007,0700,1010,0071,1770	; 5274		CALL [Q_RSH]		;TO FINAL RESTING PLACE
U 0633, 3223,4662,0000,4374,4007,0700,0000,0000,0377	; 5275	=11	Q_Q.AND.#,#/377		;WANT ONLY THE NEW BYTES
							; 5276	=
							; 5277	
							; 5278	BLTXV:	Q_[T1].OR.Q,		;MERGE RESULTS
U 3223, 3226,3002,1700,4174,4007,0700,0000,0000,0000	; 5279		J/BLTXW			;AND STUFF IN MEMORY
							; 5280	
U 3224, 0001,3445,1717,4174,4004,1700,1020,0041,0001	; 5281	T1LSH:	[T1]_[T1]*2,SHIFT,RETURN [1]
U 3225, 0002,3446,1200,4174,4004,1700,1020,0041,0001	; 5282	Q_RSH:	Q_Q*.5,SHIFT,RETURN [2]
							; 5283	
							; 5284	BLTXW:	VMA_[BRX],START WRITE,	;DEST TO VMA
U 3226, 3227,3443,0600,4174,4007,0700,0200,0003,0312	; 5285		PXCT BLT DEST
U 3227, 3230,3223,0000,4174,4007,0701,0200,0000,0002	; 5286		MEM WRITE,MEM_Q		;STORE
U 3230, 1350,2113,0603,4174,4007,0521,4000,0000,0000	; 5287		[BRX]-[AR],3T,SKIP DP0	;DONE?
U 1350, 1400,4221,0013,4170,4007,0700,0000,0000,0000	; 5288	=0	END BLT,J/DONE		;YES
U 1351, 3231,0111,0706,4174,4007,0700,0000,0000,0000	; 5289		[BRX]_[BRX]+1		;NO, INC DEST
							; 5290		VMA_[ARX]+1,LOAD VMA,	; AND SOURCE (LOADING VMA)
							; 5291		PXCT BLT SRC,START READ,;START UP MEMORY
U 3231, 3211,0111,0704,4170,4007,0700,0200,0004,0712	; 5292		J/BLTXLP		;AND CONTINUE WITH NEXT WORD
							; 5293	.ENDIF/UBABLT
							; 5294	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 143
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FAD, FSB				

							; 5295	.TOC	"FLOATING POINT -- FAD, FSB"
							; 5296	
							; 5297		.DCODE
D 0140, 0701,1577,1100					; 5298	140:	FL-R,	FL-AC,		J/FAD
D 0142, 0702,1577,1700					; 5299	142:	FL-RW,	FL-MEM,		J/FAD
D 0143, 0703,1577,1700					; 5300		FL-RW,	FL-BOTH,	J/FAD
D 0144, 0711,1577,1100					; 5301		FL-R,	FL-AC, ROUND,	J/FAD
D 0145, 0611,1577,0100					; 5302		FL-I,	FL-AC, ROUND,	J/FAD
D 0146, 0712,1577,1700					; 5303		FL-RW,	FL-MEM, ROUND,	J/FAD
D 0147, 0713,1577,1700					; 5304		FL-RW,	FL-BOTH, ROUND,	J/FAD
							; 5305	
D 0150, 0701,1576,1100					; 5306	150:	FL-R,	FL-AC,		J/FSB
D 0152, 0702,1576,1700					; 5307	152:	FL-RW,	FL-MEM,		J/FSB
D 0153, 0703,1576,1700					; 5308		FL-RW,	FL-BOTH,	J/FSB
D 0154, 0711,1576,1100					; 5309		FL-R,	FL-AC, ROUND,	J/FSB
D 0155, 0611,1576,0100					; 5310		FL-I,	FL-AC, ROUND,	J/FSB
D 0156, 0712,1576,1700					; 5311		FL-RW,	FL-MEM, ROUND,	J/FSB
D 0157, 0713,1576,1700					; 5312		FL-RW,	FL-BOTH, ROUND,	J/FSB
							; 5313		.UCODE
							; 5314	
							; 5315	;BOTH FAD & FSB ARE ENTERED WITH THE MEMORY OPERAND IN AR
							; 5316	; SIGN SMEARED. THE EXPONENT IN BOTH SC AND FE.
							; 5317	1576:
U 1576, 1577,2441,0303,4174,4007,0700,4000,0000,0000	; 5318	FSB:	[AR]_-[AR]		;MAKE MEMOP NEGATIVE
							; 5319	
							; 5320	1577:
U 1577, 0720,3771,0005,0276,6006,7701,2000,0020,2000	; 5321	FAD:	[BR]_AC, SC_SC-EXP-1, 3T, SCAD DISP
							; 5322	=0*
U 0720, 1354,3333,0005,4174,4007,0520,0000,0000,0000	; 5323	FAS1:	READ [BR], SKIP DP0, J/FAS2	;BR .LE. AR
U 0722, 3232,3441,0304,4174,4007,0700,0000,0000,0000	; 5324		[ARX]_[AR]		;SWAP AR AND BR
U 3232, 3233,3441,0503,4174,4007,0700,2000,0041,2000	; 5325		[AR]_[BR], SC_EXP
U 3233, 3234,3441,0405,4174,4007,0700,2000,0020,0000	; 5326		[BR]_[ARX], SC_SC-FE-1	;NUMBER OF SHIFT STEPS
U 3234, 1352,3333,0003,4174,4007,0520,1000,0041,2000	; 5327		READ [AR], FE_EXP, 2T, SKIP DP0
U 1352, 3235,4551,0303,4374,0007,0700,0000,0000,0777	; 5328	=0	[AR]_+SIGN, J/FAS3
U 1353, 3235,3551,0303,4374,0007,0700,0000,0077,7000	; 5329		[AR]_-SIGN, J/FAS3
							; 5330	
							; 5331	=0	;SIGN SMEAR BR AND UNNORMALIZE
U 1354, 3235,4551,0505,4374,0007,0700,0000,0000,0777	; 5332	FAS2:	[BR]_+SIGN, J/FAS3
U 1355, 3235,3551,0505,4374,0007,0700,0000,0077,7000	; 5333		[BR]_-SIGN, J/FAS3
							; 5334	
U 3235, 1356,4222,0000,4174,4007,0630,2000,0060,0000	; 5335	FAS3:	Q_0, STEP SC
							; 5336	=0
U 1356, 1356,3446,0505,4174,4047,0630,2000,0060,0000	; 5337	FAS4:	[BR]_[BR]*.5 LONG, STEP SC, ASHC, J/FAS4
U 1357, 0420,0111,0503,4174,4003,4701,0000,0000,0000	; 5338		[AR]_[AR]+[BR], NORM DISP, J/SNORM
							; 5339	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 144
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLAOTING POINT -- FMP					

							; 5340	.TOC	"FLAOTING POINT -- FMP"
							; 5341	
							; 5342		.DCODE
D 0160, 0701,1570,1100					; 5343	160:	FL-R,	FL-AC,		J/FMP
D 0162, 0702,1570,1700					; 5344	162:	FL-RW,	FL-MEM,		J/FMP
D 0163, 0703,1570,1700					; 5345		FL-RW,	FL-BOTH,	J/FMP
							; 5346	
D 0164, 0711,1570,1100					; 5347		FL-R,	FL-AC, ROUND,	J/FMP
D 0165, 0611,1570,0100					; 5348		FL-I,	FL-AC, ROUND,	J/FMP
D 0166, 0712,1570,1700					; 5349		FL-RW,	FL-MEM, ROUND,	J/FMP
D 0167, 0713,1570,1700					; 5350		FL-RW,	FL-BOTH, ROUND,	J/FMP
							; 5351		.UCODE
							; 5352	
							; 5353	1570:
							; 5354	FMP:	[BRX]_AC,		;GET AC
							; 5355		FE_SC+EXP, 3T,		;EXPONENT OF ANSWER
U 1570, 1360,3771,0006,0276,6007,0521,1000,0040,2000	; 5356		SKIP DP0		;GET READY TO SMEAR SIGN
U 1360, 3236,4551,0606,4374,0007,0700,0000,0000,0777	; 5357	=0	[BRX]_+SIGN, J/FMP1	;POSITIVE
U 1361, 3236,3551,0606,4374,0007,0700,0000,0077,7000	; 5358		[BRX]_-SIGN, J/FMP1	;NEGATIVE
U 3236, 0163,3442,0300,4174,4007,0700,2000,0071,0033	; 5359	FMP1:	Q_[AR], SC_27.		;GET MEMORY OPERAND
							; 5360	=01*	[BRX]_[BRX]*.5 LONG,	;SHIFT RIGHT
U 0163, 3017,3446,0606,4174,4007,0700,0010,0000,0000	; 5361		CALL [MULSUB]		;MULTIPLY
							; 5362		Q_Q.AND.#, #/777000,	;WE ONLY COMPUTED
U 0167, 3237,4662,0000,4370,4007,0700,0000,0077,7000	; 5363		HOLD LEFT		; 27 BITS
U 3237, 3240,3441,0403,4174,4007,0700,1000,0041,0002	; 5364		[AR]_[ARX], FE_FE+2	;SET SHIFT PATHS
							; 5365		[AR]_[AR]*.5 LONG,	;SHIFT OVER
							; 5366		FE_FE-200,		;ADJUST EXPONENT
U 3240, 0420,3446,0303,4174,4003,4701,1000,0041,1600	; 5367		NORM DISP, J/SNORM	;NORMALIZE & EXIT
							; 5368	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 145
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FDV					

							; 5369	.TOC	"FLOATING POINT -- FDV"
							; 5370	
							; 5371		.DCODE
D 0170, 0701,1574,1100					; 5372	170:	FL-R,	FL-AC,		J/FDV
D 0172, 0702,1574,1700					; 5373	172:	FL-RW,	FL-MEM,		J/FDV
D 0173, 0703,1574,1700					; 5374		FL-RW,	FL-BOTH,	J/FDV
							; 5375	
D 0174, 0711,1574,1100					; 5376		FL-R,	FL-AC, ROUND,	J/FDV
D 0175, 0611,1574,0100					; 5377		FL-I,	FL-AC, ROUND,	J/FDV
D 0176, 0712,1574,1700					; 5378		FL-RW,	FL-MEM, ROUND,	J/FDV
D 0177, 0713,1574,1700					; 5379		FL-RW,	FL-BOTH, ROUND,	J/FDV
							; 5380		.UCODE
							; 5381	
							; 5382	
							; 5383	1574:
U 1574, 1362,3441,0305,0174,4007,0621,0000,0000,0000	; 5384	FDV:	[BR]_[AR], SKIP AD.EQ.0, AC	;COPY DIVSOR SEE IF 0
							; 5385	=0
							; 5386		[AR]_AC, FE_SC-EXP, SKIP DP0,	;GET AC & COMPUTE NEW
U 1362, 1364,3771,0003,0276,6007,0520,1000,0030,2000	; 5387			J/FDV0			; EXPONENT
U 1363, 0555,4443,0000,4174,4467,0700,0000,0071,1000	; 5388		FL NO DIVIDE			;DIVIDE BY ZERO
							; 5389	=0
U 1364, 3241,4551,0303,4374,0007,0700,0000,0000,0777	; 5390	FDV0:	[AR]_+SIGN, J/FDV1
U 1365, 3242,3551,0303,4374,0007,0700,0000,0077,7000	; 5391		[AR]_-SIGN, J/FDV2
U 3241, 3243,3441,0304,4174,4007,0700,1000,0031,0200	; 5392	FDV1:	[ARX]_[AR],FE_-FE+200,J/FDV3	;COMPUTE 2*DVND
U 3242, 3243,2441,0304,4174,4007,0700,5000,0031,0200	; 5393	FDV2:	[ARX]_-[AR],FE_-FE+200,J/FDV3	;ABSOLUTE VALUE
U 3243, 1366,3445,0506,4174,4007,0520,0000,0000,0000	; 5394	FDV3:	[BRX]_[BR]*2, SKIP DP0	;ABSOLUTE VALUE
							; 5395	=0
U 1366, 1370,2113,0406,4174,4007,0311,4000,0000,0000	; 5396	FDV4:	[ARX]-[BRX], SKIP CRY0, 3T, J/FDV5	;FLOATING NO DIV?
U 1367, 1366,2445,0506,4174,4007,0700,4000,0000,0000	; 5397		[BRX]_-[BR]*2, J/FDV4		;FORCE ABSOLUTE VALUE
							; 5398	=0
U 1370, 1372,3447,0606,4174,4007,0700,0000,0000,0000	; 5399	FDV5:	[BRX]_[BRX]*.5, J/FDV6		;SHIFT BACK ARX
U 1371, 0555,4443,0000,4174,4467,0700,0000,0071,1000	; 5400		FL NO DIVIDE			;UNNORMALIZED INPUT
							; 5401	=0
							; 5402	FDV6:	[AR]_[AR]*2,			;DO NOT DROP A BIT
U 1372, 3725,3445,0303,4174,4007,0700,0010,0000,0000	; 5403		CALL [SBRL]			;AT FDV7+1
U 1373, 0144,2113,0604,4174,4007,0421,4000,0000,0000	; 5404		[BRX]-[ARX], SKIP AD.LE.0	;IS ANSWER .LE. 1?
							; 5405	=00100
U 0144, 3062,4222,0000,4174,4007,0700,2010,0071,0033	; 5406	FDV7:	Q_0, SC_27., CALL [DIVSGN]	;DIVIDE
U 0145, 0144,3447,0303,4174,4007,0700,1000,0041,0001	; 5407	=00101	[AR]_[AR]*.5, FE_FE+1, J/FDV7	;SCALE DV'END
							; 5408	=01100
U 0154, 3244,3227,0003,4174,4007,0700,0000,0000,0000	; 5409	FDV8:	[AR]_Q*.5, J/FDV9		;PUT ANSWER IN AR
							; 5410	=01101	READ [AR], SKIP AD.EQ.0,	;-VE ANSWER, LOOK AT RMDR
U 0155, 2074,3333,0003,4174,4007,0621,0010,0000,0000	; 5411		CALL [SETSN]			; SEE HOW TO NEGATE
							; 5412	=01110	READ [AR], SKIP AD.EQ.0,	;-VE ANSWER, LOOK AT RMDR
U 0156, 2074,3333,0003,4174,4007,0621,0010,0000,0000	; 5413		CALL [SETSN]			; SEE HOW TO NEGATE
U 0157, 3244,3227,0003,4174,4007,0700,0000,0000,0000	; 5414	=01111	[AR]_Q*.5, J/FDV9		;PUT ANSWER IN AR
U 0177, 3244,2227,0003,4174,4007,0700,4000,0000,0000	; 5415	=11111	[AR]_-Q*.5, J/FDV9		;ZERO RMDR
							; 5416	
U 3244, 2003,4222,0000,4174,4007,0700,0000,0000,0000	; 5417	FDV9:	Q_0, J/SNORM0			;GO NORMALIZE
							; 5418	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 146
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FLTR, FSC				

							; 5419	.TOC	"FLOATING POINT -- FLTR, FSC"
							; 5420	
							; 5421		.DCODE
D 0127, 0011,1616,1100					; 5422	127:	R,	FL-AC,ROUND,	J/FLTR
D 0132, 0001,1621,2100					; 5423	132:	I,	FL-AC,		J/FSC
							; 5424		.UCODE
							; 5425	
							; 5426	1616:
U 1616, 1374,4553,0300,4374,4007,0321,0000,0077,7000	; 5427	FLTR:	[AR].AND.#, #/777000, 3T, SKIP ADL.EQ.0 ;SMALL POS NUMBER?
U 1374, 1376,2441,0305,4174,4007,0521,4000,0000,0000	; 5428	=0	[BR]_-[AR], SKIP DP0, 3T, J/FLTR1	;NO--SEE IF MINUS
U 1375, 2003,4222,0000,4174,4007,0700,1000,0071,0233	; 5429		Q_0, FE_S#, S#/233, J/SNORM0	;FITS IN 27 BITS
							; 5430	=0
							; 5431	FLTR1:	[BR].AND.#, #/777000, 3T,
U 1376, 2000,4553,0500,4374,4007,0321,0000,0077,7000	; 5432			SKIP ADL.EQ.0, J/FLTR1A	;SMALL NEGATIVE NUMBER
U 1377, 3245,4222,0000,4174,4007,0700,1000,0071,0244	; 5433		Q_0, FE_S#, S#/244, J/FLTR2	;LARGE POS NUMBER
							; 5434	=0
U 2000, 3245,4222,0000,4174,4007,0700,1000,0071,0244	; 5435	FLTR1A:	Q_0, FE_S#, S#/244, J/FLTR2	;BIG NUMBER
U 2001, 2003,4222,0000,4174,4007,0700,1000,0071,0233	; 5436		Q_0, FE_S#, S#/233, J/SNORM0	;FITS IN 27 BITS
							; 5437	;AT THIS POINT WE KNOW THE NUMBER TAKES MORE THAN 27 BITS. WE JUST
							; 5438	; SHIFT 8 PLACES RIGHT AND NORMALIZE. WE COULD BE MORE CLEVER BUT
							; 5439	; THIS IS THE RARE CASE ANYWAY.
U 3245, 2002,3446,0303,4174,4047,0700,2000,0071,0006	; 5440	FLTR2:	[AR]_[AR]*.5 LONG, ASHC, SC_6	;SHOVE OVER TO THE RIGHT
							; 5441	=0
							; 5442	FLTR3:	[AR]_[AR]*.5 LONG, ASHC, 	;SHIFT RIGHT 9 PLACES
U 2002, 2002,3446,0303,4174,4047,0630,2000,0060,0000	; 5443			STEP SC, J/FLTR3	; SO IT WILL FIT
U 2003, 0420,3333,0003,4174,4003,4701,0000,0000,0000	; 5444	SNORM0:	READ [AR], NORM DISP, J/SNORM	;NORMALIZE ANSWER
							; 5445	
							; 5446	
							; 5447	1621:
U 1621, 3246,3333,0003,4174,4007,0700,2000,0041,4000	; 5448	FSC:	READ [AR], SC_SHIFT
U 3246, 3247,4222,0000,0174,4007,0700,0000,0000,0000	; 5449		Q_0, AC				;DON'T SHIFT IN JUNK
U 3247, 2004,3771,0003,0276,6007,0520,1000,0040,2000	; 5450		[AR]_AC, FE_SC+EXP, SKIP DP0	;SIGN SMEAR
U 2004, 2003,4551,0303,4374,0007,0700,0000,0000,0777	; 5451	=0	[AR]_+SIGN, J/SNORM0
U 2005, 2003,3551,0303,4374,0007,0700,0000,0077,7000	; 5452		[AR]_-SIGN, J/SNORM0
							; 5453	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 147
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- FIX AND FIXR				

							; 5454	.TOC	"FLOATING POINT -- FIX AND FIXR"
							; 5455	
							; 5456		.DCODE
D 0122, 0701,1626,1100					; 5457	122:	FL-R,	FL-AC,		J/FIX
D 0126, 0711,1626,1100					; 5458	126:	FL-R,	FL-AC,ROUND,	J/FIX
							; 5459		.UCODE
							; 5460	
							; 5461	1626:
							; 5462	FIX:	Q_0, SCAD/A+B, SCADA/S#,	;CLEAR Q, SEE IF
							; 5463			S#/1534, SCADB/FE, 3T,	; ANSWER FITS IN
U 1626, 0724,4222,0000,4174,4006,7701,0000,0041,1534	; 5464			SCAD DISP		; 35 BITS.
U 0724, 0555,4443,0000,4174,4467,0700,0000,0041,1000	; 5465	=0*	SET AROV, J/NIDISP		;TOO BIG
U 0726, 0730,4443,0000,4174,4006,7701,2000,0041,1544	; 5466		SC_FE+S#, S#/1544, 3T, SCAD DISP ;NEED TO MOVE LEFT?
U 0730, 2010,4443,0000,4174,4007,0630,2000,0060,0000	; 5467	=0*	STEP SC, J/FIXL
U 0732, 3250,4443,0000,4174,4007,0700,2000,0031,0232	; 5468		SC_S#-FE, S#/232		;NUMBER OF PLACES TO SHIFT
							; 5469						; RIGHT
U 3250, 2006,4443,0000,4174,4007,0630,2000,0060,0000	; 5470		STEP SC				;ALREADY THERE
							; 5471	=0
							; 5472	FIXR:	[AR]_[AR]*.5 LONG, ASHC,	;SHIFT BINARY POINT
U 2006, 2006,3446,0303,4174,4047,0630,2000,0060,0000	; 5473			STEP SC, J/FIXR		; TO BIT 35.5
U 2007, 0063,3447,0705,4174,4003,7700,0000,0000,0000	; 5474		[BR]_[ONE]*.5, B DISP, J/FIXX	;WHICH KIND OF FIX?
							; 5475	
							; 5476	=0
U 2010, 2010,3445,0303,4174,4007,0630,2000,0060,0000	; 5477	FIXL:	[AR]_[AR]*2, STEP SC, J/FIXL	;SHIFT LEFT
U 2011, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 5478		AC_[AR], NEXT INST		;WE ARE NOW DONE
							; 5479	
							; 5480	=0*11
U 0063, 2012,3333,0003,4174,4007,0520,0000,0000,0000	; 5481	FIXX:	READ [AR], SKIP DP0, J/FIXT	;FIX--SEE IF MINUS
U 0073, 1514,0111,0503,4174,4003,7700,0200,0003,0001	; 5482	FIXX1:	[AR]_[AR]+[BR], FL-EXIT		;FIXR--ROUND UP
							; 5483	=0
U 2012, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 5484	FIXT:	AC_[AR], NEXT INST		;FIX & +, TRUNCATE
U 2013, 2014,3223,0000,4174,4007,0621,0000,0000,0000	; 5485		READ Q, SKIP AD.EQ.0		;NEGATIVE--ANY FRACTION?
U 2014, 1514,0111,0703,4174,4003,7700,0200,0003,0001	; 5486	=0	[AR]_[AR]+1, FL-EXIT		;YES--ROUND UP
							; 5487		[BR]_.NOT.[MASK],		;MAYBE--GENERATE .75
U 2015, 0073,7441,1205,4174,4007,0700,0000,0000,0000	; 5488		J/FIXX1				;ROUND UP IF BIT 36 OR
							; 5489						; 37 SET
							; 5490	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 148
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- SINGLE PRECISION NORMALIZE		

							; 5491	.TOC	"FLOATING POINT -- SINGLE PRECISION NORMALIZE"
							; 5492	
							; 5493	;NORMALIZE DISPATCH IS A 9-WAY DISPATCH. THE HARDWARE LOOKS AT
							; 5494	; 4 SIGNALS: DP=0, DP BIT 8, DP BIT 9, DP BIT -2. THE 9 CASES
							; 5495	; ARE:
							; 5496	
							; 5497	;	DP=0	DP08	DP09	DP00	ACTION TO TAKE
							; 5498	;	0	0	0	0	SHIFT LEFT
							; 5499	;
							; 5500	;	0	0	0	1	NEGATE AND RETRY
							; 5501	;
							; 5502	;	0	0	1	0	ALL DONE
							; 5503	;
							; 5504	;	0	0	1	1	NEGATE AND RETRY
							; 5505	;
							; 5506	;	0	1	0	0	SHIFT RIGHT
							; 5507	;
							; 5508	;	0	1	0	1	NEGATE AND RETRY
							; 5509	;
							; 5510	;	0	1	1	0	SHIFT RIGHT
							; 5511	;
							; 5512	;	0	1	1	1	NEGATE AND RETRY
							; 5513	;
							; 5514	;	1	-	-	-	LOOK AT Q BITS
							; 5515	
							; 5516	;ENTER HERE WITH UNNORMALIZED NUMBER IN AR!Q. FE HOLDS THE NEW
							; 5517	; EXPONENT. CALL WITH NORM DISP
							; 5518	=0000		;9-WAY DISPATCH
U 0420, 0420,3444,0303,4174,4063,4701,1000,0041,1777	; 5519	SNORM:	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNORM
U 0421, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5520		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0422, 0262,3333,0003,4174,4003,4701,0010,0000,0000	; 5521		READ [AR], NORM DISP, CALL [SROUND]
U 0423, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5522		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0424, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5523		[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0425, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5524		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0426, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5525		[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0427, 2020,2222,0000,4174,4007,0311,4000,0000,0000	; 5526		Q_-Q, SKIP CRY0, 3T, J/SNNEG
U 0430, 2016,3223,0000,4174,4007,0621,0000,0000,0000	; 5527		READ Q, SKIP AD.EQ.0, J/SNORM1
U 0436, 2017,3770,0303,4324,0457,0700,0000,0041,0000	; 5528	=1110	[AR]_EXP, J/FLEX
							; 5529	=
							; 5530	=0
U 2016, 0420,3444,0303,4174,4063,4701,1000,0041,1777	; 5531	SNORM1:	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNORM
U 2017, 1514,4443,0000,4174,4003,7700,0200,0003,0001	; 5532	FLEX:	FL-EXIT
							; 5533	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 149
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- SINGLE PRECISION NORMALIZE		

							; 5534	=0
U 2020, 0440,7441,0303,4174,4003,4701,0000,0000,0000	; 5535	SNNEG:	[AR]_.NOT.[AR], NORM DISP, J/SNNORM ;NEGATE HIGH WORD
							; 5536						; (NO CARRY)
U 2021, 0440,2441,0303,4174,4003,4701,4000,0000,0000	; 5537		[AR]_-[AR], NORM DISP, J/SNNORM	;NEGATE HIGH WORD (W/CARRY)
							; 5538	=0000
U 0440, 0440,3444,0303,4174,4063,4701,1000,0041,1777	; 5539	SNNORM:	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNNORM
U 0442, 0262,3333,0003,4174,4003,4701,0010,0000,0000	; 5540	=0010	READ [AR], NORM DISP, CALL [SROUND]
U 0444, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5541	=0100	[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0446, 0262,3447,0303,4174,4007,0700,1010,0041,0001	; 5542	=0110	[AR]_[AR]*.5, FE_FE+1, CALL [SROUND]
U 0450, 0440,3444,0303,4174,4063,4701,1000,0041,1777	; 5543	=1000	[AR]_[AR]*2 LONG, DIV, FE_FE-1, NORM DISP, J/SNNORM
U 0456, 0327,3770,0303,4324,0453,7700,0000,0041,0000	; 5544	=1110	[AR]_EXP, B DISP
							; 5545	=
U 0327, 2022,4553,1300,4374,4007,0321,0000,0000,2000	; 5546	=0111	TL [FLG], FLG.SN/1, J/SNNOT
							; 5547		[AR]_[AR].AND.[MASK],	;CLEAR ANY LEFT OVER BITS
U 0337, 2025,4111,1203,4174,4007,0700,0000,0000,0000	; 5548		J/SNNOT1
							; 5549	=0
U 2022, 3251,7441,0303,4174,4007,0700,0000,0000,0000	; 5550	SNNOT:	[AR]_.NOT.[AR], J/SNNOT2
U 2023, 2024,3223,0000,4174,4007,0621,0000,0000,0000	; 5551		READ Q, SKIP AD.EQ.0
U 2024, 3251,7441,0303,4174,4007,0700,0000,0000,0000	; 5552	=0	[AR]_.NOT.[AR], J/SNNOT2
U 2025, 3251,2441,0303,4174,4007,0700,4000,0000,0000	; 5553	SNNOT1:	[AR]_-[AR], J/SNNOT2	;NORMAL NEGATE AND EXIT
U 3251, 1514,4221,0013,4174,4003,7700,0200,0003,0001	; 5554	SNNOT2:	[FLG]_0, FL-EXIT
							; 5555	
							; 5556	
							; 5557	
							; 5558	.TOC	"FLOATING POINT -- ROUND ANSWER"
							; 5559	
							; 5560	=*01*
U 0262, 0407,3447,0705,4174,4003,7700,0000,0000,0000	; 5561	SROUND:	[BR]_[ONE]*.5, B DISP, J/SRND1
U 0266, 0262,3447,0303,4174,4007,0700,1000,0041,0001	; 5562		[AR]_[AR]*.5, FE_FE+1, J/SROUND ;WE WENT TOO FAR
							; 5563	=0111
U 0407, 0016,4443,0000,4174,4004,1700,0000,0000,0000	; 5564	SRND1:	RETURN [16]			;NOT ROUNDING INSTRUCTION
U 0417, 0302,0111,0503,4174,4003,4701,0000,0000,0000	; 5565		[AR]_[AR]+[BR], NORM DISP
U 0302, 0016,4443,0000,4174,4004,1700,0000,0000,0000	; 5566	=*01*	RETURN [16]
U 0306, 0016,3447,0303,4174,4004,1700,1000,0041,0001	; 5567		[AR]_[AR]*.5, FE_FE+1, RETURN [16]
							; 5568	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 150
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFAD, DFSB				

							; 5569	.TOC	"FLOATING POINT -- DFAD, DFSB"
							; 5570	
							; 5571		.DCODE
D 0110, 1100,1637,1100					; 5572	110:	DBL FL-R,		J/DFAD
D 0111, 1100,1635,1100					; 5573	111:	DBL FL-R,		J/DFSB
							; 5574		.UCODE
							; 5575	
							; 5576	;ENTER FROM A-READ CODE WITH:
							; 5577	;FE/	EXP
							; 5578	;SC/	EXP
							; 5579	;AR/	C(E) SHIFT RIGHT 2 PLACES
							; 5580	;ARX/	C(E+1) SHIFTED RIGHT 1 PLACE
							; 5581	1635:
U 1635, 3252,2441,0404,4174,4007,0700,4000,0000,0000	; 5582	DFSB:	[ARX]_-[ARX]		;NEGATE LOW WORD
U 3252, 1637,2441,0303,4174,4007,0700,0040,0000,0000	; 5583		[AR]_-[AR]-.25, MULTI PREC/1
							; 5584	1637:
U 1637, 3253,4557,0006,1274,4007,0701,0000,0000,1441	; 5585	DFAD:	[BRX]_(AC[1].AND.[MAG])*.5, 3T ;GET LOW WORD
							; 5586		[BR]_AC*.5, 3T,		;GET AC AND START TO SHIFT
							; 5587		SC_SC-EXP-1,		;NUMBER OF PLACES TO SHIFT
U 3253, 2026,3777,0005,0274,4007,0521,2000,0020,2000	; 5588		SKIP DP0		;SEE WHAT SIGN
							; 5589	=0	[BR]_+SIGN*.5, 3T,	;SIGN SMEAR
U 2026, 2030,5547,0505,0374,4007,0631,0000,0077,7400	; 5590		AC, SKIP/SC, J/DFAS1	;SEE WHICH IS BIGGER
							; 5591		[BR]_-SIGN*.5, 3T,	;SIGN SMEAR
U 2027, 2030,3547,0505,0374,4007,0631,0000,0077,7400	; 5592		AC, SKIP/SC, J/DFAS1	;SEE WHICH IS BIGGER
							; 5593	=0
							; 5594	DFAS1:	Q_[BRX],		;AR IS BIGGER
U 2030, 2032,3442,0600,4174,4007,0700,0000,0000,0000	; 5595		J/DFAS2			;ADJUST BR!Q
							; 5596		[T0]_AC,		;BR IS BIGGER OR EQUAL
U 2031, 3255,3771,0016,0276,6007,0700,2000,0041,2000	; 5597		SC_EXP, 2T, J/DFAS3	;SET SC TO THAT EXPONENT
							; 5598	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 151
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFAD, DFSB				

							; 5599	;HERE IF AR!ARX IS GREATER THAN BR!BRX
							; 5600	=0
U 2032, 0153,3441,0516,4174,4007,0700,0010,0000,0000	; 5601	DFAS2:	[T0]_[BR], CALL [DFADJ]	;ADJUST BR!Q
U 2033, 3254,3441,1605,4174,4007,0700,0000,0000,0000	; 5602		[BR]_[T0]		;PUT ANSWER BACK
U 3254, 3260,0002,0400,4174,4007,0700,0000,0000,0000	; 5603		Q_Q+[ARX], J/DFAS5	;ADD LOW WORDS
							; 5604	
							; 5605	;HERE IS BR!BRX IF GREATER THAN OR EQUAL TO AR!ARX
							; 5606	DFAS3:	Q_[ARX],		;SETUP TO SHIFT AR!ARX
U 3255, 3256,3442,0400,4174,4007,0700,2000,0020,0000	; 5607		SC_SC-FE-1		;COMPUTE # OF PLACES
U 3256, 2034,3333,0016,4174,4007,0700,1000,0041,2000	; 5608		READ [T0], FE_EXP	;EXPONENT OF ANSWER
U 2034, 0153,3441,0316,4174,4007,0700,0010,0000,0000	; 5609	=0	[T0]_[AR], CALL [DFADJ]	;ADJUST AR!Q
U 2035, 3257,3441,1603,4174,4007,0700,0000,0000,0000	; 5610		[AR]_[T0]		;PUT ANSWER BACK
U 3257, 3260,0002,0600,4174,4007,0700,0000,0000,0000	; 5611		Q_Q+[BRX], J/DFAS5	;ADD LOW WORDS
							; 5612	
							; 5613	;BIT DIDDLE TO GET THE ANSWER (INCLUDING 2 GUARD BITS) INTO
							; 5614	; AR!Q
							; 5615	DFAS5:	[AR]_([AR]+[BR])*.5 LONG, ;ADD HIGH WORDS
U 3260, 3261,0116,0503,4174,4047,0700,0040,0000,0000	; 5616		MULTI PREC/1, ASHC	;INJECT SAVED CRY2
							; 5617		[AR]_[AR]*2 LONG,	;SHIFT BACK LEFT
U 3261, 0433,3444,0303,4174,4046,2700,0000,0000,0000	; 5618		ASHC, MUL DISP		;SEE IF WE LOST A 1
							; 5619	=1011
U 0433, 3262,5111,1217,4174,4007,0700,0000,0000,0000	; 5620	DFAS6:	[T1]_[T1].AND.NOT.[MASK], J/DFAS7
U 0437, 0433,0222,0000,4174,4007,0700,4000,0000,0000	; 5621		Q_Q+.25, J/DFAS6
							; 5622	DFAS7:	[AR]_[AR]*2 LONG, ASHC,	;PUT IN GUARD BITS
U 3262, 3263,3444,0303,4174,4047,0700,1000,0041,1777	; 5623		FE_FE-1
							; 5624		[AR]_[AR]*2 LONG, ASHC,
U 3263, 3264,3444,0303,4174,4047,0700,1000,0041,1777	; 5625		FE_FE-1
U 3264, 2047,3002,1700,4170,4007,0700,0000,0000,0000	; 5626		Q_[T1].OR.Q, HOLD LEFT, J/DNORM0
							; 5627	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 152
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFAD, DFSB				

							; 5628	;SUBROUTINE TO ADJUST NUMBER IN T0!Q
							; 5629	;RETURNS 1 WITH
							; 5630	;	T0!Q ADJUSTED
							; 5631	;	FLG.SN=1 IF WE SHIFTED OUT ANY 1 BITS (STICKY BIT)
							; 5632	;	T1 HAS Q TWO STEPS PRIOR TO BEING DONE
							; 5633	DFADJ	"STEP SC, ASHC, MUL DISP"
							; 5634	
							; 5635	=0**11
							; 5636	DFADJ:	[T0]_[T0]*2 LONG, DIV,	;MOVE EVERYTHING 2 PLACES
U 0153, 2075,3444,1616,4174,4067,0700,0010,0000,0000	; 5637		CALL [CLRSN]
U 0173, 3265,3444,1616,4174,4067,0700,0000,0000,0000	; 5638		[T0]_[T0]*2 LONG, DIV
U 3265, 3266,3444,1616,4174,4067,0700,0000,0000,0000	; 5639		[T0]_[T0]*2 LONG, DIV
							; 5640		[T0]_[T0]*.5 LONG, ASHC, ;SHIFT AT LEAST 1 PLACE
U 3266, 0472,3446,1616,4174,4047,0630,2000,0060,0000	; 5641		STEP SC
							; 5642	=1010
							; 5643	DFADJ1:	[T0]_[T0]*.5 LONG,	;UNNORMALIZE T0!Q
U 0472, 0472,3446,1616,4174,4046,2630,2000,0060,0000	; 5644		DFADJ, J/DFADJ1		;LOOP TILL DONE
							; 5645	DFADJ2:	[T1]_Q,			;SAVE GUARD BITS
U 0473, 0453,3221,0017,4174,4006,2700,0000,0000,0000	; 5646		MUL DISP, J/DFADJ5	;LOOK AT LAST BIT
U 0476, 2036,3551,1313,4374,0007,0700,0000,0000,2000	; 5647		[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, J/DFADJ3
U 0477, 2037,3551,1313,4374,0007,0700,0000,0000,2000	; 5648		[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, J/DFADJ4
							; 5649	
							; 5650	=0
U 2036, 2036,3446,1616,4174,4047,0630,2000,0060,0000	; 5651	DFADJ3:	[T0]_[T0]*.5 LONG, ASHC, STEP SC, J/DFADJ3
U 2037, 0453,3221,0017,4174,4007,0700,0000,0000,0000	; 5652	DFADJ4:	[T1]_Q			;SAVE 2 GUARD BITS
							; 5653	=1011
U 0453, 3267,3446,1616,4174,4047,0700,0000,0000,0000	; 5654	DFADJ5:	[T0]_[T0]*.5 LONG, ASHC, J/DFADJ6
U 0457, 0453,3551,1313,4374,0007,0700,0000,0000,2000	; 5655		[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, J/DFADJ5
U 3267, 0001,3446,1616,4174,4044,1700,0000,0000,0000	; 5656	DFADJ6:	[T0]_[T0]*.5 LONG, ASHC, RETURN [1]
							; 5657	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 153
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFMP					

							; 5658	.TOC	"FLOATING POINT -- DFMP"
							; 5659	
							; 5660		.DCODE
D 0112, 1105,1631,1100					; 5661	112:	DBL FL-R,	DAC,	J/DFMP
							; 5662		.UCODE
							; 5663	
							; 5664	;SAME ENTRY CONDITIONS AS DFAD/DFSB
							; 5665	1631:
U 1631, 2040,3442,0400,4174,4007,0700,2000,0071,0006	; 5666	DFMP:	Q_[ARX], SC_6		;SHIFT MEM OP 8 PLACES
							; 5667	=0
							; 5668	DFMP1:	[AR]_[AR]*2 LONG, ASHC,	;SHIFT
U 2040, 2040,3444,0303,4174,4047,0630,2000,0060,0000	; 5669		STEP SC, J/DFMP1
U 2041, 3270,3446,1200,4174,4007,0700,0000,0000,0000	; 5670		Q_Q*.5
U 3270, 3271,4662,0000,4374,0007,0700,0000,0007,7777	; 5671		Q_Q.AND.#, #/077777, HOLD RIGHT
U 3271, 3272,3221,0005,4174,4007,0700,0000,0000,0000	; 5672		[BR]_Q			;COPY LOW WORD
							; 5673	;
							; 5674	; BRX * BR ==> C(E+1) * C(AC+1)
							; 5675	;
U 3272, 0623,4557,0006,1274,4007,0700,0000,0000,1441	; 5676		[BRX]_(AC[1].AND.[MAG])*.5 ;GET LOW AC
U 0623, 3020,3447,0606,4174,4007,0700,2010,0071,0043	; 5677	=0**	[BRX]_[BRX]*.5, SC_35., CALL [MULSB1]
							; 5678	;
							; 5679	; BRX * Q ==> C(E) * C(AC+1)
							; 5680	;
U 0627, 1012,3442,0300,4174,4007,0700,2000,0071,0043	; 5681		Q_[AR], SC_35. 		;GO MULT NEXT HUNK
U 1012, 3021,4443,0000,4174,4007,0700,0010,0000,0000	; 5682	=0**	CALL [MULTIPLY]
U 1016, 3273,3441,0416,4174,4007,0700,0000,0000,0000	; 5683		[T0]_[ARX]		;SAVE PRODUCT
U 3273, 3274,3227,0004,4174,4007,0700,2000,0011,0000	; 5684		[ARX]_Q*.5, SC_FE	;PUT IN NEXT STEP
							; 5685	;
							; 5686	; BRX * BR ==> C(AC) * C(E+1)
							; 5687	;
							; 5688		[BRX]_AC*.5,		;PREPARE TO DO HIGH HALF
							; 5689		FE_SC+EXP,		;EXPONENT ON ANSWER
U 3274, 2042,3777,0006,0274,4007,0521,1000,0040,2000	; 5690		SKIP DP0, 3T
U 2042, 1032,5547,0606,4374,4007,0701,0000,0077,7400	; 5691	=0	[BRX]_+SIGN*.5, 3T, J/DFMP2
U 2043, 1032,3547,0606,4374,4007,0701,0000,0077,7400	; 5692		[BRX]_-SIGN*.5, 3T
							; 5693	=0**
U 1032, 3021,3442,0500,4174,4007,0700,2010,0071,0043	; 5694	DFMP2:	Q_[BR], SC_35., CALL [MULTIPLY]	;GO MULTIPLY
U 1036, 3275,3221,0017,4174,4007,0700,0000,0000,0000	; 5695		[T1]_Q			;SAVE FOR ROUNDING
U 3275, 1062,0111,1604,4174,4007,0700,0000,0000,0000	; 5696		[ARX]_[ARX]+[T0]	;PREPARE FOR LAST MUL
							; 5697	;
							; 5698	; BRX * Q ==> C(AC) * C(E)
							; 5699	;
							; 5700	=0**	Q_[AR], SC_35., 	;DO THE LAST MULTIPLY
U 1062, 3021,3442,0300,4174,4007,0700,2010,0071,0043	; 5701		CALL [MULTIPLY]		; ..
							; 5702	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 154
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFMP					

							; 5703	;OK, WE NOW HAVE THE PRODUCT IN ARX!Q!T1. ALL WE NEED TO DO
							; 5704	; IS SOME BIT DIDDLES TO GET EVERYTHING IN THE RIGHT PLACE
							; 5705		[AR]_[ARX]*.5 LONG,	;SHIFT THE ANSWER
U 1066, 0243,3446,0403,4174,4007,0700,1000,0041,1576	; 5706		FE_FE+S#, S#/1576	;CORRECT EXPONENT
							; 5707	=0**11	READ [T1], SKIP AD.EQ.0, ;SEE IF LOW ORDER 1
U 0243, 2074,3333,0017,4174,4007,0621,0010,0000,0000	; 5708		CALL [SETSN]		; BITS AROUND SOMEPLACE
U 0263, 3276,3444,0303,4174,4047,0700,0000,0000,0000	; 5709		[AR]_[AR]*2 LONG, ASHC	;SHIFT LEFT
U 3276, 3277,3447,0705,4174,4007,0700,0000,0000,0000	; 5710		[BR]_[ONE]*.5		;PLACE TO INSTERT BITS
U 3277, 2044,4553,1700,4374,4007,0321,0000,0020,0000	; 5711		TL [T1], #/200000	;ANYTHING TO INJECT?
U 2044, 2045,0002,0500,4174,4007,0700,0000,0000,0000	; 5712	=0	Q_Q+[BR]		;YES--PUT IT IN
U 2045, 3300,3444,0303,4174,4047,0700,0000,0000,0000	; 5713		[AR]_[AR]*2 LONG, ASHC	;MAKE ROOM FOR MORE
U 3300, 2046,4553,1700,4374,4007,0321,0000,0010,0000	; 5714		TL [T1], #/100000	;ANOTHER BIT NEEDED
U 2046, 2047,0002,0500,4174,4007,0700,0000,0000,0000	; 5715	=0	Q_Q+[BR]		;YES--PUT IN LAST BIT
							; 5716	DNORM0:	READ [AR], NORM DISP,	;SEE WHAT WE NEED TO DO
U 2047, 0520,3333,0003,4174,4003,4701,1000,0041,0002	; 5717		FE_FE+S#, S#/2, J/DNORM	;ADJUST FOR INITIAL SHIFTS
							; 5718	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 155
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DFDV					

							; 5719	.TOC	"FLOATING POINT -- DFDV"
							; 5720	
							; 5721		.DCODE
D 0113, 1105,1636,1100					; 5722	113:	DBL FL-R,	DAC,	J/DFDV
							; 5723		.UCODE
							; 5724	1636:
U 1636, 0132,3441,0406,4174,4007,0700,0000,0000,0000	; 5725	DFDV:	[BRX]_[ARX]		;COPY OPERAND (COULD SAVE TIME
							; 5726					; WITH SEPERATE A-READ FOR DFDV)
U 0132, 2075,4221,0017,4174,4007,0700,0010,0000,0000	; 5727	=1**10	[T1]_0, CALL [CLRSN]	;CLEAR FLAG
							; 5728		[BR]_[AR], SKIP AD.LE.0, ;SEE IF POSITIVE
U 0133, 2050,3441,0305,1174,4007,0421,0000,0000,1441	; 5729		AC[1]			;WARM UP RAM
							; 5730	=0
							; 5731	DFDV1:	[ARX]_(AC[1].AND.[MAG])*.5, ;POSITIVE--GET AC
U 2050, 3303,4557,0004,1274,4007,0700,0000,0000,1441	; 5732		J/DFDV2			; AND CONTINUE BELOW
U 2051, 3301,7441,1717,4174,4007,0700,0000,0000,0000	; 5733		[T1]_.NOT.[T1]		;DV'SOR NEGATIVE (OR ZERO)
U 3301, 3302,2441,0606,4174,4007,0700,4000,0000,0000	; 5734		[BRX]_-[BRX]		;NEGATE LOW WORD
							; 5735		AD/-B-.25, B/BR, DEST/AD, ;NEGATE HIGH WORD
							; 5736		MULTI PREC/1, 3T,	;ADDING IN CRY02
							; 5737		SKIP DP0, AC[1],	;SEE IF STILL NEGATIVE
U 3302, 2050,2331,0005,1174,4007,0521,0040,0000,1441	; 5738		J/DFDV1			; ..
							; 5739	DFDV2:	[AR]_AC*.5,		;GET AC AND SHIFT
							; 5740		FE_SC-EXP, 3T,		;COMPUTE NEW EXPONENT
U 3303, 2052,3777,0003,0274,4007,0521,1000,0030,2000	; 5741		SKIP DP0		;SEE IF NEGATIVE
U 2052, 2054,5547,0303,4374,4007,0701,0000,0077,7400	; 5742	=0	[AR]_+SIGN*.5, 3T, J/DFDV3	;POSITIVE
U 2053, 3304,7441,1717,4174,4007,0700,0000,0000,0000	; 5743		[T1]_.NOT.[T1]		;NEGATIVE OR ZERO
U 3304, 3305,3547,0303,4374,4007,0701,0000,0077,7400	; 5744		[AR]_-SIGN*.5, 3T	;SIGN SMEAR
U 3305, 3306,2442,0400,4174,4007,0700,4000,0000,0000	; 5745		Q_-[ARX]		;NEGATE OPERAND
							; 5746		[AR]_(-[AR]-.25)*.5 LONG, ;NEGATE HIGH WORD
							; 5747		MULTI PREC/1,		;USE SAVED CARRY
U 3306, 2055,2446,0303,4174,4047,0700,0040,0000,0000	; 5748		ASHC, J/DFDV4		;CONTINUE BELOW
							; 5749	=0
							; 5750	DFDV3:	Q_[ARX],		;COPY OPERAND
U 2054, 3061,3442,0400,4174,4007,0700,0010,0000,0000	; 5751		CALL [DDIVS]		;SHIFT OVER
U 2055, 2056,2113,0305,4174,4007,0521,4000,0000,0000	; 5752	DFDV4:	[AR]-[BR], 3T, SKIP DP0	;SEE IF OVERFLOW
U 2056, 0555,4443,0000,4174,4467,0700,0000,0071,1000	; 5753	=0	FL NO DIVIDE
U 2057, 0734,3221,0004,4174,4007,0700,0000,0000,0000	; 5754		[ARX]_Q			;START DIVISION
U 0734, 1302,4222,0000,4174,4007,0700,2010,0071,0032	; 5755	=0*	Q_0, SC_26., CALL [DBLDIV]
U 0736, 1054,3221,0016,4174,4007,0700,2000,0071,0043	; 5756		[T0]_Q, SC_35.
							; 5757	=0*	Q_Q.AND.NOT.[MAG],	;SEE IF ODD
							; 5758		SKIP AD.EQ.0,		;SKIP IF EVEN
U 1054, 1302,5002,0000,4174,4007,0621,0010,0000,0000	; 5759		CALL [DBLDIV]		;GO DIVIDE
U 1056, 3307,3446,1200,4174,4007,0700,0000,0000,0000	; 5760		Q_Q*.5			;MOVE ANSWER OVER
							; 5761	=
							; 5762		[T0]_[T0]*2 LONG, ASHC, ;DO FIRST NORM STEP
U 3307, 0513,3444,1616,4174,4046,2700,0000,0000,0000	; 5763		MUL DISP		; SEE IF A 1 FELL OUT
							; 5764	=1011
							; 5765	DFDV4A:	READ [T1], SKIP DP0,	;SHOULD RESULT BE NEGATIVE
							; 5766		FE_S#-FE, S#/202,	;CORRECT EXPONENT
U 0513, 2060,3333,0017,4174,4007,0520,1000,0031,0202	; 5767		J/DFDV4B		;LOOK BELOW
U 0517, 0513,0222,0000,4174,4007,0700,4000,0000,0000	; 5768		Q_Q+.25, J/DFDV4A	;PUT BACK THE BIT
							; 5769	=0
U 2060, 0520,3441,1603,4174,4003,4701,0000,0000,0000	; 5770	DFDV4B:	[AR]_[T0], NORM DISP, J/DNORM ;PLUS
U 2061, 0200,3441,1603,4174,4003,4701,0000,0000,0000	; 5771		[AR]_[T0], NORM DISP, J/DNNORM ;MINUS
							; 5772	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 156
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DOUBLE PRECISION NORMALIZE		

							; 5773	.TOC	"FLOATING POINT -- DOUBLE PRECISION NORMALIZE"
							; 5774	
							; 5775	;NORMALIZE AR!Q
							; 5776	;DNORM0:	READ [AR], NORM DISP,	;SEE WHAT WE NEED TO DO
							; 5777	;	FE_FE+S#, S#/2, J/DNORM	;ADJUST FOR INITIAL SHIFTS
							; 5778	=0000
							; 5779	DNORM:	[AR]_[AR]*2 LONG,	;SHIFT LEFT
							; 5780		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 0520, 0520,3444,0303,4174,4043,4701,1000,0041,1777	; 5781		NORM DISP, J/DNORM	;TRY AGAIN
U 0521, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5782		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5783		READ [AR], NORM DISP,	;SEE IF WE WENT TOO FAR
U 0522, 0322,3333,0003,4174,4003,4701,0010,0000,0000	; 5784		CALL [DROUND]		; AND ROUND ANSWER
U 0523, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5785		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5786		[AR]_[AR]*.5 LONG, ASHC,
U 0524, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5787		FE_FE+1, CALL [DROUND]
U 0525, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5788		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5789		[AR]_[AR]*.5 LONG, ASHC,
U 0526, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5790		FE_FE+1, CALL [DROUND]
U 0527, 2064,4553,1300,4374,4007,0321,0000,0000,2000	; 5791		TL [FLG], FLG.SN/1, J/DNEG ;RESULT IS NEGATIVE
							; 5792		Q_[MAG].AND.Q,		;HIGH WORD IS ZERO
U 0530, 3311,4002,0000,4174,0007,0700,0000,0000,0000	; 5793		HOLD RIGHT, J/DNORM1	;GO TEST LOW WORD
U 0536, 3310,4221,0013,4174,4007,0700,0000,0000,0000	; 5794	=1110	[FLG]_0			;[122] CLEAR FLAG WORD
							; 5795	=
							; 5796		AC[1]_[ARX].AND.[MAG],	;STORE LOW WORD
U 3310, 1515,4113,0400,1174,4007,0700,0400,0000,1441	; 5797		J/STAC			;GO DO HIGH WORD
							; 5798	
							; 5799	
U 3311, 2062,3223,0000,4174,4007,0621,0000,0000,0000	; 5800	DNORM1:	READ Q, SKIP AD.EQ.0	;TEST LOW WORD
							; 5801	=0	[AR]_[AR]*2 LONG, 	;LOW WORD IS NON-ZERO
							; 5802		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 2062, 0520,3444,0303,4174,4043,4701,1000,0041,1777	; 5803		NORM DISP, J/DNORM	;KEEP LOOKING
U 2063, 1515,3440,0303,1174,4007,0700,0400,0000,1441	; 5804		AC[1]_[AR], J/STAC	;WHOLE ANSWER IS ZERO
							; 5805	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 157
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DOUBLE PRECISION NORMALIZE		

							; 5806	;HERE TO NORMALIZE NEGATIVE D.P. RESULTS
							; 5807	=0
U 2064, 3312,7222,0000,4174,4007,0700,0000,0000,0000	; 5808	DNEG:	Q_.NOT.Q, J/DNEG1	;ONES COMP
U 2065, 2066,2222,0000,4174,4007,0511,4000,0000,0000	; 5809		Q_-Q, SKIP CRY2, J/DNEG2
U 3312, 2066,4221,0013,4174,4007,0700,0000,0000,0000	; 5810	DNEG1:	[FLG]_0
							; 5811	=0
							; 5812	DNEG2:	[AR]_.NOT.[AR],		;NO CARRY
U 2066, 0200,7441,0303,4174,4003,4701,0000,0000,0000	; 5813		NORM DISP, J/DNNORM	;GO NORMALIZE
							; 5814		[AR]_-[AR],		;CARRY
U 2067, 0200,2441,0303,4174,4003,4701,4000,0000,0000	; 5815		NORM DISP, J/DNNORM	;NORMALIZE
							; 5816	
							; 5817	=000*
							; 5818	DNNORM:	[AR]_[AR]*2 LONG,	;SHIFT 1 PLACE
							; 5819		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 0200, 0200,3444,0303,4174,4043,4701,1000,0041,1777	; 5820		NORM DISP, J/DNNORM	;LOOP TILL DONE
							; 5821	=001*	READ [AR], NORM DISP,	;SEE IF WE WENT TOO FAR
U 0202, 0322,3333,0003,4174,4003,4701,0010,0000,0000	; 5822		CALL [DROUND]		; AND ROUND ANSWER
							; 5823	=010*	[AR]_[AR]*.5 LONG, ASHC,
U 0204, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5824		FE_FE+1, CALL [DROUND]
							; 5825	=011*	[AR]_[AR]*.5 LONG, ASHC,
U 0206, 0322,3446,0303,4174,4047,0700,1010,0041,0001	; 5826		FE_FE+1, CALL [DROUND]
							; 5827	=100*	Q_[MAG].AND.Q,		;HIGH WORD IS ZERO
U 0210, 3315,4002,0000,4174,0007,0700,0000,0000,0000	; 5828		HOLD RIGHT, J/DNNRM1	;GO TEST LOW WORD
U 0216, 0650,4111,1204,4174,4007,0700,0000,0000,0000	; 5829	=111*	[ARX]_[ARX].AND.[MASK]	;REMOVE ROUNDING BIT
							; 5830	=
							; 5831	=00	[ARX]_[ARX].AND.[MAG],	;ALSO CLEAR SIGN
U 0650, 3316,4111,0004,4174,4007,0700,0010,0000,0000	; 5832		CALL [CHKSN]		;ONES COMP?
							; 5833	=10	[ARX]_[ARX].XOR.[MAG],	;YES--ONES COMP
U 0652, 3313,6111,0004,4174,4007,0700,0000,0000,0000	; 5834		J/DNN1			;CONTINUE BELOW
							; 5835	=11	[ARX]_-[ARX], 3T,	;NEGATE RESULT
U 0653, 2070,2441,0404,4174,4007,0561,4000,0000,0000	; 5836		SKIP CRY1, J/DNN2
							; 5837	=
U 3313, 2070,4221,0013,4174,4007,0700,0000,0000,0000	; 5838	DNN1:	[FLG]_0			;CLEAR FLAG
							; 5839	=0
U 2070, 3314,7333,0003,0174,4007,0700,0400,0000,0000	; 5840	DNN2:	AC_.NOT.[AR], J/DNORM2
U 2071, 3314,2443,0300,0174,4007,0701,4400,0000,0000	; 5841		AC_-[AR], 3T
							; 5842	DNORM2:	AC[1]_[ARX].AND.[MAG],	;STORE LOW WORD
U 3314, 0100,4113,0400,1174,4156,4700,0400,0000,1441	; 5843		NEXT INST		;ALL DONE
							; 5844	
U 3315, 2072,3223,0000,4174,4007,0621,0000,0000,0000	; 5845	DNNRM1:	READ Q, SKIP AD.EQ.0	;TEST LOW WORD
							; 5846	=0	[AR]_[AR]*2 LONG, 	;LOW WORD IS NON-ZERO
							; 5847		FE_FE-1, ASHC,		;ADJUST EXPONENT
U 2072, 0200,3444,0303,4174,4043,4701,1000,0041,1777	; 5848		NORM DISP, J/DNNORM	;KEEP LOOKING
U 2073, 1515,3440,0303,1174,4007,0700,0400,0000,1441	; 5849		AC[1]_[AR], J/STAC	;WHOLE ANSWER IS ZERO
							; 5850	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 158
; FLT.MIC[1,2]	01:46 20-MAR-1981				FLOATING POINT -- DOUBLE PRECISION NORMALIZE		

U 3316, 0002,4553,1300,4374,4004,1321,0000,0000,2000	; 5851	CHKSN:	TL [FLG], FLG.SN/1, RETURN [2]
							; 5852	
							; 5853	;SUBROUTINE TO SET/CLEAR FLG.SN
							; 5854	;CALL WITH:
							; 5855	;	CALL [SETSN], SKIP IF WE SHOULD CLEAR
							; 5856	;RETURNS 23
							; 5857	=0
U 2074, 0023,3551,1313,4374,0004,1700,0000,0000,2000	; 5858	SETSN:	[FLG]_[FLG].OR.#, FLG.SN/1, HOLD RIGHT, RETURN [23]
U 2075, 0023,5551,1313,4374,0004,1700,0000,0000,2000	; 5859	CLRSN:	[FLG]_[FLG].AND.NOT.#, FLG.SN/1, HOLD RIGHT, RETURN [23]
							; 5860	
							; 5861	
							; 5862	;SUBROUTINE TO ROUND A FLOATING POINT NUMBER
							; 5863	;CALL WITH:
							; 5864	;	NUMBER IN AR!Q AND NORM DISP
							; 5865	;RETURNS 16 WITH ROUNDED NUMBER IN AR!ARX
							; 5866	;
							; 5867	=*01*
							; 5868	DROUND:	[ARX]_(Q+1)*.5,		;ROUND AND SHIFT
							; 5869		SKIP CRY2,		;SEE IF OVERFLOW
U 0322, 0462,0007,0704,4174,4007,0511,0000,0000,0000	; 5870		J/DRND1			;COMPLETE ROUNDING
							; 5871		[AR]_[AR]*.5 LONG,	;WE WENT TOO FAR
U 0326, 0322,3446,0303,4174,4047,0700,1000,0041,0001	; 5872		FE_FE+1, ASHC, J/DROUND	;SHIFT BACK AND ROUND
							; 5873	=*010
U 0462, 0016,3770,0303,4324,0454,1700,0000,0041,0000	; 5874	DRND1:	[AR]_EXP, RETURN [16]	;NO OVERFLOW
							; 5875	=011	[AR]_[AR]+.25,		;ADD CARRY (BITS 36 AND 37
							; 5876					; ARE COPIES OF Q BITS)
							; 5877		NORM DISP,		;SEE IF OVERFLOW
U 0463, 0462,0441,0303,4174,4003,4701,4000,0000,0000	; 5878		J/DRND1		; ..
							; 5879	=110	[AR]_[AR]*.5,		;SHIFT RIGHT
							; 5880		FE_FE+1,		;KEEP EXP RIGHT
U 0466, 0462,3447,0303,4174,4007,0700,1000,0041,0001	; 5881		J/DRND1		;ALL SET NOW
							; 5882	=
							; 5883	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 159
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DISPATCH ROM ENTRIES				

							; 5884	.TOC	"EXTEND -- DISPATCH ROM ENTRIES"
							; 5885	
							; 5886		.DCODE
D 0001, 0001,1740,2100					; 5887	001:	I,	SJCL,	J/L-CMS
D 0002, 0002,1740,2100					; 5888		I,	SJCE,	J/L-CMS
D 0003, 0003,1740,2100					; 5889		I,	SJCLE,	J/L-CMS
D 0004, 0002,1741,2100					; 5890		I,	B/2,	J/L-EDIT
D 0005, 0005,1740,2100					; 5891		I,	SJCGE,	J/L-CMS
D 0006, 0006,1740,2100					; 5892		I,	SJCN,	J/L-CMS
D 0007, 0007,1740,2100					; 5893		I,	SJCG,	J/L-CMS
							; 5894	
D 0010, 0001,1742,2100					; 5895	010:	I,	B/1,	J/L-DBIN	;CVTDBO
D 0011, 0004,1742,2100					; 5896		I,	B/4,	J/L-DBIN	;CVTDBT
D 0012, 0001,1743,2100					; 5897		I,	B/1,	J/L-BDEC	;CVTBDO
D 0013, 0000,1743,2100					; 5898		I,	B/0,	J/L-BDEC	;CVTBDT
							; 5899	
D 0014, 0001,1744,2100					; 5900	014:	I,	B/1,	J/L-MVS		;MOVSO
D 0015, 0000,1744,2100					; 5901		I,	B/0,	J/L-MVS		;MOVST
D 0016, 0002,1744,2100					; 5902		I,	B/2,	J/L-MVS		;MOVSLJ
D 0017, 0003,1744,2100					; 5903		I,	B/3,	J/L-MVS		;MOVSRJ	
							; 5904	
D 0020, 0000,1746,2100					; 5905	020:	I,		J/L-XBLT	;XBLT
D 0021, 0000,1747,2100					; 5906		I,		J/L-SPARE-A	;GSNGL
D 0022, 0000,1750,2100					; 5907		I,		J/L-SPARE-B	;GDBLE
D 0023, 0000,1751,2100					; 5908		I,	B/0,	J/L-SPARE-C	;GDFIX
D 0024, 0001,1751,2100					; 5909		I,	B/1,	J/L-SPARE-C	;GFIX
D 0025, 0002,1751,2100					; 5910		I,	B/2,	J/L-SPARE-C	;GDFIXR
D 0026, 0004,1751,2100					; 5911		I,	B/4,	J/L-SPARE-C	;GFIXR
D 0027, 0010,1751,2100					; 5912		I,	B/10,	J/L-SPARE-C	;DGFLTR
							; 5913	;30:					;GFLTR
							; 5914						;GFSC
							; 5915		.UCODE
							; 5916	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 160
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DISPATCH ROM ENTRIES				

							; 5917	1740:
U 1740, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5918	L-CMS:	LUUO
							; 5919	1741:
U 1741, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5920	L-EDIT:	LUUO
							; 5921	1742:
U 1742, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5922	L-DBIN:	LUUO
							; 5923	1743:
U 1743, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5924	L-BDEC:	LUUO
							; 5925	1744:
U 1744, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5926	L-MVS:	LUUO
							; 5927	1746:
U 1746, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5928	L-XBLT:	LUUO
							; 5929	1747:
U 1747, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5930	L-SPARE-A: LUUO
							; 5931	1750:
U 1750, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5932	L-SPARE-B: LUUO
							; 5933	1751:
U 1751, 0400,4751,1203,4374,4007,0700,0000,0000,0040	; 5934	L-SPARE-C: LUUO
							; 5935	
							; 5936	;NOTE: WE DO NOT NEED TO RESERVE 3746 TO 3751 BECAUSE THE CODE
							; 5937	;	AT EXTEND DOES A RANGE CHECK.
							; 5938	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 161
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- INSTRUCTION SET DECODING			

							; 5939	.TOC	"EXTEND -- INSTRUCTION SET DECODING"
							; 5940	
							; 5941	;EACH INSTRUCTION IN THE RANGE 1-23 GOES TO 1 OF 2 PLACES
							; 5942	; 1740-1747 IF NOT UNDER EXTEND
							; 5943	; 3740-3747 IF UNDER EXTEND
							; 5944	
							; 5945		.DCODE
D 0123, 0000,1467,3100					; 5946	123:	I,READ/1,		J/EXTEND
							; 5947		.UCODE
							; 5948	
							; 5949	1467:
U 1467, 2100,3771,0005,4365,5007,0700,0200,0000,0002	; 5950	EXTEND:	MEM READ, [BR]_MEM	;FETCH INSTRUCTION
							; 5951	=0**	TL [BR], #/760740,	;IN RANGE 0-17 (AND AC#=0)
U 2100, 3556,4553,0500,4374,4007,0321,0010,0076,0740	; 5952		CALL [BITCHK]		;TRAP IF NON-ZERO BITS FOUND
							; 5953		[BRX]_[HR].AND.# CLR RH, ;SPLIT OUT AC NUMBER
U 2104, 3317,4521,0206,4374,4007,0700,0000,0000,0740	; 5954		#/000740		; FROM EXTEND INSTRUCTION
							; 5955		[BR]_[BR].OR.[BRX],	;LOAD IR AND AC #
U 3317, 3320,3111,0605,4174,0417,0700,0000,0000,0000	; 5956		HOLD RIGHT, LOAD IR	; ..
							; 5957		READ [BR], LOAD BYTE EA,	;LOAD XR #
U 3320, 3321,3333,0005,4174,4217,0700,0000,0000,0500	; 5958		    J/EXTEA0			;COMPUTE E1
							; 5959	
U 3321, 3322,3333,0003,7174,4007,0700,0400,0000,0240	; 5960	EXTEA0:	WORK[E0]_[AR]
U 3322, 0170,4443,0000,2174,4006,6700,0000,0000,0000	; 5961	EXTEA1:	EA MODE DISP
							; 5962	=100*
U 0170, 0172,0551,0505,2270,4007,0700,0000,0000,0000	; 5963	EXTEA:	[BR]_[BR]+XR
							; 5964	EXTDSP:	[BR]_EA FROM [BR], LOAD VMA,
U 0172, 0556,5741,0505,4174,4003,7700,0200,0000,0010	; 5965		B DISP, J/EXTEXT
U 0174, 3323,0551,0505,2270,4007,0700,0200,0004,0512	; 5966		[BR]_[BR]+XR, START READ, PXCT EXTEND EA, LOAD VMA, J/EXTIND
U 0176, 3323,3443,0500,4174,4007,0700,0200,0004,0512	; 5967		VMA_[BR], START READ, PXCT EXTEND EA
							; 5968	
U 3323, 3322,3771,0005,4361,5217,0700,0200,0000,0502	; 5969	EXTIND:	MEM READ, [BR]_MEM, HOLD LEFT, LOAD BYTE EA, J/EXTEA1
							; 5970	
							; 5971	;HERE TO EXTEND SIGN FOR OFFSET MODES
							; 5972	=1110
							; 5973	EXTEXT:	WORK[E1]_[BR],			;SAVE E1
U 0556, 3400,3333,0005,7174,4001,2700,0400,0000,0241	; 5974		DISP/DROM, J/3400		;GO TO EXTENDED EXECUTE CODE
U 0557, 2076,3333,0005,4174,4007,0530,0000,0000,0000	; 5975		READ [BR], SKIP DP18		;NEED TO EXTEND SIGN
							; 5976	=0	WORK[E1]_[BR],			;POSITIVE
U 2076, 3400,3333,0005,7174,4001,2700,0400,0000,0241	; 5977		DISP/DROM, J/3400
							; 5978		[BR]_#, #/777777, HOLD RIGHT,	;NEGATIVE
U 2077, 0556,3771,0005,4374,0007,0700,0000,0077,7777	; 5979		J/EXTEXT
							; 5980	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 162
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- SETUP				

							; 5981	.TOC	"EXTEND -- MOVE STRING -- SETUP"
							; 5982	
							; 5983	;HERE TO MOVE A STRING
							; 5984	;COME HERE WITH:
							; 5985	;	AR/ E0
							; 5986	;	BR/ E1
							; 5987	;
							; 5988	3744:
							; 5989	MVS:	[AR]_[AR]+1,		;GO FETCH FILL
							; 5990		LOAD VMA,		; BYTE
							; 5991		START READ,		; ..
U 3744, 3516,0111,0703,4174,4007,0700,0210,0004,0012	; 5992		CALL [GTFILL]		;SUBROUTINE TO COMPLETE
U 3754, 2101,3771,0005,1276,6007,0701,0000,0000,1443	; 5993	3754:	[BR]_AC[DLEN]		;GET DEST LENGTH AND FLAGS
							; 5994	=0**	TL [BR], #/777000,	;ANY FLAGS SET?
U 2101, 3556,4553,0500,4374,4007,0321,0010,0077,7000	; 5995		CALL [BITCHK]		;SEE IF ILLEGAL
U 2105, 2102,3771,0003,0276,6007,0700,0000,0000,0000	; 5996		[AR]_AC			;GET SRC LENGTH AND FLAGS
							; 5997	=0	[BRX]_[AR].AND.# CLR RH, ;COPY FLAGS TO BRX
							; 5998		#/777000,		; ..
U 2102, 3520,4521,0306,4374,4007,0700,0010,0077,7000	; 5999		CALL [CLRFLG]		;CLEAR FLAGS IN AR
							; 6000					;NEW DLEN IS <SRC LEN>-<DST LEN>
							; 6001		AC[DLEN]_[AR]-[BR], 3T,	;COMPUTE DIFFERENCE
U 2103, 2106,2113,0305,1174,4007,0521,4400,0000,1443	; 6002		SKIP DP0		;WHICH IS SHORTER?
							; 6003	=0	[AR]_.NOT.[BR], 	;DESTINATION
U 2106, 3324,7441,0503,4174,4007,0700,0000,0000,0000	; 6004		J/MVS1			;GET NEGATIVE LENGTH
U 2107, 3324,7441,0303,4174,4007,0700,0000,0000,0000	; 6005		[AR]_.NOT.[AR]		;SOURCE
							; 6006	MVS1:	WORK[SLEN]_[AR],	; ..
U 3324, 0574,3333,0003,7174,4003,7700,0400,0000,0242	; 6007		B DISP			;SEE WHAT TYPE OF MOVE
							; 6008	;SLEN NOW HAS -<LEN OF SHORTER STRING>-1
							; 6009	=1100
U 0574, 0500,3771,0013,4370,4007,0700,0000,0000,0003	; 6010		STATE_[SRC], J/MOVELP	;TRANSLATE--ALL SET
U 0575, 3325,3771,0005,1276,6007,0701,0000,0000,1444	; 6011		[BR]_AC[DSTP], J/MVSO	;OFFSET BUILD MASK
							; 6012		[ARX]_[AR],		;LEFT JUSTIFY
U 0576, 3345,3441,0304,4174,4007,0700,0000,0000,0000	; 6013		J/MOVST0		; ..
							; 6014		[ARX]_AC[DLEN],		;RIGHT JUSTIFY
							; 6015		SKIP DP0, 4T,		;WHICH IS SHORTER?
U 0577, 0750,3771,0004,1276,6007,0522,0000,0000,1443	; 6016		J/MOVRJ
							; 6017	
U 3325, 3326,3333,0005,4174,4007,0700,1000,0041,6020	; 6018	MVSO:	READ [BR], FE_S+2	;GET DST BYTE SIZE
U 3326, 2110,4222,0000,4174,4006,7701,1000,0041,1770	; 6019		Q_0, BYTE STEP		;BUILD AN S BIT MASK
							; 6020	=0*
U 2110, 2110,4224,0003,4174,4026,7701,1000,0041,1770	; 6021	MVSO1:	GEN MSK [AR], BYTE STEP, J/MVSO1
U 2112, 3327,7221,0003,4174,4007,0700,0000,0000,0000	; 6022		[AR]_.NOT.Q		;BITS WHICH MUST NOT BE SET
							; 6023		WORK[MSK]_[AR].AND.[MASK], ;SAVE FOR SRCMOD
U 3327, 0507,4113,0312,7174,4007,0700,0400,0000,0243	; 6024		J/MOVLP0		;GO ENTER LOOP
							; 6025	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 163
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- OFFSET/TRANSLATE		

							; 6026	.TOC	"EXTEND -- MOVE STRING -- OFFSET/TRANSLATE"
							; 6027	
							; 6028	;HERE IS THE LOOP FOR OFFSET AND TRANSLATED MOVES
							; 6029	=000
							; 6030	MOVELP:	[AR]_WORK[SLEN]+1,	;UPDATE STRING LENGTH
U 0500, 1120,0551,0703,7274,4007,0701,0010,0000,0242	; 6031		CALL [SRCMOD]		;GET A SOURCE BYTE
							; 6032	=001	[ARX]_[AR], SKIP DP0,	;(1) LENGTH EXHAUSTED
U 0501, 1030,3441,0304,4174,4007,0520,0000,0000,0000	; 6033		J/MOVST2		;    SEE IF FILL IS NEEDED
							; 6034	=100	[AR]_-WORK[SLEN],	;(4) ABORT
U 0504, 3330,1771,0003,7274,4007,0701,4000,0000,0242	; 6035		J/MVABT			; ..
							; 6036		STATE_[SRC+DST],	;(5) NORMAL--STORE DST BYTE
U 0505, 3510,3771,0013,4370,4007,0700,0010,0000,0005	; 6037		CALL [PUTDST]		;     ..
							; 6038	=111
U 0507, 0500,3771,0013,4370,4007,0700,0000,0000,0003	; 6039	MOVLP0:	STATE_[SRC], J/MOVELP	;(7) DPB DONE
							; 6040	=
							; 6041	
							; 6042	;HERE TO ABORT A STRING MOVE DUE TO TRANSLATE OR OFFSET FAILURE
							; 6043	
							; 6044	MVABT:	[BR]_AC[DLEN], 		;WHICH STRING IS LONGER
U 3330, 2114,3771,0005,1276,6007,0522,0000,0000,1443	; 6045		SKIP DP0, 4T
							; 6046	=0
U 2114, 3331,3440,0303,1174,4007,0700,0400,0000,1443	; 6047	MVABT1:	AC[DLEN]_[AR], J/MVABT2	;PUT AWAY DEST LEN
							; 6048		[AR]_[AR]-[BR],		;DEST LEN WAS GREATER
U 2115, 2114,1111,0503,4174,4007,0700,4000,0000,0000	; 6049		J/MVABT1		;STICK BACK IN AC
							; 6050	
U 3331, 3332,7771,0003,7274,4007,0701,0000,0000,0242	; 6051	MVABT2:	[AR]_.NOT.WORK[SLEN]	;GET UNDECREMENTED SLEN
U 3332, 2116,3333,0005,4174,4007,0520,0000,0000,0000	; 6052		READ [BR], SKIP DP0	;NEED TO FIXUP SRC?
U 2116, 2117,0111,0503,4174,4007,0700,0000,0000,0000	; 6053	=0	[AR]_[AR]+[BR]		;SRC LONGER BY (DLEN)
U 2117, 3333,3111,0603,4174,4007,0700,0000,0000,0000	; 6054	MVEND:	[AR]_[AR].OR.[BRX]	;PUT BACK SRC FLAGS
U 3333, 1515,4221,0013,4170,4007,0700,0000,0000,0000	; 6055		END STATE, J/STAC	;ALL DONE
							; 6056	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 164
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- MOVSRJ				

							; 6057	.TOC	"EXTEND -- MOVE STRING -- MOVSRJ"
							; 6058	
							; 6059	=00
U 0750, 3334,3771,0003,1276,6007,0701,0000,0000,1441	; 6060	MOVRJ:	[AR]_AC[SRCP], J/MVSKP	;SRC LONGER, SKIP OVER SOME
							; 6061		STATE_[DSTF],		;DST LONGER, FILL IT
U 0751, 2307,3771,0013,4370,4007,0700,0010,0000,0006	; 6062		CALL [MOVFIL]		; ..
							; 6063	=11	[ARX]_WORK[SLEN]+1,	;DONE FILLING
U 0753, 3346,0551,0704,7274,4007,0701,0000,0000,0242	; 6064		J/MOVST1		;GO MOVE STRING
							; 6065	
							; 6066	;HERE TO SKIP OVER EXTRA SOURCE BYTES
U 3334, 2120,3440,0303,1174,4007,0670,0400,0000,1441	; 6067	MVSKP:	AC[SRCP]_[AR], SKIP -1MS ;[121] Is there a timer interrupt?
U 2120, 3337,3333,0003,7174,4007,0700,0400,0000,0211	; 6068	=0	WORK[SV.AR]_[AR], J/MVSK2 ;[121][123] Yes, save regs for interrupt.
							; 6069		[ARX]_[ARX]-1, 3T,	;DONE SKIPPING?
U 2121, 2122,1111,0704,4174,4007,0521,4000,0000,0000	; 6070		SKIP DP0
							; 6071	=0	IBP DP, IBP SCAD,	;NO--START THE IBP
							; 6072		SCAD DISP, SKIP IRPT,	;4-WAY DISPATCH
U 2122, 1020,3770,0305,4334,4016,7371,0000,0033,6000	; 6073		3T, J/MVSKP1		;GO BUMP POINTER
							; 6074		AC[DLEN]_0,		;LENGTHS ARE NOW EQUAL
U 2123, 0546,4223,0000,1174,4007,0700,0400,0000,1443	; 6075		J/MOVST4		;GO MOVE STRING
							; 6076	
							; 6077	=00
U 1020, 3334,3441,0503,4174,4007,0700,0000,0000,0000	; 6078	MVSKP1:	[AR]_[BR], J/MVSKP	;NO OVERFLOW
							; 6079		[AR]_.NOT.WORK[SLEN],	;INTERRUPT
U 1021, 3335,7771,0003,7274,4007,0701,0000,0000,0242	; 6080		J/MVSK3			; ..
							; 6081		SET P TO 36-S,		;WORD OVERFLOW
U 1022, 3336,3770,0503,4334,4017,0700,0000,0032,6000	; 6082		J/MVSKP2		;FIXUP Y
U 1023, 3335,7771,0003,7274,4007,0701,0000,0000,0242	; 6083		[AR]_.NOT.WORK[SLEN]	;[121] INTERRUPT or timer.
U 3335, 2124,3440,0303,1174,4007,0700,0400,0000,1443	; 6084	MVSK3:	AC[DLEN]_[AR]		;RESET DLEN
							; 6085	=0	[AR]_[AR]+[ARX],
U 2124, 3724,0111,0403,4174,4007,0700,0010,0000,0000	; 6086		CALL [INCAR]		;ADD 1 TO AR
							; 6087		AC_[AR].OR.[BRX],	;PUT BACK FLAGS
U 2125, 3767,3113,0306,0174,4007,0700,0400,0000,0000	; 6088		J/ITRAP			;DO INTERRUPT TRAP
							; 6089	
							; 6090	MVSKP2:	[AR]_[AR]+1, HOLD LEFT,	;BUMP Y
U 3336, 3334,0111,0703,4170,4007,0700,0000,0000,0000	; 6091		J/MVSKP		;KEEP GOING
							; 6092	
							; 6093					;BEGIN EDIT [123]
U 3337, 3340,3333,0005,7174,4007,0700,0400,0000,0213	; 6094	MVSK2:	WORK[SV.BR]_[BR]	;SAVE ALL
U 3340, 3341,3333,0004,7174,4007,0700,0400,0000,0212	; 6095		WORK[SV.ARX]_[ARX]	;THE REGISTERS
U 3341, 2111,3333,0006,7174,4007,0700,0400,0000,0214	; 6096		WORK[SV.BRX]_[BRX]	;FOR THE TICK
U 2111, 3620,4443,0000,4174,4007,0700,0010,0000,0000	; 6097	=0*	CALL [TICK]		;UPDATE CLOCK AND SET INTERUPT
U 2113, 3342,3771,0003,7274,4007,0701,0000,0000,0211	; 6098		[AR]_WORK[SV.AR]	;NOW PUT
U 3342, 3343,3771,0005,7274,4007,0701,0000,0000,0213	; 6099		[BR]_WORK[SV.BR]	;THEM ALL
U 3343, 3344,3771,0004,7274,4007,0701,0000,0000,0212	; 6100		[ARX]_WORK[SV.ARX]	;BACK SO WE
							; 6101		[BRX]_WORK[SV.BRX],	;CAN CONTINUE
U 3344, 3334,3771,0006,7274,4007,0701,0000,0000,0214	; 6102			J/MVSKP
							; 6103					;END EDIT [123]
							; 6104	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 165
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- MOVE STRING -- SIMPLE MOVE LOOP		

							; 6105	.TOC	"EXTEND -- MOVE STRING -- SIMPLE MOVE LOOP"
							; 6106	
							; 6107	;HERE FOR NO-MODIFICATION STRING MOVES
U 3345, 3346,0111,0704,4174,4007,0700,0000,0000,0000	; 6108	MOVST0:	[ARX]_[ARX]+1		;CANT DO [ARX]_[AR]+1
U 3346, 0540,3771,0013,4370,4007,0700,0000,0000,0003	; 6109	MOVST1:	STATE_[SRC]		;PREPARE FOR PAGE FAIL
							; 6110	=000
							; 6111		WORK[SLEN]_[ARX],	;GO GET A SOURCE BYTE
U 0540, 2320,3333,0004,7174,4007,0520,0410,0000,0242	; 6112		SKIP DP0, CALL [GSRC]	; ..
							; 6113	MOVSTX:	[ARX]_[AR],		;SHORT STRING RAN OUT
U 0541, 1030,3441,0304,4174,4007,0520,0000,0000,0000	; 6114		SKIP DP0, J/MOVST2	;GO SEE IF FILL NEEDED
							; 6115	=010	STATE_[SRC+DST],	;WILL NEED TO BACK UP BOTH POINTERS
U 0542, 3510,3771,0013,4370,4007,0700,0010,0000,0005	; 6116		CALL [PUTDST]		;STORE BYTE
							; 6117	=110
							; 6118	MOVST4:	[ARX]_WORK[SLEN]+1,	;COUNT DOWN LENGTH
U 0546, 3346,0551,0704,7274,4007,0701,0000,0000,0242	; 6119		J/MOVST1		;LOOP OVER STRING
							; 6120	=
							; 6121	=00
U 1030, 3347,4223,0000,1174,4007,0700,0400,0000,1443	; 6122	MOVST2:	AC[DLEN]_0, J/MOVST3	;CLEAR DEST LEN, REBUILD SRC
U 1031, 2307,3771,0013,4370,4007,0700,0010,0000,0004	; 6123		STATE_[DST], CALL [MOVFIL] ;FILL OUT DEST
U 1033, 2167,3440,0606,0174,4007,0700,0400,0000,0000	; 6124	=11	AC_[BRX], J/ENDSKP	;ALL DONE
							; 6125	
U 3347, 3350,3113,0406,0174,4007,0700,0400,0000,0000	; 6126	MOVST3:	AC_[ARX].OR.[BRX]	;REBUILD SRC
U 3350, 0252,4221,0013,4170,4007,0700,0000,0000,0000	; 6127		END STATE, J/SKIPE	; ..
							; 6128	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 166
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- COMPARE STRING				

							; 6129	.TOC	"EXTEND -- COMPARE STRING"
							; 6130	
							; 6131	3740:
U 3740, 2130,3771,0004,1276,6007,0701,0000,0000,1443	; 6132	CMS:	[ARX]_AC[DLEN]		;GET DEST LEN
U 2130, 3556,4553,0400,4374,4007,0321,0010,0077,7000	; 6133	=0**	TL [ARX], #/777000, CALL [BITCHK]
U 2134, 2131,3771,0006,0276,6007,0700,0000,0000,0000	; 6134		[BRX]_AC		;GET SRC LEN
U 2131, 3556,4553,0600,4374,4007,0321,0010,0077,7000	; 6135	=0**	TL [BRX], #/777000, CALL [BITCHK]
U 2135, 2126,2113,0604,4174,4007,0521,4000,0000,0000	; 6136		[BRX]-[ARX], 3T, SKIP DP0 ;WHICH STRING IS LONGER?
U 2126, 2127,0111,0703,4174,4007,0700,0000,0000,0000	; 6137	=0	[AR]_[AR]+1		;SRC STRING IS LONGER
U 2127, 2132,0111,0703,4170,4007,0700,0200,0004,0012	; 6138		VMA_[AR]+1, START READ	;DST STRING
							; 6139	=0	[AR]_0,			;FORCE FIRST COMPARE TO BE
							; 6140					;EQUAL
U 2132, 3722,4221,0003,4174,4007,0700,0010,0000,0000	; 6141		CALL [LOADQ]		;PUT FILL INTO Q
							; 6142		WORK[FILL]_Q,		;SAVE FILLER
U 2133, 3360,3223,0000,7174,4007,0700,0400,0000,0244	; 6143		J/CMS2			;ENTER LOOP
							; 6144	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 167
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- COMPARE STRING				

							; 6145	;HERE IS THE COMPARE LOOP.
							; 6146	; ARX/ CONATINS REMAINING DEST LENGTH
							; 6147	; BRX/ CONTAINS REMAINING SOURCE LENGTH
							; 6148	=0
							; 6149	CMS3:				;BYTES ARE NOT EQUAL
							; 6150		END STATE,		;NO MORE SPECIAL PAGE FAIL ACTION
U 2136, 0250,4221,0013,4170,4003,7700,0000,0000,0000	; 6151		SKIP-COMP DISP		;SEE SKIP-COMP-TABLE
U 2137, 3351,3771,0003,1276,6007,0701,0000,0000,1441	; 6152	CMS4:	[AR]_AC[SRCP]		;GET BYTE POINTER
U 3351, 1050,3333,0006,4174,4007,0520,0000,0000,0000	; 6153		READ [BRX], SKIP DP0	;MORE IN SOURCE STRING?
							; 6154	=00	STATE_[EDIT-SRC],	;PREPARE FOR PAGE FAIL
U 1050, 2321,3771,0013,4370,4007,0700,0010,0000,0011	; 6155		CALL [GETSRC]		; GO GET BYTE
							; 6156		READ [ARX], SKIP DP0,	;NO MORE SRC--SEE IF MORE DEST
U 1051, 2140,3333,0004,4174,4007,0520,0000,0000,0000	; 6157		J/CMS5			; ..
U 1052, 3352,3333,0003,7174,4007,0700,0400,0000,0245	; 6158		WORK[CMS]_[AR]		;SAVE SRC BYTE
							; 6159	=
U 3352, 3353,3440,0606,0174,4007,0700,0400,0000,0000	; 6160		AC_[BRX]		;PUT BACK SRC LEN
U 3353, 3354,3771,0013,4370,4007,0700,0000,0000,0010	; 6161		STATE_[COMP-DST]	;HAVE TO BACK UP IF DST FAILS
U 3354, 1074,3333,0004,4174,4007,0520,0000,0000,0000	; 6162		READ [ARX], SKIP DP0	;ANY MORE DEST?
							; 6163	=00
U 1074, 2142,4443,0000,4174,4007,0700,0010,0000,0000	; 6164	CMS6:	CALL [CMPDST]		;MORE DEST BYTES
							; 6165		[AR]_WORK[FILL],	;OUT OF DEST BYTES
U 1075, 3355,3771,0003,7274,4007,0701,0000,0000,0244	; 6166		J/CMS7			;GO DO COMPARE
U 1076, 3355,3440,0404,1174,4007,0700,0400,0000,1443	; 6167		AC[DLEN]_[ARX]		;GOT A BYTE, UPDATE LENGTH
							; 6168	=
							; 6169	CMS7:	[AR]_[AR].AND.[MASK],	;MAKE MAGNITUDES
U 3355, 3356,4111,1203,7174,4007,0700,0000,0000,0245	; 6170		WORK[CMS]		;WARM UP RAM
U 3356, 3357,4551,1205,7274,4007,0700,0000,0000,0245	; 6171		[BR]_[MASK].AND.WORK[CMS], 2T ;GET SRC MAGNITUDE
U 3357, 3360,2111,0503,4174,4007,0700,4000,0000,0000	; 6172		[AR]_[BR]-[AR] REV	;UNSIGNED COMPARE
U 3360, 3361,1111,0704,4174,4007,0700,4000,0000,0000	; 6173	CMS2:	[ARX]_[ARX]-1		;UPDATE LENGTHS
U 3361, 3362,1111,0706,4174,4007,0700,4000,0000,0000	; 6174		[BRX]_[BRX]-1		; ..
U 3362, 2136,3333,0003,4174,4007,0621,0000,0000,0000	; 6175		READ [AR], SKIP AD.EQ.0, J/CMS3 ;SEE IF EQUAL
							; 6176	
							; 6177	=0
U 2140, 3363,3772,0000,7274,4007,0701,0000,0000,0244	; 6178	CMS5:	Q_WORK[FILL], J/CMS8	;MORE DST--GET SRC FILL
U 2141, 2136,4221,0003,4174,4007,0700,0000,0000,0000	; 6179		[AR]_0, J/CMS3		;STRINGS ARE EQUAL
U 3363, 3364,3771,0013,4370,4007,0700,0000,0000,0012	; 6180	CMS8:	STATE_[EDIT-DST]	;JUST DST POINTER ON PAGE FAIL
U 3364, 1074,3223,0000,7174,4007,0700,0400,0000,0245	; 6181		WORK[CMS]_Q, J/CMS6	;MORE DST--SAVE SRC FILL
							; 6182	
							; 6183	=0
							; 6184	CMPDST:	[AR]_AC[DSTP],		;GET DEST POINTER
U 2142, 3511,3771,0003,1276,6007,0701,0010,0000,1444	; 6185		CALL [IDST]		;UPDATE IT
							; 6186		READ [AR],		;LOOK AT BYTE POINTER
							; 6187		FE_FE.AND.S#, S#/0770,	;MASK OUT BIT 6
U 2143, 0340,3333,0003,4174,4006,5701,1000,0051,0770	; 6188		BYTE DISP, J/LDB1	;GO LOAD BYTE
							; 6189	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 168
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6190	.TOC	"EXTEND -- DECIMAL TO BINARY CONVERSION"
							; 6191	
							; 6192	3742:
U 3742, 3365,4571,1203,4374,4007,0700,0000,0077,7777	; 6193	DBIN:	[AR]_[777777] XWD 0	;IF WE ARE IN OFFSET MODE
U 3365, 3366,3333,0003,7174,4007,0700,0400,0000,0243	; 6194		WORK[MSK]_[AR]		; ONLY ALLOW 18 BITS
							; 6195					;RANGE CHECKED (0-10) LATER
U 3366, 3367,3771,0003,0276,6007,0700,0000,0000,0000	; 6196		[AR]_AC			;GET SRC LENGTH
							; 6197		[BRX]_[AR].AND.# CLR RH, ;SPLIT OUT FLAGS
U 3367, 2144,4521,0306,4374,4007,0700,0000,0077,7000	; 6198		#/777000		; ..
							; 6199	=0*	[ARX]_AC[BIN1],		;GET LOW WORD
U 2144, 2240,3771,0004,1276,6007,0701,0010,0000,1444	; 6200		CALL [CLARX0]		;CLEAR BIT 0 OF ARX
U 2146, 2150,3440,0404,1174,4007,0700,0400,0000,1444	; 6201		AC[BIN1]_[ARX]		;STORE BACK
							; 6202	=0	READ [BRX], SKIP DP0,	;IS S ALREADY SET?
U 2150, 2174,3333,0006,4174,4007,0520,0010,0000,0000	; 6203		CALL [CLRBIN]		;GO CLEAR BIN IF NOT
							; 6204		[AR]_[AR].AND.#,	;CLEAR FLAGS FROM LENGTH
							; 6205		#/000777, HOLD RIGHT,	; ..
U 2151, 0616,4551,0303,4374,0003,7700,0000,0000,0777	; 6206		B DISP			;SEE IF OFFSET OR TRANSLATE
							; 6207	=1110
U 0616, 3370,3771,0013,4370,4007,0700,0000,0000,0007	; 6208	DBIN1:	STATE_[CVTDB], J/DBIN2	;TRANSLATE--LEAVE S ALONE
							; 6209		[BRX]_[BRX].OR.#,	;OFFSET--FORCE S TO 1
							; 6210		#/400000, HOLD RIGHT,
U 0617, 0616,3551,0606,4374,0007,0700,0000,0040,0000	; 6211		J/DBIN1
U 3370, 0460,7333,0003,7174,4007,0700,0400,0000,0242	; 6212	DBIN2:	WORK[SLEN]_.NOT.[AR]	;STORE -SLEN-1
							; 6213	
							; 6214	;HERE IS THE MAIN LOOP
							; 6215	=0*0
U 0460, 1120,0551,0703,7274,4007,0701,0010,0000,0242	; 6216	DBINLP:	[AR]_WORK[SLEN]+1, CALL [SRCMOD] ;(0) GET MODIFIED SRC BYTE
							; 6217		TL [BRX], #/100000,	;(1) DONE, IS M SET?
U 0461, 2162,4553,0600,4374,4007,0321,0000,0010,0000	; 6218		J/DBXIT
							; 6219		[AR]_.NOT.WORK[SLEN],	;(4) ABORT
U 0464, 3375,7771,0003,7274,4007,0701,0000,0000,0242	; 6220		J/DBABT			;	..
							; 6221		[AR]-#, #/10.,		;(5) NORMAL--SEE IF 0-9
U 0465, 2152,1553,0300,4374,4007,0532,4000,0000,0012	; 6222		4T, SKIP DP18		; ..
							; 6223	=0	[AR]_.NOT.WORK[SLEN],	;DIGIT TOO BIG
U 2152, 3375,7771,0003,7274,4007,0701,0000,0000,0242	; 6224		J/DBABT			;GO ABORT CVT
							; 6225	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 169
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6226	;HERE TO ADD IN A DIGIT
							; 6227		[BR]_AC[BIN0], 4T,	;GET HIGH BINARY
U 2153, 1114,3771,0005,1276,6007,0622,0000,0000,1443	; 6228		SKIP AD.EQ.0		;SEE IF SMALL
							; 6229	=00
							; 6230	DBSLO:	[ARX]_AC[BIN1],		;TOO BIG
U 1114, 0560,3771,0004,1276,6007,0701,0010,0000,1444	; 6231		CALL [DBSLOW]		;GO USE DOUBLE PRECISION PATHS
							; 6232		[BR]_AC[BIN1],		;GET LOW WORD
U 1115, 3371,3771,0005,1276,6007,0701,0000,0000,1444	; 6233		J/DBFAST		;MIGHT FIT IN 1 WORD
U 1116, 0460,4443,0000,4174,4007,0700,0000,0000,0000	; 6234		J/DBINLP		;RETURN FROM DBSLOW
							; 6235					;GO DO NEXT DIGIT
							; 6236	=
U 3371, 2154,4553,0500,4374,4007,0321,0000,0076,0000	; 6237	DBFAST:	TL [BR], #/760000	;WILL RESULT FIT IN 36 BITS?
U 2154, 1114,4443,0000,4174,4007,0700,0000,0000,0000	; 6238	=0	J/DBSLO			;MAY NOT FIT--USE DOUBLE WORD
U 2155, 3372,3775,0005,1276,6007,0701,0000,0000,1444	; 6239		[BR]_AC[BIN1]*2		;COMPUTE AC*2
U 3372, 2156,3445,0505,1174,4007,0700,0000,0000,1444	; 6240		[BR]_[BR]*2, AC[BIN1]	;COMPUTE AC*4
							; 6241	=0	[BR]_[BR]+AC[BIN1], 2T,	;COMPUTE AC*5
U 2156, 3725,0551,0505,1274,4007,0700,0010,0000,1444	; 6242		CALL [SBRL]		;COMPUTE AC*10
							; 6243		AC[BIN1]_[AR]+[BR], 3T,	;NEW BINARY RESULT
U 2157, 0460,0113,0305,1174,4007,0701,0400,0000,1444	; 6244		J/DBINLP		;DO NEXT DIGIT
							; 6245	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 170
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6246	;HERE IF NUMBER DOES NOT FIT IN ONE WORD
							; 6247	
							; 6248	=000
							; 6249	DBSLOW:	[BR]_AC[BIN0],		;FETCH HIGH WORD
U 0560, 0620,3771,0005,1276,6007,0701,0010,0000,1443	; 6250		CALL [MULBY4]		;MULTIPLY BY 4
							; 6251		[ARX]_[ARX]+AC[BIN1],	;COMPUTE VALUE * 5
							; 6252		SKIP CRY1, 4T,		;SEE IF OVERFLOW
U 0561, 2160,0551,0404,1274,4007,0562,0010,0000,1444	; 6253		CALL [ADDCRY]		;GO ADD CARRY
U 0565, 0600,0551,0505,1274,4007,0701,0000,0000,1443	; 6254	=101	[BR]_[BR]+AC[BIN0]	;ADD IN HIGH WORD
							; 6255	=
U 0600, 0621,4443,0000,4174,4007,0700,0010,0000,0000	; 6256	=000	CALL [DBLDBL]		;MAKE * 10
							; 6257		[ARX]_[ARX]+[AR], 3T,	;ADD IN NEW DIGIT
							; 6258		SKIP CRY1,		;SEE IF OVERFLOW
U 0601, 2160,0111,0304,4174,4007,0561,0010,0000,0000	; 6259		CALL [ADDCRY]		;ADD IN THE CARRY
U 0605, 3373,3440,0404,1174,4007,0700,0400,0000,1444	; 6260	=101	AC[BIN1]_[ARX]		;PUT BACK ANSWER
							; 6261	=
							; 6262		AC[BIN0]_[BR],		; ..
U 3373, 0002,3440,0505,1174,4004,1700,0400,0000,1443	; 6263		RETURN [2]		;GO DO NEXT BYTE
							; 6264	
							; 6265	;HERE TO DOUBLE BR!ARX
							; 6266	=000
U 0620, 0621,4443,0000,4174,4007,0700,0010,0000,0000	; 6267	MULBY4:	CALL [DBLDBL]		;DOUBLE TWICE
U 0621, 0622,0111,0505,4174,4007,0700,0000,0000,0000	; 6268	DBLDBL:	[BR]_[BR]+[BR]		;DOUBLE HIGH WORD FIRST
							; 6269					;(SO WE DON'T DOUBLE CARRY)
							; 6270		[ARX]_[ARX]+[ARX],	;DOUBLE LOW WORD
							; 6271		SKIP CRY1, 3T,		;SEE IF CARRY
U 0622, 2160,0111,0404,4174,4007,0561,0010,0000,0000	; 6272		CALL [ADDCRY]		;ADD IN CARRY
U 0626, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 6273	=110	RETURN [1]		;ALL DONE
							; 6274	=
							; 6275	
							; 6276	;HERE TO ADD THE CARRY
							; 6277	=0
U 2160, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 6278	ADDCRY:	RETURN [4]		;NO CARRY
U 2161, 3374,4551,0404,4374,0007,0700,0000,0037,7777	; 6279		CLEAR [ARX]0		;KEEP LOW WORD POSITIVE
							; 6280		[BR]_[BR]+1,		;ADD CARRY
U 3374, 0004,0111,0705,4174,4004,1700,0000,0000,0000	; 6281		RETURN [4]		;ALL DONE
							; 6282	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 171
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- DECIMAL TO BINARY CONVERSION			

							; 6283	;HERE TO ABORT CONVERSION
U 3375, 3376,3111,0306,4174,4007,0700,0000,0000,0000	; 6284	DBABT:	[BRX]_[BRX].OR.[AR]	;PUT BACK UNUSED LENGTH
							; 6285		[PC]_[PC]-1, HOLD LEFT,	;DO NOT SKIP
U 3376, 2163,1111,0701,4170,4007,0700,4000,0000,0000	; 6286		J/DBDONE		;GO FIX UP SIGN COPY
							; 6287	
							; 6288	;HERE AT END
							; 6289	=0
							; 6290	DBXIT:	[ARX]_AC[BIN1],		;GET LOW WORD
U 2162, 3401,3771,0004,1276,6007,0701,0000,0000,1444	; 6291		J/DBNEG			;GO NEGATE
U 2163, 3377,3771,0003,1276,6007,0701,0000,0000,1444	; 6292	DBDONE:	[AR]_AC[BIN1]		;FETCH LOW WORD
							; 6293		[BR]_AC[BIN0], 4T,	;GET HIGH WORD
U 3377, 2164,3771,0005,1276,6007,0522,0000,0000,1443	; 6294		SKIP DP0		;WHAT SIGN
U 2164, 3400,4551,0303,4374,0007,0700,0000,0037,7777	; 6295	=0	CLEAR [AR]0, J/DBDN1	;POSITIVE
U 2165, 3400,3551,0303,4374,0007,0700,0000,0040,0000	; 6296		[AR]_[AR].OR.#, #/400000, HOLD RIGHT
U 3400, 2166,3440,0303,1174,4007,0700,0400,0000,1444	; 6297	DBDN1:	AC[BIN1]_[AR]		;STORE AC BACK
							; 6298	=0	AC_[BRX] TEST,	;RETURN FLAGS
U 2166, 2174,3770,0606,0174,4007,0520,0410,0000,0000	; 6299		SKIP DP0, CALL [CLRBIN]	;CLEAR BIN IS S=0
U 2167, 0260,4221,0013,4170,4007,0700,0000,0000,0000	; 6300	ENDSKP:	END STATE, J/SKIP	;NO--ALL DONE
							; 6301	
U 3401, 3402,4551,0404,4374,0007,0700,0000,0037,7777	; 6302	DBNEG:	CLEAR ARX0		;CLEAR EXTRA SIGN BIT
							; 6303		[ARX]_-[ARX], 3T,	;NEGATE AND SEE IF
U 3402, 2170,2441,0404,1174,4007,0621,4000,0000,1443	; 6304		SKIP AD.EQ.0, AC[BIN0]	; ANY CARRY
U 2170, 2173,7771,0003,1274,4007,0700,0000,0000,1443	; 6305	=0	[AR]_.NOT.AC[BIN0], 2T, J/STAC34 ;NO CARRY
							; 6306		[AR]_-AC[BIN0], 3T,	;CARRY
U 2171, 2172,1771,0003,1274,4007,0621,4000,0000,1443	; 6307		SKIP AD.EQ.0		;SEE IF ALL ZERO
U 2172, 2173,4571,1204,4374,4007,0700,0000,0040,0000	; 6308	=0	[ARX]_[400000] XWD 0	;MAKE COPY OF SIGN
							; 6309					; UNLESS HIGH WORD IS ZERO
U 2173, 3403,3440,0303,1174,4007,0700,0400,0000,1443	; 6310	STAC34:	AC[BIN0]_[AR]		;PUT BACK ANSWER
U 3403, 2163,3440,0404,1174,4007,0700,0400,0000,1444	; 6311		AC[BIN1]_[ARX], J/DBDONE	; ..
							; 6312	
							; 6313	;HELPER SUBROUTINE TO CLEAR AC[BIN0] AND AC[BIN1] IF S=0
							; 6314	;CALL WITH:
							; 6315	;	READ [BRX], SKIP DP0, CALL [CLRBIN]
							; 6316	;RETURNS 1 ALWAYS
							; 6317	=0
U 2174, 3404,4223,0000,1174,4007,0700,0400,0000,1443	; 6318	CLRBIN:	AC[BIN0]_0, J/CLRB1
U 2175, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 6319		RETURN [1]
U 3404, 0001,4223,0000,1174,4004,1700,0400,0000,1444	; 6320	CLRB1:	AC[BIN1]_0, RETURN [1]
							; 6321	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 172
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6322	.TOC	"EXTEND -- BINARY TO DECIMAL CONVERSION"
							; 6323	
							; 6324	3743:
							; 6325	BDEC:	[BRX]_AC[DLEN],		;GET LENGTH AND FLAGS
U 3743, 2176,3771,0006,1276,6007,0351,0000,0000,1443	; 6326		SKIP FPD		;CONTINUE FROM INTERUPT?
							; 6327	=0	[BRX]_[BRX].AND.#,	;JUST KEEP THE FLAGS
							; 6328		#/777000,		; ..
U 2176, 3405,4551,0606,4374,4007,0700,0000,0077,7000	; 6329		J/BDEC0			;COMPUTE NEW FLAGS
U 2177, 3423,3771,0003,0276,6007,0700,0000,0000,0000	; 6330	DOCVT:	[AR]_AC, J/DOCVT1	;ALL SET PRIOR TO TRAP
U 3405, 3406,3771,0004,1276,6007,0701,0000,0000,1441	; 6331	BDEC0:	[ARX]_AC[1]		;GET LOW BINARY
U 3406, 2145,3771,0003,0276,6007,0700,2000,0071,0024	; 6332		[AR]_AC, SC_20.		;GET HIGH WORD, SET STEP COUNT
							; 6333	=0*	WORK[BDL]_[ARX],	;SAVE IN CASE OF ABORT
U 2145, 2240,3333,0004,7174,4007,0700,0410,0000,0250	; 6334		CALL [CLARX0]		;MAKE SURE BIT 0 IS OFF
							; 6335		WORK[BDH]_[AR],		;SAVE HIGH WORD AND
U 2147, 2200,3333,0003,7174,4007,0520,0400,0000,0247	; 6336		SKIP DP0		; TEST SIGN
							; 6337	=0
							; 6338	BDEC1:	[BRX]_0, HOLD LEFT,	;POSITIVE, CLEAR RH OF BRX
U 2200, 2210,4221,0006,4170,4007,0700,0000,0000,0000	; 6339		J/BDEC3			;COMPUTE # OF DIGITS REQUIRED
							; 6340		[BRX]_[BRX].OR.#, 	;NEGATIVE, SET M
U 2201, 2204,3551,0606,4374,0007,0700,0000,0010,0000	; 6341		#/100000, HOLD RIGHT	; ..
							; 6342	=0*
U 2204, 3110,4551,0404,4374,0007,0700,0010,0037,7777	; 6343	BDEC2:	CLEAR ARX0, CALL [DBLNG1] ;NEGATE AR!ARX
							; 6344		AC_[AR] TEST,		;PUT BACK ANSWER
U 2206, 2202,3770,0303,0174,4007,0520,0400,0000,0000	; 6345		SKIP DP0		;IF STILL MINUS WE HAVE
							; 6346					; 1B0, AND NO OTHER BITS
U 2202, 2200,3440,0404,1174,4007,0700,0400,0000,1441	; 6347	=0	AC[1]_[ARX], J/BDEC1	;POSITIVE NOW
U 2203, 3407,0111,0704,4174,4007,0700,0000,0000,0000	; 6348		[ARX]_[ARX]+1		;JUST 1B0--ADD 1
							; 6349		[BRX]_[BRX].OR.#,	;AND REMEMBER THAT WE DID
							; 6350		#/040000, HOLD RIGHT,	; IN LEFT HALF OF AC+3
U 3407, 2204,3551,0606,4374,0007,0700,0000,0004,0000	; 6351		J/BDEC2			; NEGATE IT AGAIN
							; 6352	=0
U 2210, 0441,3771,0003,0276,6007,0700,0000,0000,0000	; 6353	BDEC3:	[AR]_AC, J/BDEC4	;GET HIGH AC
							; 6354		[BRX]_[BRX].OR.#,	;NO LARGER POWER OF 10 FITS
							; 6355		#/200000,		;SET N FLAG (CLEARLY NOT 0)
U 2211, 2214,3551,0606,4374,0007,0700,0000,0020,0000	; 6356		HOLD RIGHT, J/BDEC5	;SETUP TO FILL, ETC.
							; 6357	=001
							; 6358	BDEC4:	[ARX]_AC[1],		;GET HIGH WORD
U 0441, 2234,3771,0004,1276,6007,0701,0010,0000,1441	; 6359		CALL [BDSUB]		;SEE IF 10**C(BRX) FITS
							; 6360	=011	[BRX]_[BRX]+1,	;NUMBER FITS--TRY A LARGER ONE
U 0443, 2210,0111,0706,4174,4007,0630,2000,0060,0000	; 6361		STEP SC, J/BDEC3	;UNLESS WE ARE OUT OF NUMBERS
U 0447, 2212,4553,0600,4374,4007,0331,0000,0077,7777	; 6362	=111	TR [BRX], #/777777	;ANY DIGITS REQUIRED?
							; 6363	=
							; 6364	=0	[BRX]_[BRX].OR.#,	;SOME DIGITS NEEDED,
							; 6365		#/200000, HOLD RIGHT,	; SET N FLAG
U 2212, 2214,3551,0606,4374,0007,0700,0000,0020,0000	; 6366		J/BDEC5			;CONTINUE BELOW
U 2213, 2214,0111,0706,4174,4007,0700,0000,0000,0000	; 6367		[BRX]_[BRX]+1		;ZERO--FORCE AT LEAST 1 DIGIT
							; 6368	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 173
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6369	=0
							; 6370	BDEC5:	[AR]_AC[DLEN],		;GET LENGTH
U 2214, 3520,3771,0003,1276,6007,0701,0010,0000,1443	; 6371		CALL [CLRFLG]		;REMOVE FLAGS FROM AR
U 2215, 3410,4221,0005,4174,4007,0700,0000,0000,0000	; 6372		[BR]_0
U 3410, 3411,3441,0605,4170,4007,0700,0000,0000,0000	; 6373		[BR]_[BRX], HOLD LEFT	;GET # OF DIGITS NEEDED
							; 6374		[BR]_[BR]-[AR],		;NUMBER OF FILLS NEEDED
U 3411, 2216,1111,0305,4174,4007,0421,4000,0000,0000	; 6375		SKIP AD.LE.0		;SEE IF ENOUGH ROOM
							; 6376	=0	[ARX]_WORK[BDL],	;DOES NOT FIT IN SPACE ALLOWED
U 2216, 3433,3771,0004,7274,4007,0701,0000,0000,0250	; 6377		J/BDABT			; DO NOT DO CONVERT
U 2217, 2220,3333,0006,4174,4007,0520,0000,0000,0000	; 6378		READ [BRX], SKIP DP0	;IS L ALREADY SET
							; 6379	=0	AC[DLEN]_[BRX],		;NO--NO FILLERS
U 2220, 2177,3440,0606,1174,4007,0700,0400,0000,1443	; 6380		J/DOCVT			;GO CHURN OUT THE NUMBER
							; 6381	
							; 6382	
							; 6383	;HERE TO STORE LEADING FILLERS
U 2221, 3412,3441,0603,4174,0007,0700,0000,0000,0000	; 6384		[AR]_[BRX], HOLD RIGHT	;MAKE SURE THE FLAGS GET SET
U 3412, 3413,3440,0303,1174,4007,0700,0400,0000,1443	; 6385		AC[DLEN]_[AR]		; BEFORE WE PAGE FAIL
U 3413, 3414,3771,0003,7274,4007,0701,0000,0000,0240	; 6386		[AR]_WORK[E0]		;ADDRESS OF FILL (-1)
							; 6387		[AR]_[AR]+1, LOAD VMA,	;FETCH FILLER
U 3414, 3415,0111,0703,4174,4007,0700,0200,0004,0012	; 6388		START READ
U 3415, 3416,3771,0016,4365,5007,0700,0200,0000,0002	; 6389		MEM READ, [T0]_MEM	;GET FILLER INTO AR
U 3416, 3417,3771,0013,4370,4007,0700,0000,0000,0012	; 6390		STATE_[EDIT-DST]	;PAGE FAILS BACKUP DST
U 3417, 3420,2113,0507,7174,4007,0701,4400,0000,0242	; 6391		WORK[SLEN]_[BR]-1, 3T	;SAVE # OF FILLERS
U 3420, 3421,3441,1603,7174,4007,0700,0000,0000,0242	; 6392	BDFILL:	[AR]_[T0], WORK[SLEN]	;RESTORE FILL BYTE AND
							; 6393					; WARM UP RAM FILE
							; 6394		[BR]_WORK[SLEN]+1, 3T,	;MORE FILLERS NEEDED?
U 3421, 0640,0551,0705,7274,4007,0521,0000,0000,0242	; 6395		SKIP DP0
U 0640, 2177,3440,0606,1174,4007,0700,0400,0000,1443	; 6396	=000	AC[DLEN]_[BRX], J/DOCVT	;ALL DONE FIX FLAGS AND CONVERT
							; 6397	=001	WORK[SLEN]_[BR],	;SAVE UPDATED LENGTH
U 0641, 3510,3333,0005,7174,4007,0700,0410,0000,0242	; 6398		CALL [PUTDST]		; AND STORE FILLER
U 0647, 3422,2551,0705,1274,4007,0701,4000,0000,1443	; 6399	=111	[BR]_AC[DLEN]-1		;COUNT DOWN STRING LENGTH
							; 6400	=
U 3422, 3420,3440,0505,1174,4007,0700,0400,0000,1443	; 6401		AC[DLEN]_[BR], J/BDFILL	;KEEP FILLING
							; 6402	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 174
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6403	;HERE TO STORE THE ANSWER
							; 6404	
							; 6405	DOCVT1:	[ARX]_AC[1],		;GET LOW WORD
U 3423, 3432,3771,0004,1276,6007,0701,0000,0000,1441	; 6406		J/DOCVT2		;ENTER LOOP FROM BOTTOM
							; 6407	=010
							; 6408	BDECLP:	[BR]_[BR]+1,		;COUNT DIGITS
U 0562, 2234,0111,0705,4174,4007,0700,0010,0000,0000	; 6409		CALL [BDSUB]		;KEEP SUBTRACTING 10**C(BRX)
U 0566, 3424,3333,0003,7174,4007,0700,0400,0000,0247	; 6410	=110	WORK[BDH]_[AR]		;SAVE BINARY
							; 6411	=
							; 6412		[AR]_[BR]+WORK[E1],	;OFFSET DIGIT
U 3424, 0636,0551,0503,7274,4003,7701,0000,0000,0241	; 6413		B DISP			;SEE WHICH MODE
							; 6414	=1110	READ [AR], LOAD VMA,	;TRANSLATE, START READING TABLE
U 0636, 2226,3333,0003,4174,4007,0700,0200,0004,0012	; 6415		START READ, J/BDTBL	; GO GET ENTRY FROM TABLE
U 0637, 0510,3333,0004,7174,4007,0700,0400,0000,0250	; 6416	BDSET:	WORK[BDL]_[ARX]		;SAVE LOW BINARY
U 0510, 3510,3771,0013,4370,4007,0700,0010,0000,0012	; 6417	=00*	STATE_[EDIT-DST], CALL [PUTDST]
U 0516, 3425,2551,0705,1274,4007,0701,4000,0000,1443	; 6418	=11*	[BR]_AC[DLEN]-1		;UPDATE STRING LENGTH
U 3425, 3426,3771,0003,7274,4007,0701,0000,0000,0247	; 6419		[AR]_WORK[BDH]
U 3426, 3427,3771,0004,7274,4007,0701,0000,0000,0250	; 6420		[ARX]_WORK[BDL]
U 3427, 2222,4553,0500,4374,4007,0321,0000,0004,0000	; 6421		TL [BR], #/040000	;ARE WE CONVERTING 1B0?
U 2222, 3434,0111,0704,4174,4007,0700,0000,0000,0000	; 6422	=0	[ARX]_[ARX]+1, J/BDCFLG	;YES--FIX THE NUMBER AND CLEAR FLAG
U 2223, 3430,3440,0303,0174,4007,0700,0400,0000,0000	; 6423	DOCVT3:	AC_[AR]
U 3430, 3431,3440,0404,1174,4007,0700,0400,0000,1441	; 6424		AC[1]_[ARX]
U 3431, 3432,3440,0505,1174,4007,0700,0400,0000,1443	; 6425		AC[DLEN]_[BR]		;STORE BACK NEW STRING LENGTH
U 3432, 2224,1111,0706,4174,4007,0531,4000,0000,0000	; 6426	DOCVT2:	[BRX]_[BRX]-1, 3T, SKIP DP18
U 2224, 0562,2441,0705,4174,4467,0701,4000,0003,0000	; 6427	=0	[BR]_-1, SET FPD, 3T, J/BDECLP
U 2225, 0260,4221,0013,4170,4467,0700,0000,0005,0000	; 6428		END STATE, CLR FPD, J/SKIP
							; 6429	
							; 6430	;HERE TO TRANSLATE 1 DIGIT
							; 6431	=0
							; 6432	BDTBL:	END STATE,		;DON'T CHANGE BYTE POINTER IF
							; 6433					; THIS PAGE FAILS
U 2226, 3720,4221,0013,4170,4007,0700,0010,0000,0000	; 6434		CALL [LOADAR]		;GO PUT WORD IN AR
U 2227, 2230,4553,0600,4374,4007,0331,0000,0077,7777	; 6435		TR [BRX], #/777777	;LAST DIGIT
U 2230, 0637,4221,0003,4174,0007,0700,0000,0000,0000	; 6436	=0	[AR]_0, HOLD RIGHT, J/BDSET
U 2231, 2232,4553,0600,4374,4007,0321,0000,0010,0000	; 6437		TL [BRX], #/100000	;AND NEGATIVE
U 2232, 2233,3770,0303,4344,4007,0700,0000,0000,0000	; 6438	=0	[AR]_[AR] SWAP		;LAST AND MINUS, USE LH
U 2233, 0637,4221,0003,4174,0007,0700,0000,0000,0000	; 6439		[AR]_0, HOLD RIGHT, J/BDSET
							; 6440	
U 3433, 1505,3771,0003,7274,4007,0701,0000,0000,0247	; 6441	BDABT:	[AR]_WORK[BDH], J/DAC
							; 6442	
							; 6443	BDCFLG:	[BR]_[BR].AND.NOT.#, 	;CLEAR FLAG THAT TELLS US
							; 6444		#/040000, HOLD RIGHT,	; TO SUBTRACT 1 AND
U 3434, 2223,5551,0505,4374,0007,0700,0000,0004,0000	; 6445		J/DOCVT3		; CONTINUE CONVERTING
							; 6446	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 175
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- BINARY TO DECIMAL CONVERSION			

							; 6447	;SUBROUTINE TO SUBRTACT A POWER OF 10 FROM AR!ARX
							; 6448	;CALL WITH:
							; 6449	;	AR!ARX/	NUMBER TO BE CONVERTED
							; 6450	;	BRX(RIGHT)/ POWER OF 10
							; 6451	;RETURNS:
							; 6452	;	2 RESULT IS STILL POSITIVE
							; 6453	;	6 RESULT WOULD HAVE BEEN NEGATIVE (RESTORE DONE)
							; 6454	=0
							; 6455	BDSUB:	[T0]_[BRX]+#, 3T, WORK/DECLO, ;ADDRESS OF LOW WORD
U 2234, 2205,0551,0616,4374,4007,0701,0000,0000,0344	; 6456		J/BDSUB1		;NO INTERRUPT
U 2235, 2717,4443,0000,4174,4007,0700,0000,0000,0000	; 6457		J/FIXPC			;INTERRUPT
							; 6458	=0*
							; 6459	BDSUB1:	[T1]_[T0], LOAD VMA,	;PUT IN VMA,
U 2205, 2240,3441,1617,4174,4007,0700,0210,0000,0010	; 6460		CALL [CLARX0]		;FIX UP SIGN OF LOW WORD
							; 6461		[ARX]_[ARX]-RAM, 3T,	;SUBTRACT
U 2207, 2236,1551,0404,6274,4007,0561,4000,0000,0000	; 6462		SKIP CRY1		;SEE IF OVERFLOW
U 2236, 2237,1111,0703,4174,4007,0700,4000,0000,0000	; 6463	=0	[AR]_[AR]-1		;PROCESS CARRY
U 2237, 3435,0551,0616,4374,4007,0701,0000,0000,0373	; 6464		[T0]_[BRX]+#, 3T, WORK/DECHI ;ADDRESS OF HIGH WORD
U 3435, 3436,3333,0016,4174,4007,0700,0200,0000,0010	; 6465		READ [T0], LOAD VMA	;PLACE IN VMA
							; 6466		[AR]_[AR]-RAM, 4T,	;SUBTRACT
U 3436, 2240,1551,0303,6274,4007,0522,4000,0000,0000	; 6467		SKIP DP0		;SEE IF IT FIT
							; 6468	=0
							; 6469	CLARX0:	CLEAR ARX0,		;IT FIT, KEEP LOW WORD +
U 2240, 0002,4551,0404,4374,0004,1700,0000,0037,7777	; 6470		RETURN [2]		; AND RETURN
U 2241, 3437,0551,0303,6274,4007,0700,0000,0000,0000	; 6471		[AR]_[AR]+RAM		;RESTORE
U 3437, 3440,3333,0017,4174,4007,0700,0200,0000,0010	; 6472		READ [T1], LOAD VMA
U 3440, 2242,0551,0404,6274,4007,0561,0000,0000,0000	; 6473		[ARX]_[ARX]+RAM, 3T, SKIP CRY1
							; 6474	=0
							; 6475	BDSUB2:	CLEAR ARX0,		;KEEP LOW WORD +
U 2242, 0006,4551,0404,4374,0004,1700,0000,0037,7777	; 6476		RETURN [6]		;RETURN OVERFLOW
							; 6477		[AR]_[AR]+1,		;ADD BACK THE CARRY
U 2243, 2242,0111,0703,4174,4007,0700,0000,0000,0000	; 6478		J/BDSUB2		;COMPLETE SUBTRACT
							; 6479	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 176
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- MAIN LOOP				

							; 6480	.TOC	"EXTEND -- EDIT -- MAIN LOOP"
							; 6481	
							; 6482	;HERE FOR EDIT INSTRUCTION
							; 6483	;CALL WITH:
							; 6484	;	AR/	E0	ADDRESS OF FILL, FLOAT, AND MESSAGE TABLE
							; 6485	;	BR/	E1	TRANSLATE TABLE
							; 6486	;
							; 6487	3741:
							; 6488	EDIT:	VMA_[AR]+1, START READ,	;FIRST GET FILL BYTE
U 3741, 3516,0111,0703,4170,4007,0700,0210,0004,0012	; 6489		CALL [GTFILL]		;GO GET IT
U 3751, 2250,3771,0006,0276,6007,0700,0000,0000,0000	; 6490	3751:	[BRX]_AC		;GET PATTERN POINTER
							; 6491	=0**	TL [BRX], #/047777,	;MAKE SURE SECTION 0
U 2250, 3556,4553,0600,4374,4007,0321,0010,0004,7777	; 6492		CALL [BITCHK]		; ..
U 2254, 3441,3443,0600,4174,4007,0700,0200,0004,0012	; 6493	EDITLP:	VMA_[BRX], START READ	;FETCH PATTERN WORD
U 3441, 3442,4221,0013,4170,4007,0700,0000,0000,0000	; 6494		END STATE		;NO SPECIAL PAGE FAIL ACTION
U 3442, 2244,3770,0605,4344,4007,0700,0000,0000,0000	; 6495		[BR]_[BRX] SWAP		;GET PBN IN BITS 20 & 21
							; 6496	=0	[BR]_[BR]*4,		; ..
U 2244, 3720,0115,0505,4174,4007,0700,0010,0000,0000	; 6497		CALL [LOADAR]		;GET PATTERN WORD
U 2245, 0654,3333,0005,4174,4003,1701,0000,0000,0000	; 6498		READ [BR], 3T, DISP/DP LEFT
							; 6499	=1100
U 0654, 2246,3770,0303,4344,4007,0700,2000,0071,0007	; 6500		[AR]_[AR] SWAP, SC_7, J/MOVPAT	;(0) BITS 0-8
U 0655, 2247,3770,0303,4344,4007,0700,0000,0000,0000	; 6501		[AR]_[AR] SWAP, J/MSKPAT	;(1) BITS 9-17
U 0656, 2246,3447,0303,4174,4007,0700,2000,0071,0006	; 6502		[AR]_[AR]*.5, SC_6, J/MOVPAT	;(2) BITS 18-27
U 0657, 3443,4551,0303,4374,4007,0700,0000,0000,0777	; 6503		[AR]_[AR].AND.#, #/777, J/EDISP	;(3) BITS 28-35
							; 6504	=0
U 2246, 2246,3447,0303,4174,4007,0630,2000,0060,0000	; 6505	MOVPAT:	[AR]_[AR]*.5, STEP SC, J/MOVPAT	;SHIFT OVER
U 2247, 3443,4551,0303,4374,4007,0700,0000,0000,0777	; 6506	MSKPAT:	[AR]_[AR].AND.#, #/777
							; 6507	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 177
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- MAIN LOOP				

							; 6508	;HERE WITH PATTERN BYTE RIGHT ADJUSTED IN AR
U 3443, 2252,3447,0305,4174,4007,0700,2000,0071,0002	; 6509	EDISP:	[BR]_[AR]*.5, SC_2	;SHIFT OVER
							; 6510	=0
U 2252, 2252,3447,0505,4174,4007,0630,2000,0060,0000	; 6511	EDISP1:	[BR]_[BR]*.5, STEP SC, J/EDISP1
U 2253, 0661,3333,0005,4174,4003,5701,0000,0000,0000	; 6512		READ [BR], 3T, DISP/DP	;LOOK AT HIGH 3 BITS
							; 6513	=0001				;(0) OPERATE GROUP
							; 6514		[AR]-#, #/5, 4T,	;	SEE IF 0-4
U 0661, 2256,1553,0300,4374,4007,0532,4000,0000,0005	; 6515		SKIP DP18, J/EDOPR
							; 6516					;(1) MESSAGE BYTE
							; 6517		READ [BRX], SKIP DP0,
U 0663, 2274,3333,0006,4174,4007,0520,0000,0000,0000	; 6518		J/EDMSG
							; 6519					;(2) UNDEFINED
U 0665, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6520		J/EDNOP
							; 6521					;(3) UNDEFINED
U 0667, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6522		J/EDNOP
							; 6523					;(4) UNDEFINED
U 0671, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6524		J/EDNOP
							; 6525					;(5) SKIP IF M SET
							; 6526		TL [BRX], #/100000,
U 0673, 2300,4553,0600,4374,4007,0321,0000,0010,0000	; 6527		J/EDSKP
							; 6528					;(6) SKIP IF N SET
							; 6529		TL [BRX], #/200000,
U 0675, 2300,4553,0600,4374,4007,0321,0000,0020,0000	; 6530		J/EDSKP
							; 6531					;(7) SKIP ALWAYS
U 0677, 2300,4443,0000,4174,4007,0700,0000,0000,0000	; 6532		J/EDSKP
							; 6533	
							; 6534	.TOC	"EXTEND -- EDIT -- DECODE OPERATE GROUP"
							; 6535	
							; 6536	;HERE FOR OPERATE GROUP. SKIP IF IN RANGE
							; 6537	=0
U 2256, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6538	EDOPR:	J/EDNOP			;OUT OF RANGE
U 2257, 0710,3333,0003,4174,4003,5701,0000,0000,0000	; 6539		READ [AR], 3T, DISP/DP	;DISPATCH ON TYPE
U 0710, 3444,0111,0701,4174,4007,0700,0000,0000,0000	; 6540	=1000	[PC]_[PC]+1, J/EDSTOP	;(0) STOP EDIT
							; 6541		STATE_[EDIT-SRC], 	;(1) SELECT SOURCE BYTE
U 0711, 2264,3771,0013,4370,4007,0700,0000,0000,0011	; 6542		J/EDSEL
							; 6543		READ [BRX], SKIP DP0,	;(2) START SIGNIFICANCE
U 0712, 0246,3333,0006,4174,4007,0520,0000,0000,0000	; 6544		J/EDSSIG
							; 6545		[BRX]_[BRX].AND.#,	;(3) FIELD SEPERATOR
							; 6546		#/77777, HOLD RIGHT,
U 0713, 3463,4551,0606,4374,0007,0700,0000,0007,7777	; 6547		J/EDNOP
U 0714, 0715,3771,0005,1276,6007,0701,0000,0000,1443	; 6548		[BR]_AC[MARK]		;(4) EXCHANGE MARK AND DEST
							; 6549		VMA_[BR], START READ,
U 0715, 2262,3443,0500,4174,4007,0700,0200,0004,0012	; 6550		J/EDEXMD
							; 6551	=
							; 6552	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 178
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- STOP EDIT				

							; 6553	.TOC	"EXTEND -- EDIT -- STOP EDIT"
							; 6554	
							; 6555	;HERE TO END AN EDIT OPERATION. PC IS SET TO SKIP IF NORMAL END
							; 6556	; OR NON-SKIP IF ABORT
							; 6557	EDSTOP:	[BR]_.NOT.[BRX],	;AD WILL NOT DO D.AND.NOT.A
U 3444, 3445,7441,0605,4174,4007,0700,1000,0071,0010	; 6558		FE_S#, S#/10		;PRESET FE
U 3445, 3446,3441,0603,4174,4007,0701,1000,0043,0000	; 6559		[AR]_[BRX], 3T, FE_FE+P	;MOVE POINTER, UPBATE PBN
							; 6560		[BR].AND.#, 3T,		;WAS OLD NUMBER 3?
U 3446, 2260,4553,0500,4374,4007,0321,0000,0003,0000	; 6561		#/030000, SKIP ADL.EQ.0	; ..
							; 6562	=0
U 2260, 1515,3770,0303,4334,4017,0700,0000,0041,0000	; 6563	EDSTP1:	[AR]_P, J/STAC		;NO--ALL DONE
							; 6564		[AR]_[AR]+1,		;YES--BUMP WORD #
							; 6565		FE_FE.AND.S#, S#/0700,	;KEEP ONLY FLAG BITS
U 2261, 2260,0111,0703,4174,4007,0700,1000,0051,0700	; 6566		J/EDSTP1		;GO STOP EDIT
							; 6567	
							; 6568	.TOC	"EXTEND -- EDIT -- START SIGNIFICANCE"
							; 6569	
							; 6570	;HERE WITH DST POINTER IN AR
							; 6571	=110
U 0246, 3452,4443,0000,4174,4007,0700,0010,0000,0000	; 6572	EDSSIG:	CALL [EDFLT]		;STORE FLT CHAR
U 0247, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6573		J/EDNOP			;DO NEXT PATTERN BYTE
							; 6574	
							; 6575	.TOC	"EXTEND -- EDIT -- EXCHANGE MARK AND DESTINATION"
							; 6576	
							; 6577	;HERE WITH ADDRESS OF MARK POINTER IN BR
							; 6578	=0
							; 6579	EDEXMD:	Q_AC[DSTP],		;GET DEST POINTER
U 2262, 3720,3772,0000,1275,5007,0701,0010,0000,1444	; 6580		CALL [LOADAR]		;GO PUT MARK IN AR
U 2263, 3447,4443,0000,4174,4007,0700,0200,0003,0002	; 6581		START WRITE		;START WRITE. SEPERATE STEP TO AVOID
							; 6582					; PROBLEM ON DPM5
U 3447, 3450,3223,0000,4174,4007,0701,0200,0000,0002	; 6583		MEM WRITE, MEM_Q	;PUT OLD DEST IN MARK
U 3450, 3463,3440,0303,1174,4007,0700,0400,0000,1444	; 6584		AC[DSTP]_[AR], J/EDNOP	;PUT BACK DEST POINTER
							; 6585	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 179
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- PROCESS SOURCE BYTE			

							; 6586	.TOC	"EXTEND -- EDIT -- PROCESS SOURCE BYTE"
							; 6587	
							; 6588	=0*
							; 6589	EDSEL:	[AR]_AC[SRCP],		;PICK UP SRC POINTER
U 2264, 2321,3771,0003,1276,6007,0701,0010,0000,1441	; 6590		CALL [GETSRC]		;GET SOURCE BYTE
U 2266, 0700,3447,0303,7174,4007,0700,0000,0000,0241	; 6591		[AR]_[AR]*.5, WORK[E1]	;PREPARE TO TRANSLATE
							; 6592	=000	[AR]_[AR]+WORK[E1],	;GO TRANSLATE BY HALFWORDS
U 0700, 3503,0551,0303,7274,4007,0700,0010,0000,0241	; 6593		2T, CALL [TRNAR]	; ..
							; 6594	=010
							; 6595	EDFILL:	READ [AR],		;(2) NO SIGNIFICANCE, GO FILL
							; 6596		SKIP AD.EQ.0,		;    SEE IF ANY FILLER
U 0702, 2270,3333,0003,4174,4007,0621,0000,0000,0000	; 6597		J/EDFIL1		;    GO TO IT
							; 6598		STATE_[EDIT-SRC],	;(3) SIG START, DO FLOAT CHAR
U 0703, 0606,3771,0013,4370,4007,0700,0000,0000,0011	; 6599		J/EDSFLT
U 0704, 3444,4443,0000,4174,4007,0700,0000,0000,0000	; 6600	=100	J/EDSTOP		;(4) ABORT
							; 6601	=101
							; 6602	EDSPUT:	STATE_[EDIT-S+D],	;(5) NORMAL, STORE AT DST
U 0705, 3510,3771,0013,4370,4007,0700,0010,0000,0013	; 6603		CALL [PUTDST]		;    ..
							; 6604	=111
U 0707, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6605		J/EDNOP			;(7) BYTE STORED
							; 6606	=
							; 6607	
							; 6608	;HERE TO COMPLETE STORING FILL
							; 6609	=0
U 2270, 0705,4443,0000,4174,4007,0700,0000,0000,0000	; 6610	EDFIL1:	J/EDSPUT		;STORE FILLER
U 2271, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6611		J/EDNOP			;NO FILLER TO STORE
							; 6612	
							; 6613	;HERE TO DO FLOAT BYTE
							; 6614	=110
							; 6615	EDSFLT:	WORK[FSIG]_[ARX],	;SAVE SIG CHAR
U 0606, 3452,3333,0004,7174,4007,0700,0410,0000,0246	; 6616		CALL [EDFLT]		;STORE FLOAT CHAR
U 0607, 3451,3771,0003,7274,4007,0701,0000,0000,0246	; 6617		[AR]_WORK[FSIG]		;RESTORE CHAR
							; 6618		[AR]_[AR].AND.# CLR LH,	;JUST KEEP THE BYTE IN CASE
							; 6619		#/77777,		; DEST BYTE .GT. 15 BITS
U 3451, 0705,4251,0303,4374,4007,0700,0000,0007,7777	; 6620		J/EDSPUT		;GO STORE CHAR WHICH STARTED THIS ALL
							; 6621	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 180
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- PROCESS SOURCE BYTE			

							; 6622	;SUBRUTINE TO PROCESS FLOAT CHAR
							; 6623	;CALL WITH:
							; 6624	;	AR/ POINTER TO STORE @ MARK
							; 6625	;RETURN 7 WITH FLOAT STORED
U 3452, 3453,3771,0005,1276,6007,0701,0000,0000,1443	; 6626	EDFLT:	[BR]_AC[MARK]		;ADDRESS OF MARK POINTER
U 3453, 3454,3443,0500,4174,4007,0700,0200,0003,0012	; 6627		VMA_[BR], START WRITE	;READY TO STORE
U 3454, 3455,3771,0005,1276,6007,0701,0000,0000,1444	; 6628		[BR]_AC[DSTP]		;GET DST POINTER
U 3455, 2272,3333,0005,4175,5007,0701,0200,0000,0002	; 6629		MEM WRITE, MEM_[BR]	;STORE POINTER
							; 6630	=0	[AR]_0 XWD [2],		;FETCH FLOAT CHAR
U 2272, 3457,4751,1203,4374,4007,0700,0010,0000,0002	; 6631		CALL [EDBYTE]		;GET TBL BYTE
							; 6632		MEM READ, [AR]_MEM,	;GET FLOAT CHAR
U 2273, 0740,3771,0003,4365,5007,0621,0200,0000,0002	; 6633		SKIP AD.EQ.0		;SEE IF NULL
							; 6634	=000
							; 6635		[FLG]_[FLG].OR.#,	;REMEMBER TO BACKUP DST POINTER
							; 6636		STATE/EDIT-DST,		; WILL ALSO BACKUP SRC IF CALLED
							; 6637		HOLD LEFT,		; FROM SELECT
U 0740, 3510,3551,1313,4370,4007,0700,0010,0000,0012	; 6638		CALL [PUTDST]		; STORE FLOAT
							; 6639	=001	[BRX]_[BRX].OR.#, #/400000,
U 0741, 3456,3551,0606,4374,0007,0700,0000,0040,0000	; 6640		HOLD RIGHT,  J/EDFLT1	;NULL
							; 6641	=110	[BRX]_[BRX].OR.#, #/400000,
U 0746, 3456,3551,0606,4374,0007,0700,0000,0040,0000	; 6642		HOLD RIGHT,  J/EDFLT1	;MARK STORED
							; 6643	=
							; 6644	EDFLT1:	AC_[BRX],		;SAVE FLAGS SO WE DON'T
							; 6645					;TRY TO DO THIS AGAIN IF
							; 6646					;NEXT STORE PAGE FAILS
U 3456, 0007,3440,0606,0174,4004,1700,0400,0000,0000	; 6647		RETURN [7]		;AND RETURN
							; 6648	
							; 6649	.TOC	"EXTEND -- EDIT -- MESSAGE BYTE"
							; 6650	
							; 6651	;HERE WITH SKIP ON S
							; 6652	=0
							; 6653	EDMSG:	[AR]_WORK[FILL],	;GET FILL BYTE
							; 6654		SKIP AD.EQ.0, 4T,	;SEE IF NULL
U 2274, 0760,3771,0003,7274,4007,0622,0000,0000,0244	; 6655		J/EDMSG1		;GO STORE
							; 6656		[AR]_[AR].AND.# CLR LH, ;GET OFFSET INTO TABLE
U 2275, 2276,4251,0303,4374,4007,0700,0000,0000,0077	; 6657		#/77
							; 6658	=0	[AR]_[AR]+1, WORK[E0],	;PLUS 1
U 2276, 3457,0111,0703,7174,4007,0700,0010,0000,0240	; 6659		CALL [EDBYTE]		;GET TBL BYTE
U 2277, 0760,3771,0003,4365,5007,0700,0200,0000,0002	; 6660		MEM READ, [AR]_MEM	;FROM MEMORY
							; 6661	=000
							; 6662	EDMSG1:	STATE_[EDIT-DST],	;WHAT TO DO ON PAGE FAILS
U 0760, 3510,3771,0013,4370,4007,0700,0010,0000,0012	; 6663		CALL [PUTDST]		;STORE MESSAGE BYTE
U 0761, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6664	=001	J/EDNOP			;NULL FILLER
U 0766, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6665	=110	J/EDNOP			;NEXT BYTE
							; 6666	=
							; 6667	
U 3457, 3460,0551,0303,7274,4007,0701,0000,0000,0240	; 6668	EDBYTE:	[AR]_[AR]+WORK[E0]	;GET OFFSET INTO TABLE
							; 6669		VMA_[AR], START READ,	;START MEMORY CYCLE
U 3460, 0001,3443,0300,4174,4004,1700,0200,0004,0012	; 6670		RETURN [1]		;RETURN TO CALLER
							; 6671	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 181
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- EDIT -- SKIP					

							; 6672	.TOC	"EXTEND -- EDIT -- SKIP"
							; 6673	
							; 6674	=0
							; 6675	;HERE TO SKIP ALWAYS
							; 6676	EDSKP:	[AR]_[AR].AND.#, #/77,	;JUST KEEP SKIP DISTANCE
U 2300, 3461,4551,0303,4374,4007,0700,0000,0000,0077	; 6677		J/EDSKP1		;CONTINUE BELOW
							; 6678	;HERE IF WE DO NOT WANT TO SKIP
U 2301, 3463,4443,0000,4174,4007,0700,0000,0000,0000	; 6679		J/EDNOP
U 3461, 3462,0115,0703,4174,4007,0700,0000,0000,0000	; 6680	EDSKP1:	[AR]_([AR]+1)*2		;GIVE 1 EXTRA SKIP
							; 6681		READ [AR], SCAD/A*2,	;PUT THE ADJUSTMENT
							; 6682		SCADA/BYTE5, 3T, LOAD SC, ; THE SC
U 3462, 3464,3333,0003,4174,4007,0701,2000,0007,0000	; 6683		J/EDNOP1		;JOIN MAIN LOOP
							; 6684	
							; 6685	
							; 6686	.TOC	"EXTEND -- EDIT -- ADVANCE PATTERN POINTER"
							; 6687	
U 3463, 3464,4443,0000,4174,4007,0700,2000,0071,0000	; 6688	EDNOP:	SC_0			;NO SKIP
U 3464, 3465,3333,0006,4174,4007,0701,1000,0073,0000	; 6689	EDNOP1:	READ [BRX], 3T, FE_P	;PUT PBN IN FE
U 3465, 3466,4443,0000,4174,4007,0700,1000,0051,0030	; 6690		FE_FE.AND.S#, S#/30	;JUST BYTE #
U 3466, 3467,4443,0000,4174,4007,0700,1000,0040,0000	; 6691		FE_FE+SC		;ADD IN ANY SKIP DISTANCE
U 3467, 3470,4443,0000,4174,4007,0700,1000,0041,0010	; 6692		FE_FE+S#, S#/10		;BUMP PBN
							; 6693		[AR]_FE,		;GET NUMBER OF WORDS
U 3470, 3471,3777,0003,4334,4057,0700,2000,0041,0000	; 6694		LOAD SC			;PUT MSB WHERE IT CAN BE TESTED
							; 6695					; QUICKLY
							; 6696		[AR]_[AR].AND.# CLR LH,	;KEEP ONLY 1 COPY
U 3471, 2302,4251,0303,4374,4007,0630,0000,0000,0170	; 6697		#/170, SKIP/SC		; ..
							; 6698	=0
							; 6699	EDN1A:	[AR]_[AR]*.5, SC_0,
U 2302, 2304,3447,0303,4174,4007,0700,2000,0071,0000	; 6700		J/EDNOP2		;READY TO SHIFT OFF BYTE WITHIN
							; 6701					; WORD
							; 6702		[AR]_[AR].OR.#, #/200,	;GET THE SIGN BIT OF THE FE
							; 6703		HOLD LEFT,		; INTO THE AR. ONLY HAPPENS ON
U 2303, 2302,3551,0303,4370,4007,0700,0000,0000,0200	; 6704		J/EDN1A			; SKP 76 OR SKP 77
							; 6705	=0
U 2304, 2304,3447,0303,4174,4007,0630,2000,0060,0000	; 6706	EDNOP2:	[AR]_[AR]*.5, STEP SC, J/EDNOP2
							; 6707		[BRX]_[BRX]+[AR],	;UPDATE WORD ADDRESS
U 2305, 3472,0111,0306,4170,4007,0700,0000,0000,0000	; 6708		HOLD LEFT
U 3472, 3473,3770,0303,4334,4017,0700,0000,0041,0000	; 6709		[AR]_P			;PUT PBN BACK IN BRX
							; 6710		[BRX]_[BRX].AND.#,	;JUST KEEP FLAGS
							; 6711		#/700000,		; ..
U 3473, 3474,4551,0606,4374,0007,0700,0000,0070,0000	; 6712		HOLD RIGHT
							; 6713		[AR]_[AR].AND.#,	;JUST KEEP PBN
U 3474, 3475,4551,0303,4374,4007,0700,0000,0003,0000	; 6714		#/030000
							; 6715		[BRX]_[BRX].OR.[AR],	;FINAL ANSWER
U 3475, 3476,3111,0306,4174,0007,0700,0000,0000,0000	; 6716		HOLD RIGHT
U 3476, 2254,3440,0606,0174,4007,0700,0400,0000,0000	; 6717		AC_[BRX], J/EDITLP	;DO NEXT FUNCTION
							; 6718	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 182
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- FILL OUT DESTINATION		

							; 6719	.TOC	"EXTEND SUBROUTINES -- FILL OUT DESTINATION"
							; 6720	
							; 6721	;CALL WITH
							; 6722	;	AC[DLEN]/ NEGATIVE NUMBER OF BYTES LEFT IN DEST
							; 6723	;	FILL/  FILL BYTE
							; 6724	;	RETURN [2] WITH FILLERS STORED
							; 6725	;
							; 6726	;NOTE: THIS ROUTINE NEED NOT TEST FOR INTERRUPTS ON EACH BYTE
							; 6727	;	BECAUSE EVERY BYTE STORE DOES A MEMORY READ.
							; 6728	;
							; 6729	=01*
							; 6730	MOVF1:	[AR]_WORK[FILL], 2T,	;GET FILL BYTE
U 0332, 3510,3771,0003,7274,4007,0700,0010,0000,0244	; 6731		CALL [PUTDST]		;PLACE IN DEST
U 0336, 3477,3771,0003,1276,6007,0701,0000,0000,1443	; 6732		[AR]_AC[DLEN]		;AMOUNT LEFT
							; 6733		AC[DLEN]_[AR]+1, 3T,	;STORE UPDATED LEN
U 3477, 2306,0113,0703,1174,4007,0521,0400,0000,1443	; 6734		SKIP DP0		; AND SEE IF DONE
U 2306, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 6735	=0	RETURN [2]		;DONE
U 2307, 0332,4443,0000,7174,4007,0700,0000,0000,0244	; 6736	MOVFIL:	WORK[FILL], J/MOVF1	;DO ANOTHER BYTE
							; 6737					;ENTERING HERE SAVES 150NS
							; 6738					; PER BYTE BUT COSTS 300NS
							; 6739					; PER FIELD MOVED. I ASSUME (BUT DO
							; 6740					; NOT KNOW) THAT THIS SPEEDS
							; 6741					; THINGS UP.
							; 6742	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 183
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- GET MODIFIED SOURCE BYTE		

							; 6743	.TOC"EXTEND SUBROUTINES -- GET MODIFIED SOURCE BYTE"
							; 6744	
							; 6745	;CALL WITH:
							; 6746	;SLEN = MINUS LENGTH OF STRING
							; 6747	;MSK = MASK FOR BYTE SIZE (1 IF BIT MUST BE ZERO)
							; 6748	;E1 = EFFECTIVE ADDRESS OF OPERATION WORD (SIGN EXTENDED IF OFFSET)
							; 6749	;	[AR]_WORK[SLEN]+1, CALL [SRCMOD]
							; 6750	;RETURNS:
							; 6751	;	1 LENGTH EXHAUSTED
							; 6752	;	2 (EDIT ONLY) NO SIGNIFICANCE
							; 6753	;	3 (EDIT ONLY) SIGNIFICANCE START:
							; 6754	;	4 ABORT: OUT OF RANGE OR TRANSLATE FAILURE
							; 6755	;	5 NORMAL: BYTE IN AR
							; 6756	;
							; 6757	;DROM B SET AS FOLLOWS:
							; 6758	;	0 TRANSLATE
							; 6759	;	1 OFFSET
							; 6760	;	2 EDIT
							; 6761	;	4 CVTDBT
							; 6762	=00
							; 6763	SRCMOD:	WORK[SLEN]_[AR],	;PUT BACK SOURCE LENGTH
							; 6764		SKIP DP0,		;SEE IF DONE
U 1120, 2320,3333,0003,7174,4007,0520,0410,0000,0242	; 6765		CALL [GSRC]		;GET A SOURCE BYTE
U 1121, 0001,4221,0013,4170,4004,1700,0000,0000,0000	; 6766		END STATE, RETURN [1]	;DONE
U 1122, 0716,4443,0000,7174,4003,7700,0000,0000,0241	; 6767		WORK[E1], B DISP	;OFFSET OR TRANSLATE?
							; 6768	=
U 0716, 3502,3447,0303,4174,4007,0700,0000,0000,0000	; 6769	=1110	[AR]_[AR]*.5, J/XLATE	;TRANSLATE
U 0717, 3500,3770,0303,7174,0007,0700,0000,0000,0241	; 6770		FIX [AR] SIGN, WORK[E1]	;IF WE ARE PROCESSING FULL WORD
							; 6771					; BYTES, AND THEY ARE NEGATIVE,
							; 6772					; AND THE OFFSET IS POSITIVE THEN
							; 6773					; WE HAVE TO MAKE BITS -1 AND -2
							; 6774					; COPIES OF THE SIGN BIT.
U 3500, 3501,0551,0303,7274,4007,0700,0000,0000,0241	; 6775		[AR]_[AR]+WORK[E1], 2T	;OFFSET
							; 6776		[AR].AND.WORK[MSK],	;VALID BYTE?
							; 6777		SKIP AD.EQ.0, 4T,	;SKIP IF OK
U 3501, 0004,4553,0300,7274,4004,1622,0000,0000,0243	; 6778		RETURN [4]		;RETURN 4 IF BAD, 5 IF OK
							; 6779	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 184
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- TRANSLATE				

							; 6780	.TOC	"EXTEND SUBROUTINES -- TRANSLATE"
							; 6781	
							; 6782	;HERE WITH BYTE IN AR 1-36. FETCH TABLE ENTRY.
U 3502, 3503,0551,0303,7274,4007,0701,0000,0000,0241	; 6783	XLATE:	[AR]_[AR]+WORK[E1]	;COMPUTE ADDRESS
							; 6784	TRNAR:	READ [AR], LOAD VMA,	;FETCH WORD
U 3503, 2310,3333,0003,4174,4007,0700,0200,0004,0012	; 6785		START READ		; ..
							; 6786	=0	[AR]_[AR]*2,		;GET BACK LSB
							; 6787					;BIT 36 IS NOT PRESERVED 
							; 6788					; BY PAGE FAILS
U 2310, 3721,3445,0303,4174,4007,0700,0010,0000,0000	; 6789		CALL [LOADARX]		;PUT ENTRY IN ARX
U 2311, 2312,4553,0300,4374,4007,0331,0000,0000,0001	; 6790		TR [AR], #/1		;WHICH HALF?
							; 6791	=0
							; 6792	XLATE1:	[AR]_[ARX], 3T, 	;RH -- COPY TO AR
							; 6793		DISP/DP LEFT,		;DISPATCH ON CODE
U 2312, 0721,3441,0403,4174,4003,1701,0000,0000,0000	; 6794		J/TRNFNC		;DISPATCH TABLE
							; 6795		[ARX]_[ARX] SWAP,	;LH -- FLIP AROUND
U 2313, 2312,3770,0404,4344,4007,0700,0000,0000,0000	; 6796		J/XLATE1		;START SHIFT
							; 6797	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 185
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- TRANSLATE				

							; 6798	;HERE ON TRANSLATE OPERATION TO PERFORM FUNCTIONS REQUIRED BY
							; 6799	; THE 3 HIGH ORDER BITS OF THE TRANSLATE FUNCTION HALFWORD. WE
							; 6800	; DISPATCH ON FUNCTION AND HAVE:
							; 6801	;	BRX/	FLAGS
							; 6802	;	ARX/	TABLE ENTRY IN RH
							; 6803	;
							; 6804	=0001
							; 6805					;(0) NOP
							; 6806	TRNFNC:	READ [BRX], SKIP DP0,	;S FLAG ALREADY SET?
U 0721, 2314,3333,0006,4174,4007,0520,0000,0000,0000	; 6807		J/TRNRET		; ..
							; 6808					;(1) ABORT
U 0723, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 6809		RETURN [4]
							; 6810					;(2) CLEAR M FLAG
							; 6811		[BRX]_[BRX].AND.NOT.#,
							; 6812		#/100000, HOLD RIGHT,	
U 0725, 0721,5551,0606,4374,0007,0700,0000,0010,0000	; 6813		J/TRNFNC
							; 6814					;(3) SET M FLAG
							; 6815		[BRX]_[BRX].OR.#,
							; 6816		#/100000, HOLD RIGHT,
U 0727, 0721,3551,0606,4374,0007,0700,0000,0010,0000	; 6817		J/TRNFNC
							; 6818					;(4) SET N FLAG
							; 6819	TRNSIG:	[BRX]_[BRX].OR.#,
							; 6820		#/200000, HOLD RIGHT,
U 0731, 0721,3551,0606,4374,0007,0700,0000,0020,0000	; 6821		J/TRNFNC
							; 6822					;(5) SET N FLAG THEN ABORT
							; 6823		[BRX]_[BRX].OR.#,
							; 6824		#/200000, HOLD RIGHT,
U 0733, 0004,3551,0606,4374,0004,1700,0000,0020,0000	; 6825		RETURN [4]
							; 6826					;(6) CLEAR M THEN SET N
							; 6827		[BRX]_[BRX].AND.NOT.#,
							; 6828		#/100000, HOLD RIGHT,
U 0735, 0731,5551,0606,4374,0007,0700,0000,0010,0000	; 6829		J/TRNSIG
							; 6830					;(7) SET N AND M
							; 6831		[BRX]_[BRX].OR.#,	
							; 6832		#/300000, HOLD RIGHT,
U 0737, 0721,3551,0606,4374,0007,0700,0000,0030,0000	; 6833		J/TRNFNC
							; 6834	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 186
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- TRANSLATE				

							; 6835	;HERE TO COMPLETE A TRANSLATE
							; 6836	
							; 6837	=0
							; 6838	TRNRET:	READ [ARX], SKIP DP18,	;S-FLAG IS ZERO
							; 6839		B DISP, SKIP DP18,	;SEE IF EDIT OR SIG START
U 2314, 0754,3333,0004,4174,4003,7530,0000,0000,0000	; 6840		J/TRNSS			; ..
							; 6841	TRNSS1:	[AR]_[ARX].AND.# CLR LH, ;S IS SET, JUST RETURN BYTE
U 2315, 0005,4251,0403,4374,4004,1700,0000,0007,7777	; 6842		#/77777, RETURN [5]	; ..
							; 6843	
							; 6844	=1100
							; 6845	TRNSS:	[AR]_AC[DLEN],		;NO SIG ON MOVE OR D2B
U 0754, 0533,3771,0003,1276,6003,7701,0000,0000,1443	; 6846		B DISP, J/TRNNS1	;SEE IF D2B
							; 6847		[BRX]_[BRX].OR.#,	;SIG START ON MOVE OR D2B
							; 6848		#/400000, HOLD RIGHT,
U 0755, 2315,3551,0606,4374,0007,0700,0000,0040,0000	; 6849		J/TRNSS1		;RETURN BYTE
							; 6850		[AR]_WORK[FILL],	;EDIT--NO SIG RETURN FILL
U 0756, 0002,3771,0003,7274,4004,1701,0000,0000,0244	; 6851		RETURN [2]		; ..
							; 6852		[AR]_AC[DSTP],		;EDIT--START OF SIG
U 0757, 0003,3771,0003,1276,6004,1701,0000,0000,1444	; 6853		RETURN [3]		; ..
							; 6854	
							; 6855	=1011
U 0533, 3504,1111,0703,4174,4007,0700,4000,0000,0000	; 6856	TRNNS1:	[AR]_[AR]-1, J/TRNNS2	;COMPENSATE FOR IGNORING SRC
							; 6857		[AR]_WORK[SLEN]+1,	;DEC TO BIN HAS NO DEST LENGTH
U 0537, 1120,0551,0703,7274,4007,0701,0000,0000,0242	; 6858		J/SRCMOD		;JUST UPDATE SRC LENTH
							; 6859	TRNNS2:	AC[DLEN]_[AR] TEST,	;PUT BACK DLEN AND
U 3504, 2316,3770,0303,1174,4007,0520,0400,0000,1443	; 6860		SKIP DP0		; SEE WHICH IS NOW SHORTER
							; 6861	=0	[AR]_WORK[SLEN],	;DEST IS SHORTER. DO NOT CHANGE
U 2316, 1120,3771,0003,7274,4007,0701,0000,0000,0242	; 6862		J/SRCMOD		; AMOUNT LEFT
							; 6863		[AR]_WORK[SLEN]+1,	;GO LOOK AT NEXT BYTE
U 2317, 1120,0551,0703,7274,4007,0701,0000,0000,0242	; 6864		J/SRCMOD
							; 6865	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 187
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- GET UNMODIFIED SOURCE BYTE	

							; 6866	.TOC	"EXTEND SUBROUTINES -- GET UNMODIFIED SOURCE BYTE"
							; 6867	
							; 6868	;CALL:
							; 6869	;	GSRC WITH SKIP ON SOURCE LENGTH
							; 6870	;	GETSRC IF LENGHT IS OK
							; 6871	;WITH:
							; 6872	;	AC1/ SOURCE BYTE POINTER
							; 6873	;RETURNS:
							; 6874	;	1 IF LENGTH RAN OUT
							; 6875	;	2 IF OK (BYTE IN AR)
							; 6876	;
							; 6877	=0
							; 6878	GSRC:	[AR]_AC[DLEN],		;LENGTH RAN OUT
U 2320, 0001,3771,0003,1276,6004,1701,0000,0000,1443	; 6879		RETURN [1]		;RESTORE AR AND RETURN
U 2321, 3505,3771,0003,1276,6007,0701,0000,0000,1441	; 6880	GETSRC:	[AR]_AC[SRCP]		;GET SRC PTR
							; 6881		IBP DP,	IBP SCAD,	;UPDATE BYTE POINTER
U 3505, 0231,3770,0305,4334,4016,7701,0000,0033,6000	; 6882		SCAD DISP, 3T		;SEE IF OFLOW
U 0231, 3507,3441,0503,4174,4007,0700,0000,0000,0000	; 6883	=01	[AR]_[BR], J/GSRC1	;NO OFLOW
U 0233, 3506,3770,0503,4334,4017,0700,0000,0032,6000	; 6884		SET P TO 36-S		;RESET P
U 3506, 3507,0111,0703,4170,4007,0700,0000,0000,0000	; 6885		[AR]_[AR]+1, HOLD LEFT	;BUMP Y
							; 6886	
U 3507, 2322,3440,0303,1174,4007,0700,0400,0000,1441	; 6887	GSRC1:	AC[SRCP]_[AR]		;STORE UPDATED POINTER
							; 6888	=0	READ [AR], LOAD BYTE EA,;SETUP TO FIGURE OUT
U 2322, 3115,3333,0003,4174,4217,0701,1010,0073,0500	; 6889		FE_P, 3T, CALL [BYTEAS]	; EFFECTIVE ADDRESS
							; 6890		READ [AR],		;LOOK AT POINTER
							; 6891		BYTE DISP,		;SEE IF 7 BIT
							; 6892		FE_FE.AND.S#, S#/0770,	;MASK OUT P FIELD
U 2323, 0340,3333,0003,4174,4006,5701,1000,0051,0770	; 6893		J/LDB1			;GO GET THE BYTE
							; 6894	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 188
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- STORE BYTE IN DESTINATION STRING

							; 6895	.TOC	"EXTEND SUBROUTINES -- STORE BYTE IN DESTINATION STRING"
							; 6896	
							; 6897	;CALL WITH:
							; 6898	;	AR/ BYTE TO STORE
							; 6899	;	AC4/ DESTINATION BYTE POINTER
							; 6900	;RETURNS:
							; 6901	;	AR & AC4/ UPDATED BYTE POINTER
							; 6902	;	ARX/ BYTE TO STORE
							; 6903	;	BR/ WORD TO MERGE WITH
							; 6904	;	6 ALWAYS
							; 6905	;
U 3510, 2324,3441,0304,4174,4007,0700,0000,0000,0000	; 6906	PUTDST:	[ARX]_[AR]		;SAVE BYTE
							; 6907	=0	[AR]_AC[DSTP],		;GET DEST POINTER
U 2324, 3511,3771,0003,1276,6007,0701,0010,0000,1444	; 6908		CALL [IDST]		;BUMP DEST POINTER
							; 6909		AD/A+B, A/ARX, B/ARX,	;SHIFT 7-BIT BYTE TO
							; 6910		SCAD/A, 3T,		; NATURAL PLACE, AND PUT
U 2325, 2265,0113,0404,4174,4007,0701,1000,0077,0000	; 6911		SCADA/BYTE5, LOAD FE	; INTO FE
							; 6912	=0*	READ [AR], BYTE DISP,	;GO PUT BYTE IN MEMORY
U 2265, 0360,3333,0003,4174,4006,5701,0010,0000,0000	; 6913		CALL [DPB1]		; ..
U 2267, 0006,4443,0000,4174,4004,1700,0000,0000,0000	; 6914		RETURN [6]		;ALL DONE
							; 6915	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 189
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND SUBROUTINES -- UPDATE DEST STRING POINTERS	

							; 6916	.TOC	"EXTEND SUBROUTINES -- UPDATE DEST STRING POINTERS"
							; 6917	
							; 6918	
							; 6919	;SUBROUTINE TO BUMP DST POINTERS
							; 6920	;CALL WITH:
							; 6921	;	AR/	AC[DSTP]
							; 6922	;	RETURN 1 WITH UPDATED POINTER STORED
							; 6923	;
U 3511, 2330,3770,0305,4334,4016,7701,0000,0033,6000	; 6924	IDST:	IBP DP, IBP SCAD, SCAD DISP, 3T
U 2330, 3513,3441,0503,4174,4217,0700,0000,0000,0600	; 6925	=0*	[AR]_[BR], LOAD DST EA, J/IDSTX
U 2332, 3512,3770,0503,4334,4017,0700,0000,0032,6000	; 6926		SET P TO 36-S
U 3512, 3513,0111,0703,4170,4217,0700,0000,0000,0600	; 6927		[AR]_[AR]+1, HOLD LEFT, LOAD DST EA
							; 6928	IDSTX:	AC[DSTP]_[AR], 3T,	;STORE PTR BACK
U 3513, 0230,3440,0303,1174,4006,6701,1400,0073,1444	; 6929		FE_P, DISP/EAMODE	;SAVE P FOR CMPDST
							; 6930	=100*
U 0230, 3120,0553,0300,2274,4007,0701,0200,0004,0712	; 6931	DSTEA:	VMA_[AR]+XR, START READ, PXCT BYTE DATA, 3T, J/BYTFET
U 0232, 3120,3443,0300,4174,4007,0700,0200,0004,0712	; 6932		VMA_[AR], START READ, PXCT BYTE DATA, J/BYTFET
U 0234, 3514,0553,0300,2274,4007,0701,0200,0004,0612	; 6933		VMA_[AR]+XR, START READ, PXCT/BIS-DST-EA, 3T, J/DSTIND
U 0236, 3514,3443,0300,4174,4007,0700,0200,0004,0612	; 6934		VMA_[AR], START READ, PXCT/BIS-DST-EA, J/DSTIND
							; 6935	
U 3514, 3515,3771,0003,4361,5217,0700,0200,0000,0602	; 6936	DSTIND:	MEM READ, [AR]_MEM, HOLD LEFT, LOAD DST EA
U 3515, 0230,4443,0000,2174,4006,6700,0000,0000,0000	; 6937		EA MODE DISP, J/DSTEA
							; 6938	
							; 6939	
							; 6940	;HERE TO TEST ILLEGAL BITS SET
							; 6941	;CALL WITH:
							; 6942	;	SKIP IF ALL BITS LEGAL
							; 6943	;	RETURN [4] IF OK, ELSE DO UUO
							; 6944	;
							; 6945	3556:		;EXTEND OF 0 COMES HERE
U 3556, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 6946	BITCHK:	UUO
U 3557, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 6947	3557:	RETURN [4]
							; 6948	
							; 6949	;HERE TO PUT FILL IN [AR] AND WORK[FILL]
							; 6950	GTFILL:	MEM READ,		;WAIT FOR DATA
U 3516, 3517,3771,0003,4365,5007,0700,0200,0000,0002	; 6951		[AR]_MEM		;PLACE IN AR
							; 6952		WORK[FILL]_[AR],	;SAVE FOR LATER
U 3517, 0010,3333,0003,7174,4004,1700,0400,0000,0244	; 6953		RETURN [10]		;RETURN TO CALLER
							; 6954	
							; 6955	;SUBROUTINE TO CLEAR FLAGS IN AR
							; 6956	CLRFLG:	[AR]_[AR].AND.#,	;CLEAR FLAGS IN AR
							; 6957		#/000777,		; ..
U 3520, 0001,4551,0303,4374,0004,1700,0000,0000,0777	; 6958		HOLD RIGHT, RETURN [1]
							; 6959	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 190
; EXTEND.MIC[1,2]	11:35 26-JULY-1984			EXTEND -- PAGE FAIL CLEANUP				

							; 6960	.TOC	"EXTEND -- PAGE FAIL CLEANUP"
							; 6961	
							; 6962	;BACK UP SOURCE POINTER
							; 6963	=0
							; 6964	BACKS:	[AR]_AC[SRCP],
U 2326, 3533,3771,0003,1276,6007,0701,0010,0000,1441	; 6965		CALL [BACKBP]		;BACKUP BP
U 2327, 2720,3440,0505,1174,4007,0700,0400,0000,1441	; 6966		AC[SRCP]_[BR], J/CLDISP
							; 6967	
U 3521, 3522,3771,0003,7274,4007,0701,0000,0000,0214	; 6968	CMSDST:	[AR]_WORK[SV.BRX]	;GET OLD SRC LEN
U 3522, 2334,0113,0703,0174,4007,0701,0400,0000,0000	; 6969		AC_[AR]+1, 3T		;BACK UP
							; 6970	;BACK UP DESTINATION POINTER
							; 6971	=0
							; 6972	BACKD:	[AR]_AC[DSTP],
U 2334, 3533,3771,0003,1276,6007,0701,0010,0000,1444	; 6973		CALL [BACKBP]
U 2335, 2720,3440,0505,1174,4007,0700,0400,0000,1444	; 6974		AC[DSTP]_[BR], J/CLDISP
							; 6975	
							; 6976	;FAILURES DURING MOVE STRING (BACKUP LENGTHS)
U 3523, 3524,1771,0003,7274,4007,0701,4000,0000,0242	; 6977	STRPF:	[AR]_-WORK[SLEN]	;GET AMOUNT LEFT
							; 6978	STRPF0:	[BR]_AC[DLEN], 4T,	;WHICH STRING IS LONGER?
U 3524, 2336,3771,0005,1276,6007,0522,0000,0000,1443	; 6979		SKIP DP0
							; 6980	=0
U 2336, 3526,3440,0303,1174,4007,0700,0400,0000,1443	; 6981	STRPF1:	AC[DLEN]_[AR], J/STPF1A	;SRC LONGER
U 2337, 2340,3441,0304,4174,4007,0700,0000,0000,0000	; 6982		[ARX]_[AR]		;COPY SRC LENGTH
							; 6983	=0	[ARX]_[ARX].OR.WORK[SV.BRX], ;REBUILD FLAGS
U 2340, 3731,3551,0404,7274,4007,0701,0010,0000,0214	; 6984		CALL [AC_ARX]		;RESET AC]SLEN]
U 2341, 3525,1111,0503,4174,4007,0700,4000,0000,0000	; 6985		[AR]_[AR]-[BR]		;MAKE DEST LEN
							; 6986	STRPF3:	AC[DLEN]_[AR],		;PUT BACK DEST LEN
U 3525, 2720,3440,0303,1174,4007,0700,0400,0000,1443	; 6987		J/CLDISP		;DO NEXT CLEANUP
							; 6988	
U 3526, 3530,0111,0503,4174,4007,0700,0000,0000,0000	; 6989	STPF1A:	[AR]_[AR]+[BR], J/STRPF2
							; 6990	
U 3527, 3530,1771,0003,7274,4007,0701,4000,0000,0242	; 6991	PFDBIN:	[AR]_-WORK[SLEN]	;RESTORE LENGTH
U 3530, 3531,3551,0303,7274,4007,0701,0000,0000,0214	; 6992	STRPF2:	[AR]_[AR].OR.WORK[SV.BRX]
U 3531, 2720,3440,0303,0174,4007,0700,0400,0000,0000	; 6993	PFGAC0:	AC_[AR], J/CLDISP	;PUT BACK SRC LEN AND FLAGS
							; 6994	
U 3532, 3524,7771,0003,7274,4007,0701,0000,0000,0242	; 6995	STRPF4:	[AR]_.NOT.WORK[SLEN], J/STRPF0
							; 6996	
							; 6997	BACKBP:	IBP DP, SCAD/A+B, SCADA/BYTE1, SCADB/SIZE, ;P_P+S
U 3533, 0001,3770,0305,4334,4014,1700,0000,0043,6000	; 6998		RETURN [1]
							; 6999	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 191
; INOUT.MIC[1,2]	13:32 7-JAN-1986			TRAPS							

							; 7000		.TOC	"TRAPS"
							; 7001	
U 3534, 3535,3741,0104,4074,4007,0700,0000,0000,0000	; 7002	TRAP:	[ARX]_PC WITH FLAGS	;SAVE THE PC WHICH CAUSED THE
							; 7003		WORK[TRAPPC]_[ARX],	; TRAP
U 3535, 2342,3333,0004,7174,4007,0340,0400,0000,0425	; 7004		SKIP KERNEL		;SEE IF UBR OR EBR
							; 7005	=0	[AR]_[AR]+[UBR],	;ADDRESS OF INSTRUCTION
							; 7006		MEM READ,		;WAIT FOR PREFETCH TO GET INTO
							; 7007					; THE CACHE. MAY PAGE FAIL BUT
							; 7008					; THAT IS OK
							; 7009		START READ,		;START FETCH
							; 7010		VMA PHYSICAL,		;ABSOLUTE ADDRESSING
U 2342, 3536,0111,1103,4364,4007,0700,0200,0024,1016	; 7011		J/TRP1			;JOIN COMMON CODE
							; 7012	
							; 7013		[AR]_[AR]+[EBR],	;WE COME HERE IN EXEC MODE
							; 7014		MEM READ,		;WAIT FOR PREFETCH TO GET INTO
							; 7015					; THE CACHE. MAY PAGE FAIL BUT
							; 7016					; THAT IS OK
							; 7017		START READ,		;START FETCH
							; 7018		VMA PHYSICAL,		;ABSOLUTE ADDRESSING
U 2343, 3536,0111,1003,4364,4007,0700,0200,0024,1016	; 7019		J/TRP1			;JOIN COMMON CODE
							; 7020	
							; 7021	TRP1:	MEM READ, [HR]_MEM,	;PLACE INSTRUCTION IN HR
U 3536, 3537,3771,0002,4365,5617,0700,0200,0000,0002	; 7022		LOAD INST		;LOAD IR, XR, @
							; 7023		[HR].AND.#,		;TEST TO SEE IF THIS
							; 7024		#/700000, 3T,		; IS A UUO
U 3537, 2344,4553,0200,4374,4007,0321,0000,0070,0000	; 7025		SKIP ADL.EQ.0
							; 7026	=0	CHANGE FLAGS,		;NOT A UUO
							; 7027		HOLD USER/1,		;CLEAR TRAP FLAGS
U 2344, 2735,4443,0000,4174,4467,0700,0000,0001,0000	; 7028		J/XCT1			;DO THE INSTRUCTION
U 2345, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7029		UUO			;DO THE UUO
							; 7030	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 192
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES					

							; 7031		.TOC	"IO -- INTERNAL DEVICES"
							; 7032	
							; 7033		.DCODE
D 0700, 1200,1700,4100					; 7034	700:	IOT,AC DISP,	J/GRP700
D 0701, 1200,1720,4100					; 7035		IOT,AC DISP,	J/GRP701
							; 7036		.UCODE
							; 7037	
U 1701, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7038	1701:	UUO		;DATAI APR,
U 1702, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7039	1702:	UUO		;BLKO APR,
U 1703, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7040	1703:	UUO		;DATAO APR,
U 1706, 3542,3771,0005,4304,4007,0701,0000,0000,0000	; 7041	1706:	[BR]_APR, J/APRSZ ;CONSZ APR,
U 1707, 3540,3771,0005,4304,4007,0701,0000,0000,0000	; 7042	1707:	[BR]_APR, J/APRSO ;CONSO APR,
							; 7043	1710:
U 1710, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7044	RDERA:	UUO		;BLKI PI,
U 1711, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7045	1711:	UUO		;DATAI PI,
U 1712, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7046	1712:	UUO		;BLKO PI,
U 1713, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7047	1713:	UUO		;DATAO PI,
U 1716, 0136,3441,1405,4174,4007,0700,0000,0000,0000	; 7048	1716:	[BR]_[PI], J/CONSZ ;CONSZ PI,
U 1717, 3541,3441,1405,4174,4007,0700,0000,0000,0000	; 7049	1717:	[BR]_[PI], J/CONSO ;CONSO PI,
							; 7050	
							; 7051	1720:
U 1720, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7052	GRP701:	UUO		;BLKI PAG,
U 1726, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7053	1726:	UUO		;CONSZ PAG,
U 1727, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7054	1727:	UUO		;CONSO PAG,
							; 7055	
							; 7056	;680I AND CACHE SWEEP STUFF
U 1730, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7057	1730:	UUO
U 1731, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7058	1731:	UUO
U 1732, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7059	1732:	UUO
U 1733, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7060	1733:	UUO
U 1734, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7061	1734:	UUO
U 1735, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7062	1735:	UUO
U 1736, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7063	1736:	UUO
U 1737, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7064	1737:	UUO
							; 7065	
U 3540, 3541,4251,0505,4374,4007,0700,0000,0000,7770	; 7066	APRSO:	[BR]_[BR].AND.# CLR LH, #/7770
U 3541, 0260,4113,0305,4174,4007,0330,0000,0000,0000	; 7067	CONSO:	[BR].AND.[AR], SKIP ADR.EQ.0, J/SKIP
							; 7068	
U 3542, 0136,4251,0505,4374,4007,0700,0000,0000,7770	; 7069	APRSZ:	[BR]_[BR].AND.# CLR LH, #/7770
							; 7070	136:					;STANDARD LOCATION FOR VERSION INFO,
							; 7071						;ANY UWORD THAT HAS A FREE # FIELD CAN
							; 7072						;BE USED.
							; 7073	CONSZ:	[BR].AND.[AR], SKIP ADR.EQ.0, J/DONE,
							; 7074		MICROCODE RELEASE(MAJOR)/UCR,	;MAJOR VERSION #
U 0136, 1400,4113,0305,4174,4007,0330,0000,0000,0021	; 7075		MICROCODE RELEASE(MINOR)/UCR	;MINOR VERSION # (FOR ID ONLY)
							; 7076	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 193
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES					

							; 7077	1700:
							; 7078	GRP700:
							; 7079	APRID:	[BR]_#,
U 1700, 0137,3771,0005,4374,4007,0700,0000,0001,0001	; 7080		#/4097.
							; 7081	137:	[BR]_#,
							; 7082		MICROCODE OPTION(INHCST)/OPT,
							; 7083		MICROCODE OPTION(NOCST)/OPT,
							; 7084		MICROCODE OPTION(NONSTD)/OPT,
							; 7085		MICROCODE OPTION(UBABLT)/OPT,
							; 7086		MICROCODE OPTION(KIPAGE)/OPT,
							; 7087		MICROCODE OPTION(KLPAGE)/OPT,
							; 7088		MICROCODE VERSION/UCV,
							; 7089		HOLD RIGHT,
U 0137, 3653,3771,0005,4374,0007,0700,0000,0047,0130	; 7090		J/RTNREG
							; 7091	
							; 7092	1704:
U 1704, 3543,3771,0005,7274,4007,0701,0000,0000,0230	; 7093	WRAPR:	[BR]_WORK[APR]
							; 7094		[BR]_[BR].AND.NOT.#,	;CLEAR THE OLD PIA
U 3543, 3544,5551,0505,4370,4007,0700,0000,0000,0007	; 7095		#/7, HOLD LEFT		; ..
U 3544, 3545,4551,0304,4374,4007,0700,0000,0000,0007	; 7096		[ARX]_[AR].AND.#, #/7	;PUT NEW PIA IN ARX
U 3545, 3546,3111,0405,4174,4007,0700,0000,0000,0000	; 7097		[BR]_[BR].OR.[ARX]	;PUT NEW PIA IN BR
							; 7098		[ARX]_[AR].AND.#, 	;MASK THE DATA BITS
U 3546, 3547,4551,0304,4374,4007,0700,0000,0000,7760	; 7099		#/007760		; DOWN TO ENABLES
U 3547, 2346,4553,0300,4374,4007,0331,0000,0010,0000	; 7100		TR [AR], #/100000	;WANT TO ENABLE ANY?
U 2346, 2347,3111,0405,4174,4007,0700,0000,0000,0000	; 7101	=0	[BR]_[BR].OR.[ARX]	;YES--SET THEM
U 2347, 2350,4553,0300,4374,4007,0331,0000,0004,0000	; 7102		TR [AR], #/40000	;WANT TO DISABLE ANY?
U 2350, 2351,5111,0405,4174,4007,0700,0000,0000,0000	; 7103	=0	[BR]_[BR].AND.NOT.[ARX]	;YES--CLEAR THEM
U 2351, 3550,3771,0006,4304,4007,0701,0000,0000,0000	; 7104		[BRX]_APR		;GET CURRENT STATUS
U 3550, 2352,4553,0300,4374,4007,0331,0000,0002,0000	; 7105		TR [AR], #/20000	;WANT TO CLEAR FLAGS?
U 2352, 2353,5111,0406,4174,4007,0700,0000,0000,0000	; 7106	=0	[BRX]_[BRX].AND.NOT.[ARX] ;YES--CLEAR BITS
U 2353, 2354,4553,0300,4374,4007,0331,0000,0001,0000	; 7107		TR [AR], #/10000	;WANT TO SET ANY FLAGS?
U 2354, 2355,3111,0406,4174,4007,0700,0000,0000,0000	; 7108	=0	[BRX]_[BRX].OR.[ARX]	;YES--SET FLAGS
U 2355, 2356,4553,0300,4374,4007,0331,0000,0003,0000	; 7109		TR [AR], #/30000	;ANY CHANGE AT ALL?
							; 7110	=0	READ [BRX],		;YES--LOAD NEW FLAGS
U 2356, 3553,3333,0006,4174,4007,0700,0000,0000,0000	; 7111		J/WRAPR2		;TURN OFF INTERRUPT 8080
U 2357, 3551,3333,0005,4174,4007,0700,0000,0000,0000	; 7112	WRAPR1:	READ [BR]		;FIX DPM TIMING BUG
							; 7113		READ [BR], 		;ENABLE CONDITIONS
U 3551, 3552,3333,0005,4174,4257,0700,0000,0000,0000	; 7114		SET APR ENABLES
							; 7115		WORK[APR]_[BR],		;SAVE FOR RDAPR
U 3552, 1400,3333,0005,7174,4007,0700,0400,0000,0230	; 7116		J/DONE			;ALL DONE
							; 7117	
							; 7118	WRAPR2:	READ [BRX], 		;LOAD NEW FLAGS
U 3553, 3554,3333,0006,4174,4237,0700,0000,0000,0000	; 7119		SPEC/APR FLAGS		; ..
							; 7120		[BRX]_[BRX].AND.NOT.#,	;CLEAR INTERRUPT THE 8080
U 3554, 3555,5551,0606,4370,4007,0700,0000,0000,2000	; 7121		#/002000, HOLD LEFT	; FLAG
							; 7122		READ [BRX], 		;LOAD NEW FLAGS
							; 7123		SPEC/APR FLAGS,		; ..
U 3555, 2357,3333,0006,4174,4237,0700,0000,0000,0000	; 7124		J/WRAPR1		;LOOP BACK
							; 7125	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 194
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES					

							; 7126	1705:
U 1705, 3560,3771,0005,7274,4007,0701,0000,0000,0230	; 7127	RDAPR:	[BR]_WORK[APR]
							; 7128		[BR]_[BR] SWAP,		;PUT ENABLES IN BOTH
U 3560, 3561,3770,0505,4344,0007,0700,0000,0000,0000	; 7129		HOLD RIGHT		; HALVES
							; 7130		[BR]_[BR].AND.#,	;SAVE ENABLES IN LH
							; 7131		#/7760,			;
U 3561, 3562,4551,0505,4374,0007,0700,0000,0000,7760	; 7132		HOLD RIGHT
							; 7133		[BR]_[BR].AND.#,	;SAVE PIA IN RH
							; 7134		#/7,
U 3562, 3563,4551,0505,4370,4007,0700,0000,0000,0007	; 7135		HOLD LEFT
U 3563, 3564,3771,0004,4304,4007,0701,0000,0000,0000	; 7136		[ARX]_APR		;READ THE APR FLAGS
							; 7137		[ARX]_[ARX].AND.# CLR LH, ;MASK OUT JUNK
U 3564, 3565,4251,0404,4374,4007,0700,0000,0000,7770	; 7138		#/007770		;KEEP 8 FLAGS
							; 7139		[BR]_[BR].OR.[ARX],	;MASH THE STUFF TOGETHER
U 3565, 3653,3111,0405,4174,4007,0700,0000,0000,0000	; 7140		J/RTNREG		;RETURN
							; 7141	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 195
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7142	.TOC	"IO -- INTERNAL DEVICES -- EBR & UBR"
							; 7143	
							; 7144		;UBR FORMAT:
							; 7145		;BITS  0 & 2	LOAD FLAGS (RETURNED ON RDUBR)
							; 7146		;BITS  3 - 5	ZERO
							; 7147		;BITS  6 -11	AC BLOCKS SELECTED - CUR,PREV
							; 7148		;BITS 16 -35	UPT PHYSICAL ADDRESS
							; 7149	
							; 7150	1723:
							; 7151	WRUBR:	VMA_[AR],		;LOAD E INTO VMA
U 1723, 3566,3443,0300,4174,4007,0700,0200,0004,0012	; 7152		START READ		;START MEMORY
							; 7153		MEM READ,		;WAIT FOR DATA
							; 7154		[AR]_MEM, 3T,		;PUT IT INTO THE AR
U 3566, 2360,3771,0003,4365,5007,0521,0200,0000,0002	; 7155		SKIP DP0		;SEE IF WE WANT TO LOAD
							; 7156					; AC BLOCK NUMBERS
							; 7157	
							; 7158	=0	[AR]_[AR].AND.#,	;NO--CLEAR JUNK IN AR (ALL BUT LD UBR)
							; 7159		#/100000,		; LEAVE ONLY LOAD UBR
							; 7160		HOLD RIGHT,		; IN LEFT HALF
							; 7161		SKIP ADL.EQ.0, 3T,	;SEE IF WE WANT TO LOAD UBR
U 2360, 2362,4551,0303,4374,0007,0321,0000,0010,0000	; 7162		J/ACBSET		;SKIP AROUND UBR LOAD
							; 7163	
							; 7164		;HERE WHEN WE WANT TO LOAD AC BLOCK SELECTION
							; 7165		[UBR]_[UBR].AND.#,	;MASK OUT THE UBR'S OLD
							; 7166		#/770077,		; AC BLOCK NUMBERS
U 2361, 3567,4551,1111,4374,0007,0700,0000,0077,0077	; 7167		HOLD RIGHT		;IN THE LEFT HALF
							; 7168	
							; 7169		[AR]_[AR].AND.#,	;CLEAR ALL BUT NEW SELECTION
							; 7170		#/507700,		;AND LOAD BITS
U 3567, 3570,4551,0303,4374,0007,0700,0000,0050,7700	; 7171		HOLD RIGHT		;IN AR LEFT
							; 7172	
							; 7173		[AR].AND.#,		;SEE IF WE WANT TO LOAD
							; 7174		#/100000, 3T,		; UBR ALSO
U 3570, 2362,4553,0300,4374,4007,0321,0000,0010,0000	; 7175		SKIP ADL.EQ.0
							; 7176	
							; 7177		;HERE WITH AR LEFT = NEW AC BLOCKS OR ZERO, 
							; 7178		;SKIP IF DON'T LOAD UBR
							; 7179	=0
							; 7180	ACBSET: [BR]_[AR].AND.#,	;COPY UBR PAGE NUMBER
							; 7181		#/3777,			; INTO BR
U 2362, 3571,4551,0305,4374,4007,0700,0000,0000,3777	; 7182		J/SETUBR		;GO LOAD UBR
							; 7183	
							; 7184		[UBR]_[UBR].OR.[AR],	;DO NOT LOAD UBR
							; 7185					; PUT AC BLOCK # IN
							; 7186		HOLD RIGHT,		; THE LEFT HALF
							; 7187		LOAD AC BLOCKS,		;LOAD HARDWARE
U 2363, 1400,3111,0311,4174,0477,0700,0000,0000,0000	; 7188		J/DONE			;ALL DONE
							; 7189	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 196
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7190		;HERE WITH AR LEFT AS BEFORE, AR RIGHT = MASKED PAGE #
							; 7191	SETUBR: [BR]_0, 		;CLEAR BR LEFT
							; 7192		HOLD RIGHT,		;BR IS 0,,PAGE #
U 3571, 2364,4221,0005,4174,0007,0700,2000,0071,0007	; 7193		SC_7			;PUT THE COUNT IN SC
							; 7194	=0
							; 7195	STUBRS: [BR]_[BR]*2,		;SHIFT BR OVER
							; 7196		STEP SC,		; 9 PLACES
U 2364, 2364,3445,0505,4174,4007,0630,2000,0060,0000	; 7197		J/STUBRS		;PRODUCING UPT ADDRESS
							; 7198	
							; 7199		[UBR]_[UBR].AND.#,	;MASK OUT OLD UBR
							; 7200		#/777774,		; BITS IN
U 2365, 3572,4551,1111,4374,0007,0700,0000,0077,7774	; 7201		HOLD RIGHT		; LEFT HALF
							; 7202	
							; 7203		[UBR]_0,		;CLEAR RIGHT HALF
U 3572, 3573,4221,0011,4170,4007,0700,0000,0000,0000	; 7204		HOLD LEFT		;UBR IS FLGS+ACBLK+0,,0
							; 7205	
U 3573, 3574,3111,0511,4174,4007,0700,0000,0000,0000	; 7206		[UBR]_[UBR].OR.[BR]	;PUT IN PAGE TABLE ADDRESS
							; 7207	
							; 7208		[UBR]_[UBR].OR.[AR],	;PUT IN AC BLOCK #
							; 7209		HOLD RIGHT,		; IN LEFT HALF
							; 7210		LOAD AC BLOCKS,		;TELL HARDWARE
U 3574, 2432,3111,0311,4174,0477,0700,0000,0000,0000	; 7211		J/SWEEP			;CLEAR CACHE
							; 7212	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 197
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7213	1724:
U 1724, 2366,3445,0303,4174,4007,0700,2000,0071,0006	; 7214	WREBR:	[AR]_[AR]*2, SC_6	;DO A SHIFT OVER 8 MORE
							; 7215	=0
U 2366, 2366,3445,0303,4174,4007,0630,2000,0060,0000	; 7216	WREBR1:	[AR]_[AR]*2, STEP SC, J/WREBR1	;SKIP WHEN = -1
							; 7217	.IF/FULL			;DO NOT ENABLE PAGING IN SMALL
							; 7218					; MICROCODE.
U 2367, 3575,3771,0005,7274,4007,0701,0000,0000,0230	; 7219		[BR]_WORK[APR]
U 3575, 3576,4551,0505,4370,4007,0700,0000,0074,7777	; 7220		[BR]_[BR].AND.#, #/747777, HOLD LEFT
U 3576, 2370,4553,0300,4374,4007,0321,0000,0000,0020	; 7221		[AR].AND.#, #/20, 3T, SKIP ADL.EQ.0	;BIT 22 - TRAP ENABLE
U 2370, 2371,3551,0505,4370,4007,0700,0000,0003,0000	; 7222	=0	[BR]_[BR].OR.#, #/030000, HOLD LEFT	;SET - ALLOW TRAPS TO HAPPEN
U 2371, 3577,3333,0005,4174,4257,0700,0000,0000,0000	; 7223		READ [BR], SET APR ENABLES
U 3577, 3600,3333,0005,7174,4007,0700,0400,0000,0230	; 7224		WORK[APR]_[BR]
							; 7225	.ENDIF/FULL
							; 7226	
							; 7227	.IF/KIPAGE
							; 7228	.IF/KLPAGE
U 3600, 3601,3441,0310,4174,4007,0700,0000,0000,0000	; 7229		[EBR]_[AR]		;NOTE: SHIFTED LEFT 9 BITS
U 3601, 2372,4553,1000,4374,4007,0321,0000,0000,0040	; 7230		[EBR].AND.#, #/40, 3T, SKIP ADL.EQ.0	;BIT 21 - KL PAGING ENABLE
U 2372, 2432,3551,1010,4374,0007,0700,0000,0040,0000	; 7231	=0	[EBR]_[EBR].OR.#, #/400000, HOLD RIGHT, J/SWEEP ;YES, SET INTERNAL FLAG
U 2373, 2432,5551,1010,4374,0007,0700,0000,0040,0000	; 7232		[EBR]_[EBR].AND.NOT.#, #/400000, HOLD RIGHT, J/SWEEP ;NO, CLR BIT 0
							; 7233	.ENDIF/KLPAGE
							; 7234	.ENDIF/KIPAGE
							; 7235	
							;;7236	.IFNOT/KLPAGE			;MUST BE KI ONLY
							;;7237		[EBR]_[AR],J/SWEEP	;SO INTERNAL FLAG ISN'T USED
							; 7238	.ENDIF/KLPAGE
							; 7239	
							;;7240	.IFNOT/KIPAGE			;MUST BE KL ONLY
							;;7241		[EBR]_[AR],J/SWEEP	;SO INTERNAL FLAG ISN'T USED
							; 7242	.ENDIF/KIPAGE
							; 7243	
							; 7244	1725:
U 1725, 2374,3447,1005,4174,4007,0700,2000,0071,0006	; 7245	RDEBR:	[BR]_[EBR]*.5, SC_6
							; 7246	=0
U 2374, 2374,3447,0505,4174,4007,0630,2000,0060,0000	; 7247	RDEBR1:	[BR]_[BR]*.5, STEP SC, J/RDEBR1
U 2375, 3602,4551,0505,4374,4007,0700,0000,0006,3777	; 7248		[BR]_[BR].AND.#, #/63777 ;MASK TO JUST EBR
							; 7249		[BR]_0,			;CLEAR LEFT HALF
							; 7250		HOLD RIGHT,		; BITS
U 3602, 3653,4221,0005,4174,0007,0700,0000,0000,0000	; 7251		J/RTNREG		;RETURN ANSWER
							; 7252	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 198
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- EBR & UBR			

							; 7253	1721:	
U 1721, 2376,4551,1105,4374,0007,0700,0000,0050,7700	; 7254	RDUBR:	[BR]_[UBR].AND.#,#/507700,HOLD RIGHT	;GET LOAD BITS AND AC BLOCKS
U 2376, 2400,3447,1106,4174,4007,0700,2010,0071,0006	; 7255	=0	[BRX]_[UBR]*.5, SC_6, CALL [GTPCW1]	;SET SC (9) START SHIFT,GET UBR
							; 7256		VMA_[AR],START WRITE,	;START TO
U 2377, 3654,3443,0300,4174,4007,0700,0200,0003,0012	; 7257		J/RTNRG1		;RETURN DATA
							; 7258	
							; 7259	
U 3603, 3604,4551,1105,4374,0007,0700,0000,0050,7700	; 7260	GETPCW:	[BR]_[UBR].AND.#,#/507700,HOLD RIGHT	;GET LOAD BITS AND AC BLOCKS
U 3604, 2400,3447,1106,4174,4007,0700,2000,0071,0006	; 7261		[BRX]_[UBR]*.5, SC_6			;SET SC (9) START SHIFT
							; 7262	
							; 7263	=0
U 2400, 2400,3447,0606,4174,4007,0630,2000,0060,0000	; 7264	GTPCW1:	[BRX]_[BRX]*.5, STEP SC, J/GTPCW1	;SHIFT UBR ADDR TO PAGE #
U 2401, 3605,4551,0606,4374,4007,0700,0000,0000,3777	; 7265		[BRX]_[BRX].AND.#, #/3777		;ONLY PAGE #
U 3605, 0001,3441,0605,4170,4004,1700,0000,0000,0000	; 7266		[BR]_[BRX], HOLD LEFT, RETURN [1]	;MOVE PAGE # TO RH OF RESULT
							; 7267	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 199
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- KL PAGING REGISTERS		

							; 7268	.TOC	"IO -- INTERNAL DEVICES -- KL PAGING REGISTERS"
							; 7269	
							; 7270		.DCODE
D 0702, 1216,1760,4700					; 7271	702:	IOT,AC DISP,	M,	J/GRP702
							; 7272		.UCODE
							; 7273	
							; 7274	1760:
							; 7275	GRP702:
U 1760, 3653,3771,0005,7274,4007,0701,0000,0000,0215	; 7276	RDSPB:	[BR]_WORK[SBR], J/RTNREG
							; 7277	1761:
U 1761, 3653,3771,0005,7274,4007,0701,0000,0000,0216	; 7278	RDCSB:	[BR]_WORK[CBR], J/RTNREG
							; 7279	1762:
U 1762, 3653,3771,0005,7274,4007,0701,0000,0000,0220	; 7280	RDPUR:	[BR]_WORK[PUR], J/RTNREG
							; 7281	1763:
U 1763, 3653,3771,0005,7274,4007,0701,0000,0000,0217	; 7282	RDCSTM:	[BR]_WORK[CSTM], J/RTNREG
							; 7283	1766:
U 1766, 3653,3771,0005,7274,4007,0701,0000,0000,0227	; 7284	RDHSB:	[BR]_WORK[HSBADR], J/RTNREG
U 1767, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7285	1767:	UUO
							; 7286	
							; 7287	1770:
U 1770, 3606,4443,0000,4174,4007,0703,0200,0006,0002	; 7288	WRSPB:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3606, 3607,3771,0003,4365,5007,0700,0200,0000,0002	; 7289		MEM READ, [AR]_MEM
U 3607, 1400,3333,0003,7174,4007,0700,0400,0000,0215	; 7290		WORK[SBR]_[AR], J/DONE
							; 7291	1771:
U 1771, 3610,4443,0000,4174,4007,0703,0200,0006,0002	; 7292	WRCSB:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3610, 3611,3771,0003,4365,5007,0700,0200,0000,0002	; 7293		MEM READ, [AR]_MEM
U 3611, 1400,3333,0003,7174,4007,0700,0400,0000,0216	; 7294		WORK[CBR]_[AR], J/DONE
							; 7295	1772:
U 1772, 3612,4443,0000,4174,4007,0703,0200,0006,0002	; 7296	WRPUR:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3612, 3613,3771,0003,4365,5007,0700,0200,0000,0002	; 7297		MEM READ, [AR]_MEM
U 3613, 1400,3333,0003,7174,4007,0700,0400,0000,0220	; 7298		WORK[PUR]_[AR], J/DONE
							; 7299	1773:
U 1773, 3614,4443,0000,4174,4007,0703,0200,0006,0002	; 7300	WRCSTM:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3614, 3615,3771,0003,4365,5007,0700,0200,0000,0002	; 7301		MEM READ, [AR]_MEM
U 3615, 1400,3333,0003,7174,4007,0700,0400,0000,0217	; 7302		WORK[CSTM]_[AR], J/DONE
							; 7303	1776:
U 1776, 3616,4443,0000,4174,4007,0703,0200,0006,0002	; 7304	WRHSB:	START READ,WRITE TEST,5T	;WAIT FOR (?) WRITE-TEST PF
U 3616, 3617,3771,0003,4365,5007,0700,0200,0000,0002	; 7305		MEM READ, [AR]_MEM
U 3617, 1400,3333,0003,7174,4007,0700,0400,0000,0227	; 7306		WORK[HSBADR]_[AR], J/DONE
							; 7307	
U 1777, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7308	1777:	UUO
							; 7309	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 200
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- TIMER CONTROL			

							; 7310	.TOC	"IO -- INTERNAL DEVICES -- TIMER CONTROL"
							; 7311	
							; 7312	
							; 7313					;BEGIN [123]
							; 7314	TICK:	[AR]_WORK[TIME1],	;GET LOW WORD
U 3620, 3621,3771,0003,7274,4117,0701,0000,0000,0301	; 7315		SPEC/CLRCLK		;CLEAR CLOCK FLAG
							; 7316					;END [123]
U 3621, 3622,4751,1205,4374,4007,0700,0000,0001,0000	; 7317	TOCK:	[BR]_0 XWD [10000]	;2^12 UNITS PER MS
U 3622, 3623,0111,0503,4174,4007,0700,0000,0000,0000	; 7318		[AR]_[AR]+[BR]		;INCREMENT THE TIMER
U 3623, 2402,3770,0303,4174,0007,0520,0000,0000,0000	; 7319		FIX [AR] SIGN, SKIP DP0	;SEE IF IT OVERFLOWED
							; 7320	=0
							; 7321	TOCK1:	WORK[TIME1]_[AR],	;STORE THE NEW TIME
U 2402, 3624,3333,0003,7174,4007,0700,0400,0000,0301	; 7322		J/TOCK2			;SKIP OVER THE OVERFLOW CODE
U 2403, 2331,3771,0003,7274,4007,0701,0000,0000,0300	; 7323		[AR]_WORK[TIME0]	 ;GET HIGH WORD
							; 7324	=0*	[AR]_[AR]+1,		;BUMP IT
U 2331, 3632,0111,0703,4174,4007,0700,0010,0000,0000	; 7325		CALL [WRTIM1]		;STORE BACK IN RAM
							; 7326		[AR]_0,			;CAUSE LOW WORD WORD
U 2333, 2402,4221,0003,4174,4007,0700,0000,0000,0000	; 7327		J/TOCK1			; TO GET STORED
U 3624, 3625,3771,0003,7274,4007,0701,0000,0000,0303	; 7328	TOCK2:	[AR]_WORK[TTG]
							; 7329		[AR]_[AR]-[BR],		;COUNT DOWN TIME TO GO
U 3625, 2404,1111,0503,4174,4007,0421,4000,0000,0000	; 7330		SKIP AD.LE.0		;SEE IF IT TIMED OUT
							; 7331	=0
							; 7332	TOCK3:	WORK[TTG]_[AR],		;SAVE NEW TIME TO GO
U 2404, 0002,3333,0003,7174,4004,1700,0400,0000,0303	; 7333		RETURN [2]		;ALL DONE
U 2405, 3626,3771,0003,7274,4007,0701,0000,0000,0302	; 7334		[AR]_WORK[PERIOD]
U 3626, 3627,3771,0005,4304,4007,0701,0000,0000,0000	; 7335		[BR]_APR		;GET CURRENT FLAGS
U 3627, 3630,3551,0505,4374,4007,0700,0000,0000,0040	; 7336		[BR]_[BR].OR.#, #/40	;SET TIMER INTERRUPT FLAG
							; 7337		READ [BR],		;PLACE ON DP AND
							; 7338		SPEC/APR FLAGS,		; LOAD INTO HARDWARE
U 3630, 2404,3333,0005,4174,4237,0700,0000,0000,0000	; 7339		J/TOCK3			;ALL DONE
							; 7340	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 201
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- WRTIME & RDTIME		

							; 7341	.TOC	"IO -- INTERNAL DEVICES -- WRTIME & RDTIME"
							; 7342	
							; 7343	1774:
U 1774, 3631,4443,0000,4174,4007,0700,0200,0004,0002	; 7344	WRTIME:	START READ		;FETCH WORD AT E
							; 7345		MEM READ,		;WAIT FOR DATA
U 3631, 1124,3771,0003,4365,5007,0700,0200,0000,0002	; 7346		[AR]_MEM		;PUT WORD IN AR
							; 7347	=00	VMA_[HR]+1,		;BUMP E
							; 7348		START READ,		;START MEMORY
U 1124, 3721,0111,0702,4170,4007,0700,0210,0004,0012	; 7349		CALL [LOADARX]		;PUT DATA IN ARX
							; 7350		[ARX]_[ARX].AND.#,	;CLEAR PART HELD IN
							; 7351		#/770000,		; HARDWARE COUNTER
U 1125, 3632,4551,0404,4370,4007,0700,0010,0077,0000	; 7352		HOLD LEFT,  CALL [WRTIM1]
							; 7353	=11	WORK[TIME1]_[ARX],	;IN WORK SPACE
U 1127, 1400,3333,0004,7174,4007,0700,0400,0000,0301	; 7354		J/DONE			;NEXT INSTRUCTION
							; 7355	=
							; 7356	WRTIM1:	WORK[TIME0]_[AR],	;SAVE THE NEW VALUE
U 3632, 0002,3333,0003,7174,4004,1700,0400,0000,0300	; 7357		RETURN [2]
							; 7358	
							; 7359	1764:
U 1764, 3633,4451,1205,4324,4007,0700,0000,0000,0000	; 7360	RDTIME:	[BR]_TIME		;READ THE TIME
U 3633, 3634,4451,1204,4324,4007,0700,0000,0000,0000	; 7361		[ARX]_TIME		; AGAIN
U 3634, 3635,4451,1206,4324,4007,0700,0000,0000,0000	; 7362		[BRX]_TIME		; AGAIN
							; 7363		[BR].XOR.[ARX],		;SEE IF STABLE
U 3635, 2406,6113,0405,4174,4007,0621,0000,0000,0000	; 7364		SKIP AD.EQ.0		; ..
U 2406, 2407,3441,0604,4174,4007,0700,0000,0000,0000	; 7365	=0	[ARX]_[BRX]		;NO THEN NEXT TRY MUST BE OK
U 2407, 3636,3771,0005,7274,4007,0701,0000,0000,0300	; 7366		[BR]_WORK[TIME0]
							; 7367		[ARX]_[ARX]+WORK[TIME1], ;COMBINE PARTS
U 3636, 1130,0551,0404,7274,4007,0671,0000,0000,0301	; 7368		SKIP/-1 MS		;SEE IF OVERFLOW HAPPENED
							; 7369	=00	SPEC/CLRCLK,		;CLEAR CLOCK FLAG
							; 7370		[AR]_WORK[TIME1], 2T,	;GET LOW WORD FOR TOCK
U 1130, 3621,3771,0003,7274,4117,0700,0010,0000,0301	; 7371		CALL [TOCK]		;UPDATE CLOCKS
							; 7372		READ [HR], LOAD VMA,	;DID NOT OVERFLOW
U 1131, 3637,3333,0002,4174,4007,0700,0200,0003,0012	; 7373		START WRITE, J/RDTIM1	;STORE ANSWER
U 1132, 1764,4443,0000,4174,4007,0700,0000,0000,0000	; 7374		J/RDTIME		;TRY AGAIN
							; 7375	=
U 3637, 3640,3333,0005,4175,5007,0701,0200,0000,0002	; 7376	RDTIM1:	MEM WRITE, MEM_[BR]
U 3640, 3641,0111,0702,4170,4007,0700,0200,0003,0012	; 7377		VMA_[HR]+1, LOAD VMA, START WRITE
U 3641, 1400,3333,0004,4175,5007,0701,0200,0000,0002	; 7378		MEM WRITE, MEM_[ARX], J/DONE
							; 7379	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 202
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- WRINT & RDINT			

							; 7380	.TOC	"IO -- INTERNAL DEVICES -- WRINT & RDINT"
							; 7381	
							; 7382	
							; 7383	1775:
U 1775, 3642,4443,0000,4174,4007,0700,0200,0004,0002	; 7384	WRINT:	START READ
U 3642, 3643,3771,0003,4365,5007,0700,0200,0000,0002	; 7385		MEM READ, [AR]_MEM
U 3643, 3644,3333,0003,7174,4007,0700,0400,0000,0302	; 7386		WORK[PERIOD]_[AR]
							; 7387		WORK[TTG]_[AR],
U 3644, 1400,3333,0003,7174,4007,0700,0400,0000,0303	; 7388		J/DONE
							; 7389	
							; 7390	1765:
							; 7391	RDINT:	[BR]_WORK[PERIOD],
U 1765, 3653,3771,0005,7274,4007,0701,0000,0000,0302	; 7392		J/RTNREG
							; 7393	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 203
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- RDPI & WRPI			

							; 7394	.TOC	"IO -- INTERNAL DEVICES -- RDPI & WRPI"
							; 7395	
							; 7396	1715:
U 1715, 3653,3441,1405,4174,4007,0700,0000,0000,0000	; 7397	RDPI:	[BR]_[PI], J/RTNREG
							; 7398	
							; 7399	1714:
U 1714, 2410,4553,0300,4374,4007,0331,0000,0001,0000	; 7400	WRPI:	TR [AR], PI.CLR/1
U 2410, 2411,4221,0014,4174,4007,0700,0000,0000,0000	; 7401	=0	[PI]_0
U 2411, 2412,4553,0300,4374,4007,0331,0000,0074,0000	; 7402		TR [AR], PI.MBZ/17
U 2412, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7403	=0	UUO
U 2413, 3645,4551,0305,4374,4007,0700,0000,0000,0177	; 7404		[BR]_[AR].AND.#,#/177
U 3645, 3646,3770,0505,4344,0007,0700,0000,0000,0000	; 7405		[BR]_[BR] SWAP, HOLD RIGHT
U 3646, 2414,4553,0300,4374,4007,0331,0000,0002,0000	; 7406		TR [AR], PI.DIR/1
U 2414, 2415,5111,0514,4174,0007,0700,0000,0000,0000	; 7407	=0	[PI]_[PI].AND.NOT.[BR], HOLD RIGHT
U 2415, 2416,4553,0300,4374,4007,0331,0000,0000,4000	; 7408		TR [AR], PI.REQ/1
U 2416, 2417,3111,0514,4174,0007,0700,0000,0000,0000	; 7409	=0	[PI]_[PI].OR.[BR], HOLD RIGHT
U 2417, 2420,4553,0300,4374,4007,0331,0000,0000,0200	; 7410		TR [AR], PI.TSN/1
U 2420, 2421,3551,1414,4370,4007,0700,0000,0000,0200	; 7411	=0	[PI]_[PI].OR.#,PI.ON/1, HOLD LEFT
U 2421, 2422,4553,0300,4374,4007,0331,0000,0000,0400	; 7412		TR [AR], PI.TSF/1
U 2422, 2423,5551,1414,4370,4007,0700,0000,0000,0200	; 7413	=0	[PI]_[PI].AND.NOT.#,PI.ON/1, HOLD LEFT
U 2423, 2424,4553,0300,4374,4007,0331,0000,0000,2000	; 7414		TR [AR], PI.TCN/1
U 2424, 2425,3111,0514,4170,4007,0700,0000,0000,0000	; 7415	=0	[PI]_[PI].OR.[BR], HOLD LEFT
U 2425, 0304,4553,0300,4374,4007,0331,0000,0000,1000	; 7416		TR [AR], PI.TCF/1
U 0304, 0305,5111,0514,4170,4007,0700,0000,0000,0000	; 7417	=0**0	[PI]_[PI].AND.NOT.[BR], HOLD LEFT
U 0305, 3650,3770,1416,4344,4007,0700,0010,0000,0000	; 7418	PIEXIT:	CALL LOAD PI
							; 7419	=1**1
U 0315, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 7420		DONE
							; 7421	=
							; 7422	
							; 7423	;SUBROUTINE TO LOAD PI HARDWARE
							; 7424	;CALL WITH:
							; 7425	;	CALL LOAD PI
							; 7426	;RETURNS 10 WITH PI HARDWARE LOADED
							; 7427	;
U 3647, 3650,3770,1416,4344,4007,0700,0000,0000,0000	; 7428	LOADPI:	[T0]_[PI] SWAP		;PUT ACTIVE CHANS IN LH
U 3650, 3651,2441,0716,4170,4007,0700,4000,0000,0000	; 7429	LDPI2:	[T0]_-1, HOLD LEFT	;DONT MASK RH
U 3651, 3652,4111,1416,4174,4007,0700,0000,0000,0000	; 7430		[T0]_[T0].AND.[PI]	;ONLY REQUEST CHANS THAT ARE ON
							; 7431		.NOT.[T0], LOAD PI,	;RELOAD HARDWARE
U 3652, 0010,7443,1600,4174,4434,1700,0000,0000,0000	; 7432		 RETURN [10]		;RETURN TO CALLER
							; 7433	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 204
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7434	.TOC	"IO -- INTERNAL DEVICES -- SUBROUTINES"
							; 7435	
							; 7436	
							; 7437	;HERE WITH SOMETHING IN BR STORE IT @AR
U 3653, 3654,3443,0300,4174,4007,0700,0200,0003,0012	; 7438	RTNREG:	VMA_[AR], START WRITE
U 3654, 1400,3333,0005,4175,5007,0701,0200,0000,0002	; 7439	RTNRG1:	MEM WRITE, MEM_[BR], J/DONE
							; 7440	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 205
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7441	;CACHE SWEEP
							; 7442	
							; 7443	1722:
							; 7444	CLRPT:	VMA_[AR],		;PUT CORRECT ADDRESS IN VMA
U 1722, 3655,3443,0300,4174,4147,0700,0200,0000,0010	; 7445		LOAD PAGE TABLE		;GET SET TO WRITE PAGE TABLE
U 3655, 2426,4221,0003,4174,4007,0700,0000,0000,0000	; 7446		[AR]_0			;CLEAR ENTRY
							; 7447	=0	[AR]_#,#/377377,	;INITIAL VMA VALUE
U 2426, 3661,3771,0003,4374,4007,0700,0010,0037,7377	; 7448		CALL [SSWEEP]		;LOAD THE SC
							; 7449		[BR]_#, #/1001,		;CONSTANT TO KEEP ADDING
U 2427, 3656,3771,0005,4374,4247,0700,0000,0000,1001	; 7450		CLRCSH			;START TO CLEAR CACHE
U 3656, 2430,3333,0003,4174,4247,0700,0000,0000,1000	; 7451		READ [AR], CLRCSH	;FIRST THING TO CLEAR
							; 7452	=0
							; 7453	CLRPTL:	[AR]_[AR]-[BR],		;UPDATE AR (AND PUT ON DP)
							; 7454		CLRCSH,			;SWEEP ON NEXT STEP
							; 7455		STEP SC,		;SKIP IF WE ARE DONE
U 2430, 2430,1111,0503,4174,4247,0630,6000,0060,1000	; 7456		J/CLRPTL		;LOOP FOR ALL ENTRIES
U 2431, 2435,3333,0003,4174,4007,0700,0000,0000,0000	; 7457		READ [AR], J/ZAPPTA	;CLEAR LAST ENTRY
							; 7458	
							; 7459	=0
							; 7460	SWEEP:	[AR]_#,#/377377,	;INITIAL VMA VALUE
U 2432, 3661,3771,0003,4374,4007,0700,0010,0037,7377	; 7461		CALL [SSWEEP]		;LOAD NUMBER OF STEPS INTO SC
							; 7462		[BR]_#, #/1001,		;CONSTANT TO KEEP ADDING
U 2433, 3657,3771,0005,4374,4347,0700,0000,0000,1001	; 7463		SWEEP			;START SWEEP
U 3657, 2434,3333,0003,4174,4347,0700,0000,0000,1000	; 7464		READ [AR], SWEEP	;FIRST THING TO CLEAR
							; 7465	=0
							; 7466	SWEEPL:	[AR]_[AR]-[BR],		;UPDATE AR (AND PUT ON DP)
							; 7467		SWEEP,			;SWEEP ON NEXT STEP
							; 7468		STEP SC,		;SKIP IF WE ARE DONE
U 2434, 2434,1111,0503,4174,4347,0630,6000,0060,1000	; 7469		J/SWEEPL		;LOOP FOR ALL ENTRIES
							; 7470					;CLEAR LAST ENTRY AND
U 2435, 3660,4223,0000,7174,4007,0700,0400,0000,0424	; 7471	ZAPPTA:	WORK[PTA.U]_0		; FORGET PAGE TABLE ADDRESS
							; 7472		WORK[PTA.E]_0,		;FORGET PAGE TABLE ADDRESS
U 3660, 1400,4223,0000,7174,4007,0700,0400,0000,0423	; 7473		J/DONE			;ALL DONE
							; 7474	
							; 7475	SSWEEP:	SC_S#, S#/375,		;NUMBER OF STEPS
U 3661, 0001,4443,0000,4174,4004,1700,2000,0071,0375	; 7476		RETURN [1]		;RETURN
							; 7477	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 206
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7478	;WE COME HERE EITHER FROM NEXT INSTRUCTION DISPATCH OR PAGE FAIL
							; 7479	; LOGIC. IN ALL CASES, THE CURRENT INSTRUCTION IS CORRECTLY SETUP
							; 7480	; TO RESTART PROPERLY.
							; 7481	
							; 7482	;FIRST SET THE CORRECT PI IN PROGRESS BIT
							; 7483	;	[FLG]_[FLG].OR.#,FLG.PI/1, HOLD RIGHT,
							; 7484	;		J/PI		;SET PI CYCLE AND PROCESS PI
							; 7485	=1000
							; 7486	PI:	AD/D, DBUS/PI NEW,	;LOOK AT NEW LEVEL
							; 7487		DISP/DP LEFT, 3T,	;DISPATCH ON IT
U 0770, 0770,3773,0000,4074,4003,1701,0000,0000,0000	; 7488		J/PI			;GO TO 1 OF NEXT 7 PLACES
U 0771, 3662,3551,1414,4370,4007,0700,0000,0004,0000	; 7489	=1001	[PI]_[PI].OR.#, #/040000, HOLD LEFT, J/PIP1
U 0772, 3663,3551,1414,4370,4007,0700,0000,0002,0000	; 7490	=1010	[PI]_[PI].OR.#, #/020000, HOLD LEFT, J/PIP2
U 0773, 3664,3551,1414,4370,4007,0700,0000,0001,0000	; 7491	=1011	[PI]_[PI].OR.#, #/010000, HOLD LEFT, J/PIP3
U 0774, 3665,3551,1414,4370,4007,0700,0000,0000,4000	; 7492	=1100	[PI]_[PI].OR.#, #/004000, HOLD LEFT, J/PIP4
U 0775, 3666,3551,1414,4370,4007,0700,0000,0000,2000	; 7493	=1101	[PI]_[PI].OR.#, #/002000, HOLD LEFT, J/PIP5
U 0776, 3667,3551,1414,4370,4007,0700,0000,0000,1000	; 7494	=1110	[PI]_[PI].OR.#, #/001000, HOLD LEFT, J/PIP6
U 0777, 3670,3551,1414,4370,4007,0700,0000,0000,0400	; 7495	=1111	[PI]_[PI].OR.#, #/000400, HOLD LEFT, J/PIP7
U 3662, 3671,4751,1206,4374,4007,0700,0000,0000,0001	; 7496	PIP1:	[BRX]_0 XWD [1], J/PI10	;REMEMBER WE ARE AT LEVEL 1
U 3663, 3671,4751,1206,4374,4007,0700,0000,0000,0002	; 7497	PIP2:	[BRX]_0 XWD [2], J/PI10	;REMEMBER WE ARE AT LEVEL 2
U 3664, 3671,4751,1206,4374,4007,0700,0000,0000,0003	; 7498	PIP3:	[BRX]_0 XWD [3], J/PI10	;REMEMBER WE ARE AT LEVEL 3
U 3665, 3671,4751,1206,4374,4007,0700,0000,0000,0004	; 7499	PIP4:	[BRX]_0 XWD [4], J/PI10	;REMEMBER WE ARE AT LEVEL 4
U 3666, 3671,4751,1206,4374,4007,0700,0000,0000,0005	; 7500	PIP5:	[BRX]_0 XWD [5], J/PI10	;REMEMBER WE ARE AT LEVEL 5
U 3667, 3671,4751,1206,4374,4007,0700,0000,0000,0006	; 7501	PIP6:	[BRX]_0 XWD [6], J/PI10	;REMEMBER WE ARE AT LEVEL 6
U 3670, 3671,4751,1206,4374,4007,0700,0000,0000,0007	; 7502	PIP7:	[BRX]_0 XWD [7], J/PI10	;REMEMBER WE ARE AT LEVEL 7
							; 7503	
							; 7504	PI10:	[AR]_[PI].AND.# CLR LH,	;TURN OFF PI SYSTEM
U 3671, 3672,4251,1403,4374,4007,0700,0000,0007,7577	; 7505		#/077577		; TILL WE ARE DONE
U 3672, 3673,7443,0300,4174,4437,0700,0000,0000,0000	; 7506		.NOT.[AR], LOAD PI	;  ..
U 3673, 2436,4223,0000,4364,4277,0700,0200,0000,0010	; 7507		ABORT MEM CYCLE		;NO MORE TRAPS
							; 7508	=0	[AR]_VMA IO READ,	;SETUP TO READ WRU BITS
							; 7509		WRU CYCLE/1,		; ..
U 2436, 3726,4571,1203,4374,4007,0700,0010,0024,1300	; 7510		CALL [STRTIO]		;START THE CYCLE
							; 7511		MEM READ,		;WAIT FOR DATA
							; 7512		[AR]_IO DATA, 3T,	;PUT DATA IN AR
U 2437, 2440,3771,0003,4364,4007,0331,0200,0000,0002	; 7513		SKIP ADR.EQ.0		;SEE IF ANYONE THERE
U 2440, 3702,4221,0004,4174,4007,0700,0000,0000,0000	; 7514	=0	[ARX]_0, J/VECINT	;YES--VECTORED INTERRUPT
U 2441, 3674,3445,0603,4174,4007,0700,0000,0000,0000	; 7515		[AR]_[BRX]*2		;N*2
							; 7516		[AR]_[AR]+#, #/40, 3T,	;2*N+40
U 3674, 3675,0551,0303,4370,4007,0701,0000,0000,0040	; 7517		HOLD LEFT		; ..
							; 7518		[AR]_[AR]+[EBR],	;ABSOULTE ADDRESS OF 
U 3675, 3676,0111,1003,4174,4007,0700,0000,0000,0000	; 7519		J/PI40			; INTERRUPT INSTRUCTION
							; 7520	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 207
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7521	;HERE WITH ABSOLUTE ADDRESS OF INTERRUPT INSTRUCTION IN [AR]
U 3676, 3677,3443,0300,4174,4007,0700,0200,0024,1016	; 7522	PI40:	VMA_[AR], VMA PHYSICAL READ	;FETCH THE INSTRUCTION
							; 7523	PI50:	MEM READ, [AR]_MEM, LOAD VMA,	;FETCH INSTRUCTION
U 3677, 3700,3771,0003,4365,5007,0701,0200,0020,0012	; 7524		3T, FORCE EXEC			;E IS EXEC MODE
U 3700, 2442,6553,0300,4374,4007,0321,0000,0025,4340	; 7525		[AR].XOR.#, #/254340, 3T, SKIP ADL.EQ.0
U 2442, 2444,6553,0300,4374,4007,0321,0000,0026,4000	; 7526	=0	[AR].XOR.#, #/264000, SKIP ADL.EQ.0, 3T, J/PIJSR
U 2443, 3701,4521,1205,4074,4007,0700,0000,0000,0000	; 7527		[BR]_FLAGS			;SAVE FLAGS
							; 7528		AD/ZERO, LOAD FLAGS,
U 3701, 0060,4223,0000,4174,4467,0700,0000,0000,0004	; 7529		J/PIXPCW			;ENTER EXEC MODE AND ASSUME
							; 7530						; WE HAVE AN XPCW
							; 7531	;IF WE HALT HERE ON A VECTORED INTERRUPT, WE HAVE
							; 7532	;	T0/ WHAT WE READ FROM BUS AS VECTOR
							; 7533	;	ARX/ EPT+100+DEVICE
							; 7534	;	BR/  ADDRESS OF ILLEGAL INSTRUCTION
							; 7535	;	BRX/ VECTOR (MASKED AND SHIFTED)
							; 7536	=0
U 2444, 0104,4751,1217,4374,4007,0700,0000,0000,0101	; 7537	PIJSR:	HALT [ILLII]			;NOT A JSR OR XPCW
U 2445, 0470,4443,0000,4174,4007,0700,0200,0023,0002	; 7538		START WRITE, FORCE EXEC		;PREPARE TO STORE OLD PC
							; 7539	=0*0	[BR]_PC WITH FLAGS,		;OLD PC
U 0470, 3727,3741,0105,4074,4007,0700,0010,0000,0000	; 7540		CALL [STOBR]			;STORE OLD PC
							; 7541	=1*0	[AR]_#, #/0, HOLD RIGHT,		;PREPARE TO CLEAR FLAGS
U 0474, 3724,3771,0003,4374,0007,0700,0010,0000,0000	; 7542		CALL [INCAR]			;BUMP POINTER
							; 7543	=1*1	[PC]_[AR], LOAD FLAGS,		;NEW PC
U 0475, 2721,3441,0301,4174,4467,0700,0000,0000,0004	; 7544		J/PISET				;CLEAR PI CYCLE & START
							; 7545						; INTERRUPT PROGRAM
							; 7546	=
							; 7547	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 208
; INOUT.MIC[1,2]	13:32 7-JAN-1986			IO -- INTERNAL DEVICES -- SUBROUTINES			

							; 7548	;HERE TO PROCESS A VECTORED INTERRUPT. AT THIS POINT:
							; 7549	;	AR/ WRU BITS (BIT 18 FOR DEVICE 0)
							; 7550	;	ARX/ 0
							; 7551	VECINT:	[AR]_[AR]*2,		;SHIFT LEFT (UNSHIFTED ON DP)
U 3702, 2446,3445,0303,4174,4007,0530,0000,0000,0000	; 7552		SKIP DP18		;ANYONE THERE?
							; 7553	=0	[ARX]_[ARX]+[XWD1],	;NO--BUMP BOTH HALVES
U 2446, 3702,0111,1504,4174,4007,0700,0000,0000,0000	; 7554		J/VECINT		;KEEP LOOKING
							; 7555		[AR]_VMA IO READ,	;SETUP FOR VECTOR CYCLE
U 2447, 2450,4571,1203,4374,4007,0700,0000,0024,1240	; 7556		VECTOR CYCLE/1		; ..
							; 7557	=0	[AR]_[AR].OR.[ARX],	;PUT IN UNIT NUMBER
U 2450, 3726,3111,0403,4174,4007,0700,0010,0000,0000	; 7558		CALL [STRTIO]		;START CYCLE
							; 7559		MEM READ,		;WAIT FOR VECTOR (SEE DPM5)
U 2451, 2452,3771,0016,4364,4007,0700,0200,0000,0002	; 7560		[T0]_IO DATA		;GET VECTOR
							; 7561	=0	[BR]_[EBR]+#, 3T, #/100,	;EPT+100
U 2452, 3723,0551,1005,4374,4007,0701,0010,0000,0100	; 7562		CALL [CLARXL]		;CLEAR ARX LEFT
							; 7563		[ARX]_[ARX]+[BR],	;EPT+100+DEVICE
U 2453, 3703,0111,0504,4174,4007,0700,0200,0024,1016	; 7564		VMA PHYSICAL READ	;FETCH WORD
							; 7565		MEM READ, [BR]_MEM, 3T,	;GET POINTER
U 3703, 2454,3771,0005,4365,5007,0331,0200,0000,0002	; 7566		SKIP ADR.EQ.0		;SEE IF NON-ZERO
							; 7567	=0	[BRX]_([T0].AND.#)*.5, 3T, ;OK--MAKE VECTOR MOD 400
U 2454, 3704,4557,1606,4374,4007,0701,0000,0000,0774	; 7568		#/774, J/VECIN1		; AND SHIFT OVER
U 2455, 0104,4751,1217,4374,4007,0700,0000,0000,0102	; 7569		HALT [ILLINT]
U 3704, 3705,3447,0606,4174,4007,0700,0000,0000,0000	; 7570	VECIN1:	[BRX]_[BRX]*.5		;SHIFT 1 MORE PLACE
							; 7571		[BR]_[BR]+[BRX],	;ADDRESS OF WORD TO USE
							; 7572		LOAD VMA, FORCE EXEC,	;FORCE EXEC VIRTUAL ADDRESS
U 3705, 3677,0111,0605,4174,4007,0700,0200,0024,0012	; 7573		START READ, J/PI50	;GO GET INSTRUCTION
							; 7574	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 209
; INOUT.MIC[1,2]	13:32 7-JAN-1986			PRIORITY INTERRUPTS -- DISMISS SUBROUTINE		

							; 7575	.TOC	"PRIORITY INTERRUPTS -- DISMISS SUBROUTINE"
							; 7576	
							; 7577	;SUBROUTINE TO DISMISS THE HIGHEST PI IN PROGRESS
							; 7578	;RETURNS 4 ALWAYS
							; 7579	
							; 7580	;DISMISS:
							; 7581	;	TR [PI], #/077400	;ANY PI IN PROGRESS?
							; 7582	=0
U 2456, 3706,3771,0005,4374,4007,0700,0000,0004,0000	; 7583	JEN1:	[BR]_#, PI.IP1/1, J/DSMS1 ;YES--START LOOP
U 2457, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 7584		RETURN [4]		;NO--JUST RETURN
							; 7585	
U 3706, 2460,4113,0514,4174,4007,0330,0000,0000,0000	; 7586	DSMS1:	[PI].AND.[BR], SKIP ADR.EQ.0
U 2460, 0004,5111,0514,4170,4004,1700,0000,0000,0000	; 7587	=0	[PI]_[PI].AND.NOT.[BR], HOLD LEFT, RETURN [4]
U 2461, 3706,3447,0505,4174,4007,0700,0000,0000,0000	; 7588		[BR]_[BR]*.5, J/DSMS1
							; 7589	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 210
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7590	.TOC	"EXTERNAL IO INSTRUCTIONS"
							; 7591	
							; 7592		.DCODE
D 0710, 1210,1614,0100					; 7593	710:	IOT,	WORD-TNE,	J/TIOX
D 0711, 1214,1614,0100					; 7594	711:	IOT,	WORD-TNN,	J/TIOX
D 0720, 1200,1614,0100					; 7595	720:	IOT,	TNE,		J/TIOX
D 0721, 1204,1614,0100					; 7596	721:	IOT,	TNN,		J/TIOX
							; 7597		.UCODE
							; 7598	
							; 7599	1614:
U 1614, 2462,4443,0000,4174,4007,0700,0010,0000,0000	; 7600	TIOX:	CALL [IORD]
U 1617, 0014,4551,0305,0274,4003,7700,0000,0000,0000	; 7601	1617:	[BR]_[AR].AND.AC, TEST DISP
							; 7602	
							; 7603		.DCODE
D 0712, 1210,1460,0100					; 7604	712:	IOT,	B/10,		J/RDIO
D 0713, 1210,1461,0100					; 7605	713:	IOT,	B/10,		J/WRIO
D 0722, 1200,1460,0100					; 7606	722:	IOT,	B/0,		J/RDIO
D 0723, 1200,1461,0100					; 7607	723:	IOT,	B/0,		J/WRIO
							; 7608		.UCODE
							; 7609	
							; 7610	1460:
U 1460, 2462,4443,0000,4174,4007,0700,0010,0000,0000	; 7611	RDIO:	CALL [IORD]
U 1463, 1400,3440,0303,0174,4007,0700,0400,0000,0000	; 7612	1463:	AC_[AR], J/DONE
							; 7613	
							; 7614	1461:
U 1461, 2472,3771,0005,0276,6007,0700,0000,0000,0000	; 7615	WRIO:	[BR]_AC, J/IOWR
							; 7616	
							; 7617		.DCODE
D 0714, 1210,1644,0100					; 7618	714:	IOT,		B/10,	J/BIXUB
D 0715, 1214,1644,0100					; 7619	715:	IOT,		B/14,	J/BIXUB
D 0724, 1200,1644,0100					; 7620	724:	IOT,		B/0,	J/BIXUB
D 0725, 1204,1644,0100					; 7621	725:	IOT,		B/4,	J/BIXUB
							; 7622		.UCODE
							; 7623	
							; 7624	1644:
							; 7625	BIXUB:	[BRX]_[AR],		;SAVE EFFECTIVE ADDRESS
U 1644, 2462,3441,0306,4174,4007,0700,0010,0000,0000	; 7626		CALL [IORD]		;GO GET THE DATA
							; 7627	1647:	[BR]_[AR],		;COPY DATA ITEM
U 1647, 1013,3441,0305,4174,4003,7700,0000,0000,0000	; 7628		B DISP			;SEE IF SET OR CLEAR
							; 7629	=1011	[BR]_[BR].OR.AC,	;SET BITS
U 1013, 3707,3551,0505,0274,4007,0700,0000,0000,0000	; 7630		J/BIXUB1		;GO DO WRITE
							; 7631		[BR]_[BR].AND.NOT.AC,	;CLEAR BITS
U 1017, 3707,5551,0505,0274,4007,0700,0000,0000,0000	; 7632		J/BIXUB1		;GO DO WRITE
							; 7633	
							; 7634	BIXUB1:	[AR]_[BRX],		;RESTORE ADDRESS
U 3707, 2472,3441,0603,4174,4007,0700,0000,0000,0000	; 7635		J/IOWR
							; 7636	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 211
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7637	;SUBROUTINE TO READ FROM AN IO DEVICE
							; 7638	;CALL WITH:
							; 7639	;	SECTION 0 EFFECTIVE ADDRESS IN AR
							; 7640	;	INSTRUCTION IN HR
							; 7641	;RETURN 3 WITH WORD OR BYTE IN AR
							; 7642	;
							; 7643	=0
							; 7644	IORD:	CLR IO BUSY,		;CLEAR BUSY
U 2462, 2502,4443,0000,4174,4137,0700,0010,0000,0000	; 7645		CALL [IOEA]		;COMPUTE IO EA
U 2463, 0067,4443,0000,4174,4003,7700,0000,0000,0000	; 7646		B DISP
							; 7647	=10111	[BR]_VMA IO READ,	;BYTE MODE
							; 7648		IO BYTE/1,		;SET BYTE FLAG
U 0067, 2464,4571,1205,4374,4007,0700,0000,0024,1220	; 7649		J/IORD1			;GO DO C/A CYCLE
U 0077, 2464,4571,1205,4374,4007,0700,0000,0024,1200	; 7650	=11111	[BR]_VMA IO READ	;WORD MODE
							; 7651	=
							; 7652	=0
							; 7653	IORD1:	VMA_[AR].OR.[BR] WITH FLAGS,
U 2464, 3716,3113,0305,4174,4007,0701,0210,0000,0036	; 7654		CALL [IOWAIT]		;WAIT FOR THINGS COMPLETE
							; 7655		MEM READ,		;MAKE SURE REALLY READY
							; 7656		[BR]_IO DATA,		;PUT DATA IN BR
U 2465, 1027,3771,0005,4364,4003,7700,0200,0000,0002	; 7657		B DISP			;SEE IF BYTE MODE
U 1027, 2466,4553,0300,4374,4007,0331,0000,0000,0001	; 7658	=0111	TR [AR], #/1, J/IORD2	;BYTE MODE SEE IF ODD
U 1037, 0003,3441,0503,4174,4004,1700,0000,0000,0000	; 7659		[AR]_[BR], RETURN [3]	;ALL DONE
							; 7660	
							; 7661	;HERE ON WORD MODE
							; 7662	=0
							; 7663	IORD2:	[BR]_[BR]*.5, SC_5,	;LEFT BYTE
U 2466, 2470,3447,0505,4174,4007,0700,2000,0071,0005	; 7664		J/IORD3			;GO SHIFT IT
							; 7665		[AR]_[BR].AND.#,	;MASK IT
U 2467, 0003,4551,0503,4374,4004,1700,0000,0000,0377	; 7666		#/377, RETURN [3]	;ALL DONE
							; 7667	
							; 7668	=0
							; 7669	IORD3:	[BR]_[BR]*.5,		;SHIFT OVER 
U 2470, 2470,3447,0505,4174,4007,0630,2000,0060,0000	; 7670		STEP SC, J/IORD3	; ..
							; 7671		[AR]_[BR].AND.#,	;MASK IT
U 2471, 0003,4551,0503,4374,4004,1700,0000,0000,0377	; 7672		#/377, RETURN [3]	;ALL DONE
							; 7673	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 212
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7674	;ROUTINE TO WRITE TO AN IO DEVICE
							; 7675	;CALL WITH:
							; 7676	;	SECTION 0 EFFECTIVE ADDRESS IN AR
							; 7677	;	INSTRUCTION IN HR
							; 7678	;	WORD OR BYTE IN BR
							; 7679	;RETURNS BACK TO USER
							; 7680	;
							; 7681	=0
							; 7682	IOWR:	CLR IO BUSY,		;CLEAR BUSY
U 2472, 2502,4443,0000,4174,4137,0700,0010,0000,0000	; 7683		CALL [IOEA]		;COMPUTE IO EA
U 2473, 0227,4443,0000,4174,4003,7700,0000,0000,0000	; 7684		B DISP
U 0227, 2476,4553,0300,4374,4007,0331,0000,0000,0001	; 7685	=10111	TR [AR], #/1, J/IOWR2	;BYTE MODE
U 0237, 3710,4571,1204,4374,4007,0700,0000,0021,1200	; 7686	=11111	[ARX]_VMA IO WRITE	;SETUP FLAGS
							; 7687	=
U 3710, 2474,3113,0304,4174,4007,0701,0200,0000,0036	; 7688	IOWR1:	VMA_[AR].OR.[ARX] WITH FLAGS
							; 7689	=0	MEM WRITE, MEM_[BR],	;SEND DATA
U 2474, 3716,3333,0005,4175,5007,0701,0210,0000,0002	; 7690		CALL [IOWAIT]		;WAIT FOR DATA
U 2475, 0110,3443,0100,4174,4156,4700,0200,0014,0012	; 7691		DONE			;RETURN
							; 7692	
							; 7693	;HERE FOR BYTE MODE
							; 7694	=0
							; 7695	IOWR2:	[BR]_[BR]*2, SC_5,	;ODD--MOVE LEFT
U 2476, 2500,3445,0505,4174,4007,0700,2000,0071,0005	; 7696		J/IOWR3			; ..
							; 7697		[ARX]_VMA IO WRITE,	;SETUP FLAGS
U 2477, 3710,4571,1204,4374,4007,0700,0000,0021,1220	; 7698		IO BYTE/1, J/IOWR1	; ..
							; 7699	
							; 7700	=0
							; 7701	IOWR3:	[BR]_[BR]*2, STEP SC,	;SHIFT LEFT
U 2500, 2500,3445,0505,4174,4007,0630,2000,0060,0000	; 7702		J/IOWR3			;KEEP SHIFTING
							; 7703		[ARX]_VMA IO WRITE,	;SETUP FLAGS
U 2501, 3710,4571,1204,4374,4007,0700,0000,0021,1220	; 7704		IO BYTE/1, J/IOWR1	; ..
							; 7705	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 213
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7706	;HERE TO COMPUTE IO EFFECTIVE ADDRESS
							; 7707	;CALL WITH:
							; 7708	;	SECTION 0 EFFECTIVE ADDRESS IN AR
							; 7709	;	INSTRUCTION IN HR
							; 7710	;RETURN 1 WITH EA IN AR
							; 7711	;
							; 7712	=0
							; 7713	IOEA:	VMA_[PC]-1,		;GET INSTRUCTION
							; 7714		START READ,		; ..
U 2502, 3720,1113,0701,4170,4007,0700,4210,0004,0012	; 7715		CALL [LOADAR]		;PUT WORD IN AR
U 2503, 3711,7441,0306,4174,4007,0700,0000,0000,0000	; 7716		[BRX]_.NOT.[AR]		;SEE IF IN RANGE 700-777
U 3711, 2504,4553,0600,4374,4007,0321,0000,0070,0000	; 7717		TL [BRX], #/700000	; ..
							; 7718	=0
U 2504, 2506,4553,0200,4374,4007,0321,0000,0000,0020	; 7719	IOEA1:	TL [HR], #/20, J/IOEA2	;INDIRECT?
							; 7720		WORK[YSAVE]_[AR] CLR LH, ;DIRECT IO INSTRUCTION
U 2505, 2504,4713,1203,7174,4007,0700,0400,0000,0422	; 7721		J/IOEA1			;SAVE Y FOR EA CALCULATION
							; 7722	=0
							; 7723	IOEA2:	[AR]_WORK[YSAVE],	;@--GET SAVED Y
U 2506, 3712,3771,0003,7274,4007,0701,0000,0000,0422	; 7724		J/IOEAI			;GET Y AND GO
U 2507, 1055,4443,0000,2174,4006,6700,0000,0000,0000	; 7725		EA MODE DISP		;WAS THERE INDEXING?
							; 7726	=1101	[ARX]_XR, SKIP ADL.LE.0, ;SEE IF LOCAL OR GLOBAL INDEXING
U 1055, 2512,3771,0004,2274,4007,0120,0000,0000,0000	; 7727		2T, J/IOEAX		; ..
							; 7728		[AR]_WORK[YSAVE],	;JUST PLAIN IO
U 1057, 0001,3771,0003,7274,4124,1701,0000,0000,0422	; 7729		CLR IO LATCH, RETURN [1]
							; 7730	
							; 7731	IOEAI:	READ [HR], DBUS/DP,	;LOAD XR FLOPS IN CASE
U 3712, 3713,3333,0002,4174,4217,0700,0000,0000,0000	; 7732		LOAD INST EA		; THERE IS INDEXING
U 3713, 2510,4553,0200,4374,4007,0321,0000,0000,0017	; 7733		TL [HR], #/17		;WAS THERE ALSO INDEXING
U 2510, 2511,0551,0303,2270,4007,0701,0000,0000,0000	; 7734	=0	[AR]_[AR]+XR, 3T, HOLD LEFT ;YES--ADD IN INDEX VALUE
U 2511, 3714,3443,0300,4174,4007,0700,0200,0004,0012	; 7735		VMA_[AR], START READ	;FETCH DATA WORD
							; 7736		MEM READ, [AR]_MEM,	;GO GET DATA WORD
U 3714, 0001,3771,0003,4365,5124,1700,0200,0000,0002	; 7737		CLR IO LATCH, RETURN [1]
							; 7738	
							; 7739	=0
							; 7740	IOEAX:	[AR]_[ARX]+WORK[YSAVE],	;GLOBAL INDEXING
U 2512, 0001,0551,0403,7274,4124,1701,0000,0000,0422	; 7741		CLR IO LATCH, RETURN [1]
U 2513, 3715,0551,0403,7274,4007,0701,0000,0000,0422	; 7742		[AR]_[ARX]+WORK[YSAVE]	;LOCAL INDEXING
							; 7743		[AR]_0, HOLD RIGHT,
U 3715, 0001,4221,0003,4174,0124,1700,0000,0000,0000	; 7744		CLR IO LATCH, RETURN [1]
							; 7745	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 214
; INOUT.MIC[1,2]	13:32 7-JAN-1986			EXTERNAL IO INSTRUCTIONS				

							; 7746	;WAIT FOR IO TO COMPLETE
							; 7747	;RETURNS 1 OR PAGE FAILS
							; 7748	;
							; 7749	IOWAIT:	SC_S#, S#/200,		;DELAY
							; 7750		[T0]_VMA,		;GET VMA
U 3716, 1134,3771,0016,4354,4007,0650,2000,0071,0200	; 7751		SKIP/-IO BUSY		;SEE IF BUSY YET
							; 7752	=00
							; 7753	IOW1:	CLR IO LATCH,		;WENT BUSY
							; 7754		WORK[SV.VMA]_[T0],	;MAKE SURE SV.VMA IS SETUP
U 1134, 3717,3333,0016,7174,4127,0700,0400,0000,0210	; 7755		J/IOW2			;WAIT FOR IT TO CLEAR
							; 7756		SC_SC-1, SCAD DISP, 5T,	;SEE IF DONE YET
							; 7757		SKIP/-IO BUSY,		; ..
U 1135, 1134,4443,0000,4174,4006,7653,2000,0060,0000	; 7758		J/IOW1			;BACK TO LOOP
							; 7759		CLR IO LATCH,		;WENT BUSY AND TIMEOUT
							; 7760		WORK[SV.VMA]_[T0],	;MAKE SURE SV.VMA IS SETUP
U 1136, 3717,3333,0016,7174,4127,0700,0400,0000,0210	; 7761		J/IOW2			; ..
							; 7762		WORK[SV.VMA]_[T0],	;MAKE SURE SV.VMA IS SETUP
U 1137, 2517,3333,0016,7174,4007,0700,0400,0000,0210	; 7763		J/IOW5			;GO TRAP
							; 7764	
							; 7765	IOW2:	SC_S#, S#/777,		;GO TIME IO
U 3717, 2514,4443,0000,4174,4007,0650,2000,0071,0777	; 7766		SKIP/-IO BUSY		; ..
							; 7767	=0
							; 7768	IOW3:	CLR IO LATCH,		;TRY TO CLEAR LATCH
U 2514, 2516,4443,0000,4174,4127,0630,2000,0060,0000	; 7769		STEP SC, J/IOW4		;STILL BUSY
U 2515, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 7770		RETURN [1]		;IDLE
							; 7771	
							; 7772	=0
							; 7773	IOW4:	CLR IO LATCH, 5T,	;TRY TO CLEAR LATCH
							; 7774		SKIP/-IO BUSY,		;SEE IF STILL BUSY
U 2516, 2514,4443,0000,4174,4127,0653,0000,0000,0000	; 7775		J/IOW3			; ..
U 2517, 4043,4571,1206,4374,4007,0700,0000,0020,0000	; 7776	IOW5:	[BRX]_[200000] XWD 0, J/HARD
							; 7777	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 215
; INOUT.MIC[1,2]	13:32 7-JAN-1986			SMALL SUBROUTINES					

							; 7778	.TOC	"SMALL SUBROUTINES"
							; 7779	
							; 7780	;HERE ARE A COLLECTION ON 1-LINE SUBROUTINES
							; 7781	LOADAR:	MEM READ, [AR]_MEM,	;FROM MEMORY TO AR
U 3720, 0001,3771,0003,4365,5004,1700,0200,0000,0002	; 7782		RETURN [1]		;RETURN TO CALLER
							; 7783	
U 3721, 0001,3771,0004,4365,5004,1700,0200,0000,0002	; 7784	LOADARX: MEM READ, [ARX]_MEM, RETURN [1]
							; 7785	
U 3722, 0001,3772,0000,4365,5004,1700,0200,0000,0002	; 7786	LOADQ:	MEM READ, Q_MEM, RETURN [1]
							; 7787	
U 3723, 0001,4221,0004,4174,0004,1700,0000,0000,0000	; 7788	CLARXL:	[ARX]_0, HOLD RIGHT, RETURN [1]
							; 7789	
U 3724, 0001,0111,0703,4174,4004,1700,0000,0000,0000	; 7790	INCAR:	[AR]_[AR]+1, RETURN [1]
							; 7791	
U 3725, 0001,3445,0505,4174,4004,1700,0000,0000,0000	; 7792	SBRL:	[BR]_[BR]*2, RETURN [1]
							; 7793	
U 3726, 0001,3443,0300,4174,4004,1701,0200,0000,0036	; 7794	STRTIO:	VMA_[AR] WITH FLAGS, RETURN [1]
							; 7795	
U 3727, 0004,3333,0005,4175,5004,1701,0200,0000,0002	; 7796	STOBR:	MEM WRITE, MEM_[BR], RETURN [4]
							; 7797	
U 3730, 0001,3333,0001,4175,5004,1701,0200,0000,0002	; 7798	STOPC:	MEM WRITE, MEM_[PC], RETURN [1]
							; 7799	
U 3731, 0001,3440,0404,0174,4004,1700,0400,0000,0000	; 7800	AC_ARX:	AC_[ARX], RETURN [1]
							; 7801	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 216
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UNDEFINED IO INSTRUCTIONS				

							; 7802	.TOC	"UNDEFINED IO INSTRUCTIONS"
							; 7803	
							; 7804		.DCODE
D 0703, 0003,1650,2100					; 7805	703:	I,	B/3,	J/IOT700
D 0706, 0006,1650,2100					; 7806	706:	I,	B/6,	J/IOT700
D 0707, 0007,1650,2100					; 7807		I,	B/7,	J/IOT700
							; 7808	
D 0716, 0006,1651,2100					; 7809	716:	I,	B/6,	J/IOT710
D 0717, 0007,1651,2100					; 7810		I,	B/7,	J/IOT710
							; 7811	
D 0726, 0006,1652,2100					; 7812	726:	I,	B/6,	J/IOT720
D 0727, 0007,1652,2100					; 7813		I,	B/7,	J/IOT720
							; 7814	
D 0730, 0000,1653,2100					; 7815	730:	I,	B/0,	J/IOT730
D 0731, 0001,1653,2100					; 7816		I,	B/1,	J/IOT730
D 0732, 0002,1653,2100					; 7817		I,	B/2,	J/IOT730
D 0733, 0003,1653,2100					; 7818		I,	B/3,	J/IOT730
D 0734, 0004,1653,2100					; 7819		I,	B/4,	J/IOT730
D 0735, 0005,1653,2100					; 7820		I,	B/5,	J/IOT730
D 0736, 0006,1653,2100					; 7821		I,	B/6,	J/IOT730
D 0737, 0007,1653,2100					; 7822		I,	B/7,	J/IOT730
							; 7823	
D 0740, 0000,1654,2100					; 7824	740:	I,	B/0,	J/IOT740
D 0741, 0001,1654,2100					; 7825		I,	B/1,	J/IOT740
D 0742, 0002,1654,2100					; 7826		I,	B/2,	J/IOT740
D 0743, 0003,1654,2100					; 7827		I,	B/3,	J/IOT740
D 0744, 0004,1654,2100					; 7828		I,	B/4,	J/IOT740
D 0745, 0005,1654,2100					; 7829		I,	B/5,	J/IOT740
D 0746, 0006,1654,2100					; 7830		I,	B/6,	J/IOT740
D 0747, 0007,1654,2100					; 7831		I,	B/7,	J/IOT740
							; 7832	
D 0750, 0000,1655,2100					; 7833	750:	I,	B/0,	J/IOT750
D 0751, 0001,1655,2100					; 7834		I,	B/1,	J/IOT750
D 0752, 0002,1655,2100					; 7835		I,	B/2,	J/IOT750
D 0753, 0003,1655,2100					; 7836		I,	B/3,	J/IOT750
D 0754, 0004,1655,2100					; 7837		I,	B/4,	J/IOT750
D 0755, 0005,1655,2100					; 7838		I,	B/5,	J/IOT750
D 0756, 0006,1655,2100					; 7839		I,	B/6,	J/IOT750
D 0757, 0007,1655,2100					; 7840		I,	B/7,	J/IOT750
							; 7841	
D 0760, 0000,1656,2100					; 7842	760:	I,	B/0,	J/IOT760
D 0761, 0001,1656,2100					; 7843		I,	B/1,	J/IOT760
D 0762, 0002,1656,2100					; 7844		I,	B/2,	J/IOT760
D 0763, 0003,1656,2100					; 7845		I,	B/3,	J/IOT760
D 0764, 0004,1656,2100					; 7846		I,	B/4,	J/IOT760
D 0765, 0005,1656,2100					; 7847		I,	B/5,	J/IOT760
D 0766, 0006,1656,2100					; 7848		I,	B/6,	J/IOT760
D 0767, 0007,1656,2100					; 7849		I,	B/7,	J/IOT760
							; 7850	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 217
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UNDEFINED IO INSTRUCTIONS				

D 0770, 0000,1657,2100					; 7851	770:	I,	B/0,	J/IOT770
D 0771, 0001,1657,2100					; 7852		I,	B/1,	J/IOT770
D 0772, 0002,1657,2100					; 7853		I,	B/2,	J/IOT770
D 0773, 0003,1657,2100					; 7854		I,	B/3,	J/IOT770
D 0774, 0004,1657,2100					; 7855		I,	B/4,	J/IOT770
D 0775, 0005,1657,2100					; 7856		I,	B/5,	J/IOT770
D 0776, 0006,1657,2100					; 7857		I,	B/6,	J/IOT770
D 0777, 0007,1657,2100					; 7858		I,	B/7,	J/IOT770
							; 7859		.UCODE
							; 7860	
							; 7861	1650:
U 1650, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7862	IOT700:	UUO
							; 7863	1651:
							; 7864	IOT710:
							;;7865	.IFNOT/UBABLT
							;;7866		UUO
							; 7867	.IF/UBABLT
U 1651, 0674,4443,0000,4174,4007,0700,0000,0000,0000	; 7868		J/BLTX		;GO TO COMMON CODE FOR UBABLT INSTRS
							; 7869	.ENDIF/UBABLT
							; 7870	1652:
U 1652, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7871	IOT720:	UUO
							; 7872	1653:
U 1653, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7873	IOT730:	UUO
							; 7874	1654:
U 1654, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7875	IOT740:	UUO
							; 7876	1655:
U 1655, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7877	IOT750:	UUO
							; 7878	1656:
U 1656, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7879	IOT760:	UUO
							; 7880	1657:
U 1657, 2756,4551,0202,4374,0007,0700,0000,0077,7740	; 7881	IOT770:	UUO
							; 7882	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 218
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UMOVE AND UMOVEM					

							; 7883	.TOC	"UMOVE AND UMOVEM"
							; 7884	
							; 7885		.DCODE
D 0704, 1200,1754,0100					; 7886	704:	IOT,	J/UMOVE
D 0705, 1200,1755,0100					; 7887		IOT,	J/UMOVEM
							; 7888		.UCODE
							; 7889	
							; 7890	1754:
							; 7891	UMOVE:	VMA_[AR],		;LOAD VMA
							; 7892		START READ,		;START MEMORY
U 1754, 3732,3443,0300,4174,4207,0700,0200,0004,0012	; 7893		SPEC/PREV		;FORCE PREVIOUS
							; 7894		MEM READ,		;WAIT FOR MEMORY
							; 7895		[AR]_MEM,		;PUT DATA IN AR
U 3732, 1515,3771,0003,4365,5007,0700,0200,0000,0002	; 7896		J/STAC			;GO PUT AR IN AC
							; 7897	
							; 7898	1755:
							; 7899	UMOVEM:	VMA_[AR],		;LOAD VMA
							; 7900		START WRITE,		;START MEMORY
U 1755, 3733,3443,0300,4174,4207,0700,0200,0003,0012	; 7901		SPEC/PREV		;FORCE PREVIOUS
							; 7902		[AR]_AC,		;FETCH AC
U 3733, 1516,3771,0003,0276,6007,0700,0000,0000,0000	; 7903		J/STMEM			;STORE IN MEMORY
							; 7904	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 219
; INOUT.MIC[1,2]	13:32 7-JAN-1986			UMOVE AND UMOVEM					

							; 7905	;HERE WITH HALT CODE IN THE T1
							; 7906	=010*
							; 7907	HALTED:	WORK[SV.ARX]_[ARX],	;SAVE TEMP REGISTER
U 0104, 3736,3333,0004,7174,4007,0700,0410,0000,0212	; 7908		CALL [SAVVMA]		;PUT VMA IN WORK[SV.VMA]
							; 7909	=110*	ABORT MEM CYCLE,		;ABORT CYCLE IN PROGRESS
U 0114, 3735,4223,0000,4364,4277,0700,0210,0000,0010	; 7910		CALL [WRTHSB]		;WRITE HALT STATUS BLOCK
							; 7911	=111*
U 0116, 3734,4221,0004,4174,4007,0700,0200,0021,1016	; 7912	PWRON:	[ARX]_0, VMA PHYSICAL WRITE ;STORE HALT CODE
							; 7913	=
U 3734, 2520,3333,0017,4175,5007,0701,0200,0000,0002	; 7914		MEM WRITE, MEM_[T1]	; IN LOCATION 0
							; 7915	=0	NEXT [ARX] PHYSICAL WRITE,
U 2520, 3730,0111,0704,4170,4007,0700,0210,0023,1016	; 7916		CALL [STOPC]
U 2521, 0005,4443,0000,4174,4107,0700,0000,0000,0074	; 7917	H1:	SET HALT, J/HALTLP	;TELL CONSOLE WE HAVE HALTED
							; 7918	
							; 7919	
							; 7920	4:	UNHALT,			;RESET CONSOLE
U 0004, 2522,4443,0000,4174,4107,0640,0000,0000,0062	; 7921		SKIP EXECUTE, J/CONT	;SEE IF CO OR EX
							; 7922	5:
U 0005, 0004,4443,0000,4174,4007,0660,0000,0000,0000	; 7923	HALTLP:	SKIP/-CONTINUE, J/4	;WAIT FOR CONTINUE
							; 7924	
							; 7925	=0
							; 7926	CONT:	VMA_[PC],		;LOAD PC INTO VMA
							; 7927		FETCH,			;START READ
U 2522, 0117,3443,0100,4174,4007,0700,0200,0014,0012	; 7928		J/XCTGO			;DO THE INSTRUCTION
U 2523, 2524,4571,1203,4374,4007,0700,0000,0024,1200	; 7929		[AR]_VMA IO READ	;PUT FLAGS IN AR
							; 7930	=0	[AR]_[AR].OR.#,		;PUT IN ADDRESS
							; 7931		#/200000, HOLD LEFT,	; OF CSL REGISTER
U 2524, 3726,3551,0303,4370,4007,0700,0010,0020,0000	; 7932		CALL [STRTIO]
							; 7933	CONT1:	MEM READ,		;WAIT FOR DATA
							; 7934		[HR]_MEM,		;PUT IN HR
							; 7935		LOAD INST,		;LOAD IR, ETC.
U 2525, 2735,3771,0002,4365,5617,0700,0200,0000,0002	; 7936		J/XCT1			;GO DO THE INSTRUCTION
							; 7937	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 220
; INOUT.MIC[1,2]	13:32 7-JAN-1986			WRITE HALT STATUS BLOCK					

							; 7938	.TOC	"WRITE HALT STATUS BLOCK"
							; 7939	
							; 7940	;THE HALT STATUS BLOCK LOOKS LIKE:
							; 7941	
							; 7942	;	!=======================================================!
							; 7943	;	!00!                        MAG                         !
							; 7944	;	!-------------------------------------------------------!
							; 7945	;	!01!                         PC                         !
							; 7946	;	!-------------------------------------------------------!
							; 7947	;	!02!                         HR                         !
							; 7948	;	!-------------------------------------------------------!
							; 7949	;	!03!                         AR                         !
							; 7950	;	!-------------------------------------------------------!
							; 7951	;	!04!                        ARX                         !
							; 7952	;	!-------------------------------------------------------!
							; 7953	;	!05!                         BR                         !
							; 7954	;	!-------------------------------------------------------!
							; 7955	;	!06!                        BRX                         !
							; 7956	;	!-------------------------------------------------------!
							; 7957	;	!07!                        ONE                         !
							; 7958	;	!-------------------------------------------------------!
							; 7959	;	!10!                        EBR                         !
							; 7960	;	!-------------------------------------------------------!
							; 7961	;	!11!                        UBR                         !
							; 7962	;	!-------------------------------------------------------!
							; 7963	;	!12!                        MASK                        !
							; 7964	;	!-------------------------------------------------------!
							; 7965	;	!13!                        FLG                         !
							; 7966	;	!-------------------------------------------------------!
							; 7967	;	!14!                         PI                         !
							; 7968	;	!-------------------------------------------------------!
							; 7969	;	!15!                        XWD1                        !
							; 7970	;	!-------------------------------------------------------!
							; 7971	;	!16!                         T0                         !
							; 7972	;	!-------------------------------------------------------!
							; 7973	;	!17!                         T1                         !
							; 7974	;	!=======================================================!
							; 7975	;	!         VMA FLAGS         !            VMA            !
							; 7976	;	!=======================================================!
							; 7977	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 221
; INOUT.MIC[1,2]	13:32 7-JAN-1986			WRITE HALT STATUS BLOCK					

							; 7978	;START AT 1 TO DUMP 2901 REGISTERS INTO MAIN MEMORY
							; 7979	1:	WORK[SV.ARX]_[ARX],	;SAVE TEMP REGISTER
U 0001, 3736,3333,0004,7174,4007,0700,0410,0000,0212	; 7980		CALL [SAVVMA]		;WORK[SV.VMA]_VMA
U 0011, 0024,3771,0004,7274,4007,0701,0000,0000,0227	; 7981	11:	[ARX]_WORK[HSBADR]
U 0024, 3745,4223,0000,4364,4277,0700,0210,0000,0010	; 7982	=10*	ABORT MEM CYCLE, CALL [DUMP]
U 0026, 2521,4443,0000,4174,4107,0700,0000,0000,0074	; 7983		SET HALT, J/H1
							; 7984	
							; 7985	
							; 7986	WRTHSB:	[ARX]_WORK[HSBADR], ;GET ADDRESS OF HSB
U 3735, 2526,3771,0004,7274,4007,0422,0000,0000,0227	; 7987		SKIP AD.LE.0, 4T	;SEE IF VALID
							; 7988	=0	READ [MASK], LOAD PI,	;TURN OFF PI SYSTEM
U 2526, 3745,3333,0012,4174,4437,0700,0000,0000,0000	; 7989		J/DUMP			; AND GO TAKE DUMP
							; 7990		[ARX]_WORK[SV.ARX],
U 2527, 0002,3771,0004,7274,4004,1701,0000,0000,0212	; 7991		RETURN [2]		;DO NOT DUMP ANYTHING
							; 7992	
U 3736, 3737,3771,0004,4354,4007,0700,0000,0000,0000	; 7993	SAVVMA:	[ARX]_VMA
							; 7994		WORK[SV.VMA]_[ARX],
U 3737, 0010,3333,0004,7174,4004,1700,0400,0000,0210	; 7995		RETURN [10]
							; 7996	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 222
; INOUT.MIC[1,2]	13:32 7-JAN-1986			WRITE HALT STATUS BLOCK					

							; 7997	;DUMP OUT THE 2901
U 3745, 2530,3333,0004,4174,4007,0700,0200,0021,1016	; 7998	DUMP:	READ [ARX], VMA PHYSICAL WRITE
U 2530, 2765,3333,0000,4175,5007,0701,0210,0000,0002	; 7999	=0*	MEM WRITE, MEM_[MAG], CALL [NEXT]
U 2532, 3746,3333,0001,4175,5007,0701,0200,0000,0002	; 8000		MEM WRITE, MEM_[PC]
U 3746, 2531,0111,0704,4170,4007,0700,0200,0023,1016	; 8001		NEXT [ARX] PHYSICAL WRITE
U 2531, 2765,3333,0002,4175,5007,0701,0210,0000,0002	; 8002	=0*	MEM WRITE, MEM_[HR], CALL [NEXT]
U 2533, 2534,3333,0003,4175,5007,0701,0200,0000,0002	; 8003		MEM WRITE, MEM_[AR]
U 2534, 2765,3333,0003,7174,4007,0700,0410,0000,0211	; 8004	=0*	WORK[SV.AR]_[AR], CALL [NEXT]
U 2536, 2535,3771,0003,7274,4007,0701,0000,0000,0212	; 8005		[AR]_WORK[SV.ARX]
U 2535, 2765,3333,0003,4175,5007,0701,0210,0000,0002	; 8006	=0*	MEM WRITE, MEM_[AR], CALL [NEXT]
U 2537, 3747,3333,0005,4175,5007,0701,0200,0000,0002	; 8007		MEM WRITE, MEM_[BR]
U 3747, 2540,0111,0704,4170,4007,0700,0200,0023,1016	; 8008		NEXT [ARX] PHYSICAL WRITE
U 2540, 2765,3333,0006,4175,5007,0701,0210,0000,0002	; 8009	=0*	MEM WRITE, MEM_[BRX], CALL [NEXT]
U 2542, 3750,3333,0007,4175,5007,0701,0200,0000,0002	; 8010		MEM WRITE, MEM_[ONE]
U 3750, 2541,0111,0704,4170,4007,0700,0200,0023,1016	; 8011		NEXT [ARX] PHYSICAL WRITE
U 2541, 2765,3333,0010,4175,5007,0701,0210,0000,0002	; 8012	=0*	MEM WRITE, MEM_[EBR], CALL [NEXT]
U 2543, 3752,3333,0011,4175,5007,0701,0200,0000,0002	; 8013		MEM WRITE, MEM_[UBR]
U 3752, 2544,0111,0704,4170,4007,0700,0200,0023,1016	; 8014		NEXT [ARX] PHYSICAL WRITE
U 2544, 2765,3333,0012,4175,5007,0701,0210,0000,0002	; 8015	=0*	MEM WRITE, MEM_[MASK], CALL [NEXT]
U 2546, 3753,3333,0013,4175,5007,0701,0200,0000,0002	; 8016		MEM WRITE, MEM_[FLG]
U 3753, 2545,0111,0704,4170,4007,0700,0200,0023,1016	; 8017		NEXT [ARX] PHYSICAL WRITE
U 2545, 2765,3333,0014,4175,5007,0701,0210,0000,0002	; 8018	=0*	MEM WRITE, MEM_[PI], CALL [NEXT]
U 2547, 3755,3333,0015,4175,5007,0701,0200,0000,0002	; 8019		MEM WRITE, MEM_[XWD1]
U 3755, 2550,0111,0704,4170,4007,0700,0200,0023,1016	; 8020		NEXT [ARX] PHYSICAL WRITE
U 2550, 2765,3333,0016,4175,5007,0701,0210,0000,0002	; 8021	=0*	MEM WRITE, MEM_[T0], CALL [NEXT]
U 2552, 2551,3333,0017,4175,5007,0701,0200,0000,0002	; 8022		MEM WRITE, MEM_[T1]
U 2551, 2765,3771,0003,7274,4007,0701,0010,0000,0210	; 8023	=0*	[AR]_WORK[SV.VMA], CALL [NEXT]
U 2553, 3756,3333,0003,4175,5007,0701,0200,0000,0002	; 8024		MEM WRITE, MEM_[AR]
U 3756, 3757,3771,0003,7274,4007,0701,0000,0000,0211	; 8025	HSBDON:	[AR]_WORK[SV.AR]
U 3757, 3760,3771,0004,7274,4007,0701,0000,0000,0210	; 8026		[ARX]_WORK[SV.VMA]
U 3760, 3761,3443,0400,4174,4007,0700,0200,0000,0010	; 8027		VMA_[ARX]
							; 8028		[ARX]_WORK[SV.ARX],
U 3761, 0006,3771,0004,7274,4004,1701,0000,0000,0212	; 8029		RETURN [6]
							; 8030	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 223
; PAGEF.MIC[1,2]	11:16 17-APR-2015			WRITE HALT STATUS BLOCK					

							; 8031		.NOBIN
							; 8032		.TOC	"PAGE FAIL REFIL LOGIC"
							; 8033	
							; 8034	;WHEN THE CPU CAN NOT COMPLETE A MEMORY REFERENCE BECAUSE THE PAGE
							; 8035	; TABLE DOES NOT CONTAIN VALID INFORMATION FOR THE VIRTUAL PAGE INVOLVED
							; 8036	; THE HARDWARE CALLS THIS ROUTINE TO RELOAD THE HARDWARE PAGE TABLE.
							; 8037	;
							; 8038	;THIS CODE WILL EITHER DO THE RELOAD OR GENERATE A PAGE FAIL FOR THE
							; 8039	; SOFTWARE. THE INFORMATION LOADED CONSISTS OF THE PHYSICAL PAGE NUMBER,
							; 8040	; THE CACHE ENABLE BIT AND THE WRITE ENABLE BIT.
							; 8041	
							; 8042	;THIS LOGIC USES MANY VARIABLES. THEY ARE DESCRIBED BRIEFLY HERE:
							; 8043	
							; 8044	;THING			WHERE KEPT			USE
							; 8045	;OLD VMA		WORKSPACE WORD 210		SAVES VMA
							; 8046	;OLD AR 		WORKSPACE WORD 211		SAVES AR
							; 8047	;OLD ARX		WORKSPACE WORD 212		SAVES ARX
							; 8048	;OLD BR 		WORKSPACE WORD 213		SAVES BR
							; 8049	;OLD BRX		WORKSPACE WORD 214		SAVES BRX
							; 8050	;KL PAGING BIT		EBR BIT 1 (IN 2901)		INDICATES KL STYLE (TOPS-20) PAGING
							; 8051	;							INSTEAD OF KI STYLE (TOPS-10 AND DIAGNOSTIC)
							; 8052	;							MODE PAGING
							; 8053	;W BIT			FLG BIT 4			PAGE CAN BE WRITTEN
							; 8054	;C BIT			FLG BIT 6			DATA IN THIS PAGE MAY BE PUT
							; 8055	;							INTO CACHE
							; 8056	;PI CYCLE		FLG BIT 5			STORING OLD PC DURING PI
							; 8057	;MAP FLAG		FLG BIT 18			MAP INSTRUCTION IN PROGRESS
							; 8058	;CLEANUP CODE		FLG BITS 32-35			WHAT TO DO SO INSTRUCTION MAY BE
							; 8059	;							RESTARTED
							; 8060	;SPT BASE		WORKSPACE WORD 215		ADDRESS OF SHARED-POINTER-TABLE
							; 8061	;CST BASE		WORKSPACE WORD 216		ADDRESS OF CORE-STATUS-TABLE
							; 8062	;CST MASK		WORKSPACE WORD 217		BITS TO KEEP ON CST UPDATE
							; 8063	;CST DATA (PUR) 	WORKSPACE WORD 220		BITS TO SET ON CST UPDATE
							; 8064	;PAGE TABLE ADDRESS	AR				WHERE THIS PAGE TABLE IS LOCATED
							; 8065	;PHYSICAL PAGE # (PPN)	AR				RESULT OF THIS PROCESS
							; 8066	;CST ENTRY		AR				CORE STATUS TABLE ENTRY
							; 8067	;SPT ENTRY		AR				WORD FROM SPT
							; 8068	;PAGE TABLE ENTRY	AR				WORD FROM PT
							; 8069	;PAGE NUMBER		BR				INDEX INTO CURENT PAGE TABLE
							; 8070	;PAGE FAIL WORD 	BRX				WHAT HAPPENED (ALSO MAP RESULT)
							; 8071	
							; 8072	.IF/INHCST
							; 8073		SKIP NO CST	"AD/D,DBUS/RAM,RAMADR/#,WORK/CBR,DT/4T,SKIP/ADEQ0"
							; 8074	.ENDIF/INHCST
							; 8075	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 224
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8076	;
							; 8077	;
							; 8078	;
							; 8079	;		   KL10 PAGING - WORD FORMATS
							; 8080	;
							; 8081	;Section Pointer
							; 8082	;
							; 8083	;The section pointer is found in the user or exec section table.
							; 8084	;(Part of UPT or EPT.)
							; 8085	;
							; 8086	;Section pointer provides (via the SPT) the physical address  of
							; 8087	;the PAGE TABLE for the given section.
							; 8088	;
							; 8089	;	 Code:	 0	 No-access (trap)
							; 8090	;		 1	 Immediate
							; 8091	;		 2	 Share
							; 8092	;		 3	 Indirect
							; 8093	;		 4-7	 Unused, reserved
							; 8094	;
							; 8095	;	 0 1 2 3 4 5 6		 18			 35
							; 8096	;	 +----+-+-+-+-+---------+-------------------------+	
							; 8097	;	 !CODE!P!W! !C!/////////!  PAGE TABLE IDENTIFIER  !
							; 8098	;	 !010 ! ! ! ! !/////////!	 (SPT INDEX)	  !
							; 8099	;	 +----+-+-+-+-+---------+-------------------------+
							; 8100	;
							; 8101	;		NORMAL SECTION POINTER (Code = 2)
							; 8102	;
							; 8103	;	 0   2 3 4 5 6	   9	       18		      35
							; 8104	;	 +----+-+-+-+-+---+-----------+------------------------+
							; 8105	;	 !CODE!P!W! !C!///!SECTION    !SECTION TABLE IDENTIFIER!
							; 8106	;	 !011 ! ! ! ! !///!TABLE INDEX!       (SPT INDEX)      !
							; 8107	;	 +----+-+-+-+-+---+-----------+------------------------+
							; 8108	;
							; 8109	;	       INDIRECT SECTION POINTER (Code = 3)
							; 8110	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 225
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8111	;PAGE POINTERS
							; 8112	;
							; 8113	;FOUND IN PAGE TABLES
							; 8114	;
							; 8115	;	 0 1 2 3 4 5 6	    12				 35
							; 8116	;	 +----+-+-+-+-+----+------------------------------+
							; 8117	;	 !CODE!P!W! !C!////!   PHYSICAL ADDRESS OF PAGE   !
							; 8118	;	 !001 ! ! ! ! !////!				  !
							; 8119	;	 +----+-+-+-+-+----+------------------------------+
							; 8120	;
							; 8121	;		 IMMEDIATE POINTER (code field = 1)
							; 8122	;
							; 8123	;	 B12-35  give PHYSICAL ADDRESS OF PAGE
							; 8124	;	     if  B12-17 >< 0, page not in core-trap
							; 8125	;	     if  B12-17 =  0, B23-35 give CORE PAGE
							; 8126	;			      NUMBER of page, B18-22 MBZ
							; 8127	;
							; 8128	;
							; 8129	;
							; 8130	;
							; 8131	;
							; 8132	;	 0    2 3     6 	  18			 35
							; 8133	;	 +-----+-------+---------+------------------------+
							; 8134	;	 !CODE !SAME AS!/////////!	  SPT INDEX	  !
							; 8135	;	 !010  ! IMMED.!/////////!			  !
							; 8136	;	 +-----+-------+---------+------------------------+
							; 8137	;
							; 8138	;		 SHARED POINTER (code field = 2)
							; 8139	;
							; 8140	;	 B18-35  Give SPT INDEX (SPTX).  SPTX + SPT BASE
							; 8141	;		 ADDRESS = physical core address of word
							; 8142	;		 holding physical address of page.
							; 8143	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 226
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8144	;	 0 1 2 3      6     9	 17 18			 35
							; 8145	;	 +----+--------+---+-------+----------------------+
							; 8146	;	 !CODE!SAME AS !///! PAGE  ! PAGE TABLE IDENTIFIER!	
							; 8147	;	 !011 ! IMMED. !///!NUMBER !	 (SPT INDEX)	  !
							; 8148	;	 +----+--------+---+-------+----------------------+
							; 8149	;
							; 8150	;		 INDIRECT POINTER (code field = 3)
							; 8151	;
							; 8152	;	 This pointer type causes another pointer to be  fetched
							; 8153	;	 and  interpreted.   The  new pointer is found in word N
							; 8154	;	 (B9-17) of the page addressed by C(SPT + SPTX).
							; 8155	;
							; 8156	;
							; 8157	;
							; 8158	;	 SPT ENTRY
							; 8159	;
							; 8160	;	 Found in the SPT, i.e., when fetching C(SPT +SPTX)
							; 8161	;
							; 8162	;			       12			 35
							; 8163	;	 +--------------------+---------------------------+
							; 8164	;	 !////////////////////!  PHYSICAL ADDRESS OF PAGE !
							; 8165	;	 !////////////////////! 	 OR PAGE TABLE	  !
							; 8166	;	 +--------------------+---------------------------+
							; 8167	;
							; 8168	;		 B12-35  Give PHYSICAL ADDRESS of page.
							; 8169	;
							; 8170	;	 The base address (physical core  address)  of	the  SPT
							; 8171	;	 resides in one AC of the reserved AC block.
							; 8172	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 227
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8173	;PHYSICAL STORAGE ADDRESS
							; 8174	;
							; 8175	;Found in B12-35 of IMMEDIATE POINTERS and SPT ENTRIES.
							; 8176	;
							; 8177	;			 12	 17 18	 23		 35
							; 8178	;			 +---------+----+-----------------+
							; 8179	;			 !	   !MBZ ! CORE PAGE NUMBER!
							; 8180	;			 !	   !	!   IF B12-17 = 0 !
							; 8181	;			 +---------+----+-----------------+
							; 8182	;
							; 8183	;	 If B12-17 = 0, then B23-35 are CORE PAGE NUMBER  (i.e.,
							; 8184	;	 B14-26  of  physical  core  address) of page and B18-22
							; 8185	;	 MBZ.  If B12-17 >< 0, then  address  is  not  core  and
							; 8186	;	 pager traps.
							; 8187	;
							; 8188	;
							; 8189	;
							; 8190	;CORE STATUS TABLE ENTRY
							; 8191	;
							; 8192	;Found when fetching C(CBR + CORE PAGENO)
							; 8193	;
							; 8194	;	 0	5				  32  34 35
							; 8195	;	 +-------+-------------------------------+------+-+
							; 8196	;	 !  CODE !				 !	!M!
							; 8197	;	 +-------+-------------------------------+------+-+
							; 8198	;
							; 8199	;	 B0-5	 are code field:
							; 8200	;
							; 8201	;		 0 - unavailable, trap
							; 8202	;
							; 8203	;		 1-77 - available
							; 8204	;
							; 8205	;
							; 8206	;
							; 8207	;	 B32-34 reserved for future hardware specification.
							; 8208	;
							; 8209	;	 B35 is "modified" bit, set on any write ref to page.
							; 8210	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 228
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8211	;QUANTITIES IN HARDWARE REGISTERS
							; 8212	;
							; 8213	;SPT	 SPT Base Register
							; 8214	;
							; 8215	;			 14				 35
							; 8216	;			 +--------------------------------+
							; 8217	;			 !   PHYSICAL CORE WORD ADDRESS   !
							; 8218	;			 +--------------------------------+
							; 8219	;
							; 8220	;CBR	 CST Base Register
							; 8221	;
							; 8222	;			 14				 35
							; 8223	;			 +--------------------------------+
							; 8224	;			 !   PHYSICAL CORE WORD ADDRESS   !
							; 8225	;			 +--------------------------------+
							; 8226	;
							; 8227	;CSTMSK  CST Update Mask
							; 8228	;
							; 8229	;	 0					     32  35
							; 8230	;	 +------------------------------------------+---+-+
							; 8231	;	 !			 MASK		    !111!1!
							; 8232	;	 +------------------------------------------+---+-+
							; 8233	;
							; 8234	;		 ANDed with CST word during update
							; 8235	;
							; 8236	;(B32-35 must be all 1's to preserve existing CST information)
							; 8237	;
							; 8238	;CSTDATA CST Update Data
							; 8239	;
							; 8240	;	 0				      32 34 35	
							; 8241	;	 +------------------------------------------+---+-+
							; 8242	;	 !			 DATA		    !000!0!
							; 8243	;	 +------------------------------------------+---+-+
							; 8244	;
							; 8245	;		 IORed with CST word during update
							; 8246	;
							; 8247	;(B32-35 must be all 0's to preserve existing CST information)
							; 8248	;
							; 8249	;All  unspecified  bits  and  fields  are  reserved  for  future
							; 8250	;specification by DEC.
							; 8251	;
							; 8252	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 229
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8253		.BIN
							; 8254	
							; 8255		.DCODE
D 0257, 1215,1553,0100					; 8256	257:	IOT,	AC,	J/MAP
							; 8257		.UCODE
							; 8258	
							; 8259	1553:
							; 8260	MAP:	[AR]_[AR].OR.#,		;ASSUME PHYSICAL REF
							; 8261		#/160000,		;FAKE ANSWER
U 1553, 3762,3551,0303,4374,0007,0700,0000,0016,0000	; 8262		HOLD RIGHT		; ..
U 3762, 3763,3771,0006,4354,4007,0700,0000,0000,0000	; 8263		[BRX]_VMA		;PUT VMA AND FLAGS IN BRX
							; 8264		[BRX]_[BRX].AND.#,	;JUST KEEP USER BIT
U 3763, 3764,4551,0606,4374,0007,0700,0000,0040,0000	; 8265		#/400000, HOLD RIGHT	; ..
U 3764, 3765,3333,0006,7174,4007,0700,0400,0000,0210	; 8266		WORK[SV.VMA]_[BRX]	;SAVE IN WORKSPACE
U 3765, 3766,3771,0005,7274,4007,0701,0000,0000,0230	; 8267		[BR]_WORK[APR]		;GET APR FLAGS
U 3766, 2554,4553,0500,4374,4007,0331,0000,0003,0000	; 8268		TR [BR], #/030000	;PAGING ENABLED?
U 2554, 3776,3771,0013,4370,4007,0700,0000,0040,0002	; 8269	=0	STATE_[MAP], J/PFMAP	;YES--DO REAL MAP
U 2555, 0100,3440,0303,0174,4156,4700,0400,0000,0000	; 8270		AC_[AR], NEXT INST	;NO--RETURN VIRTUAL ADDRESS
							; 8271	
							; 8272	; HARDWARE COMES HERE ON PAGE TABLE NOT VALID (OR INTERRUPT) WHEN
							; 8273	; STARTING A MEMORY REFERENCE. MICOWORD ADDRESS OF INSTRUCTION DOING
							; 8274	; MEM WAIT IS SAVED ON THE STACK.
							; 8275	; THE PAGE-FAIL ENTRY POINT HAS ALL OF THE ADDRESS BITS SET.
							; 8276	; PAGE-FILE IS 3777 FOR A MACHINE THAT HAS 2K OF MICROCODE AND
							; 8277	; IS 7777 FOR A MACHINE THAT HAS 4K OF MICROCODE.
							; 8278	
							; 8279	
							; 8280	3777:
							; 8281	.IF/CRAM4K:
U 3777, 0104,4751,1217,4374,4007,0700,0000,0000,1776	; 8282		HALT [1776]
							; 8283	7777:
							; 8284	.ENDIF/CRAM4K
							; 8285	
							; 8286	PAGE-FAIL:
U 7777, 3767,3333,0003,7174,4007,0700,0400,0000,0211	; 8287		WORK[SV.AR]_[AR]
U 3767, 3770,3333,0006,7174,4007,0700,0400,0000,0214	; 8288	ITRAP:	WORK[SV.BRX]_[BRX]
U 3770, 3771,3771,0006,4354,4007,0700,0000,0000,0000	; 8289		[BRX]_VMA
U 3771, 3772,3333,0006,7174,4007,0700,0400,0000,0210	; 8290		WORK[SV.VMA]_[BRX]
							; 8291		WORK[SV.ARX]_[ARX],
U 3772, 1060,3333,0004,7174,4007,0370,0400,0000,0212	; 8292		SKIP IRPT		;SEE IF INTERRUPT (SAVE DISPATCH)
							; 8293	=0000
							; 8294	PFD:	DBM/PF DISP, DBUS/DBM,	;BRING CODE TO 2901'S
							; 8295		AD/D, DEST/PASS, 4T,	;PUT ON DP 18-21
U 1060, 1060,3773,0000,4304,4003,1702,0000,0000,0000	; 8296		DISP/DP LEFT, J/PFD	;DISPATCH ON IT
							; 8297	=0001				;(1) INTERRUPT
U 1061, 4045,3333,0005,7174,4007,0700,0400,0000,0213	; 8298		WORK[SV.BR]_[BR], J/PFPI1
							; 8299	=0011				;(3) BAD DATA FROM MEMORY
							; 8300		[BRX]_IO DATA,		;GET THE BAD DATA
							; 8301		AD PARITY OK/0,		; DO NOT LOOK AT PARITY
U 1063, 3773,3771,0006,4374,4007,0700,0000,0000,0000	; 8302		J/BADDATA		;SAVE IN AC BLK 7
							; 8303	=0101				;(5) NXM ERROR
U 1065, 4043,4571,1206,4374,4007,0700,0000,0037,0000	; 8304		[BRX]_[370000] XWD 0, J/HARD
							; 8305	=0111				;(7) NXM & BAD DATA
U 1067, 4043,4571,1206,4374,4007,0700,0000,0037,0000	; 8306		[BRX]_[370000] XWD 0, J/HARD
							; 8307	=1000				;(10) WRITE VIOLATION
U 1070, 3776,3333,0005,7174,4007,0700,0400,0000,0213	; 8308		WORK[SV.BR]_[BR], J/PFMAP; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 229-1
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8309	=1001				;[123] (11) 1 ms timer and movsrj
U 1071, 4045,3333,0005,7174,4007,0700,0400,0000,0213	; 8310		WORK[SV.BR]_[BR], J/PFPI1
							; 8311	=1010				;(12) PAGE NOT VALID
U 1072, 3776,3333,0005,7174,4007,0700,0400,0000,0213	; 8312		WORK[SV.BR]_[BR], J/PFMAP
							; 8313	=1011				;(13) EXEC/USER MISMATCH
U 1073, 3776,3333,0005,7174,4007,0700,0400,0000,0213	; 8314		WORK[SV.BR]_[BR], J/PFMAP
							; 8315	=
							; 8316	
							; 8317	BADDATA:
U 3773, 3774,3333,0006,7174,4007,0700,0400,0000,0160	; 8318		WORK[BADW0]_[BRX]	;SAVE BAD WORD
U 3774, 3775,3333,0006,7174,4007,0700,0400,0000,0161	; 8319		WORK[BADW1]_[BRX]	;AGAIN
U 3775, 4043,4571,1206,4374,4007,0700,0000,0036,0000	; 8320		[BRX]_[360000] XWD 0, J/HARD
							; 8321	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 230
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8322	;WE HAVE SAVED AR, ARX, BR AND BRX. WE MERGE IN HERE FROM MAP
							; 8323	; INSTRUCTION, SAVE THE VMA AND START THE PAGE FAIL WORD.
U 3776, 4000,4223,0000,4364,4277,0700,0200,0000,0010	; 8324	PFMAP:	ABORT MEM CYCLE		;CLEAR PAGE FAIL
							; 8325		[FLG]_[FLG].OR.#,	;PRESET W AND C TO 1
							; 8326		FLG.W/1, FLG.C/1,	;BITS INVOLVED
U 4000, 4001,3551,1313,4374,0007,0700,0000,0002,4000	; 8327		HOLD RIGHT		;LEAVE RH ALONE
U 4001, 2556,4553,0600,4374,4007,0321,0000,0002,0000	; 8328		TL [BRX], WRITE TEST/1	;IS THIS A WRITE TEST?
							; 8329	=0	[BRX]_[BRX].OR.#,
							; 8330		#/10000,
U 2556, 2557,3551,0606,4374,0007,0700,0000,0001,0000	; 8331		HOLD RIGHT		;YES--TURN INTO WRITE REF
							; 8332		[BRX]_[BRX].AND.#,	;START PAGE FAIL WORD
							; 8333		#/411000,		;SAVE 3 INTERESTING BITS
U 2557, 4002,4551,0606,4374,0007,0700,0000,0041,1000	; 8334		HOLD RIGHT		;SAVE VIRTUAL ADDRESS
							; 8335					;USER ADDR (400000)
							; 8336					;WRITE REF (010000)
							; 8337					;PAGED REF (001000)
							; 8338		[BRX]_[BRX].XOR.#,	;FIX BIT 8
U 4002, 4003,6551,0606,4374,0007,0700,0000,0000,1000	; 8339		#/1000, HOLD RIGHT
							; 8340		[BR]_[BRX],		;COPY VIRTUAL ADDRESS
U 4003, 2560,3441,0605,4174,4007,0700,2000,0071,0007	; 8341		SC_7			;PREPARE TO SHIFT 9 PLACES
							; 8342	=0
							; 8343	PF25:	[BR]_[BR]*.5,		;RIGHT ADJUST PAGE #
							; 8344		STEP SC,		;COUNT SHIFT STEPS
U 2560, 2560,3447,0505,4174,4007,0630,2000,0060,0000	; 8345		J/PF25			;LOOP FOR 9
							; 8346		[BR]_[BR].AND.# CLR LH,	;MASK TO 9 BITS
U 2561, 4004,4251,0505,4374,4007,0700,0000,0000,0777	; 8347		#/777			; ..
							; 8348	.IF/KLPAGE
							; 8349	.IF/KIPAGE
							; 8350		TL [EBR],		;KI MODE REFILL?
U 4004, 2562,4553,1000,4374,4007,0321,0000,0000,0040	; 8351		#/40			;FLAG BIT
							; 8352	=0
							; 8353	.ENDIF/KIPAGE
							; 8354		READ [BRX],		;USER REF? (KL MODE)
							; 8355		SKIP DP0,		; ..
U 2562, 2564,3333,0006,4174,4007,0520,0000,0000,0000	; 8356		J/PF30			;CONTINUE AT PF30
							; 8357	.ENDIF/KLPAGE
							; 8358	.IF/KIPAGE
							; 8359		[ARX]_[BR]*.5,		;KI10 MODE REFILL
U 2563, 4036,3447,0504,4174,4007,0700,0000,0000,0000	; 8360		J/KIFILL		;GO HANDLE EASY CASE
							; 8361	.ENDIF/KIPAGE
							; 8362	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 231
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8363	.IF/KLPAGE
							; 8364	;HERE IN TOPS-20 MODE
							; 8365	;PICK UP CORRECT SECTION POINTER
							; 8366	=0
							; 8367	PF30:	[ARX]_WORK[PTA.E],	;EXEC MODE
							; 8368		SKIP AD.EQ.0, 4T,	;SEE IF VALID
U 2564, 2570,3771,0004,7274,4007,0622,0000,0000,0423	; 8369		J/PF35			;CONTINUE BELOW
							; 8370		[ARX]_WORK[PTA.U],	;USER MODE
U 2565, 2566,3771,0004,7274,4007,0622,0000,0000,0424	; 8371		SKIP AD.EQ.0, 4T	;SEE IF VALID
							; 8372	=0	VMA_[ARX]+[BR],		;POINTER VALID
							; 8373		VMA PHYSICAL READ,	;START MEMORY
U 2566, 1140,0113,0405,4174,4007,0700,0200,0024,1016	; 8374		J/PF77			;CONTINUE BELOW
							; 8375		[AR]_[UBR]+#, 3T,	;USER MODE
							; 8376		#/540,			;OFFSET TO UPT
U 2567, 4005,0551,1103,4374,4007,0701,0000,0000,0540	; 8377		J/PF40			;GO GET POINTER
							; 8378	
							; 8379	=0
							; 8380	PF35:	VMA_[ARX]+[BR],		;POINTER VALID
							; 8381		VMA PHYSICAL READ,	;START MEMORY
U 2570, 1140,0113,0405,4174,4007,0700,0200,0024,1016	; 8382		J/PF77			;CONTINUE BELOW
							; 8383		[AR]_[EBR]+#, 3T,	;EXEC MODE
U 2571, 4005,0551,1003,4374,4007,0701,0000,0000,0540	; 8384		#/540			;OFFSET TO EPT
							; 8385	PF40:	VMA_[AR],		;LOAD THE VMA
							; 8386		START READ,		;START THE MEMORY CRANKING
U 4005, 4006,3443,0300,4174,4007,0700,0200,0024,1016	; 8387		VMA PHYSICAL		;ABSOLUTE ADDRESS
							; 8388		MEM READ,		;WAIT FOR MEMORY
U 4006, 1000,3771,0003,4365,5007,0700,0200,0000,0002	; 8389		[AR]_MEM		;POINT POINTER IN AR
							; 8390	;LOOK AT SECTION POINTER AND DISPATCH ON TYPE
							; 8391	=000
							; 8392	PF45:	SC_7,			;FETCH SECTION 0 POINTER
U 1000, 4031,4443,0000,4174,4007,0700,2010,0071,0007	; 8393		CALL [SETPTR]		;FIGURE OUT POINTER TYPE
							; 8394	SECIMM:	TL [AR],		;IMMEDIATE POINTER
							; 8395		#/77,			;TEST FOR 12-17 = 0
U 1001, 2574,4553,0300,4374,4007,0321,0000,0000,0077	; 8396		J/PF50			;CONTINUE AT PF50
							; 8397		[AR]_[AR]+WORK[SBR],	;SHARED SECTION
U 1002, 2251,0551,0303,7274,4007,0701,0000,0000,0215	; 8398		J/SECSHR		;GO FETCH POINTER FROM SPT
							; 8399		[AR]_[AR]+WORK[SBR],	;INDIRECT SECTION POINTER
U 1003, 4034,0551,0303,7274,4007,0701,0010,0000,0215	; 8400		CALL [RDPT]		;GO FETCH SPT ENTRY
							; 8401	=111	TL [AR],		;12 TO 17 = 0?
U 1007, 2572,4553,0300,4374,4007,0321,0000,0000,0077	; 8402		#/77			; ..
							; 8403	=
U 2572, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8404	=0	PAGE FAIL TRAP		;NO
							; 8405		[AR]_[AR]*2,		;FIRST SHIFT
U 2573, 1010,3445,0303,4174,4007,0630,2000,0060,0000	; 8406		STEP SC			;SC WAS LOADED AT PF45
							; 8407	=0*0
							; 8408	PF60:	[AR]_[AR]*2,		;CONVERT TO ADDRESS OF
							; 8409		STEP SC,		; SECTION TABLE
U 1010, 1010,3445,0303,4174,4007,0630,2000,0060,0000	; 8410		J/PF60
U 1011, 4034,4443,0000,4174,4007,0700,0010,0000,0000	; 8411		CALL [RDPT]		;READ SECTION TABLE
U 1015, 1000,4443,0000,4174,4007,0700,0000,0000,0000	; 8412	=1*1	J/PF45			;TRY AGAIN
							; 8413	=
							; 8414	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 232
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8415	;STILL .IF/KLPAGE
							; 8416	;HERE FOR SHARED SECTION. AR GETS THE ADDRESS OF PAGE TABLE
							; 8417	=0**
U 2251, 4034,4443,0000,4174,4007,0700,0010,0000,0000	; 8418	SECSHR:	CALL [RDPT]		;READ WORD FROM SPT
U 2255, 2574,4553,0300,4374,4007,0321,0000,0000,0077	; 8419		TL [AR], #/77		;TEST FOR BITS 12-17 = 0
							; 8420	
							; 8421	;HERE WITH ADDRESS OF PAGE TABLE IN AR AND SKIP ON
							; 8422	; BITS 12 THRU 17 EQUAL TO ZERO
							; 8423	=0
U 2574, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8424	PF50:	PAGE FAIL TRAP		;BITS 12-17 .NE. 0
							; 8425		[ARX]_[AR].AND.# CLR LH, ;PAGE NUMBER OF PAGE TABLE
U 2575, 2600,4251,0304,4374,4007,0700,0000,0000,3777	; 8426		#/3777			;11 BIT PHYSICAL PAGE #
							; 8427	.IFNOT/NOCST
							; 8428	=0*	[AR]_[ARX],		;COPY ADDRESS
U 2600, 4030,3441,0403,4174,4007,0700,0010,0000,0000	; 8429		CALL [UPCST]		;UPDATE CST0
U 2602, 2601,3551,0303,7274,4007,0701,0000,0000,0220	; 8430	PF70:	[AR]_[AR].OR.WORK[PUR]	;PUT IN NEW AGE AND
							; 8431					; USE BITS
							;;8432	.IFNOT/INHCST
							;;8433	=0**	START NO TEST WRITE,	;START MEMORY WRITE
							;;8434		CALL [IBPX]		;GO STORE IN MEMORY
							; 8435	.ENDIF/INHCST
							; 8436	.IF/INHCST
							; 8437	=0**	SKIP NO CST,		;SEE IF A CST
U 2601, 2646,3773,0000,7274,4007,0622,0010,0000,0216	; 8438		CALL [WRCST]		;AND GO WRITE IN MEMORY
							; 8439	.ENDIF/INHCST
U 2605, 2576,4443,0000,4174,4007,0700,2000,0071,0007	; 8440		SC_7			;THIS CAN BE BUMMED
							; 8441	=0
							; 8442	PF75:	[ARX]_[ARX]*2,		;CONVERT PAGE NUMBER TO
							; 8443		STEP SC,		; PAGE ADDRESS
U 2576, 2576,3445,0404,4174,4007,0630,2000,0060,0000	; 8444		J/PF75			;LOOP OVER 9 STEPS
							; 8445	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 233
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8446	;STILL .IF/KLPAGE
							; 8447	;WE NOW HAVE THE ADDRESS OF THE PAGE TABLE ENTRY. GO
							; 8448	; READ IT AND START ANALYSIS
							; 8449	
							; 8450	;IF WE ARE HERE FOR THE FIRST TIME FOR THE USER OR EXEC SAVE THE
							; 8451	; ADDRESS OF THE PAGE TABLE IN PTA.E OR PTA.U SO THAT WE DO NOT
							; 8452	; HAVE TO DO THE SECTION LOOKUP EVERY TIME.
U 2577, 1040,3333,0006,4174,4007,0520,0000,0000,0000	; 8453		READ [BRX], SKIP DP0	;USER OR EXEC REF?
							; 8454	=000	[AR]_WORK[PTA.E],	;EXEC MODE
							; 8455		SKIP AD.EQ.0, 4T,	;SEE IF SET YET
U 1040, 2662,3771,0003,7274,4007,0622,0010,0000,0423	; 8456		CALL [SHDREM]		;SHOULD WE REMEMBER PTR
							; 8457		[AR]_WORK[PTA.U],	;USER MODE
							; 8458		SKIP AD.EQ.0, 4T,	;SEE IF SET YET
U 1041, 2662,3771,0003,7274,4007,0622,0010,0000,0424	; 8459		CALL [SHDREM]		;SHOULD WE REMEMBER PTR
							; 8460		WORK[PTA.E]_[ARX],	;SAVE FOR EXEC
U 1042, 1047,3333,0004,7174,4007,0700,0400,0000,0423	; 8461		J/PF76			;CONTINUE BELOW
							; 8462		WORK[PTA.U]_[ARX],	;SAVE FOR USER
U 1043, 1047,3333,0004,7174,4007,0700,0400,0000,0424	; 8463		J/PF76			;CONTINUE BELOW
							; 8464	=111
							; 8465	PF76:	VMA_[ARX]+[BR], 	;READ PAGE POINTER
							; 8466		START READ,
U 1047, 1140,0113,0405,4174,4007,0700,0200,0024,1016	; 8467		VMA PHYSICAL
							; 8468	=
							; 8469	=00
							; 8470	PF77:	MEM READ,		;START ANALYSIS OF POINTER
							; 8471		[AR]_MEM,
U 1140, 4031,3771,0003,4365,5007,0700,0210,0000,0002	; 8472		CALL [SETPTR]
							; 8473	PTRIMM: TL [AR],		;IMMEDIATE POINTER
							; 8474		#/77,			;CHECK FOR BITS 0-5
U 1141, 1144,4553,0300,4374,4007,0321,0000,0000,0077	; 8475		J/PF80			;GO TO PF80
							; 8476		[AR]_[AR]+WORK[SBR],	;SHARED POINTER
U 1142, 2612,0551,0303,7274,4007,0701,0000,0000,0215	; 8477		J/PTRSHR		;GO TO READ SPT
							; 8478	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 234
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8479	;STILL .IF/KLPAGE
							; 8480	;INDIRECT POINTER. CHANGE PAGE # AND LOOK FOR PAGE TABLE
							; 8481	PTRIND:	[BR]_[AR] SWAP, 	;PUT IN RIGHT HALF
U 1143, 2606,3770,0305,4344,4007,0670,0000,0000,0000	; 8482		SKIP/-1 MS		;DID CLOCK GO OFF
							; 8483	=0	WORK[SV.AR1]_[AR],	;YES--UPDATE CLOCK
U 2606, 2624,3333,0003,7174,4007,0700,0400,0000,0426	; 8484		J/PFTICK		; ..
							; 8485		[BR]_[BR].AND.# CLR LH,	;UPDATE PAGE # AND RESTART
							; 8486		#/777,			;MASK FOR PAGE #
U 2607, 2610,4251,0505,4374,4007,0370,0000,0000,0777	; 8487		SKIP IRPT		;SEE IF THIS IS A LOOP
							; 8488	=0	[AR]_[AR].AND.#,	;CHANGE INDIRECT POINTER
							; 8489		#/277000,		; INTO SHARE POINTER
							; 8490		HOLD RIGHT,		; ..
U 2610, 1000,4551,0303,4374,0007,0700,0000,0027,7000	; 8491		J/PF45			;GO BACK AND TRY AGAIN
U 2611, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8492		PAGE FAIL TRAP		;POINTER LOOP
							; 8493	
							; 8494	=0**
U 2612, 4034,4443,0000,4174,4007,0700,0010,0000,0000	; 8495	PTRSHR:	CALL [RDPT]		;GO LOOK AT POINTER
							; 8496		TL [AR],		;BITS 12-17 .EQ. 0?
U 2616, 1144,4553,0300,4374,4007,0321,0000,0000,0077	; 8497		#/77
							; 8498	
							; 8499	;HERE WITH FINAL POINTER. SKIP IF 12-17 NOT EQUAL TO ZERO
							; 8500	.IFNOT/NOCST
							; 8501	=00
U 1144, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8502	PF80:	PAGE FAIL TRAP		;NO--TAKE A TRAP
							; 8503		[ARX]_[AR].AND.# CLR LH, ;SAVE PHYSICAL PAGE #
							; 8504		#/3777,			;MASK TO 13 BITS
U 1145, 4030,4251,0304,4374,4007,0700,0010,0000,3777	; 8505		CALL [UPCST]		;UPDATE CST0
							; 8506	=11
							;;8507	.IF/NOCST
							;;8508	=0
							;;8509	PF80:	PAGE FAIL TRAP		;NO--TAKE A TRAP
							; 8510	.ENDIF/NOCST
							; 8511	
							; 8512	;HERE WE HAVE CST ENTRY IN AR, PAGE FAIL WORD IN BRX. GO LOOK
							; 8513	; AT WRITABLE AND WRITTEN BITS
							; 8514	PF90:	[BRX]_[BRX].OR.#,	;TRANSLATION IS VALID
U 1147, 4007,3551,0606,4374,0007,0700,0000,0010,0000	; 8515		#/100000, HOLD RIGHT	; ..
U 4007, 2614,4553,1300,4374,4007,0321,0000,0002,0000	; 8516		TL [FLG], FLG.W/1	;IS THIS PAGE WRITABLE?
							; 8517	=0	[BRX]_[BRX].OR.#,	;YES--INDICATE THAT IN PFW
							; 8518		#/020000,
U 2614, 4010,3551,0606,4374,4007,0700,0000,0002,0000	; 8519		J/PF100			;NOT WRITE VIOLATION
							; 8520		TL [BRX],		;IS THIS A WRITE REF?
U 2615, 2620,4553,0600,4374,4007,0321,0000,0003,0000	; 8521		WRITE TEST/1, WRITE CYCLE/1
U 2620, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8522	=0	PAGE FAIL TRAP		;WRITE VIOLATION
							; 8523	PF107:
							; 8524	.IFNOT/NOCST
							; 8525		[AR]_[AR].OR.WORK[PUR],	;PUT IN NEW AGE
U 2621, 2613,3551,0303,7274,4007,0701,0000,0000,0220	; 8526		J/PF110			;GO TO STORE CST ENTRY
							; 8527	.ENDIF/NOCST
							;;8528	.IF/NOCST
							;;8529	PFDONE:	TR [FLG],
							;;8530		#/400000,
							;;8531		J/PF140
							; 8532	.ENDIF/NOCST
							; 8533	
							; 8534	=0*; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 234-1
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8535	PFTICK:	[AR]_WORK[TIME1],	;UPDATE TIMER
U 2624, 3621,3771,0003,7274,4117,0701,0010,0000,0301	; 8536		SPEC/CLRCLK, CALL [TOCK]
							; 8537		[AR]_WORK[SV.AR1],	;RESTORE AR
U 2626, 1143,3771,0003,7274,4007,0701,0000,0000,0426	; 8538		J/PTRIND		;GO TRY AGAIN
							; 8539	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 235
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8540	;STILL .IF/KLPAGE
							; 8541	;HERE IF PAGE IS WRITABLE
U 4010, 2622,4553,0600,4374,4007,0321,0000,0001,0000	; 8542	PF100:	TL [BRX], WRITE CYCLE/1	;IS THIS A WRITE REF?
							; 8543	=0	[AR]_[AR].OR.#, 	;YES--SET WRITTEN BIT
							; 8544		#/1,
							; 8545		HOLD LEFT,
U 2622, 2630,3551,0303,4370,4007,0700,0000,0000,0001	; 8546		J/PF105
							; 8547		TR [AR],		;NOT WRITE, ALREADY WRITTEN?
U 2623, 2630,4553,0300,4374,4007,0331,0000,0000,0001	; 8548		#/1
							; 8549	=0
							; 8550	PF105:	[BRX]_[BRX].OR.#,	;WRITTEN SET BIT
							; 8551		#/040000,		;MARK PAGE AS
							; 8552		HOLD RIGHT,		;WRITABLE
U 2630, 2621,3551,0606,4374,0007,0700,0000,0004,0000	; 8553		J/PF107			;STORE CST WORD
							; 8554		[FLG]_[FLG].AND.NOT.#,	;NOT WRITTEN, CAUSE TRAP ON
							; 8555		FLG.W/1,		; WRITE ATTEMPT
							; 8556		HOLD RIGHT,		;ONLY CLEAR LH
U 2631, 2621,5551,1313,4374,0007,0700,0000,0002,0000	; 8557		J/PF107
							; 8558	.IFNOT/NOCST
							; 8559	=0**
							; 8560	PF110:
							;;8561	.IFNOT/INHCST
							;;8562		START NO TEST WRITE,
							;;8563		CALL [IBPX]		;STORE CST ENTRY
							; 8564	.ENDIF/INHCST
							; 8565	.IF/INHCST
							; 8566		SKIP NO CST,
U 2613, 2646,3773,0000,7274,4007,0622,0010,0000,0216	; 8567		CALL [WRCST]
							; 8568	.ENDIF/INHCST
							; 8569	
							; 8570	.ENDIF/KLPAGE
							; 8571	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 236
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8572	
							; 8573	;HERE WHEN WE HAVE FIGURED OUT PHYSICAL ADDRESS (IN ARX) AND FLAGS
							; 8574	; (IN BRX) RELOAD PAGE TABLE.
							; 8575	PFDONE: TR [FLG],		;MAP INSTRUCTION?
U 2617, 2632,4553,1300,4374,4007,0331,0000,0040,0000	; 8576		#/400000
							; 8577	.ENDIF/NOCST
							; 8578	=0
							; 8579	PF140:	[AR]_[ARX],		;GET PHYSCIAL PAGE #
							; 8580		SC_7,			;PREPARE TO CONVERT TO
U 2632, 2634,3441,0403,4174,4007,0700,2000,0071,0007	; 8581		J/PF130			; WORD ADDRESS
							; 8582		[AR]_WORK[SV.VMA],	;RESTORE VMA
U 2633, 4015,3771,0003,7274,4007,0701,0000,0000,0210	; 8583		J/PF120
							; 8584	=0
							; 8585	PF130:	[AR]_[AR]*2,		;CONVERT TO WORD #
							; 8586		STEP SC,
U 2634, 2634,3445,0303,4174,4007,0630,2000,0060,0000	; 8587		J/PF130
							; 8588		[AR]_[AR].AND.#,	;JUST ADDRESS BITS
							; 8589		#/3,
U 2635, 4011,4551,0303,4374,0007,0700,0000,0000,0003	; 8590		HOLD RIGHT
U 4011, 4012,4221,0013,4170,4007,0700,0000,0000,0000	; 8591		END MAP 		;CLEAR MAP FLAGS
							; 8592		[BRX]_[BRX].OR.#,	;TURN ON THE TRANSLATION
							; 8593		#/100000,		; VALID BIT
U 4012, 4013,3551,0606,4374,0007,0700,0000,0010,0000	; 8594		HOLD RIGHT		; IN LEFT HALF ONLY
U 4013, 2636,4553,1300,4374,4007,0321,0000,0000,4000	; 8595		TL [FLG], FLG.C/1	;CACHE BIT SET?
							; 8596	=0	[BRX]_[BRX].OR.#,	;YES--SET IN MAP WORD
U 2636, 2637,3551,0606,4374,0007,0700,0000,0000,2000	; 8597		#/002000, HOLD RIGHT	; ..
							; 8598		[BRX]_[BRX].AND.#,	;PRESERVE WORD #
U 2637, 4014,4551,0606,4370,4007,0700,0000,0000,0777	; 8599		#/777, HOLD LEFT	; IN PAGE FAIL WORD
							; 8600		[AR]_[AR].OR.[BRX],	;COMPLETE MAP INSTRUCTION
U 4014, 1500,3111,0603,4174,4003,7700,0200,0003,0001	; 8601		EXIT
							; 8602	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 237
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

U 4015, 4016,3441,0305,4174,4007,0700,0000,0000,0000	; 8603	PF120:	[BR]_[AR]		;COPY PAGE FAIL WORD
							; 8604		[BR]_[AR].AND.NOT.#,	;CLEAR BITS WHICH START A CYCLE
							; 8605		READ CYCLE/1,		; ..
							; 8606		WRITE CYCLE/1,		; ..
							; 8607		WRITE TEST/1,		; ..
U 4016, 4017,5551,0305,4374,0007,0700,0000,0007,0000	; 8608		HOLD RIGHT		;JUST DO LEFT HALF
							; 8609		VMA_[BR], 3T,		;RESTORE VMA
U 4017, 4020,3443,0500,4174,4007,0701,0200,0000,0030	; 8610		DP FUNC/1		;SET USER ACCORDING TO WHAT IT WAS
							; 8611		[ARX]_[ARX].AND.# CLR LH, ;JUST KEEP PAGE #
U 4020, 4021,4251,0404,4374,4007,0700,0000,0000,3777	; 8612		#/3777			; ..
U 4021, 4022,3551,0406,4374,4007,0700,0000,0040,0000	; 8613		[BRX]_[ARX].OR.#, #/400000 ;SET VALID BITS
U 4022, 2640,4553,1300,4374,4007,0321,0000,0002,0000	; 8614		TL [FLG], FLG.W/1	;WANT WRITE SET?
U 2640, 2641,3551,0606,4374,4007,0700,0000,0004,0000	; 8615	=0	[BRX]_[BRX].OR.#, #/040000 ;SET WRITE BIT
							; 8616		TL [FLG], FLG.C/1,	;WANT CACHE SET?
U 2641, 2642,4553,1300,4374,4147,0321,0000,0000,4000	; 8617		LOAD PAGE TABLE		;LOAD PAGE TABLE ON NEXT
							; 8618					; MICRO INSTRUCTION
							; 8619	=0	[BRX]_[BRX].OR.#,	;SET CACHE BIT
U 2642, 4023,3551,0606,4374,4007,0700,0000,0002,0000	; 8620		#/020000, J/PF125	;CACHE BIT
U 2643, 4023,3333,0006,4174,4007,0700,0000,0000,0000	; 8621		READ [BRX]		;LOAD PAGE TABLE
U 4023, 4024,3771,0004,7274,4007,0701,0000,0000,0212	; 8622	PF125:	[ARX]_WORK[SV.ARX]
U 4024, 4025,3771,0005,7274,4007,0701,0000,0000,0213	; 8623		[BR]_WORK[SV.BR]
U 4025, 4026,3771,0006,7274,4007,0701,0000,0000,0214	; 8624		[BRX]_WORK[SV.BRX]
							; 8625		VMA_[AR],		;MAKE MEM REQUEST
							; 8626		DP FUNC/1, 3T,		;FROM DATA PATH
U 4026, 4027,3443,0300,4174,4007,0701,0200,0000,0032	; 8627		WAIT/1			;WAIT FOR PREVIOUS CYCLE TO
							; 8628					; COMPLETE. (NEED THIS TO 
							; 8629					; START ANOTHER CYCLE)
							; 8630		[AR]_WORK[SV.AR],
U 4027, 0000,3771,0003,7274,4004,1701,0000,0000,0211	; 8631		RETURN [0]
							; 8632	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 238
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8633	.IF/KLPAGE
							; 8634	.IFNOT/NOCST
							; 8635	;SUBROUTINE TO START CST UPDATE
							; 8636	;CALL WITH:
							; 8637	;	AR/ PHYSICAL PAGE NUMBER
							; 8638	;RETURN 2 WITH ENTRY IN AR, PAGE FAIL IF AGE TOO SMALL
							;;8639	.IFNOT/INHCST
							;;8640	=0**
							;;8641	UPCST:	[AR]_[AR]+WORK[CBR],	;ADDRESS OF CST0 ENTRY
							;;8642		CALL [RDPT]		;READ OLD VALUE
							;;8643		TL [AR],		;0 - 5 = 0?
							;;8644		#/770000		; ..
							;;8645	=0	[AR]_[AR].AND.WORK[CSTM],	;CLEAR AGE FIELD
							;;8646		RETURN [2]		;AGE IS NOT ZERO
							;;8647		PAGE FAIL TRAP		;AGE TOO SMALL
							; 8648	.ENDIF/INHCST
							; 8649	.IF/INHCST
U 4030, 1150,3773,0000,7274,4007,0622,0000,0000,0216	; 8650	UPCST:	SKIP NO CST		;SEE IF A CST IS PRESENT
							; 8651	=0*0	[AR]_[AR]+WORK[CBR],	;YES, ADDRESS OF CST0 ENTRY
U 1150, 4034,0551,0303,7274,4007,0701,0010,0000,0216	; 8652		CALL [RDPT]		;READ OLD VALUE
U 1151, 0002,4221,0003,4174,4004,1700,0000,0000,0000	; 8653		[AR]_0,RETURN [2]	;NO CST, RETURN
							; 8654		TL [AR],		;CHECK AGE FIELD
U 1154, 2644,4553,0300,4374,4007,0321,0000,0077,0000	; 8655		#/770000
							; 8656	=
							; 8657	=0	[AR]_[AR].AND.WORK[CSTM],	;CLEAR AGE FIELD
U 2644, 0002,4551,0303,7274,4004,1701,0000,0000,0217	; 8658		RETURN [2]		;AGE IS NOT ZERO
U 2645, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8659		PAGE FAIL TRAP		;AGE TOO SMALL
							; 8660	
							; 8661	=0
							; 8662	WRCST:	START NO TEST WRITE,
U 2646, 3114,4443,0000,4174,4007,0700,0200,0001,0002	; 8663		J/IBPX
U 2647, 0004,4443,0000,4174,4004,1700,0000,0000,0000	; 8664		RETURN [4]
							; 8665	.ENDIF/INHCST
							; 8666	.ENDIF/NOCST
							; 8667	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 239
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8668	;STILL .IF/KLPAGE
							; 8669	;SUBROUTINE TO LOOK AT PAGE POINTER
							; 8670	;CALL WITH POINTER IN AR
							; 8671	;RETURNS 1 IF TYPE 1
							; 8672	;RETURNS 2 IF TYPE 2
							; 8673	;RETURNS 3 IF TYPE 3
							; 8674	;GOES TO PFT IF TYPE 0 OR 4 THRU 7
							; 8675	SETPTR: [ARX]_[AR].OR.#,	;AND C AND W BITS
U 4031, 4032,3551,0304,4374,4007,0700,0000,0075,3777	; 8676		#/753777		; OF ALL POINTERS
							; 8677		[FLG]_[FLG].AND.[ARX],	; ..
U 4032, 4033,4111,0413,4174,0007,0700,0000,0000,0000	; 8678		HOLD RIGHT		;KEEP IN LH OF FLG
							; 8679		READ [AR],		;TYPE 4,5,6 OR 7?
U 4033, 2650,3333,0003,4174,4007,0520,0000,0000,0000	; 8680		SKIP DP0		; ..
							; 8681	=0	TL [AR],		;HERE WE TEST FOR TYPE
							; 8682		#/300000,		; ZERO POINTER
U 2650, 2652,4553,0300,4374,4007,0321,0000,0030,0000	; 8683		J/STPTR1		;CHECK AT STPTR1
U 2651, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8684		PAGE FAIL TRAP		;BAD TYPE
							; 8685	=0
							; 8686	STPTR1: TL [AR],		;NOT ZERO
							; 8687		#/100000,		;SEPERATE TYPE 2
U 2652, 2654,4553,0300,4374,4007,0321,0000,0010,0000	; 8688		J/STPTR2		; ..
U 2653, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8689		PAGE FAIL TRAP		;TYPE 0
							; 8690	
							; 8691	=0
							; 8692	STPTR2: TL [AR],		;SEPERATE TYPE 1
							; 8693		#/200000,		; AND 3
U 2654, 2656,4553,0300,4374,4007,0321,0000,0020,0000	; 8694		J/STPTR3		; ..
U 2655, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 8695		RETURN [2]		;TYPE 2
							; 8696	
							; 8697	=0
U 2656, 0003,4443,0000,4174,4004,1700,0000,0000,0000	; 8698	STPTR3: RETURN [3]		;TYPE 3
U 2657, 0001,4443,0000,4174,4004,1700,0000,0000,0000	; 8699		RETURN [1]		;TYPE 1
							; 8700	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 240
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8701	;STILL .IF/KLPAGE
							; 8702	;SUBROUTINE TO FETCH A PAGE POINTER OR CST ENTRY
							; 8703	;CALL WITH ADDRESS IN AR
							; 8704	;RETURN 4 WITH WORD IN AR
							; 8705	;
							; 8706	RDPT:	VMA_[AR],		;LOAD THE VMA
							; 8707		START READ,		;START MEM CYCLE
							; 8708		VMA PHYSICAL,		;ABSOLUTE ADDRESS
U 4034, 2660,3443,0300,4174,4007,0370,0200,0024,1016	; 8709		SKIP IRPT		;CHECK FOR INTERRUPTS
							; 8710	=0	MEM READ,		;NO INTERRUPTS
							; 8711		[AR]_MEM,		;PUT THE DATA INTO AR
U 2660, 0004,3771,0003,4365,5004,1700,0200,0000,0002	; 8712		RETURN [4]		;AND RETURN
U 2661, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8713		PAGE FAIL TRAP		;INTERRUPT
							; 8714	
							; 8715	
							; 8716	;SUBROUTINE TO SEE IF WE SHOULD REMEMBER AN EXEC SECTION PTR
							; 8717	;CALL WITH SKIP ON ADR.EQ.0
							; 8718	;RETURNS 2 IF WE SHOULD STORE AND 7 IF WE SHOULD NOT
							; 8719	;
							; 8720	=0
U 2662, 0007,4443,0000,4174,4004,1700,0000,0000,0000	; 8721	SHDREM:	RETURN [7]		;INDIRECT PTR
U 2663, 4035,7441,1303,4174,4007,0700,0000,0000,0000	; 8722		[AR]_.NOT.[FLG]		;FLIP BITS
U 4035, 2664,4553,0300,4374,4007,0321,0000,0002,4000	; 8723		TL [AR], FLG.W/1, FLG.C/1 ;BOTH BITS SET
U 2664, 0007,4443,0000,4174,4004,1700,0000,0000,0000	; 8724	=0	RETURN [7]		;NO--DON'T STORE
U 2665, 0002,4443,0000,4174,4004,1700,0000,0000,0000	; 8725		RETURN [2]		;STORE
							; 8726	
							; 8727	.ENDIF/KLPAGE
							; 8728	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 241
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8729	.IF/KIPAGE
							; 8730	;HERE IN KI10 MODE
							; 8731	;BR CONTAINS PAGE # AND ARX CONTAINS PAGE #/2
							; 8732	
							; 8733	KIFILL: READ [BRX],		;USER REF?
U 4036, 2666,3333,0006,4174,4007,0520,0000,0000,0000	; 8734		SKIP DP0		; ..
							; 8735	=0	[BR]-#, 		;EXEC--LESS THAN 340?
							; 8736		#/340,			; ..
							; 8737		SKIP DP18, 4T,		; ..
U 2666, 2670,1553,0500,4374,4007,0532,4000,0000,0340	; 8738		J/KIF10			;FOLLOW EXEC PATH
							; 8739	KIUPT:	[ARX]_[ARX]+[UBR],	;POINTER TO PAGE MAP ENTRY
							; 8740		LOAD VMA,		;PUT ADDRESS IN VMA
							; 8741		VMA PHYSICAL,		;ABSOLUTE ADDRESS
							; 8742		START READ,		;FETCH UPT WORD
U 2667, 4037,0111,1104,4174,4007,0700,0200,0024,1016	; 8743		J/KIF30			;JOIN COMMON CODE
							; 8744	=0
							; 8745	KIF10:	[BR]-#, 		;EXEC ADDRESS .GE. 340
							; 8746		#/400,			; SEE IF .GT. 400
							; 8747		SKIP DP18, 4T,		; ..
U 2670, 2672,1553,0500,4374,4007,0532,4000,0000,0400	; 8748		J/KIEPT			;LOOK AT KIF20
							; 8749		[ARX]_[ARX]+#, 3T,	;EXEC ADDRESS .LT. 340
							; 8750		#/600,			;IN EBR+600
U 2671, 2672,0551,0404,4374,4007,0701,0000,0000,0600	; 8751		J/KIEPT			;JOIN COMMON CODE
							; 8752	
							; 8753	=0
							; 8754	KIEPT:	[ARX]_[ARX]+[EBR],	;ADD OFFSET TO
							; 8755		LOAD VMA,		; EPT
							; 8756		START READ,		;START FETCH
							; 8757		VMA PHYSICAL,		;ABSOLUTE ADDRESS
U 2672, 4037,0111,1004,4174,4007,0700,0200,0024,1016	; 8758		J/KIF30			;GO GET POINTER
							; 8759		[ARX]_[ARX]+#,		;PER PROCESS PAGE
							; 8760		#/220, 3T,		; IS IN UPT + 400
U 2673, 2667,0551,0404,4374,4007,0701,0000,0000,0220	; 8761		J/KIUPT			;JOIN COMMON CODE
							; 8762	KIF30:	MEM READ,		;WAIT FOR DATA
U 4037, 4040,3771,0004,4365,5007,0700,0200,0000,0002	; 8763		[ARX]_MEM		;PLACE IT IN ARX
							; 8764		TR [BR],		;SEE IF EVEN OR ODD
U 4040, 2674,4553,0500,4374,4007,0331,0000,0000,0001	; 8765		#/1			; ..
							; 8766	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 242
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8767	;STILL .IF/KIPAGE
							; 8768	=0
							; 8769	KIF40:	READ [ARX],		;ODD
							; 8770		SKIP DP18,		;SEE IF VALID
U 2674, 2676,3333,0004,4174,4007,0530,0000,0000,0000	; 8771		J/KIF50			;JOIN COMMON CODE
							; 8772		[ARX]_[ARX] SWAP,	;EVEN--FLIP AROUND
U 2675, 2674,3770,0404,4344,4007,0700,0000,0000,0000	; 8773		J/KIF40			; AND CONTINUE
							; 8774	
							; 8775	.ENDIF/KIPAGE
							; 8776	=0
U 2676, 2712,4553,1300,4374,4007,0321,0000,0001,0000	; 8777	KIF50:	PAGE FAIL TRAP
							; 8778	;AT THIS POINT WE HAVE THE PAGE MAP ENTRY IN RH OF AR
							; 8779		[FLG]_[FLG].AND.NOT.#,	;CLEAR W AND C
U 2677, 4041,5551,1313,4374,4007,0700,0000,0002,4000	; 8780		FLG.W/1, FLG.C/1	; FLAGS
U 4041, 2700,4553,0400,4374,4007,0331,0000,0002,0000	; 8781		TR [ARX], #/020000	;CACHE ENABLED?
							; 8782	=0	[FLG]_[FLG].OR.#,	;SET CACHE BITS
U 2700, 2701,3551,1313,4374,0007,0700,0000,0000,4000	; 8783		FLG.C/1, HOLD RIGHT	; ..
U 2701, 2702,4553,0400,4374,4007,0331,0000,0004,0000	; 8784		TR [ARX], #/040000	;DO NOT CACHE
							; 8785					;SEE IF CACHE BIT SET
							; 8786	=0	[BRX]_[BRX].OR.#,	;COPY BITS TO BRX
							; 8787		#/020000,
U 2702, 2703,3551,0606,4374,0007,0700,0000,0002,0000	; 8788		HOLD RIGHT
							; 8789		TR [ARX],		; ..
U 2703, 2704,4553,0400,4374,4007,0331,0000,0010,0000	; 8790		#/100000
							; 8791	=0	[FLG]_[FLG].OR.#,	;SAVE W
							; 8792		FLG.W/1,		; ..
							; 8793		HOLD RIGHT,		; ..
U 2704, 4042,3551,1313,4374,0007,0700,0000,0002,0000	; 8794		J/KIF90			;ALL DONE
							; 8795		TL [BRX],		;W=0, WRITE REF?
U 2705, 2706,4553,0600,4374,4007,0321,0000,0001,0000	; 8796		WRITE CYCLE/1
							; 8797	=0
							; 8798	KIF80:	[BRX]_[BRX].OR.#,	;WRITE FAILURE
							; 8799		#/100000, HOLD RIGHT,	;INDICATE THAT ACCESS WAS ON
U 2706, 2676,3551,0606,4374,0007,0700,0000,0010,0000	; 8800		J/KIF50			;GO PAGE FAIL
U 2707, 2617,4443,0000,4174,4007,0700,0000,0000,0000	; 8801		J/PFDONE		;ALL DONE
							; 8802	
							; 8803	KIF90:	[BRX]_[BRX].OR.#,	;PAGE IS WRITABLE
							; 8804		#/40000,		;TURN ON IN BRX
U 4042, 2617,3551,0606,4374,4007,0700,0000,0004,0000	; 8805		J/PFDONE		;ALL SET
							; 8806	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 243
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8807	;HERE ON HARD PAGE FAILURES
U 4043, 2710,3333,0005,7174,4007,0700,0400,0000,0213	; 8808	HARD:	WORK[SV.BR]_[BR]	;SAVE BR (CLEANUP MAY NEED IT)
							; 8809	=0	[BR]_VMA,		;BUILD PAGE FAIL WORD
U 2710, 4047,3771,0005,4354,4007,0700,0010,0000,0000	; 8810		CALL [ABORT]		;CLEAR ERROR
							; 8811		[BR]_[BR].AND.#,	;SAVE THE FLAGS
							; 8812		#/401237,		; ..
U 2711, 4044,4551,0505,4374,0007,0700,0000,0040,1237	; 8813		HOLD RIGHT		; ..
							; 8814		[BRX]_[BRX].OR.[BR],	;COMPLETE PAGE FAIL WORD
U 4044, 2676,3111,0506,4174,4007,0700,0000,0000,0000	; 8815		J/KIF50			;GO TRAP
							; 8816	
U 4045, 1160,4443,0000,4174,4007,0370,0000,0000,0000	; 8817	PFPI1:	SKIP IRPT		;TIMER TRAP?
							; 8818	=00
							; 8819		[AR]_WORK[TIME1],	;YES--GET LOW WORD
							; 8820		SPEC/CLRCLK,		;CLEAR CLOCK FLAG
U 1160, 3621,3771,0003,7274,4117,0701,0010,0000,0301	; 8821		CALL [TOCK]		;DO THE UPDATE
U 1161, 2713,4443,0000,4174,4007,0700,0000,0000,0000	; 8822		J/PFT1			;EXTERNAL INTERRUPT
U 1162, 4046,4223,0000,4364,4277,0700,0200,0000,0010	; 8823		ABORT MEM CYCLE		;CLEAR 1MS FLAGS
							; 8824	=
							; 8825	PFPI2:	[AR]_WORK[SV.VMA],	;RESTORE VMA
U 4046, 4023,3771,0003,7274,4007,0701,0000,0000,0210	; 8826		J/PF125
							; 8827	
							; 8828	
U 4047, 0001,4223,0000,4364,4274,1700,0200,0000,0010	; 8829	ABORT:	ABORT MEM CYCLE, RETURN [1]
							; 8830	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 244
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8831	;HERE ON PAGE FAIL TRAP
							; 8832	=0
U 2712, 0104,4751,1217,4374,4007,0700,0000,0000,0100	; 8833	PFT:	HALT [IOPF]		;IO PAGE FAILURE
							; 8834	PFT1:	[AR]_WORK[SV.VMA],
U 2713, 2714,3771,0003,7274,4007,0611,0000,0000,0210	; 8835		SKIP/TRAP CYCLE		;SEE IF TRAP CYCLE
							; 8836	=0	TL [AR], FETCH/1,	;IS THIS AN INSTRUCTION FETCH
U 2714, 2716,4553,0300,4374,4007,0321,0000,0010,0000	; 8837		J/PFT1A			;GO LOOK BELOW
U 2715, 4050,3771,0003,7274,4007,0701,0000,0000,0425	; 8838		[AR]_WORK[TRAPPC]	;RESTORE PC
U 4050, 2720,3333,0003,4174,4467,0700,0000,0000,0004	; 8839		READ [AR], LOAD FLAGS, J/CLDISP
							; 8840	=0
U 2716, 1100,4443,0000,4174,4007,0700,0000,0000,0000	; 8841	PFT1A:	J/CLEANED		;YES--NO PC TO BACK UP
U 2717, 2720,1111,0701,4170,4007,0700,4000,0000,0000	; 8842	FIXPC:	[PC]_[PC]-1, HOLD LEFT	;DATA FAILURE--BACKUP PC
							; 8843	=0
U 2720, 1100,3333,0013,4174,4003,5701,0000,0000,0000	; 8844	CLDISP:	CLEANUP DISP		;GO CLEANUP AFTER PAGE FAIL
							; 8845	=0000
							; 8846	CLEANUP:
							; 8847	CLEANED:			;(0) NORMAL CASE
							; 8848		END STATE, SKIP IRPT,	;NO MORE CLEANUP NEEDED
U 1100, 2722,4221,0013,4170,4007,0370,0000,0000,0000	; 8849		J/PFT2			;HANDLE PAGE FAIL OR INTERRUPT
							; 8850		[AR]_WORK[SV.ARX],	;(1) BLT
U 1101, 3206,3771,0003,7274,4007,0701,0000,0000,0212	; 8851		J/BLT-CLEANUP
							; 8852		[PC]_[PC]+1,		;(2) MAP
U 1102, 4053,0111,0701,4174,4007,0700,0000,0000,0000	; 8853		J/MAPDON
							; 8854		STATE_[EDIT-SRC],	;(3) SRC IN STRING MOVE
U 1103, 3523,3771,0013,4370,4007,0700,0000,0000,0011	; 8855		J/STRPF
							; 8856		STATE_[EDIT-DST],	;(4) DST IN STRING MOVE
U 1104, 3523,3771,0013,4370,4007,0700,0000,0000,0012	; 8857		J/STRPF
							; 8858		STATE_[SRC],		;(5) SRC+DST IN STRING MOVE
U 1105, 2334,3771,0013,4370,4007,0700,0000,0000,0003	; 8859		J/BACKD
							; 8860		STATE_[EDIT-DST],	;(6) FILL IN MOVSRJ
U 1106, 3532,3771,0013,4370,4007,0700,0000,0000,0012	; 8861		J/STRPF4
							; 8862		STATE_[EDIT-SRC],	;(7) DEC TO BIN
U 1107, 3527,3771,0013,4370,4007,0700,0000,0000,0011	; 8863		J/PFDBIN
							; 8864		STATE_[EDIT-SRC],	;(10) SRC+DST IN COMP
U 1110, 3521,3771,0013,4370,4007,0700,0000,0000,0011	; 8865		J/CMSDST
U 1111, 2326,4221,0013,4170,4007,0700,0000,0000,0000	; 8866		END STATE, J/BACKS	;(11) EDIT SRC FAIL
U 1112, 2334,4221,0013,4170,4007,0700,0000,0000,0000	; 8867		END STATE, J/BACKD	;(12) EDIT DST FAIL
							; 8868		STATE_[EDIT-SRC],	;(13) SRC+DST IN EDIT
U 1113, 2334,3771,0013,4370,4007,0700,0000,0000,0011	; 8869		J/BACKD
							; 8870	=
							; 8871	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 245
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8872	=0
							; 8873	PFT2:	[AR]_[UBR]+#,		;PREPARE TO STORE PFW
							; 8874		#/500, 3T,
U 2722, 4051,0551,1103,4374,4007,0701,0000,0000,0500	; 8875		J/PFT10
U 2723, 0770,3551,1313,4374,0007,0700,0000,0001,0000	; 8876	PFT3:	TAKE INTERRUPT		;PROCESS INTERRUPT
							; 8877	PFT10:	VMA_[AR],		;WHERE TO STORE PFW
U 4051, 2724,3443,0300,4174,4007,0700,0200,0021,1016	; 8878		VMA PHYSICAL WRITE
							; 8879	=0	MEM WRITE,		;STORE PFW
							; 8880		MEM_[BRX],
U 2724, 4055,3333,0006,4175,5007,0701,0210,0000,0002	; 8881		CALL [NEXTAR]		;ADVANCE POINTER TO
							; 8882					;PREPARE TO STORE PC
							; 8883	.IF/KLPAGE
							; 8884	.IF/KIPAGE
U 2725, 2726,4553,1000,4374,4007,0321,0000,0040,0000	; 8885		TL [EBR], #/400000	;KL PAGING?
							; 8886	=0
							; 8887	.ENDIF/KIPAGE
U 2726, 2732,4521,1205,4074,4007,0700,0000,0000,0000	; 8888		[BR]_FLAGS,J/EAPF	;YES--DO EXTENDED THING
							; 8889	.ENDIF/KLPAGE
							; 8890	
							; 8891	.IF/KIPAGE
U 2727, 4052,3741,0105,4074,4007,0700,0000,0000,0000	; 8892		[BR]_PC WITH FLAGS	;GET OLD PC
							; 8893		MEM WRITE,		;STORE OLD PC
							; 8894		MEM_[BR],
U 4052, 4054,3333,0005,4175,5007,0701,0200,0000,0002	; 8895		J/EAPF1
							; 8896	.ENDIF/KIPAGE
							; 8897	
							; 8898	MAPDON:	END STATE,		;CLEAR MAP BIT
U 4053, 2730,4221,0013,4170,4007,0370,0000,0000,0000	; 8899		SKIP IRPT		;ANY INTERRUPT?
							; 8900	=0	[AR]_[BRX],		;RETURN PAGE FAIL WORD
U 2730, 1500,3441,0603,4174,4003,7700,0200,0003,0001	; 8901		EXIT
U 2731, 2723,1111,0701,4174,4007,0700,4000,0000,0000	; 8902		[PC]_[PC]-1, J/PFT3	;INTERRUPTED OUT OF MAP
							; 8903					; RETRY INSTRUCTION
							; 8904	; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 246
; PAGEF.MIC[1,2]	11:16 17-APR-2015			PAGE FAIL REFIL LOGIC					

							; 8905	
							; 8906	.IF/KLPAGE
							; 8907	=0
							; 8908	EAPF:	MEM WRITE, MEM_[BR],	;STORE FLAGS
U 2732, 4055,3333,0005,4175,5007,0701,0210,0000,0002	; 8909		CALL [NEXTAR]		;STORE PC WORD
U 2733, 4054,3333,0001,4175,5007,0701,0200,0000,0002	; 8910		MEM WRITE, MEM_[PC]	; ..
							; 8911	.ENDIF/KLPAGE
							; 8912	
							; 8913	EAPF1:	[AR]_[AR]+1,
							; 8914		VMA PHYSICAL READ,
U 4054, 2762,0111,0703,4174,4007,0700,0200,0024,1016	; 8915		J/GOEXEC
							; 8916	
U 4055, 0001,0111,0703,4170,4004,1700,0200,0023,1016	; 8917	NEXTAR:	NEXT [AR] PHYSICAL WRITE, RETURN [1]
							; 8918	


; Number of microwords used: 
;	D words= 512
;	U words= 2058, Highest= 4095

	END
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 247
; 								Cross Reference Listing					

(U) A				666 #
	AR			670 #	2424	2462	2492	2493	2556	2604	2612	2751	2753	2756	2759
				2762	2765	2849	2859	2874	2891	2901	2911	2921	2952	2962	2972
				3007	3019	3026	3030	3040	3041	3043	3045	3046	3054	3077	3078
				3304	3309	3311	3323	3326	3329	3334	3335	3405	3422	3424	3489
				3492	3560	3561	3567	3587	3614	3629	3665	3676	3688	3742	3765
				3770	3805	3849	3853	3862	3864	4025	4030	4060	4095	4109	4125
				4136	4139	4142	4156	4183	4184	4189	4206	4222	4242	4354	4363
				4368	4378	4384	4403	4407	4425	4453	4457	4459	4460	4479	4511
				4514	4517	4531	4556	4573	4574	4579	4584	4592	4594	4596	4667
				4677	4679	4684	4685	4730	4735	4745	4749	4787	4791	4795	4799
				4975	4988	5073	5076	5088	5091	5097	5103	5138	5213	5216	5318
				5324	5328	5329	5359	5365	5384	5390	5391	5392	5393	5402	5407
				5427	5428	5440	5442	5451	5452	5472	5477	5478	5484	5519	5523
				5525	5528	5531	5535	5537	5539	5541	5542	5543	5544	5550	5552
				5553	5562	5567	5583	5609	5617	5622	5624	5668	5681	5700	5709
				5713	5728	5742	5744	5746	5752	5779	5786	5789	5801	5804	5812
				5814	5818	5823	5825	5841	5846	5849	5871	5874	5875	5879	5997
				6001	6005	6012	6023	6032	6047	6067	6071	6084	6087	6113	6197
				6204	6221	6243	6257	6284	6295	6296	6297	6310	6344	6374	6385
				6423	6438	6466	6471	6500	6501	6502	6503	6505	6506	6509	6514
				6563	6584	6591	6592	6618	6656	6668	6669	6676	6696	6699	6702
				6706	6707	6709	6713	6715	6769	6770	6775	6776	6783	6786	6790
				6859	6881	6887	6906	6924	6928	6931	6932	6933	6934	6956	6981
				6982	6986	6992	6993	6997	7067	7073	7096	7098	7100	7102	7105
				7107	7109	7151	7158	7169	7173	7180	7184	7208	7214	7216	7221
				7229	7256	7319	7400	7402	7404	7406	7408	7410	7412	7414	7416
				7438	7444	7506	7516	7522	7525	7526	7543	7551	7601	7612	7625
				7627	7653	7658	7685	7688	7716	7734	7735	7794	7891	7899	7930
				8260	8270	8385	8394	8397	8399	8401	8405	8408	8419	8425	8430
				8473	8476	8481	8488	8496	8503	8525	8543	8547	8585	8588	8603
				8604	8625	8651	8654	8657	8675	8681	8686	8692	8706	8723	8836
				8877
	ARX			671 #	2524	2806	2807	3745	3747	3760	3789	4122	4134	4143	4144
				4161	4164	4166	4188	4208	4224	4244	4247	4267	4396	4424	4476
				4502	4503	4582	4674	4675	4683	4752	4942	4949	4950	4978	4981
				5002	5132	5154	5326	5364	5396	5582	5603	5606	5666	5683	5705
				5725	5745	5750	5796	5835	5842	6085	6126	6133	6167	6201	6251
				6260	6270	6279	6302	6303	6311	6343	6347	6424	6461	6469	6473
				6475	6792	6795	6841	6909	6983	7097	7101	7103	7106	7108	7137
				7139	7350	7363	7367	7557	7740	7742	7800	8027	8372	8380	8428
				8442	8465	8579	8611	8613	8677	8749	8759	8772	8781	8784	8789
	BR			672 #	2223	2420	2455	2457	2461	2942	3073	3106	3107	3110	3111
				3112	3113	3128	3131	3134	3137	3141	3144	3146	3178	3179	3182
				3183	3464	3467	3470	3473	3476	3479	3482	3485	3810	3815	3843
				3870	3879	3880	4027	4032	4130	4262	4427	4429	4437	4441	4504
				4507	4581	4585	4586	4587	4590	4595	4626	4768	4770	4829	4830
				4831	4832	4833	4840	4849	4853	4862	4923	4924	4925	4926	4927
				4948	4991	4997	5100	5140	5142	5152	5157	5241	5325	5332	5333
				5337	5338	5394	5397	5431	5482	5565	5589	5591	5601	5615	5694
				5712	5715	5951	5963	5964	5966	5967	5994	6003	6048	6053	6078
				6081	6172	6237	6240	6241	6254	6262	6268	6391	6401	6412	6421
				6425	6443	6496	6511	6549	6560	6627	6883	6884	6925	6926	6966
				6974	6985	6989	7066	7069	7094	7128	7130	7133	7195	7206	7220
				7222	7247	7248	7318	7329	7336	7405	7407	7409	7415	7417	7453
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 248
; 								Cross Reference Listing					

				7466	7563	7586	7587	7588	7629	7631	7659	7663	7665	7669	7671
				7695	7701	7792	8268	8343	8346	8359	8485	8609	8735	8745	8764
				8811	8814
	BRX			673 #	4158	4186	4192	4263	4286	4306	4310	4314	4318	4324	4328
				4332	4336	4413	4466	4506	4618	4621	4632	5079	5131	5160	5168
				5175	5199	5284	5287	5357	5358	5360	5399	5404	5594	5611	5677
				5691	5692	5734	5955	6054	6124	6135	6136	6160	6209	6217	6298
				6327	6340	6349	6354	6362	6364	6373	6379	6384	6396	6435	6437
				6455	6464	6491	6493	6495	6526	6529	6545	6557	6559	6639	6641
				6644	6710	6717	6811	6815	6819	6823	6827	6831	6847	7120	7264
				7265	7266	7365	7515	7570	7571	7634	7717	8264	8328	8329	8332
				8338	8340	8514	8517	8520	8542	8550	8592	8596	8598	8600	8615
				8619	8786	8795	8798	8803	8900
	EBR			675 #	7013	7230	7231	7232	7245	7518	7561	8350	8383	8754	8885
	FLG			678 #	3656	5546	5647	5648	5655	5782	5785	5788	5791	5851	5858
				5859	6635	8325	8404	8424	8492	8502	8516	8522	8554	8575	8595
				8614	8616	8659	8684	8689	8713	8722	8777	8779	8782	8791	8876
	HR			669 #	2324	2330	2336	2342	2351	2355	2364	2369	2470	2818	2823
				3564	3573	3576	3578	3579	3580	3599	3603	3613	3618	3621	3641
				3662	3675	3957	3959	3961	3963	3965	3967	3969	3971	3977	3997
				4075	5953	6946	7023	7029	7038	7039	7040	7044	7045	7046	7047
				7052	7053	7054	7057	7058	7059	7060	7061	7062	7063	7064	7285
				7308	7403	7719	7733	7862	7871	7873	7875	7877	7879	7881
	MAG			667 #	2459	4168	4171	4190	4193	4194	4207	4213	4215	4249	4251
				4253	4431	4449	4471	4475	4478	4519	4521	4522	4649	4654	4659
				4665	4666	5261	5262	5585	5676	5731	5757	5792	5827	5831	5833
	MASK			677 #	2185	2186	2187	2190	2193	2226	2237	2273	2277	2280	2283
				2292	2295	2298	2301	2552	2775	2796	3003	3051	3615	3663	3677
				3698	3981	3998	4021	4024	4069	4129	4265	4299	4433	4444	4472
				4597	4809	4929	4940	5246	5266	5267	5268	5282	5487	5547	5620
				5670	5760	5829	5918	5920	5922	5924	5926	5928	5930	5932	5934
				6169	6171	6193	6308	6630	7317	7360	7361	7362	7496	7497	7498
				7499	7500	7501	7502	7508	7527	7537	7555	7569	7647	7650	7686
				7697	7703	7720	7776	7929	8282	8304	8306	8320	8833	8888
	ONE			674 #	2215	2219	2264	2266	2311	2398	2449	2452	2982	3373	3439
				3455	3522	3536	3562	3571	3574	3649	3667	3670	4017	4064	4080
				4359	4774	5071	5139	5180	5182	5187	5204	5205	5289	5290	5474
				5486	5561	5710	5868	5989	6030	6063	6069	6090	6108	6118	6137
				6138	6173	6174	6216	6280	6285	6348	6360	6367	6387	6394	6399
				6408	6418	6422	6426	6427	6463	6477	6488	6540	6564	6658	6680
				6733	6856	6857	6863	6885	6927	6969	7324	7347	7377	7429	7713
				7790	7915	8001	8008	8011	8014	8017	8020	8842	8852	8902	8913
				8917
	PC			668 #	2263	2267	2285	2378	2440	2465	3361	3488	3493	3724	3841
				3847	3867	4053	4254	4256	4731	4740	7002	7420	7539	7691	7926
				8892
	PI			679 #	3627	3628	3642	7048	7049	7397	7411	7413	7418	7428	7430
				7489	7490	7491	7492	7493	7494	7495	7504
	T0			681 #	4234	4238	4474	4485	4492	4495	4497	4498	5602	5610	5636
				5638	5639	5640	5643	5651	5654	5656	5696	5762	5770	5771	6392
				6459	7431	7567
	T1			682 #	4451	4591	5257	5259	5263	5278	5281	5626	5711	5714	5733
				5743
	UBR			676 #	3983	4023	7005	7165	7199	7254	7255	7260	7261	8375	8739
				8873
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 249
; 								Cross Reference Listing					

	XWD1			680 #	3544	3714	7553
(D) A				1350 #
	DBLAC			1354 #	2810
	DFP			1360 #	5572	5573	5661	5722
	DREAD			1353 #	2801	2802	4117	4118	4201	4419
	DSHIFT			1356 #	2992	2993
	FP			1358 #	5298	5299	5300	5301	5303	5304	5306	5307	5308	5309	5311
				5312	5343	5344	5345	5347	5349	5350	5372	5373	5374	5376	5378
				5379	5457	5458
	FPI			1357 #	5302	5310	5348	5377
	IOT			1361 #	7034	7035	7271	7593	7594	7595	7596	7604	7605	7606	7607
				7618	7619	7620	7621	7886	7887	8256
	RD-PF			1359 #	2582	2587	2592	2597	2635	2640	2645	2650	2655	2660	2665
				2670	2677	2682	2687	2692	2697	2702	2707	2712	2842	2852	2862
				2867	2884	2894	2904	2914	2934	2945	2955	2965	4088	4102	4150
				4175	4342	4347
	READ			1351 #	2585	2590	2595	2600	2619	2637	2638	2642	2643	2648	2653
				2658	2663	2668	2673	2679	2680	2684	2685	2690	2695	2700	2705
				2710	2715	2844	2845	2854	2855	2864	2865	2869	2870	2877	2886
				2887	2896	2897	2906	2907	2916	2917	2936	2937	2947	2948	2957
				2958	2967	2968	3221	3222	3223	3224	3225	3226	3237	3238	3239
				3240	3241	3242	3243	3244	3255	3256	3257	3258	3259	3260	3261
				3262	3272	3273	3274	3275	3276	3277	3278	3279	3394	3395	3396
				3397	3398	3399	3400	3401	3411	3412	3413	3414	3415	3416	3417
				3418	3428	3429	3430	3431	3432	3433	3434	3435	3444	3445	3446
				3447	3448	3449	3450	3451	3682	4090	4091	4104	4105	4152	4153
				4177	4178	4344	4345	4349	4350	4720	4721	4722	4723	4724	5422
	SHIFT			1355 #	2987	2988	2989
	WRITE			1352 #	2584	2589	2594	2599	2647	2652	2657	2662	2667	2672	2689
				2694	2699	2704	2709	2714	2811	2879	2880
(U) ACALU			1248 #
	AC+N			1250 #	2208	2209	2216	2406	2418	2524	2807	2816	3057	3078	3122
				3152	4122	4134	4213	4215	4217	4225	4227	4234	4236	4248	4249
				4250	4251	4252	4253	4365	4449	4471	4475	4478	4492	4493	4495
				4498	4517	4519	4521	4522	4648	4649	4652	4653	4654	4657	4658
				4659	4665	4666	5585	5676	5729	5731	5737	5796	5804	5842	5849
				5993	6001	6011	6014	6044	6047	6060	6067	6074	6084	6122	6132
				6152	6167	6184	6199	6201	6227	6230	6232	6239	6240	6241	6243
				6249	6251	6254	6260	6262	6290	6292	6293	6297	6304	6305	6306
				6310	6311	6318	6320	6325	6331	6347	6358	6370	6379	6385	6396
				6399	6401	6405	6418	6424	6425	6548	6579	6584	6589	6626	6628
				6732	6733	6845	6852	6859	6878	6880	6887	6907	6928	6964	6966
				6972	6974	6978	6981	6986
	B			1249 #
(D) ACDISP			1381 #	3551	7034	7035	7271
(U) ACN				1251 #	2406	2418	2524	2807	2816	3057	3078	3122	3152	4122	4134
				4213	4215	4217	4225	4227	4234	4236	4248	4249	4250	4251	4252
				4253	4365	4449	4471	4475	4478	4492	4493	4495	4498	4517	4519
				4521	4522	4648	4649	4652	4653	4654	4657	4658	4659	4665	4666
				5585	5676	5729	5731	5737	5796	5804	5842	5849	6331	6347	6358
				6405	6424
	BIN0			1258 #	2208	6227	6249	6254	6262	6293	6304	6305	6306	6310	6318
	BIN1			1259 #	2209	2216	6199	6201	6230	6232	6239	6240	6241	6243	6251
				6260	6290	6292	6297	6311	6320
	DLEN			1255 #	5993	6001	6014	6044	6047	6074	6084	6122	6132	6167	6325
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 250
; 								Cross Reference Listing					

				6370	6379	6385	6396	6399	6401	6418	6425	6732	6733	6845	6859
				6878	6978	6981	6986
	DSTP			1256 #	6011	6184	6579	6584	6628	6852	6907	6928	6972	6974
	MARK			1257 #	6548	6626
	SRCLEN			1253 #
	SRCP			1254 #	6060	6067	6152	6589	6880	6887	6964	6966
(U) AD				563 #	2190	2193	2226	2237	2273	2277	2280	2283	2292	2295	2298
				2301	2355	2552	2773	2775	2794	2796	3615	3698	3981	4021	4069
				4433	4444	5259	5918	5920	5922	5924	5926	5928	5930	5932	5934
				5964	6193	6308	6630	7317	7360	7361	7362	7496	7497	7498	7499
				7500	7501	7502	7508	7537	7555	7569	7647	7650	7686	7697	7703
				7720	7776	7929	8282	8304	8306	8320	8833
	A			592 #	2185	2187	2263	2267	2285	2330	2342	2369	2378	2420	2461
				2462	2465	2524	2556	2807	2823	3007	3019	3026	3030	3040	3041
				3043	3045	3046	3054	3073	3078	3106	3107	3110	3111	3112	3113
				3128	3131	3134	3137	3141	3144	3178	3179	3182	3183	3335	3361
				3424	3464	3476	3488	3489	3492	3493	3560	3561	3567	3587	3603
				3614	3629	3665	3676	3688	3742	3745	3747	3765	3770	3843	3849
				3862	3867	3880	4156	4158	4161	4183	4184	4186	4188	4206	4208
				4222	4224	4242	4244	4256	4262	4263	4265	4286	4299	4354	4363
				4378	4384	4413	4425	4427	4429	4441	4453	4457	4472	4476	4479
				4492	4498	4502	4511	4531	4579	4584	4585	4586	4591	4592	4594
				4596	4667	4731	4740	4745	4752	4768	4791	4799	4853	4929	4942
				4978	4997	5002	5076	5079	5097	5132	5152	5160	5168	5216	5241
				5246	5261	5262	5266	5267	5268	5281	5282	5284	5324	5325	5326
				5337	5359	5360	5364	5365	5384	5392	5394	5399	5402	5407	5440
				5442	5472	5474	5477	5478	5484	5519	5523	5525	5531	5539	5541
				5542	5543	5561	5562	5567	5594	5601	5602	5606	5609	5610	5617
				5622	5624	5636	5638	5639	5640	5643	5651	5654	5656	5666	5668
				5670	5677	5681	5683	5694	5700	5705	5709	5710	5713	5725	5728
				5750	5760	5762	5770	5771	5779	5786	5789	5801	5804	5818	5823
				5825	5846	5849	5871	5879	5967	6012	6032	6047	6067	6078	6084
				6113	6124	6160	6167	6201	6240	6260	6262	6297	6310	6311	6347
				6373	6379	6384	6385	6392	6396	6401	6423	6424	6425	6459	6493
				6502	6505	6509	6511	6549	6559	6584	6591	6627	6644	6669	6699
				6706	6717	6769	6786	6792	6883	6887	6906	6925	6928	6932	6934
				6966	6974	6981	6982	6986	6993	7048	7049	7151	7195	7214	7216
				7229	7245	7247	7255	7256	7261	7264	7266	7365	7397	7420	7438
				7444	7515	7522	7543	7551	7570	7588	7612	7625	7627	7634	7659
				7663	7669	7691	7695	7701	7735	7792	7794	7800	7891	7899	7926
				8027	8270	8340	8343	8359	8385	8405	8408	8428	8442	8579	8585
				8603	8609	8625	8706	8877	8900
	A+B			565 #	2215	2219	2264	2266	2311	2398	2449	2452	2818	3146	3373
				3439	3649	3667	3670	3810	3815	3983	4017	4023	4064	4080	4234
				4238	4267	4323	4327	4407	4503	4504	4507	4517	4590	4595	4621
				4625	4631	4774	5180	5182	5187	5204	5205	5289	5290	5338	5482
				5486	5565	5615	5696	5989	6053	6085	6090	6108	6137	6138	6243
				6257	6268	6270	6280	6348	6360	6367	6387	6408	6422	6477	6488
				6496	6540	6564	6658	6680	6707	6733	6885	6909	6927	6969	6989
				7005	7013	7318	7324	7347	7377	7518	7553	7563	7571	7790	7915
				8001	8008	8011	8014	8017	8020	8372	8380	8465	8739	8754	8852
				8913	8917
	A+Q			564 #	4474	4485	4506	5139	5603	5611	5712	5715	5868
	A-.25			576 #
	A-B-.25			581 #	4403	4459	4460	5138	5157	5175	5199	5287	5396	5404	5752
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 251
; 								Cross Reference Listing					

				6001	6136	6172	6391
	A-D-.25			577 #	6221	6461	6466	6514	8735	8745
	A-Q-.25			580 #
	A.AND.B			597 #	4192	4207	4424	4495	4948	5547	5796	5829	5831	5842	6023
				6169	7067	7073	7430	7586	8677
	A.AND.Q			596 #	4190	4431	4475	4519	4521	4597	4649	4654	4659	4665	4666
				4862	4940	4949	5792	5827
	A.EQV.B			624 #
	A.EQV.Q			623 #	4168	4171	4193	4194	4249	4251	4253	4522
	A.OR.B			589 #	2942	4130	4950	5103	5955	6054	6087	6126	6284	6715	7097
				7101	7108	7139	7184	7206	7208	7409	7415	7557	7653	7688	8600
				8814
	A.OR.Q			588 #	5257	5278	5626
	A.XOR.B			616 #	5833	7363
	A.XOR.Q			615 #
	B			591 #	2195	2203	2205	2206	2209	2211	2218	2220	2411	2431	2530
				2562	2568	2573	2576	2607	2626	2771	2778	2785	2792	2822	3103
				3119	3175	3320	3364	3367	3370	3376	3379	3382	3441	3595	3643
				3654	3694	3730	3736	3775	3781	3852	3987	3991	4001	4005	4007
				4013	4035	4041	4052	4056	4072	4079	4160	4305	4309	4331	4335
				4366	4372	4386	4391	4393	4398	4465	4467	4484	4500	4509	4570
				4577	4598	4728	4737	4741	4756	4759	4775	4856	4922	4930	4938
				4987	5000	5020	5052	5059	5323	5327	5410	5412	5444	5448	5481
				5521	5540	5608	5707	5716	5765	5783	5821	5957	5960	5973	5975
				5976	6006	6018	6052	6068	6094	6095	6096	6111	6153	6156	6158
				6162	6175	6186	6194	6202	6333	6335	6378	6397	6410	6414	6416
				6465	6472	6498	6512	6517	6539	6543	6595	6615	6629	6681	6689
				6763	6784	6806	6838	6888	6890	6912	6952	7003	7110	7112	7113
				7115	7118	7122	7223	7224	7290	7294	7298	7302	7306	7321	7332
				7337	7353	7356	7372	7376	7378	7386	7387	7439	7451	7457	7464
				7689	7731	7754	7760	7762	7796	7798	7907	7914	7979	7988	7994
				7998	7999	8000	8002	8003	8004	8006	8007	8009	8010	8012	8013
				8015	8016	8018	8019	8021	8022	8024	8266	8287	8288	8290	8291
				8298	8308	8310	8312	8314	8318	8319	8354	8453	8460	8462	8483
				8621	8679	8733	8769	8808	8839	8844	8880	8894	8908	8910
	B-.25			575 #
	B-A-.25			573 #	3455	3562	3571	3574	4313	4317	4587	4618	6048	6069	6173
				6174	6285	6374	6426	6463	6856	6985	7329	7453	7466	7713	8842
				8902
	D			595 #	2184	2188	2213	2214	2216	2254	2304	2374	2388	2392	2397
				2401	2405	2406	2418	2419	2424	2429	2440	2446	2604	2623	2724
				2726	2751	2753	2756	2757	2759	2762	2763	2765	2780	2782	2787
				2789	2816	3000	3017	3023	3035	3038	3076	3122	3125	3304	3309
				3422	3467	3470	3473	3479	3482	3485	3508	3584	3591	3608	3623
				3628	3648	3652	3713	3724	3752	3758	3785	3794	3805	3807	3841
				3847	3864	3865	3878	3879	3883	3997	4040	4053	4142	4157	4166
				4185	4189	4227	4232	4247	4250	4252	4254	4355	4364	4365	4447
				4576	4730	4735	4749	4751	4755	4770	4803	4829	4830	4831	4832
				4833	4849	4923	4924	4925	4926	4927	4975	4984	4991	5005	5007
				5011	5015	5017	5021	5050	5055	5078	5091	5093	5131	5140	5144
				5151	5195	5213	5214	5239	5244	5321	5354	5386	5450	5528	5544
				5586	5596	5688	5739	5874	5950	5969	5978	5993	5996	6010	6011
				6014	6036	6039	6044	6060	6061	6071	6081	6098	6099	6100	6101
				6109	6115	6123	6132	6134	6152	6154	6161	6165	6178	6180	6184
				6196	6199	6208	6227	6230	6232	6239	6249	6290	6292	6293	6298
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 252
; 								Cross Reference Listing					

				6325	6330	6331	6332	6344	6353	6358	6370	6376	6386	6389	6390
				6405	6417	6419	6420	6438	6441	6490	6495	6500	6501	6541	6548
				6563	6579	6589	6598	6602	6617	6626	6628	6632	6653	6660	6662
				6693	6709	6730	6732	6770	6795	6845	6850	6852	6859	6861	6878
				6880	6881	6884	6907	6924	6926	6936	6951	6964	6968	6972	6978
				6997	7002	7021	7041	7042	7079	7081	7093	7104	7127	7128	7136
				7154	7219	7276	7278	7280	7282	7284	7289	7293	7297	7301	7305
				7314	7319	7323	7328	7334	7335	7346	7366	7370	7385	7391	7405
				7418	7428	7447	7449	7460	7462	7486	7512	7523	7539	7541	7560
				7565	7583	7615	7656	7723	7726	7728	7736	7750	7781	7784	7786
				7895	7902	7934	7981	7986	7990	7993	8005	8023	8025	8026	8028
				8263	8267	8269	8289	8295	8300	8367	8370	8389	8437	8454	8457
				8471	8481	8535	8537	8566	8582	8622	8623	8624	8630	8650	8711
				8763	8772	8809	8819	8825	8834	8838	8850	8854	8856	8858	8860
				8862	8864	8868	8892
	D+A			569 #	2324	2336	2351	2364	3522	3544	3599	3714	3760	3789	3853
				3870	4095	4122	4125	4787	4795	5073	5142	5154	5963	5966	6030
				6063	6118	6216	6241	6251	6254	6394	6412	6455	6464	6471	6473
				6592	6668	6775	6783	6857	6863	6931	6933	7367	7516	7561	7734
				7740	7742	8375	8383	8397	8399	8476	8651	8749	8759	8873
	D+Q			570 #	5023	5031	5062	5081
	D-.25			587 #
	D-A-.25			585 #	3405	3536	4109	4134	4136	4139	5088	6399	6418
	D-Q-.25			586 #
	D.AND.A			604 #	2457	2459	2470	2492	2806	2849	2972	3003	3051	3311	3334
				3564	3573	3576	3578	3579	3580	3613	3618	3621	3627	3641	3642
				3662	3663	3675	3677	3957	3959	3961	3963	3965	3967	3969	3971
				3977	3998	4024	4025	4030	4075	4143	4213	4215	4396	4449	4471
				4478	4674	4809	4981	4988	5100	5263	5328	5332	5357	5390	5427
				5431	5451	5546	5585	5676	5711	5714	5731	5782	5785	5788	5791
				5851	5951	5953	5994	5997	6133	6135	6171	6197	6204	6217	6237
				6279	6295	6302	6327	6343	6362	6421	6435	6437	6469	6475	6491
				6503	6506	6526	6529	6545	6560	6676	6710	6713	6776	6790	6946
				6956	7023	7029	7038	7039	7040	7044	7045	7046	7047	7052	7053
				7054	7057	7058	7059	7060	7061	7062	7063	7064	7096	7098	7100
				7102	7105	7107	7109	7130	7133	7158	7165	7169	7173	7180	7199
				7220	7221	7230	7248	7254	7260	7265	7285	7308	7350	7400	7402
				7403	7404	7406	7408	7410	7412	7414	7416	7527	7567	7601	7658
				7665	7671	7685	7717	7719	7733	7862	7871	7873	7875	7877	7879
				7881	8264	8268	8328	8332	8350	8394	8401	8404	8419	8424	8473
				8488	8492	8496	8502	8516	8520	8522	8542	8547	8575	8588	8595
				8598	8614	8616	8654	8657	8659	8681	8684	8686	8689	8692	8713
				8723	8764	8777	8781	8784	8789	8795	8811	8836	8885	8888
	D.AND.Q			605 #	3148	4549	5249	5255	5269	5275	5362	5671
	D.EQV.A			628 #	2921
	D.EQV.Q			629 #
	D.OR.A			593 #	2186	2455	2493	2901	3329	4027	4032	4144	4497	4582	5329
				5333	5358	5391	5452	5591	5647	5648	5655	5692	5744	5858	6209
				6296	6340	6349	6354	6364	6635	6639	6641	6702	6815	6819	6823
				6831	6847	6983	6992	7222	7231	7336	7411	7489	7490	7491	7492
				7493	7494	7495	7629	7930	8260	8325	8329	8430	8514	8517	8525
				8543	8550	8592	8596	8613	8615	8619	8675	8782	8786	8791	8798
				8803	8876
	D.OR.Q			594 #	3150	4434
	D.XOR.A			620 #	2223	2891	3326	4451	7525	7526	8338
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 253
; 								Cross Reference Listing					

	D.XOR.Q			621 #
	Q			590 #	3152	4162	4170	4217	4225	4225	4236	4248	4390	4445	4462
				4468	4473	4477	4483	4491	5010	5172	5198	5286	5409	5414	5485
				5527	5551	5645	5652	5672	5684	5695	5754	5756	5800	5845	6142
				6181	6583
	Q-.25			574 #
	Q-A-.25			572 #	4466	5071
	Q-D-.25			578 #	5014
	ZERO			601 #	2196	2196	2198	2201	2208	2210	2212	2229	2251	2435	2839
				3016	3057	3077	3306	3644	4008	4261	4287	4357	4493	4571	4838
				4851	4857	4858	4861	4933	4934	4937	4993	5136	5178	5202	5288
				5335	5406	5417	5429	5433	5435	5436	5449	5462	5554	5727	5755
				5794	5810	5838	6019	6021	6055	6074	6122	6127	6139	6150	6179
				6300	6318	6320	6338	6372	6428	6432	6436	6439	6494	6618	6656
				6696	6766	6841	7066	7069	7137	7191	7203	7249	7326	7401	7446
				7471	7472	7504	7507	7514	7528	7743	7788	7909	7912	7982	8324
				8346	8425	8485	8503	8591	8611	8653	8823	8829	8848	8866	8867
				8898
	-A-.25			584 #	2612	2982	4359	4437	4514	4556	4574	4581	4675	4679	4683
				4685	5318	5393	5397	5428	5537	5553	5582	5583	5734	5745	5746
				5814	5835	5841	6303	6427	7429
	-B-.25			583 #	5735
	-D-.25			579 #	4488	4648	4653	4658	4663	6034	6306	6977	6991
	-Q-.25			582 #	4436	4487	4513	4554	4555	4572	5415	5520	5522	5524	5526
				5809
	.NOT.A			627 #	2874	2911	2952	2962	3323	4129	4368	4573	4677	4684	5487
				5535	5550	5552	5733	5743	5812	6003	6005	6557	7431	7506	7716
				8722
	.NOT.A.AND.B		608 #	4164	5620	7103	7106	7407	7417	7587
	.NOT.A.AND.Q		607 #	5757
	.NOT.B			626 #	5840	6212
	.NOT.D			630 #	2931	2941	4652	4657	4662	6051	6079	6083	6219	6223	6305
				6995
	.NOT.D.AND.A		612 #	2859	3656	4060	5589	5691	5742	5859	6443	6811	6827	7094
				7120	7232	7413	7631	8554	8604	8779
	.NOT.D.AND.Q		613 #
	.NOT.Q			625 #	4947	5808	6022
	0+A			568 #	5875
	0+B			567 #
	0+D			571 #
	0+Q			566 #	5621	5768
(U) AD PARITY OK		740 #	2216	2392	2405	2406	2623	2724	2726	2757	2763	2816	3000
				3003	3017	3051	3508	3752	3785	3807	3865	3878	4185	4227	4364
				4755	5151	5239	5321	5354	5386	5450	5596	5993	5996	6011	6014
				6044	6060	6132	6134	6152	6184	6196	6199	6227	6230	6232	6239
				6249	6290	6292	6293	6325	6330	6331	6332	6353	6358	6370	6405
				6490	6548	6589	6626	6628	6732	6845	6852	6878	6880	6907	6964
				6972	6978	7615	7902	8301
(U) ADFLGS			1144 #	2613	3439	3455	3522	3536	4096	4110	4127	4137	4140	4267
				4678	4680
(U) AREAD			1178 #	2356
(U) B				686 #
	AR			690 #	2193	2195	2210	2273	2277	2280	2292	2295	2298	2355	2388
				2392	2397	2405	2411	2424	2429	2431	2440	2449	2449	2452	2452
				2461	2462	2492	2493	2530	2556	2562	2568	2573	2576	2604	2607
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 254
; 								Cross Reference Listing					

				2612	2724	2726	2751	2753	2756	2757	2759	2762	2763	2765	2771
				2773	2775	2778	2780	2782	2785	2787	2789	2792	2794	2796	2839
				2849	2859	2874	2891	2901	2911	2921	2931	2942	2942	2952	2962
				2972	2982	3000	3003	3007	3017	3019	3023	3026	3030	3035	3038
				3040	3041	3043	3045	3046	3076	3077	3078	3103	3119	3175	3304
				3309	3323	3326	3329	3334	3335	3364	3367	3370	3376	3379	3382
				3405	3422	3424	3439	3439	3441	3455	3649	3649	3667	3670	3670
				3677	3805	3810	3815	3865	3997	3998	4005	4024	4040	4041	4053
				4056	4060	4069	4072	4080	4095	4109	4125	4130	4130	4136	4139
				4142	4162	4168	4170	4171	4188	4189	4206	4254	4357	4359	4364
				4366	4391	4413	4447	4453	4457	4500	4504	4504	4507	4507	4511
				4514	4517	4531	4556	4570	4573	4574	4579	4584	4587	4590	4592
				4594	4595	4595	4596	4626	4662	4663	4667	4677	4679	4684	4685
				4728	4737	4741	4745	4756	4759	4768	4770	4774	4774	4775	4803
				4841	4856	4858	4861	4862	4922	4923	4924	4925	4926	4927	4930
				4938	4947	4948	4948	4950	4950	5005	5007	5017	5020	5021	5050
				5059	5073	5083	5088	5091	5093	5097	5175	5199	5213	5214	5216
				5287	5318	5325	5327	5328	5329	5338	5338	5364	5365	5386	5390
				5391	5402	5407	5409	5410	5412	5414	5415	5440	5442	5444	5448
				5450	5451	5452	5472	5477	5478	5481	5482	5482	5484	5486	5486
				5519	5521	5523	5525	5528	5531	5535	5537	5539	5540	5541	5542
				5543	5544	5547	5547	5550	5552	5553	5562	5565	5565	5567	5583
				5610	5615	5615	5617	5622	5624	5668	5705	5709	5713	5716	5739
				5742	5744	5746	5770	5771	5779	5783	5786	5789	5801	5804	5812
				5814	5818	5821	5823	5825	5840	5846	5849	5871	5874	5875	5879
				5918	5920	5922	5924	5926	5928	5930	5932	5934	5960	5989	5989
				5996	6003	6005	6006	6021	6022	6030	6034	6047	6048	6048	6051
				6053	6053	6054	6054	6060	6067	6068	6078	6079	6081	6083	6084
				6085	6085	6090	6090	6098	6137	6137	6138	6139	6152	6158	6165
				6169	6169	6172	6172	6175	6179	6184	6186	6193	6194	6196	6204
				6212	6216	6219	6223	6292	6295	6296	6297	6305	6306	6310	6330
				6332	6335	6344	6353	6370	6384	6385	6386	6387	6387	6392	6410
				6412	6414	6419	6423	6436	6438	6439	6441	6463	6466	6471	6477
				6477	6488	6500	6501	6502	6503	6505	6506	6539	6559	6563	6564
				6564	6584	6589	6591	6592	6595	6617	6618	6630	6632	6653	6656
				6658	6658	6660	6668	6676	6680	6680	6681	6693	6696	6699	6702
				6706	6709	6713	6730	6732	6733	6763	6769	6770	6775	6783	6784
				6786	6792	6841	6845	6850	6852	6856	6857	6859	6861	6863	6878
				6880	6883	6884	6885	6885	6887	6888	6890	6907	6912	6925	6926
				6927	6927	6928	6936	6951	6952	6956	6964	6968	6969	6972	6977
				6981	6985	6985	6986	6989	6989	6991	6992	6993	6995	7005	7005
				7013	7013	7154	7158	7169	7214	7216	7289	7290	7293	7294	7297
				7298	7301	7302	7305	7306	7314	7318	7318	7319	7321	7323	7324
				7324	7326	7328	7329	7329	7332	7334	7346	7356	7370	7385	7386
				7387	7446	7447	7451	7453	7453	7457	7460	7464	7466	7466	7504
				7508	7512	7515	7516	7518	7518	7523	7541	7551	7555	7557	7557
				7612	7634	7659	7665	7671	7720	7723	7728	7734	7736	7740	7742
				7743	7781	7790	7790	7895	7902	7929	7930	8003	8004	8005	8006
				8023	8024	8025	8260	8270	8287	8375	8383	8389	8397	8399	8405
				8408	8428	8430	8454	8457	8471	8476	8483	8488	8525	8535	8537
				8543	8579	8582	8585	8588	8600	8600	8630	8651	8653	8657	8679
				8711	8722	8819	8825	8834	8838	8839	8850	8873	8900	8913	8913
				8917
	ARX			691 #	2216	2220	2401	2406	2435	2459	2524	2806	2807	2816	2822
				3714	3745	3747	3752	3760	3785	3789	3864	3867	3981	3983	3983
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 255
; 								Cross Reference Listing					

				3991	4001	4017	4064	4122	4134	4143	4144	4160	4161	4166	4190
				4193	4194	4207	4207	4215	4225	4238	4238	4244	4247	4261	4267
				4287	4306	4310	4314	4318	4324	4328	4332	4336	4378	4390	4396
				4462	4468	4477	4571	4576	4582	4598	4618	4618	4621	4621	4632
				4674	4675	4683	4751	4755	4942	4949	4975	4978	4981	4984	4987
				5131	5180	5180	5205	5290	5324	5392	5393	5404	5582	5684	5696
				5696	5731	5754	5829	5829	5831	5831	5833	5833	5835	5868	6012
				6014	6032	6063	6069	6095	6100	6108	6108	6111	6113	6118	6132
				6136	6156	6162	6167	6173	6199	6201	6230	6251	6257	6257	6260
				6270	6270	6279	6290	6302	6303	6308	6311	6331	6333	6343	6347
				6348	6348	6358	6376	6405	6416	6420	6422	6422	6424	6461	6469
				6473	6475	6615	6795	6838	6906	6909	6982	6983	7002	7003	7096
				7098	7136	7137	7350	7353	7361	7365	7367	7378	7514	7553	7553
				7563	7563	7686	7688	7697	7703	7726	7784	7788	7800	7907	7912
				7915	7979	7981	7986	7990	7993	7994	7998	8001	8008	8011	8014
				8017	8020	8026	8028	8291	8359	8367	8370	8425	8442	8460	8462
				8503	8611	8622	8675	8739	8739	8749	8754	8754	8759	8763	8769
				8772
	BR			692 #	2218	2419	2420	2446	2455	2457	2623	2626	2941	3051	3073
				3106	3107	3110	3111	3112	3113	3125	3128	3131	3134	3137	3141
				3144	3146	3178	3179	3182	3183	3306	3311	3320	3464	3467	3470
				3473	3476	3479	3482	3485	3508	3522	3536	3544	3648	3654	3663
				3713	3724	3730	3736	3758	3775	3781	3807	3841	3843	3847	3852
				3862	3878	3879	3883	4021	4023	4023	4027	4032	4035	4129	4208
				4354	4363	4372	4386	4393	4398	4403	4407	4425	4427	4429	4437
				4441	4459	4460	4577	4581	4585	4586	4730	4735	4749	4809	4829
				4830	4831	4832	4833	4849	4851	4853	4988	4991	4993	4997	5000
				5015	5025	5052	5064	5100	5103	5139	5140	5142	5152	5154	5241
				5321	5323	5326	5332	5333	5337	5384	5428	5474	5487	5561	5586
				5589	5591	5602	5672	5710	5728	5735	5752	5950	5955	5955	5957
				5963	5964	5966	5969	5973	5975	5976	5978	5993	6001	6011	6018
				6044	6052	6071	6094	6099	6171	6227	6232	6239	6240	6241	6243
				6249	6254	6262	6268	6268	6280	6280	6293	6372	6373	6374	6374
				6394	6397	6399	6401	6408	6408	6418	6425	6427	6443	6495	6496
				6498	6509	6511	6512	6548	6557	6626	6628	6629	6881	6924	6966
				6974	6978	6997	7041	7042	7048	7049	7066	7067	7069	7073	7079
				7081	7093	7094	7097	7097	7101	7101	7103	7103	7112	7113	7115
				7127	7128	7130	7133	7139	7139	7180	7191	7195	7219	7220	7222
				7223	7224	7245	7247	7248	7249	7254	7260	7266	7276	7278	7280
				7282	7284	7317	7335	7336	7337	7360	7363	7366	7376	7391	7397
				7404	7405	7439	7449	7462	7527	7539	7561	7565	7571	7571	7583
				7588	7601	7615	7627	7629	7631	7647	7650	7653	7656	7663	7669
				7689	7695	7701	7792	7796	8007	8267	8298	8308	8310	8312	8314
				8340	8343	8346	8372	8380	8465	8481	8485	8603	8604	8623	8808
				8809	8811	8888	8892	8894	8908
	BRX			693 #	2214	2215	2215	4156	4158	4185	4186	4213	4232	4263	4286
				4384	4445	4503	5076	5079	5136	5138	5151	5157	5182	5187	5204
				5204	5239	5289	5289	5354	5357	5358	5360	5394	5396	5397	5399
				5585	5676	5677	5688	5691	5692	5725	5734	5953	5997	6087	6096
				6101	6124	6126	6134	6153	6160	6174	6197	6202	6209	6284	6284
				6298	6325	6327	6338	6340	6349	6354	6360	6360	6364	6367	6367
				6378	6379	6396	6426	6490	6517	6543	6545	6639	6641	6644	6689
				6707	6707	6710	6715	6715	6717	6806	6811	6815	6819	6823	6827
				6831	6847	7104	7106	7106	7108	7108	7110	7118	7120	7122	7255
				7261	7264	7265	7362	7496	7497	7498	7499	7500	7501	7502	7567
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 256
; 								Cross Reference Listing					

				7570	7625	7716	7776	8009	8263	8264	8266	8288	8289	8290	8300
				8304	8306	8318	8319	8320	8329	8332	8338	8354	8453	8514	8517
				8550	8592	8596	8598	8613	8615	8619	8621	8624	8733	8786	8798
				8803	8814	8814	8880
	EBR			695 #	2198	3987	7229	7231	7232	8012
	FLG			698 #	2201	2203	2205	2206	3656	5144	5178	5202	5288	5554	5647
				5648	5655	5794	5810	5838	5858	5859	6010	6036	6039	6055	6061
				6109	6115	6123	6127	6150	6154	6161	6180	6208	6300	6390	6417
				6428	6432	6494	6541	6598	6602	6635	6662	6766	8016	8269	8325
				8554	8591	8677	8677	8779	8782	8791	8844	8848	8854	8856	8858
				8860	8862	8864	8866	8867	8868	8876	8898
	HR			689 #	2213	2219	2219	2304	2336	2351	2364	2374	2398	2470	3564
				3573	3576	3578	3579	3580	3584	3595	3599	3608	3613	3618	3621
				3623	3641	3662	3675	3688	3694	3698	3957	3959	3961	3963	3965
				3967	3969	3971	3977	4008	4013	4052	4075	4079	4640	6946	7021
				7029	7038	7039	7040	7044	7045	7046	7047	7052	7053	7054	7057
				7058	7059	7060	7061	7062	7063	7064	7285	7308	7347	7372	7377
				7403	7731	7862	7871	7873	7875	7877	7879	7881	7934	8002
	MAG			687 #	2187	4265	4299	4424	4472	4495	4929	4934	4937	5246	5266
				5267	5268	5282	5670	5760	5796	5842	7999
	MASK			697 #	2184	2185	2186	3643	4164	5261	5262	6023	7988	8015
	ONE			694 #	2190	2209	2211	2818	6391	8010
	PC			688 #	2251	2264	2266	2311	2324	2330	3054	3373	3489	3492	3560
				3561	3562	3571	3574	3587	3614	3629	3652	3742	3794	3853	3870
				4007	6285	6540	6540	7543	7713	7798	8000	8842	8852	8852	8902
				8910
	PI			699 #	2229	7401	7407	7407	7409	7409	7411	7413	7415	7415	7417
				7417	7489	7490	7491	7492	7493	7494	7495	7586	7587	7587	8018
	T0			701 #	3628	4184	4192	4224	4227	4234	4473	4479	4483	4485	4487
				4492	4497	4498	5596	5601	5608	5609	5636	5638	5639	5640	5643
				5651	5654	5656	5683	5756	5762	6389	6455	6464	6465	7418	7428
				7429	7430	7430	7560	7750	7754	7760	7762	8021
	T1			702 #	2226	2237	2254	2283	2301	2552	3615	4433	4444	4451	4465
				4467	4484	4509	4591	5250	5258	5263	5270	5281	5620	5620	5645
				5652	5695	5707	5727	5733	5743	5765	6459	6472	7537	7569	7914
				8022	8282	8833
	UBR			696 #	2196	7165	7184	7184	7199	7203	7206	7206	7208	7208	8013
	XWD1			700 #	2188	8019
(D) B				1363 #	3212	3213	3214	3215	3216	3217	3221	3222	3223	3224	3225
				3226	3228	3229	3230	3231	3232	3233	3234	3235	3237	3238	3239
				3240	3241	3242	3243	3244	3246	3247	3248	3249	3250	3251	3252
				3253	3255	3256	3257	3258	3259	3260	3261	3262	3263	3264	3265
				3266	3267	3268	3269	3270	3272	3273	3274	3275	3276	3277	3278
				3279	3385	3386	3387	3388	3389	3390	3391	3392	3394	3395	3396
				3397	3398	3399	3400	3401	3411	3412	3413	3414	3415	3416	3417
				3418	3428	3429	3430	3431	3432	3433	3434	3435	3444	3445	3446
				3447	3448	3449	3450	3451	3497	3498	3499	3500	3501	3502	3503
				3504	3511	3512	3513	3514	3515	3516	3517	3518	3525	3526	3527
				3528	3529	3530	3531	3532	3539	3540	3704	3705	3706	3801	3890
				3891	3892	3893	3894	3895	3896	3897	3947	3948	3949	3950	3951
				3952	5887	5888	5889	5890	5891	5892	5893	5895	5896	5897	5898
				5900	5901	5902	5903	5908	5909	5910	5911	5912	7593	7594	7595
				7596	7604	7605	7606	7607	7618	7619	7620	7621	7805	7806	7807
				7809	7810	7812	7813	7815	7816	7817	7818	7819	7820	7821	7822
				7824	7825	7826	7827	7828	7829	7830	7831	7833	7834	7835	7836
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 257
; 								Cross Reference Listing					

				7837	7838	7839	7840	7842	7843	7844	7845	7846	7847	7848	7849
				7851	7852	7853	7854	7855	7856	7857	7858
	AC			1367 #	2582	2583	2587	2588	2592	2593	2597	2598	2619	2635	2636
				2640	2641	2645	2646	2650	2651	2655	2656	2660	2661	2665	2666
				2670	2671	2677	2678	2682	2683	2687	2688	2692	2693	2697	2698
				2702	2703	2707	2708	2712	2713	2802	2832	2833	2842	2843	2852
				2853	2862	2863	2867	2868	2884	2885	2894	2895	2904	2905	2914
				2915	2924	2925	2934	2935	2945	2946	2955	2956	2965	2966	2975
				2976	4088	4089	4102	4103	4150	4151	4720	8256
	BOTH			1369 #	2835	2845	2855	2865	2870	2887	2897	2907	2917	2927	2937
				2948	2958	2968	2978	4091	4105	4153
	DBLAC			1365 #	2801	4117	4118	4175	4176	4201	4342	4343	4347	4348	4419
				5661	5722
	DBLB			1366 #	4178	4345	4350
	MEM			1368 #	2584	2589	2594	2599	2637	2642	2647	2652	2657	2662	2667
				2672	2679	2684	2689	2694	2699	2704	2709	2714	2834	2844	2854
				2864	2869	2879	2880	2886	2896	2906	2916	2926	2936	2947	2957
				2967	2977	4090	4104	4152	4177	4344	4349	7271
	SELF			1364 #	2585	2590	2595	2600	2638	2643	2648	2653	2658	2663	2668
				2673	2680	2685	2690	2695	2700	2705	2710	2715
(U) BWRITE			1187 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	4096	4110	4162
				4168	4191	4193	5482	5486	5532	5554	8601	8901
(U) BYTE			846 #
	BYTE1			847 #	4730	4735	4749	4770	4923	6071	6081	6563	6709	6881	6884
				6924	6926	6997
	BYTE2			848 #	4924
	BYTE3			849 #	4925
	BYTE4			850 #	4926
	BYTE5			851 #	3076	4829	4830	4831	4832	4833	4927	6693
(U) CALL			998 #	2191	2217	2229	2434	2806	2816	3586	3625	3627	3628	3642
				3666	3669	3866	3869	3984	4000	4005	4009	4015	4018	4052	4054
				4159	4187	4214	4223	4233	4243	4266	4376	4397	4452	4458	4472
				4476	4482	4528	4552	4730	4735	4739	4744	4749	4758	4761	5009
				5019	5053	5080	5135	5151	5153	5240	5252	5254	5272	5274	5361
				5403	5406	5411	5413	5521	5523	5525	5540	5541	5542	5601	5609
				5637	5677	5682	5694	5701	5708	5727	5751	5755	5759	5784	5787
				5790	5822	5824	5826	5832	5952	5992	5995	5999	6031	6037	6062
				6086	6097	6112	6116	6123	6133	6135	6141	6155	6164	6185	6200
				6203	6216	6231	6242	6250	6253	6256	6259	6267	6272	6299	6334
				6343	6359	6371	6398	6409	6417	6434	6460	6489	6492	6497	6572
				6580	6590	6593	6603	6616	6631	6638	6659	6663	6731	6765	6789
				6889	6908	6913	6965	6973	6984	7255	7325	7349	7352	7371	7418
				7448	7461	7510	7540	7542	7558	7562	7600	7611	7626	7645	7654
				7683	7690	7715	7908	7910	7916	7932	7980	7982	7999	8002	8004
				8006	8009	8012	8015	8018	8021	8023	8393	8400	8411	8418	8429
				8438	8456	8459	8472	8495	8505	8536	8567	8652	8810	8821	8881
				8909
(U) CHKL			751 #	2304	2374	2388	2397	2401	2418	2429	2440	2446	2459	2530
				2562	2568	2573	2576	2626	2822	3122	3441	3584	3608	3623	3648
				3652	3713	3730	3736	3758	3775	3781	3794	3852	3883	4005	4007
				4013	4040	4052	4056	4079	4157	4250	4252	4355	4365	4449	4471
				4478	4775	4803	4809	4930	5195	5244	5950	5969	6389	6579	6629
				6632	6660	6936	6951	7021	7154	7289	7293	7297	7301	7305	7346
				7376	7378	7385	7439	7523	7565	7689	7736	7781	7784	7786	7796
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 258
; 								Cross Reference Listing					

				7798	7895	7914	7934	7999	8000	8002	8003	8006	8007	8009	8010
				8012	8013	8015	8016	8018	8019	8021	8022	8024	8389	8471	8711
				8763	8880	8894	8908	8910
(U) CHKR			758 #	2304	2374	2388	2397	2401	2418	2429	2440	2446	2459	2530
				2562	2568	2573	2576	2626	2822	3122	3441	3584	3608	3623	3648
				3652	3713	3730	3736	3758	3775	3781	3794	3852	3883	4005	4007
				4013	4040	4052	4056	4079	4157	4250	4252	4355	4365	4449	4471
				4478	4775	4803	4809	4930	5195	5244	5950	5969	6389	6579	6629
				6632	6660	6936	6951	7021	7154	7289	7293	7297	7301	7305	7346
				7376	7378	7385	7439	7523	7565	7689	7736	7781	7784	7786	7796
				7798	7895	7914	7934	7999	8000	8002	8003	8006	8007	8009	8010
				8012	8013	8015	8016	8018	8019	8021	8022	8024	8389	8471	8711
				8763	8880	8894	8908	8910
(U) CLKL			747 #	2264	2266	2311	2324	2325	2331	2336	2351	2352	2364	2375
				2398	2726	2757	2765	2787	2789	3373	3489	3492	3560	3561	3562
				3571	3574	3587	3599	3629	3653	3667	3795	3854	3868	3872	4017
				4029	4034	4064	4080	4131	4774	4804	5013	5072	5095	5144	5156
				5178	5182	5187	5202	5205	5215	5267	5268	5288	5290	5363	5626
				5963	5966	5969	6010	6036	6039	6055	6061	6090	6109	6115	6123
				6127	6138	6150	6154	6161	6180	6208	6285	6300	6338	6373	6390
				6417	6428	6432	6488	6494	6541	6598	6602	6637	6662	6703	6708
				6766	6885	6927	6936	7095	7121	7135	7204	7220	7222	7266	7347
				7352	7377	7411	7413	7415	7417	7429	7489	7490	7491	7492	7493
				7494	7495	7517	7587	7713	7734	7734	7915	7931	8001	8008	8011
				8014	8017	8020	8269	8545	8591	8599	8842	8848	8854	8856	8858
				8860	8862	8864	8866	8867	8868	8898	8917
(U) CLKR			754 #	2455	2457	2470	2492	2493	2724	2759	2763	2780	2782	2806
				3149	3151	3422	3564	3573	3576	3578	3579	3580	3613	3618	3621
				3641	3662	3675	3806	3957	3959	3961	3963	3965	3967	3969	3971
				3979	3999	4009	4061	4077	4142	4143	4144	4166	4189	4396	4435
				4497	4551	4674	4851	4986	4994	5057	5102	5137	5141	5328	5329
				5332	5333	5357	5358	5390	5391	5451	5452	5528	5544	5647	5648
				5655	5671	5793	5828	5858	5859	5874	5956	5978	6205	6210	6279
				6295	6296	6302	6341	6343	6350	6356	6365	6384	6436	6439	6444
				6469	6475	6546	6640	6642	6712	6716	6770	6812	6816	6820	6824
				6828	6832	6848	6946	6958	7029	7038	7039	7040	7044	7045	7046
				7047	7052	7053	7054	7057	7058	7059	7060	7061	7062	7063	7064
				7089	7129	7132	7160	7167	7171	7186	7192	7201	7209	7231	7232
				7250	7254	7260	7285	7308	7319	7403	7405	7407	7409	7541	7743
				7788	7862	7871	7873	7875	7877	7879	7881	8262	8265	8327	8331
				8334	8339	8490	8515	8552	8556	8590	8594	8597	8608	8678	8783
				8788	8793	8799	8813	8876
(U) CLRFPD			1116 #	3725	3842	3848	4245	4745	4762	6428
(D) COND FUNC			1386 #	2584	2585	2589	2590	2594	2595	2599	2600	2637	2638	2642
				2643	2647	2648	2652	2653	2657	2658	2662	2663	2667	2668	2672
				2673	2679	2680	2684	2685	2689	2690	2694	2695	2699	2700	2704
				2705	2709	2710	2714	2715	2834	2835	2844	2845	2854	2855	2864
				2865	2869	2870	2879	2880	2886	2887	2896	2897	2906	2907	2916
				2917	2926	2927	2936	2937	2947	2948	2957	2958	2967	2968	2977
				2978	4090	4091	4104	4105	4152	4153	4177	4178	4344	4345	4349
				4350	5299	5300	5303	5304	5307	5308	5311	5312	5344	5345	5349
				5350	5373	5374	5378	5379	7271
(U) CRY38			981 #	2612	2982	3405	3455	3536	3562	3571	3574	4109	4126	4134
				4139	4313	4317	4359	4403	4436	4459	4460	4466	4487	4513	4554
				4555	4556	4572	4574	4581	4587	4618	4648	4653	4658	4663	4675
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 259
; 								Cross Reference Listing					

				4679	4683	4685	5014	5071	5088	5138	5157	5175	5199	5287	5318
				5393	5396	5397	5404	5415	5428	5520	5522	5524	5526	5537	5553
				5582	5621	5734	5745	5752	5768	5809	5814	5835	5841	5875	6001
				6034	6048	6069	6136	6172	6173	6174	6221	6285	6303	6306	6374
				6391	6399	6418	6426	6427	6461	6463	6466	6514	6856	6977	6985
				6991	7329	7429	7453	7466	7713	8735	8745	8842	8902
(U) DBM				726 #
	APR FLAGS		729 #	7041	7042	7104	7136	7335
	BYTES			730 #
	DP			732 #	3076	4730	4735	4749	4770	4829	4830	4831	4832	4833	4923
				4924	4925	4926	4927	6071	6081	6563	6693	6709	6881	6884	6924
				6926	6997
	DP SWAP			733 #	2424	2604	2751	2753	2756	2759	2762	2765	3304	3309	3628
				3805	3864	3879	3997	4849	4975	4991	5091	5131	5140	5213	6438
				6495	6500	6501	6795	7128	7405	7418	7428	8481	8772
	EXP			731 #	5528	5544	5874	7360	7361	7362
	MEM			735 #	2196	2303	2374	2387	2396	2400	2428	2439	2445	2458	3583
				3607	3622	3644	3648	3652	3712	3757	3794	3882	4039	4802	4808
				5194	5243	5950	5969	6389	6632	6660	6936	6950	7006	7014	7021
				7153	7289	7293	7297	7301	7305	7345	7385	7507	7511	7523	7559
				7565	7655	7736	7781	7784	7786	7894	7909	7933	7982	8324	8388
				8470	8710	8762	8823	8829
	PF DISP			728 #	8294
	SCAD DIAG		727 #
	VMA			734 #	7750	7993	8263	8289	8809
	#			736 #	2184	2186	2188	2190	2193	2213	2214	2223	2226	2237	2254
				2273	2277	2280	2283	2292	2295	2298	2301	2455	2457	2470	2492
				2493	2552	2780	2782	2787	2789	2806	3077	3148	3150	3564	3573
				3576	3578	3579	3580	3613	3615	3618	3621	3627	3641	3642	3656
				3662	3675	3760	3789	3853	3870	3957	3959	3961	3963	3965	3967
				3969	3971	3977	3981	4021	4025	4027	4030	4032	4060	4069	4075
				4143	4144	4396	4433	4434	4444	4451	4497	4549	4576	4582	4674
				4839	4981	4984	4988	5007	5011	5017	5021	5050	5055	5088	5093
				5100	5144	5154	5250	5255	5263	5270	5275	5328	5329	5332	5333
				5357	5358	5362	5390	5391	5427	5431	5451	5452	5546	5589	5591
				5647	5648	5655	5671	5691	5692	5711	5714	5742	5744	5782	5785
				5788	5791	5851	5858	5859	5918	5920	5922	5924	5926	5928	5930
				5932	5934	5951	5953	5978	5994	5997	6010	6036	6039	6061	6109
				6115	6123	6133	6135	6154	6161	6180	6193	6197	6204	6208	6209
				6217	6221	6237	6279	6295	6296	6302	6308	6327	6340	6343	6349
				6354	6362	6364	6390	6417	6421	6435	6437	6443	6455	6464	6469
				6475	6491	6503	6506	6514	6526	6529	6541	6545	6560	6598	6602
				6618	6630	6635	6639	6641	6656	6662	6676	6696	6702	6710	6713
				6790	6811	6815	6819	6823	6827	6831	6841	6847	6946	6956	7023
				7029	7038	7039	7040	7044	7045	7046	7047	7052	7053	7054	7057
				7058	7059	7060	7061	7062	7063	7064	7066	7069	7079	7081	7094
				7096	7098	7100	7102	7105	7107	7109	7120	7130	7133	7137	7158
				7165	7169	7173	7180	7199	7220	7221	7222	7230	7231	7232	7248
				7254	7260	7265	7285	7308	7317	7336	7350	7400	7402	7403	7404
				7406	7408	7410	7411	7412	7413	7414	7416	7447	7449	7460	7462
				7489	7490	7491	7492	7493	7494	7495	7496	7497	7498	7499	7500
				7501	7502	7504	7508	7516	7525	7526	7537	7541	7555	7561	7567
				7569	7583	7647	7650	7658	7665	7671	7685	7686	7697	7703	7717
				7719	7733	7776	7862	7871	7873	7875	7877	7879	7881	7929	7930
				8260	8264	8268	8269	8282	8304	8306	8320	8325	8328	8329	8332
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 260
; 								Cross Reference Listing					

				8338	8346	8350	8375	8383	8394	8401	8404	8419	8424	8425	8473
				8485	8488	8492	8496	8502	8503	8514	8516	8517	8520	8522	8542
				8543	8547	8550	8554	8575	8588	8592	8595	8596	8598	8604	8611
				8613	8614	8615	8616	8619	8654	8659	8675	8681	8684	8686	8689
				8692	8713	8723	8735	8745	8749	8759	8764	8777	8779	8781	8782
				8784	8786	8789	8791	8795	8798	8803	8811	8833	8836	8854	8856
				8858	8860	8862	8864	8868	8873	8876	8885
(U) DBUS			717 #
	DBM			723 #	2184	2186	2188	2190	2193	2196	2213	2214	2223	2226	2237
				2254	2273	2277	2280	2283	2292	2295	2298	2301	2303	2304	2374
				2374	2387	2388	2396	2397	2400	2401	2424	2428	2429	2439	2440
				2445	2446	2455	2457	2458	2459	2470	2492	2493	2552	2604	2751
				2753	2756	2759	2762	2765	2780	2782	2787	2789	2806	3076	3077
				3148	3150	3304	3309	3564	3573	3576	3578	3579	3580	3583	3584
				3607	3608	3613	3615	3618	3621	3622	3623	3627	3628	3641	3642
				3644	3648	3648	3652	3652	3656	3662	3675	3712	3713	3757	3758
				3760	3789	3794	3794	3805	3853	3864	3870	3879	3882	3883	3957
				3959	3961	3963	3965	3967	3969	3971	3977	3981	3997	4021	4025
				4027	4030	4032	4039	4040	4060	4069	4075	4143	4144	4396	4433
				4434	4444	4451	4497	4549	4576	4582	4674	4730	4735	4749	4770
				4802	4803	4808	4809	4829	4830	4831	4832	4833	4839	4849	4923
				4924	4925	4926	4927	4975	4981	4984	4988	4991	5007	5011	5017
				5021	5050	5055	5088	5091	5093	5100	5131	5140	5144	5154	5194
				5195	5213	5243	5244	5249	5255	5263	5269	5275	5328	5329	5332
				5333	5357	5358	5362	5390	5391	5427	5431	5451	5452	5528	5544
				5546	5589	5591	5647	5648	5655	5671	5691	5692	5711	5714	5742
				5744	5782	5785	5788	5791	5851	5858	5859	5874	5918	5920	5922
				5924	5926	5928	5930	5932	5934	5950	5950	5951	5953	5969	5969
				5978	5994	5997	6010	6036	6039	6061	6071	6081	6109	6115	6123
				6133	6135	6154	6161	6180	6193	6197	6204	6208	6209	6217	6221
				6237	6279	6295	6296	6302	6308	6327	6340	6343	6349	6354	6362
				6364	6389	6389	6390	6417	6421	6435	6437	6438	6443	6455	6464
				6469	6475	6491	6495	6500	6501	6503	6506	6514	6526	6529	6541
				6545	6560	6563	6598	6602	6618	6630	6632	6632	6635	6639	6641
				6656	6660	6660	6662	6676	6693	6696	6702	6709	6710	6713	6790
				6795	6811	6815	6819	6823	6827	6831	6841	6847	6881	6884	6924
				6926	6936	6936	6946	6950	6951	6956	6997	7006	7014	7021	7021
				7023	7029	7038	7039	7040	7041	7042	7044	7045	7046	7047	7052
				7053	7054	7057	7058	7059	7060	7061	7062	7063	7064	7066	7069
				7079	7081	7094	7096	7098	7100	7102	7104	7105	7107	7109	7120
				7128	7130	7133	7136	7137	7153	7154	7158	7165	7169	7173	7180
				7199	7220	7221	7222	7230	7231	7232	7248	7254	7260	7265	7285
				7289	7289	7293	7293	7297	7297	7301	7301	7305	7305	7308	7317
				7335	7336	7345	7346	7350	7360	7361	7362	7385	7385	7400	7402
				7403	7404	7405	7406	7408	7410	7411	7412	7413	7414	7416	7418
				7428	7447	7449	7460	7462	7489	7490	7491	7492	7493	7494	7495
				7496	7497	7498	7499	7500	7501	7502	7504	7507	7508	7511	7512
				7516	7523	7523	7525	7526	7537	7541	7555	7559	7560	7561	7565
				7565	7567	7569	7583	7647	7650	7655	7656	7658	7665	7671	7685
				7686	7697	7703	7717	7719	7733	7736	7736	7750	7776	7781	7781
				7784	7784	7786	7786	7862	7871	7873	7875	7877	7879	7881	7894
				7895	7909	7929	7930	7933	7934	7982	7993	8260	8263	8264	8268
				8269	8282	8289	8294	8300	8304	8306	8320	8324	8325	8328	8329
				8332	8338	8346	8350	8375	8383	8388	8389	8394	8401	8404	8419
				8424	8425	8470	8471	8473	8481	8485	8488	8492	8496	8502	8503
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 261
; 								Cross Reference Listing					

				8514	8516	8517	8520	8522	8542	8543	8547	8550	8554	8575	8588
				8592	8595	8596	8598	8604	8611	8613	8614	8615	8616	8619	8654
				8659	8675	8681	8684	8686	8689	8692	8710	8711	8713	8723	8735
				8745	8749	8759	8762	8763	8764	8772	8777	8779	8781	8782	8784
				8786	8789	8791	8795	8798	8803	8809	8811	8823	8829	8833	8836
				8854	8856	8858	8860	8862	8864	8868	8873	8876	8885
	DP			721 #	2208	2209	2524	2530	2556	2562	2568	2573	2576	2626	2807
				2822	3057	3078	3113	3146	3152	3335	3422	3424	3441	3464	3467
				3467	3470	3470	3473	3473	3476	3479	3479	3482	3482	3485	3485
				3689	3730	3736	3745	3747	3775	3781	3810	3815	3843	3852	4005
				4007	4013	4052	4056	4079	4142	4166	4189	4217	4225	4234	4236
				4247	4247	4248	4249	4251	4253	4475	4491	4492	4493	4495	4498
				4517	4519	4522	4649	4654	4659	4665	4666	4667	4745	4775	4930
				5103	5152	5172	5198	5216	5241	5286	5478	5484	5796	5804	5840
				5841	5842	5849	6001	6047	6067	6074	6084	6087	6122	6124	6126
				6160	6167	6201	6243	6260	6262	6297	6298	6298	6310	6311	6318
				6320	6344	6344	6347	6379	6385	6396	6401	6423	6424	6425	6583
				6584	6629	6644	6717	6733	6770	6859	6859	6887	6928	6966	6974
				6981	6986	6993	7319	7376	7378	7439	7612	7689	7731	7796	7798
				7800	7914	7999	8000	8002	8003	8006	8007	8009	8010	8012	8013
				8015	8016	8018	8019	8021	8022	8024	8270	8844	8880	8894	8908
				8910
	PC FLAGS		718 #	3663	3677	3724	3841	3847	3998	4024	4053	4254	7002	7527
				7539	8888	8892
	PI NEW			719 #	7486
	RAM			722 #	2216	2324	2336	2351	2364	2392	2405	2406	2418	2419	2623
				2724	2726	2757	2763	2816	2849	2859	2891	2901	2921	2931	2941
				2972	3000	3003	3017	3023	3035	3038	3051	3122	3125	3311	3326
				3329	3334	3405	3508	3522	3536	3544	3591	3599	3714	3752	3785
				3807	3865	3878	4095	4109	4122	4125	4134	4136	4139	4157	4185
				4213	4215	4227	4232	4250	4252	4355	4364	4365	4447	4449	4471
				4478	4488	4648	4652	4653	4657	4658	4662	4663	4751	4755	4787
				4795	5005	5014	5015	5027	5031	5066	5073	5078	5086	5142	5151
				5214	5239	5321	5354	5386	5450	5585	5586	5596	5676	5688	5731
				5739	5963	5966	5993	5996	6011	6014	6030	6034	6044	6051	6060
				6063	6079	6083	6098	6099	6100	6101	6118	6132	6134	6152	6165
				6171	6178	6184	6196	6199	6216	6219	6223	6227	6230	6232	6239
				6241	6249	6251	6254	6290	6292	6293	6305	6306	6325	6330	6331
				6332	6353	6358	6370	6376	6386	6394	6399	6405	6412	6418	6419
				6420	6441	6461	6466	6471	6473	6490	6548	6579	6589	6592	6617
				6626	6628	6653	6668	6730	6732	6775	6776	6783	6845	6850	6852
				6857	6861	6863	6878	6880	6907	6931	6933	6964	6968	6972	6977
				6978	6983	6991	6992	6995	7093	7127	7219	7276	7278	7280	7282
				7284	7314	7323	7328	7334	7366	7367	7370	7391	7601	7615	7629
				7631	7723	7726	7728	7734	7740	7742	7902	7981	7986	7990	8005
				8023	8025	8026	8028	8267	8367	8370	8397	8399	8430	8437	8454
				8457	8476	8525	8535	8537	8566	8582	8622	8623	8624	8630	8650
				8651	8657	8819	8825	8834	8838	8850
(U) DEST			652 #
	A			653 #	2424	2440	2524	2556	2604	2751	2753	2756	2759	2762	2765
				2807	3078	3113	3304	3309	3335	3422	3424	3464	3467	3470	3473
				3476	3479	3482	3485	3628	3745	3747	3805	3843	3864	3879	3997
				4142	4166	4189	4247	4492	4498	4667	4730	4735	4745	4749	4770
				4829	4830	4831	4832	4833	4849	4923	4924	4925	4926	4927	4975
				4991	5091	5131	5140	5152	5213	5216	5241	5478	5484	5528	5544
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 262
; 								Cross Reference Listing					

				5804	5849	5874	6047	6067	6071	6081	6084	6124	6160	6167	6201
				6260	6262	6297	6298	6310	6311	6344	6347	6379	6385	6396	6401
				6423	6424	6425	6438	6495	6500	6501	6563	6584	6644	6709	6717
				6770	6795	6859	6881	6884	6887	6924	6926	6928	6966	6974	6981
				6986	6993	6997	7128	7319	7405	7418	7428	7612	7800	8270	8481
				8772
	AD			655 #	2184	2186	2188	2190	2193	2196	2198	2201	2210	2213	2214
				2215	2216	2219	2226	2229	2237	2251	2254	2264	2266	2273	2277
				2280	2283	2292	2295	2298	2301	2304	2311	2324	2330	2336	2351
				2355	2364	2374	2388	2392	2397	2398	2401	2405	2406	2429	2435
				2446	2449	2452	2455	2457	2470	2492	2493	2552	2612	2623	2724
				2726	2757	2763	2773	2775	2780	2782	2787	2789	2794	2796	2806
				2816	2839	2849	2859	2874	2891	2901	2911	2921	2931	2941	2942
				2952	2962	2972	2982	3000	3003	3017	3051	3054	3077	3306	3311
				3323	3326	3329	3334	3373	3405	3439	3455	3489	3492	3508	3522
				3536	3544	3560	3561	3564	3573	3576	3578	3579	3580	3584	3587
				3599	3608	3613	3614	3615	3618	3621	3623	3629	3641	3648	3649
				3652	3656	3662	3663	3667	3670	3675	3677	3688	3713	3714	3724
				3742	3752	3758	3760	3785	3789	3794	3807	3841	3847	3853	3862
				3865	3867	3870	3878	3883	3957	3959	3961	3963	3965	3967	3969
				3971	3977	3981	3983	3998	4008	4017	4021	4023	4024	4027	4032
				4040	4053	4060	4064	4069	4075	4080	4095	4109	4122	4125	4129
				4130	4134	4136	4139	4143	4144	4156	4162	4168	4170	4171	4184
				4185	4190	4193	4194	4208	4224	4238	4254	4261	4354	4357	4359
				4363	4364	4378	4384	4390	4396	4413	4433	4444	4445	4451	4462
				4468	4477	4485	4497	4504	4507	4556	4571	4573	4574	4576	4581
				4582	4595	4662	4663	4674	4675	4677	4679	4683	4684	4685	4755
				4768	4774	4803	4809	4851	4862	4947	4948	4949	4950	4984	4993
				5005	5007	5015	5017	5021	5024	5050	5063	5073	5076	5082	5093
				5100	5136	5139	5142	5144	5151	5154	5178	5180	5182	5187	5202
				5204	5205	5214	5239	5257	5263	5288	5289	5290	5318	5321	5324
				5325	5326	5328	5329	5332	5333	5338	5354	5357	5358	5364	5384
				5386	5390	5391	5392	5393	5428	5450	5451	5452	5482	5486	5487
				5535	5537	5547	5550	5552	5553	5554	5565	5582	5583	5596	5601
				5602	5609	5610	5620	5645	5647	5648	5652	5655	5672	5683	5695
				5696	5725	5727	5728	5733	5734	5735	5743	5754	5756	5770	5771
				5794	5810	5812	5814	5829	5831	5833	5835	5838	5858	5859	5875
				5918	5920	5922	5924	5926	5928	5930	5932	5934	5950	5953	5955
				5963	5964	5966	5969	5978	5989	5993	5996	5997	6003	6005	6010
				6011	6012	6014	6022	6030	6032	6034	6036	6039	6044	6048	6051
				6053	6054	6055	6060	6061	6063	6069	6078	6079	6083	6085	6090
				6098	6099	6100	6101	6108	6109	6113	6115	6118	6123	6127	6132
				6134	6137	6138	6139	6150	6152	6154	6161	6165	6169	6171	6172
				6173	6174	6179	6180	6184	6193	6196	6197	6199	6204	6208	6209
				6216	6219	6223	6227	6230	6232	6241	6249	6251	6254	6257	6268
				6270	6279	6280	6284	6285	6290	6292	6293	6295	6296	6300	6302
				6303	6305	6306	6308	6325	6327	6330	6331	6332	6338	6340	6343
				6348	6349	6353	6354	6358	6360	6364	6367	6370	6372	6373	6374
				6376	6384	6386	6387	6389	6390	6392	6394	6399	6405	6408	6412
				6417	6418	6419	6420	6422	6426	6427	6428	6432	6436	6439	6441
				6443	6455	6459	6461	6463	6464	6466	6469	6471	6473	6475	6477
				6488	6490	6494	6503	6506	6540	6541	6545	6548	6557	6559	6564
				6589	6592	6598	6602	6617	6618	6626	6628	6630	6632	6635	6639
				6641	6653	6656	6658	6660	6662	6668	6676	6696	6702	6707	6710
				6713	6715	6730	6732	6766	6775	6783	6792	6811	6815	6819	6823
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 263
; 								Cross Reference Listing					

				6827	6831	6841	6845	6847	6850	6852	6856	6857	6861	6863	6878
				6880	6883	6885	6906	6907	6925	6927	6936	6946	6951	6956	6964
				6968	6972	6977	6978	6982	6983	6985	6989	6991	6992	6995	7002
				7005	7013	7021	7029	7038	7039	7040	7041	7042	7044	7045	7046
				7047	7048	7049	7052	7053	7054	7057	7058	7059	7060	7061	7062
				7063	7064	7066	7069	7079	7081	7093	7094	7096	7097	7098	7101
				7103	7104	7106	7108	7120	7127	7130	7133	7136	7137	7139	7154
				7158	7165	7169	7180	7184	7191	7199	7203	7206	7208	7219	7220
				7222	7229	7231	7232	7248	7249	7254	7260	7265	7266	7276	7278
				7280	7282	7284	7285	7289	7293	7297	7301	7305	7308	7314	7317
				7318	7323	7324	7326	7328	7329	7334	7335	7336	7346	7347	7350
				7360	7361	7362	7365	7366	7367	7370	7377	7385	7391	7397	7401
				7403	7404	7407	7409	7411	7413	7415	7417	7429	7430	7446	7447
				7449	7453	7460	7462	7466	7489	7490	7491	7492	7493	7494	7495
				7496	7497	7498	7499	7500	7501	7502	7504	7508	7512	7514	7516
				7518	7523	7527	7537	7539	7541	7543	7553	7555	7557	7560	7561
				7563	7565	7569	7571	7583	7587	7601	7615	7625	7627	7629	7631
				7634	7647	7650	7656	7659	7665	7671	7686	7697	7703	7716	7723
				7726	7728	7734	7736	7740	7742	7743	7750	7776	7781	7784	7788
				7790	7862	7871	7873	7875	7877	7879	7881	7895	7902	7912	7915
				7929	7930	7934	7981	7986	7990	7993	8001	8005	8008	8011	8014
				8017	8020	8023	8025	8026	8028	8260	8263	8264	8267	8269	8282
				8289	8300	8304	8306	8320	8325	8329	8332	8338	8340	8346	8367
				8370	8375	8383	8389	8397	8399	8425	8428	8430	8454	8457	8471
				8476	8485	8488	8503	8514	8517	8525	8535	8537	8543	8550	8554
				8579	8582	8588	8591	8592	8596	8598	8600	8603	8604	8611	8613
				8615	8619	8622	8623	8624	8630	8651	8653	8657	8675	8677	8711
				8722	8739	8749	8754	8759	8763	8779	8782	8786	8791	8798	8803
				8809	8811	8814	8819	8825	8833	8834	8838	8842	8848	8850	8852
				8854	8856	8858	8860	8862	8864	8866	8867	8868	8873	8876	8888
				8892	8898	8900	8902	8913	8917
	AD*.5			662 #	2187	2459	2461	2462	3019	3023	3035	3038	3040	3041	3045
				3076	3128	3131	4206	4207	4213	4215	4225	4227	4232	4263	4425
				4447	4453	4584	4585	4586	4592	4842	4853	4929	4978	4981	4988
				4997	5399	5407	5409	5414	5415	5474	5523	5525	5541	5542	5561
				5562	5567	5585	5586	5589	5591	5676	5677	5684	5688	5691	5692
				5710	5731	5739	5742	5744	5868	5879	6502	6505	6509	6511	6591
				6693	6699	6706	6769	7245	7247	7255	7261	7264	7567	7570	7588
				7663	7669	8343	8359
	AD*2			660 #	2185	3007	3030	3043	3046	3073	4161	4188	4244	4487	4627
				4751	5088	5097	5250	5270	5281	5394	5397	5402	5477	6239	6240
				6496	6680	6786	7195	7214	7216	7515	7551	7695	7701	7792	8405
				8408	8442	8585
	PASS			657 #	2195	2203	2205	2206	2209	2211	2212	2218	2220	2263	2267
				2285	2342	2369	2378	2465	2530	2562	2568	2573	2576	2626	2822
				2823	3146	3361	3441	3488	3493	3567	3603	3665	3676	3698	3730
				3736	3765	3770	3775	3781	3810	3815	3849	3852	3880	4005	4007
				4013	4052	4056	4079	4164	4192	4234	4249	4251	4253	4256	4431
				4475	4495	4517	4519	4522	4649	4654	4659	4665	4666	4728	4731
				4740	4775	4791	4799	4930	4987	5000	5010	5020	5052	5132	5160
				5168	5284	5796	5840	5841	5842	5960	5967	5973	5976	6001	6006
				6023	6068	6094	6095	6096	6111	6142	6158	6181	6194	6212	6243
				6333	6335	6391	6397	6410	6416	6493	6549	6615	6627	6629	6669
				6733	6763	6932	6934	6952	6969	7003	7067	7073	7115	7151	7224
				7256	7290	7294	7298	7302	7306	7321	7332	7353	7356	7363	7376
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 264
; 								Cross Reference Listing					

				7378	7386	7387	7420	7438	7439	7444	7471	7472	7522	7586	7653
				7688	7689	7691	7720	7735	7754	7760	7762	7794	7796	7798	7891
				7899	7907	7914	7926	7979	7994	7999	8000	8002	8003	8004	8006
				8007	8009	8010	8012	8013	8015	8016	8018	8019	8021	8022	8024
				8027	8266	8287	8288	8290	8291	8295	8298	8308	8310	8312	8314
				8318	8319	8372	8380	8385	8460	8462	8465	8483	8609	8625	8706
				8808	8877	8880	8894	8908	8910
	Q_AD			656 #	2418	3016	3122	3148	3150	4157	4183	4222	4242	4250	4252
				4262	4355	4365	4424	4434	4436	4449	4471	4474	4476	4478	4489
				4502	4503	4506	4513	4521	4549	4554	4555	4572	4597	4648	4652
				4653	4657	4658	4857	4933	4940	5002	5011	5014	5031	5055	5071
				5078	5138	5195	5244	5255	5260	5275	5278	5335	5359	5362	5406
				5417	5429	5433	5435	5436	5449	5462	5520	5522	5524	5526	5594
				5603	5606	5611	5621	5626	5666	5671	5681	5694	5700	5712	5715
				5745	5750	5755	5757	5768	5792	5808	5809	5827	6019	6178	6579
				7786
	Q_Q*.5			661 #	2419	2420	3106	3125	3134	3178	4158	4186	4265	4286	4287
				4299	4306	4314	4324	4332	4427	4429	4437	4441	4457	4472	4479
				4531	4579	5079	5246	5266	5267	5268	5282	5337	5360	5365	5440
				5442	5472	5615	5640	5643	5651	5654	5656	5670	5705	5746	5760
				5786	5789	5823	5825	5871
	Q_Q*2			659 #	3026	3107	3110	3111	3112	3137	3141	3144	3179	3182	3183
				4310	4318	4328	4336	4473	4483	4511	4514	4587	4590	4591	4594
				4596	4618	4621	4633	4638	4858	4861	4934	4937	4942	5261	5262
				5519	5531	5539	5543	5617	5622	5624	5636	5638	5639	5668	5709
				5713	5762	5779	5801	5818	5846	6021
(U) DISP			891 #	4599
	ADISP			898 #
	AREAD			894 #	2356
	BDISP			899 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	3306	3312	3405
				3424	3425	3508	3522	3536	3546	3731	3738	3776	4096	4110	4162
				4168	4191	4193	5245	5474	5482	5486	5532	5544	5554	5561	5965
				6007	6151	6206	6413	6767	6839	6846	7601	7628	7646	7657	7684
				8601	8901
	BYTE			904 #	4743	4760	6188	6891	6912
	CONSOLE			892 #
	DP			897 #	4465	4467	4484	4509	6512	6539	8844
	DP LEFT			895 #	6498	6793	7487	8296
	DROM			893 #	2389	2393	2402	2407	2415	2436	2442	2466	2471	5974	5977
	EAMODE			905 #	2314	2380	3589	4782	4785	5961	6929	6937	7725
	MUL			901 #	4306	4314	4324	4332	5618	5644	5646	5763
	NICOND			903 #	2263	2264	2266	2267	2327	2333	2557	3078	3124	3152	3361
				3373	3464	3488	3489	3492	3493	3560	3561	3587	3629	3746	3822
				3829	4256	4520	4523	4731	5478	5484	5843	7420	7691	8270
	NORM			896 #	5338	5367	5444	5519	5521	5531	5535	5537	5539	5540	5543
				5565	5716	5770	5771	5781	5783	5803	5813	5815	5820	5821	5848
				5877
	PAGE FAIL		902 #
	RETURN			900 #	2492	2493	3594	3598	4062	4065	4268	4311	4319	4329	4337
				4531	4553	4554	4556	4640	4667	4769	4771	4775	4810	4843	4862
				4930	5144	5281	5282	5564	5566	5567	5656	5851	5858	5859	5874
				6263	6273	6278	6281	6319	6320	6470	6476	6647	6670	6735	6766
				6778	6809	6825	6842	6851	6853	6879	6914	6947	6953	6958	6998
				7266	7333	7357	7432	7476	7584	7587	7659	7666	7672	7729	7737
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 265
; 								Cross Reference Listing					

				7741	7744	7770	7782	7784	7786	7788	7790	7792	7794	7796	7798
				7800	7991	7995	8029	8631	8653	8658	8664	8695	8698	8699	8712
				8721	8724	8725	8829	8917
	SCAD0			906 #	4730	4735	4749	4825	5321	5464	5466	6019	6021	6072	6882
				6924	7756
(U) DIVIDE			992 #	4590	4591	4635	4639
(U) DONT CACHE			1162 #
(U) DP FUNC			1179 #	7653	7688	7794	8610	8626
(U) DT				961 #
	2T			964 #
	3T			965 #	2216	2406	2418	2419	2529	2561	2567	2572	2575	2625	2816
				2822	3023	3035	3038	3052	3122	3125	3367	3370	3379	3382	3441
				3470	3473	3482	3485	3627	3627	3642	3642	3729	3735	3774	3780
				3851	4004	4006	4012	4025	4030	4051	4055	4078	4122	4134	4160
				4165	4227	4232	4250	4252	4365	4367	4369	4373	4387	4426	4432
				4447	4449	4461	4471	4478	4491	4572	4648	4650	4652	4653	4655
				4657	4658	4660	4676	4683	4730	4735	4743	4749	4751	4760	4775
				4930	5001	5005	5014	5015	5030	5060	5073	5078	5142	5171	5197
				5214	5286	5338	5367	5384	5404	5410	5412	5444	5485	5519	5521
				5527	5531	5535	5537	5539	5540	5543	5546	5551	5565	5586	5688
				5707	5711	5714	5716	5728	5739	5758	5770	5771	5781	5782	5783
				5785	5788	5791	5800	5803	5809	5813	5815	5820	5821	5845	5848
				5851	5869	5877	5951	5993	5994	6011	6014	6030	6034	6044	6051
				6060	6063	6079	6083	6098	6099	6100	6101	6118	6132	6133	6135
				6152	6165	6171	6175	6178	6184	6188	6199	6216	6217	6219	6223
				6227	6228	6230	6232	6237	6239	6241	6249	6251	6254	6290	6292
				6293	6304	6305	6306	6307	6325	6331	6358	6362	6370	6375	6376
				6386	6394	6399	6405	6412	6418	6419	6420	6421	6435	6437	6441
				6491	6526	6529	6548	6579	6583	6589	6592	6596	6617	6626	6628
				6629	6633	6653	6654	6668	6730	6732	6775	6776	6777	6783	6790
				6845	6850	6852	6857	6861	6863	6878	6880	6891	6907	6912	6964
				6968	6972	6977	6978	6983	6991	6992	6995	7041	7042	7093	7100
				7102	7104	7105	7107	7109	7127	7136	7219	7276	7278	7280	7282
				7284	7314	7323	7328	7330	7334	7335	7364	7366	7367	7370	7376
				7378	7391	7400	7402	7406	7408	7410	7412	7414	7416	7439	7653
				7658	7685	7688	7689	7717	7719	7723	7726	7728	7733	7740	7742
				7794	7796	7798	7914	7981	7986	7987	7990	7999	8000	8002	8003
				8005	8006	8007	8009	8010	8012	8013	8015	8016	8018	8019	8021
				8022	8023	8024	8025	8026	8028	8267	8268	8328	8350	8367	8368
				8370	8371	8394	8397	8399	8401	8404	8419	8424	8430	8454	8455
				8457	8458	8473	8476	8492	8496	8502	8516	8520	8522	8525	8535
				8537	8542	8547	8575	8582	8595	8614	8616	8622	8623	8624	8630
				8651	8654	8657	8659	8681	8684	8686	8689	8692	8713	8723	8764
				8777	8781	8784	8789	8795	8819	8825	8834	8836	8838	8850	8879
				8885	8893	8908	8910
	4T			966 #	8437	8566	8650
	5T			967 #
(U) EXT ADR			1185 #	3993	4003	4017	4037	4064	7010	7018	7522	7564	7653	7688
				7794	7912	7915	7998	8001	8008	8011	8014	8017	8020	8373	8381
				8387	8467	8708	8741	8757	8878	8914	8917
(U) FETCH			1151 #	2263	2264	2266	2267	2286	2312	2326	2332	2379	2440	2465
				3055	3361	3373	3488	3489	3492	3493	3560	3561	3587	3629	3744
				4256	4731	4740	7420	7691	7927	8836
(D) FL-B			1374 #
	AC			1375 #	5298	5301	5302	5306	5309	5310	5343	5347	5348	5372	5376
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 266
; 								Cross Reference Listing					

				5377	5422	5423	5457	5458
	BOTH			1377 #	5300	5304	5308	5312	5345	5350	5374	5379
	MEM			1376 #	5299	5303	5307	5311	5344	5349	5373	5378
(U) FLG.C			1340 #	8326	8595	8616	8723	8780	8783
(U) FLG.PI			1339 #	3657	8404	8424	8492	8502	8522	8659	8684	8689	8713	8777
				8876
(U) FLG.SN			1341 #	5546	5647	5648	5655	5782	5785	5788	5791	5851	5858	5859
(U) FLG.W			1338 #	8326	8516	8555	8614	8723	8780	8792
(U) FMWRITE			987 #	2195	2203	2205	2206	2208	2209	2211	2212	2218	2220	2524
				2556	2807	3057	3078	3113	3146	3152	3335	3424	3464	3467	3470
				3473	3476	3479	3482	3485	3698	3745	3747	3810	3815	3843	4217
				4225	4234	4236	4247	4248	4249	4251	4253	4475	4491	4492	4493
				4495	4498	4517	4519	4522	4649	4654	4659	4665	4666	4667	4728
				4745	4987	5000	5010	5020	5052	5103	5152	5216	5241	5478	5484
				5796	5804	5840	5841	5842	5849	5960	5973	5976	6001	6006	6023
				6047	6067	6068	6074	6084	6087	6094	6095	6096	6111	6122	6124
				6126	6142	6158	6160	6167	6181	6194	6201	6212	6243	6260	6262
				6297	6298	6310	6311	6318	6320	6333	6335	6344	6347	6379	6385
				6391	6396	6397	6401	6410	6416	6423	6424	6425	6584	6615	6644
				6717	6733	6763	6859	6887	6928	6952	6966	6969	6974	6981	6986
				6993	7003	7115	7224	7290	7294	7298	7302	7306	7321	7332	7353
				7356	7386	7387	7471	7472	7612	7720	7754	7760	7762	7800	7907
				7979	7994	8004	8266	8270	8287	8288	8290	8291	8298	8308	8310
				8312	8314	8318	8319	8460	8462	8483	8808
(U) FORCE EXEC			1149 #	3993	4003	4017	4037	4064	7010	7018	7508	7522	7524	7538
				7555	7564	7572	7647	7650	7686	7697	7703	7912	7915	7929	7998
				8001	8008	8011	8014	8017	8020	8373	8381	8387	8467	8708	8741
				8757	8878	8914	8917
(U) FORCE USER			1148 #	3993	4003	4017	4037	4064	7010	7018	7508	7522	7555	7564
				7647	7650	7686	7697	7703	7912	7915	7929	7998	8001	8008	8011
				8014	8017	8020	8373	8381	8387	8467	8708	8741	8757	8878	8914
				8917
(U) GENL			749 #	2264	2266	2311	2324	2325	2331	2336	2351	2352	2364	2375
				2398	2726	2757	2765	2787	2789	3373	3489	3492	3560	3561	3562
				3571	3574	3587	3599	3629	3653	3667	3795	3854	3868	3872	4017
				4029	4034	4064	4080	4131	4774	4804	5013	5072	5095	5144	5156
				5178	5182	5187	5202	5205	5215	5267	5268	5288	5290	5363	5626
				5963	5966	5969	6010	6036	6039	6055	6061	6090	6109	6115	6123
				6127	6138	6150	6154	6161	6180	6208	6285	6300	6338	6373	6390
				6417	6428	6432	6488	6494	6541	6598	6602	6637	6662	6703	6708
				6766	6885	6927	6936	7095	7121	7135	7204	7220	7222	7266	7347
				7352	7377	7411	7413	7415	7417	7429	7489	7490	7491	7492	7493
				7494	7495	7517	7587	7713	7734	7734	7915	7931	8001	8008	8011
				8014	8017	8020	8269	8545	8591	8599	8842	8848	8854	8856	8858
				8860	8862	8864	8866	8867	8868	8898	8917
(U) GENR			756 #	2455	2457	2470	2492	2493	2724	2759	2763	2780	2782	2806
				3149	3151	3422	3564	3573	3576	3578	3579	3580	3613	3618	3621
				3641	3662	3675	3806	3957	3959	3961	3963	3965	3967	3969	3971
				3979	3999	4009	4061	4077	4142	4143	4144	4166	4189	4396	4435
				4497	4551	4674	4851	4986	4994	5057	5102	5137	5141	5328	5329
				5332	5333	5357	5358	5390	5391	5451	5452	5528	5544	5647	5648
				5655	5671	5793	5828	5858	5859	5874	5956	5978	6205	6210	6279
				6295	6296	6302	6341	6343	6350	6356	6365	6384	6436	6439	6444
				6469	6475	6546	6640	6642	6712	6716	6770	6812	6816	6820	6824
				6828	6832	6848	6946	6958	7029	7038	7039	7040	7044	7045	7046
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 267
; 								Cross Reference Listing					

				7047	7052	7053	7054	7057	7058	7059	7060	7061	7062	7063	7064
				7089	7129	7132	7160	7167	7171	7186	7192	7201	7209	7231	7232
				7250	7254	7260	7285	7308	7319	7403	7405	7407	7409	7541	7743
				7788	7862	7871	7873	7875	7877	7879	7881	8262	8265	8327	8331
				8334	8339	8490	8515	8552	8556	8590	8594	8597	8608	8678	8783
				8788	8793	8799	8813	8876
(U) HALT			1317 #	8282
	BW14			1327 #	2552
	CSL			1321 #	2283	2301
	HALT			1320 #	3615
	ILLII			1324 #	7537
	ILLINT			1325 #	7569
	IOPF			1323 #	8833
	MULERR			1329 #	2226
	NICOND 5		1328 #
	POWER			1319 #	2254
(U) HOLD USER			1118 #	2252	2613	3439	3455	3522	3536	3593	3597	3633	3655	3725
				3737	3793	3823	3827	3842	3848	4043	4096	4110	4127	4137	4140
				4170	4171	4195	4245	4257	4267	4270	4377	4412	4443	4529	4678
				4680	4745	4762	4784	5036	5388	5400	5465	5753	6427	6428	7027
(D) I				1382 #	2583	2588	2593	2598	2636	2641	2646	2651	2656	2661	2666
				2671	2678	2683	2688	2693	2698	2703	2708	2713	2832	2833	2834
				2835	2843	2853	2863	2868	2878	2885	2895	2905	2915	2924	2925
				2926	2927	2935	2946	2956	2966	2975	2976	2977	2978	2990	2991
				3210	3211	3212	3213	3214	3215	3216	3217	3219	3220	3228	3229
				3230	3231	3232	3233	3234	3235	3246	3247	3248	3249	3250	3251
				3252	3253	3263	3264	3265	3266	3267	3268	3269	3270	3385	3386
				3387	3388	3389	3390	3391	3392	3497	3498	3499	3500	3501	3502
				3503	3504	3511	3512	3513	3514	3515	3516	3517	3518	3525	3526
				3527	3528	3529	3530	3531	3532	3539	3540	3551	3553	3704	3705
				3706	3707	3801	3834	3835	3836	3837	3890	3891	3892	3893	3894
				3895	3896	3897	3901	3902	3903	3904	3905	3906	3907	3908	3909
				3910	3911	3912	3913	3914	3915	3916	3917	3918	3919	3920	3921
				3922	3923	3924	3925	3926	3927	3928	3929	3930	3931	3932	3936
				3937	3938	3939	3943	3944	3945	3946	3947	3948	3949	3950	3951
				3952	3953	4089	4103	4151	4176	4343	4348	5147	5423	5887	5888
				5889	5890	5891	5892	5893	5895	5896	5897	5898	5900	5901	5902
				5903	5905	5906	5907	5908	5909	5910	5911	5912	5946	7805	7806
				7807	7809	7810	7812	7813	7815	7816	7817	7818	7819	7820	7821
				7822	7824	7825	7826	7827	7828	7829	7830	7831	7833	7834	7835
				7836	7837	7838	7839	7840	7842	7843	7844	7845	7846	7847	7848
				7849	7851	7852	7853	7854	7855	7856	7857	7858
(U) I.CO3			1213 #
(U) I.CO4			1214 #
(U) I.CO5			1215 #
(U) I.CO6			1216 #
(U) I.CO7			1217 #
(U) IO BYTE			1198 #	7648	7698	7704
(U) IO CYCLE			1192 #	7508	7555	7647	7650	7686	7697	7703	7929
(U) J				554 #	2356	2389	2393	2402	2407	2415	2436	2442	2466	2471	2492
				2493	3594	3598	4062	4065	4268	4311	4319	4329	4337	4531	4553
				4554	4556	4600	4640	4667	4769	4771	4775	4810	4843	4862	4930
				5144	5281	5282	5564	5566	5567	5656	5851	5858	5859	5874	5974
				5977	6263	6273	6278	6281	6319	6320	6470	6476	6647	6670	6735
				6766	6778	6809	6825	6842	6851	6853	6879	6914	6947	6953	6958
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 268
; 								Cross Reference Listing					

				6998	7266	7333	7357	7432	7476	7584	7587	7659	7666	7672	7729
				7737	7741	7744	7770	7782	7784	7786	7788	7790	7792	7794	7796
				7798	7800	7923	7991	7995	8029	8631	8653	8658	8664	8695	8698
				8699	8712	8721	8724	8725	8829	8917
	ABORT			8829 #	3984	8810
	ACBSET			7180 #	7162
	AC_ARX			7800 #	3869	6984
	ADD			4095 #	4088	4089	4090	4091
	ADDCRY			6278 #	6253	6259	6272
	ADJBP			4975 #	4729
	ADJBP0			4978 #	4980
	ADJBP1			4997 #	4999
	ADJBP2			5007 #	5004
	ADJBP3			5050 #	5035
	ADJBP4			5062 #	5074
	ADJBP5			5076 #	5070
	ADJBP6			5097 #	5099
	ADJSP			3805 #	3801
	ADJSP1			3822 #	3814
	ADJSP2			3827 #	3819
	AND			2849 #	2842	2843	2844	2845	2874
	ANDCA			2859 #	2852	2853	2854	2855	2911
	ANDCB			2911 #	2904	2905	2906	2907
	ANDCM			2874 #	2867	2868	2869	2870
	AOBJ			3544 #	3539	3540
	AOJ			3522 #	3511	3512	3513	3514	3515	3516	3517	3518
	AOS			3439 #	3428	3429	3430	3431	3432	3433	3434	3435
	APRID			7079 #
	APRSO			7066 #	7042
	APRSZ			7069 #	7041
	ARSIGN			2492 #	2434
	ASH			3016 #	2987
	ASHC			3119 #	2991
	ASHC1			3125 #	3123
	ASHCL			3141 #	3130	3143
	ASHCQ1			3152 #	3113	3149
	ASHCR			3134 #	3136
	ASHCX			3146 #	3138
	ASHL			3026 #	3026
	ASHL0			3023 #	3016
	ASHR			3019 #	3005
	ASHX			3030 #	3043
	ASHXX			3043 #	3048
	BACKBP			6997 #	6965	6973
	BACKD			6972 #	8859	8867	8869
	BACKS			6964 #	8866
	BADDATA			8317 #	8302
	BDABT			6441 #	6377
	BDCFLG			6443 #	6422
	BDEC			6325 #
	BDEC0			6331 #	6329
	BDEC1			6338 #	6347
	BDEC2			6343 #	6351
	BDEC3			6353 #	6339	6361
	BDEC4			6358 #	6353
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 269
; 								Cross Reference Listing					

	BDEC5			6370 #	6356	6366
	BDECLP			6408 #	6427
	BDFILL			6392 #	6401
	BDSET			6416 #	6436	6439
	BDSUB			6455 #	6359	6409
	BDSUB1			6459 #	6456
	BDSUB2			6475 #	6478
	BDTBL			6432 #	6415
	BITCHK			6946 #	5952	5995	6133	6135	6492
	BIXUB			7625 #	7618	7619	7620	7621
	BIXUB1			7634 #	7630	7632
	BLT			5151 #	5147
	BLT-CLEANUP		5212 #	8851
	BLTBU1			5266 #	5247
	BLTCLR			5171 #	5186
	BLTGOT			5199 #	5174
	BLTGO			5197 #	5163	5191
	BLTLP			5194 #	5209
	BLTLP1			5160 #	5196
	BLTX			5239 #	7868
	BLTXLP			5243 #	5292
	BLTXV			5278 #	5264
	BLTXW			5284 #	5279
	BOTH			2364 #
	BWRITE			2503 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	4096	4110	4162
				4168	4191	4193	8601	8901
	BYTEAS			4782 #	4806	6889
	BYTEA			4784 #	4739	4758
	BYTEA0			4787 #	4783
	BYTFET			4808 #	4790	4794	6931	6932
	BYTIND			4802 #	4798
	CAIM			3405 #	3386	3387	3388	3389	3390	3391	3392	3394	3395	3396	3397
				3398	3399	3400	3401
	CHKSN			5851 #	5832
	CLARXL			7788 #	5135	7562
	CLARX0			6469 #	4678	4680	4684	4685	6200	6334	6460
	CLDISP			8844 #	6966	6974	6987	6993	8839
	CLEANED			8847 #	5217	8841
	CLEANUP			8846 #	8844
	CLRB1			6320 #	6318
	CLRBIN			6318 #	6203	6299
	CLRFLG			6956 #	5999	6371
	CLRPTL			7453 #	7456
	CLRPT			7444 #
	CLRSN			5859 #	5637	5727
	CMPDST			6184 #	6164
	CMS			6132 #
	CMS2			6173 #	6143
	CMS3			6149 #	6175	6179
	CMS4			6152 #
	CMS5			6178 #	6157
	CMS6			6164 #	6181
	CMS7			6169 #	6166
	CMS8			6180 #	6178
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 270
; 								Cross Reference Listing					

	CMSDST			6968 #	8865
	COM0			4667 #	4662	4663
	COM0A			4662 #	4666
	COM1			4666 #	4657
	COM1A			4657 #	4665
	COM2			4665 #	4652
	COM2A			4652 #
	CONSO			7067 #	7049
	CONSZ			7073 #	7048
	CONT			7926 #	7921
	CONT1			7933 #	4083
	CPYSGN			4142 #	4128	4138
	DAC			2524 #	2531	2801	6441
	DADD			4122 #	4117
	DADD1			4125 #	4131
	DBABT			6284 #	6220	6224
	DBDN1			6297 #	6295
	DBDONE			6292 #	6286	6311
	DBFAST			6237 #	6233
	DBIN			6193 #
	DBIN1			6208 #	6211
	DBIN2			6212 #	6208
	DBINLP			6216 #	6234	6244
	DBLDBL			6268 #	6256	6267
	DBLDIV			4618 #	4472	4482	5755	5759
	DBLMUL			4262 #	4233
	DBLNEG			4674 #	2816
	DBLNGA			4675 #	2806
	DBLNG1			4683 #	4397	6343
	DBNEG			6302 #	6291
	DBSLOW			6249 #	2217	6231
	DBSLO			6230 #	6238
	DBXIT			6290 #	6218
	DDIV			4424 #	4419
	DDIV1			4441 #	4428	4432
	DDIV2			4444 #	4442
	DDIV3A			4449 #	4454
	DDIV3			4445 #	4439
	DDIV4			4457 #	4450
	DDIV5A			4471 #	4462
	DDIV5B			4495 #	4486
	DDIV5C			4497 #	4492
	DDIV5			4465 #	4461
	DDIV6			4500 #	4493	4495
	DDIV7			4502 #
	DDIV8A			4511 #
	DDIV8			4509 #	4502
	DDIV9			4517 #	4512
	DDIVS			4531 #	4458	4476	5751
	DFAD			5585 #	5572
	DFADJ			5636 #	5601	5609
	DFADJ1			5643 #	5644
	DFADJ2			5645 #
	DFADJ3			5651 #	5647	5651
	DFADJ4			5652 #	5648
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 271
; 								Cross Reference Listing					

	DFADJ5			5654 #	5646	5655
	DFADJ6			5656 #	5654
	DFAS1			5594 #	5590	5592
	DFAS2			5601 #	5595
	DFAS3			5606 #	5597
	DFAS5			5615 #	5603	5611
	DFAS6			5620 #	5621
	DFAS7			5622 #	5620
	DFDV			5725 #	5722
	DFDV1			5731 #	5738
	DFDV2			5739 #	5732
	DFDV3			5750 #	5742
	DFDV4A			5765 #	5768
	DFDV4B			5770 #	5767
	DFDV4			5752 #	5748
	DFMP			5666 #	5661
	DFMP1			5668 #	5669
	DFMP2			5694 #	5691
	DFPR1			2457 #	2451
	DFPR2			2458 #	2456
	DFSB			5582 #	5573
	DIV			4363 #	4347	4348	4349	4350
	DIV1			4372 #	4358	4360	4414
	DIV2			4375 #	4388
	DIVA			4384 #	4370
	DIVB			4390 #	4385
	DIVC			4403 #	4395	4400
	DIVHI			4625 #	4619	4622	4636
	DIVIDE			4590 #	4590
	DIVSET			4584 #	4580
	DIVSGN			4570 #	4552	5406
	DIVSUB			4549 #	4376	5009	5019	5053
	DMLINT			4270 #	4235
	DMOVNM			2816 #	2811
	DMOVN			2806 #	2802
	DMOVN1			2818 #	2810
	DMTRAP			4254 #	4248
	DMUL			4206 #	4201
	DMUL1			4227 #	4216
	DMUL2			4232 #	4226
	DMULGO			4261 #	4214
	DNEG			5808 #	5782	5785	5788	5791
	DNEG1			5810 #	5808
	DNEG2			5812 #	5809
	DNN1			5838 #	5834
	DNN2			5840 #	5836
	DNNORM			5818 #	5771	5813	5815	5820	5848
	DNNRM1			5845 #	5828
	DNORM			5779 #	5717	5770	5781	5803
	DNORM0			5716 #	5626
	DNORM1			5800 #	5793
	DNORM2			5842 #	5840
	DOCVT			6330 #	6380	6396
	DOCVT1			6405 #	6330
	DOCVT2			6426 #	6406
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 272
; 								Cross Reference Listing					

	DOCVT3			6423 #	6445
	DONE			2263 #	2563	2577	2877	2878	3057	3210	3211	3219	3220	3320	3364
				3367	3370	3385	3497	3748	3856	3873	4257	4762	5104	5179	5203
				5288	7073	7116	7188	7290	7294	7298	7302	7306	7354	7378	7388
				7439	7473	7612
	DPB			4751 #	4724
	DPB1			4922 #	4761	6913
	DPB7			4929 #	4923	4924	4925	4926	4927	4951
	DPBSLO			4933 #	4922
	DRND1			5874 #	5870	5878	5881
	DROUND			5868 #	5784	5787	5790	5822	5824	5826	5872
	DSMS1			7586 #	7583	7588
	DSTEA			6931 #	6937
	DSTIND			6936 #	6933	6934
	DSUB			4134 #	4118
	DUMP			7998 #	7982	7989
	DVSUB1			4576 #	4573
	DVSUB2			4577 #	4571
	DVSUB3			4579 #	4583
	EACALC			2318 #	2381
	EAPF			8908 #	8888
	EAPF1			8913 #	8895
	EDBYTE			6668 #	6631	6659
	EDEXMD			6579 #	6550
	EDFILL			6595 #
	EDFIL1			6610 #	6597
	EDFLT			6626 #	6572	6616
	EDFLT1			6644 #	6640	6642
	EDISP			6509 #	6503
	EDISP1			6511 #	6511
	EDIT			6488 #
	EDITLP			6493 #	6717
	EDMSG			6653 #	6518
	EDMSG1			6662 #	6655
	EDN1A			6699 #	6704
	EDNOP			6688 #	6520	6522	6524	6538	6547	6573	6584	6605	6611	6664	6665
				6679
	EDNOP1			6689 #	6683
	EDNOP2			6706 #	6700	6706
	EDOPR			6538 #	6515
	EDSEL			6589 #	6542
	EDSFLT			6615 #	6599
	EDSKP			6676 #	6527	6530	6532
	EDSKP1			6680 #	6677
	EDSPUT			6602 #	6610	6620
	EDSSIG			6572 #	6544
	EDSTOP			6557 #	6540	6600
	EDSTP1			6563 #	6566
	ENDSKP			6300 #	6124
	EQV			2921 #	2914	2915	2916	2917
	EXCH			2623 #	2619
	EXTDSP			5964 #
	EXTEA			5963 #
	EXTEA0			5960 #	5958
	EXTEA1			5961 #	5969
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 273
; 								Cross Reference Listing					

	EXTEND			5950 #	5946
	EXTEXT			5973 #	5965	5979
	EXTIND			5969 #	5966
	FAD			5321 #	5298	5299	5300	5301	5302	5303	5304
	FAS1			5323 #
	FAS2			5332 #	5323
	FAS3			5335 #	5328	5329	5332	5333
	FAS4			5337 #	5337
	FDV			5384 #	5372	5373	5374	5376	5377	5378	5379
	FDV0			5390 #	5387
	FDV1			5392 #	5390
	FDV2			5393 #	5391
	FDV3			5394 #	5392	5393
	FDV4			5396 #	5397
	FDV5			5399 #	5396
	FDV6			5402 #	5399
	FDV7			5406 #	5407
	FDV8			5409 #
	FDV9			5417 #	5409	5414	5415
	FETIND			2374 #	2339	2344	2366
	FIX			5462 #	5457	5458
	FIX++			4594 #	4595
	FIX1++			4596 #	4594
	FIXL			5477 #	5467	5477
	FIXPC			8842 #	4270	6457
	FIXR			5472 #	5473
	FIXT			5484 #	5481
	FIXX			5481 #	5474
	FIXX1			5482 #	5488
	FL-BWRITE		2550 #	5482	5486	5532	5554
	FLEX			5532 #	5528
	FLTR			5427 #	5422
	FLTR1A			5435 #	5432
	FLTR1			5431 #	5428
	FLTR2			5440 #	5433	5435
	FLTR3			5442 #	5443
	FMP			5354 #	5343	5344	5345	5347	5348	5349	5350
	FMP1			5359 #	5357	5358
	FP-LONG			3969 #	3947	3948	3949	3950	3951	3952
	FPR0			2431 #	2425
	FPR1			2435 #
	FSB			5318 #	5306	5307	5308	5309	5310	5311	5312
	FSC			5448 #	5423
	GETPCW			7260 #	4015
	GETSRC			6880 #	6155	6590
	GOEXEC			4039 #	8915
	GRP700			7078 #	7034
	GRP701			7052 #	7035
	GRP702			7275 #	7271
	GSRC			6878 #	6112	6765
	GSRC1			6887 #	6883
	GTFILL			6950 #	5992	6489
	GTPCW1			7264 #	7255	7264
	H1			7917 #	7983
	HALT			3613 #	3565
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 274
; 								Cross Reference Listing					

	HALTED			7907 #	2226	2283	2301	2552	3615	7537	7569	8282	8833
	HALTLP			7923 #	7917
	HARD			8808 #	7776	8304	8306	8320
	HLL			2726 #	2635	2636	2679	2751
	HLLE			2792 #	2665	2666	2667	2668
	HLLO			2796 #	2655	2656	2657	2658
	HLLZ			2794 #	2645	2646	2647	2648
	HLR			2753 #	2682	2683
	HLRE			2785 #	2712	2713	2714	2715
	HLRM			2762 #	2684
	HLRO			2789 #	2702	2703	2704	2705
	HLRS			2765 #	2685
	HLRZ			2787 #	2692	2693	2694	2695
	HRL			2751 #	2640	2641
	HRLE			2778 #	2670	2671	2672	2673
	HRLM			2756 #	2642
	HRLO			2782 #	2660	2661	2662	2663
	HRLS			2759 #	2643
	HRLZ			2780 #	2650	2651	2652	2653
	HRR			2724 #	2637	2677	2678	2753
	HRRE			2771 #	2707	2708	2709	2710
	HRRO			2775 #	2697	2698	2699	2700
	HRRZ			2773 #	2687	2688	2689	2690
	HSBDON			8025 #
	IBP			4727 #	4720
	IBPS			4768 #	4730	4735	4749
	IBPX			4775 #	3866	4768	8663
	IDIV			4354 #	4342	4343	4344	4345
	IDPB			4749 #	4723
	IDST			6924 #	6185	6908
	IDSTX			6928 #	6925
	ILDB			4735 #	4721
	IMUL			4156 #	4150	4151	4152	4153
	IMUL1			4162 #	4379
	IMUL2			4164 #	4161
	IMUL3			4170 #	4167
	INCAR			7790 #	6086	7542
	INCPC			2311 #	2306
	INDEX			2351 #
	INDRCT			2369 #
	IOEA			7713 #	7645	7683
	IOEA1			7719 #	7721
	IOEA2			7723 #	7719
	IOEAI			7731 #	7724
	IOEAX			7740 #	7727
	IOR			2901 #	2894	2895	2896	2897	2962
	IORD			7644 #	7600	7611	7626
	IORD1			7653 #	7649
	IORD2			7663 #	7658
	IORD3			7669 #	7664	7670
	IOT700			7862 #	7805	7806	7807
	IOT710			7864 #	7809	7810
	IOT720			7871 #	7812	7813
	IOT730			7873 #	7815	7816	7817	7818	7819	7820	7821	7822
	IOT740			7875 #	7824	7825	7826	7827	7828	7829	7830	7831
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 275
; 								Cross Reference Listing					

	IOT750			7877 #	7833	7834	7835	7836	7837	7838	7839	7840
	IOT760			7879 #	7842	7843	7844	7845	7846	7847	7848	7849
	IOT770			7881 #	7851	7852	7853	7854	7855	7856	7857	7858
	IOW1			7753 #	7758
	IOW2			7765 #	7755	7761
	IOW3			7768 #	7775
	IOW4			7773 #	7769
	IOW5			7776 #	7763
	IOWAIT			7749 #	7654	7690
	IOWR			7682 #	7615	7635
	IOWR1			7688 #	7698	7704
	IOWR2			7695 #	7685
	IOWR3			7701 #	7696	7702
	ITRAP			8288 #	6088
	JEN			3621 #	3575
	JEN1			7583 #	3627	3642
	JEN2			3627 #	3619
	JFCL			3633 #	3553
	JFFO			3051 #	2990
	JFFO1			3059 #	3056
	JFFOL			3073 #	3075
	JMPA			3476 #	3884
	JRA			3878 #	3837
	JRST			3560 #	3501	3551
	JRST0			3589 #	3586	3610	3625
	JRST1			3607 #	3602	3606
	JRST10			3618 #	3572
	JRSTF			3583 #	3563
	JSA			3862 #	3836
	JSP			3841 #	3835
	JSR			3847 #	3834
	JSTAC			3742 #	3732	3739	3777
	JSTAC1			3745 #	3796
	JSYS			3963 #	3944
	JUMP			3508 #	3498	3499	3500	3502	3503	3504
	JUMP-TABLE		3461 #	3508	3522	3536	3546
	JUMP-			3488 #	3467	3470	3473	3636
	JUMPA			3492 #	3476	3479	3482	3485	3844	4045
	KIEPT			8754 #	8748	8751
	KIF10			8745 #	8738
	KIF30			8762 #	8743	8758
	KIF40			8769 #	8773
	KIF50			8777 #	8771	8800	8815
	KIF80			8798 #
	KIF90			8803 #	8794
	KIFILL			8733 #	8360
	KIMUUO			4051 #	3994
	KIUPT			8739 #	8761
	L-BDEC			5924 #	5897	5898
	L-CMS			5918 #	5887	5888	5889	5891	5892	5893
	L-DBIN			5922 #	5895	5896
	L-EDIT			5920 #	5890
	L-MVS			5926 #	5900	5901	5902	5903
	L-SPARE-A		5930 #	5906
	L-SPARE-B		5932 #	5907
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 276
; 								Cross Reference Listing					

	L-SPARE-C		5934 #	5908	5909	5910	5911	5912
	L-XBLT			5928 #	5905
	LDB			4737 #	4722
	LDB1			4824 #	4744	6188	6893
	LDB7			4838 #	4829	4830	4831	4832	4833
	LDBSH			4853 #	4848
	LDBSWP			4847 #	4826
	LDPI2			7429 #	3628	7418
	LOADAR			7781 #	6434	6497	6580	7715
	LOADARX			7784 #	6789	7349
	LOADPI			7428 #	2229
	LOADQ			7786 #	5153	6141
	LSH			3000 #	2989
	LSHC			3102 #	2993
	LSHCL			3110 #	3102	3110
	LSHCR			3106 #	3106
	LSHCX			3112 #	3107	3179	3184
	LSHL			3007 #	3002
	LUUO			4069 #	3890	3891	3892	3893	3894	3895	3896	3897
	LUUO1			4072 #	5918	5920	5922	5924	5926	5928	5930	5932	5934
	MAP			8260 #	8256
	MAPDON			8898 #	8853
	MOVE			2610 #	2584	2607	2614	2638	2680	2862	2863	2864	2865	2879	2880
				4143	4144	4170	4171	4195	5005
	MOVELP			6030 #	6010	6039
	MOVF1			6730 #	6736
	MOVFIL			6736 #	6062	6123
	MOVLP0			6039 #	6024
	MOVM			2607 #	2597	2599	2600
	MOVN			2612 #	2592	2593	2594	2595
	MOVPAT			6505 #	6500	6502	6505
	MOVRJ			6060 #	6016
	MOVS			2604 #	2587	2588	2589	2590	2757	2763	2780	2782	2787	2789
	MOVSTX			6113 #
	MOVST0			6108 #	6013
	MOVST1			6109 #	6064	6119
	MOVST2			6122 #	6033	6114
	MOVST3			6126 #	6122
	MOVST4			6118 #	6075
	MSKPAT			6506 #	6501
	MUL			4183 #	4175	4176	4177	4178
	MUL+			4305 #	4289	4301	4307	4325
	MUL-			4323 #	4315	4333
	MULBY4			6267 #	6250
	MULSB1			4287 #	5677
	MULSUB			4286 #	4159	4187	5080	5361
	MULTIPLY		4298 #	4266	5682	5694	5701
	MUUO			3976 #	3901	3902	3903	3904	3905	3906	3907	3908	3909	3910	3911
				3912	3913	3914	3915	3916	3917	3918	3919	3920	3921	3922	3923
				3924	3925	3926	3927	3928	3929	3930	3931	3932
	MVABT			6044 #	6035
	MVABT1			6047 #	6049
	MVABT2			6051 #	6047
	MVEND			6054 #
	MVS			5989 #
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 277
; 								Cross Reference Listing					

	MVS1			6006 #	6004
	MVSK2			6094 #	6068
	MVSK3			6084 #	6080
	MVSKP			6067 #	6060	6078	6091	6102
	MVSKP1			6078 #	6073
	MVSKP2			6090 #	6082
	MVSO			6018 #	6011
	MVSO1			6021 #	6021
	NEXT			4064 #	4005	4009	4052	7999	8002	8004	8006	8009	8012	8015	8018
				8021	8023
	NEXTAR			8917 #	8881	8909
	NICOND			2272 #	2557	3078	3124	3152	3464	3746	3822	3829	4520	4523	5478
				5484	5843	8270
	NICOND-FETCH		2291 #	2263	2264	2266	2267	2327	2333	3361	3373	3488	3489	3492
				3493	3560	3561	3587	3629	4256	4731	7420	7691
	NIDISP			3124 #	3824	3828	4377	4412	4443	4529	4746	5036	5388	5400	5465
				5753
	NODDIV			4528 #	4465	4467
	NODIV			4412 #	4406	4410
	NOMOD			2355 #
	NXTWRD			4774 #	4770
	ORCA			2941 #	2934	2935	2936	2937
	ORCB			2972 #	2965	2966	2967	2968
	ORCM			2962 #	2955	2956	2957	2958
	PAGE-FAIL		8286 #
	PF100			8542 #	8519
	PF105			8550 #	8546
	PF107			8523 #	8553	8557
	PF110			8560 #	8526
	PF120			8603 #	8583
	PF125			8622 #	8620	8826
	PF130			8585 #	8581	8587
	PF140			8579 #
	PF25			8343 #	8345
	PF30			8367 #	8356
	PF35			8380 #	8369
	PF40			8385 #	8377
	PF45			8392 #	8412	8491
	PF50			8424 #	8396
	PF60			8408 #	8410
	PF70			8430 #
	PF75			8442 #	8444
	PF76			8465 #	8461	8463
	PF77			8470 #	8374	8382
	PF80			8502 #	8475
	PF90			8514 #
	PFD			8294 #	8296
	PFDBIN			6991 #	8863
	PFDONE			8575 #	8801	8805
	PFGAC0			6993 #
	PFMAP			8324 #	8269	8308	8312	8314
	PFPI1			8817 #	8298	8310
	PFPI2			8825 #
	PFT			8833 #	8404	8424	8492	8502	8522	8659	8684	8689	8713	8777
	PFT1			8834 #	8822
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 278
; 								Cross Reference Listing					

	PFT10			8877 #	8875
	PFT1A			8841 #	8837
	PFT2			8873 #	8849
	PFT3			8876 #	8902
	PFTICK			8535 #	8484
	PI			7486 #	7488	8876
	PI10			7504 #	7496	7497	7498	7499	7500	7501	7502
	PI40			7522 #	7519
	PI50			7523 #	7573
	PIEXIT			7418 #	3657
	PIJSR			7537 #	7526
	PIP1			7496 #	7489
	PIP2			7497 #	7490
	PIP3			7498 #	7491
	PIP4			7499 #	7492
	PIP5			7500 #	7493
	PIP6			7501 #	7494
	PIP7			7502 #	7495
	PISET			3656 #	7544
	PIXPCW			3665 #	7529
	POP			3752 #	3706
	POPJ			3785 #	3707
	POPX1			3780 #	3768
	PTRIMM			8473 #
	PTRIND			8481 #	8538
	PTRSHR			8495 #	8477
	PUSH			3712 #	3705
	PUSH1			3714 #	3726
	PUSHJ			3724 #	3704
	PUTDST			6906 #	6037	6116	6398	6417	6603	6638	6663	6731
	PWRON			7912 #	2255
	QDNEG			4648 #	4452	4528
	QMULT			4265 #	4223	4243
	Q_RSH			5282 #	5254	5274
	RDAPR			7127 #
	RDCSB			7278 #
	RDCSTM			7282 #
	RDEBR			7245 #
	RDEBR1			7247 #	7247
	RDERA			7044 #
	RDHSB			7284 #
	RDINT			7391 #
	RDIO			7611 #	7604	7606
	RDPI			7397 #
	RDPT			8706 #	8400	8411	8418	8495	8652
	RDPUR			7280 #
	RDSPB			7276 #
	RDTIME			7360 #	7374
	RDTIM1			7376 #	7373
	RDUBR			7254 #
	ROT			3035 #	2988
	ROTC			3174 #	2992
	ROTCL			3182 #	3174	3182
	ROTCR			3178 #	3178
	ROTL			3045 #	3037
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 279
; 								Cross Reference Listing					

	RTNREG			7438 #	7090	7140	7251	7276	7278	7280	7282	7284	7392	7397
	RTNRG1			7439 #	7257
	SAVVMA			7993 #	7908	7980
	SBRL			7792 #	5403	6242
	SECIMM			8394 #
	SECSHR			8418 #	8398
	SETBLT			5131 #	5151	5240
	SETCA			2931 #	2924	2925	2926	2927
	SETCM			2952 #	2945	2946	2947	2948	2972
	SETO			2982 #	2975	2976	2977	2978
	SETPDL			3737 #	3782
	SETPTR			8675 #	8393	8472
	SETSN			5858 #	5411	5413	5708
	SETUBR			7191 #	7182
	SETZ			2839 #	2832	2833	2834	2835
	SFM			3675 #	3577
	SHDREM			8721 #	8456	8459
	SHIFT			2411 #	2421
	SKIP			2266 #	3376	3379	3382	6300	6428	7067
	SKIP-COMP-TABLE		3358 #	3405	3424	3425	6151
	SKIPE			3367 #	6127
	SKIPS			3422 #	3411	3412	3413	3414	3415	3416	3417	3418	3441
	SNNEG			5535 #	5520	5522	5524	5526
	SNNORM			5539 #	5535	5537	5539	5543
	SNNOT			5550 #	5546
	SNNOT1			5553 #	5548
	SNNOT2			5554 #	5550	5552	5553
	SNORM			5519 #	5338	5367	5444	5519	5531
	SNORM0			5444 #	5417	5429	5436	5451	5452
	SNORM1			5531 #	5527
	SOJ			3536 #	3525	3526	3527	3528	3529	3530	3531	3532
	SOS			3455 #	3444	3445	3446	3447	3448	3449	3450	3451
	SRCMOD			6763 #	6031	6216	6858	6862	6864
	SRND1			5564 #	5561
	SROUND			5561 #	5521	5523	5525	5540	5541	5542	5562
	SSWEEP			7475 #	7448	7461
	STAC			2556 #	2525	2569	2574	2582	2583	2598	2627	2807	3008	3021	3030
				5797	5804	5849	6055	6563	7896
	STAC34			6310 #	6305
	STBOTH			2567 #
	STBTH1			2572 #	2520
	STDBTH			2529 #
	STMAC			3729 #	3721
	STMEM			2561 #	7903
	STOBR			7796 #	3666	4018	7540
	STOPC			7798 #	3669	7916
	STORE			2575 #	2827	3677
	STPF1A			6989 #	6981
	STPTR1			8686 #	8683
	STPTR2			8692 #	8688
	STPTR3			8698 #	8694
	STRPF			6977 #	8855	8857
	STRPF0			6978 #	6995
	STRPF1			6981 #
	STRPF2			6992 #	6989
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 280
; 								Cross Reference Listing					

	STRPF3			6986 #
	STRPF4			6995 #	8861
	STRTIO			7794 #	7510	7558	7932
	STSELF			2519 #	2585
	STUBRS			7195 #	7197
	SUB			4109 #	4102	4103	4104	4105
	SWEEPL			7466 #	7469
	SWEEP			7460 #	7211	7231	7232
	T1LSH			5281 #	5252	5272
	TDONE			3335 #	3326	3329
	TDX			3306 #	3214	3223	3228	3232	3237	3241	3246	3250	3255	3259	3263
				3267	3272	3276
	TDXX			3311 #	3212	3216	3221	3225	3230	3234	3239	3243	3248	3252	3257
				3261	3265	3269	3274	3278
	TENLP			2215 #	2222
	TEST-TABLE		3317 #	3306	3312	7601
	TICK			7314 #	6097
	TIOX			7600 #	7593	7594	7595	7596
	TOCK			7317 #	7371	8536	8821
	TOCK1			7321 #	7327
	TOCK2			7328 #	7322
	TOCK3			7332 #	7339
	TRAP			7002 #	2276	2279	2282	2294	2297	2300
	TRNAR			6784 #	6593
	TRNFNC			6806 #	6794	6813	6817	6821	6833
	TRNNS1			6856 #	6846
	TRNNS2			6859 #	6856
	TRNRET			6838 #	6807
	TRNSIG			6819 #	6829
	TRNSS			6845 #	6840
	TRNSS1			6841 #	6849
	TRP1			7021 #	7011	7019
	TSX			3304 #	3215	3224	3229	3233	3238	3242	3247	3251	3256	3260	3264
				3268	3273	3277
	TSXX			3309 #	3213	3217	3222	3226	3231	3235	3240	3244	3249	3253	3258
				3262	3266	3270	3275	3279
	TXXX			3320 #	3335
	TXZX			3334 #	3323
	UMOVEM			7899 #	7887
	UMOVE			7891 #	7886
	UPCST			8650 #	8429	8505
	UUO			3975 #	3936	3943
	UUO101			3957 #	3937
	UUO102			3959 #	3938
	UUO103			3961 #	3939
	UUO106			3965 #	3945
	UUO107			3967 #	3946
	UUO247			3971 #	3953
	UUOFLG			4060 #	4000	4054
	UUOGO			3981 #	2470	3564	3573	3576	3578	3579	3580	3613	3618	3621	3641
				3662	3675	3957	3959	3961	3963	3965	3967	3969	3971	6946	7029
				7038	7039	7040	7044	7045	7046	7047	7052	7053	7054	7057	7058
				7059	7060	7061	7062	7063	7064	7285	7308	7403	7862	7871	7873
				7875	7877	7879	7881
	UUOPCW			4012 #	4057
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 281
; 								Cross Reference Listing					

	VECINT			7551 #	7514	7554
	VECIN1			7570 #	7568
	WRAPR			7093 #
	WRAPR1			7112 #	7124
	WRAPR2			7118 #	7111
	WRCSB			7292 #
	WRCSTM			7300 #
	WRCST			8662 #	8438	8567
	WREBR			7214 #
	WREBR1			7216 #	7216
	WRHSB			7304 #
	WRINT			7384 #
	WRIO			7615 #	7605	7607
	WRPI			7400 #
	WRPUR			7296 #
	WRSPB			7288 #
	WRTHSB			7986 #	7910
	WRTIME			7344 #
	WRTIM1			7356 #	7325	7352
	WRUBR			7151 #
	XCT			3686 #	3682
	XCT1			3698 #	3692	7028	7936
	XCT1A			3688 #	3696
	XCT2			2378 #	3699
	XCTGO			2303 #	2287	7928
	XJEN			3641 #	3569
	XJRSTF			3648 #	3568	3671
	XJRSTF0			3567 #	3645
	XLATE			6783 #	6769
	XLATE1			6792 #	6796
	XOR			2891 #	2884	2885	2886	2887
	XOS			3440 #	3455
	XPCW			3662 #	3570
	ZAPPTA			7471 #	7457
(D) J				1379 #
(U) JFCLFLG			1138 #	3633
(U) LD FLAGS			1142 #	2253	3592	3596	3654	4042	7528	7543	8839
(U) LD PCU			1130 #	4044
(U) LDVMA			1181 #	2196	2215	2219	2263	2263	2264	2266	2267	2267	2285	2311
				2326	2332	2338	2342	2365	2369	2378	2398	2440	2450	2453	2465
				2819	2823	2824	3055	3361	3361	3373	3488	3488	3489	3492	3493
				3493	3560	3561	3562	3567	3571	3574	3587	3600	3603	3629	3644
				3650	3665	3667	3667	3676	3716	3743	3753	3765	3770	3786	3849
				3880	3992	3993	3993	4002	4003	4003	4017	4017	4036	4037	4064
				4064	4073	4080	4081	4256	4256	4731	4731	4740	4787	4791	4795
				4799	5132	5160	5168	5182	5183	5187	5188	5205	5206	5284	5290
				5290	5964	5966	5967	5990	6138	6387	6414	6459	6465	6472	6488
				6493	6549	6627	6669	6784	6931	6932	6933	6934	7010	7018	7151
				7256	7347	7372	7377	7377	7420	7420	7438	7444	7507	7522	7522
				7522	7523	7564	7564	7572	7653	7688	7691	7691	7713	7735	7794
				7891	7899	7909	7912	7912	7915	7915	7926	7982	7998	7998	8001
				8001	8008	8008	8011	8011	8014	8014	8017	8017	8020	8020	8027
				8324	8372	8373	8373	8380	8381	8381	8385	8387	8465	8467	8609
				8625	8706	8708	8740	8741	8755	8757	8823	8829	8877	8878	8878
				8914	8914	8917	8917
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 282
; 								Cross Reference Listing					

(U) LOADFE			985 #	2414	2432	2447	3001	3004	3008	3018	3020	3036	3039	3042
				3047	3059	3074	3120	4738	4742	4754	4847	4852	4854	4856	4859
				4922	4935	4938	4939	4941	4943	5251	5253	5271	5273	5281	5282
				5327	5355	5364	5366	5386	5392	5393	5407	5429	5433	5435	5436
				5450	5519	5523	5525	5531	5539	5541	5542	5543	5562	5567	5608
				5623	5625	5689	5706	5717	5740	5766	5780	5787	5790	5802	5819
				5824	5826	5847	5872	5880	6018	6019	6021	6187	6558	6559	6565
				6689	6690	6691	6692	6889	6892	6911	6929
(U) LOADSC			983 #	2210	2220	2413	2432	2447	2463	3024	3026	3102	3103	3104
				3106	3110	3120	3129	3132	3136	3143	3174	3175	3176	3178	3182
				4157	4185	4222	4242	4262	4288	4300	4306	4314	4324	4332	4375
				4472	4480	4587	4590	4630	4976	4979	4992	4998	5003	5016	5032
				5077	5092	5098	5321	5325	5326	5335	5337	5359	5406	5440	5443
				5448	5466	5467	5468	5470	5473	5477	5587	5597	5607	5641	5644
				5651	5666	5669	5677	5681	5684	5694	5700	5755	5756	6332	6361
				6500	6502	6505	6509	6511	6682	6688	6694	6699	6706	7193	7196
				7214	7216	7245	7247	7255	7261	7264	7455	7468	7475	7663	7670
				7695	7701	7749	7756	7765	7769	8341	8344	8392	8406	8409	8440
				8443	8580	8586
(U) LSRC			635 #
(U) MACRO%
	ABORT MEM CYCLE		2034 #	2196	3644	7507	7909	7982	8324	8823	8829
	AC			1884 #	4156	4183	4354	4445	5384	5449	5590	5592
	AC[]			1885 #	4521	5729	5737	6240	6304
	AC[]_Q			1786 #	3152	4217	4225	4236	4248
	AC[]_Q.AND.[]		1775 #	4475	4519	4649	4654	4659	4665	4666
	AC[]_[]			1762 #	2524	2807	3078	4492	4498	5804	5849	6047	6067	6084	6167
				6201	6260	6262	6297	6310	6311	6347	6379	6385	6396	6401	6424
				6425	6584	6887	6928	6966	6974	6981	6986
	AC[]_[] TEST		1763 #	6859
	AC[]_[] VIA AD		1760 #
	AC[]_[]*2		1765 #	4234
	AC[]_[]+1		1764 #	6733
	AC[]_[]+Q		1770 #
	AC[]_[]+[]		1772 #	4517	6243
	AC[]_[]-[]		1771 #	6001
	AC[]_[].AND.[]		1774 #	4495	5796	5842
	AC[]_[].EQV.Q		1776 #	4249	4251	4253	4522
	AC[]_-Q			1782 #
	AC[]_-[]		1777 #
	AC[]_.NOT.[]		1780 #
	AC[]_0			1784 #	2208	3057	4493	6074	6122	6318	6320
	AC[]_1			1785 #	2209
	AC_-[]			1778 #	5841
	AC_.NOT.[]		1781 #	5840
	AC_Q			1783 #	4491
	AC_[]			1766 #	2556	3113	3335	3424	3464	3476	3745	3747	3843	4667	4745
				5152	5216	5241	5478	5484	6124	6160	6423	6644	6717	6993	7612
				7800	8270
	AC_[] TEST		1767 #	3467	3470	3473	3479	3482	3485	4247	6298	6344
	AC_[] VIA AD		1761 #
	AC_[]+1			1768 #	6969
	AC_[]+Q			1769 #
	AC_[]+[]		1773 #	3146	3810	3815
	AC_[].OR.[]		1779 #	5103	6087	6126
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 283
; 								Cross Reference Listing					

	AD FLAGS		2062 #	2613	3439	3455	3522	3536	4096	4110	4127	4137	4140	4267
				4678	4680
	AD FLAGS EXIT		2110 #	4096	4110
	AD PARITY		1988 #	2216	2392	2405	2406	2623	2724	2726	2757	2763	2816	3000
				3003	3017	3051	3508	3752	3785	3807	3865	3878	4185	4227	4364
				4755	5151	5239	5321	5354	5386	5450	5596	5993	5996	6011	6014
				6044	6060	6132	6134	6152	6184	6196	6199	6227	6230	6232	6239
				6249	6290	6292	6293	6325	6330	6331	6332	6353	6358	6370	6405
				6490	6548	6589	6626	6628	6732	6845	6852	6878	6880	6907	6964
				6972	6978	7615	7902
	ADD .25			2019 #	2612	2982	3405	3455	3536	3562	3571	3574	4109	4126	4134
				4139	4313	4317	4359	4403	4436	4459	4460	4466	4487	4513	4554
				4555	4556	4572	4574	4581	4587	4618	4648	4653	4658	4663	4675
				4679	4683	4685	5014	5071	5088	5138	5157	5175	5199	5287	5318
				5393	5396	5397	5404	5415	5428	5520	5522	5524	5526	5537	5553
				5582	5621	5734	5745	5752	5768	5809	5814	5835	5841	5875	6001
				6034	6048	6069	6136	6172	6173	6174	6221	6285	6303	6306	6374
				6391	6399	6418	6426	6427	6461	6463	6466	6514	6856	6977	6985
				6991	7329	7429	7453	7466	7713	8735	8745	8842	8902
	ADL PARITY		1981 #
	ADR PARITY		1985 #
	AREAD			2105 #	2356
	ASH			1996 #	2460	3020
	ASH AROV		2047 #	3026	3142	3145
	ASH36 LEFT		3013 #	3026
	ASHC			2001 #	3026	3135	3138	3142	3145	4306	4314	4324	4332	4438	4442
				4511	4515	4531	5337	5440	5442	5472	5616	5618	5622	5624	5640
				5644	5651	5654	5656	5668	5709	5713	5748	5762	5780	5786	5789
				5802	5819	5823	5825	5847	5872
	B DISP			2106 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	3306	3312	3405
				3424	3425	3508	3522	3536	3546	3731	3738	3776	4096	4110	4162
				4168	4191	4193	5245	5474	5482	5486	5532	5544	5554	5561	5965
				6007	6151	6206	6413	6767	6839	6846	7601	7628	7646	7657	7684
				8601	8901
	BAD PARITY		1990 #
	BASIC DIV STEP		4566 #	4587	4590
	BWRITE DISP		2107 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	4096	4110	4162
				4168	4191	4193	8601	8901
	BYTE DISP		2124 #	4743	4760	6188	6891	6912
	BYTE STEP		4715 #	6019	6021
	CALL IBP		4709 #	4730	4735	4749
	CALL LOAD PI		2130 #	3628	7418
	CALL []			2020 #	2217	2229	2434	2806	2816	3586	3625	3627	3628	3642	3666
				3669	3866	3869	3984	4000	4005	4009	4015	4018	4052	4054	4159
				4187	4214	4223	4233	4243	4266	4376	4397	4452	4458	4472	4476
				4482	4528	4552	4730	4735	4739	4744	4749	4758	4761	5009	5019
				5053	5080	5135	5151	5153	5240	5252	5254	5272	5274	5361	5403
				5406	5411	5413	5521	5523	5525	5540	5541	5542	5601	5609	5637
				5677	5682	5694	5701	5708	5727	5751	5755	5759	5784	5787	5790
				5822	5824	5826	5832	5952	5992	5995	5999	6031	6037	6062	6086
				6097	6112	6116	6123	6133	6135	6141	6155	6164	6185	6200	6203
				6216	6231	6242	6250	6253	6256	6259	6267	6272	6299	6334	6343
				6359	6371	6398	6409	6417	6434	6460	6489	6492	6497	6572	6580
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 284
; 								Cross Reference Listing					

				6590	6593	6603	6616	6631	6638	6659	6663	6731	6765	6789	6889
				6908	6913	6965	6973	6984	7255	7325	7349	7352	7371	7418	7448
				7461	7510	7540	7542	7558	7562	7600	7611	7626	7645	7654	7683
				7690	7715	7908	7910	7916	7932	7980	7982	7999	8002	8004	8006
				8009	8012	8015	8018	8021	8023	8393	8400	8411	8418	8429	8438
				8456	8459	8472	8495	8505	8536	8567	8652	8810	8821	8881	8909
	CHANGE FLAGS		2040 #	2252	2253	2613	3439	3455	3522	3536	3592	3593	3596	3597
				3633	3654	3655	3725	3737	3793	3823	3827	3842	3848	4042	4043
				4044	4096	4110	4127	4137	4140	4170	4171	4195	4245	4257	4267
				4270	4377	4412	4443	4529	4678	4680	4745	4762	4784	5036	5388
				5400	5465	5753	6427	6428	7026	7528	7543	8839
	CHK PARITY		1989 #	2304	2374	2388	2397	2401	2418	2429	2440	2446	2459	2530
				2562	2568	2573	2576	2626	2822	3122	3441	3584	3608	3623	3648
				3652	3713	3730	3736	3758	3775	3781	3794	3852	3883	4005	4007
				4013	4040	4052	4056	4079	4157	4250	4252	4355	4365	4449	4471
				4478	4775	4803	4809	4930	5195	5244	5950	5969	6389	6579	6629
				6632	6660	6936	6951	7021	7154	7289	7293	7297	7301	7305	7346
				7376	7378	7385	7439	7523	7565	7689	7736	7781	7784	7786	7796
				7798	7895	7914	7934	7999	8000	8002	8003	8006	8007	8009	8010
				8012	8013	8015	8016	8018	8019	8021	8022	8024	8389	8471	8711
				8763	8880	8894	8908	8910
	CHK PARITY L		1982 #
	CHK PARITY R		1986 #
	CLEANUP DISP		2132 #	8844
	CLEAR ARX0		1738 #	2806	4674	6302	6343	6469	6475
	CLEAR CONTINUE		2029 #
	CLEAR EXECUTE		2030 #
	CLEAR RUN		2031 #
	CLEAR []0		1737 #	2806	4396	4674	6279	6295	6302	6343	6469	6475
	CLR FPD			2049 #	3725	3842	3848	4245	4745	4762	6428
	CLR IO BUSY		2035 #	7644	7682
	CLR IO LATCH		2036 #	7729	7737	7741	7744	7753	7759	7768	7773
	CLRCSH			2026 #	7450	7451	7454
	DFADJ			5633 #	5644
	DISMISS			2129 #	3627	3642
	DIV			2004 #	4587	4590	4591	4638	5519	5531	5539	5543	5636	5638	5639
	DIV DISP		2123 #
	DIV STEP		4567 #	4590
	DONE			2115 #	2263	2267	3361	3488	3493	4256	4731	7420	7691
	DPB SCAD		4918 #	4923	4924	4925	4926	4927
	EA MODE DISP		2104 #	2314	2380	3589	4782	4785	5961	6937	7725
	END BLT			2072 #	5178	5202	5288
	END MAP			2073 #	8591
	END STATE		2070 #	5178	5202	5288	6055	6127	6150	6300	6428	6432	6494	6766
				8591	8848	8866	8867	8898
	EXIT			2109 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	4162	4168	4191
				4193	8601	8901
	EXP TEST		2061 #	5528	5544	5874
	FETCH			1841 #	2263	2264	2266	2267	2286	2326	2332	2440	2465	3055	3361
				3373	3488	3489	3492	3493	3560	3561	3587	3629	3744	4256	4731
				4740	7420	7691	7927
	FE_-1			1961 #
	FE_-12.			1959 #	3059
	FE_-2			1958 #
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 285
; 								Cross Reference Listing					

	FE_-FE			1945 #	4847	4941
	FE_-FE+200		1972 #	5392	5393
	FE_-FE+S#		1948 #	4852
	FE_-FE-1		1946 #	3001	3036
	FE_-S-10		1955 #	4856	4922
	FE_-S-20		1954 #
	FE_0			1960 #
	FE_EXP			1967 #	2432	2447	5327	5608
	FE_FE+1			1962 #	3004	3018	3039	5407	5523	5525	5541	5542	5562	5567	5787
				5790	5824	5826	5872	5880
	FE_FE+10		1964 #	4854	4859	4935	4943
	FE_FE+2			1963 #	5364
	FE_FE+4			1966 #	3074
	FE_FE+P			1970 #	6559
	FE_FE+S#		1973 #	5706	5717	6692
	FE_FE+SC		1949 #	6691
	FE_FE-1			1965 #	5519	5531	5539	5543	5623	5625	5780	5802	5819	5847
	FE_FE-19		1947 #
	FE_FE-200		1971 #	5366
	FE_FE.AND.S#		1950 #	4742	4939	6187	6565	6690	6892
	FE_P			1951 #	4738	4938	6689	6889	6929
	FE_S			1952 #
	FE_S#			1956 #	3059	5251	5253	5271	5273	5429	5433	5435	5436	6558
	FE_S#-FE		1957 #	5766
	FE_S+2			1953 #	6018
	FE_SC+EXP		1968 #	5355	5450	5689
	FE_SC-EXP		1969 #	5386	5740
	FIRST DIV STEP		4568 #	4587
	FIX [] SIGN		1751 #	3422	4142	4166	4189	6770	7319
	FL NO DIVIDE		2065 #	5388	5400	5753
	FL-EXIT			2111 #	5482	5486	5532	5554
	FM WRITE		1758 #	2195	2203	2205	2206	2208	2209	2211	2212	2218	2220	2524
				2556	2807	3057	3078	3113	3146	3152	3335	3424	3464	3467	3470
				3473	3476	3479	3482	3485	3698	3745	3747	3810	3815	3843	4217
				4225	4234	4236	4247	4248	4249	4251	4253	4475	4491	4492	4493
				4495	4498	4517	4519	4522	4649	4654	4659	4665	4666	4667	4728
				4745	4987	5000	5010	5020	5052	5103	5152	5216	5241	5478	5484
				5796	5804	5840	5841	5842	5849	5960	5973	5976	6001	6006	6023
				6047	6067	6068	6074	6084	6087	6094	6095	6096	6111	6122	6124
				6126	6142	6158	6160	6167	6181	6194	6201	6212	6243	6260	6262
				6297	6298	6310	6311	6318	6320	6333	6335	6344	6347	6379	6385
				6391	6396	6397	6401	6410	6416	6423	6424	6425	6584	6615	6644
				6717	6733	6763	6859	6887	6928	6952	6966	6969	6974	6981	6986
				6993	7003	7115	7224	7290	7294	7298	7302	7306	7321	7332	7353
				7356	7386	7387	7471	7472	7612	7720	7754	7760	7762	7800	7907
				7979	7994	8004	8266	8270	8287	8288	8290	8291	8298	8308	8310
				8312	8314	8318	8319	8460	8462	8483	8808
	FORCE EXEC		1821 #	7524	7538	7572
	GEN 17-FE		1976 #	4824
	GEN MSK []		1754 #	4858	4861	4934	4937	6021
	HALT []			2131 #	2226	2283	2301	2552	3615	7537	7569	8282	8833
	HOLD LEFT		1980 #	2264	2266	2311	2324	2325	2331	2336	2351	2352	2364	2375
				2398	2726	2757	2765	2787	2789	3373	3489	3492	3560	3561	3562
				3571	3574	3587	3599	3629	3653	3667	3795	3854	3868	3872	4017
				4029	4034	4064	4080	4131	4774	4804	5013	5072	5095	5144	5156
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 286
; 								Cross Reference Listing					

				5178	5182	5187	5202	5205	5215	5267	5268	5288	5290	5363	5626
				5963	5966	5969	6010	6036	6039	6055	6061	6090	6109	6115	6123
				6127	6138	6150	6154	6161	6180	6208	6285	6300	6338	6373	6390
				6417	6428	6432	6488	6494	6541	6598	6602	6637	6662	6703	6708
				6766	6885	6927	6936	7095	7121	7135	7204	7220	7222	7266	7347
				7352	7377	7411	7413	7415	7417	7429	7489	7490	7491	7492	7493
				7494	7495	7517	7587	7713	7734	7734	7915	7931	8001	8008	8011
				8014	8017	8020	8269	8545	8591	8599	8842	8848	8854	8856	8858
				8860	8862	8864	8866	8867	8868	8898	8917
	HOLD RIGHT		1984 #	2455	2457	2470	2492	2493	2724	2759	2763	2780	2782	2806
				3149	3151	3422	3564	3573	3576	3578	3579	3580	3613	3618	3621
				3641	3662	3675	3806	3957	3959	3961	3963	3965	3967	3969	3971
				3979	3999	4009	4061	4077	4142	4143	4144	4166	4189	4396	4435
				4497	4551	4674	4851	4986	4994	5057	5102	5137	5141	5328	5329
				5332	5333	5357	5358	5390	5391	5451	5452	5528	5544	5647	5648
				5655	5671	5793	5828	5858	5859	5874	5956	5978	6205	6210	6279
				6295	6296	6302	6341	6343	6350	6356	6365	6384	6436	6439	6444
				6469	6475	6546	6640	6642	6712	6716	6770	6812	6816	6820	6824
				6828	6832	6848	6946	6958	7029	7038	7039	7040	7044	7045	7046
				7047	7052	7053	7054	7057	7058	7059	7060	7061	7062	7063	7064
				7089	7129	7132	7160	7167	7171	7186	7192	7201	7209	7231	7232
				7250	7254	7260	7285	7308	7319	7403	7405	7407	7409	7541	7743
				7788	7862	7871	7873	7875	7877	7879	7881	8262	8265	8327	8331
				8334	8339	8490	8515	8552	8556	8590	8594	8597	8608	8678	8783
				8788	8793	8799	8813	8876
	IBP DP			4706 #	4730	4735	4749	6071	6881	6924	6997
	IBP SCAD		4707 #	4730	4735	4749	6071	6881	6924
	IBP SPEC		4708 #	4730	4735	4749
	INH CRY18		1992 #	3545	3715	3762	3791	3811	3816	5068	5143
	INST DISP		2108 #	2389	2393	2402	2407	2415	2436	2442	2466	2471
	INTERRUPT TRAP		2121 #
	JFCL FLAGS		2058 #	3633
	JUMP DISP		2114 #	3508	3522	3536	3546
	JUMPA			2116 #	3489	3492	3560	3561	3587	3629
	LDB SCAD		4820 #	4829	4830	4831	4832	4833
	LEAVE USER		2056 #	2252	4043
	LOAD AC BLOCKS		2024 #	2198	7187	7210
	LOAD BYTE EA		2015 #	4738	4757	4805	5957	5969	6888
	LOAD DST EA		2018 #	6925	6927	6936
	LOAD FE			1898 #	2414	2432	2447	3001	3004	3008	3018	3020	3036	3039	3042
				3047	3059	3074	3120	4738	4742	4754	4847	4852	4854	4856	4859
				4922	4935	4938	4939	4941	4943	5251	5253	5271	5273	5281	5282
				5327	5355	5364	5366	5386	5392	5393	5407	5429	5433	5435	5436
				5450	5519	5523	5525	5531	5539	5541	5542	5543	5562	5567	5608
				5623	5625	5689	5706	5717	5740	5766	5780	5787	5790	5802	5819
				5824	5826	5847	5872	5880	6018	6019	6021	6187	6558	6559	6565
				6689	6690	6691	6692	6889	6892	6911	6929
	LOAD FLAGS		2060 #	2253	3592	3596	3654	4042	7528	7543	8839
	LOAD IND EA		2016 #	2376
	LOAD INST		2013 #	2305	3690	7022	7935
	LOAD INST EA		2014 #	3585	3609	3624	7732
	LOAD IR			2009 #	5956
	LOAD PAGE TABLE		2023 #	7445	8617
	LOAD PCU		2054 #	4044
	LOAD PI			2027 #	3643	7431	7506	7988
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 287
; 								Cross Reference Listing					

	LOAD PXCT		2021 #	3695
	LOAD SC			1897 #	2210	2220	2413	2432	2447	2463	3024	3026	3102	3103	3104
				3106	3110	3120	3129	3132	3136	3143	3174	3175	3176	3178	3182
				4157	4185	4222	4242	4262	4288	4300	4306	4314	4324	4332	4375
				4472	4480	4587	4590	4630	4976	4979	4992	4998	5003	5016	5032
				5077	5092	5098	5321	5325	5326	5335	5337	5359	5406	5440	5443
				5448	5466	5467	5468	5470	5473	5477	5587	5597	5607	5641	5644
				5651	5666	5669	5677	5681	5684	5694	5700	5755	5756	6332	6361
				6500	6502	6505	6509	6511	6682	6688	6694	6699	6706	7193	7196
				7214	7216	7245	7247	7255	7261	7264	7455	7468	7475	7663	7670
				7695	7701	7749	7756	7765	7769	8341	8344	8392	8406	8409	8440
				8443	8580	8586
	LOAD SRC EA		2017 #
	LOAD VMA		1820 #	2196	2215	2219	2263	2263	2264	2266	2267	2267	2285	2311
				2326	2332	2338	2342	2365	2369	2378	2398	2440	2450	2453	2465
				2819	2823	2824	3055	3361	3361	3373	3488	3488	3489	3492	3493
				3493	3560	3561	3562	3567	3571	3574	3587	3600	3603	3629	3644
				3650	3665	3667	3667	3676	3716	3743	3753	3765	3770	3786	3849
				3880	3992	3993	3993	4002	4003	4003	4017	4017	4036	4037	4064
				4064	4073	4080	4081	4256	4256	4731	4731	4740	4787	4791	4795
				4799	5132	5160	5168	5182	5183	5187	5188	5205	5206	5284	5290
				5290	5964	5966	5967	5990	6138	6387	6414	6459	6465	6472	6488
				6493	6549	6627	6669	6784	6931	6932	6933	6934	7010	7018	7151
				7256	7347	7372	7377	7377	7420	7420	7438	7444	7507	7522	7522
				7522	7523	7564	7564	7572	7653	7688	7691	7691	7713	7735	7794
				7891	7899	7909	7912	7912	7915	7915	7926	7982	7998	7998	8001
				8001	8008	8008	8011	8011	8014	8014	8017	8017	8020	8020	8027
				8324	8372	8373	8373	8380	8381	8381	8385	8387	8465	8467	8609
				8625	8706	8708	8740	8741	8755	8757	8823	8829	8877	8878	8878
				8914	8914	8917	8917
	LSH			1997 #
	LSHC			2000 #	3106	3110	4619	4622
	LUUO			2118 #	5918	5920	5922	5924	5926	5928	5930	5932	5934
	MEM CYCLE		1817 #	2196	2215	2219	2263	2263	2263	2264	2264	2266	2266	2267
				2267	2267	2285	2286	2303	2311	2326	2326	2332	2332	2337	2338
				2342	2343	2365	2366	2369	2370	2374	2378	2387	2396	2398	2399
				2400	2428	2439	2440	2440	2450	2451	2453	2454	2458	2465	2465
				2529	2561	2567	2572	2575	2624	2625	2819	2820	2822	2823	2824
				2826	3055	3055	3361	3361	3361	3373	3373	3440	3441	3488	3488
				3488	3489	3489	3492	3492	3493	3493	3493	3560	3560	3561	3561
				3562	3562	3567	3567	3571	3571	3574	3574	3583	3587	3587	3600
				3601	3603	3604	3607	3622	3629	3629	3644	3648	3650	3651	3652
				3665	3665	3667	3667	3668	3671	3676	3676	3712	3716	3717	3729
				3735	3743	3744	3753	3754	3757	3765	3767	3770	3772	3774	3780
				3786	3788	3794	3849	3850	3851	3863	3880	3881	3882	3992	3993
				3993	4002	4003	4003	4004	4006	4012	4017	4017	4017	4036	4037
				4038	4039	4051	4055	4064	4064	4064	4073	4074	4078	4080	4081
				4082	4256	4256	4256	4731	4731	4731	4740	4740	4768	4774	4775
				4787	4788	4791	4792	4795	4796	4799	4800	4802	4808	4929	4930
				5132	5133	5160	5161	5168	5169	5171	5182	5183	5185	5187	5188
				5190	5194	5197	5205	5206	5208	5243	5284	5284	5286	5290	5290
				5291	5950	5964	5966	5966	5967	5967	5969	5990	5991	6138	6138
				6387	6388	6389	6414	6415	6459	6465	6472	6488	6488	6493	6493
				6549	6549	6581	6583	6627	6627	6629	6632	6660	6669	6669	6784
				6785	6931	6931	6932	6932	6933	6933	6934	6934	6936	6950	7006
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 288
; 								Cross Reference Listing					

				7009	7010	7014	7017	7018	7021	7151	7152	7153	7256	7256	7288
				7289	7292	7293	7296	7297	7300	7301	7304	7305	7344	7345	7347
				7348	7372	7373	7376	7377	7377	7377	7378	7384	7385	7420	7420
				7420	7438	7438	7439	7444	7507	7511	7522	7522	7522	7523	7523
				7538	7559	7564	7564	7565	7572	7573	7653	7655	7688	7689	7691
				7691	7691	7713	7714	7735	7735	7736	7781	7784	7786	7794	7796
				7798	7891	7892	7894	7899	7900	7909	7912	7912	7914	7915	7915
				7915	7926	7927	7933	7982	7998	7998	7999	8000	8001	8001	8001
				8002	8003	8006	8007	8008	8008	8008	8009	8010	8011	8011	8011
				8012	8013	8014	8014	8014	8015	8016	8017	8017	8017	8018	8019
				8020	8020	8020	8021	8022	8024	8027	8324	8372	8373	8373	8380
				8381	8381	8385	8386	8387	8388	8465	8466	8467	8470	8609	8625
				8662	8706	8707	8708	8710	8740	8741	8742	8755	8756	8757	8762
				8823	8829	8877	8878	8878	8879	8893	8908	8910	8914	8914	8917
				8917	8917
	MEM READ		1845 #	2303	2374	2387	2396	2400	2428	2439	2458	3583	3607	3622
				3648	3652	3712	3757	3794	3882	4039	4802	4808	5194	5243	5950
				5969	6389	6632	6660	6936	6950	7006	7014	7021	7153	7289	7293
				7297	7301	7305	7345	7385	7511	7523	7559	7565	7655	7736	7781
				7784	7786	7894	7933	8388	8470	8710	8762
	MEM WAIT		1844 #	2303	2374	2387	2396	2400	2428	2439	2458	2529	2561	2567
				2572	2575	2625	2822	3441	3583	3607	3622	3648	3652	3712	3729
				3735	3757	3774	3780	3794	3851	3882	4004	4006	4012	4039	4051
				4055	4078	4775	4802	4808	4930	5171	5194	5197	5243	5286	5950
				5969	6389	6583	6629	6632	6660	6936	6950	7006	7014	7021	7153
				7289	7293	7297	7301	7305	7345	7376	7378	7385	7439	7511	7523
				7559	7565	7655	7689	7736	7781	7784	7786	7796	7798	7894	7914
				7933	7999	8000	8002	8003	8006	8007	8009	8010	8012	8013	8015
				8016	8018	8019	8021	8022	8024	8388	8470	8710	8762	8879	8893
				8908	8910
	MEM WRITE		1846 #	2529	2561	2567	2572	2575	2625	2822	3441	3729	3735	3774
				3780	3851	4004	4006	4012	4051	4055	4078	4775	4930	5171	5197
				5286	6583	6629	7376	7378	7439	7689	7796	7798	7914	7999	8000
				8002	8003	8006	8007	8009	8010	8012	8013	8015	8016	8018	8019
				8021	8022	8024	8879	8893	8908	8910
	MEM_Q			1853 #	5172	5198	5286	6583
	MEM_[]			1852 #	2530	2562	2568	2573	2576	2626	2822	3441	3730	3736	3775
				3781	3852	4005	4007	4013	4052	4056	4079	4775	4930	6629	7376
				7378	7439	7689	7796	7798	7914	7999	8000	8002	8003	8006	8007
				8009	8010	8012	8013	8015	8016	8018	8019	8021	8022	8024	8880
				8894	8908	8910
	MUL DISP		2122 #	4306	4314	4324	4332	5618	5644	5646	5763
	MUL FINAL		4284 #	4310	4318	4328	4336
	MUL STEP		4283 #	4306	4314	4324	4332
	NEXT INST		2102 #	2557	3078	3124	3152	3464	3746	3822	3829	4520	4523	5478
				5484	5843	8270
	NEXT INST FETCH		2103 #	2263	2264	2266	2267	2327	2333	3361	3373	3488	3489	3492
				3493	3560	3561	3587	3629	4256	4731	7420	7691
	NEXT [] PHYSICAL WRI	1875 #	4017	4064	7915	8001	8008	8011	8014	8017	8020	8917
	NO DIVIDE		2064 #	4377	4412	4443	4529	5036
	NORM DISP		2128 #	5338	5367	5444	5519	5521	5531	5535	5537	5539	5540	5543
				5565	5716	5770	5771	5781	5783	5803	5813	5815	5820	5821	5848
				5877
	ONES			2003 #	4858	4861	4934	4937	6021
	PAGE FAIL TRAP		2119 #	8404	8424	8492	8502	8522	8659	8684	8689	8713	8777
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 289
; 								Cross Reference Listing					

	PI DISP			2127 #
	PXCT BLT DEST		1829 #	5162	5170	5184	5189	5285
	PXCT BLT SRC		1833 #	5134	5207	5291
	PXCT BYTE DATA		1831 #	4789	4793	6931	6932
	PXCT BYTE PTR EA	1830 #	4797	4801
	PXCT DATA		1828 #	2356	2398	2450	2453	2821	2825	3766	3771
	PXCT EA			1827 #	2365	2370	3605
	PXCT EXTEND EA		1834 #	5966	5967
	PXCT STACK WORD		1832 #	3718	3755	3787
	Q-[]			1702 #	4466
	Q.AND.NOT.[]		1703 #
	Q_#			1718 #	5011	5055
	Q_-1			1710 #
	Q_-AC[]			1711 #	4648	4653	4658
	Q_-Q			1712 #	4436	4513	4554	4555	4572	5520	5522	5524	5526	5809
	Q_-[]			1709 #	5745
	Q_.NOT.AC[]		1708 #	4652	4657
	Q_.NOT.Q		1717 #	5808
	Q_0			1719 #	3016	4857	4933	5335	5406	5417	5429	5433	5435	5436	5449
				5462	5755	6019
	Q_0 XWD []		1720 #
	Q_AC			1713 #	4157	4355
	Q_AC[]			1714 #	2418	3122	4250	4252	4365	6579
	Q_AC[].AND.MASK		1715 #
	Q_AC[].AND.[]		1716 #	4449	4471	4478
	Q_MEM			1863 #	5195	5244	7786
	Q_Q*.5			1725 #	4265	4299	4472	5246	5266	5267	5268	5282	5670	5760
	Q_Q*2			1726 #	5261	5262
	Q_Q+.25			1721 #	5621	5768
	Q_Q+1			1722 #
	Q_Q+AC			1724 #	5031
	Q_Q+[]			1731 #	4474	4506	5603	5611	5712	5715
	Q_Q-1			1723 #	5071
	Q_Q-WORK[]		1810 #	5014
	Q_Q.AND.#		1728 #	3148	4549	5255	5275	5362	5671
	Q_Q.AND.NOT.[]		1730 #	5757
	Q_Q.AND.[]		1729 #	4521	4940
	Q_Q.OR.#		1727 #	3150	4434
	Q_WORK[]		1792 #	5078	6178
	Q_[]			1704 #	4183	4222	4242	4262	4476	4502	5002	5359	5594	5606	5666
				5681	5694	5700	5750
	Q_[]+[]			1706 #	4503
	Q_[]-[]			1705 #	5138
	Q_[].AND.Q		1732 #	4597	5792	5827
	Q_[].AND.[]		1707 #	4424
	Q_[].OR.Q		1733 #	5278	5626
	RAM_[]			1813 #	2218	2220
	READ Q			1743 #	5485	5527	5551	5800	5845
	READ XR			1741 #	3591
	READ []			1742 #	2411	2431	2607	2771	2778	2785	2792	3103	3119	3175	3320
				3364	3367	3370	3376	3379	3382	3595	3643	3654	3694	3987	3991
				4001	4035	4041	4072	4160	4366	4372	4386	4391	4393	4398	4465
				4467	4484	4500	4509	4570	4577	4598	4737	4741	4756	4759	4856
				4922	4938	5059	5323	5327	5410	5412	5444	5448	5481	5521	5540
				5608	5707	5716	5765	5783	5821	5957	5975	6018	6052	6153	6156
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 290
; 								Cross Reference Listing					

				6162	6175	6186	6202	6378	6414	6465	6472	6498	6512	6517	6539
				6543	6595	6681	6689	6784	6806	6838	6888	6890	6912	7110	7112
				7113	7118	7122	7223	7337	7372	7451	7457	7464	7731	7988	7998
				8354	8453	8621	8679	8733	8769	8839	8844
	RETURN []		2126 #	2492	2493	3594	3598	4062	4065	4268	4311	4319	4329	4337
				4531	4553	4554	4556	4640	4667	4769	4771	4775	4810	4843	4862
				4930	5144	5281	5282	5564	5566	5567	5656	5851	5858	5859	5874
				6263	6273	6278	6281	6319	6320	6470	6476	6647	6670	6735	6766
				6778	6809	6825	6842	6851	6853	6879	6914	6947	6953	6958	6998
				7266	7333	7357	7432	7476	7584	7587	7659	7666	7672	7729	7737
				7741	7744	7770	7782	7784	7786	7788	7790	7792	7794	7796	7798
				7800	7991	7995	8029	8631	8653	8658	8664	8695	8698	8699	8712
				8721	8724	8725	8829	8917
	ROT			1999 #	3042	3047
	ROTC			2002 #	3178	3182
	SCAD DISP		2125 #	4730	4735	4749	4825	5321	5464	5466	6019	6021	6072	6882
				6924	7756
	SC_-1			1942 #
	SC_-2			1943 #
	SC_-SHIFT		1906 #
	SC_-SHIFT-1		1907 #	3103	3175
	SC_-SHIFT-2		1908 #
	SC_0			1941 #	6688	6699
	SC_1			1940 #
	SC_11.			1931 #
	SC_14.			1930 #
	SC_19.			1929 #	2210
	SC_2			1939 #	6509
	SC_20.			1928 #	6332
	SC_22.			1927 #
	SC_24.			1926 #
	SC_26.			1925 #	5755
	SC_27.			1924 #	5359	5406
	SC_28.			1923 #
	SC_3			1938 #	4992
	SC_34.			1922 #	4375	4472	4480	5003	5016	5032
	SC_35.			1921 #	4157	4185	4222	4242	4262	5077	5677	5681	5694	5700	5756
	SC_36.			1920 #
	SC_4			1937 #
	SC_5			1936 #	7663	7695
	SC_6			1935 #	5440	5666	6502	7214	7245	7255	7261
	SC_7			1934 #	6500	7193	8341	8392	8440	8580
	SC_8.			1933 #
	SC_9.			1932 #	4976	5092
	SC_EXP			1913 #	2432	2447	5325	5597
	SC_FE			1916 #	2463	5684
	SC_FE+S#		1915 #	3129	5466
	SC_S#			1917 #	2210	4157	4185	4222	4242	4262	4375	4472	4480	4976	4992
				5003	5016	5032	5077	5092	5359	5406	5440	5666	5677	5681	5694
				5700	5755	5756	6332	6500	6502	6509	6688	6699	7193	7214	7245
				7255	7261	7475	7663	7695	7749	7765	8341	8392	8440	8580
	SC_S#-FE		1914 #	3132	5468
	SC_SC-1			1902 #	7756
	SC_SC-EXP		1909 #
	SC_SC-EXP-1		1910 #	5321	5587
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 291
; 								Cross Reference Listing					

	SC_SC-FE		1912 #
	SC_SC-FE-1		1911 #	5326	5607
	SC_SHIFT		1903 #	3120	5448
	SC_SHIFT-1		1904 #	2413
	SC_SHIFT-2		1905 #
	SET APR ENABLES		2033 #	2201	7114	7223
	SET AROV		2042 #	4170	4171	4195	4257	5465
	SET FL NO DIVIDE	2045 #	5388	5400	5753
	SET FOV			2043 #
	SET FPD			2048 #	4270	4784	6427
	SET HALT		2028 #	7917	7983
	SET NO DIVIDE		2044 #	4377	4412	4443	4529	5036	5388	5400	5753
	SET PDL OV		2051 #	3737	3793	3823	3827
	SET P TO 36-S		4711 #	4770	6081	6884	6926
	SET TRAP1		2052 #
	SHIFT			1900 #	3008	3020	3042	3047	5281	5282
	SKIP AC REF		2096 #
	SKIP AD.EQ.0		2080 #	3052	3367	3379	3470	3482	4160	4165	4367	4369	4373	4387
				4432	4461	4491	4572	4650	4655	4660	4676	4683	5001	5030	5384
				5410	5412	5485	5527	5551	5707	5758	5800	5845	6175	6228	6304
				6307	6596	6633	6654	6777	7364	8368	8371	8455	8458
	SKIP AD.LE.0		2081 #	3370	3382	3473	3485	4426	5060	5404	5728	6375	7330	7987
	SKIP ADL.EQ.0		2092 #	2223	4025	4030	5427	5432	5546	5711	5714	5782	5785	5788
				5791	5851	5951	5994	6133	6135	6217	6237	6421	6437	6491	6526
				6529	6561	7025	7161	7175	7221	7230	7525	7526	7717	7719	7733
				8328	8350	8394	8401	8404	8419	8424	8473	8492	8496	8502	8516
				8520	8522	8542	8595	8614	8616	8654	8659	8681	8684	8686	8689
				8692	8713	8723	8777	8795	8836	8885
	SKIP ADL.LE.0		2083 #	7726
	SKIP ADR.EQ.0		2093 #	3121	3627	3642	5158	6362	6435	6790	7067	7073	7100	7102
				7105	7107	7109	7400	7402	7406	7408	7410	7412	7414	7416	7513
				7566	7586	7658	7685	8268	8547	8575	8764	8781	8784	8789
	SKIP CRY0		2088 #	3720	3763	3792	5396	5520	5522	5524	5526
	SKIP CRY1		2089 #	4123	4135	5836	6252	6258	6271	6462	6473
	SKIP CRY2		2090 #	5809	5869
	SKIP DP0		2078 #	2433	2448	2607	2785	2792	3075	3147	3364	3376	3467	3479
				3809	3812	3817	3988	4142	4167	4189	4192	4247	4255	4356	4392
				4394	4399	4404	4408	4430	4447	4459	4466	4481	4500	4518	4570
				4577	4592	5033	5177	5201	5287	5323	5327	5356	5386	5394	5428
				5450	5481	5588	5690	5737	5741	5752	5765	6002	6015	6032	6045
				6052	6070	6112	6114	6136	6153	6156	6162	6202	6294	6299	6336
				6345	6378	6395	6467	6517	6543	6734	6764	6806	6860	6979	7155
				7319	8355	8453	8680	8734
	SKIP DP18		2079 #	2412	2771	2778	5975	6222	6426	6515	6838	6839	7552	8737
				8747	8770
	SKIP EXECUTE		2097 #	7921
	SKIP FPD		2085 #	4209	4730	4735	4749	6326
	SKIP IF AC0		2077 #	2519	3423	4727
	SKIP IO LEGAL		2087 #	2469	3572	3575
	SKIP IRPT		2094 #	5181	6072	8292	8487	8709	8817	8848	8899
	SKIP JFCL		2091 #	3634
	SKIP KERNEL		2086 #	3565	3569	3570	3577	3686	7004
	SKIP NO CST		8073 #	8437	8566	8650
	SKIP -1MS		2095 #	6067
	SKIP-COMP DISP		2113 #	3405	3424	3425	6151
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 292
; 								Cross Reference Listing					

	SPEC MEM READ		1847 #	2445
	SPEC MEM WRITE		1848 #
	START NO TEST WRITE	1840 #	8662
	START READ		1838 #	2263	2264	2266	2267	2286	2326	2332	2337	2343	2366	2370
				2399	2440	2451	2454	2465	3055	3361	3373	3488	3489	3492	3493
				3560	3561	3562	3567	3571	3574	3587	3601	3604	3629	3651	3671
				3744	3754	3788	3881	4038	4082	4256	4731	4740	4788	4792	4796
				4800	5133	5208	5291	5966	5967	5991	6138	6388	6415	6488	6493
				6549	6669	6785	6931	6932	6933	6934	7009	7017	7152	7288	7292
				7296	7300	7304	7344	7348	7384	7420	7573	7691	7714	7735	7892
				7927	8386	8466	8707	8742	8756
	START WRITE		1839 #	2624	2820	2826	3440	3665	3668	3676	3717	3767	3772	3850
				3863	4017	4064	4074	4768	4774	4929	5161	5169	5185	5190	5284
				6581	6627	7256	7373	7377	7438	7538	7900	7915	8001	8008	8011
				8014	8017	8020	8917
	STATE_[]		2069 #	5144	6010	6036	6039	6061	6109	6115	6123	6154	6161	6180
				6208	6390	6417	6541	6598	6602	6662	8269	8854	8856	8858	8860
				8862	8864	8868
	STEP SC			1899 #	2220	3024	3026	3102	3104	3106	3110	3136	3143	3174	3176
				3178	3182	4288	4300	4306	4314	4324	4332	4587	4590	4630	4979
				4998	5098	5335	5337	5443	5467	5470	5473	5477	5641	5644	5651
				5669	6361	6505	6511	6706	7196	7216	7247	7264	7455	7468	7670
				7701	7769	8344	8406	8409	8443	8586
	SWEEP			2025 #	7463	7464	7467
	TAKE INTERRUPT		2120 #	8876
	TEST DISP		2112 #	3306	3312	7601
	TL []			1747 #	4025	4030	5546	5711	5714	5782	5785	5788	5791	5851	5951
				5994	6133	6135	6217	6237	6421	6437	6491	6526	6529	7717	7719
				7733	8328	8350	8394	8401	8404	8419	8424	8473	8492	8496	8502
				8516	8520	8522	8542	8595	8614	8616	8654	8659	8681	8684	8686
				8689	8692	8713	8723	8777	8795	8836	8885
	TR []			1746 #	3627	3642	6362	6435	6790	7100	7102	7105	7107	7109	7400
				7402	7406	7408	7410	7412	7414	7416	7658	7685	8268	8547	8575
				8764	8781	8784	8789
	TURN OFF PXCT		2022 #	2275	2278	2281	2293	2296	2299	2313
	TXXX TEST		2098 #	3320
	UNHALT			2032 #	7920
	UPDATE USER		2055 #	3593	3597	3655
	UUO			2117 #	2470	3564	3573	3576	3578	3579	3580	3613	3618	3621	3641
				3662	3675	3957	3959	3961	3963	3965	3967	3969	3971	6946	7029
				7038	7039	7040	7044	7045	7046	7047	7052	7053	7054	7057	7058
				7059	7060	7061	7062	7063	7064	7285	7308	7403	7862	7871	7873
				7875	7877	7879	7881
	VMA			1887 #
	VMA EXTENDED		1825 #
	VMA PHYSICAL		1822 #	3993	4003	4017	4037	4064	7010	7018	7522	7564	7912	7915
				7998	8001	8008	8011	8014	8017	8020	8373	8381	8387	8467	8708
				8741	8757	8878	8914	8917
	VMA PHYSICAL READ	1824 #	7522	7564	8373	8381	8914
	VMA PHYSICAL WRITE	1823 #	3993	4003	7912	7998	8878
	VMA_[]			1867 #	2263	2267	2285	2342	2369	2378	2465	2823	3361	3488	3493
				3567	3603	3665	3676	3765	3770	3849	3880	4256	4731	4740	4791
				4799	5132	5160	5168	5284	5967	6493	6549	6627	6669	6932	6934
				7151	7256	7420	7438	7444	7522	7691	7735	7891	7899	7926	8027
				8385	8609	8625	8706	8877
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 293
; 								Cross Reference Listing					

	VMA_[] WITH FLAGS	1868 #	7794
	VMA_[]+1		1870 #	2264	2266	2311	2398	3373	3667	4080	5182	5187	5205	5290
				6138	6488	7347	7377
	VMA_[]+XR		1872 #	4787	4795	6931	6933
	VMA_[]+[]		1873 #	8372	8380	8465
	VMA_[]-1		1871 #	3562	3571	3574	7713
	VMA_[].OR.[] WITH FL	1869 #	7653	7688
	WORK[]			1888 #	6170	6392	6591	6658	6736	6767	6770
	WORK[]_.NOT.[]		1798 #	6212
	WORK[]_0		1793 #	2212	7471	7472
	WORK[]_1		1794 #	2211
	WORK[]_Q		1791 #	5010	6142	6181
	WORK[]_[]		1795 #	2195	2203	2205	2206	4728	4987	5000	5020	5052	5960	5973
				5976	6006	6068	6094	6095	6096	6111	6158	6194	6333	6335	6397
				6410	6416	6615	6763	6952	7003	7115	7224	7290	7294	7298	7302
				7306	7321	7332	7353	7356	7386	7387	7754	7760	7762	7907	7979
				7994	8004	8266	8287	8288	8290	8291	8298	8308	8310	8312	8314
				8318	8319	8460	8462	8483	8808
	WORK[]_[] CLR LH	1796 #	3698	7720
	WORK[]_[]-1		1797 #	6391
	WORK[]_[].AND.[]	1799 #	6023
	WRITE TEST		1837 #	2624	2820	2826	3440	3665	3668	3676	3717	3767	3772	3850
				3863	4017	4064	4074	4768	4774	4929	5161	5169	5185	5190	5284
				6581	6627	7256	7288	7292	7296	7300	7304	7373	7377	7438	7538
				7900	7915	8001	8008	8011	8014	8017	8020	8917
	XR			1886 #
	[] LEFT_-1		1688 #	2775
	[] LEFT_0		1686 #	2773
	[] RIGHT_-1		1689 #	2796
	[] RIGHT_0		1687 #	2794
	[]+[]			1553 #	2818	4267	4407
	[]-#			1555 #	6221	6514	8735	8745
	[]-[]			1554 #	4403	4459	4460	5157	5175	5199	5287	5396	5404	5752	6136
	[].AND.#		1556 #	5427	5431	6560	7023	7173	7221	7230
	[].AND.NOT.WORK[]	1800 #
	[].AND.NOT.[]		1559 #	4164
	[].AND.Q		1557 #	4431
	[].AND.WORK[]		1801 #	6776
	[].AND.[]		1558 #	4192	7067	7073	7586
	[].OR.[]		1560 #
	[].XOR.#		1561 #	2223	7525	7526
	[].XOR.[]		1562 #	7363
	[]_#			1564 #	2184	2188	2213	2214	2254	2780	2782	2787	2789	4576	4984
				5007	5017	5021	5050	5093	5144	5978	6010	6036	6039	6061	6109
				6115	6123	6154	6161	6180	6208	6390	6417	6541	6598	6602	6662
				7079	7081	7447	7449	7460	7462	7541	7583	8269	8854	8856	8858
				8860	8862	8864	8868
	[]_#-[]			1563 #
	[]_(#-[])*2		1650 #	5088
	[]_(-[])*.5		1651 #
	[]_(-[]-.25)*.5 LONG	1652 #	4437	5746
	[]_(-[]-.25)*2 LONG	1653 #	4514
	[]_(AC[].AND.[])*.5	1648 #	4213	4215	5585	5676	5731
	[]_(MEM.AND.[])*.5	1862 #	2459
	[]_(Q+1)*.5		1649 #	5868
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 294
; 								Cross Reference Listing					

	[]_([]+#)*2		1663 #
	[]_([]+1)*2		1664 #	6680
	[]_([]+[])*.5 LONG	1665 #	5615
	[]_([]+[])*2 LONG	1666 #	4621
	[]_([]+[]+.25)*.5 LO	1669 #
	[]_([]-[])*.5 LONG	1667 #
	[]_([]-[])*2 LONG	1668 #	4618
	[]_([].AND.#)*.5	1655 #	4981	4988	7567
	[]_([].AND.#)*2		1656 #
	[]_([].AND.NOT.#)*.5	1657 #
	[]_([].AND.NOT.#)*2	1658 #
	[]_([].AND.[])*.5	1659 #	4207
	[]_([].AND.[])*2	1660 #
	[]_([].OR.#)*.5		1661 #
	[]_([].OR.#)*2		1662 #
	[]_+SIGN		1692 #	2457	2492	5328	5332	5357	5390	5451
	[]_+SIGN*.5		1697 #	5589	5691	5742
	[]_-1			1565 #	4359	6427	7429
	[]_-2			1566 #
	[]_-AC			1581 #	4663
	[]_-AC[]		1582 #	6306
	[]_-Q			1567 #
	[]_-Q*.5		1569 #	5415
	[]_-Q*2			1568 #	4487
	[]_-SIGN		1693 #	2455	2493	5329	5333	5358	5391	5452
	[]_-SIGN*.5		1698 #	5591	5692	5744
	[]_-WORK[]		1808 #	6034	6977	6991
	[]_-[]			1570 #	2612	2982	4556	4574	4581	4675	4679	4683	4685	5318	5393
				5428	5537	5553	5582	5734	5814	5835	6303
	[]_-[]*2		1572 #	5397
	[]_-[]-.25		1571 #	5583
	[]_.NOT.AC[]		1574 #	6305
	[]_.NOT.AC		1573 #	2931	2941	4662
	[]_.NOT.Q		1575 #	4947	6022
	[]_.NOT.WORK[]		1807 #	6051	6079	6083	6219	6223	6995
	[]_.NOT.[]		1576 #	2874	2911	2952	2962	3323	4129	4573	4677	4684	5487	5535
				5550	5552	5733	5743	5812	6003	6005	6557	7716	8722
	[]_0			1577 #	2196	2198	2201	2210	2229	2251	2435	2839	3306	4008	4261
				4357	4571	4851	4993	5136	5178	5202	5288	5554	5727	5794	5810
				5838	6055	6127	6139	6150	6179	6300	6338	6372	6428	6432	6436
				6439	6494	6766	7191	7203	7249	7326	7401	7446	7514	7743	7788
				7912	8591	8653	8848	8866	8867	8898
	[]_0 XWD []		1579 #	2190	2193	2237	2273	2277	2280	2292	2295	2298	3981	4021
				4069	4433	4444	5918	5920	5922	5924	5926	5928	5930	5932	5934
				6630	7317	7496	7497	7498	7499	7500	7501	7502
	[]_0*.5 LONG		1578 #	4287
	[]_AC[]			1596 #	2216	2406	2816	5993	6011	6014	6044	6060	6132	6152	6184
				6199	6227	6230	6232	6249	6290	6292	6293	6325	6331	6358	6370
				6405	6548	6589	6626	6628	6732	6845	6852	6878	6880	6907	6964
				6972	6978
	[]_AC[]*.5		1598 #	4227
	[]_AC[]*2		1597 #	6239
	[]_AC[]-1		1593 #	6399	6418
	[]_AC[]-[]		1592 #	4134
	[]_AC[].AND.[]		1594 #
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 295
; 								Cross Reference Listing					

	[]_AC			1580 #	2392	2405	2623	2724	2726	2757	2763	3000	3017	3508	3752
				3785	3807	3865	3878	4185	4364	4755	5151	5239	5321	5354	5386
				5450	5596	5996	6134	6196	6330	6332	6353	6490	7615	7902
	[]_AC*.5		1583 #	3023	3035	3038	4232	4447	5586	5688	5739
	[]_AC*.5 LONG		1584 #	2419	3125
	[]_AC*2			1585 #	4751
	[]_AC+1			1586 #	3522
	[]_AC+1000001		1587 #	3544	3714
	[]_AC+[]		1588 #	5142
	[]_AC-1			1589 #	3536
	[]_AC-[]		1590 #	3405	4109	4139
	[]_AC-[]-.25		1591 #	4136
	[]_AC.AND.MASK		1595 #	3003	3051
	[]_APR			1599 #	7041	7042	7104	7136	7335
	[]_CURRENT AC []	1600 #
	[]_EA			1603 #	2355
	[]_EA FROM []		1601 #	5964
	[]_EXP			1604 #	5528	5544	5874
	[]_FE			1605 #	3076	6693
	[]_FLAGS		1606 #	3663	3677	3998	4024	7527	8888
	[]_IO DATA		1857 #	7512	7560	7656	8300
	[]_MEM			1858 #	2304	2374	2388	2397	2401	2429	2446	3584	3608	3623	3648
				3652	3713	3758	3794	3883	4040	4803	5950	5969	6389	6632	6660
				6936	6951	7021	7154	7289	7293	7297	7301	7305	7346	7385	7523
				7565	7736	7781	7784	7895	7934	8389	8471	8711	8763
	[]_MEM THEN FETCH	1859 #	2440
	[]_MEM*.5		1860 #
	[]_MEM.AND.MASK		1861 #	4809
	[]_P			1607 #	6563	6709
	[]_PC WITH FLAGS	1608 #	3724	3841	3847	4053	4254	7002	7539	8892
	[]_Q			1609 #	4162	4170	4390	4445	4462	4468	4477	5645	5652	5672	5695
				5754	5756
	[]_Q*.5			1610 #	4225	5409	5414	5684
	[]_Q*2			1611 #
	[]_Q*2 LONG		1612 #	4473	4483
	[]_Q+1			1613 #	5139
	[]_RAM			1614 #
	[]_TIME			1615 #	7360	7361	7362
	[]_VMA			1616 #	7750	7993	8263	8289	8809
	[]_VMA FLAGS		1878 #	7508	7555	7647	7650	7686	7697	7703	7929
	[]_VMA IO READ		1879 #	7508	7555	7647	7650	7929
	[]_VMA IO WRITE		1880 #	7686	7697	7703
	[]_WORK[]		1806 #	5005	5015	5214	6098	6099	6100	6101	6165	6376	6386	6419
				6420	6441	6617	6653	6730	6850	6861	6968	7093	7127	7219	7276
				7278	7280	7282	7284	7314	7323	7328	7334	7366	7370	7391	7723
				7728	7981	7986	7990	8005	8023	8025	8026	8028	8267	8367	8370
				8454	8457	8535	8537	8582	8622	8623	8624	8630	8819	8825	8834
				8838	8850
	[]_WORK[]+1		1809 #	6030	6063	6118	6216	6394	6857	6863
	[]_XR			1617 #	7726
	[]_[]			1618 #	2330	3054	3489	3492	3560	3561	3587	3614	3629	3688	3742
				3862	3867	4156	4184	4208	4224	4354	4363	4378	4384	4413	4768
				5076	5324	5325	5326	5364	5384	5392	5601	5602	5609	5610	5683
				5725	5728	5770	5771	6012	6032	6078	6113	6373	6384	6392	6459
				6559	6792	6883	6906	6925	6982	7048	7049	7229	7266	7365	7397
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 296
; 								Cross Reference Listing					

				7543	7625	7627	7634	7659	8340	8428	8579	8603	8900
	[]_[] SWAP		1619 #	2424	2604	2751	2753	2756	2759	2762	2765	3304	3309	3628
				3805	3864	3879	3997	4849	4975	4991	5091	5131	5140	5213	6438
				6495	6500	6501	6795	7128	7405	7418	7428	8481	8772
	[]_[] XWD 0		1620 #	6193	6308	7776	8304	8306	8320
	[]_[]*.5		1621 #	2187	2461	2462	3019	3040	3041	3045	3128	3131	4206	4263
				4425	4453	4584	4585	4586	4592	4853	4929	4978	4997	5399	5407
				5474	5523	5525	5541	5542	5561	5562	5567	5677	5710	5879	6502
				6505	6509	6511	6591	6699	6706	6769	7245	7247	7255	7261	7264
				7570	7588	7663	7669	8343	8359
	[]_[]*.5 LONG		1622 #	2420	3106	3134	3178	4158	4186	4265	4286	4299	4427	4429
				4441	4457	4472	4479	4531	4579	5079	5246	5266	5267	5268	5282
				5337	5360	5365	5440	5442	5472	5640	5643	5651	5654	5656	5670
				5705	5760	5786	5789	5823	5825	5871
	[]_[]*2			1623 #	2185	3007	3030	3043	3046	3073	4161	4188	4244	5097	5281
				5394	5402	5477	6240	6786	7195	7214	7216	7515	7551	7695	7701
				7792	8405	8408	8442	8585
	[]_[]*2 LONG		1624 #	3026	3107	3110	3111	3112	3137	3141	3144	3179	3182	3183
				4511	4591	4594	4596	4942	5261	5262	5519	5531	5539	5543	5617
				5622	5624	5636	5638	5639	5668	5709	5713	5762	5779	5801	5818
				5846
	[]_[]*4			1625 #	6496
	[]_[]+#			1626 #	3760	3789	6455	6464	7516	7561	8375	8383	8749	8759	8873
	[]_[]+.25		1627 #	5875
	[]_[]+0			1628 #
	[]_[]+1			1629 #	2215	2219	2449	2452	3439	3649	3670	4774	5180	5204	5289
				5486	5989	6090	6108	6137	6280	6348	6360	6367	6387	6408	6422
				6477	6540	6564	6658	6885	6927	7324	7790	8852	8913
	[]_[]+1000001		1630 #	3853	3870	5154
	[]_[]+AC		1631 #	4095	4125
	[]_[]+AC[]		1632 #	4122	6241	6251	6254
	[]_[]+Q			1633 #	4485
	[]_[]+RAM		1634 #	6471	6473
	[]_[]+WORK[]		1802 #	5073	6412	6592	6668	6775	6783	7367	7740	7742	8397	8399
				8476	8651
	[]_[]+XR		1635 #	2324	2336	2351	2364	3599	5963	5966	7734
	[]_[]+[]		1636 #	3983	4023	4238	4504	4507	4595	5338	5482	5565	5696	6053
				6085	6257	6268	6270	6707	6989	7005	7013	7318	7518	7553	7563
				7571	8739	8754
	[]_[]+[]+.25		1637 #
	[]_[]-#			1638 #
	[]_[]-1			1639 #	3455	6069	6173	6174	6285	6426	6463	6856	8842	8902
	[]_[]-1000001		1640 #
	[]_[]-AC		1641 #
	[]_[]-RAM		1642 #	6461	6466
	[]_[]-WORK[]		1811 #
	[]_[]-[]		1643 #	6048	6374	6985	7329	7453	7466
	[]_[]-[] REV		1644 #	6172
	[]_[].AND.AC		1670 #	2849	2972	3311	3334	7601
	[]_[].AND.NOT.#		1671 #	3656	4060	5859	6443	6811	6827	7094	7120	7232	7413	8554
				8604	8779
	[]_[].AND.NOT.AC	1673 #	2859	7631
	[]_[].AND.NOT.WORK[]	1804 #
	[]_[].AND.NOT.[]	1672 #	5620	7103	7106	7407	7417	7587
	[]_[].AND.Q		1674 #	4190	4862	4949
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 297
; 								Cross Reference Listing					

	[]_[].AND.WORK[]	1803 #	6171	8657
	[]_[].AND.[]		1675 #	4948	5547	5829	5831	6169	7430	8677
	[]_[].AND.#		1645 #	2457	2470	2492	3564	3573	3576	3578	3579	3580	3613	3618
				3621	3641	3662	3675	3957	3959	3961	3963	3965	3967	3969	3971
				3977	4075	4143	5100	5328	5332	5357	5390	5451	6204	6327	6503
				6506	6545	6676	6710	6713	6946	6956	7029	7038	7039	7040	7044
				7045	7046	7047	7052	7053	7054	7057	7058	7059	7060	7061	7062
				7063	7064	7096	7098	7130	7133	7158	7165	7169	7180	7199	7220
				7248	7254	7260	7265	7285	7308	7350	7403	7404	7665	7671	7862
				7871	7873	7875	7877	7879	7881	8264	8332	8488	8588	8598	8811
	[]_[].AND.# CLR LH	1646 #	3077	6618	6656	6696	6841	7066	7069	7137	7504	8346	8425
				8485	8503	8611
	[]_[].AND.# CLR RH	1647 #	5263	5953	5997	6197
	[]_[].EQV.AC		1676 #	2921
	[]_[].EQV.Q		1677 #	4168	4171	4193	4194
	[]_[].OR.#		1678 #	2186	2455	2493	4027	4032	4144	4497	4582	5329	5333	5358
				5391	5452	5647	5648	5655	5858	6209	6296	6340	6349	6354	6364
				6635	6639	6641	6702	6815	6819	6823	6831	6847	7222	7231	7336
				7411	7489	7490	7491	7492	7493	7494	7495	7930	8260	8325	8329
				8514	8517	8543	8550	8592	8596	8613	8615	8619	8675	8782	8786
				8791	8798	8803	8876
	[]_[].OR.AC		1679 #	2901	3329	7629
	[]_[].OR.FLAGS		1680 #
	[]_[].OR.WORK[]		1805 #	6983	6992	8430	8525
	[]_[].OR.[]		1681 #	2942	4130	4950	5955	6054	6284	6715	7097	7101	7108	7139
				7184	7206	7208	7409	7415	7557	8600	8814
	[]_[].XOR.AC		1683 #	2891	3326
	[]_[].XOR.[]		1684 #	5833
	[]_[].XOR.#		1682 #	4451	8338
	.NOT.[]			1552 #	4368	7431	7506
	2T			1890 #	4447	4460	5327	5597	6171	6241	6305	6593	6730	6775	7370
				7727
	3T			1891 #	2223	2448	2458	2613	3146	3320	3405	3439	3455	3545	3635
				3719	3754	3762	3787	3791	3808	3813	3818	3855	3871	4096	4110
				4213	4215	4234	4268	4405	4409	4459	4465	4466	4467	4484	4488
				4509	4517	4598	4663	4680	4738	4753	4824	4842	4938	4982	4989
				5069	5085	5089	5155	5157	5176	5200	5287	5321	5355	5396	5427
				5428	5431	5463	5466	5520	5522	5524	5526	5585	5586	5589	5591
				5690	5691	5692	5736	5740	5742	5744	5752	5835	5841	6001	6019
				6021	6069	6073	6136	6243	6257	6271	6303	6306	6391	6394	6426
				6427	6455	6461	6464	6473	6498	6512	6539	6559	6560	6682	6689
				6733	6792	6882	6889	6910	6924	6928	6931	6933	6969	7024	7154
				7161	7174	7221	7230	7487	7512	7516	7524	7525	7526	7561	7565
				7567	7734	8375	8383	8609	8626	8749	8760	8844	8874
	4T			1892 #	3051	3522	3536	4122	4127	4134	4137	4139	5029	5034	6015
				6045	6222	6227	6252	6293	6466	6514	6654	6777	6978	7987	8295
				8368	8371	8455	8458	8737	8747
	5T			1893 #	7288	7292	7296	7300	7304	7756	7773
	7-BIT DPB		4919 #	4923	4924	4925	4926	4927
	7-BIT LDB		4821 #	4829	4830	4831	4832	4833
(D) MACRO%
	AC			2159 #	2582	2583	2587	2588	2592	2593	2597	2598	2619	2635	2636
				2640	2641	2645	2646	2650	2651	2655	2656	2660	2661	2665	2666
				2670	2671	2677	2678	2682	2683	2687	2688	2692	2693	2697	2698
				2702	2703	2707	2708	2712	2713	2802	2832	2833	2842	2843	2852
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 298
; 								Cross Reference Listing					

				2853	2862	2863	2867	2868	2884	2885	2894	2895	2904	2905	2914
				2915	2924	2925	2934	2935	2945	2946	2955	2956	2965	2966	2975
				2976	4088	4089	4102	4103	4150	4151	4720	8256
	AC DISP			2173 #	3551	7034	7035	7271
	B			2161 #	2835	2845	2855	2865	2870	2887	2897	2907	2917	2927	2937
				2948	2958	2968	2978	4091	4105	4153
	DAC			2163 #	2801	4117	4118	4175	4176	4201	4342	4343	4347	4348	4419
				5661	5722
	DBL AC			2148 #	2810
	DBL B			2164 #	4178	4345	4350
	DBL FL-R		2154 #	5572	5573	5661	5722
	DBL R			2147 #	2801	2802	4117	4118	4201	4419
	FL-AC			2165 #	5298	5301	5302	5306	5309	5310	5343	5347	5348	5372	5376
				5377	5422	5423	5457	5458
	FL-BOTH			2167 #	5300	5304	5308	5312	5345	5350	5374	5379
	FL-I			2153 #	5302	5310	5348	5377
	FL-MEM			2166 #	5299	5303	5307	5311	5344	5349	5373	5378
	FL-R			2151 #	5298	5301	5306	5309	5343	5347	5372	5376	5457	5458
	FL-RW			2152 #	5299	5300	5303	5304	5307	5308	5311	5312	5344	5345	5349
				5350	5373	5374	5378	5379
	I			2139 #	2878	2990	3210	3211	3212	3213	3214	3215	3216	3217	3219
				3220	3228	3229	3230	3231	3232	3233	3234	3235	3246	3247	3248
				3249	3250	3251	3252	3253	3263	3264	3265	3266	3267	3268	3269
				3270	3385	3386	3387	3388	3389	3390	3391	3392	3497	3498	3499
				3500	3501	3502	3503	3504	3512	3513	3514	3515	3516	3517	3518
				3526	3527	3528	3529	3530	3531	3532	3539	3540	3551	3553	3704
				3706	3707	3834	3835	3836	3837	3890	3891	3892	3893	3894	3895
				3896	3897	3901	3902	3903	3904	3905	3906	3907	3908	3909	3910
				3911	3912	3913	3914	3915	3916	3917	3918	3919	3920	3921	3922
				3923	3924	3925	3926	3927	3928	3929	3930	3931	3932	3936	3937
				3938	3939	3943	3944	3945	3946	3947	3948	3949	3950	3951	3952
				3953	5147	5423	5887	5888	5889	5890	5891	5892	5893	5895	5896
				5897	5898	5900	5901	5902	5903	5905	5906	5907	5908	5909	5910
				5911	5912	5946	7805	7806	7807	7809	7810	7812	7813	7815	7816
				7817	7818	7819	7820	7821	7822	7824	7825	7826	7827	7828	7829
				7830	7831	7833	7834	7835	7836	7837	7838	7839	7840	7842	7843
				7844	7845	7846	7847	7848	7849	7851	7852	7853	7854	7855	7856
				7857	7858
	I-PF			2140 #	2583	2588	2593	2598	2636	2641	2646	2651	2656	2661	2666
				2671	2678	2683	2688	2693	2698	2703	2708	2713	2832	2833	2843
				2853	2863	2868	2885	2895	2905	2915	2924	2925	2935	2946	2956
				2966	2975	2976	2991	3511	3525	3801	4089	4103	4151	4176	4343
				4348
	IOT			2155 #	7034	7035	7271	7593	7594	7595	7596	7604	7605	7606	7607
				7618	7619	7620	7621	7886	7887	8256
	IR			2146 #	3705
	IW			2145 #	2834	2835	2926	2927	2977	2978
	M			2160 #	2584	2589	2594	2599	2637	2642	2647	2652	2657	2662	2667
				2672	2679	2684	2689	2694	2699	2704	2709	2714	2834	2844	2854
				2864	2869	2879	2880	2886	2896	2906	2916	2926	2936	2947	2957
				2967	2977	4090	4104	4152	4177	4344	4349	7271
	R			2141 #	2619	2877	3221	3222	3223	3224	3225	3226	3237	3238	3239
				3240	3241	3242	3243	3244	3255	3256	3257	3258	3259	3260	3261
				3262	3272	3273	3274	3275	3276	3277	3278	3279	3394	3395	3396
				3397	3398	3399	3400	3401	3411	3412	3413	3414	3415	3416	3417
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 299
; 								Cross Reference Listing					

				3418	3682	4720	4721	4722	4723	4724	5422
	R-PF			2142 #	2582	2587	2592	2597	2635	2640	2645	2650	2655	2660	2665
				2670	2677	2682	2687	2692	2697	2702	2707	2712	2842	2852	2862
				2867	2884	2894	2904	2914	2934	2945	2955	2965	4088	4102	4150
				4175	4342	4347
	ROUND			2168 #	5301	5302	5303	5304	5309	5310	5311	5312	5347	5348	5349
				5350	5376	5377	5378	5379	5422	5458
	RW			2144 #	2585	2590	2595	2600	2637	2638	2642	2643	2648	2653	2658
				2663	2668	2673	2679	2680	2684	2685	2690	2695	2700	2705	2710
				2715	2844	2845	2854	2855	2864	2865	2869	2870	2886	2887	2896
				2897	2906	2907	2916	2917	2936	2937	2947	2948	2957	2958	2967
				2968	3428	3429	3430	3431	3432	3433	3434	3435	3444	3445	3446
				3447	3448	3449	3450	3451	4090	4091	4104	4105	4152	4153	4177
				4178	4344	4345	4349	4350
	S			2162 #	2585	2590	2595	2600	2638	2643	2648	2653	2658	2663	2668
				2673	2680	2685	2690	2695	2700	2705	2710	2715
	SH			2149 #	2987	2988	2989
	SHC			2150 #	2992	2993
	SJC-			3345 #	3385	3394	3411	3428	3444	3497	3511	3525
	SJCA			3349 #	3389	3398	3415	3432	3448	3501	3515	3529
	SJCE			3347 #	3387	3396	3413	3430	3446	3499	3513	3527	5888
	SJCG			3352 #	3392	3401	3418	3435	3451	3504	3518	3532	5893
	SJCGE			3350 #	3390	3399	3416	3433	3449	3502	3516	3530	3539	5891
	SJCL			3346 #	3386	3395	3412	3429	3445	3498	3512	3526	3540	5887
	SJCLE			3348 #	3388	3397	3414	3431	3447	3500	3514	3528	5889
	SJCN			3351 #	3391	3400	3417	3434	3450	3503	3517	3531	5892
	TC-			3201 #	3246	3247	3255	3256
	TCA			3203 #	3250	3251	3259	3260
	TCE			3202 #	3248	3249	3257	3258
	TCN			3204 #	3252	3253	3261	3262
	TN-			3191 #
	TNA			3194 #	3214	3215	3223	3224
	TNE			3192 #	3212	3213	3221	3222	7595
	TNN			3195 #	3216	3217	3225	3226	7596
	TO-			3205 #	3263	3264	3272	3273
	TOA			3207 #	3267	3268	3276	3277
	TOE			3206 #	3265	3266	3274	3275
	TON			3208 #	3269	3270	3278	3279
	TZ-			3197 #	3228	3229	3237	3238
	TZA			3199 #	3232	3233	3241	3242
	TZE			3198 #	3230	3231	3239	3240
	TZN			3200 #	3234	3235	3243	3244
	W			2143 #	2584	2589	2594	2599	2647	2652	2657	2662	2667	2672	2689
				2694	2699	2704	2709	2714	2811	2879	2880
	W TEST			2172 #	2619	4721	4723
	WORD-TNE		3193 #	7593
	WORD-TNN		3196 #	7594
(U) MEM				989 #	2196	2215	2219	2263	2263	2263	2264	2264	2266	2266	2267
				2267	2267	2285	2286	2303	2311	2326	2326	2332	2332	2337	2338
				2342	2343	2356	2365	2366	2369	2370	2374	2378	2387	2396	2398
				2399	2400	2428	2439	2440	2440	2450	2451	2453	2454	2458	2465
				2465	2529	2561	2567	2572	2575	2604	2610	2624	2625	2724	2726
				2759	2765	2773	2775	2794	2796	2819	2820	2822	2823	2824	2826
				2839	2849	2859	2891	2901	2921	2931	2942	2952	2982	3055	3055
				3361	3361	3361	3373	3373	3440	3441	3488	3488	3488	3489	3489
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 300
; 								Cross Reference Listing					

				3492	3492	3493	3493	3493	3560	3560	3561	3561	3562	3562	3567
				3567	3571	3571	3574	3574	3583	3587	3587	3600	3601	3603	3604
				3607	3622	3629	3629	3644	3648	3650	3651	3652	3665	3665	3667
				3667	3668	3671	3676	3676	3712	3716	3717	3729	3735	3743	3744
				3753	3754	3757	3765	3767	3770	3772	3774	3780	3786	3788	3794
				3849	3850	3851	3863	3880	3881	3882	3992	3993	3993	3993	4002
				4003	4003	4003	4004	4006	4012	4017	4017	4017	4036	4037	4038
				4039	4051	4055	4064	4064	4064	4073	4074	4078	4080	4081	4082
				4096	4110	4162	4168	4191	4193	4256	4256	4256	4731	4731	4731
				4740	4740	4768	4774	4775	4787	4788	4791	4792	4795	4796	4799
				4800	4802	4808	4929	4930	5132	5133	5160	5161	5168	5169	5171
				5182	5183	5185	5187	5188	5190	5194	5197	5205	5206	5208	5243
				5284	5284	5286	5290	5290	5291	5482	5486	5532	5554	5950	5964
				5966	5966	5967	5967	5969	5990	5991	6138	6138	6387	6388	6389
				6414	6415	6459	6465	6472	6488	6488	6493	6493	6549	6549	6581
				6583	6627	6627	6629	6632	6660	6669	6669	6784	6785	6931	6931
				6932	6932	6933	6933	6934	6934	6936	6950	7006	7009	7010	7014
				7017	7018	7021	7151	7152	7153	7256	7256	7288	7289	7292	7293
				7296	7297	7300	7301	7304	7305	7344	7345	7347	7348	7372	7373
				7376	7377	7377	7377	7378	7384	7385	7420	7420	7420	7438	7438
				7439	7444	7507	7511	7522	7522	7522	7522	7523	7523	7538	7559
				7564	7564	7564	7565	7572	7573	7653	7653	7655	7688	7688	7689
				7691	7691	7691	7713	7714	7735	7735	7736	7781	7784	7786	7794
				7794	7796	7798	7891	7892	7894	7899	7900	7909	7912	7912	7912
				7914	7915	7915	7915	7926	7927	7933	7982	7998	7998	7998	7999
				8000	8001	8001	8001	8002	8003	8006	8007	8008	8008	8008	8009
				8010	8011	8011	8011	8012	8013	8014	8014	8014	8015	8016	8017
				8017	8017	8018	8019	8020	8020	8020	8021	8022	8024	8027	8324
				8372	8373	8373	8373	8380	8381	8381	8381	8385	8386	8387	8388
				8465	8466	8467	8470	8601	8609	8625	8662	8706	8707	8708	8710
				8740	8741	8742	8755	8756	8757	8762	8823	8829	8877	8878	8878
				8878	8879	8893	8901	8908	8910	8914	8914	8914	8917	8917	8917
(U) MICROCODE OPTION(INH@	1269 #
	OPT			1271 #	7082
(U) MICROCODE OPTION(KIP@	1293 #
	OPT			1295 #	7086
(U) MICROCODE OPTION(KLP`	1299 #
	OPT			1301 #	7087
(U) MICROCODE OPTION(NOC`	1275 #
	OPT			1279 #	7083
(U) MICROCODE OPTION(NON	1281 #
	OPT			1285 #	7084
(U) MICROCODE OPTION(UBA 	1287 #
	OPT			1289 #	7085
(U) MICROCODE OPTIONS		1262 #
(U) MICROCODE RELEASE(MA	1309 #
	UCR			1310 #	7074
(U) MICROCODE RELEASE(MI`	1312 #
	UCR			1313 #	7075
(U) MICROCODE VERSION		1306 #
	UCV			1307 #	7088
(D) MODE			1373 #
(U) MULTI PREC			994 #	4438	4490	4505	4508	4515	4629	5583	5616	5736	5747
(U) MULTI SHIFT			996 #	3008	3020	3042	3047	4855	4860	4936	4944	5281	5282
(U) PHYSICAL			1163 #	3993	4003	4017	4037	4064	7010	7018	7450	7451	7454	7463
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 301
; 								Cross Reference Listing					

				7464	7467	7508	7522	7555	7564	7647	7650	7686	7697	7703	7912
				7915	7929	7998	8001	8008	8011	8014	8017	8020	8373	8381	8387
				8467	8708	8741	8757	8878	8914	8917
(U) PI.CLR			1222 #	7400
(U) PI.CO1			1211 #
(U) PI.CO2			1212 #
(U) PI.DIR			1221 #	7406
(U) PI.IP1			1203 #	7583
(U) PI.IP2			1204 #
(U) PI.IP3			1205 #
(U) PI.IP4			1206 #
(U) PI.IP5			1207 #
(U) PI.IP6			1208 #
(U) PI.IP7			1209 #
(U) PI.MBZ			1220 #	7402
(U) PI.ON			1210 #	7411	7413
(U) PI.REQ			1223 #	7408
(U) PI.SC1			1228 #
(U) PI.SC2			1229 #
(U) PI.SC3			1230 #
(U) PI.SC4			1231 #
(U) PI.SC5			1232 #
(U) PI.SC6			1233 #
(U) PI.SC7			1234 #
(U) PI.TCF			1225 #	7416
(U) PI.TCN			1224 #	7414
(U) PI.TSF			1226 #	7412
(U) PI.TSN			1227 #	7410
(U) PI.ZER			1202 #
(U) PXCT			1167 #
	BIS-DST-EA		1173 #	6925	6927	6933	6934	6936
	BIS-SRC-EA		1171 #
	CURRENT			1168 #	2263	2264	2266	2267	2286	2326	2332	2440	2465	3055	3361
				3373	3488	3489	3492	3493	3560	3561	3585	3587	3609	3624	3629
				3744	4256	4731	4740	7420	7691	7732	7927
	D1			1170 #	2356	2398	2450	2453	2821	2825	3766	3771	5162	5170	5184
				5189	5285
	D2			1174 #	3718	3755	3787	4789	4793	5134	5207	5291	6931	6932
	E1			1169 #	2365	2370	2376	3605	3691
	E2			1172 #	4738	4757	4797	4801	4805	5957	5966	5967	5969	6888
(U) RAMADR			706 #
	AC#			707 #	2392	2405	2419	2556	2623	2724	2726	2757	2763	2849	2859
				2891	2901	2921	2931	2941	2972	3000	3003	3017	3023	3035	3038
				3051	3113	3125	3146	3311	3326	3329	3334	3335	3405	3424	3464
				3467	3470	3473	3476	3479	3482	3485	3508	3522	3536	3544	3714
				3745	3747	3752	3785	3807	3810	3815	3843	3865	3878	4095	4109
				4125	4136	4139	4156	4157	4183	4185	4232	4247	4354	4355	4364
				4445	4447	4489	4491	4662	4663	4667	4745	4751	4755	5031	5103
				5142	5151	5152	5216	5239	5241	5321	5354	5384	5386	5449	5450
				5478	5484	5586	5590	5592	5596	5688	5739	5840	5841	5996	6087
				6124	6126	6134	6160	6196	6298	6330	6332	6344	6353	6423	6490
				6644	6717	6969	6993	7601	7612	7615	7629	7631	7800	7902	8270
	AC*#			708 #	2208	2209	2216	2406	2418	2524	2807	2816	3057	3078	3122
				3152	4122	4134	4213	4215	4217	4225	4227	4234	4236	4248	4249
				4250	4251	4252	4253	4365	4449	4471	4475	4478	4492	4493	4495
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 302
; 								Cross Reference Listing					

				4498	4517	4519	4521	4522	4648	4649	4652	4653	4654	4657	4658
				4659	4665	4666	5585	5676	5729	5731	5737	5796	5804	5842	5849
				5993	6001	6011	6014	6044	6047	6060	6067	6074	6084	6122	6132
				6152	6167	6184	6199	6201	6227	6230	6232	6239	6240	6241	6243
				6249	6251	6254	6260	6262	6290	6292	6293	6297	6304	6305	6306
				6310	6311	6318	6320	6325	6331	6347	6358	6370	6379	6385	6396
				6399	6401	6405	6418	6424	6425	6548	6579	6584	6589	6626	6628
				6732	6733	6845	6852	6859	6878	6880	6887	6907	6928	6964	6966
				6972	6974	6978	6981	6986
	RAM			711 #	2218	2220	6461	6466	6471	6473
	VMA			710 #	2196	2304	2374	2388	2397	2401	2429	2440	2446	2459	2530
				2562	2568	2573	2576	2626	2822	3441	3584	3608	3623	3644	3648
				3652	3713	3730	3736	3758	3775	3781	3794	3852	3883	4005	4007
				4013	4040	4052	4056	4079	4775	4803	4809	4930	5172	5195	5198
				5244	5286	5950	5969	6389	6583	6629	6632	6660	6936	6951	7021
				7154	7289	7293	7297	7301	7305	7346	7376	7378	7385	7439	7507
				7512	7523	7560	7565	7656	7689	7736	7781	7784	7786	7796	7798
				7895	7909	7914	7934	7982	7999	8000	8002	8003	8006	8007	8009
				8010	8012	8013	8015	8016	8018	8019	8021	8022	8024	8300	8324
				8389	8471	8711	8763	8823	8829	8880	8894	8908	8910
	XR#			709 #	2314	2324	2336	2351	2364	2380	3589	3591	3599	4782	4785
				4787	4795	5961	5963	5966	6931	6933	6937	7725	7726	7734
	#			712 #	2195	2203	2205	2206	2211	2212	3698	4728	4987	5000	5005
				5010	5014	5015	5020	5026	5052	5065	5073	5078	5084	5214	5960
				5973	5976	6006	6023	6030	6034	6051	6063	6068	6079	6083	6094
				6095	6096	6098	6099	6100	6101	6111	6118	6142	6158	6165	6170
				6171	6178	6181	6194	6212	6216	6219	6223	6333	6335	6376	6386
				6391	6392	6394	6397	6410	6412	6416	6419	6420	6441	6591	6592
				6615	6617	6653	6658	6668	6730	6736	6763	6767	6770	6775	6776
				6783	6850	6857	6861	6863	6952	6968	6977	6983	6991	6992	6995
				7003	7093	7115	7127	7219	7224	7276	7278	7280	7282	7284	7290
				7294	7298	7302	7306	7314	7321	7323	7328	7332	7334	7353	7356
				7366	7367	7370	7386	7387	7391	7471	7472	7720	7723	7728	7740
				7742	7754	7760	7762	7907	7979	7981	7986	7990	7994	8004	8005
				8023	8025	8026	8028	8266	8267	8287	8288	8290	8291	8298	8308
				8310	8312	8314	8318	8319	8367	8370	8397	8399	8430	8437	8454
				8457	8460	8462	8476	8483	8525	8535	8537	8566	8582	8622	8623
				8624	8630	8650	8651	8657	8808	8819	8825	8834	8838	8850
(D) READ			1384 #	2582	2583	2585	2587	2588	2590	2592	2593	2595	2597	2598
				2600	2619	2635	2636	2637	2638	2640	2641	2642	2643	2645	2646
				2648	2650	2651	2653	2655	2656	2658	2660	2661	2663	2665	2666
				2668	2670	2671	2673	2677	2678	2679	2680	2682	2683	2684	2685
				2687	2688	2690	2692	2693	2695	2697	2698	2700	2702	2703	2705
				2707	2708	2710	2712	2713	2715	2801	2802	2832	2833	2842	2843
				2844	2845	2852	2853	2854	2855	2862	2863	2864	2865	2867	2868
				2869	2870	2877	2884	2885	2886	2887	2894	2895	2896	2897	2904
				2905	2906	2907	2914	2915	2916	2917	2924	2925	2934	2935	2936
				2937	2945	2946	2947	2948	2955	2956	2957	2958	2965	2966	2967
				2968	2975	2976	2987	2988	2989	2991	2992	2993	3221	3222	3223
				3224	3225	3226	3237	3238	3239	3240	3241	3242	3243	3244	3255
				3256	3257	3258	3259	3260	3261	3262	3272	3273	3274	3275	3276
				3277	3278	3279	3394	3395	3396	3397	3398	3399	3400	3401	3411
				3412	3413	3414	3415	3416	3417	3418	3428	3429	3430	3431	3432
				3433	3434	3435	3444	3445	3446	3447	3448	3449	3450	3451	3511
				3525	3682	3705	3801	4088	4089	4090	4091	4102	4103	4104	4105
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 303
; 								Cross Reference Listing					

				4117	4118	4150	4151	4152	4153	4175	4176	4177	4178	4201	4342
				4343	4344	4345	4347	4348	4349	4350	4419	4720	4721	4722	4723
				4724	5298	5299	5300	5301	5302	5303	5304	5306	5307	5308	5309
				5310	5311	5312	5343	5344	5345	5347	5348	5349	5350	5372	5373
				5374	5376	5377	5378	5379	5422	5457	5458	5572	5573	5661	5722
				5946
(U) READ CYCLE			1155 #	2263	2264	2266	2267	2286	2326	2332	2337	2343	2366	2370
				2399	2440	2451	2454	2465	3055	3361	3373	3488	3489	3492	3493
				3560	3561	3562	3567	3571	3574	3587	3601	3604	3629	3651	3671
				3744	3754	3788	3881	4038	4082	4256	4731	4740	4788	4792	4796
				4800	5133	5208	5291	5966	5967	5991	6138	6388	6415	6488	6493
				6549	6669	6785	6931	6932	6933	6934	7009	7017	7152	7288	7292
				7296	7300	7304	7344	7348	7384	7420	7508	7522	7555	7564	7573
				7647	7650	7691	7714	7735	7892	7927	7929	8373	8381	8386	8466
				8605	8707	8742	8756	8914
(D) ROUND			1372 #	5301	5302	5303	5304	5309	5310	5311	5312	5347	5348	5349
				5350	5376	5377	5378	5379	5422	5458
(U) RSRC			640 #
	AB			642 #	3698	7720
	AQ			641 #
	D0			648 #	2794	6193	6308	7508	7555	7647	7650	7686	7697	7703	7776
				7929	8304	8306	8320
	DA			646 #	2190	2193	2226	2237	2273	2277	2280	2283	2292	2295	2298
				2301	2552	3077	3615	3981	4021	4069	4433	4444	4838	5918	5920
				5922	5924	5926	5928	5930	5932	5934	6618	6630	6656	6696	6841
				7066	7069	7137	7317	7360	7361	7362	7496	7497	7498	7499	7500
				7501	7502	7504	7537	7569	8282	8346	8425	8485	8503	8611	8833
	DQ			647 #
	0A			645 #	2355	2796	3724	3841	3847	4053	4254	5259	5589	5591	5691
				5692	5742	5744	5964	7002	7539	8892
	0B			644 #	2773	2775
	0Q			643 #	3663	3677	3998	4024	5263	5953	5997	6197	7527	8888
(U) S#				1030 #	2210	2413	2432	2432	2447	2447	2463	3001	3004	3008	3018
				3020	3036	3039	3042	3047	3059	3074	3076	3103	3120	3129	3132
				3175	4157	4185	4222	4242	4262	4375	4472	4480	4742	4824	4847
				4852	4854	4856	4859	4922	4923	4924	4925	4926	4927	4935	4939
				4941	4943	4976	4992	5003	5016	5032	5077	5092	5251	5253	5271
				5273	5281	5282	5325	5327	5359	5364	5366	5392	5393	5406	5407
				5429	5433	5435	5436	5440	5448	5463	5466	5468	5519	5523	5525
				5528	5531	5539	5541	5542	5543	5544	5562	5567	5597	5608	5623
				5625	5666	5677	5681	5684	5694	5700	5706	5717	5755	5756	5766
				5780	5787	5790	5802	5819	5824	5826	5847	5872	5874	5880	6018
				6019	6021	6187	6332	6500	6502	6509	6558	6563	6565	6688	6690
				6692	6693	6699	6709	6892	7193	7214	7245	7255	7261	7475	7663
				7695	7749	7765	8341	8392	8440	8580
(U) SCAD			1007 #
	A			1015 #	2210	3059	4157	4185	4222	4242	4262	4375	4472	4480	4738
				4752	4829	4830	4831	4832	4833	4938	4976	4992	5003	5016	5032
				5077	5092	5251	5253	5271	5273	5359	5406	5429	5433	5435	5436
				5440	5666	5677	5681	5694	5700	5755	5756	6332	6500	6502	6509
				6558	6688	6689	6699	6889	6910	6929	7193	7214	7245	7255	7261
				7475	7663	7695	7749	7765	8341	8392	8440	8580
	A*2			1008 #	6681
	A+B			1012 #	2413	2432	2432	2447	2447	3004	3008	3018	3020	3039	3042
				3047	3074	3076	3120	3129	4854	4859	4923	4924	4925	4926	4927
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 304
; 								Cross Reference Listing					

				4935	4943	5281	5282	5325	5327	5355	5364	5366	5407	5448	5450
				5462	5466	5519	5523	5525	5528	5531	5539	5541	5542	5543	5544
				5562	5567	5597	5608	5623	5625	5689	5706	5717	5780	5787	5790
				5802	5819	5824	5826	5847	5872	5874	5880	6018	6019	6021	6559
				6563	6691	6692	6693	6709	6997
	A-1			1014 #	2220	3024	3026	3102	3104	3106	3110	3136	3143	3174	3176
				3178	3182	4288	4300	4306	4314	4324	4332	4587	4590	4630	4979
				4998	5098	5335	5337	5443	5467	5470	5473	5477	5641	5644	5651
				5669	6361	6505	6511	6706	7196	7216	7247	7264	7455	7468	7670
				7701	7756	7769	8344	8406	8409	8443	8586
	A-B			1011 #	3001	3036	3103	3132	3175	4730	4735	4749	4770	4824	4847
				4852	4856	4922	4941	5386	5392	5393	5468	5740	5766	6071	6081
				6881	6884	6924	6926
	A-B-1			1010 #	5321	5326	5587	5607
	A.AND.B			1013 #	4742	4939	6187	6565	6690	6892
	A.OR.B			1009 #	2463	5684
(U) SCADA			1016 #
	BYTE1			1020 #	4730	4735	4738	4749	4829	4938	6071	6559	6689	6881	6889
				6924	6929	6997
	BYTE2			1021 #	4830
	BYTE3			1022 #	4831
	BYTE4			1023 #	4832
	BYTE5			1024 #	4753	4833	6682	6911
	PTR44			1019 #	4770	6081	6884	6926
	S#			1018 #	2210	2413	2432	2432	2447	2447	2463	3001	3004	3008	3018
				3020	3036	3039	3042	3047	3059	3074	3076	3103	3120	3129	3132
				3175	4157	4185	4222	4242	4262	4375	4472	4480	4742	4824	4847
				4852	4854	4856	4859	4922	4923	4924	4925	4926	4927	4935	4939
				4941	4943	4976	4992	5003	5016	5032	5077	5092	5251	5253	5271
				5273	5281	5282	5325	5327	5359	5364	5366	5392	5393	5406	5407
				5429	5433	5435	5436	5440	5448	5462	5466	5468	5519	5523	5525
				5528	5531	5539	5541	5542	5543	5544	5562	5567	5597	5608	5623
				5625	5666	5677	5681	5684	5694	5700	5706	5717	5755	5756	5766
				5780	5787	5790	5802	5819	5824	5826	5847	5872	5874	5880	6018
				6019	6021	6187	6332	6500	6502	6509	6558	6563	6565	6688	6690
				6692	6693	6699	6709	6892	7193	7214	7245	7255	7261	7475	7663
				7695	7749	7765	8341	8392	8440	8580
	SC			1017 #	2220	3024	3026	3102	3104	3106	3110	3136	3143	3174	3176
				3178	3182	4288	4300	4306	4314	4324	4332	4587	4590	4630	4979
				4998	5098	5321	5326	5335	5337	5355	5386	5443	5450	5467	5470
				5473	5477	5587	5607	5641	5644	5651	5669	5689	5740	6361	6505
				6511	6691	6706	7196	7216	7247	7264	7455	7468	7670	7701	7756
				7769	8344	8406	8409	8443	8586
(U) SCADB			1025 #
	EXP			1027 #	2432	2432	2447	2447	5321	5325	5327	5355	5386	5450	5587
				5597	5608	5689	5740
	FE			1026 #	2463	3001	3004	3008	3018	3020	3036	3039	3042	3047	3074
				3076	3129	3132	4742	4824	4847	4852	4854	4859	4923	4924	4925
				4926	4927	4935	4939	4941	4943	5281	5282	5326	5364	5366	5392
				5393	5407	5463	5466	5468	5519	5523	5525	5528	5531	5539	5541
				5542	5543	5544	5562	5567	5607	5623	5625	5684	5706	5717	5766
				5780	5787	5790	5802	5819	5824	5826	5847	5872	5874	5880	6019
				6021	6187	6559	6563	6565	6690	6691	6692	6693	6709	6892
	SHIFT			1028 #	2413	3103	3120	3175	5448
	SIZE			1029 #	4730	4735	4749	4770	4856	4922	6018	6071	6081	6881	6884
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 305
; 								Cross Reference Listing					

				6924	6926	6997
(U) SETFOV			1111 #	5388	5400	5753
(U) SETFPD			1117 #	4270	4784	6427
(U) SETNDV			1112 #	4377	4412	4443	4529	5036	5388	5400	5753
(U) SETOV			1109 #	4170	4171	4195	4257	4377	4412	4443	4529	5036	5388	5400
				5465	5753
(U) SHSTYLE			854 #
	ASHC			859 #	3026	3135	3138	3142	3145	4306	4314	4324	4332	4438	4442
				4511	4515	4531	5337	5440	5442	5472	5616	5618	5622	5624	5640
				5644	5651	5654	5656	5668	5709	5713	5748	5762	5780	5786	5789
				5802	5819	5823	5825	5847	5872
	DIV			861 #	4587	4590	4591	4634	4638	5519	5531	5539	5543	5636	5638
				5639
	LSHC			860 #	3106	3110	4619	4622
	NORM			855 #	2460	3020	4265	4299	4472	4628	5246	5261	5262	5266	5267
				5268	5282	5670	5760
	ONES			857 #	4858	4861	4934	4937	6021
	ROT			858 #	3042	3047
	ROTC			862 #	3178	3182
	ZERO			856 #
(U) SKIP			932 #
	AC0			940 #	2519	3423	4727
	ADEQ0			952 #	3052	3367	3379	3470	3482	4160	4165	4367	4369	4373	4387
				4432	4461	4491	4572	4650	4655	4660	4676	4683	5001	5030	5384
				5410	5412	5485	5527	5551	5707	5758	5800	5845	6175	6228	6304
				6307	6596	6633	6654	6777	7364	8368	8371	8437	8455	8458	8566
				8650
	ADLEQ0			936 #	2223	4025	4030	5427	5432	5546	5711	5714	5782	5785	5788
				5791	5851	5951	5994	6133	6135	6217	6237	6421	6437	6491	6526
				6529	6561	7025	7161	7175	7221	7230	7525	7526	7717	7719	7733
				8328	8350	8394	8401	8404	8419	8424	8473	8492	8496	8502	8516
				8520	8522	8542	8595	8614	8616	8654	8659	8681	8684	8686	8689
				8692	8713	8723	8777	8795	8836	8885
	ADREQ0			937 #	3121	3627	3642	5158	6362	6435	6790	7067	7073	7100	7102
				7105	7107	7109	7400	7402	7406	7408	7410	7412	7414	7416	7513
				7566	7586	7658	7685	8268	8547	8575	8764	8781	8784	8789
	CRY0			935 #	3720	3763	3792	5396	5520	5522	5524	5526
	CRY1			948 #	4123	4135	5836	6252	6258	6271	6462	6473
	CRY2			943 #	5809	5869
	DP0			944 #	2433	2448	2607	2785	2792	3075	3147	3364	3376	3467	3479
				3809	3812	3817	3988	4142	4167	4189	4192	4247	4255	4356	4392
				4394	4399	4404	4408	4430	4447	4459	4466	4481	4500	4518	4570
				4577	4592	5033	5177	5201	5287	5323	5327	5356	5386	5394	5428
				5450	5481	5588	5690	5737	5741	5752	5765	6002	6015	6032	6045
				6052	6070	6112	6114	6136	6153	6156	6162	6202	6294	6299	6336
				6345	6378	6395	6467	6517	6543	6734	6764	6806	6860	6979	7155
				7319	8355	8453	8680	8734
	DP18			945 #	2412	2771	2778	5975	6222	6426	6515	6838	6839	7552	8737
				8747	8770
	EXECUTE			954 #	7921
	FPD			939 #	4209	4730	4735	4749	6326
	INT			941 #	5181	6072	8292	8487	8709	8817	8848	8899
	IOLGL			933 #	2469	3572	3575
	IOT			946 #
	JFCL			947 #	3634
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 306
; 								Cross Reference Listing					

	KERNEL			938 #	3565	3569	3570	3577	3686	7004
	LE			942 #	3370	3382	3473	3485	4426	5060	5404	5728	6375	7330	7987
	LLE			934 #	7726
	SC			953 #	2220	3024	3026	3102	3104	3106	3110	3127	3136	3143	3174
				3176	3178	3182	4288	4300	4306	4314	4324	4332	4587	4590	4630
				4979	4998	5098	5335	5337	5443	5467	5470	5473	5477	5590	5592
				5641	5644	5651	5669	6361	6505	6511	6697	6706	7196	7216	7247
				7264	7455	7468	7670	7701	7769	8344	8406	8409	8443	8586
	TRAP CYCLE		950 #	8835
	TXXX			949 #	3320
	-1 MS			957 #	5173	6067	7368	8482
	-CONTINUE		956 #	7923
	-IO BUSY		955 #	7751	7757	7766	7774
(U) SPEC			818 #	2604	2610	2724	2726	2759	2765	2773	2775	2794	2796	2839
				2849	2859	2891	2901	2921	2931	2942	2952	2982	4162	4168	4191
				4193	8601	8901
	APR EN			832 #	2201	7114	7223
	APR FLAGS		830 #	7119	7123	7338
	ASHOV			839 #	3026	3142	3145
	CLR IO BUSY		822 #	7644	7682
	CLR IO LATCH		821 #	7729	7737	7741	7744	7753	7759	7768	7773
	CLRCLK			820 #	7315	7369	8536	8820
	CLRCSH			831 #	7450	7451	7454
	EXPTST			840 #	5528	5544	5874
	FLAGS			841 #	2252	2253	2613	3439	3455	3522	3536	3592	3593	3596	3597
				3633	3654	3655	3725	3737	3793	3823	3827	3842	3848	4042	4043
				4044	4096	4110	4127	4137	4140	4170	4171	4195	4245	4257	4267
				4270	4377	4412	4443	4529	4678	4680	4745	4762	4784	5036	5388
				5400	5465	5753	6427	6428	7026	7528	7543	8839
	INHCRY18		836 #	3545	3715	3762	3791	3811	3816	5068	5143
	LDACBLK			842 #	2198	7187	7210
	LDINST			843 #	2305	3690	7022	7935
	LDPAGE			823 #	7445	8617
	LDPI			838 #	3643	7431	7506	7988
	LDPXCT			825 #	3695
	LOADIR			837 #	5956
	LOADXR			828 #	2376	3585	3609	3624	4738	4757	4805	5957	5969	6888	6925
				6927	6936	7732
	MEMCLR			833 #	2196	3644	7507	7909	7982	8324	8823	8829
	NICOND			824 #	2263	2264	2266	2267	2327	2333	2557	3078	3124	3152	3361
				3373	3464	3488	3489	3492	3493	3560	3561	3587	3629	3746	3822
				3829	4256	4520	4523	4731	5478	5484	5843	7420	7691	8270
	PREV			827 #	7893	7901
	PXCT OFF		835 #	2275	2278	2281	2293	2296	2299	2313
	SWEEP			834 #	7463	7464	7467
	WAIT			826 #	2445
	#			819 #	7917	7920	7983
(U) STATE			1033 #
	BLT			1035 #	5144
	COMP-DST		1042 #	6161
	CVTDB			1041 #	6208
	DST			1038 #	6123
	DSTF			1040 #	6061
	EDIT-DST		1044 #	6180	6390	6417	6636	6662	8856	8860
	EDIT-S+D		1045 #	6602
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 307
; 								Cross Reference Listing					

	EDIT-SRC		1043 #	6154	6541	6598	8854	8862	8864	8868
	MAP			1036 #	8269
	SIMPLE			1034 #
	SRC			1037 #	6010	6039	6109	8858
	SRC+DST			1039 #	6036	6115
(U) SWITCH%
	CRAM4K			8	417	434	443	460	462	464	8281	8284
	FULL			408	1330	1332	2207	2227	2232	2236	4204	4272	4275	4422	4532
				4535	4603	4668	4954	5105	5109	7217	7225
	INHCST			10	411	1270	1272	1274	8072	8074	8432	8435	8436	8439	8561
				8564	8565	8568	8639	8648	8649	8665
	KIPAGE			423	439	441	1294	1296	1298	3985	3995	4047	4058	7227	7234
				7240	7242	8349	8353	8358	8361	8729	8775	8884	8887	8891	8896
	KLPAGE			426	436	438	1300	1302	1304	3986	3990	3996	4010	7228	7233
				7236	7238	8348	8357	8363	8570	8633	8727	8883	8889	8906	8911
	NOCST			414	446	448	1276	1278	1280	8427	8500	8507	8510	8524	8527
				8528	8532	8558	8577	8634	8666
	NONSTD			450	1282	1284	1286
	SIM			405	2245	2250	2257
	UBABLT			9	420	435	442	1288	1290	1292	5219	5293	7865	7867	7869
(U) T				970 #
	2T			973 #	4447	4460	5327	5597	6171	6241	6305	6593	6730	6775	7370
				7727
	3T			974 #	2223	2448	2458	2613	3146	3320	3405	3439	3455	3545	3635
				3719	3754	3762	3787	3791	3808	3813	3818	3855	3871	4096	4110
				4213	4215	4234	4268	4405	4409	4459	4465	4466	4467	4484	4488
				4509	4517	4598	4663	4680	4738	4753	4824	4842	4938	4982	4989
				5069	5085	5089	5155	5157	5176	5200	5287	5321	5355	5396	5427
				5428	5431	5463	5466	5520	5522	5524	5526	5585	5586	5589	5591
				5690	5691	5692	5736	5740	5742	5744	5752	5835	5841	6001	6019
				6021	6069	6073	6136	6243	6257	6271	6303	6306	6391	6394	6426
				6427	6455	6461	6464	6473	6498	6512	6539	6559	6560	6682	6689
				6733	6792	6882	6889	6910	6924	6928	6931	6933	6969	7024	7154
				7161	7174	7221	7230	7487	7512	7516	7524	7525	7526	7561	7565
				7567	7734	8375	8383	8609	8626	8749	8760	8844	8874
	4T			975 #	3051	3522	3536	4122	4127	4134	4137	4139	5029	5034	6015
				6045	6222	6227	6252	6293	6466	6514	6654	6777	6978	7987	8295
				8368	8371	8455	8458	8737	8747
	5T			976 #	7288	7292	7296	7300	7304	7756	7773
(D) TEST			1385 #	2584	2584	2585	2585	2589	2589	2590	2590	2594	2594	2595
				2595	2599	2599	2600	2600	2619	2637	2637	2638	2638	2642	2642
				2643	2643	2647	2647	2648	2648	2652	2652	2653	2653	2657	2657
				2658	2658	2662	2662	2663	2663	2667	2667	2668	2668	2672	2672
				2673	2673	2679	2679	2680	2680	2684	2684	2685	2685	2689	2689
				2690	2690	2694	2694	2695	2695	2699	2699	2700	2700	2704	2704
				2705	2705	2709	2709	2710	2710	2714	2714	2715	2715	2811	2834
				2834	2835	2835	2844	2844	2845	2845	2854	2854	2855	2855	2864
				2864	2865	2865	2869	2869	2870	2870	2879	2879	2880	2880	2886
				2886	2887	2887	2896	2896	2897	2897	2906	2906	2907	2907	2916
				2916	2917	2917	2926	2926	2927	2927	2936	2936	2937	2937	2947
				2947	2948	2948	2957	2957	2958	2958	2967	2967	2968	2968	2977
				2977	2978	2978	3428	3429	3430	3431	3432	3433	3434	3435	3444
				3445	3446	3447	3448	3449	3450	3451	4090	4090	4091	4091	4104
				4104	4105	4105	4152	4152	4153	4153	4177	4177	4178	4178	4344
				4344	4345	4345	4349	4349	4350	4350	4721	4723	5299	5299	5300
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 308
; 								Cross Reference Listing					

				5300	5303	5303	5304	5304	5307	5307	5308	5308	5311	5311	5312
				5312	5344	5344	5345	5345	5349	5349	5350	5350	5373	5373	5374
				5374	5378	5378	5379	5379	7271
(U) TRAP1			1126 #	4170	4171	4195	4257	4377	4412	4443	4529	5036	5388	5400
				5465	5753
(U) TRAP2			1125 #	3737	3793	3823	3827
(U) VECTOR CYCLE		1197 #	7556
(D) VMA				1387 #	2583	2588	2593	2598	2636	2641	2646	2651	2656	2661	2666
				2671	2678	2683	2688	2693	2698	2703	2708	2713	2832	2833	2843
				2853	2863	2868	2885	2895	2905	2915	2924	2925	2935	2946	2956
				2966	2975	2976	2987	2988	2989	2991	2992	2993	3511	3525	3551
				3801	4089	4103	4151	4176	4343	4348
(U) WAIT			1186 #	2263	2263	2264	2264	2266	2266	2267	2267	2286	2286	2303
				2326	2326	2332	2332	2337	2343	2356	2366	2370	2374	2387	2396
				2399	2400	2428	2439	2440	2440	2451	2454	2458	2465	2465	2529
				2561	2567	2572	2575	2624	2624	2625	2820	2820	2822	2826	2826
				3055	3055	3361	3361	3373	3373	3440	3440	3441	3488	3488	3489
				3489	3492	3492	3493	3493	3560	3560	3561	3561	3562	3567	3571
				3574	3583	3587	3587	3601	3604	3607	3622	3629	3629	3648	3651
				3652	3665	3665	3668	3668	3671	3676	3676	3712	3717	3717	3729
				3735	3744	3744	3754	3757	3767	3767	3772	3772	3774	3780	3788
				3794	3850	3850	3851	3863	3863	3881	3882	3993	4003	4004	4006
				4012	4017	4017	4038	4039	4051	4055	4064	4064	4074	4074	4078
				4082	4256	4256	4731	4731	4740	4740	4768	4768	4774	4774	4775
				4788	4792	4796	4800	4802	4808	4929	4929	4930	5133	5161	5161
				5169	5169	5171	5185	5185	5190	5190	5194	5197	5208	5243	5284
				5284	5286	5291	5950	5966	5967	5969	5991	6138	6388	6389	6415
				6488	6493	6549	6581	6581	6583	6627	6627	6629	6632	6660	6669
				6785	6931	6932	6933	6934	6936	6950	7006	7009	7014	7017	7021
				7152	7153	7256	7256	7288	7288	7289	7292	7292	7293	7296	7296
				7297	7300	7300	7301	7304	7304	7305	7344	7345	7348	7373	7373
				7376	7377	7377	7378	7384	7385	7420	7420	7438	7438	7439	7511
				7522	7523	7538	7538	7559	7564	7565	7573	7653	7655	7688	7689
				7691	7691	7714	7735	7736	7781	7784	7786	7794	7796	7798	7892
				7894	7900	7900	7912	7914	7915	7915	7927	7927	7933	7998	7999
				8000	8001	8001	8002	8003	8006	8007	8008	8008	8009	8010	8011
				8011	8012	8013	8014	8014	8015	8016	8017	8017	8018	8019	8020
				8020	8021	8022	8024	8373	8381	8386	8388	8466	8470	8627	8662
				8707	8710	8742	8756	8762	8878	8879	8893	8908	8910	8914	8917
				8917
(U) WORK			1049 #
	AC0			1090 #
	AC1			1091 #
	AC2			1092 #
	AC3			1093 #
	ADJBPW			1068 #	5052	5073
	ADJP			1063 #	4987	5014
	ADJPTR			1065 #	4728	5005	5067
	ADJQ1			1066 #	5010	5028
	ADJR2			1067 #	5020	5087
	ADJS			1064 #	5000	5015	5078
	APR			1070 #	2203	7093	7115	7127	7219	7224	8267
	BADW0			1050 #	8318
	BADW1			1051 #	8319
	BDH			1080 #	6335	6410	6419	6441
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 309
; 								Cross Reference Listing					

	BDL			1081 #	6333	6376	6416	6420
	CBR			1060 #	7278	7294	8437	8566	8650	8651
	CMS			1077 #	6158	6170	6171	6181
	CSTM			1061 #	7282	7302	8657
	DDIV SGN		1094 #
	DECHI			1099 #	2212	2214	6464
	DECLO			1098 #	2211	2213	6455
	DIV			1053 #
	DVSOR H			1095 #
	DVSOR L			1096 #
	E0			1072 #	5960	6386	6658	6668
	E1			1073 #	5973	5976	6412	6591	6592	6767	6770	6775	6783
	FILL			1076 #	6142	6165	6178	6653	6730	6736	6850	6952
	FSIG			1078 #	6615	6617
	HSBADR			1069 #	2195	7284	7306	7981	7986
	MSK			1075 #	6023	6194	6776
	MUL			1052 #
	PERIOD			1086 #	7334	7386	7391
	PTA.E			1102 #	7472	8367	8454	8460
	PTA.U			1103 #	7471	8370	8457	8462
	PUR			1062 #	7280	7298	8430	8525
	SBR			1059 #	7276	7290	8397	8399	8476
	SLEN			1074 #	6006	6030	6034	6051	6063	6079	6083	6111	6118	6212	6216
				6219	6223	6391	6392	6394	6397	6763	6857	6861	6863	6977	6991
				6995
	SV.ARX			1056 #	6095	6100	7907	7979	7990	8005	8028	8291	8622	8850
	SV.AR			1055 #	6068	6098	8004	8025	8287	8630
	SV.AR1			1105 #	8483	8537
	SV.BRX			1058 #	5214	6096	6101	6968	6983	6992	8288	8624
	SV.BR			1057 #	6094	6099	8298	8308	8310	8312	8314	8623	8808
	SV.VMA			1054 #	7754	7760	7762	7994	8023	8026	8266	8290	8582	8825	8834
	TIME0			1084 #	2205	7323	7356	7366
	TIME1			1085 #	2206	7314	7321	7353	7367	7370	8535	8819
	TRAPPC			1104 #	7003	8838
	TTG			1087 #	7328	7332	7387
	YSAVE			1101 #	3698	7720	7723	7728	7740	7742
(D) WRITE			1388 #
(U) WRITE CYCLE			1157 #	2604	2610	2624	2724	2726	2759	2765	2773	2775	2794	2796
				2820	2826	2839	2849	2859	2891	2901	2921	2931	2942	2952	2982
				3440	3665	3668	3676	3717	3767	3772	3850	3863	3993	4003	4017
				4064	4074	4096	4110	4162	4168	4191	4193	4768	4774	4929	5161
				5169	5185	5190	5284	5482	5486	5532	5554	6581	6627	7256	7373
				7377	7438	7538	7686	7697	7703	7900	7912	7915	7998	8001	8008
				8011	8014	8017	8020	8521	8542	8601	8606	8662	8796	8878	8901
				8917
(U) WRITE TEST			1156 #	2604	2610	2624	2724	2726	2759	2765	2773	2775	2794	2796
				2820	2826	2839	2849	2859	2891	2901	2921	2931	2942	2952	2982
				3440	3665	3668	3676	3717	3767	3772	3850	3863	3993	4003	4017
				4064	4074	4096	4110	4162	4168	4191	4193	4768	4774	4929	5161
				5169	5185	5190	5284	5482	5486	5532	5554	6581	6627	7256	7288
				7292	7296	7300	7304	7373	7377	7438	7508	7522	7538	7555	7564
				7647	7650	7686	7697	7703	7900	7912	7915	7929	7998	8001	8008
				8011	8014	8017	8020	8328	8373	8381	8521	8601	8607	8878	8901
				8914	8917
(U) WRU CYCLE			1193 #	7509
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 310
; 								Cross Reference Listing					

(U) #				1004 #	2184	2186	2188	2190	2193	2223	2237	2273	2277	2280	2292
				2295	2298	2455	2457	2470	2492	2493	2780	2782	2787	2789	2806
				3077	3148	3150	3564	3573	3576	3578	3579	3580	3613	3618	3621
				3627	3641	3642	3662	3675	3761	3790	3853	3870	3957	3959	3961
				3963	3965	3967	3969	3971	3978	3981	4021	4026	4028	4031	4033
				4061	4069	4076	4143	4144	4396	4433	4434	4444	4452	4497	4550
				4576	4583	4674	4839	4983	4985	4990	5008	5012	5018	5022	5051
				5056	5090	5094	5101	5154	5250	5255	5264	5270	5275	5328	5329
				5332	5333	5357	5358	5362	5390	5391	5427	5431	5451	5452	5589
				5591	5671	5691	5692	5711	5714	5742	5744	5918	5920	5922	5924
				5926	5928	5930	5932	5934	5951	5954	5978	5994	5998	6133	6135
				6193	6198	6205	6210	6217	6221	6237	6279	6295	6296	6302	6308
				6328	6341	6343	6350	6355	6362	6365	6421	6435	6437	6444	6469
				6475	6491	6503	6506	6514	6526	6529	6546	6561	6619	6630	6639
				6641	6657	6676	6697	6702	6711	6714	6790	6812	6816	6820	6824
				6828	6832	6842	6848	6946	6957	7024	7029	7038	7039	7040	7044
				7045	7046	7047	7052	7053	7054	7057	7058	7059	7060	7061	7062
				7063	7064	7066	7069	7080	7095	7096	7099	7100	7102	7105	7107
				7109	7121	7131	7134	7138	7159	7166	7170	7174	7181	7200	7220
				7221	7222	7230	7231	7232	7248	7254	7260	7265	7285	7308	7317
				7336	7351	7403	7404	7447	7449	7460	7462	7489	7490	7491	7492
				7493	7494	7495	7496	7497	7498	7499	7500	7501	7502	7505	7516
				7525	7526	7541	7561	7568	7658	7666	7672	7685	7717	7719	7733
				7776	7862	7871	7873	7875	7877	7879	7881	7917	7920	7931	7983
				8261	8265	8268	8304	8306	8320	8330	8333	8339	8347	8351	8376
				8384	8395	8402	8419	8426	8474	8486	8489	8497	8504	8515	8518
				8544	8548	8551	8576	8589	8593	8597	8599	8612	8613	8615	8620
				8655	8676	8682	8687	8693	8736	8746	8750	8760	8765	8781	8784
				8787	8790	8799	8804	8812	8874	8885
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 311
; 								Location / Line Number Index
; Dcode Loc'n	0	1	2	3	4	5	6	7						

D 0000		3943	5887	5888	5889	5890	5891	5892	5893
D 0010		5895	5896	5897	5898	5900	5901	5902	5903
D 0020		5905	5906	5907	5908	5909	5910	5911	5912
D 0030		3890	3891	3892	3893	3894	3895	3896	3897
D 0040		3901	3902	3903	3904	3905	3906	3907	3908
D 0050		3909	3910	3911	3912	3913	3914	3915	3916
D 0060		3917	3918	3919	3920	3921	3922	3923	3924
D 0070		3925	3926	3927	3928	3929	3930	3931	3932

D 0100		3936	3937	3938	3939	3944	3801	3945	3946
D 0110		5572	5573	5661	5722	4117	4118	4201	4419
D 0120		2801	2802	5457	5946	2810	2811	5458	5422
D 0130		3947	3948	5423	4720	4721	4722	4723	4724
D 0140		5298	3949	5299	5300	5301	5302	5303	5304
D 0150		5306	3950	5307	5308	5309	5310	5311	5312
D 0160		5343	3951	5344	5345	5347	5348	5349	5350
D 0170		5372	3952	5373	5374	5376	5377	5378	5379

D 0200		2582	2583	2584	2585	2587	2588	2589	2590
D 0210		2592	2593	2594	2595	2597	2598	2599	2600
D 0220		4150	4151	4152	4153	4175	4176	4177	4178
D 0230		4342	4343	4344	4345	4347	4348	4349	4350
D 0240		2987	2988	2989	2990	2991	2992	2993	3953
D 0250		2619	5147	3539	3540	3551	3553	3682	8256
D 0260		3704	3705	3706	3707	3834	3835	3836	3837
D 0270		4088	4089	4090	4091	4102	4103	4104	4105

D 0300		3385	3386	3387	3388	3389	3390	3391	3392
D 0310		3394	3395	3396	3397	3398	3399	3400	3401
D 0320		3497	3498	3499	3500	3501	3502	3503	3504
D 0330		3411	3412	3413	3414	3415	3416	3417	3418
D 0340		3511	3512	3513	3514	3515	3516	3517	3518
D 0350		3428	3429	3430	3431	3432	3433	3434	3435
D 0360		3525	3526	3527	3528	3529	3530	3531	3532
D 0370		3444	3445	3446	3447	3448	3449	3450	3451

D 0400		2832	2833	2834	2835	2842	2843	2844	2845
D 0410		2852	2853	2854	2855	2862	2863	2864	2865
D 0420		2867	2868	2869	2870	2877	2878	2879	2880
D 0430		2884	2885	2886	2887	2894	2895	2896	2897
D 0440		2904	2905	2906	2907	2914	2915	2916	2917
D 0450		2924	2925	2926	2927	2934	2935	2936	2937
D 0460		2945	2946	2947	2948	2955	2956	2957	2958
D 0470		2965	2966	2967	2968	2975	2976	2977	2978

D 0500		2635	2636	2637	2638	2640	2641	2642	2643
D 0510		2645	2646	2647	2648	2650	2651	2652	2653
D 0520		2655	2656	2657	2658	2660	2661	2662	2663
D 0530		2665	2666	2667	2668	2670	2671	2672	2673
D 0540		2677	2678	2679	2680	2682	2683	2684	2685
D 0550		2687	2688	2689	2690	2692	2693	2694	2695
D 0560		2697	2698	2699	2700	2702	2703	2704	2705
D 0570		2707	2708	2709	2710	2712	2713	2714	2715

; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 312
; 								Location / Line Number Index
; Dcode Loc'n	0	1	2	3	4	5	6	7						

D 0600		3210	3211	3212	3213	3214	3215	3216	3217
D 0610		3219	3220	3221	3222	3223	3224	3225	3226
D 0620		3228	3229	3230	3231	3232	3233	3234	3235
D 0630		3237	3238	3239	3240	3241	3242	3243	3244
D 0640		3246	3247	3248	3249	3250	3251	3252	3253
D 0650		3255	3256	3257	3258	3259	3260	3261	3262
D 0660		3263	3264	3265	3266	3267	3268	3269	3270
D 0670		3272	3273	3274	3275	3276	3277	3278	3279

D 0700		7034	7035	7271	7805	7886	7887	7806	7807
D 0710		7593	7594	7604	7605	7618	7619	7809	7810
D 0720		7595	7596	7606	7607	7620	7621	7812	7813
D 0730		7815	7816	7817	7818	7819	7820	7821	7822
D 0740		7824	7825	7826	7827	7828	7829	7830	7831
D 0750		7833	7834	7835	7836	7837	7838	7839	7840
D 0760		7842	7843	7844	7845	7846	7847	7848	7849
D 0770		7851	7852	7853	7854	7855	7856	7857	7858
; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 313
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 0000		2184:	7980:	2185 	2193:	7921:	7923:	5247=	5250=
U 0010		2217=	7981:	2218=	2186 	3320=	3323=	3326=	3329=
U 0020		4009=	4159=	4015=	4018=	7982=	4160=	7983=	4021=
U 0030		3594=	4187=	3598=	4528=	3602=	4188=	3606=	4529=
U 0040		2389:	2393:	2397:	2405:	2415:	2418:	2425:	2429:
U 0050		2442:	2448:	2469:	2187 	4450=	4452=	4486=	4487=
U 0060		3666=	2188 	5080=	5481=	3669=	3671=	5087=	7649=
U 0070		4790=	2191 	4794=	5482=	4798=	4454=	4801=	7650=

U 0100		2195 	2276=	2279=	2282=	7908=	2283=	2196 	2287=
U 0110		2198 	2294=	2297=	2300=	7910=	2301=	7912=	2306=
U 0120		4214=	4216=	4307=	4311=	4217=	2201 	4315=	4319=
U 0130		3866=	2203 	5727=	5729=	3869=	3873=	7075:	7090:
U 0140		2226=	2229=	4325=	4329=	5406=	5407=	4333=	4337=
U 0150		3586=	2237=	3587=	5637=	5409=	5411=	5413=	5414=
U 0160		4370=	4373=	2205 	5361=	4376=	4377=	4379=	5363=
U 0170		5963=	4223=	5965=	5638=	5966=	4224=	5967=	5415=

U 0200		5820=	2327=	5822=	2333=	5824=	2339=	5826=	2344=
U 0210		5828=	2352=	2206 	2356=	2208 	2366=	5829=	2370=
U 0220		3744=	3746=	3748=	2209 	2222=	2223=	2210 	7685=
U 0230		6931=	6883=	6932=	6884=	6933=	2211 	6934=	7686=
U 0240		4729=	4730=	2212 	5708=	2213 	4731=	6572=	6573=
U 0250		3361=	3364=	3367=	3370=	3373=	3376=	3379=	3382=
U 0260		2266=	2267=	5561=	5709=	4758=	4761=	5562=	4762=
U 0270		3464=	3467=	3470=	3473=	3476=	3479=	3482=	3485=

U 0300		3621=	3625=	5566=	3627=	7417=	7418=	5567=	3628=
U 0310		4052=	2214 	4054=	4057=	4005=	7420=	4007=	3629=
U 0320		3641=	3642=	5870=	2215 	2219 	3643=	5872=	5546=
U 0330		4395=	4397=	6731=	4400=	2220 	3645=	6732=	5548=
U 0340		4826=	4829=	4830=	2253 	4831=	4832=	2255 	4833=
U 0350		4768=	4769=	4770=	4771=	4472=	4512=	4473=	4513=
U 0360		4922=	4923=	4924=	2314 	4925=	4926=	2376 	4927=
U 0370		4552=	2381 	2434=	2436=	4553=	4554=	4555=	4556=

U 0400		4074:	2399 	2451=	2454=	2470=	2471=	2402 	5564=
U 0410		4233=	4235=	2492=	2493=	4236=	2407 	2419 	5565=
U 0420		5519=	5520=	5521=	5522=	5523=	5524=	5525=	5526=
U 0430		5527=	2421 	2456 	5620=	2574=	2577=	5528=	5621=
U 0440		5539=	6359=	5540=	6361=	5541=	2457 	5542=	6362=
U 0450		5543=	2460 	2461 	5654=	3026=	3030=	5544=	5655=
U 0460		6216=	6218=	5874=	5878=	6220=	6222=	5881=	2463 
U 0470		7540=	2466 	5644=	5646=	7542=	7544=	5647=	5648=

U 0500		6031=	6033=	3056=	3057=	6035=	6037=	2627 	6039=
U 0510		6417=	2757 	2763 	5767=	3075=	3076=	6418=	5768=
U 0520		5781=	5782=	5784=	5785=	5787=	5788=	5790=	5791=
U 0530		5793=	2822 	2827 	6856=	3106=	3107=	5794=	6858=
U 0540		6112=	6114=	6116=	4243=	3110=	3111=	6119=	4245=
U 0550		4848=	4482=	4849=	4483=	3123=	3124=	5974=	5975=
U 0560		6250=	6253=	6409=	4266=	2942 	6254=	6410=	4268=
U 0570		5051=	5053=	3008 	5057=	6010=	6011=	6013=	6016=

; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 314
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 0600		6256=	6259=	3130=	3132=	3021 	6260=	6616=	6617=
U 0610		5252=	5254=	3024 	5255=	3136=	3138=	6208=	6211=
U 0620		6267=	6268=	6272=	5677=	3143=	3145=	6273=	5681=
U 0630		5272=	5274=	3040 	5275=	3149=	3151=	6415=	6416=
U 0640		6396=	6398=	3178=	3179=	3182=	3184=	3042 	6399=
U 0650		5832=	3043 	5834=	5836=	6500=	6501=	6502=	6503=
U 0660		4744=	6515=	4746=	6518=	5009=	6520=	5010=	6522=
U 0670		5019=	6524=	5020=	6527=	5240=	6530=	5241=	6532=

U 0700		6593=	3045 	6597=	6599=	6600=	6603=	3048 	6605=
U 0710		6540=	6542=	6544=	6547=	6548=	6550=	6769=	6770=
U 0720		5323=	6807=	5324=	6809=	5465=	6813=	5466=	6817=
U 0730		5467=	6821=	5468=	6825=	5755=	6829=	5756=	6833=
U 0740		6638=	6640=	3424=	3425=	3488=	3489=	6642=	3059 
U 0750		6060=	6062=	3077 	6064=	6846=	6849=	6851=	6853=
U 0760		6663=	6664=	3492=	3493=	3613=	3614=	6665=	3078 
U 0770		7488=	7489=	7490=	7491=	7492=	7493=	7494=	7495=

U 1000		8393=	8396=	8398=	8400=	3618=	3619=	3104 	8402=
U 1010		8410=	8411=	5682=	7630=	3112 	8412=	5683=	7632=
U 1020		6078=	6080=	6082=	6083=	3662=	3663=	3113 	7658=
U 1030		6122=	6123=	5694=	6124=	3675=	3676=	5695=	7659=
U 1040		8456=	8459=	8461=	8463=	3692=	3696=	3127 	8467=
U 1050		6155=	6157=	6158=	3147 	5759=	7727=	5760=	7729=
U 1060		8296=	8298=	5701=	8302=	3152 	8304=	5706=	8306=
U 1070		8308=	8310=	8312=	8314=	6164=	6166=	6167=	3176 

U 1100		8849=	8851=	8853=	8855=	8857=	8859=	8861=	8863=
U 1110		8865=	8866=	8867=	8869=	6231=	6233=	6234=	3334 
U 1120		6765=	6766=	6767=	3335 	7349=	7352=	3440 	7354=
U 1130		7371=	7373=	7374=	3441 	7755=	7758=	7761=	7763=
U 1140		8472=	8475=	8477=	8482=	8502=	8505=	3589 	8515=
U 1150		8652=	8653=	3732=	3736=	8655=	3610 	3768=	3772=
U 1160		8821=	8822=	8823=	3615 	3793=	3796=	3814=	3819=
U 1170		3822=	3824=	3828=	3829=	3984=	3988=	3994=	3997=

U 1200		4000=	4003=	4029=	4031=	4034=	4038=	4128=	4129=
U 1210		4138=	4140=	4143=	4144=	4161=	4162=	4167=	4168=
U 1220		4170=	4171=	4191=	4192=	4193=	4195=	4248=	4249=
U 1230		4256=	4257=	4358=	4360=	4385=	4388=	4406=	4410=
U 1240		4412=	4414=	4428=	4430=	4432=	4433=	4442=	4443=
U 1250		4458=	4459=	4461=	4462=	4465=	4466=	4467=	4468=
U 1260		4476=	4477=	4492=	4493=	4502=	4503=	4520=	4521=
U 1270		4571=	4572=	4573=	4574=	4580=	4581=	4590=	4591=

U 1300		4594=	4595=	4619=	4622=	4636=	4640=	4652=	4653=
U 1310		4657=	4658=	4662=	4663=	4678=	4680=	4684=	4685=
U 1320		4980=	4983=	4999=	5001=	5004=	5005=	5035=	5036=
U 1330		5070=	5072=	5099=	5102=	5135=	5137=	5163=	5170=
U 1340		5174=	5177=	5179=	5181=	5186=	5191=	5203=	5204=
U 1350		5288=	5289=	5328=	5329=	5332=	5333=	5337=	5338=
U 1360		5357=	5358=	5387=	5388=	5390=	5391=	5396=	5397=
U 1370		5399=	5400=	5403=	5404=	5428=	5429=	5432=	5433=

; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 315
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 1400		2263:	2264:	2604:	2607:	2610:	2614:	2624:	2724:
U 1410		2726:	2751:	2753:	2756:	2759:	2762:	2765:	2771:
U 1420		2773:	2775:	2778:	2785:	2780:	2782:	2787:	2789:
U 1430		2792:	3439:	2794:	2796:	2806:		2807:	3455:
U 1440		3508:	2839:	2849:	2859:	2874:	2891:	2901:	2911:
U 1450		2921:	2931:	2941:	2952:	2962:	2972:	2982:	4123:
U 1460		7611:	7615:	3052:	7612:	3102:	3103:	3121:	5950:
U 1470		3174:	3175:	3304:	3306:	3309:	3312:	3405:	3423:

U 1500						2520:	2525:	2531:	
U 1510						2552:	2557:	2563:	2569:
U 1520		3560:	3561:	3563:	3564:	3565:	3568:	3569:	3570:
U 1530		3572:	3573:	3575:	3576:	3577:	3578:	3579:	3580:
U 1540		3636:	3686:	3536:	3713:	3726:	3755:	3788:	3546:
U 1550		3841:	3806:	3848:	8262:	3863:	3878:	3979:	4069:
U 1560		4096:	4110:				2816:	4206:	2821:
U 1570		5356:	4183:			5384:		5318:	5321:

U 1600		4354:	4363:						
U 1610		4727:	3522:	3002:	3005:	7600:	4135:	5427:	7601:
U 1620		4735:	5448:	3016:	3018:	4739:	4740:	5464:	4424:
U 1630		4749:	5666:	3037:	3039:	4751:	5582:	5725:	5585:
U 1640		5151:	4156:	5153:	5156:	7626:			7628:
U 1650		7862:	7868:	7871:	7873:	7875:	7877:	7879:	7881:
U 1660		3969:	3957:	3959:	3961:	3963:	3971:	3965:	3967:
U 1670									

U 1700		7080:	7038:	7039:	7040:	7093:	7127:	7041:	7042:
U 1710		7044:	7045:	7046:	7047:	7400:	7397:	7048:	7049:
U 1720		7052:	7254:	7445:	7152:	7214:	7245:	7053:	7054:
U 1730		7057:	7058:	7059:	7060:	7061:	7062:	7063:	7064:
U 1740		5918:	5920:	5922:	5924:	5926:		5928:	5930:
U 1750		5932:	5934:			7893:	7901:		
U 1760		7276:	7278:	7280:	7282:	7360:	7392:	7284:	7285:
U 1770		7288:	7292:	7296:	7300:	7344:	7384:	7304:	7308:

U 2000		5435=	5436=	5443=	5444=	5451=	5452=	5473=	5474=
U 2010		5477=	5478=	5484=	5485=	5486=	5488=	5531=	5532=
U 2020		5535=	5537=	5550=	5551=	5552=	5553=	5590=	5592=
U 2030		5595=	5597=	5601=	5602=	5609=	5610=	5651=	5652=
U 2040		5669=	5670=	5691=	5692=	5712=	5713=	5715=	5717=
U 2050		5732=	5733=	5742=	5743=	5751=	5752=	5753=	5754=
U 2060		5770=	5771=	5803=	5804=	5808=	5809=	5813=	5815=
U 2070		5840=	5841=	5848=	5849=	5858=	5859=	5977=	5979=

U 2100		5952=	5995=	5999=	6002=	5954=	5996=	6004=	6005=
U 2110		6021=	6097=	6022=	6098=	6047=	6049=	6053=	6054=
U 2120		6068=	6070=	6073=	6075=	6086=	6088=	6137=	6138=
U 2130		6133=	6135=	6141=	6143=	6134=	6136=	6151=	6152=
U 2140		6178=	6179=	6185=	6188=	6200=	6334=	6201=	6336=
U 2150		6203=	6206=	6224=	6228=	6238=	6239=	6242=	6244=
U 2160		6278=	6279=	6291=	6292=	6295=	6296=	6299=	6300=
U 2170		6305=	6307=	6308=	6310=	6318=	6319=	6329=	6330=

; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 316
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 2200		6339=	6341=	6347=	6348=	6343=	6460=	6345=	6462=
U 2210		6353=	6356=	6366=	6367=	6371=	6372=	6377=	6378=
U 2220		6380=	6384=	6422=	6423=	6427=	6428=	6434=	6435=
U 2230		6436=	6437=	6438=	6439=	6456=	6457=	6463=	6464=
U 2240		6470=	6471=	6476=	6478=	6497=	6498=	6505=	6506=
U 2250		6492=	8418=	6511=	6512=	6493=	8419=	6538=	6539=
U 2260		6563=	6566=	6580=	6581=	6590=	6913=	6591=	6914=
U 2270		6610=	6611=	6631=	6633=	6655=	6657=	6659=	6660=

U 2300		6677=	6679=	6700=	6704=	6706=	6708=	6735=	6736=
U 2310		6789=	6790=	6794=	6796=	6840=	6842=	6862=	6864=
U 2320		6879=	6880=	6889=	6893=	6908=	6911=	6965=	6966=
U 2330		6925=	7325=	6926=	7327=	6973=	6974=	6981=	6982=
U 2340		6984=	6985=	7011=	7019=	7028=	7029=	7101=	7102=
U 2350		7103=	7104=	7106=	7107=	7108=	7109=	7111=	7112=
U 2360		7162=	7167=	7182=	7188=	7197=	7201=	7216=	7219=
U 2370		7222=	7223=	7231=	7232=	7247=	7248=	7255=	7257=

U 2400		7264=	7265=	7322=	7323=	7333=	7334=	7365=	7366=
U 2410		7401=	7402=	7403=	7404=	7407=	7408=	7409=	7410=
U 2420		7411=	7412=	7413=	7414=	7415=	7416=	7448=	7450=
U 2430		7456=	7457=	7461=	7463=	7469=	7471=	7510=	7513=
U 2440		7514=	7515=	7526=	7527=	7537=	7538=	7554=	7556=
U 2450		7558=	7560=	7562=	7564=	7568=	7569=	7583=	7584=
U 2460		7587=	7588=	7645=	7646=	7654=	7657=	7664=	7666=
U 2470		7670=	7672=	7683=	7684=	7690=	7691=	7696=	7698=

U 2500		7702=	7704=	7715=	7716=	7719=	7721=	7724=	7725=
U 2510		7734=	7735=	7741=	7742=	7769=	7770=	7775=	7776=
U 2520		7916=	7917=	7928=	7929=	7932=	7936=	7989=	7991=
U 2530		7999=	8002=	8000=	8003=	8004=	8006=	8005=	8007=
U 2540		8009=	8012=	8010=	8013=	8015=	8018=	8016=	8019=
U 2550		8021=	8023=	8022=	8024=	8269=	8270=	8331=	8334=
U 2560		8345=	8347=	8356=	8360=	8369=	8371=	8374=	8377=
U 2570		8382=	8384=	8404=	8406=	8424=	8426=	8444=	8453=

U 2600		8429=	8438=	8430=	3648 	3651 	8440=	8484=	8487=
U 2610		8491=	8492=	8495=	8567=	8519=	8521=	8497=	8576=
U 2620		8522=	8526=	8546=	8548=	8536=	3653 	8538=	3655 
U 2630		8553=	8557=	8581=	8583=	8587=	8590=	8597=	8599=
U 2640		8615=	8617=	8620=	8621=	8658=	8659=	8663=	8664=
U 2650		8683=	8684=	8688=	8689=	8694=	8695=	8698=	8699=
U 2660		8712=	8713=	8721=	8722=	8724=	8725=	8738=	8743=
U 2670		8748=	8751=	8758=	8761=	8771=	8773=	8777=	8780=

U 2700		8783=	8784=	8788=	8790=	8794=	8796=	8800=	8801=
U 2710		8810=	8813=	8833=	8835=	8837=	8838=	8841=	8842=
U 2720		8844=	3657 	8875=	8876=	8881=	8885=	8888=	8892=
U 2730		8901=	8902=	8909=	8910=	3677 	3699 	3721 	3739 
U 2740		3758 	3763 	3777 	3782 	3792 	3809 	3844 	3850 
U 2750		3852 	3856 	3864 	3879 	3881 	3884 	3981 	4023 
U 2760		4024 	4026 	4040 	4045 	4062 	4065 	4077 	4079 
U 2770		4083 	4131 	4142 	4157 	4165 	4184 	4185 	4189 

; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 317
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 3000		4207 	4209 	4226 	4227 	4238 	4247 	4250 	4251 
U 3010		4252 	4253 	4255 	4261 	4262 	4263 	4270 	4286 
U 3020		4289 	4301 	4356 	4364 	4365 	4367 	4390 	4392 
U 3030		4426 	4435 	4436 	4439 	4444 	4445 	4447 	4471 
U 3040		4474 	4475 	4478 	4484 	4490 	4491 	4495 	4497 
U 3050		4498 	4500 	4505 	4506 	4508 	4509 	4515 	4518 
U 3060		4523 	4531 	4570 	4576 	4577 	4583 	4584 	4585 
U 3070		4586 	4587 	4592 	4596 	4597 	4600 	4630 	4648 

U 3100		4650 	4655 	4660 	4665 	4666 	4667 	4674 	4676 
U 3110		4683 	4754 	4755 	4774 	4775 	4783 	4785 	4806 
U 3120		4810 	4843 	4852 	4855 	4856 	4857 	4860 	4861 
U 3130		4862 	4929 	4930 	4933 	4936 	4937 	4938 	4939 
U 3140		4941 	4944 	4947 	4948 	4949 	4951 	4976 	4986 
U 3150		4987 	4990 	4992 	4994 	5013 	5014 	5015 	5016 
U 3160		5022 	5030 	5060 	5074 	5077 	5078 	5090 	5092 
U 3170		5095 	5104 	5131 	5138 	5139 	5141 	5143 	5144 

U 3200		5158 	5173 	5196 	5198 	5201 	5209 	5213 	5215 
U 3210		5217 	5245 	5258 	5260 	5261 	5262 	5264 	5266 
U 3220		5267 	5268 	5270 	5279 	5281 	5282 	5285 	5286 
U 3230		5287 	5292 	5325 	5326 	5327 	5335 	5359 	5364 
U 3240		5367 	5392 	5393 	5394 	5417 	5440 	5449 	5450 
U 3250		5470 	5554 	5583 	5588 	5603 	5607 	5608 	5611 
U 3260		5616 	5618 	5623 	5625 	5626 	5639 	5641 	5656 
U 3270		5671 	5672 	5676 	5684 	5690 	5696 	5710 	5711 

U 3300		5714 	5734 	5738 	5741 	5744 	5745 	5748 	5763 
U 3310		5797 	5800 	5810 	5838 	5843 	5845 	5851 	5956 
U 3320		5958 	5960 	5961 	5969 	6007 	6018 	6019 	6024 
U 3330		6045 	6051 	6052 	6055 	6067 	6084 	6091 	6094 
U 3340		6095 	6096 	6099 	6100 	6102 	6108 	6109 	6126 
U 3350		6127 	6153 	6160 	6161 	6162 	6170 	6171 	6172 
U 3360		6173 	6174 	6175 	6180 	6181 	6194 	6196 	6198 
U 3370		6212 	6237 	6240 	6263 	6281 	6284 	6286 	6294 

U 3400		6297 	6302 	6304 	6311 	6320 	6331 	6332 	6351 
U 3410		6373 	6375 	6385 	6386 	6388 	6389 	6390 	6391 
U 3420		6392 	6395 	6401 	6406 	6413 	6419 	6420 	6421 
U 3430		6424 	6425 	6426 	6441 	6445 	6465 	6467 	6472 
U 3440		6473 	6494 	6495 	6509 	6558 	6559 	6561 	6583 
U 3450		6584 	6620 	6626 	6627 	6628 	6629 	6647 	6668 
U 3460		6670 	6680 	6683 	6688 	6689 	6690 	6691 	6692 
U 3470		6694 	6697 	6709 	6712 	6714 	6716 	6717 	6734 

U 3500		6775 	6778 	6783 	6785 	6860 	6882 	6885 	6887 
U 3510		6906 	6924 	6927 	6929 	6936 	6937 	6951 	6953 
U 3520		6958 	6968 	6969 	6977 	6979 	6987 	6989 	6991 
U 3530		6992 	6993 	6995 	6998 	7002 	7004 	7022 	7025 
U 3540		7066 	7067 	7069 	7095 	7096 	7097 	7099 	7100 
U 3550		7105 	7114 	7116 	7119 	7121 	7124 	6946:	6947:
U 3560		7129 	7132 	7135 	7136 	7138 	7140 	7155 	7171 
U 3570		7175 	7193 	7204 	7206 	7211 	7220 	7221 	7224 

; CRAM4K.MCR[1,2]	23:46 29-MAY-2015	MICRO 31(254)	KS10 MICROCODE V2A(130), 15-APR-2015	Page 318
; 								Location / Line Number Index
; Ucode Loc'n	0	1	2	3	4	5	6	7						

U 3600		7229 	7230 	7251 	7260 	7261 	7266 	7289 	7290 
U 3610		7293 	7294 	7297 	7298 	7301 	7302 	7305 	7306 
U 3620		7315 	7317 	7318 	7319 	7328 	7330 	7335 	7336 
U 3630		7339 	7346 	7357 	7361 	7362 	7364 	7368 	7376 
U 3640		7377 	7378 	7385 	7386 	7388 	7405 	7406 	7428 
U 3650		7429 	7430 	7432 	7438 	7439 	7446 	7451 	7464 
U 3660		7473 	7476 	7496 	7497 	7498 	7499 	7500 	7501 
U 3670		7502 	7505 	7506 	7507 	7517 	7519 	7522 	7524 

U 3700		7525 	7529 	7552 	7566 	7570 	7573 	7586 	7635 
U 3710		7688 	7717 	7732 	7733 	7737 	7744 	7751 	7766 
U 3720		7782 	7784 	7786 	7788 	7790 	7792 	7794 	7796 
U 3730		7798 	7800 	7896 	7903 	7914 	7987 	7993 	7995 
U 3740		6132:	6489:	6193:	6326:	5992:	7998 	8001 	8008 
U 3750		8011 	6490:	8014 	8017 	5993:	8020 	8025 	8026 
U 3760		8027 	8029 	8263 	8265 	8266 	8267 	8268 	8288 
U 3770		8289 	8290 	8292 	8318 	8319 	8320 	8324 	8282:

U 4000		8327 	8328 	8339 	8341 	8351 	8387 	8389 	8516 
U 4010		8542 	8591 	8594 	8595 	8601 	8603 	8608 	8610 
U 4020		8612 	8613 	8614 	8622 	8623 	8624 	8627 	8631 
U 4030		8650 	8676 	8678 	8680 	8709 	8723 	8734 	8763 
U 4040		8765 	8781 	8805 	8808 	8815 	8817 	8826 	8829 
U 4050		8839 	8878 	8895 	8899 	8915 	8917 		
U 4060 - 7767 Unused
U 7770									8287:

No errors detected
End of microcode assembly
323 pages of listing
Used 1.93 seconds, 120 pages of core
  Symbol table: 31P
  Text strings: 9P
  Loc'n assignment: 19P
  Cross reference: 53P
