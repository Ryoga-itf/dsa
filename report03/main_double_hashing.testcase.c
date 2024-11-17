#include "double_hashing.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    DictDoubleHashing *test_dict = create_dict(5);

    insert_hash(test_dict, 1);
    insert_hash(test_dict, 6);
    insert_hash(test_dict, 11);
    insert_hash(test_dict, 1);
    insert_hash(test_dict, 1);
    display(test_dict);

    printf("Search 1 ...\t%d\n", search_hash(test_dict, 1));
    printf("Search 6 ...\t%d\n", search_hash(test_dict, 6));
    printf("Search 11 ...\t%d\n", search_hash(test_dict, 11));

    insert_hash(test_dict, 1);

    return EXIT_SUCCESS;
}
