.macro push(%src)
    addi $sp, $sp, -4
    sw %src, 0($sp)
.end_macro

.macro pop(%src)
    lw %src, 0($sp)
    addi $sp, $sp, 4
.end_macro

.data
mid: .asciiz " -> "
enter: .asciiz "\n"

.text
li $v0, 5
syscall
move $s0, $v0

move $a0, $s0
li $a1, 65
li $a2, 66
li $a3, 67
jal Tower

li $v0, 10
syscall

Tower:    
    push($ra)
    push($t0)
    push($t1)
    push($t2)
    push($t3)

    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3

    if:
        bne $t0, 1, else

        move $a0, $t1
        move $a1, $t3
        jal print
        
        j if_end
    else:
        addi $a0, $t0, -1
        move $a1, $t1
        move $a2, $t3
        move $a3, $t2
        jal Tower

        move $a0, $t1
        move $a1, $t3
        jal print

        addi $a0, $t0, -1
        move $a1, $t2
        move $a2, $t1
        move $a3, $t3
        jal Tower

    if_end:

    pop($t3)
    pop($t2)
    pop($t1)
    pop($t0)
    pop($ra)
jr $ra

print:
    push($ra)           #没有维护 $a0
    push($t0)
    push($t1)

    move $t0, $a0
    move $t1, $a1

    li		$v0, 11		# system call #1 - print char
    move	$a0, $t0
    syscall				# execute

    li		$v0, 4		# system call #4 - print string
    la		$a0, mid
    syscall				# execute

    li		$v0, 11		# system call #1 - print char
    move	$a0, $t1
    syscall				# execute

    li		$v0, 4		# system call #4 - print string
    la		$a0, enter
    syscall				# execute

    pop($t1)
    pop($t0)
    pop($ra)
jr $ra