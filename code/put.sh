#! /bin/sh
sftp -in -q root@192.168.7.1 <<EOF
put makefile
put main.cpp
put cmdline.hpp
put cmdline.cpp
put commands.hpp
put commands.cpp
put config.hpp
put config.cpp
put cursor.hpp
put cursor.cpp
put dasm.hpp
put dasm.cpp
put dz11.hpp
put dz11.cpp
put hist.hpp
put hist.cpp
put ks10.hpp
put ks10.cpp
put lp20.hpp
put lp20.cpp
put prompt.hpp
put rh11.hpp
put rh11.cpp
put uba.hpp
put vt100.hpp
bye
EOF