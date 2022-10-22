.macro getindex(%i, %j, %ans)
	mul %ans, %i, $s1
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.data	
space: .asciiz " "
newline: .asciiz "\n"
martrix: .space 400 # 4* n*m

.text
li $v0, 5
syscall
move $s0, $v0		# n=$s0

li $v0, 5
syscall
move $s1, $v0 # m = $s1

# i = $t0 j=$t1
li $t0, 0
for_i:
	beq $t0, $s0, for_i_end
	nop
	
	li $t1, 0
	for_j:
	beq $t1, $s1, for_j_end
	nop
	
	li $v0, 5
	syscall
	move $t2, $v0 # read t2 
	getindex($t0, $t1,$t3)	#t3 index
	sw $t2, martrix($t3)
	
	addi $t1, $t1, 1
	j for_j
	nop
	for_j_end:

	addi $t0, $t0, 1
	j for_i
	nop
for_i_end:

###########################

addi $t0, $s0, -1
for_i_out:
	bltz $t0, for_i_out_end
	nop
	
	addi $t1, $s1, -1
	for_j_out:
	bltz $t1, for_j_out_end
	nop
	
	getindex($t0, $t1,$t2)	#t2 index
	lw $t3, martrix($t2) 	# t3 word
	if_not_zero:
		beqz $t3, if_not_zero_end
		
		li $v0, 1
		addi $a0, $t0, 1
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		li $v0, 1
		addi $a0, $t1, 1
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		li $v0, 1
		move $a0, $t3
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
		
		if_not_zero_end:

	addi $t1, $t1, -1
	j for_j_out
	nop
	for_j_out_end:
	
	addi $t0, $t0, -1
	j for_i_out
	nop
for_i_out_end:

li $v0, 10
syscall












