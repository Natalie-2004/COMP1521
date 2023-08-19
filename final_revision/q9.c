// write a c program, which takes a single filename as argument from stdin and print the total number of bits which were unset(0).

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main (int argc, char *argv[]) {
    // pathname = argv[1]
    FILE *file = fopen(argv[1], "r");

    // all file needs to do error check
    if (file == NULL) {
        perror(argv[1]);
        exit(1);
    }

    // calc the unset bit
    int count = 0;
    int byte; // 01011010
    // loop to read every bit in the byte
    // fgetc() reads the next character from stream and returns it 
    // as an unsigned char cast to an int, or EOF on end of file or error.
    while ((byte = fgetc(file)) != EOF) {
        for (int i = 0; i < 8; i++) {
            // 判断byte包含多少setbit/unset bit
            if ((byte & 0x1) == 0) {
                count++;
            }
            // let byte left shift, so next time reads the next bit. 
            byte >>= 1;
        }
    }

    fclose(file);
    printf("%d bits unset", count);
    return 0;
}