!file to for FFT calculations
!Data to be read from Heap
!For FFT calculations and 

.section ".data"
.global twiddle !predefined twiddle values[doesnt make much sense tbh]
.align 4
twiddle:
w20: .word -1
w40: .word 1
w41: .word -j
w80: .word -1
w81: .word 
w82: .word -j
w83: 
!! OR 
.section ".data"! for calculations of twiddle factor
.global Nvar
.align 4
n1: .word 0
n2: .word 1
n3: .word 2
n4: .word 3
n5: .word 4
n6: .word 5
n7: .word 6
n8: .word 7

twiddle1:
set 2.73, %f1, %f2 ! e as a double stored in 2 regs
set 3.1415, %f4, %f5! PI as a double stored in 2 regs
		!fdtoi %f1, %f3 !convert e into integer form
		!fdtoi %f4, %f6 !convert pi into integer form

set 2, %g3 ! set 2 in g3
ld [%g3], %f6 !load 2 in f6 reg
fmul  %f4, %f6,%f7 !store product of 2 and pi in f7

