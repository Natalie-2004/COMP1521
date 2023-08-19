#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "rb");
    if (file == NULL) {
        printf("Error opening file: %s\n", argv[1]);
        return 1;
    }

    int byte;
    long int count = 0;

    while ((byte = fgetc(file)) != EOF) {
        int is_printable = isprint(byte);
        printf("byte %4ld: %3d 0x%02x", count, byte, byte);

        if (is_printable) {
            printf(" '%c'", byte);
        }

        printf("\n");
        count++;
    }

    fclose(file);
    return 0;
}
