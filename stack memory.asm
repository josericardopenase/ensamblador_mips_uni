.data
	newLine: .asciiz "first number"
	
.text
	main:
	
		addi $s0, $zero, 10
		
		li $v0, 1
		
		jal addOne
		
		move $a0, $s0
		
		syscall
	
	li $v0,10
	syscall
	
	addOne:
	
	#reservamos memoria del sistema
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	#sumamos uno a s0
	addi $s0, $s0, 200
	
	#print the new value
	li $v0, 1
	move $a0, $s0
	syscall
	
	#recuperamos el valor de $s0
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	