.text

	main: 
	
		addi $s0, $zero, 10
		addi $s1, $zero, 20
		addi $s2, $zero,  30
		
		addi $sp, $sp, -12
		
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		
		lw $t1, 0($sp)
		lw $t2, 4($sp)
		lw $t3, ($sp)
		
		
		
		li $v0, 10
		syscall