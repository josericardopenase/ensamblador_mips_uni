.data

	line: .asciiz "\n"
	msg1 :  .asciiz "Enter the delay time:"
	

.text

	.globl main
	main:
	
	 	mfc0 $t0, $12 
	 	ori $t0, 0x01
	 	mtc0 $t0, $12
	 	
	 	 
	 	li $v0, 4
	 	la $a0, msg1
	 	syscall
	 	 
	 	  
	 	li $v0, 5
	 	syscall
	 	 
	 	move $t0, $v0
	 	
	 	mtc0 $t0, $11
	 	mtc0 $zero, $9
	 	
	 	
	forever:
	
	
	
		j forever
	 	      
	 	     