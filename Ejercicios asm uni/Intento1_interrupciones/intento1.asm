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
		ori     $s1, 0x00008C01
		mtc0    $s1, $12
		
		#correcto no me jodas payasos
		la $t0, tcontrol
		li $t1, 0x02
		sb $t1, 0($t0)

		la $t0, pcontrol
		li $t1, 0x02
		sb $t1, 0($t0)
		
			
	bucle:

		j bucle