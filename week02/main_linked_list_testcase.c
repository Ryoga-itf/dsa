#include "linked_list.h"
#include <stdlib.h>

int main(void) {
    insert_cell_top(1);
    insert_cell(head, 3);
    insert_cell(head, 2);
    insert_cell(head->next->next, 4);
    display(); // 1 2 3 4

    delete_cell(head);
    delete_cell(head->next);
    display(); // 1 3

    insert_cell_top(0);
    display(); // 0 1 3

    delete_cell_top();
    display(); // 1 3

    return EXIT_SUCCESS;
}
