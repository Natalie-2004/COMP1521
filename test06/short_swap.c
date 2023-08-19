// Swap bytes of a short

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

// given uint16_t value return the value with its bytes swapped
uint16_t short_swap(uint16_t value) {
    // PUT YOUR CODE HERE

    uint16_t swapped_value = ((value & 0xFF) << 8) | ((value >> 8) & 0xFF);

    return swapped_value;
}
