# include <stdio.h>
# include <stdlib.h>
# include <stdint.h>
# include <sys/stat.h>

int main (int argc, char **argv) {
     if (argc < 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        struct stat st;
        if (stat(argv[i], &st) == -1) {
            perror('stat');
            continue;
        }

        print_permission(st.st_mode);
        printf(" %s\n", argv[i]);
    }

    return 0;
}