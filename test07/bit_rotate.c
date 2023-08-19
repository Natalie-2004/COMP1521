#include "bit_rotate.h"

#define MAX_ROTATION 16

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {

    n_rotations %= MAX_ROTATION;

    // error handle - negative values 
    if (n_rotations < 0) {
        n_rotations += 16;
    }

    // using bitwise shifts and bitwise OR
    uint16_t result = (bits << n_rotations) | (bits >> (16 - n_rotations));

    return result; 
}
