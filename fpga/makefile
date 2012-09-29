UC  := microcontroller
ALU := alu

SRC := \
	$(ALU)/alu.v \
	$(UC)/crom.vh  \
	$(UC)/crom.v   \
	$(UC)/crom.bin \
	$(UC)/drom.vh  \
	$(UC)/drom.v   \
	$(UC)/drom.bin \
	$(UC)/skip.v   \
	$(UC)/stack.v  \
	$(UC)/dispatch.v   \
	$(UC)/microcontroller.vh \
	$(UC)/microcontroller.v \
	ir.v \
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
	rcsclean $(ALU)/*
	rcsclean $(UC)/*
	rm -f    $(UC)/*.bin
	find . -type f -name "*~" | xargs rm -fv