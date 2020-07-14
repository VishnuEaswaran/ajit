! divide and store in heap recursively

    .global divide_store
    .align 4
divide_store:
    clr %g5                 ! count for recursion
    mv %g7, %l7             ! make a copy to l7
    ld [%l7], %i5           ! n: size of array
    add %g5, %l7             ! go to first array element
    
recurse:
    save %sp, -96-((8+2)*4) & -8, %sp   ! ((array_size+2empty_elem)*4)bytes 
    cmp 1, %i5              ! check if n==2
    be return               ! return if n==2
        nop                 ! DELAY SLOT

    udiv %i5, 2, %l6        ! n/2 in l6
    
    ! for loop
    ba test
        clr %l5             ! loop counter initialised
loop:
    ! get elements from array_input
    ! copy them to sorresponding arrays
    
    smul %g5, %l5, %l4        ! (4 * i) stored to l4

    !even
    smul 2, %l4, %l3        ! (2*i)*4 stored to l4
    ld [%g7+%l3], %l2       ! loaded array_input(i*2) to l4
    st %l2, [%g6+%l4]       ! array_input(i*4) stored to heap(i)

    !odd
    add %g5, %l3, %l2       ! ((2*i) + 1)*4 stored in l2
    ld [%g7+%l2], %l2       ! loaded array_input((2*i)+1) to l2
    smul 4, %g5, %l3        ! since odd starts 4 elements from heap, 4*4 stored in l3
    add %l4, %l3            ! store ((heap+4)+i)4
    st %l2, [%g6+%l3]

    inc %l5                 ! l5++

test:
    cmp %l5, %l6            ! check i<(n/2)
    bl loop
        nop    

    ba recurse
        

return:     
    ret
    restore
