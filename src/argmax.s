.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    # Check array_length ≥ 1
    li t6, 1
    blt a1, t6, handle_error

    # Load number from memory
    lw t0, 0(a0)

    #li t1, 0
    #li t2, 1

    # Count array index
    li t1, 0
    li t2, 0
loop_start:
    # TODO: Add your own implementation
    # Load number from memory
    lw t3, 0(a0)

    bge t0, t3, loop_end

    # Update the max value
    addi t0, t3, 0
    # Update the argmax
    addi t1, t2, 0
loop_end:
    # Circular variables minus 1
    addi a1, a1, -1
    # Address of next array number
    addi a0, a0, 4
    # Array index plus 1
    addi t2, t2, 1
    bne zero, a1, loop_start
    # return the argmax
    addi a0, t1, 0
    jr ra
handle_error:
    li a0, 36
    j exit
