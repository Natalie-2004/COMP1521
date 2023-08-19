/*
    This file is intentionally provided (almost) empty.
    Remove this comment and add your code.
*/

#include <stdio.h>
#include <stdlib.h>

void compare_bytes(char* filename1, long pos1, char* filename2, long pos2) {
    FILE* file1 = fopen(filename1, "rb");
    FILE* file2 = fopen(filename2, "rb");

    fseek(file1, pos1, SEEK_SET);
    fseek(file2, pos2, SEEK_SET);

    int byte1 = fgetc(file1);
    int byte2 = fgetc(file2);

    if (byte1 == EOF || byte2 == EOF || byte1 != byte2) {
        printf("byte %ld in %s and byte %ld in %s are not the same\n", pos1, filename1, pos2, filename2);
    } else {
        printf("byte %ld in %s and byte %ld in %s are the same\n", pos1, filename1, pos2, filename2);
    }

    fclose(file1);
    fclose(file2);
}

int main(int argc, char* argv[]) {

    compare_bytes(argv[1], atol(argv[2]), argv[3], atol(argv[4]));

    return 0;
}
