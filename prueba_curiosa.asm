.data

	texto: .asciiz "Que pasa mi compañero, me encanta esta asignatura \n"
	textoALeer: .space 30
	
.text
	
	main:
	
		la $a0, texto
		li $v0, 4
		syscall
		
		la $a0, textoALeer
		li $a1, 30
		li $v0, 8
		syscall
		
		li $v0, 4
		syscall
		
		
		
	
		li $v0, 10
		syscall
		
	