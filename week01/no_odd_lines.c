#include <stdio.h>
#include <string.h>

#define MAX_LENGTH 1024

int main(void) {
    char string[MAX_LENGTH];

    while (fgets(string, MAX_LENGTH, stdin) != NULL) {

        if (strlen(string) % 2 == 0) {
            fputs(string, stdout);
            //fputs("\n", stdout);
        }

    }

    return 0;
}
