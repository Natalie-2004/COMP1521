// write a c program, which takes two names of environment variables as arguments.
// it should print 1 iff both environment varaibles are set to the same value, otherwise print 0

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char *env1 = getenv(argv[1]);
    char *env2 = getenv(argv[2]);

    //  error check
    if(env1 != NULL && env2 != NULL) {
        if (strcmp(env1, env2) == 0) {
            printf("1\n");
        } else {
            printf("0\n");
        }
    } else {
        printf("0\n");
    }

}