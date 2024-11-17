#include "double_hashing.h"
#include <stdio.h>
#include <stdlib.h>

DictDoubleHashing *create_dict(int len) {
    DictDoubleHashing *dict = malloc(sizeof(DictDoubleHashing));
    if (dict == NULL) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    dict->H = malloc(sizeof(DictData) * len);
    if (dict->H == NULL) {
        perror("malloc");
        free(dict);
        exit(EXIT_FAILURE);
    }
    dict->B = len;

    for (int i = 0; i < len; i++) {
        dict->H[i].state = EMPTY;
    }

    return dict;
}

int h_0(int d) { return d % 23; }

// B must be a prime
int g(int d, int B) { return (d % (B - 1)) + 1; }

int h(DictDoubleHashing *dict, int d, int count) {
    return (h_0(d) + count * g(d, dict->B)) % dict->B;
}

void insert_hash(DictDoubleHashing *dict, int d) {
    for (int count = 0; count < dict->B; count++) {
        int index = h(dict, d, count);
        if (dict->H[index].state != OCCUPIED) {
            dict->H[index].name = d;
            dict->H[index].state = OCCUPIED;
            return;
        }
    }

    fprintf(stderr, "[Error] Dictionary is full!\n");
    exit(EXIT_FAILURE);
}

int search_hash(DictDoubleHashing *dict, int d) {
    int res = -1;
    for (int count = 0; count < dict->B; count++) {
        int index = h(dict, d, count);
        if (dict->H[index].state == EMPTY) {
            break;
        }
        if (dict->H[index].state == OCCUPIED && dict->H[index].name == d) {
            res = index;
            break;
        }
    }

    return res;
}

void delete_hash(DictDoubleHashing *dict, int d) {
    int index = search_hash(dict, d);
    if (index != -1) {
        dict->H[index].state = DELETED;
    }
}

void display(DictDoubleHashing *dict) {
    for (int i = 0; i < dict->B; i++) {
        if (dict->H[i].state == OCCUPIED) {
            printf("%d", dict->H[i].name);
        } else if (dict->H[i].state == EMPTY) {
            printf("e");
        } else if (dict->H[i].state == DELETED) {
            printf("d");
        }
        printf("%c", " \n"[i == dict->B - 1]);
    }
}

void delete_dict(DictDoubleHashing *dict) {
    if (dict) {
        free(dict->H);
        free(dict);
    }
}
