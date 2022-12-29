
#
# Modelsim/Questasim waveforms for the various devices
#

WAVE_ARB := \
	"add wave -noupdate -divider {ARBITER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI}              {/testbench/uKS10/uARB/ubaREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO}              {/testbench/uKS10/uARB/ubaREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI}              {/testbench/uKS10/uARB/ubaACKI}" \
	"add wave -noupdate -divider {ARB to UBA1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI[1]}           {/testbench/uKS10/uARB/ubaREQI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKO[1]}           {/testbench/uKS10/uARB/ubaACKO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRI[1]}          {/testbench/uKS10/uARB/ubaADDRI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAI[1]}          {/testbench/uKS10/uARB/ubaDATAI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO[1]}           {/testbench/uKS10/uARB/ubaREQO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI[1]}           {/testbench/uKS10/uARB/ubaACKI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRO[1]}          {/testbench/uKS10/uARB/ubaADDRO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAO[1]}          {/testbench/uKS10/uARB/ubaDATAO[1]}" \
	"add wave -noupdate -divider {ARB to UBA3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI[3]}           {/testbench/uKS10/uARB/ubaREQI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKO[3]}           {/testbench/uKS10/uARB/ubaACKO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRI[3]}          {/testbench/uKS10/uARB/ubaADDRI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAI[3]}          {/testbench/uKS10/uARB/ubaDATAI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO[3]}           {/testbench/uKS10/uARB/ubaREQO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI[3]}           {/testbench/uKS10/uARB/ubaACKI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRO[3]}          {/testbench/uKS10/uARB/ubaADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAO[3]}          {/testbench/uKS10/uARB/ubaDATAO[3]}" \
	"add wave -noupdate -divider {ARB to UBA4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI[4]}           {/testbench/uKS10/uARB/ubaREQI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKO[4]}           {/testbench/uKS10/uARB/ubaACKO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRI[4]}          {/testbench/uKS10/uARB/ubaADDRI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAI[4]}          {/testbench/uKS10/uARB/ubaDATAI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO[4]}           {/testbench/uKS10/uARB/ubaREQO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI[4]}           {/testbench/uKS10/uARB/ubaACKI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRO[4]}          {/testbench/uKS10/uARB/ubaADDRO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAO[4]}          {/testbench/uKS10/uARB/ubaDATAO[4]}"

WAVE_BRKPT := \
	"add wave -noupdate -divider {Breakpoint}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uBRKPT/rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uBRKPT/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDR}              {/testbench/uKS10/uBRKPT/cpuADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBAR0}                {/testbench/uKS10/uBRKPT/brDATA.regBRAR[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBMR0}                {/testbench/uKS10/uBRKPT/brDATA.regBRMR[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBAR1}                {/testbench/uKS10/uBRKPT/brDATA.regBRAR[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBMR1}                {/testbench/uKS10/uBRKPT/brDATA.regBRMR[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBAR2}                {/testbench/uKS10/uBRKPT/brDATA.regBRAR[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBMR2}                {/testbench/uKS10/uBRKPT/brDATA.regBRMR[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBAR3}                {/testbench/uKS10/uBRKPT/brDATA.regBRAR[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBMR3}                {/testbench/uKS10/uBRKPT/brDATA.regBRMR[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {addrmatch}            {/testbench/uKS10/uBRKPT/addrmatch}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {d}                    {/testbench/uKS10/uBRKPT/d}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {brHALT}               {/testbench/uKS10/uBRKPT/brHALT}" \

WAVE_BUSES := \
	"add wave -noupdate -divider {BUSES}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uCPU/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DP}                   {/testbench/uKS10/uCPU/dp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBUS}                 {/testbench/uKS10/uCPU/dbus}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBM}                  {/testbench/uKS10/uCPU/dbm}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMFILE}              {/testbench/uKS10/uCPU/ramfile}" \

WAVE_CPU := \
	"add wave -noupdate -divider {CPU}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {cpuCLK}               {/testbench/uKS10/uCPU/clkT[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack}                {/testbench/uKS10/uCPU/uUSEQ/uSTACK/stack}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack wp}             {/testbench/uKS10/uCPU/uUSEQ/uSTACK/sp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack sp}             {/testbench/uKS10/uCPU/uUSEQ/uSTACK/wp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack addrOUT}        {/testbench/uKS10/uCPU/uUSEQ/uSTACK/addrOUT}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uCPU/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM J}               {/testbench/uKS10/uCPU/uUSEQ/uCROM/addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM ADDR}            {/testbench/uKS10/uCPU/uUSEQ/addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM CURR ADDR}       {/testbench/uKS10/uCPU/uUSEQ/uSTACK/currADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uCPU/pageFAIL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PC}                   {/testbench/uKS10/uDEBUG/PC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {IR}                   {/testbench/uKS10/uDEBUG/IR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 0: MAG}              {/testbench/uKS10/uCPU/uALU/aluRAM[0][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 1: PC}               {/testbench/uKS10/uCPU/uALU/aluRAM[1][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 2: HR}               {/testbench/uKS10/uCPU/uALU/aluRAM[2][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 3: AR}               {/testbench/uKS10/uCPU/uALU/aluRAM[3][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 4: ARX}              {/testbench/uKS10/uCPU/uALU/aluRAM[4][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 5: BR}               {/testbench/uKS10/uCPU/uALU/aluRAM[5][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 6: BRX}              {/testbench/uKS10/uCPU/uALU/aluRAM[6][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 7: ONE}              {/testbench/uKS10/uCPU/uALU/aluRAM[7][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 8: EBR}              {/testbench/uKS10/uCPU/uALU/aluRAM[8][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 9: UBR}              {/testbench/uKS10/uCPU/uALU/aluRAM[9][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {10: MASK}             {/testbench/uKS10/uCPU/uALU/aluRAM[10][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {11: FLG}              {/testbench/uKS10/uCPU/uALU/aluRAM[11][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {12: PI}               {/testbench/uKS10/uCPU/uALU/aluRAM[12][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {13: XWD1}             {/testbench/uKS10/uCPU/uALU/aluRAM[13][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {14: T0}               {/testbench/uKS10/uCPU/uALU/aluRAM[14][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {15: T1}               {/testbench/uKS10/uCPU/uALU/aluRAM[15][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC0}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC1}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC2}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC3}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC4}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC5}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC6}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[6]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC7}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[7]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC8}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[8]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC9}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[9]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC10}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[10]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC11}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[11]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC12}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC13}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[13]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC14}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[14]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC15}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[15]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vmaREG}               {/testbench/uKS10/uCPU/vmaREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regIR}                {/testbench/uKS10/uCPU/regIR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uCPU/pageFAIL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuRUN}               {/testbench/uKS10/uCPU/cpuRUN}"

WAVE_CPU_INTFC := \
	"add wave -noupdate -divider {CPU Backplane Bus Interface}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uCPU/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uCPU/uINTF/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuREQO}              {/testbench/uKS10/uCPU/cpuBUS.busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuACKI}              {/testbench/uKS10/uCPU/cpuBUS.busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO[0:35]}       {/testbench/uKS10/uCPU/cpuBUS.busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 3: READ}             {/testbench/uKS10/uCPU/cpuBUS.busADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 4: WRTEST}           {/testbench/uKS10/uCPU/cpuBUS.busADDRO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 5: WRITE}            {/testbench/uKS10/uCPU/cpuBUS.busADDRO[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {10: IO}               {/testbench/uKS10/uCPU/cpuBUS.busADDRO[10]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {11: WRU}              {/testbench/uKS10/uCPU/cpuBUS.busADDRO[11]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {12: VECT}             {/testbench/uKS10/uCPU/cpuBUS.busADDRO[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO[14:35]}      {/testbench/uKS10/uCPU/cpuBUS.busADDRO[14:35]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuDATAI}             {/testbench/uKS10/uCPU/cpuBUS.busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuDATAO}             {/testbench/uKS10/uCPU/cpuBUS.busDATAO}" \
	"add wave -noupdate -divider {CPU Control Interface}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuRUN}               {/testbench/uKS10/uCPU/uINTF/cpuRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuCONT}              {/testbench/uKS10/uCPU/uINTF/cpuCONT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuEXEC}              {/testbench/uKS10/uCPU/uINTF/cpuEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuHALT}              {/testbench/uKS10/uCPU/uINTF/cpuHALT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslRUN}               {/testbench/uKS10/uCPU/uINTF/cslRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslCONT}              {/testbench/uKS10/uCPU/uINTF/cslCONT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslEXEC}              {/testbench/uKS10/uCPU/uINTF/cslEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslHALT}              {/testbench/uKS10/uCPU/uINTF/cslHALT}"

WAVE_CPU_NXD := \
	"add wave -noupdate -divider {CPU NXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/uNXD/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuREQO}              {/testbench/uKS10/uCPU/uNXD/cpuREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuACKI}              {/testbench/uKS10/uCPU/uNXD/cpuACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busIO}                {/testbench/uKS10/uCPU/uNXD/busIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busWRU}               {/testbench/uKS10/uCPU/uNXD/busWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busVECT}              {/testbench/uKS10/uCPU/uNXD/busVECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ioCLEAR}              {/testbench/uKS10/uCPU/uNXD/ioCLEAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {addr3666}             {/testbench/uKS10/uCPU/uNXD/addr3666}" \
	"add wave -noupdate -divider {CPU NXD State Machine}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wru}                  {/testbench/uKS10/uCPU/uNXD/wru}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vect}                 {/testbench/uKS10/uCPU/uNXD/vect}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busy}                 {/testbench/uKS10/uCPU/uNXD/busy}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uCPU/uNXD/state}" \
	"add wave -noupdate -divider {CPU NXD Outputs}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ioWAIT}               {/testbench/uKS10/uCPU/uNXD/ioWAIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ioBUSY}               {/testbench/uKS10/uCPU/uNXD/ioBUSY}"

