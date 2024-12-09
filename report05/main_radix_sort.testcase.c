#include "radix_sort.h"
#include "sort_util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void print_bucket_state(int a[], int n, int exp) {
    printf("exp = %d: ", exp);
    for (int i = 0; i < n; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");
}

extern void counting_sort(int a[], int n, int exp);

void test_specific_array() {
    int arr[] = {143, 322, 246, 755, 123, 563, 514, 522};
    int n = sizeof(arr) / sizeof(arr[0]);

    printf("before: ");
    display(arr, n);

    int max = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }

    for (int exp = 1; max / exp > 0; exp *= 10) {
        counting_sort(arr, n, exp);
        print_bucket_state(arr, n, exp);
    }
}

int main(void) {
    srand(time(NULL));

    for (int test = 0; test < 5; test++) {
        int n = rand() % 6 + 5;
        int *a = (int *)calloc(n, sizeof(int));

        for (int i = 0; i < n; i++) {
            a[i] = rand() % 100;
        }

        radix_sort(a, n);

        if (!is_sorted(a, n)) {
            fprintf(stderr,
                    "Hey! Your sorting program seems to be broken :(\n");
            exit(EXIT_FAILURE);
        }

        free(a);
    }

    test_specific_array();
}
