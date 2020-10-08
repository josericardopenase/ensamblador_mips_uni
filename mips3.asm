.data
	pi: .float 3.1415
	miNombre: .ascii "\n Que onda mi gente"
	
.text
	li $v0, 2
	lwc1 $f12, pi
	syscall
	li $v0, 4
	la $a0, miNombre
	syscall