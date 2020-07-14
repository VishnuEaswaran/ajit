! --------.data-----------------

    .section ".data"! the .data section is used for normal read/write data

! --------.rodata-------------------
! the .rodata section is used for read-only data
    .section ".rodata"

! array_input is a global read-only array
    .global array_input
	.align 4
array_input:
	.word 8			! Number of elements in the array
	.word 1			! First element
	.word 0			! Second element
	.word 1 		! Third element
	.word 0			! Fourth element
	.word 1			! fifth element
	.word 0			! sixth  element
	.word 1			! seventh element
	.word 0			! eighth element

! ---------.bss---------------------
! the .bss section is used for data allocated (as zeroes) at run-time
! data in this section does not occupy space in the ELF file
    .section ".bss"

! heap is a global "bss" integer allocated at run-time
    .global heap 
    .align 4
heap: .skip 256 ! ((8*8)*4) these many bytes

    .global array_output
    .align 4
array_output: .skip 32   ! (8*4) these many bytes
