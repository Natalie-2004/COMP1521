#include <assert.h>
#include <stdlib.h>
#include <stdint.h>

// bits rotated left n times

// tips: 想象成circle，如果朝左边，是正数，朝右边，负数

uint16_t bit_rotate (int n_rotations, uint16_t bits) {
    uint32_t bits32 = bits;
    n_rotations = n_rotations % 16;
    if (n_rotations < 0) {
        n_rotations += 16;
    }

    bits32 <<= n_rotations;

    return (bits32 & 0xffff) | (bits32 >> 16);
}


// alternative:
    //  1 #include "bit_rotate.h"
    //  2 
    //  3 #define MAX_ROTATION 16
    //  4 
    //  5 // return the value bits rotated left n_rotations
    //  6 uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    //  7 
    //  8     n_rotations %= MAX_ROTATION;
    //  9 
    // 10     // error handle - negative values 
    // 11     if (n_rotations < 0) {
    // 12         n_rotations += 16;
    // 13     }
    // 14 
    // 15     // using bitwise shifts and bitwise OR
    // 16     uint16_t result = (bits << n_rotations) | (bits >> (16 - n_rotations));
    // 17 
    // 18     return result; 
    // 19 }