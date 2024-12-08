#include <stdbool.h>
#include <stdio.h>

bool is_sorted(int a[], int n) {
    for (int i = 1; i < n; i++) {
        if (a[i - 1] > a[i]) {
            return false;
        }
    }
    return true;
}

void display(int a[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d%c", a[i], " \n"[i == n - 1]);
    }
}
