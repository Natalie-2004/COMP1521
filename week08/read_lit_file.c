# include <stdio.h>
# include <stdlib.h>
# include <stdint.h>

uint64_t read_int (const unsigned char *bytes, int num_bytes);

int main (int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "rb");
    if (!file) {
        fprintf(stderr, "Failed to open.");
        return 1;
    }

    char magic[4];

    if (
        fread(magic, 1, 3, file) != 3 || 
        magic[0] != 0x4C || 
        magic[1] != 0x49 || 
        magic[2] != 0x54
        ) {
        fprintf(stderr, "Failed to read magic\n");
        fclose(file);
        return 1;
    }

    // Null-terminate the magic string
    magic[3] = '\0'; 

    int num_bytes;
    unsigned char num_char;
    while (fread(&num_char, 1, 1, file) == 1) {
        // Convert ASCII character to integer
        num_bytes = num_char - '0'; 
        if (num_bytes < 1 || num_bytes > 8) {
            fprintf(stderr, "Invalid record length\n");
            fclose(file);
            return 1;
        }

        unsigned char bytes[8];
        if (fread(bytes, 1, num_bytes, file) != num_bytes) {
            fprintf(stderr, "Failed to read record\n");
            fclose(file);
            return 1;
        }

        uint64_t value = read_int(bytes, num_bytes);
        printf("%lu\n", value);
    }

    fclose(file);
    return 0;
}

uint64_t read_int (const unsigned char *bytes, int num_bytes) {
    uint64_t result = 0;
    for (int i = num_bytes - 1; i >= 0; i--) {
        result = (result << 8) | bytes[i];
    }
    return result; 
}