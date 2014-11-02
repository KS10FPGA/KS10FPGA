#!/bin/sh

#
# Script to execute the regressions tests
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
    DSKBA-RD00
    DSKCA
    DSKCB
    DSKCC
    DSKCD
    DSKCE-RD00
    DSKCF-RD00
    DSKDA-RD00
    DSKEA-RD00
    DSUBA-RD00
    DSDZA-RD00
    DSKCG
"

DIR=testsuite
RESFILE=results_`date '+%y%m%d_%H%M'`.txt
PREFIX=MAINDEC-10-

RED='\e[0;31m'
GRN='\e[0;32m'
END='\e[0m'

date "+Testing performed on %a, %b %d %Y." | tee ${RESFILE}
if [ ! -f rtl/testbench/ssram.awk ]; then
    co -q "rtl/testbench/ssram.awk"
fi

date "+[%r] Testing started." | tee -a ${RESFILE}
for FILE in ${FILES}
do
    if [ ! -f rtl/testbench/${PREFIX}${FILE}.SEQ ]; then
        co -q "rtl/testbench/${PREFIX}${FILE}.SEQ"
    fi
    date "+[%r] Testing ${FILE}$" | tr $ \\t | tr -d \\n | expand -t 20 | tee -a ${RESFILE}
    make -B -s DIAG=${FILE} ${DIR}/${FILE}.vvp 2> /dev/null > /dev/null
    RETVAL=$?
    if [ ${RETVAL} -eq 0 ]; then
        vvp -n ${DIR}/${FILE}.vvp > ${DIR}/${FILE}.txt
        if grep -q "Test Completed" ${DIR}/${FILE}.txt; then
            echo -e "${GRN}Test Pass${END}" | tee -a ${RESFILE}
        else
            echo -e "${RED}Test Fail${END}" | tee -a ${RESFILE}
        fi
        tail -n 6 ${DIR}/${FILE}.txt >> ${RESFILE}
    else
        echo -e "${RED}Build Fail${END}" | tee -a ${RESFILE}
    fi
done
date "+[%r] Testing completed." | tee -a ${RESFILE}
