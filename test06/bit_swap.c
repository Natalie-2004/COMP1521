// swap pairs of bits of a 64-bit value, using bitwise operators

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return value with pairs of bits swapped
uint64_t bit_swap(uint64_t value) {
    // PUT YOUR CODE HERE

    // A -> odd-positioned bits of the value >> 1
    // wheareas 5 -> even-positioned bits << 1
    uint64_t swapped_value = ((value & 0xAAAAAAAAAAAAAAAA) >> 1) | ((value & 0x5555555555555555) << 1);

    return swapped_value;
}
