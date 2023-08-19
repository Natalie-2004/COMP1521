#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, char **argv)
{   
    ino_t inodes[argc];
    int uniqueCount = 0;

    for (int i = 1; i < argc; i++) {
        struct stat fileStat;
        stat(argv[i], &fileStat);

        int isUnique = 1;
        for (int j = 0; j < uniqueCount; j++) {
            if (inodes[j] == fileStat.st_ino) {
                isUnique = 0;
                break;
            }
        }

        if (isUnique) {
            printf("%s\n", argv[i]);
            inodes[uniqueCount++] = fileStat.st_ino;
        }
    }
    
    return EXIT_SUCCESS;
}
