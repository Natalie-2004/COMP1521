#3.6.23
#print "hello world" in MIPS
#intend is 8 not 4!

        .test

main:   
        li      $vo, 4          #(add equivalency code / describe the sysyem call) 
                                #system call 4: print string
        la      $a0, hello_word_msg             #la->load address, allow to load address into register
        syscall

        li      $vo, 0
        jr      $ra         #return 0

        .data               #ask terminal to load this string into memory 

hello_word_msg:
        .asciiz "Hello World\n"
