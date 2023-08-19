#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(void) {

    int string = '\0';

    while ((string = getchar()) != EOF) {
        if (string != '/xff') {
           putchar(tolower(string));
        }
    }

    return 0;
}


