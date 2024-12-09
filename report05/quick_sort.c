#include "quick_sort.h"

int partition(int a[], int pivot, int left, int right) {
    int i = left - 1;

    for (int j = left; j < right; j++) {
        if (a[j] <= pivot) {
            i++;
            int temp = a[i];
            a[i] = a[j];
            a[j] = temp;
        }
    }
    int temp = a[i + 1];
    a[i + 1] = a[right];
    a[right] = temp;

    return i + 1;
}

void quick_sort_helper(int a[], int left, int right) {
    if (left < right) {
        int pivot_index = partition(a, a[right], left, right);
        quick_sort_helper(a, left, pivot_index - 1);
        quick_sort_helper(a, pivot_index + 1, right);
    }
}

void quick_sort(int a[], int n) { quick_sort_helper(a, 0, n - 1); }
