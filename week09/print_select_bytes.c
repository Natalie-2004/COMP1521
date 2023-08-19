#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <filename> <positions>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "rb");
    if (!file) {
        perror("File opening failed");
        return 1;
    }

    for (int i = 2; i < argc; i++) {
        long pos = atol(argv[i]);
        if (fseek(file, pos, SEEK_SET) != 0) {
            fprintf(stderr, "Failed to seek to position %ld\n", pos);
            continue;
        }
        
        int ch = fgetc(file);
        if (ch == EOF) {
            if (feof(file))
                printf("End of file reached at position %ld\n", pos);
            else
                perror("File read failed");
            continue;
        }

        if (ch >= ' ' && ch <= '~')
            printf("%d - 0x%02X - '%c'\n", ch, ch, ch);
        else
            printf("%d - 0x%02X\n", ch, ch);
    }

    fclose(file);
    return 0;
}
