
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

archive_all:
	tar -czvf ks10_all_`date '+%y%m%d'`.tgz ../ks10/fpga ../ks10/code 

archive_dist:
	tar --exclude-vcs -czvf ks10_dist_`date '+%y%m%d'`.tgz ../ks10/fpga ../ks10/code
