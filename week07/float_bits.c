// Extract the 3 parts of a float using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// separate out the 3 components of a float
float_components_t float_bits(uint32_t f) {
    // PUT YOUR CODE HERE

    float_components_t components;
    // exact sign
    // right shjift 31 bits to moves the sign at rightmost
    // mask all other bits and keep only sign's bit
    components.sign = (f >> 31) & 1;
    // exact component
    // right shift 23 bits to moves the exponent bits to the rightmost
    // mask all other bits and keep only the 8 bits representing the exponent.
    components.exponent = (f >> 23) & 0xFF;
    // exact frction
    // masks the sign and exponent bits, leaving only the 23 bits representing the fraction.
    components.fraction = f & 0x7FFFFF;
    return components;
}

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {
    // since NaN represent an exponent with all bits set to 1 (0xFF) and a non-zero fraction
    int isExponentAllOnes = (f.exponent == 0xFF);
    int isFractionNonZero = (f.fraction != 0);
    return isExponentAllOnes && isFractionNonZero;
}

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    // Positive infinity -> an exponent with all bits set to 1 (0xFF), 
    // a fraction equal to 0, and a sign bit equal to 0
    int isExponentAllOnes = (f.exponent == 0xFF);
    int isFractionZero = (f.fraction == 0);
    int isSignZero = (f.sign == 0);
    return isExponentAllOnes && isFractionZero && isSignZero;
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    // Negative infinity -> an exponent with all bits set to 1 (0xFF), 
    // a fraction equal to 0, and a sign bit equal to 1
    int isExponentAllOnes = (f.exponent == 0xFF);
    int isFractionZero = (f.fraction == 0);
    // change the sign
    int isSignOne = (f.sign == 1);
    return isExponentAllOnes && isFractionZero && isSignOne;
    return 42;
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {
    int isExponentZero = (f.exponent == 0);
    int isFractionZero = (f.fraction == 0);
    return isExponentZero && isFractionZero;
    return 42;
}
