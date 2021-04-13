MAIN=fft
makeLinkerScript.py -t 0x00000000 -d 0x40000000 -o customLinkerScript.lnk
compileToSparcUclibc.py -N ${MAIN} -s init.s -s trap_handlers.s -s fft.s -s data.s -s divide.s -s main.s -V vmap.txt -o 3 -U  -L customLinkerScript.lnk -D AJIT
