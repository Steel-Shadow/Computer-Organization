.data
symbol: .space 28
array: .space 28
space: .asciiz " "
enter: .asciiz "\n"
# n= s0

.macro print_int(%a)
    li		$v0, 1		# system call #1 - print int
    move		$a0, %a
    syscall				# execute
.end_macro

.macro get_index(%i, %ans)
    move %ans, %i
    sll %ans, %ans, 2
.end_macro

.macro push(%a)
    addi $sp, $sp, -4
    sw %a, 0($sp)
.end_macro

.macro pop(%a)
    lw %a, 0($sp)
    addi $sp, $sp, 4
.end_macro

.text
li $v0, 5
syscall
move $s0, $v0

li $a0, 0
jal fun

li $v0, 10
syscall

fun:
    ## in stack
    push($a0)
    push($t0)
    push($ra)

    # index = $a0 
    if_1:
        bne $a0, $s0, if_1_end
        
        li $t0, 0   # i     = $t0
        for_1:
            beq $t0, $s0, for_1_end

            get_index($t0, $t1)
            lw $t1, array($t1)
            print_int($t1)

            li		$v0, 4		# system call #4 - print string
            la		$a0, space
            syscall				# execute

            addi $t0, $t0, 1
            j for_1
        for_1_end:

        li		$v0, 4		# system call #4 - print string
        la		$a0, enter
        syscall				# execute

        pop($ra)
        pop($t0)
        pop($a0)
        jr $ra
    if_1_end:

    li $t0, 0
    for_2:
        beq $t0, $s0, for_2_end

        if_2:
            get_index($t0,$t1)
            lw $t1, symbol($t1)
            bne $t1, $zero, if_2_end

            addi $t2, $t0, 1
            get_index($a0, $t1)
            sw $t2, array($t1)

            li $t2, 1
            get_index($t0, $t1)
            sw $t2, symbol($t1)
            
            addi $a0, $a0, 1
            jal fun
            addi $a0, $a0, -1

            li $t2, 0
            get_index($t0, $t1)
            sw $t2, symbol($t1)

        if_2_end:

        addi $t0, $t0, 1
        j for_2
    for_2_end:
    
    pop($ra)
    pop($t0)
    pop($a0)
    jr $ra
