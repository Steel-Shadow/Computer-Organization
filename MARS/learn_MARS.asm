.data
.text
.global main
main:
addi $t0,$0,100 # tag
ori $t1,$0,200
add $t2,$t1,$t2
sub $t3,$t2,$t1
lui $t4,233
ori $v0,1
ori $a0,2333
mthi $t1
ori $a0,2333
mthi $t1
syscall
nop
loop:
j loop
nop