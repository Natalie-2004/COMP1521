// count bits in a uint64_t

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return how many 1 bits value contains
int bit_count(uint64_t value) {
    // PUT YOUR CODE HERE

    int number = 0;

    while (value != 0) {
        // least significant bit of number using the bitwise AND (&) operator with 1
        number += value & 1;
        // Shift value right by 1 bit
        value >>= 1;
    }

    return number;
}
