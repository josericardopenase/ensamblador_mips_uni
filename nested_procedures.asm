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
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	
	#sumamos uno a s0
	addi $s0, $s0, 200
	
	#print the new value
	#NESTED PROCEDURE (NESTING FUNCTIONS INSIDE OTHER FUNCTIONS)
	sw $ra, 4($sp)
	
	jal printValue
	
	lw $ra, 4($sp)
	#recuperamos el valor de $s0
	
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
	printValue:
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	jr $ra