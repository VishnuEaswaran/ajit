.section .text.ajitstart
.global _start;
_start:
	set -96, %sp
	clr %fp

	set 0x1, %l0		! window 0 is marked invalid...  we start at window 7
	wr %l0, 0x0, %wim	!

	! trap table.
	set	trap_table_base, %l0
	wr	%l0, 0x0, %tbr

	! set up virtual -> physical map.
	call page_table_setup 	
	nop

	call set_context_table_pointer 	
	nop

	! enable traps.
	set 0x10E7, %l0
	wr %l0, %psr

  	! enable mmu.
	set 0x1, %o0
	sta %o0, [%g0] 0x4    

	! Load PI to %f8
	set PI, %o1 
	ld [%o1], %f8 

	! Set constant "2" to %f7 through memory
	set 2, %i5
	st %i5, [%fp-16]
	ld [%fp-16], %f7

	fitos %f7, %f7 			! Convert integer value "2" to floating point representation

	fdivs %f8, %f7, %f8 	! %f8 = PI / 2


	fstod	%f8, %f8 		! Convert single precison to double precision as required for sin function
	std	%f8, [%fp-8] 		! Store this double word to memory
	ldd	[%fp-8], %o0 		! Load that double word in Windowed register as required by sin function

	call sin, 0
	nop

	fmovs	%f0, %f8 	! To transfer a multiple-precision value between f registers, 
	fmovs	%f1, %f9 	! one FMOVs instruction is required per word to be transferred.

	fdtos	%f8, %f8
	fstoi	%f8, %f10

	! Instructions involving "Double" works only with even valued registers.
	! Example: In following data section, if PI is declared as ".double" then it cannot be loaded in 
	!          %f1, %f3, %f5, %f7, ..., %f31

	restore
	ta 0



.section ".data"
.align 4
.global
PI:
.single 3.14159265358979323846
