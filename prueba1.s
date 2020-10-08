.data
      myMessage: .asciiz "hello world! \n from assambly"

.text
      li $v0, 4
      la $a0, myMessage
      syscall