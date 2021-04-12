#! /bin/sh
sftp -in -q root@192.168.7.1 <<EOF
get makefile
get main.cpp
get cmdline.hpp
get cmdline.cpp
get commands.hpp
get commands.cpp
get config.hpp
get config.cpp
get cursor.hpp
get cursor.cpp
get dasm.hpp
get dasm.cpp
get dz11.hpp
get dz11.cpp
get hist.hpp
get hist.cpp
get ks10.hpp
get ks10.cpp
get lp20.hpp
get lp20.cpp
get rh11.hpp
get rh11.cpp
get uba.hpp
get vt100.hpp
bye
EOF