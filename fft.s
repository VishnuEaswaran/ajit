! Used for twiddle factor and fft calculations 
!

.section ".data"! for calculations of twiddle factor
.align 4
w20: .word 1
w21: .word 0xbf800000  !-1 = 0xbf800000 
w40: .word 1
w41_R: .word 0
w41_I: .word 0xbf800000 !-j
w80: .word 1 !
w81_R: .word 0x3f34fdf4 ! +0.707 in float as HEX
w81_I: .word 0xbf34fdf4 ! -0.707 in float as HEX
w82: .word 0xbf800000 !-1
w83_I: .word 0x3f34fdf4 ! +0.707 in float as HEX
w83_R:.word 0xbf34fdf4 ! -0.707 in float as HEX

.section ".data"
.align 4
.global
PI:
.single 3.14159265358979323846

.section ".text"
! Load PI to %f8
	set PI, %o1 
	ld [%o1], %f8
	set w20, %o2
	ld [%o2], %g4
	fitos %g4, %f31 ! w20 stored in f31 register
	
	! -----------------------------------------------
	! Set constant "2" to %f7 through memory
	set 2, %i5
  	set 4, %i4
  	set 3, %i3


.stage1:
! F(0) = x(0) + w20*x(1)
	ld [%i4], %g4
	ld [%i4+4], %g5
	fmuls %f31, %g5, %f31 
	fstoi %f31, %g5
	add %g4, %g5, %g4
! F(1) = x(0) - w20*x(1)

.stage2:


.stage3:
		
.fft_main:

!!!! For PI/2
	st %i5, [%fp-16]
	ld [%fp-16], %f7  ! f7,f8 has 2
	fitos %f7, %f7 			! Convert integer value "2" to floating point representation
	fdivs %f8, %f7, %f8 	! %f8 = PI / 2

  fstod	%f8, %f8 		! Convert single precison to double precision as required for sin function
	std	%f8, [%fp-8] 		! Store this double word to memory
	ldd	[%fp-8], %o0 		! Load that double word in Windowed register as required by sin function


  	call sin, 0 
  	call cos, 0
	nop

	fmovs	%f0, %f8 	! To transfer a multiple-precision value between f registers,  contains half
	fmovs	%f1, %f9 	! one FMOVs instruction is required per word to be transferred.
	fdtos	%f8, %f8
	fstoi	%f8, %f10

!!!! For PI/4

	st %i4, [%fp-32]    !f9, f10 will have 3
	ld [%fp-32], %f11
	fitos %f11, %f11 			! Convert integer value "4" to floating point representation
	fdivs %f12, %f11, %f12 	! %f12 = PI / 4

  fstod	%f12, %f12 		! Convert single precison to double precision as required for sin function
	std	%f12, [%fp-24]   		! Store this double word to memory
	ldd	[%fp-24], %o1 		! Load that double word in Windowed register as required by sin function

  call sin, 0
  call cos, 0
	nop

	fmovs	%f0, %f11 	! To transfer a multiple-precision value between f registers, 
	fmovs	%f1, %f12 	! one FMOVs instruction is required per word to be transferred.

	fdtos	%f12, %f12  !???
	fstoi	%f12, %f14  !???


!!!! For 3PI/4

	st %i3, [%fp-48]
	ld [%fp-48], %f15
	fitos %f15, %f15 			! Convert integer value "3" to floating point representation
	fmuls %f15, %f12, %f15 	! multiply 3(floating) with pi/4(floating)

  	fstod	%f15, %f15 		! Convert single precison to double precision as required for sinfunction
	std	%f15, [%fp-24]   		! Store this double word to memory
	ldd	[%fp-40], %o2 		! Load that double word in Windowed register as required by sin function

  call sin, 0
  call cos, 0
	nop


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	fstod	%f8, %f8 		! Convert single precison to double precision as required for sin function
	std	%f8, [%fp-8] 		! Store this double word to memory
	ldd	[%fp-8], %o0 		! Load that double word in Windowed register as required by sin function






