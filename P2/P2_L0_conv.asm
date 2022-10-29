.data
#1-10
f: .space 400
h: .space 400
g: .space 400
space: .asciiz " "
enter: .asciiz "\n"

.macro read_int(%a)
    li $v0, 5
    syscall
    move %a, $v0
.end_macro

.macro get_index(%x, %y, %m, %ans)
    mul %ans, %x, %m
    add %ans, %ans, %y
    sll %ans, %ans, 2
.end_macro

.text
read_int($s0)
read_int($s1)
read_int($s2)
read_int($s3)
#s0=m1 s1=n1    s2=m2 s3=n2

li $t0, 0
for_i_read:
    beq $t0, $s0, for_i_read_end

    li $t1, 0
    for_j_read:
        beq $t1, $s1, for_j_read_end

        read_int($t2)
        get_index($t0, $t1, $s1, $t3)
        sw $t2, f($t3)
        
        addi $t1, $t1, 1
        j for_j_read
    for_j_read_end:

    addi $t0, $t0, 1
    j for_i_read
for_i_read_end:

li $t0, 0
for_i_read_1:
    beq $t0, $s2, for_i_read_end_1

    li $t1, 0
    for_j_read_1:
        beq $t1, $s3, for_j_read_end_1

        read_int($t2)
        get_index($t0, $t1, $s3, $t3)
        sw $t2, h($t3)
        
        addi $t1, $t1, 1
        j for_j_read_1
    for_j_read_end_1:

    addi $t0, $t0, 1
    j for_i_read_1
for_i_read_end_1:

sub $s4, $s0, $s2
addi $s4, $s4, 1
sub $s5, $s1, $s3
addi $s5, $s5, 1

li $t0, 0
for_i:
    beq $t0, $s4, for_i_end

    li $t1, 0
    for_j:
        beq $t1, $s5, for_j_end

        # t2=sum
        li $t2, 0        
##################################
        li $t3, 0 #k=t3    l=t4
        for_k:
            beq $t3, $s2, for_k_end

            li $t4, 0
            for_l:
                beq $t4, $s3, for_l_end
                
                #f t5,t6   h t7
                add $t5, $t0, $t3
                add $t6, $t1, $t4
                get_index($t5, $t6, $s1, $t5)
                lw $t5, f($t5)

                get_index($t3, $t4, $s3, $t7)
                lw $t7, h($t7)

                mul $t5, $t5, $t7
                add $t2, $t2, $t5
                
                addi $t4, $t4, 1
                j for_l
            for_l_end:

            addi $t3, $t3, 1
            j for_k
        for_k_end:
##################################
        
        get_index($t0, $t1, $s5,$t3)
        sw $t2, g($t3)

        addi $t1, $t1, 1
        j for_j
    for_j_end:

    addi $t0, $t0, 1
    j for_i
for_i_end:

li $t3, 0 #k=t3    l=t4
for_k_out:
    beq $t3, $s4, for_k_out_end

    li $t4, 0
    for_l_out:
        beq $t4, $s5, for_l_out_end
        
        get_index($t3, $t4, $s5, $t5)
        lw $t5 g($t5)

        li		$v0, 1		# system call #1 - print int
        move		$a0, $t5
        syscall				# execute

        li		$v0, 4		# system call #4 - print string
        la		$a0, space
        syscall				# execute

        addi $t4, $t4, 1
        j for_l_out
    for_l_out_end:

    li		$v0, 4		# system call #4 - print string
    la		$a0, enter
    syscall				# execute

    addi $t3, $t3, 1
    j for_k_out
for_k_out_end: