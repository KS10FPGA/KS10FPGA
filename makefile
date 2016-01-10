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
	--exclude ks10/fpga/esm_top/ise/isim/* \
	--exclude ks10/fpga/esm_top/ise/*.wdb \
	--exclude ks10/fpga/esm_top/testbench/*.dsk \
	--exclude ks10/fpga/esm_top/testbench/*.rp06 \
	--exclude ks10/fpga/esm_top/testbench/RCS/*.dsk,v \
	--exclude ks10/fpga/esm_top/testbench/RCS/*.rp06,v \
	--exclude ks10/fpga/results/*

all:
	${MAKE} -C code console.bin
	${MAKE} -C fpga ise/esm_ks10.mcs

clean:
	${MAKE} -C fpga clean
	${MAKE} -C code clean

rcsclean:
	${MAKE} -C fpga rcsclean
	${MAKE} -C code rcsclean

rcsfetch:
	${MAKE} -C fpga rcsfetch
	${MAKE} -C code rcsfetch

loadcode:
	${MAKE} -C code load

loadfpga:
	${MAKE} -C fpga load

loadall: loadcode loadfpga

reset:
	${MAKE} -C code reset

isim:
	${MAKE} -C fpga isim

archive_all:
	tar $(ARGS) -czvf ks10_all_`date '+%y%m%d'`.tgz $(ALL_LIST)

archive_fpga:
	tar $(ARGS) -czvf ks10_fpga_`date '+%y%m%d'`.tgz $(FPGA_LIST)

archive_dist:
	tar $(ARGS) --exclude-vcs -czvf ks10_dist_`date '+%y%m%d'`.tgz $(FPGA_LIST)
