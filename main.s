! main function
! the execution starts from here after init.s

    .global main
main:
    save %sp, -96-((8+2)*4) & -8, %sp   ! ((array_size+2empty_elem)*4)bytes 
                                        ! + 96 default bytes
    set array_input, %g7    ! g7 --> pointer to input; globally stored
    set heap, %g6           ! g6 --> pointer to heap
    mov 4, %g5              ! constant 4 for traversing memory 4 at a time

    ld [%g7], 
recurse:

   call divide_store
        nop                 ! DELAY SLOT

   call complex             ! call complex multiplication
        nop
    
    ret                     ! jumpl %i7+8, %g0
    restore                 ! restore %g0, %g0, %go
