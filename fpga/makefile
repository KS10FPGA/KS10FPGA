UC  := microcontroller

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
	$(UC)/microcontroller.v \
	ac_block.v \
	alu.v \
	apr.v \
	apr_device.v \
	byte_disp.v \
	clkgen.v \
	dbm.v \
	dbus.v \
	flags.v \
	intr.v \
	ir.v \
	ni_disp.v \
	page_tables.v \
	pxct.v \
	ramfile.v \
	scad.v \
	timer.v \
	trap_cycle.v \
	vma.v \
	xr.v \
	ks10.v \
	testbench.v

asdf : $(SRC)
	echo $(SRC)

$(UC)/crom.bin : $(UC)/ks10.mcr $(UC)/crom.awk makefile
	awk -f $(UC)/crom.awk $(UC)/ks10.mcr > $(UC)/crom.bin

$(UC)/drom.bin : $(UC)/ks10.mcr $(UC)/drom.awk makefile
	awk -f $(UC)/drom.awk $(UC)/ks10.mcr > $(UC)/drom.bin

clean: 
	rcsclean *
	rcsclean $(UC)/*
	rm -f    $(UC)/*.bin
	find . -type f -name "*~" | xargs rm -fv

archive_src: $(SRC)
	tar -czvf ks10_src_`date '+%y%m%d'`.tgz $(SRC)

archive_all:
	tar -czvf ks10_all_`date '+%y%m%d'`.tgz *