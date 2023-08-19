// Write a C function deleteLine which deletes a specific line of the given file.
// It should delete the line specifying by the line number and keep all other contents unchanged. 
// After the deletion, the file with filename should be in the original directory and no other temporary files are allowed.

/**
 * C program to delete specific line from a file.
 * https://codeforwin.org/c-programming/c-program-remove-specific-line-from-file
 */

#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 1000

/* Function declarations */
void deleteLine(char path, const int line);
void printFile(FILE *fptr);

int main()
{
    FILE *srcFile;
    FILE *tempFile;

    char path[100];

    int line;


    /* Input file path and line number */
    printf("Enter file path: ");
    scanf("%s", path);

    printf("Enter line number to remove: ");
    scanf("%d", &line);


    // /* Try to open file */
    // srcFile  = fopen(path, "r");
    // tempFile = fopen("delete-line.tmp", "w");


    // /* Exit if file not opened successfully */
    // if (srcFile == NULL || tempFile == NULL)
    // {
    //     printf("Unable to open file.\n");
    //     printf("Please check you have read/write previleges.\n");

    //     exit(EXIT_FAILURE);
    // }

    // printf("\nFile contents before removing line.\n\n");
    // printFile(srcFile);


    // // Move src file pointer to beginning
    // rewind(srcFile);

    // Delete given line from file.
    deleteLine(path, line);

    printf("\n\n\nFile contents after removing %d line \n\n", line);

    // /* Close all open files */
    // fclose(srcFile);
    // fclose(tempFile);


    // /* Delete src file and rename temp file as src */
    // remove(path);
    // rename("delete-line.tmp", path);


    // printf("\n\n\nFile contents after removing %d line.\n\n", line);

    // Open source file and print its contents
    srcFile = fopen(path, "r");
    printFile(srcFile);
    fclose(srcFile);

    return 0;
}


/**
 * Print contents of a file.
 */
void printFile(FILE *fptr)
{
    char ch;

    while((ch = fgetc(fptr)) != EOF)
        putchar(ch);
}



/**
 * Function to delete a given line from file.
 */
void deleteLine(FILE *srcFile, FILE *tempFile, const int line)
{
    // TODO

    FILE *src = fopen(path, "r");
    FILE *temp = fopen("del.tmp", "w");

    if (src == NULL || temp == NULL) {
        perror ("delete");
        exit(1);
    }

    // 确保pointer在文件开头
    fseek(src, 0, SEEK_SET);
    char buffer[BUFFER_SIZE];
    int count = 1;

    while ((fgets(buffer, BUFFER_SIZE, src)) != EOF) {
        if (line != count) {
            fputs(buffer, temp);
        }
        count ++;
    }

    fclose(src);
    fclose(temp);

    // remove source file
    remove(path);
    // "del.temp" -> old name
    rename("del.temp", path);

}