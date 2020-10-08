.data

	myArray: .word 1, 2, 3, 4, 5
	spacer: .asciiz ", "
	
.text
	
	main:
	
		li $t2, 4
		add $a1, $zero, $zero
		addi $a2, $zero, 4
		
		jal while
		
		li $v0, 10
		syscall
	
	
	while:
		#printing array offset
		mul $t1, $a1, $t2
		
		lw $a0, myArray($t1)
		
		li $v0, 1
		
		syscall
		
		#adding space between array elements
		la $a0, spacer
		li $v0, 4
		syscall
		
		
		#adding 1 to the index and if index equals length of array break
		addi $a1, $a1, 1
		
		bge $a1, $a2, break
		
		#else call while
		j while
	
	
	break:
		
		li $v0, 10
		syscall
		
		
		
	