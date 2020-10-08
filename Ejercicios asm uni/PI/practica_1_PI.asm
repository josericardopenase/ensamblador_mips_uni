.data 0xFFFF0000
# Registros de los dispositivos de entrada/salida
	tcontrol: .space 4 # direcci�n --> 0xFFFF0000
	tdata: .space 4 # direcci�n --> 0xFFFF0004
	pcontrol: .space 4 # direcci�n --> 0xFFFF0008
	pdata: .space 4 # direcci�n --> 0xFFFF000C

.data 0x10000000
# frase a imprimir por el programa principal
# definici�n del mensaje: [Pulsaci�n (n) = tecla"
# Implementaci�n del reloj, �
	pulsacion: .asciiz "[Pulsaci�n ("
	tecla: .asciiz ") = "
	cerrarTexto: .asciiz "] \n"
	frase : .asciiz "En un lugar de la mancha de cuyo nombre... \n"
	terminar: .asciiz "\n"

.text
	.globl main
	main:
			
    #enable interruptions
    jal KbdIntrEnable 
		#enable loop make delay
		la $s1, frase
    syscall

		jal Frase
		
		li $v0, 10
    syscall
	
	# Programa principal (bucle infinito) que imprime una frase en pantalla de forma
	#indefinida
	#t7 sera el contador
	Frase:
		
		la $s2, terminar
		beq $s1, $s2, reloadFrase
		
		#MOSTRAR FRASE
		#===========================================
		lb $a0, 0($s1)
		
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
		jal PrintCharacter
		
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
		
		
		addi $s1, $s1,  1
		#======================
		
		
		
		#enable loop make delay
		li $a0, 1
		
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
    #jal Delay funciona pero en ubuntu n funciona pero en ubuntu noo
		
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
		#======================
		
		j Frase
	
	#RECARGA LA FRASE PARA QUE SE MANTENGA
	#ESCRIBIENDOSE EN PANTALLA
	reloadFrase:
		la $s1, frase
		
		j Frase
	
	# PrintCharacter(): Imprime un car�cter en pantalla
	# $a0: Car�cter a imprimir
	PrintCharacter:
	
		li $v0, 11
		syscall
		
		jr $ra
	
	
	# Delay(): Temporizador (0.5 seg aproximadamente)
	# $a0: Tiempo
	Delay:
		
		mfc0 $t1, $9
		
		add $t1, $t1, $a0

		#enable loop make delay
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
		jal makeDelay
		
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
		#======================
		
		jr $ra
	#MakeDelay(): establece un ciclo y hasta que no pase el tiempo de $a0
	#permanecera en el
	makeDelay:
		
		mfc0 $t2, $9
		
		bge $t1, $t2, makeDelay
		
		jr $ra
	# KbdIntrEnable(): Subrutina de habilitaci�n de interrupciones del teclado
  	KbdIntrEnable:

   		mfc0    $s1, $12
		ori     $s1, 0x0000ff00
		mtc0    $s1, $12
    
