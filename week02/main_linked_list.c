#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

int main(void) {
    insert_cell_top(1);
    insert_cell(head, 3);
    insert_cell(head, 2);
    display();

    delete_cell(head);
    display();

    delete_cell_top();
    display();

    return EXIT_SUCCESS;
}