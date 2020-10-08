.data

	message1: .asciiz "dime un numero: "
	message2: .asciiz "dime otro numero: "
	message3: .asciiz "\n el resultado es: "
	
.text

	main:
		#load message as argument
		la $a1, message1
		
		#show message
		
		jal printMessage
		
		#get number
		
		jal userInput
		
		add $t1, $zero, $v1
		
		#get other number
		
		la $a1, message2
		
		#show message
		
		jal printMessage
		
		#get number
		
		jal userInput
		
		add $t2, $zero, $v1
		
		#move to a0 and a1, $t1, $t2
		
		move $a1, $t1
		move $a2, $t2
		
		#execute add
		jal addNumbers
		
		#print result
		move $a0, $v1
		
		li $v0, 1
		
		syscall
		
				
								
		#return
		li $v0, 10
		syscall
	
	
	#print a message that is saved in v0
	printMessage:
	
		li $v0, 4
		move $a0, $a1
		
		syscall
		
		jr $ra
	
	#get user input and save it in $v1
	userInput:
	
		li $v0, 5
		syscall
		
		move $v1, $v0
		
		jr $ra
		
	#add numbers saved in a1 and a2 and save in $v1
	addNumbers:
	
		add $v1, $a1, $a2
		
		jr $ra
	
		