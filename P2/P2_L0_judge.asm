.data
s: .space 25
# 如果你采取每次读入一个字符的系统调用（$v0=12）来读入数据,
# 那么我们保证你不会读入到任何换行符。
# 如果你采取这种方式输入，那么对于样例，
# 你可以在MARS中首先手动输入5，打回车，
# 然后手动在一行之中输入abbdl。

.text
li $v0, 5
syscall
move $s0, $v0 # $s0=n

li $t0, 0
for_read:
    beq $t0, $s0, for_read_end

    li $v0, 12
    syscall
    move $t1, $v0 # $t1= getchar()

    sb $t1, s($t0)

    add $t0, $t0, 1
    j for_read
for_read_end:

li $t0, 0
addi $t1, $s0, -1
li $t2, 1
for_judge:
    bge $t0, $t1, for_judge_end

    if: # flag=t2
        lb $s0, s($t0)
        lb $s1, s($t1)
        bne $s0, $s1, else

        j if_end
        else:
        li $t2, 0
    if_end:

    addi $t0, $t0,1
    addi $t1, $t1,-1
    j for_judge
for_judge_end:

li		$v0, 1		# system call #1 - print int
move		$a0, $t2
syscall				# execute












