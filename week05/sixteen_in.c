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

    // let input string has right 16 bits length
    assert(strlen(bits) == N_BITS);

    //initialise result as 0
    int16_t result = 0;

    for (int i = 0; i < N_BITS; i++) {

        if (bits[i] == '1') {
            // Set the least significant bit of the result to 1
            result |= 1 << (N_BITS - i - 1);
        }

    }

    return result;
}

