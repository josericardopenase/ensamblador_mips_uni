.text

	main:
	
	addi $a1, $zero, 4
	addi $a2, $zero, 5
	
	jal addNumbers
	
	add $a0, $zero, $v1
	
	li $v0, 1
	syscall
	
	#return 0
	li $v0, 10
	syscall
	
	addNumbers:
	
	add $v1, $a1, $a2
	
	#return to main
	jr $ra