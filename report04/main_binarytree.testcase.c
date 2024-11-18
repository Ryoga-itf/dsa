#include "binarytree.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    // Build a binary tree

    Node *h = create_node("H", NULL, NULL);
    Node *g = create_node("G", NULL, NULL);
    Node *i = create_node("I", NULL, NULL);

    Node *d = create_node("D", NULL, NULL);
    Node *e = create_node("E", NULL, i);
    Node *f = create_node("F", h, g);

    Node *c = create_node("C", d, e);
    Node *b = create_node("B", f, NULL);

    Node *a = create_node("A", c, b);

    preorder(a);
    inorder(a);
    postorder(a);
    breadth_first_search(a);
    display(a);

    printf("height: %d\n", height(a));

    delete_tree(a);

    return EXIT_SUCCESS;
}
