.data
	prompt : .asciiz "enter your age! \n"
	message: .asciiz "\nyour age is: "
	
.text

	main:
		
		#print prompt in screen
		li $v0, 4
		la $a0, prompt
		
		syscall
		
		#get the user's age
		li $v0, 5
		syscall
		
		#save the age in $t0
		move $t0, $v0
		
		#print messsage your age
		li $v0, 4
		la $a0, message
		syscall
		
		li $v0, 1
		move $a0, $t0
		syscall
	
		
	
		li $v0, 10
		syscall