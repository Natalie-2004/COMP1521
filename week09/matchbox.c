#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "matchbox.h"

#define BYTE_LENGTH 8


struct packed_matchbox pack_matchbox(char *filename) {
    // TODO: complete this function!
    // You may find the definitions in matchbox.h useful.

    struct packed_matchbox matchbox = {
        .sequence_length = 0,
        .packed_bytes = NULL
    };

    FILE *file = fopen(filename, "rb");
    if (file == NULL) {
        perror("Failed to open file");
        exit(EXIT_FAILURE);
    }

     if (fread(&(matchbox.sequence_length), sizeof(uint16_t), 1, file) != 1) {
        perror("Error reading sequence length");
        fclose(file);
        return matchbox;
    }
    
    // convert sequence length to little endian
    matchbox.sequence_length = le16toh(matchbox.sequence_length);

    // calculate the number of bytes required to store the sequence
    size_t num_bytes = num_packed_bytes(matchbox.sequence_length);
    matchbox.packed_bytes = (uint8_t*)malloc(num_bytes * sizeof(uint8_t));

    for (int i = 0; i < matchbox.sequence_length; i++) {
        int bit = fgetc(file);
        if (bit == EOF) {
            perror("Error reading sequence");
            free(matchbox.packed_bytes);
            matchbox.packed_bytes = NULL;
            fclose(file);
            return matchbox;
        }

        // Convert '0' or '1' to actual bit and add it to the appropriate byte
        int byte_index = i / BYTE_LENGTH;
        int bit_index = i % BYTE_LENGTH;
        if (bit == '1') {
            matchbox.packed_bytes[byte_index] |= 1 << (7 - bit_index);
        } else if (bit == '0') {
            matchbox.packed_bytes[byte_index] &= ~(1 << (7 - bit_index));
        } else {
            perror("Invalid character in sequence");
            free(matchbox.packed_bytes);
            matchbox.packed_bytes = NULL;
            fclose(file);
            return matchbox;
        }
    }

    fclose(file);
    
    return matchbox;
}
