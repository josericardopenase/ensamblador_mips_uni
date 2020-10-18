.data 0xFFFF0000

	tcontrol: .space 4 # dirección --> 0xFFFF0000
	tdata: .space 4 # dirección --> 0xFFFF0004
	pcontrol: .space 4 # dirección --> 0xFFFF0008
	pdata: .space 4 # dirección --> 0xFFFF000C

.text 0x400000
	
	.globl main
	main:
		
 		jal KbdIntrEnable


		jal TimerIntrEnable

#		jal bucle
			
	bucle:
	
		j bucle

	
	
	
	
	
	
	
	
	
	
	
	
	KbdIntrEnable:

		mfc0    $s1, $12
		ori     $s1, 0x801
		mtc0    $s1, $12


		la $a3,  tcontrol
		li $s1, 2
		sw $s1, tcontrol

		la $a3, pcontrol
		sw $s1, pcontrol


		jr $ra

	TimerIntrEnable:
		mfc0 $t3, $12
		ori $t3, $t3, 0x8001
		mtc0 $t3, $12

		li $t3, 1000
		mtc0 $t3, $11

		jr $ra

	CaseInt:
		srl $s2, $k0, 8
		andi $s2, $s2, 0x80
		beq $s2, 0x80, TimerIntr

		srl $s2, $k0, 8
		andi $s0, $s2, 0x8
		beq $s2, 0x8, KbdIntr

		jr $ra

	KbdIntr:
		addi $sp, $sp, -4
		sw $ra, 0($sp)


		li $v0, 1
		li $a0, 1
		syscall
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4

		jr $ra

	 #PARA PODER PULSAR CTRL R HAY UN COMANDO ESPECIAL EN HEXADECIMAL : 0X12
	TimerIntr:

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		li $t3, 0
		mtc0 $t3, $9

		li $v0, 1
		li $a0, 2
		syscall

		lw $ra, 0($sp)
		addi $sp, $sp, 4

		jr $ra