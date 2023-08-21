// wirte a c program, which takes a name of file as argument should
// print thr number of 3 byte UTF-8 characters in the given file if there exists any.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ONE_BYTE 0x80
#define TWO_BYTE 0xe0
#define THREE_BYTE 0xf0
#define FOUR_BYTE 0xf8

// file operations & unicode format

void test_utf8(FILE *unicode, int *byte, int *utf8_char, int *not_utf, char *file);

int main(int argc, char **argv) {
    
    FILE *unicode = fopen(argv[1], "rb");
    char *file = argv[1];
    int utf8_char = 0;
    int not_utf = 0;
    int byte;
    while ((byte = fgetc(unicode)) != EOF) {
        test_utf8(unicode, &byte, &utf8_char, &not_utf, file);
    }

    if (!not_utf) {
        printf("%s: %d UTF-8 characters\n", file, utf8_char);
    }

    return 0;
}

// 1110 xxxx 10xx xxxx 10xx xxxx
void test_utf8(FILE *unicode, int *byte, int *utf8_char, int *not_utf, char *file) {
    int not_utf = 0;
    // 提取高位四位“1110” -> three bytes
    // 224 = 1110 0000, 继续往下走，不然不符合three byte unicode
    if ((*byte & 0xf0) == 224) {
        for (int i = 0; i < 2; i++) {
            *byte = fgetc(unicode);
            // 第二段 -> 11xx xxxx 
            if (*byte == EOF || (*byte &0xc0) == 128) {
                // 不符合utf 3bytes
                not_utf = 1;
            }
        }  

        if (!not_utf) {
            // if not ture, add on flag
            (*utf8_char)++;
        }
    }
}
