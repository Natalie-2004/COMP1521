#include <stdio.h>

int is_vowel (int ch) {
    if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u' ||
        ch == 'A' || ch == 'E' || ch == 'I' || ch == 'O' || ch == 'U') {
        return 1;
    }
    return 0;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <source_file> <destination_file>\n", argv[0]);
        return 1;
    }

    FILE *source_file = fopen(argv[1], "r");
    if (!source_file) {
        printf("Failed to open source file: %s\n", argv[1]);
        return 1;
    }

    FILE *dest_file = fopen(argv[2], "w");
    if (!dest_file) {
        printf("Failed to open/create destination file: %s\n", argv[2]);
        fclose(source_file);
        return 1;
    }

    int ch;
    while ((ch = fgetc(source_file)) != EOF) {
        if (!is_vowel(ch)) {
            fputc(ch, dest_file);
        }
    }

    fclose(source_file);
    fclose(dest_file);
    
    return 0;
}

