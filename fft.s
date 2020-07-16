! Used for twiddle factor and fft calculations 
!

.section ".data"! for calculations of twiddle factor
.global Nvar
.align 4
w20: .word 1
w40: .word 1
w80: .word 1

.section ".data"
.align 4
.global
PI:
.single 3.14159265358979323846

! Load PI to %f8
	set PI, %o1 
	ld [%o1], %f8 
! -----------------------------------------------
	! Set constant "2" to %f7 through memory
	set 2, %i5
  set 4, %i4
  set 3, %i3

!!!! For PI/2
	st %i5, [%fp-16]
	ld [%fp-16], %f7  ! f7,f8 has 2
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

!!!! For PI/4

	st %i4, [%fp-32]    !f9, f10 will have 3
	ld [%fp-32], %f11
	fitos %f11, %f11 			! Convert integer value "4" to floating point representation
	fdivs %f12, %f11, %f12 	! %f12 = PI / 4

  fstod	%f12, %f12 		! Convert single precison to double precision as required for sin function
	std	%f12, [%fp-24]   		! Store this double word to memory
	ldd	[%fp-24], %o1 		! Load that double word in Windowed register as required by sin function

  call sin, 0
	nop

	fmovs	%f0, %f11 	! To transfer a multiple-precision value between f registers, 
	fmovs	%f1, %f12 	! one FMOVs instruction is required per word to be transferred.

	fdtos	%f12, %f12  !???
	fstoi	%f12, %f14  !???


!!!! For 3PI/4

	st %i3, [%fp-32]
	ld [%fp-32], %f7
	fitos %f7, %f7 			! Convert integer value "2" to floating point representation
	fdivs %f8, %f7, %f8 	! %f8 = PI / 2

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	fstod	%f8, %f8 		! Convert single precison to double precision as required for sin function
	std	%f8, [%fp-8] 		! Store this double word to memory
	ldd	[%fp-8], %o0 		! Load that double word in Windowed register as required by sin function




twiddle:
