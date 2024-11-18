#include "bst_advanced.h"
#include <stdio.h>
#include <stdlib.h>

int get_height(Node *node) { return (node == NULL) ? 0 : node->height; }

void reset_height(Node *node) {
    if (node != NULL) {
        int left_height = get_height(node->left);
        int right_height = get_height(node->right);
        node->height =
            (left_height > right_height ? left_height : right_height) + 1;
    }
}

Node *create_node(int value) {
    Node *node = (Node *)malloc(sizeof(Node));
    node->value = value;
    node->height = 1;
    node->left = NULL;
    node->right = NULL;
    return node;
}

Node *insert_bst(Node *root, int value) {
    if (root == NULL) {
        return create_node(value);
    }
    if (value < root->value) {
        root->left = insert_bst(root->left, value);
    } else if (value > root->value) {
        root->right = insert_bst(root->right, value);
    }
    reset_height(root);
    return root;
}

Node *delete_min_bst(Node *root) {
    if (root == NULL)
        return NULL;

    if (root->left == NULL) {
        Node *right = root->right;
        free(root);
        return right;
    }
    root->left = delete_min_bst(root->left);
    reset_height(root);
    return root;
}

Node *delete_bst(Node *root, int value) {
    if (root == NULL) {
        return NULL;
    }

    if (value < root->value) {
        root->left = delete_bst(root->left, value);
    } else if (value > root->value) {
        root->right = delete_bst(root->right, value);
    } else {
        if (root->left == NULL) {
            Node *right = root->right;
            free(root);
            return right;
        } else if (root->right == NULL) {
            Node *left = root->left;
            free(root);
            return left;
        } else {
            Node *min_node = root->right;
            while (min_node->left != NULL) {
                min_node = min_node->left;
            }
            root->value = min_node->value;
            root->right = delete_min_bst(root->right);
        }
    }
    reset_height(root);
    return root;
}

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
        printf("%d#%d(", n->value, n->height);
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

void display_mermaid(Node *node) {
    if (node == NULL) {
        return;
    }

    if (node->left != NULL) {
        printf("%d --> %d\n", node->value, node->left->value);
        display_mermaid(node->left);
    } else {
        printf("%d --> nullL\n", node->value);
    }

    if (node->right != NULL) {
        printf("%d --> %d\n", node->value, node->right->value);
        display_mermaid(node->right);
    } else {
        printf("%d --> nullR\n", node->value);
    }
}

void delete_tree(Node *n) {
    if (n != NULL) {
        delete_tree(n->left);
        delete_tree(n->right);
        free(n);
    }
}
