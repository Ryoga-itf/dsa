#ifndef INCLUDE_GUARD_DOUBLE_HASHING_H
#define INCLUDE_GUARD_DOUBLE_HASHING_H

typedef enum state { EMPTY, DELETED, OCCUPIED } State;

typedef struct dict_data {
    int name;
    State state;
} DictData;

typedef struct dict_double_hashing {
    DictData *H;
    int B;
} DictDoubleHashing;

DictDoubleHashing *create_dict(int len);
int h(DictDoubleHashing *dict, int d, int count);
int g(int d, int B);
void display(DictDoubleHashing *dict);
void insert_hash(DictDoubleHashing *dict, int d);
int search_hash(DictDoubleHashing *dict, int d);
void delete_hash(DictDoubleHashing *dict, int d);
void delete_dict(DictDoubleHashing *dict);

#endif // INCLUDE_GUARD_DOUBLE_HASHING_H
