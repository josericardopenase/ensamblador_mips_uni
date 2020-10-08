.data

	msg1: .asciiz "Introducir tu nombre "
	msg2: .asciiz "Introducir tu numero "
	msg3: .asciiz "quieres continuar (1: si, 2: no) "
	nombre: .space 20

.text

	main:
		
		#print message and fetch data
		
		la $a0, msg1
		li $v0, 4
		syscall
		
		li $v0, 8
		li $a1, 20
		la $a0, nombre
		syscall
		
		#imprimir numero
		la $a0, msg2
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		#quieres continuar con esta mierda
		la $a0, msg3
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		beq $v0, 1, main
		
		
		#return 0
		li $v0, 10
		syscall