#include <stdio.h>

int is_vowel (int ch) {
    if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u' ||
        ch == 'A' || ch == 'E' || ch == 'I' || ch == 'O' || ch == 'U') {
        return 1;
    }
    return 0;
}

int main (int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Failed to open file: %s\n", argv[1]);
        return 1;
    }

    int ch;
    int count = 0;

    while ((ch = fgetc(file)) != EOF) {
        if (is_vowel(ch)) {
            count++;
        }
    }

    fclose(file);
    printf("%d\n", count);

    return 0;
}