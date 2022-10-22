.data
g: .space 256
book: .space 32
# n=s0 m=s1 ans=s2
#   n个顶点 m条边

.macro push(%a)
	addi $sp, $sp, -4
	sw %a, ($sp)
.end_macro

.macro pop(%a)
	lw %a, ($sp)
	addi $sp, $sp, 4
.end_macro

.macro	 get_index(%x, %y, %ans)
	mul %ans, %x, $s0
	add %ans, %ans, %y
	sll %ans,%ans, 2
.end_macro

.text
	li $v0, 5
	syscall
	move $s0, $v0
	li $v0, 5
	syscall
	move $s1, $v0
	# i = t0		x=t1		y=t2	
	li $t0, 0
	for_input:
		beq $t0, $s1, for_input_end
		
		li $v0, 5
		syscall
		move $t1, $v0
		li $v0, 5
		syscall
		move $t2, $v0
		
		addi $t1, $t1, -1 #x=t1 y=t2
		addi $t2, $t2, -1
		
		li $t4, 1
		get_index($t1, $t2, $t3)
		sw $t4, g($t3)
		
		get_index($t2, $t1, $t3)
		sw $t4, g($t3)
		
		addi $t0, $t0, 1
		j for_input 
	for_input_end:

	move $a0, $zero
	jal dfs
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 10
	syscall

dfs:
	push($t0)
	push($ra)
	push($t2)
	move $t0,$a0 #x=$t0
	
	get_index($zero, $t0, $t1)
	li $t2 1
	sw $t2, book($t1)
	
	li $t1, 1 #flag = $t1  i=$t2
	
	li $t2, 0
	for_i: 		# $ i=$t2   		book i=t3
		beq $t2, $s0, for_i_end
		
		get_index($zero, $t2, $t3)
		lw $t3, book($t3)
		and $t1, $t1, $t3
		
		addi $t2, $t2, 1
		j for_i
	for_i_end:
	
	if_1: # g[x][0]=t2 		 judge=t3
		get_index($t0, $zero, $t2)
		lw $t2, g($t2)
		and $t3, $t1, $t2
		bne $t3, 1, if_1_end
		
		li $s2, 1
		pop($t2)
		pop($ra)
		pop($t0)
		jr $ra
	if_1_end:
	
	li $t2, 0 	#	i=t2
	for_i_2:
		beq $t2, $s0, for_i_2_end
		if_2:
			get_index ($zero, $t2, $t3)
			lw $t3, book($t3) #book i = t3
			bne $t3, 0, if_2_end
			
			get_index($t0, $t2, $t4)
			lw $t4, g($t4)  # g x i =t4 
			bne $t4, 1, if_2_end
	
			move $a0, $t2
			jal dfs
		if_2_end:
		addi $t2, $t2, 1
		j for_i_2
	for_i_2_end:
	
	get_index($zero, $t0,$t2)
	sw $0, book($t2)
	
	pop($t2)
	pop($ra)
	pop($t0)
	jr $ra