WAVE_CSL := \
	"add wave -noupdate -divider {CSL}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uCSL/rst}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCSL/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/uCSL/cslBUS.busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/uCSL/cslBUS.busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/uCSL/cslBUS.busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uCSL/cslBUS.busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uCSL/cslBUS.busDATAI}" \
	"add wave -noupdate -divider {AXI BUS}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiAWADDR}            {/testbench/uKS10/uCSL/axiAWADDR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiAWVALID}           {/testbench/uKS10/uCSL/axiAWVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiAWREADY}           {/testbench/uKS10/uCSL/axiAWREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWDATA}             {/testbench/uKS10/uCSL/axiWDATA}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWSTRB}             {/testbench/uKS10/uCSL/axiWSTRB}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWVALID}            {/testbench/uKS10/uCSL/axiWVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWREADY}            {/testbench/uKS10/uCSL/axiWREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiARADDR}            {/testbench/uKS10/uCSL/axiARADDR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiARVALID}           {/testbench/uKS10/uCSL/axiARVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiARREADY}           {/testbench/uKS10/uCSL/axiARREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRDATA}             {/testbench/uKS10/uCSL/axiRDATA}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRRESP}             {/testbench/uKS10/uCSL/axiRRESP}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRVALID}            {/testbench/uKS10/uCSL/axiRVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRREADY}            {/testbench/uKS10/uCSL/axiRREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiBRESP}             {/testbench/uKS10/uCSL/axiBRESP}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiBVALID}            {/testbench/uKS10/uCSL/axiBVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiBREADY}            {/testbench/uKS10/uCSL/axiBREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWVALID}            {/testbench/uKS10/uCSL/axiWVALID}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uCSL/cslBUS.busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/uCSL/cslBUS.busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/uCSL/cslBUS.busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uCSL/cslBUS.busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uCSL/cslBUS.busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/uCSL/cslBUS.busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uCSL/cslBUS.busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uCSL/cslBUS.busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONIR}             {/testbench/uKS10/uCSL/regCONIR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONDR}             {/testbench/uKS10/uCSL/regCONDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONAR}             {/testbench/uKS10/uCSL/regCONAR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regDZCCR}             {/testbench/uKS10/uCSL/regDZCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regLPCCR}             {/testbench/uKS10/uCSL/regLPCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regRPCCR}             {/testbench/uKS10/uCSL/regRPCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regDUPCCR}            {/testbench/uKS10/uCSL/regDUPCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regCONCSR}            {/testbench/uKS10/uCSL/regCONCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONAR}             {/testbench/uKS10/uCSL/regCONAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONDR}             {/testbench/uKS10/uCSL/regCONDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rdPULSE}              {/testbench/uKS10/uCSL/rdPULSE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wrPULSE}              {/testbench/uKS10/uCSL/wrPULSE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslGO}                {/testbench/uKS10/uCSL/cslGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETOFFLN}           {/testbench/uKS10/uCSL/lpSETOFFLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslRUN}               {/testbench/uKS10/uCSL/cslRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslHALT}              {/testbench/uKS10/uCSL/cslHALT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslCONT}              {/testbench/uKS10/uCSL/cslCONT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslEXEC}              {/testbench/uKS10/uCSL/cslEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslINTR}              {/testbench/uKS10/uCSL/cslINTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uCSL/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {cslNXDTIM}            {/testbench/uKS10/uCSL/cslNXDTIM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busIO}                {/testbench/uKS10/uCSL/busIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regFVER}              {/testbench/uKS10/uCSL/regFVER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {trCLR}                {/testbench/uKS10/uCSL/trDATA.trCLR}"

WAVE_DBM := \
	"add wave -noupdate -divider {DBM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mux}                  {/testbench/uKS10/uCPU/uDBM/mux}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbm}                  {/testbench/uKS10/uCPU/uDBM/dbm}"

WAVE_DISPPF := \
	"add wave -noupdate -divider {PAGE FAIL DISPATCH}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/uDISP_PF/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {specMEMCLR}           {/testbench/uKS10/uCPU/uDISP_PF/specMEMCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memEN}                {/testbench/uKS10/uCPU/uDISP_PF/memEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pfCYCLE}              {/testbench/uKS10/uCPU/uDISP_PF/pfCYCLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pfEN}                 {/testbench/uKS10/uCPU/uDISP_PF/pfEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageENABLE}           {/testbench/uKS10/uCPU/uDISP_PF/pageENABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {timerINTR}            {/testbench/uKS10/uCPU/uDISP_PF/timerINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {nmxINTR}              {/testbench/uKS10/uCPU/uDISP_PF/nxmINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {piINTR}               {/testbench/uKS10/uCPU/uDISP_PF/piINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {intrEN}               {/testbench/uKS10/uCPU/uDISP_PF/intrEN}" \

WAVE_DUP11 :=\
	"add wave -noupdate -divider {DUP11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uDUP11/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uDUP11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uDUP11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uDUP11/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uDUP11/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uDUP11/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDUP11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDUP11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uDUP11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uDUP11/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uDUP11/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uDUP11/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uDUP11/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uDUP11/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uDUP11/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devHIBYTE}            {/testbench/uKS10/uDUP11/devHIBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devLOBYTE}            {/testbench/uKS10/uDUP11/devLOBYTE}" \
	"add wave -noupdate -divider {DUP11 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RXCSR  REG}           {/testbench/uKS10/uDUP11/regRXCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RXDBUF REG}           {/testbench/uKS10/uDUP11/regRXDBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {TXCSR  REG}           {/testbench/uKS10/uDUP11/regTXCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {TXDBUF REG}           {/testbench/uKS10/uDUP11/regTXDBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PARCSR REG}           {/testbench/uKS10/uDUP11/regPARCSR}" \
	"add wave -noupdate -divider {DUP11 MODEM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupW3}                {/testbench/uKS10/uDUP11/RXCSR/dupW3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupW5}                {/testbench/uKS10/uDUP11/RXCSR/dupW5}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupW6}                {/testbench/uKS10/uDUP11/RXCSR/dupW6}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDSCA}              {/testbench/uKS10/uDUP11/RXCSR/dupDSCA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSECTX}             {/testbench/uKS10/uDUP11/RXCSR/dupSECTX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSECRX}             {/testbench/uKS10/uDUP11/RXCSR/dupSECRX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRI}                {/testbench/uKS10/uDUP11/dupRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCTS}               {/testbench/uKS10/uDUP11/dupCTS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDCD}               {/testbench/uKS10/uDUP11/dupDCD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDSR}               {/testbench/uKS10/uDUP11/dupDSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRTS}               {/testbench/uKS10/uDUP11/dupRTS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDTR}               {/testbench/uKS10/uDUP11/dupDTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDSCB}              {/testbench/uKS10/uDUP11/RXCSR/dupDSCB}" \
	"add wave -noupdate -divider {DUP11 CLKS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMSEL}              {/testbench/uKS10/uDUP11/uDUPCLK/dupMSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk10KHz}             {/testbench/uKS10/uDUP11/uDUPCLK/clk10KHz}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk5KHz}              {/testbench/uKS10/uDUP11/uDUPCLK/clk5KHz}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMCO}               {/testbench/uKS10/uDUP11/uDUPCLK/dupMCO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMNTT}              {/testbench/uKS10/uDUP11/uDUPCLK/dupMNTT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCEN}             {/testbench/uKS10/uDUP11/uDUPCLK/dupRXCEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXCEN}             {/testbench/uKS10/uDUP11/uDUPCLK/dupTXCEN}" \
	"add wave -noupdate -divider {DUP11 TX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDECMD}             {/testbench/uKS10/uDUP11/uDUPTX/dupDECMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCI}              {/testbench/uKS10/uDUP11/uDUPTX/dupCRCI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMSEL}              {/testbench/uKS10/uDUP11/uDUPTX/dupMSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSEND}              {/testbench/uKS10/uDUP11/uDUPTX/dupSEND}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXABRT}            {/testbench/uKS10/uDUP11/uDUPTX/dupTXABRT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXEOM}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXEOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXSOM}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXSOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXCEN}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXCEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXDONE}            {/testbench/uKS10/uDUP11/uDUPTX/dupTXDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXACT}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXACT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXDLE}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXDLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXD}               {/testbench/uKS10/uDUP11/uDUPTX/dupTXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdbufWRITE}          {/testbench/uKS10/uDUP11/txdbufWRITE}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uDUPTX/state}" \
	"add wave -noupdate -divider {DUP11 USRT TX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clr}                  {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/clr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {abort}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/abort}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {flag}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/flag}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/data}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {zbi}                  {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/zbi}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {load}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/load}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {last}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/last}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {empty}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/empty}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txd}                  {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdat}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txdat}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {txlen}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txlen}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txzbi}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txzbi}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {count}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/count}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/state}" \
	"add wave -noupdate -divider {DUP11 TXCRC}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {din}                  {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/din}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {poly}                 {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/poly}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {init}                 {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/init}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {crc}                  {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/crc}" \
	"add wave -noupdate -divider {DUP11 RX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMCO}               {/testbench/uKS10/uDUP11/uDUPCLK/dupMCO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMDI}               {/testbench/uKS10/uDUP11/uDUPRX/dupMDI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXIN}              {/testbench/uKS10/uDUP11/uDUPRX/dupRXIN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupINIT}              {/testbench/uKS10/uDUP11/uDUPRX/dupINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCI}              {/testbench/uKS10/uDUP11/uDUPRX/dupCRCI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMSEL}              {/testbench/uKS10/uDUP11/uDUPRX/dupMSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXEN}              {/testbench/uKS10/uDUP11/uDUPRX/dupRXEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXACT}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXACT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXSOM}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXSOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXEOM}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXEOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCRCE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXCRCE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXABRT}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXABRT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXDONE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCINIT}           {/testbench/uKS10/uDUP11/uDUPRX/dupCRCINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDECMD}             {/testbench/uKS10/uDUP11/uDUPRX/dupDECMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSSM}               {/testbench/uKS10/uDUP11/uDUPRX/dupSSM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCEN}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXCEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXD}               {/testbench/uKS10/uDUP11/uDUPRX/dupRXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXDAT}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCRCE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXCRCE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXABRT}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXABRT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCERR}            {/testbench/uKS10/uDUP11/uDUPRX/dupCRCERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCLO}             {/testbench/uKS10/uDUP11/uDUPRX/dupCRCLO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uDUPRX/state}" \
	"add wave -noupdate -divider {DUP11 USRT RX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clr}                  {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/clr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxd}                  {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {decmode}              {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/decmode}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {synchr}               {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/synchr}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {stat}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/stat}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {bitcnt}               {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/bitcnt}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {ones}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/ones}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {zbd}                  {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/zbd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sync}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/sync}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {flag}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/flag}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {abort}                {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/abort}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {valid}                {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/valid}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/data}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {full}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/full}" \
	"add wave -noupdate -divider {DUP11 RX CRC16}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {din}                  {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/din}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {poly}                 {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/poly}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {init}                 {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/init}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {crc}                  {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/crc}" \
	"add wave -noupdate -divider {DUP11 RX INTR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupRXDONE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXDONE}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupRXIE}              {/testbench/uKS10/uDUP11/RXCSR/regRXCSR[6]}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIREQ}              {/testbench/uKS10/uDUP11/uRXINTR/dupIREQ}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIACK}              {/testbench/uKS10/uDUP11/uRXINTR/dupIACK}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupSECINH}            {/testbench/uKS10/uDUP11/uRXINTR/dupSECINH}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupPRIACT}            {/testbench/uKS10/uDUP11/uRXINTR/dupPRIACT}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIRQO}              {/testbench/uKS10/uDUP11/uRXINTR/dupIRQO}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uRXINTR/state}" \
	"add wave -noupdate -divider {DUP11 TX INTR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupTXDONE}            {/testbench/uKS10/uDUP11/uDUPTX/dupTXDONE}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupTXIE}              {/testbench/uKS10/uDUP11/TXCSR/regTXCSR[6]}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIREQ}              {/testbench/uKS10/uDUP11/uTXINTR/dupIREQ}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIACK}              {/testbench/uKS10/uDUP11/uTXINTR/dupIACK}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupSECINH}            {/testbench/uKS10/uDUP11/uTXINTR/dupSECINH}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupPRIACT}            {/testbench/uKS10/uDUP11/uTXINTR/dupPRIACT}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIRQO}              {/testbench/uKS10/uDUP11/uTXINTR/dupIRQO}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uTXINTR/state}" \
	"add wave -noupdate -divider {DUP11 REG READ/WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDUP11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDUP11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxcsrREAD}            {/testbench/uKS10/uDUP11/rxcsrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxcsrWRITE}           {/testbench/uKS10/uDUP11/rxcsrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxdbufREAD}           {/testbench/uKS10/uDUP11/rxdbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {parcsrWRITE}          {/testbench/uKS10/uDUP11/parcsrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txcsrREAD}            {/testbench/uKS10/uDUP11/txcsrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txcsrWRITE}           {/testbench/uKS10/uDUP11/txcsrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdbufREAD}           {/testbench/uKS10/uDUP11/txdbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdbufWRITE}          {/testbench/uKS10/uDUP11/txdbufWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uDUP11/vectREAD}" \
	"add wave -noupdate -divider {DUP11 BARF}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPTX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPRX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uRXINTR/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uTXINTR/*}"

