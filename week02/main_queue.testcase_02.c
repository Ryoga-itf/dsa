#include "queue.h"
#include <stdlib.h>

int main(void) {
    int i;
    Queue *test_q = create_queue(3);

    enqueue(test_q, 1);
    enqueue(test_q, 2);
    enqueue(test_q, 3);
    display(test_q);

    enqueue(test_q, 4);

    delete_queue(test_q);

    return EXIT_SUCCESS;
}
