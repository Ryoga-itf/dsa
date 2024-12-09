#include <stdio.h>
#include <stdlib.h>
#include <time.h>

long comparison_count = 0;

////////////////////////
//
// heap_sort
//
////////////////////////

void sift_down(int a[], int i, int n) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    comparison_count++;
    if (left < n && a[left] > a[largest]) {
        largest = left;
    }

    comparison_count++;
    if (right < n && a[right] > a[largest]) {
        largest = right;
    }

    comparison_count++;
    if (largest != i) {
        int temp = a[i];
        a[i] = a[largest];
        a[largest] = temp;

        sift_down(a, largest, n);
    }
}

void build_heap(int a[], int n) {
    for (int i = n / 2 - 1; i >= 0; i--) {
        comparison_count++; // ループが回るごとに終了条件が比較されるため
        sift_down(a, i, n);
    }
}

void heap_sort(int a[], int n) {
    build_heap(a, n);

    for (int i = n - 1; i > 0; i--) {
        comparison_count++; // ループが回るごとに終了条件が比較されるため
        int temp = a[0];
        a[0] = a[i];
        a[i] = temp;

        sift_down(a, 0, i);
    }
}

////////////////////////
//
// quick_sort
//
////////////////////////

int partition(int a[], int pivot, int left, int right) {
    int i = left - 1;

    for (int j = left; j < right; j++) {
        comparison_count++; // ループが回るごとに終了条件が比較されるため
        comparison_count++;
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
    comparison_count++;
    if (left < right) {
        int pivot_index = partition(a, a[right], left, right);
        quick_sort_helper(a, left, pivot_index - 1);
        quick_sort_helper(a, pivot_index + 1, right);
    }
}

void quick_sort(int a[], int n) { quick_sort_helper(a, 0, n - 1); }

////////////////////////
//
// Timer
//
////////////////////////

typedef struct timer {
    double seconds;
    double ref;
    void (*reset)(struct timer *this_timer);
    void (*start)(struct timer *this_timer);
    void (*stop)(struct timer *this_timer);
    void (*display)(struct timer *this_timer);
    double (*result)(struct timer *this_timer);
} Timer;

void timer_reset(Timer *this_timer) {
    this_timer->seconds = 0.0;
    this_timer->ref = 0.0;
    printf("Timer reset\n");
    struct timespec ts;
    clock_getres(CLOCK_MONOTONIC, &ts);
    printf("Time precision:\t%ld.%09ld sec\n", (long)ts.tv_sec, ts.tv_nsec);
}

void timer_start(Timer *this_timer) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    this_timer->ref = (double)(ts.tv_sec) + (double)ts.tv_nsec * 1e-9;
}

void timer_stop(Timer *this_timer) {
    this_timer->seconds -= this_timer->ref;
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    this_timer->ref = (double)(ts.tv_sec) + (double)ts.tv_nsec * 1e-9;
    this_timer->seconds += this_timer->ref;
}

void timer_display(Timer *this_timer) {
    printf("Elapsed time: \t%lf sec\n", this_timer->seconds);
}

double timer_result(Timer *this_timer) { return this_timer->seconds; }

////////////////////////
//
// task01, task02, task03
//
////////////////////////

void task01() {
    puts("[[task01]]");
    for (int numdata = 1000; numdata <= 10000; numdata += 1000) {
        printf("numdata: %d\n", numdata);
        int *arr1 = (int *)malloc(numdata * sizeof(int));
        int *arr2 = (int *)malloc(numdata * sizeof(int));

        for (int i = 0; i < numdata; i++) {
            int data = rand() % 10000;
            arr1[i] = arr2[i] = data;
        }

        comparison_count = 0;
        heap_sort(arr1, numdata);
        printf("  heap_sort: %ld\n", comparison_count);

        comparison_count = 0;
        quick_sort(arr2, numdata);
        printf("  quick_sort: %ld\n", comparison_count);
    }
}

void task02() {
    puts("[[task02]]");
    Timer stop_watch = {0.0,        0.0,           timer_reset, timer_start,
                        timer_stop, timer_display, timer_result};
    for (int numdata = 100000; numdata <= 3000000; numdata += 200000) {
        printf("numdata: %d\n", numdata);
        int *arr1 = (int *)malloc(numdata * sizeof(int));
        int *arr2 = (int *)malloc(numdata * sizeof(int));

        for (int i = 0; i < numdata; i++) {
            int data = rand() % 10000;
            arr1[i] = arr2[i] = data;
        }

        stop_watch.reset(&stop_watch);
        stop_watch.start(&stop_watch);
        comparison_count = 0;
        heap_sort(arr1, numdata);
        stop_watch.stop(&stop_watch);
        printf("  heap_sort: %lf sec\n", stop_watch.seconds);

        stop_watch.reset(&stop_watch);
        stop_watch.start(&stop_watch);
        comparison_count = 0;
        quick_sort(arr2, numdata);
        stop_watch.stop(&stop_watch);
        printf("  quick_sort: %lf sec\n", stop_watch.seconds);
    }
}

void task03() {
    puts("[[task03]]");
    for (int numdata = 1000; numdata <= 10000; numdata += 1000) {
        printf("numdata: %d\n", numdata);
        int *arr1 = (int *)malloc(numdata * sizeof(int));
        int *arr2 = (int *)malloc(numdata * sizeof(int));

        for (int i = 0; i < numdata; i++) {
            arr1[i] = arr2[i] = i; // already sorted
        }

        comparison_count = 0;
        heap_sort(arr1, numdata);
        printf("  heap_sort: %ld\n", comparison_count);

        comparison_count = 0;
        quick_sort(arr2, numdata);
        printf("  quick_sort: %ld\n", comparison_count);
    }
}

int main() {
    srand(time(NULL));

    task01();
    puts("");
    task02();
    puts("");
    task03();

    return 0;
}
