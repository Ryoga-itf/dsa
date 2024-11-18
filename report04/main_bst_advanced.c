#include "bst_advanced.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    // Build an advanced binary search tree
    Node *root = NULL;
    root = insert_bst(root, 20);
    root = insert_bst(root, 10);
    root = insert_bst(root, 26);
    root = insert_bst(root, 14);
    root = insert_bst(root, 13);
    root = insert_bst(root, 5);

    inorder(root);
    display(root);

    printf("search_bst 14: %d\n", search_bst(root, 14));
    printf("search_bst 7: %d\n", search_bst(root, 7));
    printf("min_bst: %d\n", min_bst(root));

    root = delete_bst(root, 10);

    inorder(root);
    display(root);

    delete_tree(root);

    return EXIT_SUCCESS;
}
