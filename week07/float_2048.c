// Sample solution for COMP1521 lab exercises
//
// Multiple a float by 2048 using bit operations only

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

float_components_t float_to_components(uint32_t f);
uint32_t float_from_components(float_components_t f);

#define EXPONENT_INF_NAN   0xFF
#define SIGN_SHIFT       31
#define SIGN_MASK        0x1
#define EXPONENT_SHIFT   23
#define EXPONENT_MASK    0xFF
#define FRACTION_SHIFT   0
#define FRACTION_MASK    0x7FFFFF

// float_2048 is given the bits of a float as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if the float is +inf or -int, or Nan it is returned unchanged
//
// float_2048 assumes the float is not a denormal number
//
uint32_t float_2048(uint32_t bits) {
    float_components_t f = float_to_components(bits);

    if (f.exponent != 0 && f.exponent != EXPONENT_INF_NAN) {
        // if we have a normal non-zero number increase the exponent

        f.exponent += 11;

        if (f.exponent >= EXPONENT_INF_NAN) {

            // number too large to be represented
            // set fraction & exponent to represent inf

            f.fraction = 0;
            f.exponent = EXPONENT_INF_NAN;
        }
    }

    return float_from_components(f);
}

// separate out the 3 components of a float
float_components_t float_to_components(uint32_t f) {
    float_components_t c;
    c.exponent = (f >> EXPONENT_SHIFT) & EXPONENT_MASK;
    c.fraction = (f >> FRACTION_SHIFT) & FRACTION_MASK;
    c.sign = (f >> SIGN_SHIFT) & SIGN_MASK;
    return c;
}


// build a float from its 3 components
uint32_t float_from_components(float_components_t f) {
    return (f.sign << SIGN_SHIFT)
         | (f.exponent << EXPONENT_SHIFT) |
           (f.fraction << FRACTION_SHIFT);
}