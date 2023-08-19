////////////////////////////////////////////////////////////////////////
// COMP1521 23T2 --- Assignment 2: `basin', a simple file synchroniser
// <https://cgi.cse.unsw.edu.au/~cs1521/23T2/assignments/ass2/index.html>
//
// Written by Natalie Ye (z5453932) on 4.8.23
// implementing the local version of basin 
// (efficiently transfers files between computers), 
// where the sender and receiver are two different directories on the same computer
// 
// 2023-07-16   v1.1    Team COMP1521 <cs1521 at cse.unsw.edu.au>

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

// import helper function from basin.h
#include "basin.h"
// uint64_t hash_block(char block[], size_t block_size) useful in subset 1
// size_t number_of_blocks_in_file(size_t num_bytes) useful in subset 1
// size_t num_tbbi_match_bytes(size_t num_blocks) useful in sebset 2

#define BYTE_MASK 0xFF
#define INT24_SIZE 24
#define INT64_SIZE 64
#define RECORD_BYTE 1
#define PATH_LEN_ELEM 1
#define HASH_ELEM 1
#define ZERO 0
#define FAIL 1
#define SHIFT_BITS 8
#define MODE_SIZE 10
#define MAX_UPDATES 100 
#define FAILURE 1

// --- Prototypes ---
void write_int16 (uint16_t value, FILE *file);
void write_int24 (uint32_t value, FILE *file);
void write_int64 (uint64_t value, FILE* file);
void file_info1 (FILE *file, char *name);
void file_info2 (FILE *inputfile, FILE *outputfile);
// FILE *rw_source_file (char *path);
// void read_header(FILE *file, char *magic_num, uint8_t *num_record);
// void check_existence (char *path);
// uint32_t read_int24(FILE *file);
// void tcbi_update(FILE *inputfile, uint32_t *block_ind, 
//                  uint16_t *update_len, char **update_data);
// void tcbi_update(char *tbbi_filename, uint16_t *path_len, 
//                  uint32_t *block_ind, uint16_t *update_len, 
//                  char **update_data);
// void read_tcbi_record(char *tbbi_filename, uint16_t *path_len, 
//                       char **path, char *mode, uint32_t *file_size, 
//                       uint32_t *num_update);

/// @brief Create a TABI file from an array of filenames.
/// @param out_filename A path to where the new TABI file should be created.
/// @param in_filenames An array of strings containing, in order, the files
//                      that should be placed in the new TABI file.
/// @param num_in_filenames The length of the `in_filenames` array. In
///                         subset 5, when this is zero, you should include
///                         everything in the current directory.
void stage_1(char *out_filename, char *in_filenames[], size_t num_in_filenames) {
    FILE *file = fopen(out_filename, "wb");

    // error handling
    if (file == NULL) {
        perror("The above command failed successfully.");
        exit(FAILURE);
    }

    // TABI header
    char magic[MAGIC_SIZE] = TYPE_A_MAGIC;
    fwrite(magic, sizeof(char), MAGIC_SIZE, file);
    fputc(num_in_filenames, file);

    // nusing pre_increment is better
    for (int i = 0; i < num_in_filenames; ++i) {
        char *name = in_filenames[i];

        struct stat st;
        if (stat(name, &st) == ZERO) {
            size_t num_bytes = st.st_size;
            size_t num_blocks = number_of_blocks_in_file(num_bytes);

            // TABI record filed
            uint16_t path_len = strlen(name);
            fwrite(&path_len, PATH_LEN_ELEM, sizeof(uint16_t), file);
            fwrite(name, sizeof(char), path_len, file);
            write_int24(num_blocks, file);

            FILE *source_file = fopen(name, "rb");
            // error handling
            if (source_file == NULL) {
                perror("The above command failed successfully.");
                // can't jse return coz it make program cont. executing
                exit(FAILURE);
            }

            char block[BLOCK_SIZE];
            for (int j = 0; j < num_blocks; j++) {
                size_t read_size = fread(block, sizeof(char), BLOCK_SIZE, source_file);
                uint64_t hash = hash_block(block, read_size);
                // write_int64(hash, file);
                fwrite(&hash, HASH_ELEM, sizeof(uint64_t), file);
            }
            fclose(source_file);

        } else {
            perror("The above command failed successfully.");
            exit(FAILURE);
        }
    }

    fclose(file);
}

