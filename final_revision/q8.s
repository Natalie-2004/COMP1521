# void string_print (char *mystr) {
#     while (*mystr != "\0") {
#         myprint(*mystr);
#         mystr++;
#     }
# }

string_print:
    begin 
    push    $ra
    push    $s0

    move    $s0, $a0        # stored *mystr at $s0
    # load the vale stored at addredd mystr
    lb      $a0, ($s0)      

loop:
    beq     $a0, '\0', end   # while (*mystr == "\0"), go to end
    jal     myprint
    #这里加的是地址而不是值，用回s0
    addi    $s0, $s0, 1
    lb      $a0, ($s0)
    j       loop

end:
    pop     $s0
    pop     $ra
    end 
    jr      $ra