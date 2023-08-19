#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX 30

int fibonacci (int input);

int main (void) {
    
    int input;

    while (scanf("%d", &input) != EOF) {

        if (input < MAX) {
            printf("%d\t\n", fibonacci(input));
        } else {
            return 1;
        }

    }
    
    return 0;
}

int fibonacci (int input) {
    if (input == 0) {
        return 0;
    } else if (input == 1) {
        return 1;
    }

    return fibonacci (input - 1) + fibonacci (input - 2);
}