WAVE_DZ11_UART0 := \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/clken}        {/testbench/uKS10/uDZ11/UART[0]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/txd}          {/testbench/uKS10/uDZ11/UART[1]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/rxd}          {/testbench/uKS10/uDZ11/UART[1]/UART/rxd}" \

WAVE_DZ11 := \
	"add wave -noupdate -divider {DZ11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uDZ11/unibus.clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uDZ11/unibus.rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devRESET}             {/testbench/uKS10/uDZ11/unibus.devRESET}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uDZ11/unibus.devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uDZ11/unibus.devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uDZ11/unibus.devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uDZ11/unibus.devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDZ11/unibus.devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDZ11/unibus.devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uDZ11/unibus.devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uDZ11/unibus.devADDRO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uDZ11/unibus.devINTRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACLO}              {/testbench/uKS10/uDZ11/unibus.devACLO}" \
	"add wave -noupdate -divider {DZ11 REG DECODE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDZ11/unibus.devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDZ11/unibus.devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uDZ11/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uDZ11/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uDZ11/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uDZ11/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrREAD}              {/testbench/uKS10/uDZ11/csrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrWRITE}             {/testbench/uKS10/uDZ11/csrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rbufREAD}             {/testbench/uKS10/uDZ11/rbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lprWRITE}             {/testbench/uKS10/uDZ11/lprWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {tcrREAD}              {/testbench/uKS10/uDZ11/tcrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {tcrWRITE}             {/testbench/uKS10/uDZ11/tcrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {msrREAD}              {/testbench/uKS10/uDZ11/msrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {tdrWRITE}             {/testbench/uKS10/uDZ11/tdrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uDZ11/vectREAD}" \
	"add wave -noupdate -divider {DZ11 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR}               {/testbench/uKS10/uDZ11/regCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regMSR}               {/testbench/uKS10/uDZ11/regMSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regRBUF}              {/testbench/uKS10/uDZ11/regRBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regTCR}               {/testbench/uKS10/uDZ11/regTCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regTDR}               {/testbench/uKS10/uDZ11/regTDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/lprREG}       {/testbench/uKS10/uDZ11/UART[0]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/lprREG}       {/testbench/uKS10/uDZ11/UART[1]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/lprREG}       {/testbench/uKS10/uDZ11/UART[2]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/lprREG}       {/testbench/uKS10/uDZ11/UART[3]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/lprREG}       {/testbench/uKS10/uDZ11/UART[4]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/lprREG}       {/testbench/uKS10/uDZ11/UART[5]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/lprREG}       {/testbench/uKS10/uDZ11/UART[6]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/lprREG}       {/testbench/uKS10/uDZ11/UART[7]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/txREG}        {/testbench/uKS10/uDZ11/UART[0]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/txREG}        {/testbench/uKS10/uDZ11/UART[1]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/txREG}        {/testbench/uKS10/uDZ11/UART[2]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/txREG}        {/testbench/uKS10/uDZ11/UART[3]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/txREG}        {/testbench/uKS10/uDZ11/UART[4]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/txREG}        {/testbench/uKS10/uDZ11/UART[5]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/txREG}        {/testbench/uKS10/uDZ11/UART[6]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/txREG}        {/testbench/uKS10/uDZ11/UART[7]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR[TRDY]}         {/testbench/uKS10/uDZ11/regCSR[15]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR[TIE]}          {/testbench/uKS10/uDZ11/regCSR[14]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR[SA]}           {/testbench/uKS10/uDZ11/regCSR[13]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR[SAE]}          {/testbench/uKS10/uDZ11/regCSR[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR[RDONE]}        {/testbench/uKS10/uDZ11/regCSR[7]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR[RIE]}          {/testbench/uKS10/uDZ11/regCSR[6]}" \
	"add wave -noupdate -divider {UART[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/clken}        {/testbench/uKS10/uDZ11/UART[0]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/rxd}          {/testbench/uKS10/uDZ11/UART[0]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/rxdata}       {/testbench/uKS10/uDZ11/UART[0]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/clken}        {/testbench/uKS10/uDZ11/UART[1]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/rxd}          {/testbench/uKS10/uDZ11/UART[1]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/rxdata}       {/testbench/uKS10/uDZ11/UART[1]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/clken}        {/testbench/uKS10/uDZ11/UART[2]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/rxd}          {/testbench/uKS10/uDZ11/UART[2]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/rxdata}       {/testbench/uKS10/uDZ11/UART[2]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/clken}        {/testbench/uKS10/uDZ11/UART[3]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/rxd}          {/testbench/uKS10/uDZ11/UART[3]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/rxdata}       {/testbench/uKS10/uDZ11/UART[3]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/clken}        {/testbench/uKS10/uDZ11/UART[4]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/rxd}          {/testbench/uKS10/uDZ11/UART[4]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/rxdata}       {/testbench/uKS10/uDZ11/UART[4]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/clken}        {/testbench/uKS10/uDZ11/UART[5]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/rxd}          {/testbench/uKS10/uDZ11/UART[5]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/rxdata}       {/testbench/uKS10/uDZ11/UART[5]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[6]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/clken}        {/testbench/uKS10/uDZ11/UART[6]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/rxd}          {/testbench/uKS10/uDZ11/UART[6]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/rxdata}       {/testbench/uKS10/uDZ11/UART[6]/UART/rxdata}" \
	"add wave -noupdate -divider {UART[7]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/clken}        {/testbench/uKS10/uDZ11/UART[7]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/rxd}          {/testbench/uKS10/uDZ11/UART[7]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/rxdata}       {/testbench/uKS10/uDZ11/UART[7]/UART/rxdata}" \
	"add wave -noupdate -divider {DZ11 Receiver}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXFRME}      {/testbench/uKS10/uDZ11/RBUF/uartRXFRME}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXPARE}      {/testbench/uKS10/uDZ11/RBUF/uartRXPARE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXFULL}      {/testbench/uKS10/uDZ11/RBUF/uartRXFULL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXCLR}       {/testbench/uKS10/uDZ11/RBUF/uartRXCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXDATA}      {/testbench/uKS10/uDZ11/RBUF/uartRXDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/rxSCAN}          {/testbench/uKS10/uDZ11/RBUF/rxSCAN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/rd}              {/testbench/uKS10/uDZ11/RBUF/rd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/wr}              {/testbench/uKS10/uDZ11/RBUF/wr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/writeDATA}       {/testbench/uKS10/uDZ11/RBUF/writeDATA}" \
	"add wave -noupdate -divider {DZ11 FIFO}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {RBUF/FIFO/SIZE}       {/testbench/uKS10/uDZ11/RBUF/RBUF/SIZE}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {RBUF/FIFO/depth}      {/testbench/uKS10/uDZ11/RBUF/RBUF/depth}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {RBUF/FIFO/rd_ptr}     {/testbench/uKS10/uDZ11/RBUF/RBUF/rd_addr}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {RBUF/FIFO/wr_ptr}     {/testbench/uKS10/uDZ11/RBUF/RBUF/wr_addr}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {RBUF/FIFO/mem}        {/testbench/uKS10/uDZ11/RBUF/RBUF/mem}" \
	"add wave -noupdate -divider {DZ11 Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uDZ11/INTR/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rbufREAD}             {/testbench/uKS10/uDZ11/INTR/rbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {tdrWRITE}             {/testbench/uKS10/uDZ11/INTR/tdrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cdrRIE}               {/testbench/uKS10/uDZ11/INTR/csrRIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrRRDY}              {/testbench/uKS10/uDZ11/INTR/csrRRDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrTIE}               {/testbench/uKS10/uDZ11/INTR/csrTIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrTRDY}              {/testbench/uKS10/uDZ11/INTR/csrTRDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxstate}              {/testbench/uKS10/uDZ11/INTR/rxstate}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txstate}              {/testbench/uKS10/uDZ11/INTR/txstate}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {arbstate}             {/testbench/uKS10/uDZ11/INTR/arbstate}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxclr}                {/testbench/uKS10/uDZ11/INTR/rxclr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txclr}                {/testbench/uKS10/uDZ11/INTR/txclr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxINTR}               {/testbench/uKS10/uDZ11/INTR/rxINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txINTR}               {/testbench/uKS10/uDZ11/INTR/txINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxVECTOR}             {/testbench/uKS10/uDZ11/INTR/rxVECTOR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uDZ11/vectREAD}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR[5]}           {/testbench/uKS10/uDZ11/unibus.devINTRO[5]}" \

