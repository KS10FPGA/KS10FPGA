FPGA_LIST := \
	ks10/fpga \
	ks10/code \
	ks10/makefile

ALL_LIST := \
	ks10/fpga \
	ks10/code \
	ks10/makefile \
	ks10/doc/Manual \
	ks10/doc/Website 

ARGS :=\
	--directory=.. \
	--exclude ks10/fpga/ise/isim/* \
	--exclude ks10/fpga/ise/*.wdb

all:
	make -C code console.bin
	make -C fpga ise/esm_ks10.mcs

clean:
	make -C fpga clean
	make -C code clean

rcsclean:
	make -C fpga rcsclean
	make -C code rcsclean

rcsfetch:
	make -C fpga rcsfetch
	make -C code rcsfetch

loadcode:
	make -C code load

loadfpga:
	make -C fpga load

loadall: loadcode loadfpga

reset:
	make -C code reset

isim:
	make -C fpga isim

archive_all:
	tar $(ARGS) -czvf ks10_all_`date '+%y%m%d'`.tgz $(ALL_LIST)

archive_fpga:
	tar $(ARGS) -czvf ks10_fpga_`date '+%y%m%d'`.tgz $(FPGA_LIST)

archive_dist:
	tar $(ARGS) --exclude-vcs -czvf ks10_dist_`date '+%y%m%d'`.tgz $(FPGA_LIST)
