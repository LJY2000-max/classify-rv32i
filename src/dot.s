.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         
    li t2, 0

    # Change to stride*4
    slli a3, a3, 2
    slli a4, a4, 2

    li t0, 0
loop_start:
    li t4, 0
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    # Load number from memory
    lw t1, 0(a0)
    lw t2, 0(a1)
    li t3, 0
    beq t1, zero, end_mul
    bge t1, zero, checkt2
    sub t1, zero, t1
    addi t3, t3, 1
    checkt2:
    bge t2, zero, multiply
    sub t2, zero, t2
    addi t3, t3, -1
    
    multiply:
    add t4, t4, t2
    addi t1, t1, -1
    bgt t1, zero, multiply
    beq t3, zero, end_mul
    sub t4, zero, t4
    
    end_mul:
    add t0, t0, t4
    addi a2, a2, -1
    add a0, a0, a3
    add a1, a1, a4
    bne a2, zero, loop_start
loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
