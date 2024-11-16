# Assignment 2: Classify

TODO: Add your own descriptions here.
# Assignment2: Complete Applications


<details>
  <summary>Odd Content</summary>
    
## Part A (Mathematical Functions)
### Task 1 (ReLU)
```RISC-V=
#--------------------ReLU function--------------------#
#a0: array address
#a1: array_length
ReLU:
    # check array_length ≥ 1
    li t0, 1
    blt a1, t0, ReLU_error
ReLU_abs:
    # load number from memory
    lw t0, 0(a0)
    bge t0, zero, ReLU_done


    # store number back to memory
    sw zero, 0(a0)

    # loop condition -1 and set next index
ReLU_done:
    addi a1, a1, -1
    addi a0, a0, 4
    bne zero, a1, ReLU_abs
    jr ra
ReLU_error:
    li a0, 36
    jr ra
#-----------------------------------------------------#
```

### Task 2 (ArgMax)
```RISC-V=
#-------------------ArgMax function-------------------#
#a0: array address
#a1: array length
ArgMax:
    # check array_length ≥ 1
    li t0, 1
    blt a1, t0, ReLU_error

    # load number from memory
    lw t0, 0(a0)
    # load array address form memory
    add t3, zero, a0
ArgMax_loop:
    # Load number from memory
    lw t2, 0(t3)
    bge t0, t2, ArgMax_done
    # load array address form memory
    add a0, zero, t3
    # update the max value
    add t0, zero, t2
ArgMax_done:
    addi a1, a1, -1
    addi t3, t3, 4
    bne zero, a1, ArgMax_loop
    jr ra
ArgMax_error:
    li a0, 36
    jr ra
#-----------------------------------------------------#
```

### Task 3.1 (Dot Product)

```RISC-V=
#-----------------DotProduct function-----------------#
#a0: array1 address
#a1: array2 address
#a2: calculation_element
#a3: array1_stride
#a4: array2_stride
DotProduct:
    # store temp reg.
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    addi s0, zero, 0
    

    # check calculation_element ≥ 1
    li t0, 1
    blt a2, t0, DotProduct_error_element
    # check array_stride ≥ 1
    blt a3, t0, DotProduct_error_stride
    blt a4, t0, DotProduct_error_stride

    # change to stride*4
    slli a3, a3, 2
    slli a4, a4, 2
DotProduct_loop:
    # load number from memory
    lw t0, 0(a0)
    lw t1, 0(a1)
    mul s1, t0, t1
    add s0, s0, s1
DotProduct_done:
    addi a2, a2, -1
    add a0, a0, a3
    add a1, a1, a4
    bne zero, a2, DotProduct_loop
    addi a0, s0, 0

    # restore temp reg.
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

    jr ra
DotProduct_error_element:
    li a0, 36
    jr ra
DotProduct_error_stride:
    li a0, 37
    jr ra
#-----------------------------------------------------#
```

