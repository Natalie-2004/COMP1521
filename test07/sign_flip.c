#include "sign_flip.h"

// given the 32 bits of a float return it with its sign flipped
uint32_t sign_flip(uint32_t f) {

    uint32_t sign_mask = 0x80000000;
    uint32_t expo_mask = 0x7F800000;
    uint32_t mantissa_mask = 0x007FFFFF;

    uint32_t sign = f & sign_mask;
    uint32_t exponent = f & expo_mask;
    uint32_t mantissa = f & mantissa_mask;

    // using XOR
    uint32_t flipped_sign = sign ^ sign_mask;

    // combine the fliped sign with its origin expo and mantissa
    uint32_t result = flipped_sign | exponent | mantissa;
    
    return result; 
}
