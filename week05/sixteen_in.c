// Convert string of binary digits to 16-bit signed integer

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#define N_BITS 16

int16_t sixteen_in(char *bits);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        printf("%d\n", sixteen_in(argv[arg]));
    }

    return 0;
}

//
// given a string of binary digits ('1' and '0')
// return the corresponding signed 16 bit integer
//
int16_t sixteen_in(char *bits) {

    int16_t result = 0;

    for (int i = 0; i < N_BITS; i++) {
        if (bits[i] == '1') {
            // (15 - i)
            // calculates how many positions to the left the 1 should be shifted.
            // i.e for first iteration, with i = 0
            // the shift will be 15 positions to the left -> most significant figure
            // 1 << (15 - i)
            // shifts the number 1 to the left by the calculated number of positions
            // result |== ...
            // ORing any number with 0 will leave it unchanged, and ORing it with 1 will set that bit
            result |= 1 << (15 - i);
        }
    }

    return result;
}
