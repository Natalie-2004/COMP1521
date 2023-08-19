#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>

#define MINIMUM_SEQUENCE_LENGTH 4

void process_file(char *pathname);

int main(int argc, char *argv[]) {
    for (int arg = 1; arg < argc; arg++) {
        process_file(argv[arg]);
    }
    return 0;
}

void process_file(char *pathname) {
    FILE *stream = fopen(pathname, "r");
    if (stream == NULL) {
        perror(pathname);
        exit(1);
    }

    uint8_t buffer[MINIMUM_SEQUENCE_LENGTH - 1];
    size_t n_printable_characters_read = 0;
    int byte = 0;
    while ((byte = fgetc(stream)) != EOF) {
        if (isprint(byte)) {
            if (n_printable_characters_read < MINIMUM_SEQUENCE_LENGTH - 1) {
                buffer[n_printable_characters_read] = byte;
            } else if (
                n_printable_characters_read == MINIMUM_SEQUENCE_LENGTH - 1
            ) {
                fwrite(
                    buffer, sizeof buffer[0],
                    MINIMUM_SEQUENCE_LENGTH - 1, stdout
                );
                fputc(byte, stdout);
            } else {
                fputc(byte, stdout);
            }
            n_printable_characters_read++;
        } else {
            if (n_printable_characters_read >= MINIMUM_SEQUENCE_LENGTH) {
                printf("\n");
            }
            n_printable_characters_read = 0;
        }
    }
    if (n_printable_characters_read > MINIMUM_SEQUENCE_LENGTH) {
        printf("\n");
    }
    fclose(stream);
}