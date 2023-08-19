#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	
    if (argc <= 1) {
        printf("Usage: %s NUMBER [NUMBER ...]\n", argv[0]);
    } else {

        int length = argc - 1;
        int array[length];

        int min = 100;
        int max = 0;
        int sum = 0;
        int prod = 1;
        int mean = 0;

        for (int i = 1; i < argc; i++) {
            array[i - 1] = atoi(argv[i]);
        }

        for (int j = 0; j < length; j++) {
            if (min > array[j]) {
                min = array[j];
            }

            if (max < array[j]) {
                max = array[j];
            }

            sum = sum + array[j];
            prod = prod * array[j];
            mean = sum / length;
        }

        printf("MIN:  %d\n", min);
        printf("MAX:  %d\n", max);
        printf("SUM:  %d\n", sum);
        printf("PROD: %d\n", prod);
        printf("MEAN: %d\n", mean);
           
    }

return 0;
}