/// @brief Create a TBBI file from a TABI file.
/// @param out_filename A path to where the new TBBI file should be created.
/// @param in_filename A path to where the existing TABI file is located.
void stage_2(char *out_filename, char *in_filename) {

    // aka. receiver file, sender file 
    FILE *outputfile = fopen(out_filename, "wb");
    FILE *inputfile = fopen(in_filename, "rb");
    if (outputfile == NULL || inputfile == NULL) {
        perror("The above command failed successfully.");
        exit(FAILURE);
    }

    // check and compare init filesize - not working
    size_t init_size = ZERO;
    int check;
    while ((check = fgetc(inputfile)) != EOF) {
        //accumulate the size of file
        if (check != EOF) {
            init_size++;
        }
    }
    // move the file pointer back to the beginning pos -> seek_Set = 0
    fseek(inputfile, ZERO, SEEK_SET);

    // TBBI header in outputfile
    // MAGIC_SIZE = 4
    char magic_num[MAGIC_SIZE] = TYPE_B_MAGIC;
    fwrite(magic_num, sizeof(char), MAGIC_SIZE, outputfile);

    // read magic & num records
    char in_magic[MAGIC_SIZE];
    fread(in_magic, sizeof(char), MAGIC_SIZE, inputfile);
    uint8_t num_records;
    fread(&num_records, sizeof(uint8_t), NUM_RECORDS_SIZE, inputfile);

    // error check
    if (strncmp(in_magic, TYPE_A_MAGIC, MAGIC_SIZE) != ZERO) {
        fprintf(stderr, "The above command failed successfully.\n");
        exit(FAILURE);
    }

    fwrite(&num_records, sizeof(uint8_t), NUM_RECORDS_SIZE, outputfile);

    for (int i = 0; i < num_records; i++) {
        file_info2(inputfile, outputfile);
    }

    fclose(inputfile);
    fclose(outputfile);
}


/// @brief Create a TCBI file from a TBBI file.
/// @param out_filename A path to where the new TCBI file should be created.
/// @param in_filename A path to where the existing TBBI file is located.
void stage_3(char *tcbi_filename, char *tbbi_filename) {
    // don't have time to complete 
}


/// @brief Apply a TCBI file to the filesystem.
/// @param in_filename A path to where the existing TCBI file is located.
void stage_4(char *in_filename) {
    // TODO: implement this.
}


// --- Helper Functions ---
// 16 bit int in little endian order
void write_int16(uint16_t value, FILE *file) {
    // flipped the order -> large endian to little endian order
    // LSF written in file first
    fputc(value & BYTE_MASK, file);
    fputc((value >> SHIFT_BITS) & BYTE_MASK, file);
}

// no_blocks are written as 24bit int
// 24 bit int in little endian order
void write_int24 (uint32_t value, FILE *file) {
    // four bytes
    for (int i = 0; i < INT24_SIZE; i += SHIFT_BITS) {
        fputc((value >> i) & BYTE_MASK, file);
    }
}

// 64 bit int in little endian order
void write_int64 (uint64_t value, FILE *file) {
    for (int i = 0; i < INT64_SIZE; i += SHIFT_BITS) {
        fputc((value >> i) & BYTE_MASK, file);
    }
}

// Reads information from the inputfile and writes it to the outputfile
void file_info2 (FILE *inputfile, FILE *outputfile) {
    uint16_t path_len;

    // read inputfile
    fread (&path_len, sizeof(uint16_t), PATH_LEN_ELEM, inputfile);
    char path[path_len + 1];
    fread(path, sizeof(char), path_len, inputfile);
    // NULL terminator
    path[path_len] = '\0';

    // record field
    fwrite(&path_len, sizeof(uint16_t), PATH_LEN_ELEM, outputfile);
    fwrite(path, sizeof(char), path_len, outputfile);

    uint32_t num_blocks;
    // 24bits = 3byte
    size_t valid_block_num = fread(
        &num_blocks, 
        sizeof(uint8_t), 
        NUM_BLOCKS_SIZE, 
        inputfile
        );
    
    // error checks
    if (valid_block_num != NUM_BLOCKS_SIZE ) {
        perror("The above command failed successfully.");
        exit(FAILURE);
    }
    
    fwrite(&num_blocks, sizeof(uint8_t), NUM_BLOCKS_SIZE , outputfile);

    // imported helper function
    size_t matched_byte = num_tbbi_match_bytes(num_blocks);
    char match[matched_byte];
    // init to all 0
    memset(match, 0, matched_byte);

    FILE *source_file = fopen(path, "r+");
    // error check
    if (source_file == NULL) {
        // if file i.e short.txt do not eixst, then use w to create a new empty file
        source_file = fopen(path, "w");
    }

    char block[BLOCK_SIZE];
    // Read actual block, calculate hashes and compare with result hashes. 
    for (int i = 0; i < num_blocks; ++i) {
        uint64_t result_hash; 
        fread(&result_hash, sizeof(uint64_t), HASH_ELEM, inputfile);

        size_t size = fread(block, sizeof(char), BLOCK_SIZE, source_file);
        uint64_t atcu_hash = hash_block(block, size);

        if (result_hash == atcu_hash) {
            match[i / MATCH_BYTE_BITS] |= (1 << (7 - (i % MATCH_BYTE_BITS)));
        }
    }

    fclose(source_file);
    fwrite(match, sizeof(char), matched_byte, outputfile);
}

