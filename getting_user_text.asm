.data

	text: .asciiz "hello, "
	name : .space 20
	
.text

	main:
	
	
		#Text input user
		li $v0, 8
		la $a0, name
		li $a1, 20
		syscall
		
		#Print message
		li $v0, 4
		la $a0, text
		syscall
		
		#Print name
		la $a0, name
		syscall
		
		li $v0, 10
		syscall