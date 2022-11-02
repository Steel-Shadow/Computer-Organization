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
move $s0, $v0

move $a0, $s0
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

    move $t0, $a0

    if:
        bne $t0, $zero, if_end

        li $v0, 1
        
        pop($t0)
        pop($ra)
        jr $ra
    if_end:
    
    addi $a0, $t0, -1
    jal fun

    mul $v0, $v0, $t0

    pop($t0)
    pop($ra)
jr $ra

#        #include<iostream>using namespace std; 
#        int F(int n){
#       	if(n==0)//递归边界
#      		return 1; 
#        	return n*F(n-1);//递归公式} 
#        
#       int main(){	
#       int n;	cin >> n;	cout << F(n) << endl; 
#        	return 0;
#        }