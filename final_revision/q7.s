# counts the number of bits that we are set to 1 in an integer -> recursion function
# int bitCount (uint32_t num) {
#     int bit;
#     if (num == 0) {
#     return 0;
#     }
#     bit = x & 0x1;
#     return bit + bitCount(x >> 1)
# }

.text
main:
bitCount:
    begin
    push    $ra
    push    $s0    # int bit;

    bne     $a0, 0, else    # if (num != 0)
    li      $v0, 0          # return 0
    end                     #

    jr      $ra

else:
    andi    $s0, $a0, 0x1   # bit = x & 0x1;
    srl     $a0, $a0, 1     # stored in argument (x >> 1)
    jal     bitCount        # call function bitCount, passing argument num

    add     $v0, $s0, $v0   # bit + bitCount(x >> 1)

    pop     $s0
    pop     $ra
    jr      $ra

.data