WAVE_MEM := \
	"add wave -noupdate -color \"lightblue\" -divider {Memory Interface}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memCLK}               {/testbench/uKS10/uMEM/memCLK}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uMEM/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uMEM/memBUS.busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uMEM/memBUS.busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uMEM/memBUS.busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uMEM/memBUS.busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uMEM/memBUS.busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memREAD}              {/testbench/uKS10/uMEM/memREAD}"  \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memWRITE}             {/testbench/uKS10/uMEM/memWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memWRTEST}            {/testbench/uKS10/uMEM/memWRTEST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_CLK}            {/testbench/uKS10/uMEM/SSRAM_CLK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_WE_N}           {/testbench/uKS10/uMEM/SSRAM_WE_N}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_ADV}            {/testbench/uKS10/uMEM/SSRAM_ADV}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_D}              {/testbench/uKS10/uMEM/SSRAM_D}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_A}              {/testbench/uKS10/uMEM/SSRAM_A[17:0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {address}              {/testbench/uKS10/uMEM/SSRAM_A[17:1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ssramDI}              {/testbench/uKS10/uMEM/ssramDI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ssramDO}              {/testbench/uKS10/uMEM/ssramDO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM addreg}         {/testbench/SSRAM/addreg}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM dor}            {/testbench/SSRAM/dor}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {tristate}             {/testbench/SSRAM/tristate}"

WAVE_KMC11 := \
	"add wave -noupdate -divider {KMC11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uKMC11/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKMC11/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKMC11/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKMC11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKMC11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKMC11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKMC11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uKMC11/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKMC11/devDATAO}" \
	"add wave -noupdate -divider {KMC11 Registers}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMISC}              {/testbench/uKS10/uKMC11/kmcMISC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRC}              {/testbench/uKS10/uKMC11/kmcNPRC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMOUT}           {/testbench/uKS10/uKMC11/kmcCRAMOUT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMOUT}           {/testbench/uKS10/uKMC11/kmcCRAMOUT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcALU}               {/testbench/uKS10/uKMC11/kmcALU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcALUC}              {/testbench/uKS10/uKMC11/kmcALUC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcALUZ}              {/testbench/uKS10/uKMC11/kmcALUZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMEM}               {/testbench/uKS10/uKMC11/kmcMEM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMAR}               {/testbench/uKS10/uKMC11/kmcMAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcPC}                {/testbench/uKS10/uKMC11/kmcPC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAM}              {/testbench/uKS10/uKMC11/kmcCRAM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcDMUX}              {/testbench/uKS10/uKMC11/kmcDMUX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcBRG}               {/testbench/uKS10/uKMC11/kmcBRG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR0}              {/testbench/uKS10/uKMC11/kmcCSR0}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR2}              {/testbench/uKS10/uKMC11/kmcCSR2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR4}              {/testbench/uKS10/uKMC11/kmcCSR4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR6}              {/testbench/uKS10/uKMC11/kmcCSR6}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRID}             {/testbench/uKS10/uKMC11/kmcNPRID}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPROD}             {/testbench/uKS10/uKMC11/kmcNPROD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRIA}             {/testbench/uKS10/uKMC11/kmcNPRIA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPROA}             {/testbench/uKS10/uKMC11/kmcNPROA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMNTADDR}           {/testbench/uKS10/uKMC11/kmcMNTADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMNTINST}           {/testbench/uKS10/uKMC11/kmcMNTINST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel0READ}             {/testbench/uKS10/uKMC11/sel0READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel0WRITE}            {/testbench/uKS10/uKMC11/sel0WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel2READ}             {/testbench/uKS10/uKMC11/sel2READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel2WRITE}            {/testbench/uKS10/uKMC11/sel2WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel4READ}             {/testbench/uKS10/uKMC11/sel4READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel4WRITE}            {/testbench/uKS10/uKMC11/sel4WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel6READ}             {/testbench/uKS10/uKMC11/sel6READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel6WRITE}            {/testbench/uKS10/uKMC11/sel6WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uKMC11/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcPCCLKEN}           {/testbench/uKS10/uKMC11/kmcPCCLKEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMCLKEN}         {/testbench/uKS10/uKMC11/kmcCRAMCLKEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMIN}            {/testbench/uKS10/uKMC11/kmcCRAMIN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMOUT}           {/testbench/uKS10/uKMC11/kmcCRAMOUT}" \
	"add wave -noupdate -divider {KMC11 Interrupt}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSETIRQ}            {/testbench/uKS10/uKMC11/kmcSETIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcIRQO}              {/testbench/uKS10/uKMC11/kmcIRQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcVECTXXX4}          {/testbench/uKS10/uKMC11/kmcVECTXXX4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uKMC11/vectREAD}" \
	"add wave -noupdate -divider {KMC11 NPRC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKMC11/uNPRC/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKMC11/uNPRC/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcLDNPRC}            {/testbench/uKS10/uKMC11/uNPRC/kmcLDNPRC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRRQ}             {/testbench/uKS10/uKMC11/uNPRC/kmcNPRRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcGONPR}             {/testbench/uKS10/uKMC11/uNPRC/kmcGONPR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {kmcNXMCNT}            {/testbench/uKS10/uKMC11/uNPRC/kmcNXMCNT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSETNXM}            {/testbench/uKS10/uKMC11/uNPRC/kmcSETNXM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcBYTEXFER}          {/testbench/uKS10/uKMC11/uNPRC/kmcBYTEXFER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRO}              {/testbench/uKS10/uKMC11/uNPRC/kmcNPRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcBAEI}              {/testbench/uKS10/uKMC11/uNPRC/kmcBAEI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcBAEO}              {/testbench/uKS10/uKMC11/kmcBAEO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcXLXFER}            {/testbench/uKS10/uKMC11/uNPRC/kmcNLXFER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRRQ}             {/testbench/uKS10/uKMC11/uNPRC/kmcNPRRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSETNXM}            {/testbench/uKS10/uKMC11/uNPRC/kmcSETNXM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRCLKEN}          {/testbench/uKS10/uKMC11/uNPRC/kmcNPRCLKEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uKMC11/uNPRC/state}" \
#	"add wave -noupdate -divider {KMC11 Memories}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAM_MEM}          {/testbench/uKS10/uKMC11/uSEQ/kmcCRAM_MEM}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcRAM}               {/testbench/uKS10/uKMC11/uMEM/ram}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSP}                {/testbench/uKS10/uKMC11/uALU/kmcSP}" \
#	"add wave -noupdate -divider {KMC11 ALL}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/*}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/uSEQ/*}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/uALU/*}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/uBRG/*}" \

WAVE_KS10 :=\
	"add wave -noupdate -divider {KS10 Device Interconnect}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/devDATAO}"

WAVE_LP20 :=\
	"add wave -noupdate -divider {LP20}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uLP20/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uLP20/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKO}             {/testbench/uKS10/uLP20/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRI}            {/testbench/uKS10/uLP20/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAI}            {/testbench/uKS10/uLP20/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}             {/testbench/uKS10/uLP20/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKI}              {/testbench/uKS10/uLP20/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRO}             {/testbench/uKS10/uLP20/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAO}             {/testbench/uKS10/uLP20/devDATAO}" \
        "add wave -noupdate -divider {LP20 Decoder}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uLP20/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uLP20/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uLP20/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uLP20/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uLP20/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTOF}                {/testbench/uKS10/uLP20/lpTOF}" \
	"add wave -noupdate -divider {LP20 REG READ/WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uLP20/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uLP20/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csraREAD}             {/testbench/uKS10/uLP20/csraREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csraWRITE}            {/testbench/uKS10/uLP20/csraWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbREAD}             {/testbench/uKS10/uLP20/csrbREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbWRITE}            {/testbench/uKS10/uLP20/csrbWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {barREAD}              {/testbench/uKS10/uLP20/barREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {barWRITE}             {/testbench/uKS10/uLP20/barWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {bctrREAD}             {/testbench/uKS10/uLP20/bctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {bctrWRITE}            {/testbench/uKS10/uLP20/bctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pctrREAD}             {/testbench/uKS10/uLP20/pctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pctrWRITE}            {/testbench/uKS10/uLP20/pctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramdREAD}             {/testbench/uKS10/uLP20/ramdREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramdWRITE}            {/testbench/uKS10/uLP20/ramdWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cctrREAD}             {/testbench/uKS10/uLP20/cctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cctrWRITE}            {/testbench/uKS10/uLP20/cctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cbufREAD}             {/testbench/uKS10/uLP20/cbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cbufWRITE}            {/testbench/uKS10/uLP20/cbufWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cksmREAD}             {/testbench/uKS10/uLP20/cksmREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cksmWRITE}            {/testbench/uKS10/uLP20/cksmWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pdatREAD}             {/testbench/uKS10/uLP20/pdatREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pdatWRITE}            {/testbench/uKS10/uLP20/pdatWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uLP20/vectREAD}" \
	"add wave -noupdate -divider {LP20 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CSRA REG}             {/testbench/uKS10/uLP20/regCSRA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CSRB REG}             {/testbench/uKS10/uLP20/regCSRB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BAR  REG}             {/testbench/uKS10/uLP20/regBAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BCTR REG}             {/testbench/uKS10/uLP20/regBCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PCTR REG}             {/testbench/uKS10/uLP20/regPCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMD REG}             {/testbench/uKS10/uLP20/regRAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CCTR REG}             {/testbench/uKS10/uLP20/regCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/regCBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CKSM REG}             {/testbench/uKS10/uLP20/regCKSM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PDAT REG}             {/testbench/uKS10/uLP20/regPDAT}" \
	"add wave -noupdate -divider {LP20 PCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbWRITE}            {/testbench/uKS10/uLP20/PCTR/csrbWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lastDECR}             {/testbench/uKS10/uLP20/PCTR/lastDECR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTPCTR}           {/testbench/uKS10/uLP20/PCTR/lpTESTPCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {decrement}            {/testbench/uKS10/uLP20/PCTR/decrement}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regPCTR}              {/testbench/uKS10/uLP20/PCTR/regPCTR}" \
	"add wave -noupdate -divider {LP20 DMA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDGO}              {/testbench/uKS10/uLP20/DMA/lpCMDGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDSTOP}            {/testbench/uKS10/uLP20/DMA/lpCMDSTOP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpREADY}              {/testbench/uKS10/uLP20/DMA/lpREADY}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {DMA state}            {/testbench/uKS10/uLP20/DMA/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {DMA timer}            {/testbench/uKS10/uLP20/DMA/timer}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDONE}               {/testbench/uKS10/uLP20/DMA/lpDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTMSYN}           {/testbench/uKS10/uLP20/DMA/lpTESTMSYN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTMPE}            {/testbench/uKS10/uLP20/DMA/lpTESTMPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCR}               {/testbench/uKS10/uLP20/DMA/lpINCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETMSYN}            {/testbench/uKS10/uLP20/DMA/lpSETMSYN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETMPE}             {/testbench/uKS10/uLP20/DMA/lpSETMPE}" \
	"add wave -noupdate -divider {LP20 Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uLP20/INTR/devINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINTR}               {/testbench/uKS10/uLP20/INTR/lpINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpIE}                 {/testbench/uKS10/uLP20/INTR/lpIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpIRQ}                {/testbench/uKS10/uLP20/INTR/lpIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETIRQ}             {/testbench/uKS10/uLP20/CSRA/lpSETIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETERR}             {/testbench/uKS10/uLP20/CSRA/lpSETERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETPCZ}             {/testbench/uKS10/uLP20/CSRA/lpSETPCZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETUNDC}            {/testbench/uKS10/uLP20/CSRA/lpSETUNDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDONE}            {/testbench/uKS10/uLP20/CSRA/lpDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFURDY}             {/testbench/uKS10/uLP20/CSRA/lpVFURDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uLP20/CSRA/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lastONLINE}           {/testbench/uKS10/uLP20/CSRA/lastONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINIT}               {/testbench/uKS10/uLP20/INTR/lpINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRI}               {/testbench/uKS10/uLP20/INTR/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uLP20/INTR/vectREAD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP20/INTR/state}" \
	"add wave -noupdate -divider {LP20 RAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uLP20/RAMD/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uLP20/RAMD/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATAI}              {/testbench/uKS10/uLP20/RAMD/lpDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramWRITE}             {/testbench/uKS10/uLP20/RAMD/ramWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wordDATAI}            {/testbench/uKS10/uLP20/RAMD/wordDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {byteDATAI}            {/testbench/uKS10/uLP20/RAMD/byteDATAI}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {ramADDR}              {/testbench/uKS10/uLP20/RAMD/ramADDR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpADDR}               {/testbench/uKS10/uLP20/RAMD/lpADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDGO}              {/testbench/uKS10/uLP20/RAMD/lpCMDGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCADDR}            {/testbench/uKS10/uLP20/RAMD/lpINCADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODEPRINT}          {/testbench/uKS10/uLP20/RAMD/lpMODEPRINT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODETEST}           {/testbench/uKS10/uLP20/RAMD/lpMODETEST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODELDVFU}          {/testbench/uKS10/uLP20/RAMD/lpMODELDVFU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODELDRAM}          {/testbench/uKS10/uLP20/RAMD/lpMODELDRAM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramDATA}              {/testbench/uKS10/uLP20/RAMD/ramDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramCTRL}              {/testbench/uKS10/uLP20/RAMD/ramCTRL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regRAMD}              {/testbench/uKS10/uLP20/RAMD/regRAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpRPEEN}              {/testbench/uKS10/uLP20/RAMD/lpRPEEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDHLDEN}             {/testbench/uKS10/uLP20/RAMD/lpDHLDEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDHLD}            {/testbench/uKS10/uLP20/RAMD/lpSETDHLD}" \
	"add wave -noupdate -divider {LP20 PDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uLP20/PDAT/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uLP20/PDAT/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDMAWR}              {/testbench/uKS10/uLP20/PDAT/lpDMAWR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMD REG}             {/testbench/uKS10/uLP20/PDAT/lpRAMD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {CCTR REG}             {/testbench/uKS10/uLP20/PDAT/lpCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOP}                 {/testbench/uKS10/uLP20/PDAT/lpOP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTDTE}            {/testbench/uKS10/uLP20/PDAT/lpTESTDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTLPE}            {/testbench/uKS10/uLP20/PDAT/lpTESTLPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDTE}             {/testbench/uKS10/uLP20/PDAT/lpSETDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDPAR}               {/testbench/uKS10/uLP20/PDAT/lpDPAR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP20/PDAT/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCLRCCTR}            {/testbench/uKS10/uLP20/PDAT/lpCLRCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCCCTR}            {/testbench/uKS10/uLP20/PDAT/lpINCCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETUNDC}            {/testbench/uKS10/uLP20/PDAT/lpSETUNDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDTE}             {/testbench/uKS10/uLP20/PDAT/lpSETDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDEMAND}             {/testbench/uKS10/uLP20/PDAT/lpDEMAND}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVAL}                {/testbench/uKS10/uLP20/PDAT/lpVAL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpLPE}                {/testbench/uKS10/uLP20/PDAT/lpLPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPI}                 {/testbench/uKS10/uLP20/PDAT/lpPI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSTROBE}             {/testbench/uKS10/uLP20/PDAT/lpSTROBE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uLP20/PDAT/lpDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPDAT}               {/testbench/uKS10/uLP20/PDAT/lpPDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPARERR}             {/testbench/uKS10/uLP20/PDAT/lpPARERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpREADY}              {/testbench/uKS10/uLP20/DMA/lpREADY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {strobe}               {/testbench/uKS10/uLP20/PDAT/strobe}" \
	"add wave -noupdate -divider {LP26}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uLP26/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uLP26/rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINIT}               {/testbench/uKS10/uLP26/lpINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOVFU}               {/testbench/uKS10/uLP26/lpOVFU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETONLN}            {/testbench/uKS10/uLP26/lpSETONLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETOFFLN}           {/testbench/uKS10/uLP26/lpSETOFFLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uLP26/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSTROBE}             {/testbench/uKS10/uLP26/lpSTROBE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPI}                 {/testbench/uKS10/uLP26/lpPI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uLP26/lpDATA}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uLP26/lpDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDPAR}               {/testbench/uKS10/uLP26/lpDPAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPARERR}             {/testbench/uKS10/uLP26/lpPARERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFURDY}             {/testbench/uKS10/uLP26/lpVFURDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDEMAND}             {/testbench/uKS10/uLP26/lpDEMAND}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLCTR}               {/testbench/uKS10/uLP26/lpLCTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpVFULEN}             {/testbench/uKS10/uLP26/lpVFULEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXEMPTY}            {/testbench/uKS10/uLP26/lpTXEMPTY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXSTB}              {/testbench/uKS10/uLP26/lpTXSTB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXDAT}              {/testbench/uKS10/uLP26/lpTXDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpXON}                {/testbench/uKS10/uLP26/lpXON}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP26/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpDVFULEN}            {/testbench/uKS10/uLP26/lpDVFULEN}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpOVFULEN}            {/testbench/uKS10/uLP26/lpOVFULEN}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpVFULEN}             {/testbench/uKS10/uLP26/lpVFULEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTEMP}               {/testbench/uKS10/uLP26/lpTEMP}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpCOUNT}              {/testbench/uKS10/uLP26/lpCOUNT}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLFCNT}              {/testbench/uKS10/uLP26/lpLFCNT}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLCTR}               {/testbench/uKS10/uLP26/lpLCTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpCCTR}               {/testbench/uKS10/uLP26/lpCCTR}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {lpLINBUF}             {/testbench/uKS10/uLP26/lpLINBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTOF}                {/testbench/uKS10/uLP26/lpTOF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDVFUDAT}            {/testbench/uKS10/uLP26/lpDVFUDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOVFUDAT}            {/testbench/uKS10/uLP26/lpOVFUDAT}" \
	"add wave -noupdate -divider {LP20 UART}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uLP26/TX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {load}                 {/testbench/uKS10/uLP26/TX/load}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uLP26/TX/data}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uLP26/TX/data}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP26/TX/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {empty}                {/testbench/uKS10/uLP26/TX/empty}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {intr}                 {/testbench/uKS10/uLP26/TX/intr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpRXD}                {/testbench/uKS10/uLP26/lpRXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXD}                {/testbench/uKS10/uLP26/lpTXD}"

WAVE_MT := \
	"add wave -noupdate -divider {MT0}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uMT/massbus.clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDATAI}              {/testbench/uKS10/uMT/mtDATAI}" \
	"add wave -noupdate -divider {Massbus}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtINIT}               {/testbench/uKS10/uMT/mtINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtUNIT}               {/testbench/uKS10/uMT/mtUNIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSS}                 {/testbench/uKS10/uMT/mtSS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSEL}                {/testbench/uKS10/uMT/mtSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtREAD}               {/testbench/uKS10/uMT/mtREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRITE}              {/testbench/uKS10/uMT/mtWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtREGSEL}             {/testbench/uKS10/uMT/mtREGSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mbREGDAT}             {/testbench/uKS10/uMT/massbus.mbREGDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mbREGACK}             {/testbench/uKS10/uMT/massbus.mbREGACK}" \
	"add wave -noupdate -divider {MT0 Registers Decode}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRCS1}              {/testbench/uKS10/uMT/mtWRCS1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRFC}               {/testbench/uKS10/uMT/mtWRFC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRAS}               {/testbench/uKS10/uMT/mtWRAS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRCC}               {/testbench/uKS10/uMT/mtWRCC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRMR}               {/testbench/uKS10/uMT/mtWRMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRTC}               {/testbench/uKS10/uMT/mtWRTC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDCS1}              {/testbench/uKS10/uMT/mtRDCS1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDDS}               {/testbench/uKS10/uMT/mtRDDS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDER}               {/testbench/uKS10/uMT/mtRDER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDMR}               {/testbench/uKS10/uMT/mtRDMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDAS}               {/testbench/uKS10/uMT/mtRDAS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDFC}               {/testbench/uKS10/uMT/mtRDFC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDDT}               {/testbench/uKS10/uMT/mtRDDT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDCC}               {/testbench/uKS10/uMT/mtRDCC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDSN}               {/testbench/uKS10/uMT/mtRDSN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtRDTC}               {/testbench/uKS10/uMT/mtRDTC}" \
	"add wave -noupdate -divider {MT0 Registers}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTFC REG}             {/testbench/uKS10/uMT/mtFC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTDS REG}             {/testbench/uKS10/uMT/mtDS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTER REG}             {/testbench/uKS10/uMT/mtER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTCC REG}             {/testbench/uKS10/uMT/mtCC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTMR REG}             {/testbench/uKS10/uMT/mtMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTDT REG}             {/testbench/uKS10/uMT/drvTYPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTSN REG}             {/testbench/uKS10/uMT/drvSN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC REG}             {/testbench/uKS10/uMT/mtTC}" \
	"add wave -noupdate -divider {MT0 Signals}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC/mtINIT}          {/testbench/uKS10/uMT/TC/mtINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC/mtDATAI}         {/testbench/uKS10/uMT/TC/mtDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC/mtWRTC}          {/testbench/uKS10/uMT/TC/mtWRTC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC/mtSETFCS}        {/testbench/uKS10/uMT/TC/mtSETFCS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC/mtCLRFCS}        {/testbench/uKS10/uMT/TC/mtCLRFCS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTTC/mtTC}            {/testbench/uKS10/uMT/TC/mtTC}" \
	"add wave -noupdate -divider {MT0 CTRL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRLO}               {/testbench/uKS10/uMT/CTRL/mtWRLO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWRHI}               {/testbench/uKS10/uMT/CTRL/mtWRHI}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {mtWSTRB}              {/testbench/uKS10/uMT/CTRL/mtWSTRB}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {mtCSLDATAI}           {/testbench/uKS10/uMT/CTRL/mtCSLDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtMOL}                {/testbench/uKS10/uMT/CTRL/mtMOL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtNPRO}               {/testbench/uKS10/uMT/CTRL/mtNPRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSTB}                {/testbench/uKS10/uMT/CTRL/mtSTB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDIRINIT}            {/testbench/uKS10/uMT/CTRL/mtDIRINT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtEOT}                {/testbench/uKS10/uMT/CTRL/mtEOT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtBOT}                {/testbench/uKS10/uMT/CTRL/mtBOT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtTM}                 {/testbench/uKS10/uMT/CTRL/mtTM}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {mtDIRO}               {/testbench/uKS10/uMT/CTRL/mtDIRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtMOTCMD}             {/testbench/uKS10/uMT/CTRL/mtMOTCMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtATA}                {/testbench/uKS10/uMT/CTRL/mtATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DS/dsERATA}           {/testbench/uKS10/uMT/DS/dsERATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DS/dsATA}             {/testbench/uKS10/uMT/mtDS[15]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDRY}                {/testbench/uKS10/uMT/CTRL/mtDRY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSSC}                {/testbench/uKS10/uMT/CTRL/mtSSC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSLA}                {/testbench/uKS10/uMT/CTRL/mtSLA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtPIP}                {/testbench/uKS10/uMT/CTRL/mtPIP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSSC}                {/testbench/uKS10/uMT/CTRL/mtSSC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtFWD}                {/testbench/uKS10/uMT/CTRL/mtFWD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtACCL}               {/testbench/uKS10/uMT/CTRL/mtACCL}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {mtACCLTIM}            {/testbench/uKS10/uMT/CTRL/mtACCLTIM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSDWN}               {/testbench/uKS10/uMT/CTRL/mtSDWN}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {mtSDWNTIM}            {/testbench/uKS10/uMT/CTRL/mtSDWNTIM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtBUSY}               {/testbench/uKS10/uMT/CTRL/mtBUSY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSTBI}               {/testbench/uKS10/uMT/CTRL/mtSTBI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtINCBA}              {/testbench/uKS10/uMT/CTRL/mtINCBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDECBA}              {/testbench/uKS10/uMT/CTRL/mtDECBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtINCWC}              {/testbench/uKS10/uMT/CTRL/mtINCWC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtINCFC}              {/testbench/uKS10/uMT/CTRL/mtINCFC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtWCZ}                {/testbench/uKS10/uMT/CTRL/mtWCZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtFCZ}                {/testbench/uKS10/uMT/CTRL/mtFCZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHWC REG}             {/testbench/uKS10/uRH11B/rhWC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHBA REG}             {/testbench/uKS10/uRH11B/rhBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTFC REG}             {/testbench/uKS10/uMT/mtFC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtGO}                 {/testbench/uKS10/uMT/CTRL/mtGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtFUN}                {/testbench/uKS10/uMT/CTRL/mtFUN}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {state}                {/testbench/uKS10/uMT/CTRL/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDATAO}              {/testbench/uKS10/uMT/CTRL/mtDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtREADY}              {/testbench/uKS10/uMT/CTRL/mtREADY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtSTB}                {/testbench/uKS10/uMT/CTRL/mtSTB}" \
	"add wave -noupdate -divider {DEBUG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/uMT/CTRL/mtREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/uMT/CTRL/mtACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDATAI}              {/testbench/uKS10/uMT/CTRL/mtDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtDATAO}              {/testbench/uKS10/uMT/CTRL/mtDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtMDF}                {/testbench/uKS10/uMT/CTRL/mtMDF}" \
	"add wave -noupdate -divider {MRCLK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uMT/MR/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtmrWRITE}            {/testbench/uKS10/uMT/MR/mtmrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTMR REG}             {/testbench/uKS10/uMT/MR/mtMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTMR[MM]}             {/testbench/uKS10/uMT/MR/mtMR[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTMR[MOP]}            {/testbench/uKS10/uMT/MR/mtMR[4:1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MTMR[MC]}             {/testbench/uKS10/uMT/MR/mtMR[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mtGO}                 {/testbench/uKS10/uMT/MR/mtGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wrdly}                {/testbench/uKS10/uMT/MR/wrdly}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {toggle}               {/testbench/uKS10/uMT/MR/toggle}"

WAVE_PAGER :=\
	"add wave -noupdate -divider {PAGER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/uPAGER/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uCPU/uPAGER/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO}             {/testbench/uKS10/uCPU/cpuADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vmaEN}                {/testbench/uKS10/uCPU/uPAGER/vmaEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {crom}                 {/testbench/uKS10/uCPU/uPAGER/crom}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {drom}                 {/testbench/uKS10/uCPU/uPAGER/drom}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {specPAGEWRITE}        {/testbench/uKS10/uCPU/uPAGER/specPAGEWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {specPAGESWEEP}        {/testbench/uKS10/uCPU/uPAGER/specPAGESWEEP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {specMEMCLR}           {/testbench/uKS10/uCPU/uPAGER/specMEMCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITE}            {/testbench/uKS10/uCPU/uPAGER/pageWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageSWEEP}            {/testbench/uKS10/uCPU/uPAGER/pageSWEEP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeEN}              {/testbench/uKS10/uCPU/writeEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uCPU/pageFAIL}" \
	"add wave -noupdate -divider {}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageVALID}            {/testbench/uKS10/uCPU/uPAGER/pageVALID}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITEABLE}        {/testbench/uKS10/uCPU/uPAGER/pageWRITEABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageCACHEABLE}        {/testbench/uKS10/uCPU/uPAGER/pageCACHEABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageADDRI}            {/testbench/uKS10/uCPU/uPAGER/pageADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeSel}             {/testbench/uKS10/uCPU/uPAGER/writeSel}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeAddr}            {/testbench/uKS10/uCPU/uPAGER/writeAddr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageVMA}              {/testbench/uKS10/uCPU/uPAGER/pageVMA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageTABLE}            {/testbench/uKS10/uCPU/uPAGER/pageTABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS}            {/testbench/uKS10/uCPU/uPAGER/pageFLAGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageVALID}            {/testbench/uKS10/uCPU/uPAGER/pageFLAGS[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITEABLE}        {/testbench/uKS10/uCPU/uPAGER/pageFLAGS[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageCACHEABLE}        {/testbench/uKS10/uCPU/uPAGER/pageFLAGS[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageUSER}             {/testbench/uKS10/uCPU/uPAGER/pageFLAGS[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageADDR}             {/testbench/uKS10/uCPU/uPAGER/pageADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {physAddr}             {/testbench/uKS10/uCPU/uPAGER/physAddr}"

WAVE_RH11A := \
	"add wave -noupdate -divider {RH11A}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uRH11A/unibus.devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uRH11A/unibus.devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uRH11A/unibus.devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uRH11A/unibus.devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uRH11A/unibus.devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uRH11A/unibus.devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uRH11A/unibus.devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uRH11A/unibus.devADDRO}" \
	"add wave -noupdate -divider {RH11A Register Addressing}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uRH11A/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CS1 READ}             {/testbench/uKS10/uRH11A/rhRDREG00}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CS2 WRITE}            {/testbench/uKS10/uRH11A/rhWRREG00}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {WC  READ}             {/testbench/uKS10/uRH11A/rhRDREG02}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {WC  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG02}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BA  READ}             {/testbench/uKS10/uRH11A/rhRDREG04}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BA   WRITE}           {/testbench/uKS10/uRH11A/rhWRREG04}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DA/FC READ}           {/testbench/uKS10/uRH11A/rhRDREG06}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DA/FC WRITE}          {/testbench/uKS10/uRH11A/rhWRREG06}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CS2 READ}             {/testbench/uKS10/uRH11A/rhRDREG10}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CS2 WRITE}            {/testbench/uKS10/uRH11A/rhWRREG10}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DS  READ}             {/testbench/uKS10/uRH11A/rhRDREG12}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DS  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG12}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ER  READ}             {/testbench/uKS10/uRH11A/rhRDREG14}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ER  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG14}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AS  READ}             {/testbench/uKS10/uRH11A/rhRDREG16}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AS  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG16}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {LA/CC READ}           {/testbench/uKS10/uRH11A/rhRDREG20}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {LA/CC WRITE}          {/testbench/uKS10/uRH11A/rhWRREG20}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DB  READ}             {/testbench/uKS10/uRH11A/rhRDREG22}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DB  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG22}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MR  READ}             {/testbench/uKS10/uRH11A/rhRDREG24}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {MR  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG24}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DT  READ}             {/testbench/uKS10/uRH11A/rhRDREG26}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DT  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG26}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SN  READ}             {/testbench/uKS10/uRH11A/rhRDREG30}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SN  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG30}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {OF/TC READ}           {/testbench/uKS10/uRH11A/rhRDREG32}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {OF/TC WRITE}          {/testbench/uKS10/uRH11A/rhWRREG32}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DC  READ}             {/testbench/uKS10/uRH11A/rhRDREG34}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DC  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG34}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CC  READ}             {/testbench/uKS10/uRH11A/rhRDREG36}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CC  WRITE}            {/testbench/uKS10/uRH11A/rhWRREG36}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ER2 READ}             {/testbench/uKS10/uRH11A/rhRDREG40}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ER2 WRITE}            {/testbench/uKS10/uRH11A/rhWRREG40}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ER3 READ}             {/testbench/uKS10/uRH11A/rhRDREG42}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ER3 WRITE}            {/testbench/uKS10/uRH11A/rhWRREG42}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {EC1 READ}             {/testbench/uKS10/uRH11A/rhRDREG44}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {EC1 WRITE}            {/testbench/uKS10/uRH11A/rhWRREG44}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {EC2 READ}             {/testbench/uKS10/uRH11A/rhRDREG46}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {EC2 WRITE}            {/testbench/uKS10/uRH11A/rhWRREG46}" \
	"add wave -noupdate -divider {RH11A Registers}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rhISDISK}             {/testbench/uKS10/uRH11A/rhISDISK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHCS1 REG}            {/testbench/uKS10/uRH11A/rhCS1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHWC  REG}            {/testbench/uKS10/uRH11A/rhWC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHBA  REG}            {/testbench/uKS10/uRH11A/rhBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHCS2 REG}            {/testbench/uKS10/uRH11A/rhCS2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHDB  REG}            {/testbench/uKS10/uRH11A/rhDB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHAS  REG}            {/testbench/uKS10/uRH11A/rhAS}" \
	"add wave -noupdate -divider {RH11A Debug}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rhSETNED}             {/testbench/uKS10/uRH11A/rhSETNED}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rhREAD}               {/testbench/uKS10/uRH11A/rhREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rhWRITE}              {/testbench/uKS10/uRH11A/rhWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rhREGNED}             {/testbench/uKS10/uRH11A/rhREGNED}" \

WAVE_RH11B := $(subst RH11A,RH11B,$(WAVE_RH11A))

WAVE_RP1 := \
	"add wave -noupdate -divider {RP1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uRP/unibus.devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uRP/unibus.devADDRI}" \
	"add wave -noupdate -divider {HERE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uRP/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rhUNIT}               {/testbench/uKS10/uRP/rhUNIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpUNIT[0]}            {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpUNIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpSELECT[0]}          {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpSELECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpMR[0]}              {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpMR[1]}              {/testbench/uKS10/uRP/uRPXX[1]/uRPXX/rpMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpMR[2]}              {/testbench/uKS10/uRP/uRPXX[2]/uRPXX/rpMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpMR[3]}              {/testbench/uKS10/uRP/uRPXX[3]/uRPXX/rpMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpOF[0]}              {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpOF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpGO}                 {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN}                {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpFUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_GO[0]}          {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpFUN_GO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_GO[1]}          {/testbench/uKS10/uRP/uRPXX[1]/uRPXX/rpFUN_GO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_GO[2]}          {/testbench/uKS10/uRP/uRPXX[2]/uRPXX/rpFUN_GO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_GO[3]}          {/testbench/uKS10/uRP/uRPXX[3]/uRPXX/rpFUN_GO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_DRVCLR[0]}      {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/rpFUN_DRVCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_DRVCLR[1]}      {/testbench/uKS10/uRP/uRPXX[1]/uRPXX/rpFUN_DRVCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_DRVCLR[2]}      {/testbench/uKS10/uRP/uRPXX[2]/uRPXX/rpFUN_DRVCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpFUN_DRVCLR[3]}      {/testbench/uKS10/uRP/uRPXX[3]/uRPXX/rpFUN_DRVCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CTRL/rpGO}            {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/CTRL/rpGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CTRL/rpFUN}           {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/CTRL/rpFUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CTRL/go_cmd}          {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/CTRL/go_cmd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CTRL/rst}             {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/CTRL/rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CTRL/devRESET}        {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/CTRL/devRESET}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uRP/uRPXX[0]/uRPXX/CTRL/state}" \

WAVE_SD := \
	"add wave -noupdate -divider {SD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ch}                   {/testbench/SD/ch}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {spiTX}                {/testbench/SD/spiTX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uRH11A/uSD/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uRH11A/uSD/devDATAO}" \

WAVE_TRACE := \
	"add wave -noupdate -divider {TRACE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uTRACE/rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uTRACE/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuPC}                {/testbench/uKS10/uTRACE/cpuPC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuHR}                {/testbench/uKS10/uTRACE/cpuHR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regsLOAD}             {/testbench/uKS10/uTRACE/regsLOAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {trPCIR}               {/testbench/uKS10/uTRACE/trPCIR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {trADV}                {/testbench/uKS10/uTRACE/trDATA.trADV}"\
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {push}                 {/testbench/uKS10/uTRACE/push}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pop}                  {/testbench/uKS10/uTRACE/pop}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rd_addr}              {/testbench/uKS10/uTRACE/TRACEBUF/rd_addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wr_addr}              {/testbench/uKS10/uTRACE/TRACEBUF/wr_addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {depth}                {/testbench/uKS10/uTRACE/TRACEBUF/depth}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack}                {/testbench/uKS10/uTRACE/TRACEBUF/stack}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {full}                 {/testbench/uKS10/uTRACE/full}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {empty}                {/testbench/uKS10/uTRACE/empty}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {trCLR}                  {/testbench/uKS10/uTRACE/trDATA.trCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clr}                  {/testbench/uKS10/uTRACE/clr}" \

