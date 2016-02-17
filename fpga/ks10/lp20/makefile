
V_FILES := \
	lpcsra.v lpcsrb.v lpbar.v lpbctr.v lppctr.v lpcksm.v \
	lpctrl.v lp20.v \

VH_FILES := \
	lpcsra.vh lpcsrb.vh lpbar.vh lpbctr.vh lppctr.vh lpcksm.vh  \
	lpramd.vh lpcbuf.vh \
	lp20.vh

asdf: $(V_FILES) $(VH_FILES)
	iverilog $(V_FILES)

clean:
	rcsclean *
	rm -rf a.out