### Task 3.2 (Matrix Multiplication)
```RISC-V=
#------------MatrixMultiplication function------------#
#a0: matrix1 address
#a1: matrix1_row
#a2: matrix1_col
#a3: matrix2 address
#a4: matrix2_row
#a5: matrix2_col
#a6: matrix3 address
MatrixMultiplication:
    # check any matrix row and col is higher than 1
    bge zero, a1, MatrixMultiplication_error_negtiveRowOrCol
    bge zero, a2, MatrixMultiplication_error_negtiveRowOrCol
    bge zero, a4, MatrixMultiplication_error_negtiveRowOrCol
    bge zero, a5, MatrixMultiplication_error_negtiveRowOrCol
    # check matrix1's col match matrix2's row
    bne a2, a4, MatrixMultiplication_error_MatrixSizeNotMatch
    addi t0, a5, 0 # outer loop variable
    addi t2, a0, 0
MatrixMultiplication_outer_loop:
    addi t1, a1, 0 # inner loop variable
    addi a0, t2, 0 
    MatrixMultiplication_inner_loop:
        # store argument
        addi sp, sp, -44
        sw ra, 0(sp)
        sw a0, 4(sp)
        sw a1, 8(sp)
        sw a2, 12(sp)
        sw a3, 16(sp)
        sw a4, 20(sp)
        sw a5, 24(sp)
        sw a6, 28(sp)
        sw t0, 32(sp)
        sw t1, 36(sp)
        sw t2, 40(sp)

        # a0 don't change 、matrix1 address
        addi t3, a1, 0    
        addi a1, a3, 0   # matrix2 address
        # a2 don't change 、calculation_element
        addi a3, t3, 0   # array1_stride
        addi a4, zero, 1 # array2_stride
        jal DotProduct
        addi t3, a0, 0   # store a0 which is return from Dot Product


        # restore argument
        lw ra, 0(sp)
        lw a0, 4(sp)
        lw a1, 8(sp)
        lw a2, 12(sp)
        lw a3, 16(sp)
        lw a4, 20(sp)
        lw a5, 24(sp)
        lw a6, 28(sp)
        lw t0, 32(sp)
        lw t1, 36(sp)
        lw t2, 40(sp)
        addi sp, sp, 44

        addi t1, t1, -1 # inner_loop variable -1
        sw t3, 0(a6)
        addi a6, a6, 4
        addi a0, a0, 4
        bne t1, zero, MatrixMultiplication_inner_loop
    
    slli a4, a4, 2
    add a3, a3, a4
    srli a4, a4, 2
    addi t0, t0, -1 # outter_loo variable -1
    bne t0, zero, MatrixMultiplication_outer_loop
MatrixMultiplication_done:
    jr ra
MatrixMultiplication_error_negtiveRowOrCol:
    li a0, 36
    jr ra
MatrixMultiplication_error_MatrixSizeNotMatch:
    li a0, 4
    jr ra
#-----------------------------------------------------#
```
</details>