WAVE_UBA1 := \
	"add wave -noupdate -divider {UBA1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/UBA1/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaINTRI}             {/testbench/uKS10/uARB/ubaINTRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuINTRO}             {/testbench/uKS10/uARB/cpuINTRO}" \
	"add wave -noupdate -divider {UBA1 Interface}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/UBA1/ks10bus.busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { busACKO}             {/testbench/uKS10/UBA1/ks10bus.busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { busADDRI}            {/testbench/uKS10/UBA1/ks10bus.busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { busDATAI}            {/testbench/uKS10/UBA1/ks10bus.busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/UBA1/ks10bus.busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { busACKI}             {/testbench/uKS10/UBA1/ks10bus.busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { busADDRO}            {/testbench/uKS10/UBA1/ks10bus.busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { busDATAO}            {/testbench/uKS10/UBA1/ks10bus.busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/UBA1/INTR/devINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busINTR}              {/testbench/uKS10/UBA1/INTR/busINTR}" \
	"add wave -noupdate -divider {UBA1 Register Control}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wruREAD}              {/testbench/uKS10/UBA1/wruREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/UBA1/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageREAD}             {/testbench/uKS10/UBA1/pageREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITE}            {/testbench/uKS10/UBA1/pageWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {statREAD}             {/testbench/uKS10/UBA1/statREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {statWRITE}            {/testbench/uKS10/UBA1/statWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {maintWRITE}           {/testbench/uKS10/UBA1/maintWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREAD}              {/testbench/uKS10/UBA1/ubaREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaWRITE}             {/testbench/uKS10/UBA1/ubaWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/UBA1/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/UBA1/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopREAD}             {/testbench/uKS10/UBA1/loopREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopWRITE}            {/testbench/uKS10/UBA1/loopWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regUBASR}             {/testbench/uKS10/UBA1/regUBASR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regUBAMR}             {/testbench/uKS10/UBA1/regUBAMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopADDR}             {/testbench/uKS10/UBA1/loopADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopDATA}             {/testbench/uKS10/UBA1/loopDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpwDATA}              {/testbench/uKS10/UBA1/rpwDATA}" \
	"add wave -noupdate -divider {UBA1 Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busINTR}              {/testbench/uKS10/UBA1/busINTR}" \
	"add wave -noupdate -divider {UBA1 Error and Arbitration}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {cntNXD}               {/testbench/uKS10/UBA1/cntNXD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {cntTMO}               {/testbench/uKS10/UBA1/cntTMO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {setNXD}               {/testbench/uKS10/UBA1/setNXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {setTMO}               {/testbench/uKS10/UBA1/setTMO}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/UBA1/state}" \
	"add wave -noupdate -divider {UBA1 Paging}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageADDRI}            {/testbench/uKS10/UBA1/PAGE/pageADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/UBA1/PAGE/busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/UBA1/PAGE/pageFAIL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS[RRV]}       {/testbench/uKS10/UBA1/PAGE/pageFLAGS[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS[E16]}       {/testbench/uKS10/UBA1/PAGE/pageFLAGS[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS[FTM]}       {/testbench/uKS10/UBA1/PAGE/pageFLAGS[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS[VLD]}       {/testbench/uKS10/UBA1/PAGE/pageFLAGS[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageRAM}              {/testbench/uKS10/UBA1/PAGE/pageRAM}" \
	"add wave -noupdate -divider {UBA1 DEV 1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[1]}           {/testbench/uKS10/UBA1/devINTR[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[1]}           {/testbench/uKS10/UBA1/devREQI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKO[1]}          {/testbench/uKS10/UBA1/devACKO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRI[1]}         {/testbench/uKS10/UBA1/devADDRI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAI[1]}         {/testbench/uKS10/UBA1/devDATAI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[1]}           {/testbench/uKS10/UBA1/devREQO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKI[1]}          {/testbench/uKS10/UBA1/devACKI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRO[1]}         {/testbench/uKS10/UBA1/devADDRO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAO[1]}         {/testbench/uKS10/UBA1/devDATAO[1]}" \
	"add wave -noupdate -divider {UBA1 DEV 2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[2]}           {/testbench/uKS10/UBA1/devINTR[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[2]}           {/testbench/uKS10/UBA1/devREQI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKO[2]}          {/testbench/uKS10/UBA1/devACKO[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRI[2]}         {/testbench/uKS10/UBA1/devADDRI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAI[2]}         {/testbench/uKS10/UBA1/devDATAI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[2]}           {/testbench/uKS10/UBA1/devREQO[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKI[2]}          {/testbench/uKS10/UBA1/devACKI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRO[2]}         {/testbench/uKS10/UBA1/devADDRO[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAO[2]}         {/testbench/uKS10/UBA1/devDATAO[2]}" \
	"add wave -noupdate -divider {UBA1 DEV 3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[3]}           {/testbench/uKS10/UBA1/devINTR[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[3]}           {/testbench/uKS10/UBA1/devREQI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKO[3]}          {/testbench/uKS10/UBA1/devACKO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRI[3]}         {/testbench/uKS10/UBA1/devADDRI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAI[3]}         {/testbench/uKS10/UBA1/devDATAI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[3]}           {/testbench/uKS10/UBA1/devREQO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKI[3]}          {/testbench/uKS10/UBA1/devACKI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRO[3]}         {/testbench/uKS10/UBA1/devADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAO[3]}         {/testbench/uKS10/UBA1/devDATAO[3]}" \
	"add wave -noupdate -divider {UBA1 DEV 4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[4]}           {/testbench/uKS10/UBA1/devINTR[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[4]}           {/testbench/uKS10/UBA1/devREQI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKO[4]}          {/testbench/uKS10/UBA1/devACKO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRI[4]}         {/testbench/uKS10/UBA1/devADDRI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAI[4]}         {/testbench/uKS10/UBA1/devDATAI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[4]}           {/testbench/uKS10/UBA1/devREQO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devACKI[4]}          {/testbench/uKS10/UBA1/devACKI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devADDRO[4]}         {/testbench/uKS10/UBA1/devADDRO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { devDATAO[4]}         {/testbench/uKS10/UBA1/devDATAO[4]}"

