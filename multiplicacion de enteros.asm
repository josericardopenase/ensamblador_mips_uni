.data

.text

	addi $t0, $zero, 3
	addi $t1, $zero, 10
	
	mul $a0, $t0, $t1
	li $v0, 1
	syscall