## Recording what I change.
### Initial 
After forking the [GitHub repository](https://github.com/sysprog21/classify-rv32i) to my own GitHub account, I cloned it to my local machine. Upon running the ./test.sh all command for the first time, the following output appeared, as shown in the image. The output indicates which tests passed and which tests failed. Out of a total of 46 test cases, 34 were marked as FAIL (failed to pass).

![1](https://hackmd.io/_uploads/r1-ImeRWkl.png)

### abs.s
In the initial version of the abs.s file, the program only checked whether the input value in t0 was negative, without performing the actual absolute value operation. When the bge instruction determined that t0 was negative, it would not branch to done. To address this, I added the instruction ```sub t0, x0, t0``` after bge, which converts the negative value in t0 to its positive equivalent. Additionally, the instruction ```sw t0, 0(a0)``` was included to store the updated value of t0 back into memory.


![2](https://hackmd.io/_uploads/Bk27pxTWyg.png)

After making the modifications, we ran the tests again and observed that test_abs_minus_one successfully passed.

![3](https://hackmd.io/_uploads/H1wfmlAbye.png)

### argmax.s
In the initial version of the argmax.s file, the program only checked whether the array length was greater than 1. I modified the code to use t0 to store the current maximum value of the array and t3 to store the current array value. The program compares whether t0 is less than t3. If the condition is true, it proceeds to the next iteration, where t3 reads the next array value. If the condition is false, t0 is updated to the value of t3, and the current index of the argmax is stored in t1. After the loop ends, the return value is set using ```addi a0, t1, 0```.

![4](https://hackmd.io/_uploads/r1_nUeCZJg.png)

After making the modifications, we ran the tests again and observed that both test_argmax_length_1 and test_argmax_standard successfully passed.

![5](https://hackmd.io/_uploads/r1rhYeCbye.png)

### dot.s
In the initial version of the dot.s file, the program only checked whether the element count and the strides of the two arrays were positive. I used t0 to store the result of element-wise multiplication, t1 to store the elements of the first array, and t2 to store the elements of the second array. To handle strides (a3 and a4), I left-shifted their values by two bits so that moving to the next array element could be achieved by directly adding a3 or a4 to the address. However, due to the constraints of only using the RV32I instruction set, the mul instruction could not be directly utilized. Instead, I implemented multiplication using an accumulation method: treating the multiplier (t1) as the loop counter and the multiplicand (t2) as the value to accumulate. In each loop iteration, the value of t2 was added to t0, and the process continued until the loop completed.

![6](https://hackmd.io/_uploads/B1mI2bC-1x.png)

After making the modifications, we ran the tests again and observed that test_dot_length_1, test_dot_standard, and test_dot all successfully passed.

![7](https://hackmd.io/_uploads/rklbcbRZ1l.png)

### relu.s
In the initial version of the relu.s file, the program only checked whether the array length was less than 1. I modified the code to use t0 to access the array elements and added logic to check whether t0 is negative. If an element is negative, the program sets it to 0.

![8](https://hackmd.io/_uploads/HkSAIGC-ye.png)

After applying the modifications, we ran the tests again and observed that both test_relu_length_1 and test_relu_standard passed successfully.

![9](https://hackmd.io/_uploads/r16s8zRWJx.png)

### matmul.s
When I first opened the initial version of matmul.s, I found myself at a loss on where to begin. My initial assumption was that the matrix was stored in a column-major format because, prior to this major update, I had already written a column-major version of matmul.s. However, upon inspecting the line ```li a3, 1 # stride for matrix A```, I realized something was off. In a column-major implementation, the stride for matrix A should be set to the number of rows in matrix A. To clarify, I revisited the [Assignment 2](https://hackmd.io/@sysprog/2024-arch-homework2#Matrix-Representation) page and searched for the term “major,” only to discover that the implementation had been changed to row-major format. With this understanding, everything started to make sense. I recalculated the variables for the inner and outer loops, adjusted the strides for matrices A and B, and manually determined the memory addresses for matrix A and B.

I initially thought the setup was complete, but during step-by-step testing in Venus, I discovered an issue: the test case test_matmul_length_1.s successfully jumped to matmul.s, but it failed to return from matmul.s back to test_matmul_length_1.s. The problem was that before calling dot.s within matmul.s, the return address (ra) was pushed onto the stack, representing the address to return to test_matmul_length_1.s. However, after dot.s finished execution and returned to matmul.s, the previously stored ra on the stack was not restored. In fact, none of the registers that had been pushed onto the stack earlier were restored. Once I added an appropriate Epilogue to restore the stack, the test passed successfully.

![10](https://hackmd.io/_uploads/rygYx8R-ke.png)

After making the modifications, we ran the tests again and observed that the following test cases passed successfully: test_matmul_incorrect_check, test_matmul_length_1, test_matmul_negative_dim_m0_x, test_matmul_negative_dim_m0_y, test_matmul_negative_dim_m1_x, test_matmul_negative_dim_m1_y, test_matmul_nonsquare_1, test_matmul_nonsquare_2, test_matmul_nonsquare_outer_dims, test_matmul_square, test_matmul_unmatched_dims, test_matmul_zero_dim_m0, and test_matmul_zero_dim_m1.

![11](https://hackmd.io/_uploads/SyOaxI0Zkl.png)

### read_matrix.s
While working on this modification, I added the missing multiplication logic and conducted tests. However, the tests kept failing. I used Venus to debug step by step, verifying that a0 was set to 13 (the correct system call number for fopen), a1 correctly pointed to the string address of msg0 in test_read_1, and a2 was set to 0, indicating read mode. Despite this, after executing ecall, the return value in a0 was consistently 0xFFFFFFFF. I sought help from ChatGPT-4o, and while it couldn’t pinpoint the exact issue, it provided some ideas. One suggestion made me realize an overlooked possibility: a file access permission issue. My project was stored in the National Cheng Kung University’s OneDrive sync folder, which might have caused access restrictions. After moving the project to a local folder, I ran the tests again, and this time, they passed successfully!

![截圖 2024-11-11 下午2.51.01](https://hackmd.io/_uploads/rywuKQkMJx.png)

![13](https://hackmd.io/_uploads/S1cFoXkzyx.png)

After applying the modifications, we ran the tests again and observed that the following test cases passed successfully: test_read_1, test_read_2, test_read_3, test_read_fail_fclose, and test_read_fail_malloc.

![14](https://hackmd.io/_uploads/SJDL0REfJl.png)

### write_matrix.s
With the experience gained from read_matrix.s, the first test after adding the multiply logic to write_matrix.s was successful.

![15](https://hackmd.io/_uploads/r1643EyGJx.png)

After making the modifications, we ran the tests again and observed that test_write_1 and test_write_fail_fclose passed successfully.

![16](https://hackmd.io/_uploads/ryLS3VyGye.png)

### classify.s
I encountered significant difficulties while modifying classify.s. According to the instructions within the classify.s file, only four sections needed to be updated, each requiring the implementation of a mul operation. However, when I copied and pasted the mul implementation from dot.s, the tests consistently failed to pass test_chain_1_silent and test_classify_3_print. I was stuck for quite some time, unable to understand why this was happening. As a result, I made no progress for several days.

Later, I decided to check whether the final output matrix matched the expected results. To do this, I wrote a Python script to read the binary files from classify-rv32i/tests, specifically classify-1, classify-2, classify-3, and chain-1. I then manually organized the data I read. I discovered discrepancies between output.bin and reference.bin for classify-3, as well as between batch1-output.bin and batch1-reference.bin for chain-1. However, the output.bin and reference.bin for classify-1 and classify-2 matched perfectly. These findings aligned exactly with the failed test cases, leading me to preliminarily conclude that there was an issue with the computation. What puzzled me, however, was that the computations for classify-1 and classify-2 were correct, yet the results for classify-3 were incorrect.

As mentioned earlier, I organized the data from the binary files, which were formatted as shown in the image below. Upon examining the batch1-output Matrix and batch1-reference Matrix, I noticed they were not equal. To investigate further, I referred to the [Homework 2 documentation](https://hackmd.io/@sysprog/2024-arch-homework2#Matrix-Representation) to review the steps used in [matrix computations](https://matrixcalc.org/zh-TW/). Then, I used the Matrix Calculator to verify that the computation results matched the batch1-reference Matrix. Next, I duplicated test_matmul_nonsquare_1.s and modified its inputs to use the batch1-M0 Matrix and batch1-input Matrix, with the output set to match the batch1-reference Matrix. Running the modified test_matmul_nonsquare_1.s in Venus showed that the output matrices were not equal.

I read the resulting batch1-output.bin file and compared it field by field to identify the discrepancies. The issue was evident in the very first row and column. I then traced the problem back to dot.s to identify where the computation went wrong. To isolate the issue, I duplicated test_dot_standard.s, setting the inputs to the first row of batch1-M0 Matrix and the first column of batch1-input Matrix, with strides set to 1, the computation count to 15, and the expected output to the value at the first row and column of the batch1-reference Matrix. However, the results were still inconsistent.

Unable to trace further, I resorted to step-by-step debugging to examine the logic in dot.s. Eventually, I discovered that the original implementation did not account for signed multiplication. If either of the multiplied numbers was negative, the result was incorrect. I rewrote the multiply function in dot.s to properly handle signed multiplication. After making the corrections, the computations in dot.s were validated successfully.

Realizing that the same flawed approach to multiplication had been used elsewhere, I rewrote all four instances of multiply in classify.s. However, for read_matrix.s and write_matrix.s, since the multiplication logic was only applied to the dimensions (rows and columns) of the matrices, any negative values in these dimensions would immediately trigger an error and skip the multiplication process. Therefore, I kept the original implementation in those files.

![17](https://hackmd.io/_uploads/HysGjArGyg.png)
![18](https://hackmd.io/_uploads/ryYRFASz1e.png)


![19](https://hackmd.io/_uploads/Sk00Q0Sfkg.png)

![20](https://hackmd.io/_uploads/SJLR7RBz1g.png)

After making the modifications, we ran the tests again and observed that test_chain_1, test_classify_1_silent, test_classify_2_print, and test_classify_3_print all passed successfully.

![21](https://hackmd.io/_uploads/r1sZrRBzJx.png)



