ori $t0, $zero, 0
ori $s0, $0, 2
ori $t1, $0, 1
for:
    beq $t0, $s0, for_end
    
    sub $s1, $s1, $t0

    add $t0, $t0, $t1
    jal for
    nop
for_end: