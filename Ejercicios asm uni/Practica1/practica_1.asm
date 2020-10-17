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
		
		jal Frase
		
	
	Frase:
	
		
		j Frase
		
	
	#imprimimos el caracter guardado en a0
	PrintCharacter:
	
		jr $ra
		
	# Delay(): Temporizador (0.5 seg aproximadamente)
	# $a0: Tiempo	
	Delay:
		
		li $t0, 400
		mtc0 $t0, $11
		mtc0 $zero, $9
		
		
		jr $ra
		
	
	# KbdIntrEnable(): Subrutina de habilitación de interrupciones del teclado
	KbdIntrEnable:
		
		mfc0    $t0, $12
		ori $t0, 0x01
		mtc0    $t0, $12
		
		jr $ra
	
	
	TimerIntrEnable:
	
		jr $ra
	
	# CaseIntr():Identifica interrupción y salta a rutina servicio.
	CaseIntr:
	# $k0 = Al llamar a esta rutina $k0 = Registro de Cause
	
		jr $ra
	
	# KbdIntr(): Rutina de servicio del teclado	
	KbdIntr:
	
		jr $ra
	
	# TimerIntr(): Rutina de servicio del timer
	TimerIntr:
		
		jr $ra
