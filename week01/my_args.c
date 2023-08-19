//3.6.23
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_WORD 1028
#define MAX_LENGTH 128

int main(int argc, char *argv[]) {

    int n_words = argc - 1;

    printf("Program name: %s\n", argv[0]);

    //no addition arguments add in. 
    if (argc <= 1) {
        printf("There are no other arguments\n");

    } else {
        printf("There are %d arguments:\n", n_words);
        int argument = 1;
        while (argument < argc) {
            printf("\tArgument %d is \"%s\"\n", argument, argv[argument]);
            argument++;
        }
    }

    return 0;
}