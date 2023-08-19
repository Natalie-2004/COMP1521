#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <unistd.h>

#define DCC_PATH "/usr/local/bin/dcc"

extern char **environ;

char *strrstr(const char *, const char *);
int needsCompilation(const char *c_file, const char *binary_file);

int main(int argc, char **argv)
{
    for (size_t i = 1; i < (size_t)argc; i++) {
        if (!strrstr(argv[i], ".c")  || *(strrstr(argv[i], ".c") + 2) != '\0') continue;

        char *output_file = strdup(argv[i]);
        output_file[strlen(output_file) - 2] = '\0';

        if (!needsCompilation(argv[i], output_file)) {
            printf("%s does not need compiling\n", argv[i]);
            free(output_file);
            continue;
        }

        pid_t pid;
        char *dcc_argv[] = {DCC_PATH, argv[i], "-o", output_file, NULL};

        printf("running the command: \"");
        for (char **p = dcc_argv; *p; p++) printf("%s%s", p == dcc_argv ? "" : " ", *p);
        printf("\"\n");

        posix_spawn(&pid, DCC_PATH, NULL, NULL, dcc_argv, environ);
        waitpid(pid, NULL, 0);
        free(output_file);
    }
    return EXIT_SUCCESS;
}

extern size_t strlen(const char *);
extern char *strstr(const char *, const char *);

char *strrstr(const char *haystack, const char *needle)
{
    char *r = NULL;

    if (!needle[0]) return (char *)haystack + strlen(haystack);

    while (1) {
        char *p = strstr(haystack, needle);
        if (!p) return r;
        r = p;
        haystack = p + 1;
    }
}

int needsCompilation(const char *c_file, const char *binary_file)
{
    struct stat c_stat, bin_stat;

    // If binary doesn't exist, we need to compile
    if (stat(binary_file, &bin_stat) != 0) {
        return 1;
    }

    // If C file doesn't exist, we can't compile
    if (stat(c_file, &c_stat) != 0) {
        return 0;
    }

    // If C file has been modified after the binary, we need to compile
    return c_stat.st_mtime > bin_stat.st_mtime;
}
