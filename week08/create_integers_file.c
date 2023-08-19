#include <stdio.h>
#include <stdlib.h>

void create_file(char *pathname, int start, int finish); 
void print_int(FILE *f, int start, int finish);

int main(int argc, char **argv) {

    if (argc != 4) {
        fprintf(stderr, "Usage: %s <file> <start> <finish>\n", argv[0]);
        exit(1);
    }

    char *pathname = argv[1];
    int start = atoi(argv[2]);
    int finish = atoi(argv[3]);

    create_file(pathname, start, finish);

    return 0;
}

void create_file(char *pathname, int start, int finish) {
    FILE *stream = fopen(pathname, "w");
    if (stream == NULL) {
        perror(pathname);
        exit(1);
    }

    print_int(stream, start, finish);
    fclose(stream);
}

void print_int(FILE *f, int start, int finish) {
    int i = start;
    while (i <= finish) {
        fprintf(f, "%d\n", i);
        i = i + 1;
    }
}