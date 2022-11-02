# F(0)=0，F(1)=1, F(n)=F(n - 1)+F(n - 2)（n ≥ 2，n ∈ N*）。
.macro push(%a)
    addi $sp, $sp, -4
    sw %a, 0($sp)
.end_macro

.macro pop(%a)
    lw %a, 0($sp)
    addi $sp, $sp, 4
.end_macro

.data

.text

li $v0, 5
syscall
move $a0, $v0

jal fun
move $t0, $v0

li		$v0, 1		# system call #1 - print int
move		$a0, $t0
syscall				# execute

li $v0, 10
syscall

fun:
    push($ra)
    push($t0)
    push($t1)
    push($t2)

    move $t0, $a0

    if:
        bne $t0, 0, else_if
        li $v0, 0

        j if_end
    else_if:
        bne $t0, 1, else
        li $v0, 1        

        j if_end
    else:
        addi $a0, $t0, -1
        jal fun
        move $t1, $v0

        addi $a0, $t0, -2
        jal fun
        move $t2, $v0

        add $v0, $t1, $t2
    if_end:

    pop($t2)
    pop($t1)
    pop($t0)
    pop($ra)
jr $ra