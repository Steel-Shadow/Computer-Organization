.macro read_int(%a)
	li	$v0, 5
	syscall
	move %a, $v0
.end_macro

.macro print_int(%a)
	li	$v0, 1
	move $a0, %a
	syscall
.end_macro

.macro get_index(%x, %y, %ans)
	mul %ans, %x, $s0
	add %ans, %ans, %y
	sll %ans, %ans, 2 
.end_macro

.data
martrix_1: .space 256   # n<=8
martrix_2: .space 256   # n<=8
ans: .space 256         # n<=8
space: .asciiz " "
enter: .asciiz "\n"

.text
read_int($s0)	#x = s0
	
li $t0, 0
for_i_read:
	beq $t0, $s0, for_i_read_end

	li $t1, 0
	for_j_read: # i t0		 j t1
		beq $t1, $s0, for_j_read_end
		
		read_int($t2)
		get_index($t0,$t1,$t3)
		sw $t2, martrix_1($t3)

		addi $t1, $t1, 1
		j for_j_read
	for_j_read_end:

	addi $t0, $t0, 1
	j for_i_read
for_i_read_end:

li $t0, 0
for_i_read_2:
	beq $t0, $s0, for_i_read_end_2

	li $t1, 0
	for_j_read_2: # i t0		 j t1
		beq $t1, $s0, for_j_read_end_2
		
		read_int($t2)
		get_index($t0,$t1,$t3)
		sw $t2, martrix_2($t3)

		addi $t1, $t1, 1
		j for_j_read_2
	for_j_read_end_2:

	addi $t0, $t0, 1
	j for_i_read_2
for_i_read_end_2:

li $t0, 0
for_i:
	beq $t0, $s0, for_i_end

	li $t1, 0
	for_j: # i t0		 j t1
		beq $t1, $s0, for_j_end
		# t2=k	sum=s4
		li $t2, 0
		li $s4, 0
		for_sum:
			beq $t2, $s0, for_sum_end

			get_index($t0,$t2,$t3)
			lw $s1, martrix_1($t3)
			get_index($t2,$t1,$t3)
			lw $s2, martrix_2($t3)
			
			mul $t3, $s1, $s2
			add $s4, $s4, $t3
			
			addi $t2, $t2, 1
			j for_sum
		for_sum_end:

		get_index($t0,$t1,$t2)
		sw $s4, ans($t2)

		addi $t1, $t1, 1
		j for_j
	for_j_end:

	addi $t0, $t0, 1
	j for_i
for_i_end:
	
li $t0, 0
for_i_out:
	beq $t0, $s0, for_i_out_end

	li $t1, 0
	for_j_out: # i t0		 j t1
		beq $t1, $s0, for_j_out_end
		
		get_index($t0,$t1,$t3)
		lw $t2, ans($t3)
		print_int($t2)
		
		li		$v0, 4		# system call #4 - print string
		la		$a0, space
		syscall				# execute

		addi $t1, $t1, 1
		j for_j_out
	for_j_out_end:

	li		$v0, 4		# system call #4 - print string
	la		$a0, enter
	syscall				# execute

	addi $t0, $t0, 1
	j for_i_out
for_i_out_end:

li $v0, 10
syscall
	
	
	
	
	
	
	
	
	
	
	
	