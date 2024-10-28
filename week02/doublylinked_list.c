#include "doublylinked_list.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

Cell *CreateCell(int d, bool is_head) {
    Cell *cell = (Cell *)malloc(sizeof(Cell));
    if (cell == NULL) {
        perror("out of memory.");
        exit(EXIT_FAILURE);
    }
    cell->data = d;
    cell->is_head = is_head;
    cell->prev = cell->next = cell;
    return cell;
}

void InsertNext(Cell *this_cell, Cell *p) {
    if (!this_cell || !p) {
        return;
    }
    p->next = this_cell->next;
    p->prev = this_cell;
    this_cell->next->prev = p;
    this_cell->next = p;
}

void InsertPrev(Cell *this_cell, Cell *p) {
    if (!this_cell || !p) {
        return;
    }
    p->prev = this_cell->prev;
    p->next = this_cell;
    this_cell->prev->next = p;
    this_cell->prev = p;
}

void DeleteCell(Cell *this_cell) {
    if (!this_cell || this_cell->is_head) {
        return;
    }
    this_cell->prev->next = this_cell->next;
    this_cell->next->prev = this_cell->prev;
    free(this_cell);
}

Cell *SearchCell(Cell *this_cell, int d) {
    for (Cell *cur = this_cell;; cur = cur->next) {
        if (cur->data == d) {
            return cur;
        }
        if (cur->next == this_cell) {
            break;
        }
    }
    return NULL;
}

void Display(Cell *this_cell) {
    for (Cell *cur = this_cell;; cur = cur->next) {
        if (!cur->is_head) {
            printf("%d", cur->data);
        }
        if (cur->next == this_cell) {
            printf("\n");
            break;
        }
        if (!cur->is_head && !cur->next->is_head) {
            printf(" ");
        }
    }
}

void DisplayReverse(Cell *this_cell) {
    for (Cell *cur = this_cell;; cur = cur->prev) {
        if (!cur->is_head) {
            printf("%d", cur->data);
        }
        if (cur->prev == this_cell) {
            printf("\n");
            break;
        }
        if (!cur->is_head && !cur->prev->is_head) {
            printf(" ");
        }
    }
}

void ReadFromArray(Cell *this_cell, int *data, unsigned int len) {
    for (int i = 0; i < len; i++) {
        Cell *new_cell = CreateCell(data[i], false);
        InsertPrev(this_cell, new_cell);
    }
}
void WriteToArray(Cell *this_cell, int *data, unsigned int max_len) {
    int count = 0;
    Cell *cur = this_cell->next;
    while (cur != this_cell) {
        if (count >= max_len) {
            fprintf(stderr, "[Error] List exceeds max array length!\n");
            exit(EXIT_FAILURE);
        }
        data[count++] = cur->data;
        cur = cur->next;
    }
}

void ReadFromFile(Cell *this_cell, const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    int d;
    while (fscanf(file, "%d", &d) == 1) {
        Cell *new_cell = CreateCell(d, false);
        InsertPrev(this_cell, new_cell);
    }
    fclose(file);
}
void WriteToFile(Cell *this_cell, const char *filename) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    Cell *cur = this_cell->next;
    while (cur != this_cell) {
        fprintf(file, "%d\n", cur->data);
        cur = cur->next;
    }
    fclose(file);
}
