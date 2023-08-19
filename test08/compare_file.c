#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <file1> <file2>\n", argv[0]);
        return 1;
    }

    FILE *file1 = fopen(argv[1], "r");
    FILE *file2 = fopen(argv[2], "r");

    if (!file1 || !file2) {
        printf("Failed to open files.\n");
        return 1;
    }

    int ch1, ch2;
    int byte_counter = 0;

    while (1) {
        ch1 = fgetc(file1);
        ch2 = fgetc(file2);

        if (ch1 != ch2 || ch1 == EOF || ch2 == EOF) {
            break;
        }

        // Increment the counter only if both characters are successfully read and are equal
        byte_counter++;
    }

    if (ch1 != ch2) {
        if (ch1 == EOF) {
            printf("EOF on %s\n", argv[1]);
        } else if (ch2 == EOF) {
            printf("EOF on %s\n", argv[2]);
        } else {
            printf("Files differ at byte %d\n", byte_counter + 1);
        }
    } else {
        printf("Files are identical\n");
    }

    fclose(file1);
    fclose(file2);

    return 0;
}
