// append arguments with newline to $HOME/.diary

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char *home_pathname = getenv("HOME");
    if (home_pathname == NULL) {
        home_pathname = ".";
    }

    char *basename = ".diary";
    int diary_pathname_len = strlen(home_pathname) + strlen(basename) + 2;
    char diary_pathname[diary_pathname_len];
    snprintf(diary_pathname, sizeof diary_pathname, "%s/%s", home_pathname, basename);

    FILE *stream = fopen(diary_pathname, "a");
    if (stream == NULL) {
        perror(diary_pathname);
        return 1;
    }

    for (int arg = 1; arg < argc; arg++) {
        fprintf(stream, "%s", argv[arg]);
        if (arg < argc - 1) {
            fprintf(stream, " ");
        }
    }
    fprintf(stream, "\n");
    fclose(stream);

    return 0;
}