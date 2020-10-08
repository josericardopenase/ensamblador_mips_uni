.data

	datosb: .byte 0x10, -127, 0x75
	datosw: .space 3

.text

main:
	la $t0, datosb
	
	lb $a1, 0($t0)
	
	la $t1, datosw
	
	sb $a1, 0($t1)
	sb $a1, 1($t1)
	sb $a1, 2($t1)
	
	move $a0, $t1
	
	li $v0, 1
	
	syscall
	
	
	#return 0
	li $v0, 10
	syscall
	
printNumber:
	
	move $a0, $a1
	li $v0, 1
	syscall
	
	jr $ra
	
	
	
