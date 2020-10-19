.data 0xFFFF0000

	tcontrol: .space 4 # dirección --> 0xFFFF0000
	tdata: .space 4 # dirección --> 0xFFFF0004
	pcontrol: .space 4 # dirección --> 0xFFFF0008
	pdata: .space 4 # dirección --> 0xFFFF000C


.data 0x10000000
# frase a imprimir por el programa principal
# definici�n del mensaje: [Pulsaci�n (n) = tecla"
# Implementaci�n del reloj, �
	pulsacion: .asciiz "[Pulsacion ("
	tecla: .asciiz ") = "
	cerrarTexto: .asciiz "]"
	frase : .asciiz "En un lugar de la mancha de cuyo nombre... \n"
	terminar: .asciiz "\n"
	separacionHora: .asciiz ":"
	resetearHora: .asciiz "\n=============================="
	resetearHora1: .asciiz "\nBIENVENIDO AL MENU DE CAMBIO DE HORA :)"
	ponerSegundosTexto: .asciiz "\nQue segundos desea poner: (0-60): "
	ponerMinutosTexto: .asciiz "\nQue minutos desea poner: (0-60): "
	ponerHorasTexto: .asciiz "\nQue horas desea poner: (0-60): "
	pusoTiempoIncorrecto: .asciiz "\nHAS PUESTO UN TIEMPO INCORRECTO!!!!!\n*RECUERDA SOLO SE PERMITEN VALORES ENTRE 0-60*\nvolviendo a abrir el menu de cambio de tiempo...\n"

.text 0x400000
	
	.globl main
	main:
		
		#Habilitamos las interrupciones de teclado
 		jal KbdIntrEnable

		#Habilitamos las interrupciones por tiempo
		jal TimerIntrEnable

		#cargamos el final de linea en el registro s1
		la $s1, frase
			
	bucle:

		#cargamos la frase para imprimir en el registro S2
		la $s2, terminar

		#si actualmente la frase == /n recargamos la frase
		beq $s1, $s2, reloadFrase

		#Sino mostramos la frase
		#===========================================
		lb $a0, 0($s1) #cargamos el byte 0 de la frase en a0 (primera palabra)
		
		#guardamos el registro ra en el stack por si va a ser usado posteriormente
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
		#funcion que imprime el caracter gurdado en a0 por pantalla
		jal PrintCharacter 
		
		#recuperamos el registro ra del stack
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
		
		#le añadimos offset a la frase para pasar a la dirección de la siguiente palabra
		addi $s1, $s1,  1
		#======================


		#preparamos el delay entre palabra y palabra (se ejecutaran 10000 instruciones)
		li  $a2, 10000

		#guaramos el registro ra en el stack 
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)

		#ejecutamos la función delay
		jal delay

		#recuperamos el registro ra del stack
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
		
		
		#ejecutamos denuevo el bucle
		j bucle

	#Delay(): se encarga del delay entre mostrar palabra y palabra.
	delay:

		#restamos -1 a a2
		addi    $a2, $a2, -1

		#mientras a2 siga siendo mayor o igual a zero volvemos al delay creando  un bucle
		bgez    $a2, delay   

		#si delay es menor que zero volvemos al programa principal
		jr      $ra


	#reloadFrase(): recarga la frase cada vez que va a terminar
	reloadFrase:

		#recarga la frase denuevo en s1
		la $s1, frase
		
		#vuelve al bucle
		j bucle

	# PrintCharacter(): Imprime un car�cter en pantalla
	# $a0: Caracter a imprimir
	PrintCharacter:

		#carga en v0 la isntruccion 11 de impresión de caracter
		li $v0, 11
		#ejecuta la instruccion
		syscall
		
		#vuelve al programa principal
		jr $ra
	
	
	
	
