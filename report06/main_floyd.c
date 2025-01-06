#include "common.h"
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>

int d[N][N];
int p[N][N];
int stack[N];
int stack_p = -1;

void push(int x) { stack[++stack_p] = x; }

int pop() { return stack[stack_p--]; }

/**
 * Floydのアルゴリズムで，全ての頂点間の最短経路と重みを計算．
 * @return なし
 */
void floyd() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            d[i][j] = w[i][j];
            if (i == j || w[i][j] == M) {
                p[i][j] = -1; // unreachable
            } else {
                p[i][j] = i;
            }
        }
    }
    for (int k = 0; k < N; k++) {
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (d[i][k] != M && d[k][j] != M &&
                    d[i][k] + d[k][j] < d[i][j]) {
                    d[i][j] = d[i][k] + d[k][j];
                    p[i][j] = p[k][j];
                }
            }
        }
    }
}

/**
 * 頂点mからnまでの最短路を出力．
 * @param m 始点
 * @param n 終点
 * @return なし
 */
void shortest_path(int m, int n) {
    printf("From %d to %d ", m, n);
    if (d[m][n] == M) {
        printf("(w = M): unreachable\n");
        return;
    }
    printf("(w = %d): ", d[m][n]);

    int current = n;
    while (current != -1 && current != m) {
        push(current);
        current = p[m][current];
    }
    push(m);

    while (stack_p >= 0) {
        printf("%d", pop());
        if (stack_p >= 0) {
            printf(" ");
        }
    }
    printf("\n");
}

/**
 * 任意の頂点間の最短路及び重さを表示．
 * @return 終了ステータス　0
 *
 */
void display() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            shortest_path(i, j);
        }
    }
}

/**
 * メイン関数．
 * @return 終了ステータス 0
 */
int main() {
    floyd();
    display();
    return 0;
}
