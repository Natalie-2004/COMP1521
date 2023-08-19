#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int collatz(int integer);

int main(int argc, char **argv) {

    int integer = atoi(argv[1]);
    collatz(integer);

    return 0;
}

int collatz(int integer) {

    if (integer == 1) {
        printf("%d\n", integer);
        return 1;
    } 

    int count = 0;

    while (integer != 1) {

        printf("%d\n", integer);

        //If integer is odd number 
        if (integer % 2 != 0) {
            integer = integer * 3 + 1;
        } 
        //else if Integer is even number
        else if (integer % 2 == 0) {
            integer = integer / 2;
        }

        count++;
    }

    //print the final number '1' -> 'integer' is always equals to 1 
    printf("%d\n", integer);
    return count;
}