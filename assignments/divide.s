! divide and store in heap 

    .global divide_store
    .align 4
divide_store:
    ! incoming
    ! i5 size of the array
    ! i4 base address of first element
    ! i3 base address of current empty point of heap
    ! i2 count of recursion
    
    save %sp, -96-((8+2)*4) & -8, %sp   ! ((array_size+2empty_elem)*4)bytes 
    cmp %i5, 1              ! check if n==2
    be return               ! return if n==2
        nop                 ! DELAY SLOT

    udiv %i5, 2, %l7        ! n/2 in l7
    
    ! for loop
    ba test
        clr %l6             ! loop counter initialised
loop:
    ! get elements from passed on array
    ! copy them to corresponding even & odd arrays
    
    smul 4, %l6, %l5        ! (4 * i) stored to l5

    !even
    smul 2, %l5, %l4        ! (2*i)*4 stored to l4
    ld [%i4+%l4], %l3       ! loaded array_input(i*2) to l3
    st %l3, [%i3+%l4]       ! array_input(i*4) stored to heap(i)

    !odd
    add 4, %l4, %l2         ! ((2*i) + 1)*4 stored in l2
    ld [%i4+%l2], %l2       ! loaded array_input((2*i)+1) to l2
    smul 4, %g5, %l3        ! since odd starts 4 elements from heap, 4*4 stored in l3
    add %i3, %l3, %l3       ! store heap+4 in l3
    st %l2, [%l3+%l5]       ! store odd element from l2 to (heap+4+i)th memory

    inc %l6                 ! l6++

test:
    cmp %l6, %l7            ! check i<(n/2)
    bl loop
        nop   

return:     
    ! return values: size, current heap base address, next empty heap address
    ! return values when cwp+1; in --> out
    mov %l7, %i5            ! size of the array
    mov %i3, %i4            ! current base address of heap. even and odd can be
                            ! accessed by knowing this
    add 32, %i3, %i3        ! added 8*4 bytes to current heap address for next
                            ! empty heap
    ret
    restore
