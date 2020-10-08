	.data 0xFFFF0000
tcontrol: .space 4 # dirección --> 0xFFFF0000
tdata: .space 4 # dirección --> 0xFFFF0004
pcontrol: .space 4 # dirección --> 0xFFFF0008
pdata: .space 4 # dirección --> 0xFFFF000C


.text

	.globl main
	main:
	
		jal readCharacter
		jal printCharacter
		
	
		li $v0, 10
		syscall 
	
	#Procedure that enable interruptions.
	readCharacter:
	
		la $t0, tcontrol
		
		lw $t1, 0($t0)
		
		beq $t1, $zero, readCharacter
		
		lw $v0, 4($t0)
		
		jr $ra
		
	printCharacter:
	
		la $t2, pcontrol
		
		lw $t3, 0($t2)
		
		beq $t3, $zero, printCharacter
		
		la $a0, pdata
		
		jr $ra