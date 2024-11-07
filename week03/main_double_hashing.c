#include "double_hashing.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DICT_LEN 10009 // prime
#define NUM_TESTS 100000

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

int main(void) {
    Timer stop_watch = {0.0,        0.0,           timer_reset, timer_start,
                        timer_stop, timer_display, timer_result};
    DictDoubleHashing *dict = create_dict(DICT_LEN);
    int num_insert = 0;

    for (int alpha_i = 0; alpha_i <= 10; alpha_i++) {
        double alpha = alpha_i / 10.0;
        int num_insertions = (int)(alpha * DICT_LEN);
        while (num_insert < num_insertions) {
            insert_hash(dict, rand());
            num_insert++;
        }
        printf("alpha: %.1f =======\n", alpha);

        stop_watch.reset(&stop_watch);
        stop_watch.start(&stop_watch);
        for (int i = 0; i < NUM_TESTS; i++) {
            search_hash(dict, rand());
        }
        stop_watch.stop(&stop_watch);
        stop_watch.display(&stop_watch);

        printf("\n");
    }

    delete_dict(dict);
    return EXIT_SUCCESS;
}
