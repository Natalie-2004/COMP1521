/*
    This file is intentionally provided (almost) empty.
    Remove this comment and add your code.
*/

#include <stdio.h>
#include <time.h>
#include <sys/stat.h>

void check_time_travel(char* filename) {
    struct stat file_stat;
    time_t now = time(NULL);

    stat(filename, &file_stat);

    if (difftime(now, file_stat.st_atime) < 0 || difftime(now, file_stat.st_mtime) < 0) {
        printf("%s has a timestamp that is in the future\n", filename);
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file1 [file2 ...]\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        check_time_travel(argv[i]);
    }

    return 0;
}
