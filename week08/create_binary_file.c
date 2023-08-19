# include <stdio.h>
# include <stdlib.h>

int main (int argc, char **argv) {

    // Check if the correct number of arguments is provided
    if (argc < 3) {
        printf("Usage: ./create_binary_file filename byte_value1 byte_value2 ...\n");
        return 1;
    }

    // Open the file in binary write mode ("wb")
    FILE *file = fopen(argv[1], "wb");
    if (file == NULL) {
        printf("Error creating the file.\n");
        return 1;
    }

// Loop through the provided byte values and write them to the file
for (int i = 2; i < argc; i++) {
    // convert the string into interger using atoi
    int byte_value = atoi(argv[i]);

    // Check if the byte value is within the range of 0...255
    if (byte_value < 0 || byte_value >255) {
        printf("Invalid byte value: %d. Byte values must be in the range 0...255.\n", byte_value);
        fclose(file);
        return 1;
    }
     // Write the byte value to the file using fputc
    fputc(byte_value, file);
}

fclose(file);

return 0;

}