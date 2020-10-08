
.data

	frase1 : .asciiz "Dime un numero: "
	frase2 : .asciiz "Dime otro numero: "
	frase3: .asciiz "Son iguales"
	frase4: .asciiz "No son iguales"
	
.text

	main:
		
		#guardo la frase 1 en el resgistro a1 y ejecuto la función pedir numero
		la $a1, frase1
		
		jal pedirNumero
		
		
		move $t1, $v0 #guardo el numero 
		
		
		#pido otro numero
		
		la $a1, frase2
		
		jal pedirNumero
		
		
		
		move $t2, $v0 #guardo el numero 
		
		beq $t1, $t2, sonIguales
		
		
		
		#return
		li $v0, 10
		syscall
		
		
	#muestra la frase que se encuentra en el registro a1 y guarda un numero
	sonIguales:
	
		la $a1, frase3
		
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
		jal imprimirMensaje
		
		
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
	
		jr $ra
		
	sonDiferentes:
	
		la $a1, frase3
		
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
		jal imprimirMensaje
		
		
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
	
		jr $ra
	
	
	pedirNumero:
		
		addi $sp, $sp, -4
		
		sw $ra, 0($sp)
		
		jal imprimirMensaje
		
		lw $ra, 0($sp)
		
		addi $sp, $sp, 4
	
		li $v0, 5
		
		syscall
	
		jr $ra
	
	imprimirMensaje:
	
		li $v0, 4
		move $a0, $a1
		
		syscall
		
		jr $ra
	
		
