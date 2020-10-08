.data

 	frase: .asciiz "EN UN LUGAR DE LA MANCHA"
 
 .text
 
 	la $t1, frase
 	
 	li $a1, 101
 	
 	sb $a1, 0($t1)
 	
 	move $a0, $t1
 	
 	li $v0, 4
 	syscall
 	
 	