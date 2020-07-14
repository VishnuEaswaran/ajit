! divide and store in heap recursively

    .global divide_store
    .align 4
divide_store:
    save %sp, -96-((8+2)*4) & -8, %sp   ! ((array_size+2empty_elem)*4)bytes 

    clr %g5                 ! count for recursion
    mv %g7, %l7             ! make a copy to local 7
    ld [%l7], %i5           ! n: size of array

    cmp 1, %i5              ! check if n==2
    be return               ! return if n==2
        nop                 ! DELAY SLOT

    udiv %l7, 2, %l6        ! n/2
    sub %l7, %l6, %l5       ! (n - n/2)

    

    clr 
return:     
    ret
    restore

store:
    
