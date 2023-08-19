#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int no_vowel(char string);

//Use ASCII table
int no_vowel(char string) {
    if (string == 'a' || string == 'e' || string == 'i' || string == 'o' || string == 'u') {
        return 1;
    } else if (string == 'A' || string == 'E' || string == 'I' || string == 'O' || string == 'U') {
        return 1;
    }

    return 0;
}

int main(void) {
    char string;

    while (scanf("%c", &string) == 1) {
        if (no_vowel(string) == 0) {
            printf("%c", string);
        }
    }
    return 0;
}
