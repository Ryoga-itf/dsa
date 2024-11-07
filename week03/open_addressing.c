#include "open_addressing.h"
#include <stdio.h>
#include <stdlib.h>

DictOpenAddr *create_dict(int len) {
    DictOpenAddr *dict = (DictOpenAddr *)malloc(sizeof(DictOpenAddr));
    if (dict == NULL) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    dict->H = (DictData *)malloc(sizeof(DictData) * len);
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

int h(DictOpenAddr *dict, int d, int count) { return (d + count) % dict->B; }

void insert_hash(DictOpenAddr *dict, int d) {
    for (int count = 0; count < dict->B; count++) {
        int index = h(dict, d, count);
        if (dict->H[index].state != OCCUPIED) {
            dict->H[index].name = d;
            dict->H[index].state = OCCUPIED;
            return;
        }
    }
    fprintf(stderr, "[Error] Dictionary is full!");
    exit(EXIT_FAILURE);
}

int search_hash(DictOpenAddr *dict, int d) {
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

void delete_hash(DictOpenAddr *dict, int d) {
    int index = search_hash(dict, d);
    if (index != -1) {
        dict->H[index].state = DELETED;
    }
}

void display(DictOpenAddr *dict) {
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

void delete_dict(DictOpenAddr *dict) {
    if (dict) {
        free(dict->H);
        free(dict);
    }
}
