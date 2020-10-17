.data

	texto: .asciiz "no"
	
.data 0xFFFF0000

	tcontrol: .space 4 # dirección --> 0xFFFF0000
	tdata: .space 4 # dirección --> 0xFFFF0004
	pcontrol: .space 4 # dirección --> 0xFFFF0008
	pdata: .space 4 # dirección --> 0xFFFF000C

.text 0x400000
	
	.globl main
	main:
		
		#activamos las interrupciones
		mfc0    $s1, $12
		ori     $s1, 0x0000ff01
		mtc0    $s1, $12

 		jal KbdIntrEnable

#		jal bucle
			
	bucle:
	
		j bucle

	
	KbdIntrEnable:
		la $a3,  tcontrol
		li $s1, 2
		sw $s1, 0($a3)

		la $a3, pcontrol
		sw $s1, 0($a3)


		jr $ra


