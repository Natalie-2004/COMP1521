#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

// Return the encoded binary MIPS for addi $t, $s, i
uint32_t addi(int t, int s, int i) {

    uint32_t instruction = 0;
    instruction |= 0x20000000;  // Set opcode to 001000 (addi)
    instruction |= ((s & 0x1F) << 21);  // Set source register (rs)
    instruction |= ((t & 0x1F) << 16);  // Set target register (rt)
    instruction |= (i & 0xFFFF);  // Set immediate value

    return instruction;

}
