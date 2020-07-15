! main function
! the execution starts from here after init.s

    .global main
main:
    save %sp, -96-((8+2)*4) & -8, %sp   ! ((array_size+2empty_elem)*4)bytes 
                                        ! + 96 default bytes
    set array_input, %g7    ! g7 --> pointer to input; globally stored
    set heap, %g6           ! g6 --> pointer to heap
    mov 4, %g5              ! constant 4 for traversing memory 4 at a time

    ! initial values for first call
    clr %g5                 ! count for recursion
    mov %g7, %o4            ! make a copy to l7
    ld [%o4], %o5           ! n: size of array
    add %g5, %o4, %o4       ! go to first array element
    mov %g6, %o3

fft_main:

    call divide_store
        nop                 ! DELAY SLOT

    ! even recursion
    call fft_main
        nop
    ! odd recursion
    add  16, %o4, %o4       ! move ahead by 4 elements
    call fft_main
        nop

    !call complex            ! call complex multiplication
        nop
    
    ret                     ! jumpl %i7+8, %g0
    restore                 ! restore %g0, %g0, %go
