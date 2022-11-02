# 21.10
.data
a:.space 4004
space: .asciiz " "
enter: .asciiz "\n"

.macro  read(%src)
    li $v0, 5
    syscall
    move %src, $v0
.end_macro

.macro get_index(%x, %src)
    sll %src, %x, 2
.end_macro

.text
read($s0) 

li $t0, 0
for_read:
    beq $t0, $s0, for_read_end

    read($t1)
    sll $t2, $t0, 3
    sw $t1, a($t2)

    read($t1)
    addi $t2, $t2, 4 
    sw $t1, a($t2)

    addi $t0, $t0, 1
    j for_read
for_read_end:

li $t0, 0
addi $s1, $s0, -1
for_i:
    beq $t0, $s1, for_i_end

    li $t1, 0
    sub $s2, $s1, $t0
    for_j:
        beq $t1, $s2, for_j_end

        if:
            sll $t2, $t1, 3
            lw $t2, a($t2) # t2=a 2*j

            sll $t3, $t1, 1 
            addi $t3, $t3, 2 # t2=2*j+2
            sll $t3, $t3, 2
            lw $t3, a($t3) # t3=a 2*j+2

            bge $t2, $t3, else_if
            
            temp:
            move $t5, $t2 #int t5 = a[2 * j];
            
            sll $t2, $t1, 1
            addi $t2, $t2, 1
            sll $t2, $t2, 2
            lw $t6, a($t2) #int t6 = a[2 * j + 1];
            
            sll $t2, $t1, 3
            sw $t3, a($t2)

            sll $t2, $t1, 1
            addi $t2, $t2, 3
            sll $t2, $t2, 2 
            lw $t2, a($t2)#  a[2 * j + 3]

            sll $t3, $t1, 1
            addi $t3, $t3, 1
            sll $t3, $t3, 2
            sw $t2, a($t3)

            sll $t2, $t1, 1
            addi $t2, $t2, 2
            sll $t2, $t2, 2
            sw $t5, a($t2) 
            
            sll $t2, $t1, 1
            addi $t2, $t2, 3
            sll $t2, $t2, 2
            sw $t6, a($t2)
            
            j if_end
        else_if:
            sll $t2, $t1, 3
            lw $t2, a($t2)

            sll $t3, $t1, 1
            addi $t3, $t3, 2
            sll $t3, $t3, 2
            lw $t3, a($t3)

            bne $t2, $t3, if_end

            if_2:
                sll $t2, $t1, 3
                addi $t2, $t2, 4
                lw $t2, a($t2)

                sll $t3, $t1, 1
                addi $t3, $t3, 3
                sll $t3, $t3, 2
                lw $t3, a($t3)

                bge $t2, $t3, if_2_end
                
                sll $t2, $t1, 3
                lw $t2, a($t2) # t2=a 2*j
                sll $t3, $t1, 1 
                addi $t3, $t3, 2 # t2=2*j+2
                sll $t3, $t3, 2
                lw $t3, a($t3) # t3=a 2*j+2
                j temp

            if_2_end:
        if_end:

        add $t1, $t1, 1
        j for_j
    for_j_end:

    addi $t0, $t0, 1
    j for_i
for_i_end:

li $t0, 0
for_out:
    beq $t0, $s0, for_out_end

    sll $t1, $t0, 3
    lw $t1, a($t1)

    li		$v0, 1		# system call #1 - print int
    move		$a0, $t1
    syscall				# execute

    li		$v0, 4		# system call #4 - print string
    la		$a0, space
    syscall				# execute

    sll $t1, $t0, 1
    addi $t1, $t1, 1
    sll $t1, $t1, 2

    li		$v0, 1		# system call #1 - print int
    lw		$a0, a($t1)
    syscall				# execute
    
    li		$v0, 4		# system call #4 - print string
    la		$a0, enter
    syscall				# execute

    addi $t0, $t0, 1
    j for_out
for_out_end:

li $v0, 10
