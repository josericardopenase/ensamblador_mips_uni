.data
	message: .asciiz "hello function \n My name is Pepe. \n"

.text
	main: 
		jal displayMessage, #call the function with jal
		jal displayMessage
	
	#program is done

	li $v0, 10
	syscall
	
	#ANOTHER FUNCTION
	displayMessage:
		li $v0, 4
		la $a0, message
		syscall
		
		#es el return
		jr $ra
