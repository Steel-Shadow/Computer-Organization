.data
graph: .space 400
 
.macro read_int(%src)
    li $v0, 5
    syscall
    move %src, $v0
.end_macro

.macro push(%src)
    addi $sp, $sp, -4
    sw %src, ($sp)
.end_macro

.macro pop(%src)
    lw %src, ($sp)
    addi $sp, $sp, 4
.end_macro

.macro get_index(%x, %y, %ans)
    mul %ans, %x ,$s1
    add %ans, %ans, %y
    sll %ans, %ans, 2
.end_macro

.text
read_int($s0)
read_int($s1)

li $t0, 0
for_i:
    beq $t0, $s0, for_i_end

    li $t1, 0        
    for_j:
        beq $t1, $s1, for_j_end

        read_int($t2)        
        # li $t3, 1
        # sub $t2, $t3, $t2

        get_index($t0, $t1, $t3)
        sw $t2, graph($t3)

        addi $t1, $t1, 1
        j for_j
    for_j_end:        
            
    addi $t0, $t0, 1
    j for_i
for_i_end:

read_int($s2)
addi $s2, $s2, -1

read_int($s3)
addi $s3, $s3, -1

read_int($s4)
addi $s4, $s4, -1

read_int($s5)
addi $s5, $s5, -1

move $a0, $s2
move $a1, $s3
jal fun

li		$v0, 1		# system call #1 - print int
move		$a0, $s6
syscall				# execute

li $v0, 10
syscall

# fun:
# #   $t0=x0  $t1=y0
#     push($ra)
#     push($t0)
#     push($t1)

#     move $t0, $a0
#     move $t1, $a1

#     if: 
#         li $t2, 1
#         get_index($t0, $t1,$t3)
#         lw $t3, graph($t3)
#         bne $t2, $t3 if_end

#         if_1:
#             bne $t0, $s4 if_1_end
            
#             if_2:
#                 bne $t1, $s5, if_2_end
                
#                 addi $s6, $s6, 1
                
#                 pop($t1)
#                 pop($t0)
#                 pop($ra)
#                 jr $ra
                
#             if_2_end:

#         if_1_end:

#         get_index($t0, $t1,$t3)
#         sw $zero, graph($t3)
        
#         addi $a0, $t0, 1
#         move $a1, $t1
#         jal fun
        
#         addi $a0, $t0, -1
#         move $a1, $t1
#         jal fun

#         move $a0, $t0
#         addi $a1, $t1, 1 
#         jal fun

#         move $a0, $t0
#         addi $a1, $t1, -1 
#         jal fun

#         li $t2, 1
#         get_index($t0, $t1,$t3)
#         sw $t2, graph($t3)
#     if_end:

#     pop($t1)
#     pop($t0)
#     pop($ra)
# jr $ra


fun:
    push($a0)
    push($a1)
    push($t0)
    push($ra)

    bne    $a0,$s4,test
    bne    $a1,$s5,test
    addi    $s6,$s6,1
    
    end:
    pop($ra)
    pop($t0)
    pop($a1)
    pop($a0)
    jr $ra

    test:
        beq    $a0,-1,end
        beq    $a1,-1,end

        beq    $a0,$s0,end
        beq    $a1,$s1,end

        get_index($a0, $a1, $t0)

        lw    $t1,graph($t0)    
        lw    $t2,graph($t0)   
        bne    $t1,$zero,end
        bne    $t2,$zero,end

    addi    $t2,$t2,1
    sw    $t2,graph($t0)    

    addi    $a0,$a0,1
    jal    fun
    addi    $a0,$a0,-1

    addi    $a0,$a0,-1
    jal    fun
    addi    $a0,$a0,1

    addi    $a1,$a1,1
    jal    fun
    addi    $a1,$a1,-1

    addi    $a1,$a1,-1
    jal    fun
    addi    $a1,$a1,1

    get_index($a0, $a1, $t0)
    sw    $zero,graph($t0)    

    pop($ra)
    pop($t0)
    pop($a1)
    pop($a0)
jr $ra

