TAPEFILE  := CRAM4K_Microcode.tap
T10BACKUP := ../../tools/tapeutils/t10backup

MICS      := extend.mic flt.mic inout.mic ks10.mic pagef.mic simple.mic smfile.mic
CMDS      := ks10.cmd
CRAM4K    := cram4k.cmd cram4k.mic cram4k.mcr cram4k.ram cram4k.uld
T10KI     :=  t10ki.cmd  t10ki.mic  t10ki.mcr t10ki.ram  t10ki.uld
T10KL     :=  t10kl.cmd  t10kl.mic  t10kl.mcr  t10kl.ram  t10kl.uld

all : $(MICS) $(CMDS) $(CRAM4K) $(T10KI) $(T10KL)

$(TAPEFILE) : $(TAPEFILE).gz
	gunzip -c $< > $@

tapedir : $(TAPEFILE)
	$(T10BACKUP) -t -f $(TAPEFILE)

extend.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

flt.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

inout.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

ks10.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

pagef.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

simple.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

smfile.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

ks10.cmd : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

#
# CRAM4K
#

cram4k.cmd : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

cram4k.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

cram4k.mcr : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

cram4k.ram : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

cram4k.uld : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

#
# T10KI
#

t10ki.cmd : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10ki.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10ki.mcr : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10ki.ram : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10ki.uld : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

#
# T10KL
#

t10kl.cmd : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10kl.mic : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10kl.mcr : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10kl.ram : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

t10kl.uld : $(TAPEFILE)
	$(T10BACKUP) -x $@ -f $(TAPEFILE)

#
# Clean
#

clean :
	rm -f *~ .*~
	rm -f $(TAPEFILE)
	rm -f $(MICS) $(CMDS) $(CRAM4K) $(T10KI) $(T10KL)

#ks10.chk
#ks10.cmd
#ks10.ctl
#ks10.doc
#ks10.bak
#ks10.ram
#ks10.rnd
#ks10.uld
#ks124.txt
#micro.exe
#micro.mac
#smfile.cmd
#t10ki.cmd
#t10ki.mcr
#t10ki.mic
#t10ki.ram
#t10ki.uld
#t10kl.cmd
#t10kl.mcr
#t10kl.mic
#t10kl.ram
#t10kl.uld
#ucodes.ctl
#ucodes.log
#pagef.bak
#ks10.etf


