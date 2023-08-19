/*
    This file is intentionally provided (almost) empty.
    Remove this comment and add your code.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <unistd.h>
#include <sys/wait.h>

extern char **environ;


int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <command_path>\n", argv[0]);
        return 1;
    }

    char command_path[1024];
    strncpy(command_path, argv[1], sizeof(command_path) - 1);
    command_path[sizeof(command_path) - 1] = '\0';

    char line[1024];
    while (fgets(line, sizeof(line), stdin)) {
        // Remove trailing newline character
        line[strcspn(line, "\n")] = 0;

        char *args[] = {command_path, line, NULL};

        pid_t pid;
        posix_spawn(&pid, command_path, NULL, NULL, args, environ);
        waitpid(pid, NULL, 0);
    }

    return EXIT_SUCCESS;
}