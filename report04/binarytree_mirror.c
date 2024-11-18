#include "./binarytree_mirror.h"
#include <stddef.h>
#include <string.h>

Node *create_mirror(Node *n) {
    if (n == NULL) {
        return NULL;
    }
    return create_node(n->label, create_mirror(n->right),
                       create_mirror(n->left));
}

bool are_mirrors(Node *n0, Node *n1) {
    if (n0 == NULL && n1 == NULL) {
        return true;
    } else if (n0 == NULL || n1 == NULL) {
        return false;
    }

    return strcmp(n0->label, n1->label) == 0 &&
           are_mirrors(n0->left, n1->right) && are_mirrors(n0->right, n1->left);
}
