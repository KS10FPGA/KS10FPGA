#!/bin/bash

#
# Script to execute the regressions tests
#
# Usage:
#   ./testsuite.sh              Run all of the tests listed below
#   ./testsuite.sh DSKAA DSKAB  Run only the named tests
#   SIM=iverilog ./testsuite.sh Use Icarus Verilog instead of QuestaSim
#
# Each test is built and simulated (batch mode) by the Makefile target
# testsuite/<DIAG>.txt.  The make output for each test is saved in
# testsuite/<DIAG>.build.log so build failures can be diagnosed.
#

FILES="\
    DSKAA
    DSKAB
    DSKAC
    DSKAD
    DSKAE
    DSKAF
    DSKAG
    DSKAH
    DSKAI
    DSKAJ
    DSKAK
    DSKAL
    DSKAM
    DSKCA
    DSKCB
    DSKCC
    DSKCD
    DSKCE
    DSKCF
    DSKDA
    DSKEA
    DSKEB
    DSKEC
    DSKFA
    DSUBA
    DSDZA
    DSRPA
    DSMMA
    DSMMB
    DSMMC
    DSMMD
    DSKCG
"

if [ $# -gt 0 ]; then
    FILES="$*"
fi

DIR=testsuite
RESFILE=results_`date '+%y%m%d_%H%M'`.txt

RED='\e[0;31m'
GRN='\e[0;32m'
END='\e[0m'

mkdir -p ${DIR}

date "+Testing performed on %a, %b %d %Y." | tee ${RESFILE}
date "+[%r] Testing started." | tee -a ${RESFILE}
for FILE in ${FILES}
do
    date "+[%r] Testing ${FILE}$" | tr $ \\t | tr -d \\n | expand -t 20 | tee -a ${RESFILE}
    rm -f ${DIR}/${FILE}.txt
    make -s DIAG=${FILE} ${DIR}/${FILE}.txt > ${DIR}/${FILE}.build.log 2>&1
    RETVAL=$?
    if [ ${RETVAL} -eq 0 ]; then
        if grep -q "Test Completed" ${DIR}/${FILE}.txt; then
            echo -e "${GRN}Test Pass${END}" | tee -a ${RESFILE}
        else
            echo -e "${RED}Test Fail${END}" | tee -a ${RESFILE}
        fi
        tail -n 6 ${DIR}/${FILE}.txt >> ${RESFILE}
    else
        echo -e "${RED}Build Fail${END} (see ${DIR}/${FILE}.build.log)" | tee -a ${RESFILE}
    fi
done
date "+[%r] Testing completed." | tee -a ${RESFILE}
