.data

	texto: .asciiz "no"

.text 0x400000
	
	.globl main
	main:
	
	
		mfc0    $s1, $12
		ori     $s1, 0x0000ff01
		mtc0    $s1, $12
		
	
		j main
			

