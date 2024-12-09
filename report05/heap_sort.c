#include "heap_sort.h"

void sift_down(int a[], int i, int n) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && a[left] > a[largest]) {
        largest = left;
    }

    if (right < n && a[right] > a[largest]) {
        largest = right;
    }

    if (largest != i) {
        int temp = a[i];
        a[i] = a[largest];
        a[largest] = temp;

        sift_down(a, largest, n);
    }
}

void build_heap(int a[], int n) {
    for (int i = n / 2 - 1; i >= 0; i--) {
        sift_down(a, i, n);
    }
}

void heap_sort(int a[], int n) {
    build_heap(a, n);

    for (int i = n - 1; i > 0; i--) {
        int temp = a[0];
        a[0] = a[i];
        a[i] = temp;

        sift_down(a, 0, i);
    }
}
