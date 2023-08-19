#include <stdlib.h>
#include <pthread.h>

void *increment_and_sleep(void *arg);

void costly_addition(int num)
{
    pthread_t threads[num];

    // Create a thread for each call to increment_and_sleep
    for (int i = 0; i < num; i++) {
        pthread_create(&threads[i], NULL, increment_and_sleep, NULL);
    }

    // Wait for all threads to complete
    for (int i = 0; i < num; i++) {
        pthread_join(threads[i], NULL);
    }
}
