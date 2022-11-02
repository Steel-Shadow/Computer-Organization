.data
array: .space 400
plus: .asciiz "+"
enter: .asciiz "\n"
.macro push(%src)
    addi $sp, $sp, -4
    sw %src, ($sp)
.end_macro

.macro pop(%src)
    lw %src, ($sp)
    addi $sp, $sp, 4
.end_macro

.text
li $v0, 5
syscall
move $s0, $v0

move $a0, $s0
li $a1, 1
jal js

li $v0, 10
syscall

print:
    push($ra)
    push($t0)
    push($t1)
    push($t2)
    push($a0)
    
    move $t2, $a0

    li $t0, 1
    for_print:
        beq $t0, $t2, for_print_end
        
        li $v0, 1
        sll $t1, $t0, 2
        lw $a0, array($t1)
        syscall

        li		$v0, 4		# system call #4 - print string
        la		$a0, plus
        syscall				# execute   

        addi $t0, $t0, 1
        j for_print
    for_print_end:

    li $v0, 1
    sll $t1, $t0, 2
    lw $a0, array($t1)
    syscall

    li		$v0, 4		# system call #4 - print string
    la		$a0, enter
    syscall				# execute

    pop($a0)
    pop($t2)
    pop($t1)
    pop($t0)
    pop($ra)
jr $ra

js:
    push($ra)
    push($t0)
    push($t1)
    push($t3)

    move $t0, $a0
    move $t1, $a1
    
    if:
        bnez $a0, if_end
        addi $a0, $t1, -1
        jal print
    if_end:

    li $t3, 1
    for_js:
        bgt $t3, $t0, for_js_end

        if_for_js:
            addi $t2, $t1, -1
            sll $t2, $t2, 2
            lw $t2, array($t2)
            bgt $t2, $t3, if_for_js_end

            bge $t3, $s0, if_for_js_end

            sll $t2, $t1, 2
            sw $t3, array($t2)

            sub $t0, $t0, $t3

            move $a0, $t0
            addi $a1, $t1, 1
            jal js

            add $t0, $t0, $t3 
        if_for_js_end:

        addi $t3, $t3, 1
        j for_js
    for_js_end:

    pop($t3)
    pop($t1)
    pop($t0)
    pop($ra)
jr $ra