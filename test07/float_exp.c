#include "float_exp.h"

// given the 32 bits of a float return the exponent
uint32_t float_exp(uint32_t f) {

    // 01111111 10000000 00000000 00000000
    uint32_t expo_mask = 0x7F800000;

    //right shift to LSF
    uint32_t expo_bit = (f & expo_mask) >> 23;

    // Remove bias from the exponent
    // uint32_t acutal_expo = expo_bit - 127;

    return expo_bit; 

}