WAVE_UBA2 := $(subst UBA1,UBA2,$(WAVE_UBA1))
WAVE_UBA3 := $(subst UBA1,UBA3,$(WAVE_UBA1))
WAVE_UBA4 := $(subst UBA1,UBA4,$(WAVE_UBA1))

WAVE_UBE1 := \
	"add wave -noupdate -divider {UBE1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uUBE1/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uUBE1/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uUBE1/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uUBE1/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uUBE1/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uUBE1/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uUBE1/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uUBE1/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uUBE1/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uUBE1/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uUBE1/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uUBE1/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uUBE1/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devPHYS}              {/testbench/uKS10/uUBE1/devPHYS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uUBE1/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uUBE1/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devVECT}              {/testbench/uKS10/uUBE1/devVECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDEV}               {/testbench/uKS10/uUBE1/devDEV}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDR}              {/testbench/uKS10/uUBE1/devADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devHIBYTE}            {/testbench/uKS10/uUBE1/devHIBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devLOBYTE}            {/testbench/uKS10/uUBE1/devLOBYTE}" \
	"add wave -noupdate -divider {UBE1 SELECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uUBE1/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbREAD}               {/testbench/uKS10/uUBE1/dbREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbWRITE}              {/testbench/uKS10/uUBE1/dbWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ccREAD}               {/testbench/uKS10/uUBE1/ccREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ccWRITE}              {/testbench/uKS10/uUBE1/ccWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {baREAD}               {/testbench/uKS10/uUBE1/baREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {baWRITE}              {/testbench/uKS10/uUBE1/baWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr1READ}             {/testbench/uKS10/uUBE1/csr1READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr1WRITE}            {/testbench/uKS10/uUBE1/csr1WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr2READ}             {/testbench/uKS10/uUBE1/csr2READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr2WRITE}            {/testbench/uKS10/uUBE1/csr2WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clrREAD}              {/testbench/uKS10/uUBE1/clrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clrWRITE}             {/testbench/uKS10/uUBE1/clrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {simgoREAD}            {/testbench/uKS10/uUBE1/simgoREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {simgoWRITE}           {/testbench/uKS10/uUBE1/simgoWRITE}" \
	"add wave -noupdate -divider {UBE1 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regDB}                {/testbench/uKS10/uUBE1/regDB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCC}                {/testbench/uKS10/uUBE1/regCC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regBA}                {/testbench/uKS10/uUBE1/regBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR1}              {/testbench/uKS10/uUBE1/regCSR1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR2}              {/testbench/uKS10/uUBE1/regCSR2}" \
	"add wave -noupdate -divider {State Machine}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeGO}                {/testbench/uKS10/uUBE1/ubeGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeCLR}               {/testbench/uKS10/uUBE1/ubeCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeSIMGO}             {/testbench/uKS10/uUBE1/ubeSIMGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeGOANY}             {/testbench/uKS10/uUBE1/ubeGOANY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeIACK}              {/testbench/uKS10/uUBE1/ubeIACK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uUBE1/state}" \

