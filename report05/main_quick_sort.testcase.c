#include "quick_sort.h"
#include "sort_util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int main(void) {
    srand(time(NULL));

    for (int test = 0; test < 5; test++) {
        int n = rand() % 6 + 5;
        int *a = (int *)calloc(n, sizeof(int));

        for (int i = 0; i < n; i++) {
            a[i] = rand() % 100;
        }

        quick_sort(a, n);

        if (!is_sorted(a, n)) {
            fprintf(stderr,
                    "Hey! Your sorting program seems to be broken :(\n");
            exit(EXIT_FAILURE);
        }

        free(a);
    }

    int manual_array[] = {64, 25, 12, 22, 11};
    int manual_n = sizeof(manual_array) / sizeof(manual_array[0]);

    display(manual_array, manual_n);
    quick_sort(manual_array, manual_n);
    display(manual_array, manual_n);
}
