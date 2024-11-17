#include "queue.h"
#include <stdio.h>
#include <stdlib.h>

Queue *create_queue(int len) {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->buffer = (int *)malloc((len + 1) * sizeof(int));
    q->length = len + 1;
    q->front = 0;
    q->rear = 0;
    return q;
}

void enqueue(Queue *q, int d) {
    int pos = (q->rear + 1) % q->length;
    if (pos == q->front) {
        fprintf(stderr, "[Error] Queue is full!\n");
        exit(EXIT_FAILURE);
    }
    q->buffer[q->rear] = d;
    q->rear = pos;
}

int dequeue(Queue *q) {
    if (q->front == q->rear) {
        fprintf(stderr, "[Error] Queue is empty!\n");
        exit(EXIT_FAILURE);
    }
    int res = q->buffer[q->front];
    q->front = (q->front + 1) % q->length;
    return res;
}

void display(Queue *q) {
    for (int i = q->front; i != q->rear; i = (i + 1) % q->length) {
        printf("%d%c", q->buffer[i], " \n"[(i + 1 % q->length == q->rear)]);
    }
}

void delete_queue(Queue *q) {
    free(q->buffer);
    free(q);
}