WAVE_UBE2 := $(subst UBE1,UBE2,$(WAVE_UBE1))
WAVE_UBE3 := $(subst UBE1,UBE3,$(WAVE_UBE1))
WAVE_UBE4 := $(subst UBE1,UBE4,$(WAVE_UBE1))

WAVE_FIRST := \
	"onerror {resume}" \
	"quietly WaveActivateNextPane {} 0 " \
	"view wave" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memRST}               {/testbench/memRST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memCLK}               {/testbench/memCLK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {haltLED}              {/testbench/haltLED}"

WAVE_LAST := \
       "run -a"

#
# DUP11
#

ifeq ($(DIAG),DSDUA)
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU) \
	$(WAVE_DUP11) \
	$(WAVE_LAST)
endif

#
# DZ11
#

ifeq ($(DIAG),DSDZA)
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU) \
	$(WAVE_DZ11) \
	$(WAVE_LAST)
endif

#
# KMC11
#

ifeq ($(DIAG),DSKMA)
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU) \
	$(WAVE_KMC11) \
	$(WAVE_LAST)
endif

#
# DSLPA
#

ifeq ($(DIAG),DSLPA)
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU) \
	$(WAVE_LP20) \
	$(WAVE_LAST)
endif

#
# DSRPA or DSRMA or DSRMB
#

