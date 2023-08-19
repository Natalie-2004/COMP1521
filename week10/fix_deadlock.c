#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <string.h>

// alice and bob's shared bank account
// starts with 1000000 cents (i.e. $10000)
int bank_account = 1000000;
pthread_mutex_t bank_account_mutex = PTHREAD_MUTEX_INITIALIZER;


// alice's personal wallet
// starts with 20000 cents (i.e. $200)
int alice_wallet = 20000;
pthread_mutex_t alice_wallet_mutex = PTHREAD_MUTEX_INITIALIZER;


// bob's personal wallet
// starts with 20000 cents (i.e. $200)
int bob_wallet   = 20000;
pthread_mutex_t bob_wallet_mutex   = PTHREAD_MUTEX_INITIALIZER;

typedef enum mutex_operation {
    LOCK,
    UNLOCK,
} mutex_operation;

static int compare_mutex_pointer(const void *p1, const void *p2)
{
    pthread_mutex_t *mp1 = (pthread_mutex_t *) p1;
    pthread_mutex_t *mp2 = (pthread_mutex_t *) p2;
    return (int)((intptr_t)mp1 - (intptr_t)mp2);
}

void ordered_mutex(mutex_operation operation, pthread_mutex_t *mutex_array[])
{
    size_t length = 0;
    while(mutex_array[length] != NULL) length++;
    qsort(mutex_array, length - 1, sizeof(mutex_array[0]), compare_mutex_pointer);
    for(size_t i = 0; i < length; i++) {
        if(operation == LOCK) {
            pthread_mutex_lock(mutex_array[i]);
        } else {
            pthread_mutex_unlock(mutex_array[length - 1 - i]);
        }
    }
}

// a thread that withdraws money from
// the joint bank account into alice's
// wallet 1 cent at a time
void *alice_withdraw(void *data) {
    for (int i = 0; i < 10000; i++) {
        ordered_mutex(LOCK, (pthread_mutex_t*[]){&bank_account_mutex, &alice_wallet_mutex, NULL});
        bank_account--;
        alice_wallet++;
        ordered_mutex(UNLOCK, (pthread_mutex_t*[]){&bank_account_mutex, &alice_wallet_mutex, NULL});
    }
    return NULL;
}

// a thread that withdraws money from
// the joint bank account into bob's
// wallet 1 cent at a time
void *bob_withdraw(void *data) {
    for (int i = 0; i < 10000; i++) {
        ordered_mutex(LOCK, (pthread_mutex_t *[]){&bank_account_mutex, &bob_wallet_mutex, NULL});
        bank_account--;
        bob_wallet++;
        ordered_mutex(UNLOCK, (pthread_mutex_t *[]){&bank_account_mutex, &bob_wallet_mutex, NULL});
    }
    return NULL;
}

// a thread that deposits money into
// the joint bank account from alice's
// wallet 1 cent at a time
void *alice_deposit(void *data) {
    for (int i = 0; i < 10000; i++) {
        ordered_mutex(LOCK, (pthread_mutex_t *[]){&bank_account_mutex, &alice_wallet_mutex, NULL});
        alice_wallet--;
        bank_account++;
        ordered_mutex(UNLOCK, (pthread_mutex_t *[]){&bank_account_mutex, &alice_wallet_mutex, NULL});
    }
    return NULL;
}

// a thread that deposits money into
// the joint bank account from bob's
// wallet 1 cent at a time
void *bob_deposit(void *data) {
    for (int i = 0; i < 10000; i++) {
        ordered_mutex(LOCK, (pthread_mutex_t *[]){&bank_account_mutex, &bob_wallet_mutex, NULL});
        bob_wallet--;
        bank_account++;
        ordered_mutex(UNLOCK, (pthread_mutex_t *[]){&bank_account_mutex, &bob_wallet_mutex, NULL});
    }
    return NULL;
}

// a thread that sends money from
// alice's wallet into bob's wallet
// 1 cent at a time
void *alice_send_bob(void *data) {
    for (int i = 0; i < 10000; i++) {
        ordered_mutex(LOCK, (pthread_mutex_t *[]){&alice_wallet_mutex, &bob_wallet_mutex, NULL});
        alice_wallet--;
        bob_wallet++;
        ordered_mutex(UNLOCK, (pthread_mutex_t *[]){&alice_wallet_mutex, &bob_wallet_mutex, NULL});
    }
    return NULL;
}

// a thread that sends money from
// bob's wallet into alice's wallet
// 1 cent at a time
void *bob_send_alice(void *data) {
    for (int i = 0; i < 10000; i++) {
        ordered_mutex(LOCK, (pthread_mutex_t *[]){&alice_wallet_mutex, &bob_wallet_mutex, NULL});
        bob_wallet--;
        alice_wallet++;
        ordered_mutex(UNLOCK, (pthread_mutex_t *[]){&alice_wallet_mutex, &bob_wallet_mutex, NULL});
    }
    return NULL;
}


///
/// DO NOT CHANGE ANY CODE BELOW THIS POINT
///


int bank_account_balance(void) {
    pthread_mutex_lock(&bank_account_mutex);
    int balance = bank_account;
    pthread_mutex_unlock(&bank_account_mutex);
    
    return balance;
}

int alice_wallet_balance(void) {
    pthread_mutex_lock(&alice_wallet_mutex);
    int balance = alice_wallet;
    pthread_mutex_unlock(&alice_wallet_mutex);
    
    return balance;
}

int bob_wallet_balance(void) {
    pthread_mutex_lock(&bob_wallet_mutex);
    int balance = bob_wallet;
    pthread_mutex_unlock(&bob_wallet_mutex);
    
    return balance;
}