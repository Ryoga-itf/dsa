#include "queue.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int i;
    Queue *test_q = create_queue(10);

    enqueue(test_q, 1);
    enqueue(test_q, 2);
    display(test_q); // 1 2

    printf("%d\n", dequeue(test_q)); // 1
    printf("%d\n", dequeue(test_q)); // 2

    for (i = 0; i < 10; i++) {
        enqueue(test_q, i);
    }
    display(test_q); // 0 1 2 3 4 5 6 7 8 9

    for (i = 0; i < 9; i++) {
        dequeue(test_q); // 9
    }
    display(test_q);

    delete_queue(test_q);

    return EXIT_SUCCESS;
}
