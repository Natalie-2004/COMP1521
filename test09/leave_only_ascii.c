/*
    This file is intentionally provided (almost) empty.
    Remove this comment and add your code.
*/

#include <stdio.h>
#include <stdlib.h>

void leave_only_ascii(char* filename) {
    FILE* file = fopen(filename, "rb");
    FILE* temp = fopen("temp", "wb");

    int c;
    while ((c = fgetc(file)) != EOF) {
        // Skip non-ASCII bytes
        if (c < 128) {
            fputc(c, temp);
        }
    }

    fclose(file);
    fclose(temp);

    // Rename the temporary file to the original file name
    if (rename("temp", filename) != 0) {
        fprintf(stderr, "Error renaming file");
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s filename\n", argv[0]);
        return EXIT_FAILURE;
    }

    leave_only_ascii(argv[1]);

    return EXIT_SUCCESS;
}
