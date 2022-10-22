.text

    li      $v0         5
    syscall 

    move    $t0         $v0                     # n=t0

if_1_begin:
    li      $t1         100
    div     $t0         $t1                     # $t0 / 100
    mfhi    $t1                                 # $t1 = $t0 mod 100
    bne     $t1         $0      if_1_elseif1    # if $t1 != $0 then if_1_elseif1
    nop     

	if_1_1_begin:
		li $t1  400
		div $t0  $t1
		mfhi $t1
		bne $t1  $0  if_1_1_else
		nop
	
		li $t1  1 
		j if_1_1_end
	
	if_1_1_else:
			li $t1 0 
	
	if_1_1_end:
    
    	j       if_1_end                            # jump to if_1_end

if_1_elseif1:

    li      $t1         4
    div     $t0         $t1
    mfhi    $t1
    bne     $t1         $0      if_1_else
    nop     

    li      $t1         1
    j       if_1_end                            # jump to if_1_end

if_1_else:
    li      $t1         0                       # $t1 = 0

if_1_end:
    li      $v0         1
    la      $a0         ($t1)
    syscall 
    
    li      $v0         10
    syscall 

