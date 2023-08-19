#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s: <file> <byte0> <byte1> ...\n", argv[0]);
        exit(1);
    }

    FILE *stream = fopen(argv[1], "r");
    if (stream == NULL) {
        fprintf(stderr, "%s: ", argv[0]);
        perror(argv[1]);
        exit(1);
    }

    // look backwards through the file for a '\n'
    // or start of the file
    // starting at the 2nd last byte

    long offset = -2;
    while (fseek(stream, offset, SEEK_END) == 0 && fgetc(stream) != '\n') {
        offset--;
    }

    // write out all bytes after the '\n' or start of file
    fseek(stream, offset + 1, SEEK_END);
    int byte;
    while ((byte = fgetc(stream)) != EOF) {
        fputc(byte, stdout);
    }

    fclose(stream);

    return 0;
}