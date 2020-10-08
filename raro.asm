
.text

	.globl main
	main:
		la $t0, 0xffff
		
		jal rd_poll
		
		li $v0, 10
		syscall
	
	
	rd_poll:
	
		lw $v0, 0($t0)
		andi $v0, $v0, 0x01
		
	beq $v0, $zero, rd_poll
	
	lw $a0, 4($t0)
	li $v0, 4
	syscall