########################################################################
# Subrutinas relacionadas con la gestión de interrupciones #
# -> KbdIntrEnable():Habilita interrupciones del teclado #
# -> TimerIntrEnable(): Habilita interrupciones del timer #
# -> CaseIntr():Identifica interrupción y salta a rutina servicio. #
# -> KbdIntr():Rutina de servicio para atender al teclado #
# -> TimerIntr():Rutina de servicio para atender al timer #
########################################################################

	

	
	
	#KbdIntrEnable():Habilita interrupciones del teclado 
	KbdIntrEnable:

		#cargamos en s1 el registro status
		mfc0    $s1, $12
		#le hacemos un ori al numero 100000000001 (binario) de esa forma habilitamos el bit IE y el IMn correspondiente al teclado
		ori     $s1, 0x801

		#movemos s1 al registro status para completar el proceso
		mtc0    $s1, $12

		#activamos el segundo bit de tcontrol, para que registre pulsaciones del teclado
		la $a3,  tcontrol
		li $s1, 2
		sw $s1, tcontrol
		
		#ctivamos el segundo bit de pcontrol para habilitar la impresión en pantalla
		la $a3, pcontrol
		sw $s1, pcontrol

		#volvemos al programa principal
		jr $ra
	
	#TimerIntrEnable(): Habilita interrupciones del timer
	TimerIntrEnable:

		#cogemos el valor almacenado en el registro status
		mfc0 $t3, $12
		#le hacemos un ori a la direccion 1000000000000001 (binario) activando el bit IE y el IMn corespondiente al timer
		ori $t3, $t3, 0x8001
		#guardamos el valor en el registro status
		mtc0 $t3, $12

		#cargamos en t3 1000ms (1s)
		li $t3, 1000
		#lo movemos al registro compare para que se activen las interrupciones cada segundo
		mtc0 $t3, $11

		jr $ra

	#CaseInt(): se encarga de gestionar las interrupciones. Observa que tipo de interrupcion se ha producido y ejecuta la rutina de servicio correspondiente.
	CaseInt:

		#movemos 8 bits a la izquierda el registro k0 y lo almacenamos en s2
		srl $s2, $k0, 8
		#le realizamos un andi 10000000 (binario)
		andi $s2, $s2, 0x80
		#si s2 despues de la operación anterior es igual a 0X80 significa que la interrupcion producida fue del timer y activamos su rutina de servicio
		beq $s2, 0x80, TimerIntr

		#sino....

		#movemos denuevo 8 bits a la izquierda el registro k0 y lo almacenamos en s2
		srl $s2, $k0, 8
		#le realizamos un andi 1000 (binario)
		andi $s0, $s2, 0x8
		#si después de esta operación sigue siendo igual a 0x8 significa que la interrupcion producida fue de teclado y activamos su rutina de servicio.
		beq $s2, 0x8, KbdIntr

		jr $ra

	#KbdIntr(): rutina de servicio del teclado
	KbdIntr:

		#guardamos el registro ra en el stack por si acaso 

		addi $sp, $sp, -4
		sw $ra, 0($sp)


		la $t0, tcontrol 		#Cargamos en t0 la direcci�n del registro de control de teclado
		
		lw $t5, 4($t0) 			#Cargamos en t5 el registro xFFFF0004 donde se guarda la tecla pulsada
		
		#comprobamos que se ha pulsado contrl R para asi ejecutar reset time
		jal resetTime

		addi $t7, $t7, 1 		#añadimos 1 al contador de teclas pulsadas
		
		#guardamos el registro ra en el stack
		addi $sp , $sp, -4
		
		sw $ra, 0($sp)
		
		jal formatCharacter		#formateamos el caracter a imprimir
		
		#recuperamos el registro ra del stack
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4

		#volvemos a Case Int
		jr $ra

	#resetTime(): funcion que evalua si la tecla pulsada es CTRL+R (0x12 en ascii) y si es asi se resetea la hora , sino se vuelve a CaseIntr()
	resetTime:

		#en caso de la tecla no ser ctrl R volvemos a KbdIntr
		bne $t5, 0x12, exit

		#Cargamos y mostramos el texto de separación del menu de hora
		la $a0, resetearHora
		li $v0, 4
		syscall

		#cargamos y mostramos el texto de bienvenida al menu de hora
		la $a0, resetearHora1
		li $v0, 4
		syscall

		#cargamos y mostramos el texto de sepración del menu hora
		la $a0, resetearHora
		li $v0, 4
		syscall


		#CAMBIAR SEGUNDOS:
		#===========

		#mostramos el texto que te pide que introzucas los segundos
		la $a0, ponerSegundosTexto
		li $v0, 4
		syscall

		#ejecutamos la instrucción para coger un entero por teclado
		li $v0, 5
		syscall

		#comprobamos que el tiempo no sea incorrecto
		bge $v0, 60, TiempoIncorrecto

		#si no es incorrecto añadimos al registro $s5 (aquel que guarda los segundos) el registro $v0
		add $s5, $zero, $v0

		#CAMBIAR MINUTOS:
		#===========

		#mostramos el texto que te pide que introzucas los segundos
		la $a0, ponerMinutosTexto
		li $v0, 4
		syscall
		
		#ejecutamos la instrucción para coger un entero por teclado
		li $v0, 5
		syscall

		#comprobamos que el tiempo no sea incorrecto
		bge $v0, 60, TiempoIncorrecto
		
		#si no es incorrecto añadimos al registro $s6 (aquel que guarda los minutos) el registro $v0
		add $s6, $zero, $v0


		#CAMBIAR HORAS:
		#===========
		
		#cogemos y cambiamos las horas
		la $a0, ponerHorasTexto
		li $v0, 4
		syscall

		li $v0, 5
		syscall

		bge $v0, 60, TiempoIncorrecto

		add $s7, $zero, $v0

		lw $ra, 0($sp)
		
		addi $sp, $sp, 4

		jr $ra

	TiempoIncorrecto:

		la $a0, pusoTiempoIncorrecto
		li $v0, 4
		syscall

		j resetTime



	 #PARA PODER PULSAR CTRL R HAY UN COMANDO ESPECIAL EN HEXADECIMAL : 0X12
	#TimerIntr(): rutina de servicio del timer
	TimerIntr:

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		li $t3, 0
		mtc0 $t3, $9

		#=================

		addi $s5, 1


		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal addMinuto

		lw $ra, 0($sp)
		addi $sp, $sp, 4

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal addHora


		lw $ra, 0($sp)
		addi $sp, $sp, 4


		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal printHour


		lw $ra, 0($sp)
		addi $sp, $sp, 4

		#=================


		jr $ra

	addMinuto:
		
		bne $s5, 60, exit

		li $s5, 0
		addi $s6, 1
	
		jr $ra

	addHora:

		bne $s6, 60, exit

		li $s6, 0
		addi $s7, 1
	
		jr $ra

	printHour:
		la $a0, terminar
		li $v0, 4
		syscall

		#print zero for formatting
		move $s4, $s7

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal printZero

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		#=======================

		li $v0, 1
		add $a0, $zero, $s7
		syscall

		la $a0, separacionHora
		li $v0, 4
		syscall

		#print zero for formatting
		move $s4, $s6

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal printZero

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		#=======================

		li $v0, 1
		add $a0, $zero, $s6
		syscall

		la $a0, separacionHora
		li $v0, 4
		syscall


		#print zero for formatting
		move $s4, $s5

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal printZero

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		#=======================

		li $v0, 1
		add $a0, $zero, $s5
		syscall

		la $a0, terminar
		li $v0, 4
		syscall

		jr $ra


	#take register $s4 and compare
	printZero:

		bge $s4, 10, exit

		li $v0, 1
		li $a0, 0
		syscall

		jr $ra

	exit:
		jr $ra

	#$t7 contador, $t5 character
	#formateamos el caracter para que vaya de acuerdo a los estandares de la practica
	formatCharacter:
	
	#PRINT FORMATED CHARACTER
			
		#pulsaci�n "[Pulsaci�n ("
		la $a0, pulsacion
		
		li $v0, 4
		
		syscall
		#========
		#numero pulsacion "[Pulsaci�n (1"
		
		add $a0, $zero, $t7
		
		li $v0, 1
		
		syscall 
		#=========
		
		#tecla "[Pulsaci�n (1) ="
		
		la $a0, tecla
		
		li $v0, 4
		
		syscall
		
		#========
		#imprimir tecla "[Pulsaci�n (1) = a"
		add $a0, $zero,  $t5
		
		li $v0, 11
		
		syscall
		
		#=======
		#imprimir final del texto "[Pulsaci�n (1) = a]"
		
		la $a0, cerrarTexto
		
		li $v0, 4
		
		syscall
		
		#Volvemos a la instrucci�n de justo despues de llamar la rutina
		#RETURN TO $RA
		jr $ra
		
