#include "radix_sort.h"
#include "sort_util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int const DATA_1[] = {3, 6, 8, 0, 5, 9, 7, 1, 2, 4};
static int const DATA_2[] = {63, 45, 76, 38, 38, 23, 91, 41, 37, 58};
static int const DATA_3[] = {297, 423, 250, 167, 482, 471, 778, 914, 798, 265};

void check(int const *data, int n, char const *name) {
    int *a = (int *)calloc(n, sizeof(int));
    memcpy(a, data, n * sizeof(n));

    display(a, n);
    radix_sort(a, n);
    display(a, n);

    if (!is_sorted(a, n)) {
        fprintf(stderr, "Error: %s\n", name);
        exit(EXIT_FAILURE);
    }

    free(a);
}

int main(void) {
    check(DATA_1, 10, "DATA_1");
    check(DATA_2, 10, "DATA_2");
    check(DATA_3, 10, "DATA_3");
}
