.macro push(%a)
sw %a, 0($sp)
ori $t7, $t7, 4
sub $sp, $sp, $t7
.end_macro

.data

.text
ori $sp, $t0, 256
jal		test				# jump to test and save position to $ra
test:
push($31)
push($30)
push($29)
push($28)
push($27)
push($26)
push($25)
push($24)
push($23)
push($22)
push($21)
push($20)
push($19)
push($18)
push($17)
push($16)
push($15)
push($14)
push($13)
push($12)
push($11)
push($10)
push($9)
push($8)
push($7)
push($6)
push($5)
push($4)
push($3)
push($2)
push($1)
push($0)
