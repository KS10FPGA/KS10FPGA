ARB := arb
CON := con
CPU := cpu
MEM := mem
UBA := uba
UC  := $(CPU)/useq

SRC := \
	$(UC)/crom.vh  \
	$(UC)/crom.v   \
	$(UC)/crom.bin \
	$(UC)/drom.vh  \
	$(UC)/drom.v   \
	$(UC)/drom.bin \
	$(UC)/skip.v   \
	$(UC)/stack.v  \
	$(UC)/dispatch.v   \
	$(UC)/useq.v \
	$(CPU)/ac_block.v \
	$(CPU)/alu.v \
	$(CPU)/apr.v \
	$(CPU)/bus.v \
	$(CPU)/byte_disp.v \
	$(CPU)/cache.v \
	$(CPU)/clkgen.v \
	$(CPU)/dbm.v \
	$(CPU)/dbus.v \
	$(CPU)/intr.v \
	$(CPU)/iolatch.v \
	$(CPU)/ni_disp.v \
	$(CPU)/page_tables.v \
	$(CPU)/pcflags.v \
	$(CPU)/pxct.v \
	$(CPU)/ram1kx36.v \
	$(CPU)/ramfile.v \
	$(CPU)/regIR.v \
	$(CPU)/scad.v \
	$(CPU)/timer.v \
	$(CPU)/traps.v \
	$(CPU)/vma.v \
	$(CPU)/cpu.v \
	$(MEM)/mem.v \
	$(ARB)/arb.v \
	$(UBA)/uba.v \
	ks10.v \
	ks10.ucf \
	testbench.v

asdf : $(SRC)
	echo $(SRC)

$(UC)/crom.bin : $(UC)/ks10.mcr $(UC)/crom.awk makefile
	awk -f $(UC)/crom.awk $(UC)/ks10.mcr > $(UC)/crom.bin

$(UC)/drom.bin : $(UC)/ks10.mcr $(UC)/drom.awk makefile
	awk -f $(UC)/drom.awk $(UC)/ks10.mcr > $(UC)/drom.bin

clean: 
	rcsclean *
	rcsclean $(ARB)/*
	rcsclean $(CON)/*
	rcsclean $(CPU)/*
	rcsclean $(MEM)/*
	rcsclean $(UBA)/*
	rcsclean $(UC)/*
	rm -f    $(UC)/*.bin
	find . -type f -name "*~" | xargs rm -fv

archive_src: $(SRC)
	tar -czvf ks10_src_`date '+%y%m%d'`.tgz $(SRC)

archive_all:
	tar -czvf ks10_all_`date '+%y%m%d'`.tgz *