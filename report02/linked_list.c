#include "linked_list.h"
#include <stdio.h>
#include <stdlib.h>

Cell *head = NULL;

void insert_cell(Cell *p, int d) {
    if (p != NULL) {
        Cell *new_cell = (Cell *)malloc(sizeof(Cell));
        new_cell->data = d;
        new_cell->next = p->next;
        p->next = new_cell;
    }
}

void insert_cell_top(int d) {
    Cell *new_cell = (Cell *)malloc(sizeof(Cell));
    new_cell->data = d;
    new_cell->next = head;
    head = new_cell;
}

void delete_cell(Cell *p) {
    if (p != NULL && p->next != NULL) {
        Cell *tmp = p->next;
        p->next = tmp->next;
        free(tmp);
    }
}

void delete_cell_top(void) {
    if (head != NULL) {
        Cell *tmp = head;
        head = head->next;
        free(tmp);
    }
}

void display(void) {
    for (Cell *cur = head; cur != NULL; cur = cur->next) {
        printf("%d%c", cur->data, " \n"[cur->next == NULL]);
    }
}
