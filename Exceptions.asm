.text
	
	
	main:
	
	mfc0 $k0, $14
	
	jal writeCode
	
	jr $k0
	
	j main


	writeCode:
	
	li $v0, 1
	li $a0, 1
	syscall
	
	jr $ra
	