/*
// checks if a file exists and is a regular file
void check_existence (char *path) {
    // call stat system
    struct stat st;

    // from lib, 
    if (!(stat(path, &st) == 0 && S_ISREG(st.st_mode))) {
        fprintf(stderr, "The above command failed successfully.\n");
        exit(FAILURE);
    }
}

// can be use for stage 3
// opens a file in binary read mode ("rb") and returns the file pointer.
FILE *rw_source_file3 (char *path) {
    FILE *file = fopen(path, "rb");
    if (file == NULL) {
        perror("The above command failed successfully.");
        exit(1);
    }
    return file;
}

// reads the header of a file and extracts the magic number and number of records
void read_header(FILE *file, char *magic_num, uint8_t *num_record) {
    fread(magic_num, sizeof(char), 4, file);
    fread(num_record, sizeof(uint8_t), 1, file);

}

//  reads a single record from a file in TCBI format and extracts information 
void read_tcbi_record(FILE *file, uint16_t *path_len, char **path, char *mode, uint32_t *file_size, uint32_t *num_update) {
    fread(path_len, sizeof(uint16_t), 1, file);
    *path = malloc(sizeof(char) * (*path_len));
    fread(*path, sizeof(char), *path_len, file);
    fread(mode, sizeof(char), 10, file);
    fread(file_size, sizeof(uint32_t), 1, file);
    *num_update = read_int24(file);
}


uint32_t read_int24(FILE *file) {
    uint8_t bytes[3];
    fread(bytes, sizeof(uint8_t), 3, file);
    return (uint32_t)bytes[0] | ((uint32_t)bytes[1] << 8) | ((uint32_t)bytes[2] << 16);
}

// updates for a specific block from a TBBI file
void tcbi_update(char *tbbi_filename, uint16_t *path_len, uint32_t *block_ind, uint16_t *update_len, char **update_data) {
    FILE *tbbi_file = fopen(tbbi_filename, "rb");

    if (tbbi_file == NULL) {
        perror("Error opening TBBI file.\n");
        return;
    }

    // // Skip the magic and num_records
    fseek(tbbi_file, MAGIC_SIZE + 1, SEEK_SET); 
    uint16_t current_path_len;

    for (int i = 0; i < *block_ind; i++) {
        fread(&current_path_len, sizeof(uint16_t), 1, tbbi_file);
        fseek(tbbi_file, current_path_len + MODE_SIZE + sizeof(uint32_t), SEEK_CUR);
        uint32_t num_update = read_int24(tbbi_file);
        fseek(tbbi_file, num_update * (sizeof(uint32_t) + sizeof(uint16_t)), SEEK_CUR);
    }

    // Read num_updates for the current block
    uint32_t current_block_ind;
    fread(&current_path_len, sizeof(uint16_t), 1, tbbi_file);
    fseek(tbbi_file, current_path_len + MODE_SIZE, SEEK_CUR);
    fread(&current_block_ind, sizeof(uint32_t), 1, tbbi_file);

    // to the desired update
    fseek(tbbi_file, *update_len * (*block_ind + 1) + sizeof(uint32_t), SEEK_CUR);

    // Read the current update data
    fread(update_len, sizeof(uint16_t), 1, tbbi_file);

    *update_data = malloc(*update_len);
    if (*update_data == NULL) {
        perror("Error allocating memory for update_data.\n");
        exit(1);
    }

    // Read update_data
    fread(*update_data, sizeof(char), *update_len, tbbi_file);

    fclose(tbbi_file);
}

*/
