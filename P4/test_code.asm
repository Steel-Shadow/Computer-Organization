sub $26,$0,$2
ori $11,$22,53288
lui $23,46664
add $15,$23,$17
nop 
ori $25,$11,44245
ori $11,$23,50047
lui $11,12446
sw $11,1596($0)
lui $27,49745
sub $23,$24,$24
add $1,$23,$28
add $0,$1,$3
sw $2,1100($0)
ori $11,$19,45042
beq $11,$0,next1
sub $25,$11,$15
lw $12,4924($0)
jal next2
add $18,$25,$12
lw $18,3252($0)
sub $21,$11,$22
ori $11,$21,12283
ori $16,$11,55573
add $14,$16,$17
sub $21,$14,$9
sw $2,2004($0)
jr $31
sw $2,8216($0)
sw $16,5272($0)
jal next3
sw $16,9916($0)
lui $22,63618
lui $18,62692
nop 
sw $15,11180($0)
ori $21,$24,39502
ori $5,$21,35087
add $27,$30,$5
lui $14,15263
ori $11,$14,62173
sub $31,$12,$28
lui $22,63137
add $8,$1,$25
add $24,$10,$11
sw $28,12084($0)
lui $25,53994
next1: sub $0,$3,$1
sub $16,$0,$5
add $4,$16,$29
next2: sw $24,4876($0)
lw $12,12072($0)
sub $22,$13,$2
sw $22,652($0)
add $8,$22,$9
add $13,$8,$31
ori $24,$13,32963
nop 
next3: ori $30,$29,63098
lw $29,1504($0)
lui $20,47464
ori $6,$20,28841
ori $0,$6,8199
add $19,$20,$31
testend: nop
