// compile .c files specified as command line arguments
//
// if my_program.c and other_program.c is speicified as an argument then the follow two command will be executed:
// /usr/local/bin/dcc my_program.c -o my_program
// /usr/local/bin/dcc other_program.c -o other_program

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <sys/types.h>
#include <sys/wait.h>

#define DCC_PATH "/usr/local/bin/dcc"

extern char **environ;

char *strrstr(const char *, const char *);

int main(int argc, char **argv)
{
    for (size_t i = 1; i < (size_t)argc; i++) {
        if (!strrstr(argv[i], ".c")  || *(strrstr(argv[i], ".c") + 2) != '\0') continue;

        char *output_file = strdup(argv[i]);
        output_file[strlen(output_file) - 2] = '\0';
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
