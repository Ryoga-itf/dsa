#include "binarytree.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Node *create_node(char *label, Node *left, Node *right) {
    Node *node = (Node *)malloc(sizeof(Node));
    node->label = strdup(label);
    node->left = left;
    node->right = right;
    return node;
}

void preorder_inner(Node *n) {
    if (n != NULL) {
        printf(" %s", n->label);
        preorder_inner(n->left);
        preorder_inner(n->right);
    }
}

void preorder(Node *n) {
    printf("PRE:");
    preorder_inner(n);
    printf("\n");
}

void inorder_inner(Node *n) {
    if (n != NULL) {
        inorder_inner(n->left);
        printf(" %s", n->label);
        inorder_inner(n->right);
    }
}

void inorder(Node *n) {
    printf("IN: ");
    inorder_inner(n);
    printf("\n");
}

void postorder_inner(Node *n) {
    if (n != NULL) {
        postorder_inner(n->left);
        postorder_inner(n->right);
        printf(" %s", n->label);
    }
}

void postorder(Node *n) {
    printf("POST: ");
    postorder_inner(n);
    printf("\n");
}

typedef struct queue {
    Node **buffer;
    int length;
    int front;
    int rear;
} Queue;

Queue *create_queue(int len) {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->buffer = (Node **)malloc((len + 1) * sizeof(Node));
    q->length = len + 1;
    q->front = 0;
    q->rear = 0;
    return q;
}

int isEmpty(Queue *q) { return q->front == q->rear; }

void enqueue(Queue *q, Node *d) {
    int pos = (q->rear + 1) % q->length;
    if (pos == q->front) {
        fprintf(stderr, "[Error] Queue is full!\n");
        exit(EXIT_FAILURE);
    }
    q->buffer[q->rear] = d;
    q->rear = pos;
}

Node *dequeue(Queue *q) {
    if (isEmpty(q)) {
        fprintf(stderr, "[Error] Queue is empty!\n");
        exit(EXIT_FAILURE);
    }
    Node *res = q->buffer[q->front];
    q->front = (q->front + 1) % q->length;
    return res;
}

void delete_queue(Queue *q) {
    free(q->buffer);
    free(q);
}

void breadth_first_search(Node *n) {
    printf("BFS: ");
    Queue *queue = create_queue(100);
    enqueue(queue, n);
    while (!isEmpty(queue)) {
        Node *current = dequeue(queue);
        if (current != NULL) {
            printf(" %s", current->label);
            enqueue(queue, current->left);
            enqueue(queue, current->right);
        }
    }
    delete_queue(queue);
    printf("\n");
}

void display_inner(Node *n) {
    if (n != NULL) {
        printf("%s(", n->label);
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

void height_inner(Node *n, int current, int *res) {
    if (n != NULL) {
        current++;
        height_inner(n->left, current, res);
        height_inner(n->right, current, res);
        if (*res < current) {
            *res = current;
        }
    }
}

int height(Node *n) {
    int res = 0;
    height_inner(n, 0, &res);
    return res;
}

void delete_tree(Node *n) {
    if (n != NULL) {
        delete_tree(n->left);
        delete_tree(n->right);
        free(n->label);
        free(n);
    }
}