ifeq ($(DIAG),$(filter $(DIAG),DSRPA DSRMA DSRMB))
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU) \
	$(WAVE_RH11A) \
	$(WAVE_RP1) \
	$(WAVE_LAST)
endif

#
# DSTUA or DSTUB
#

ifeq ($(DIAG),$(filter $(DIAG),DSTUA DSTUB))
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU)\
	$(WAVE_RH11B) \
	$(WAVE_MT) \
	$(WAVE_LAST)
endif

#
# DSUBA
#

ifeq ($(DIAG),DSUBA)
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU)\
	$(WAVE_UBA4) \
	$(WAVE_UBE4) \
	$(WAVE_UBE1) \
	$(WAVE_UBE2) \
	$(WAVE_UBE3) \
	$(WAVE_LAST)
endif

#
# Test for $(WAVE_LIST) empty string.
# Use this list is there no special special waveform list for the diagnostic
#

ifeq ($(WAVE_LIST),)
    WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTFC) \
	$(WAVE_CPU) \
	$(WAVE_CSL) \
	$(WAVE_BRKPT) \
	$(WAVE_TRACE) \
	$(WAVE_CPU_NXD) \
	$(WAVE_KS10) \
	$(WAVE_PAGER) \
	$(WAVE_DISPPF) \
	$(WAVE_LAST)
endif

#	$(WAVE_UBA1) \
#	$(WAVE_RH11A) \
#       $(WAVE_RP1) \
# 	$(WAVE_UBA3) \
#	$(WAVE_RH11B) \
#	$(WAVE_MT) \
#	$(WAVE_RP1) \
#	$(WAVE_UBA4) \
#	$(WAVE_UBE2) \
#	$(WAVE_UBE3) \
#	$(WAVE_LP20) \
#	$(WAVE_ARB) \
#	$(WAVE_DZ11) \
#	$(WAVE_DUP11) \
