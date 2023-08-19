// print digits from an integer one per line, reverse order
//wk4 integer
#include <stdio.h>

int main(int argc, char **argv) {
    int num;
    int rem;

    if (argc < 2) {
        printf("Usage: %s IntegerVal\n", argv[0]);
        return 1;
    }

    //printf("Number:\n");
    int nfound = scanf("%d", &num)

    if (!nfound != 1) {
        printf("Invalid IntVal\n");
        return 1;

    }

    rem = num;

    do {
        printf("%d\n", rem % 10);
        rem = rem / 10;
    } while (rem != 0);

    return 0;
}