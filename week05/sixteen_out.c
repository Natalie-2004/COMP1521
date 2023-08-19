// Convert a 16-bit signed integer to a string of binary digits

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define N_BITS 16

char *sixteen_out(int16_t value);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= INT16_MIN && l <= INT16_MAX);
        int16_t value = l;

        char *bits = sixteen_out(value);
        printf("%s\n", bits);

        free(bits);
    }

    return 0;
}

// given a signed 16 bit integer
// return a null-terminated string of 16 binary digits ('1' and '0')
// storage for string is allocated using malloc
char *sixteen_out(int16_t value) {
    // Allocate memory to store the binary string
    char *string =malloc((N_BITS + 1) * sizeof(char));
    assert(string);

    for (int i = 0; i < N_BITS; i++) {

        //calculates the position of the bit we want to extract, 
        //from most significant bit and towards the least significant bit
        //left shift -> sets the bit at the calculated position to 1, while all other bits remain 0.
        int16_t bit = 1 << (N_BITS - i - 1);

        if (value & bit) {
            string[i] = '1';
        } else {
            string[i] = '0';
        }

    }

    //terminator
    string[N_BITS] = '\0';

    return string;

}

