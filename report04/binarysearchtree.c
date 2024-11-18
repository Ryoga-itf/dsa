#include "binarysearchtree.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int min_bst(Node *root) {
    if (root == NULL) {
        return -1;
    }
    Node *current = root;
    while (current->left != NULL) {
        current = current->left;
    }
    return current->value;
}

bool search_bst(Node *root, int d) {
    if (root == NULL) {
        return false;
    }
    if (d == root->value) {
        return true;
    } else if (d < root->value) {
        return search_bst(root->left, d);
    } else {
        return search_bst(root->right, d);
    }
}

void insert_bst(Node **root, int d) {
    if (*root == NULL) {
        *root = (Node *)malloc(sizeof(Node));
        (*root)->value = d;
        (*root)->left = NULL;
        (*root)->right = NULL;
    } else if (d < (*root)->value) {
        insert_bst(&(*root)->left, d);
    } else if (d > (*root)->value) {
        insert_bst(&(*root)->right, d);
    }
}

void delete_bst(Node **root, int d) {
    if (*root == NULL) {
        return;
    }

    if (d < (*root)->value) {
        delete_bst(&(*root)->left, d);
    } else if (d > (*root)->value) {
        delete_bst(&(*root)->right, d);
    } else {
        if ((*root)->left == NULL && (*root)->right == NULL) {
            free(*root);
            *root = NULL;
        } else if ((*root)->left == NULL) {
            Node *temp = *root;
            *root = (*root)->right;
            free(temp);
        } else if ((*root)->right == NULL) {
            Node *temp = *root;
            *root = (*root)->left;
            free(temp);
        } else {
            Node *successor = (*root)->right;
            while (successor->left != NULL) {
                successor = successor->left;
            }
            (*root)->value = successor->value;
            delete_bst(&(*root)->right, successor->value);
        }
    }
}

void inorder_inner(Node *n) {
    if (n != NULL) {
        inorder_inner(n->left);
        printf(" %d", n->value);
        inorder_inner(n->right);
    }
}

void inorder(Node *n) {
    printf("IN:");
    inorder_inner(n);
    printf("\n");
}

void display_inner(Node *n) {
    if (n != NULL) {
        printf("%d(", n->value);
        display_inner(n->left);
        printf(",");
        display_inner(n->right);
        printf(")");
    } else {
        printf("null");
    }
}

void display(Node *n) {
    printf("TREE: ");
    display_inner(n);
    printf("\n");
}

void delete_tree(Node *n) {
    if (n != NULL) {
        delete_tree(n->left);
        delete_tree(n->right);
        free(n);
    }
}
