#include <stdbool.h>
#include <stdlib.h>

/**
 * 二次元int配列の生成
 * rows: 行数
 * cols: 列数
 */
int **makeIntMatrix(int rows, int cols) {
    int **matrix = (int **)malloc(sizeof(int *) * (rows + 1));
    int *array = (int *)malloc(sizeof(int) * (rows + 1) * (cols + 1));
    for (int i = 0; i < rows + 1; i++) {
        matrix[i] = array + (cols + 1) * i;
    }
    return matrix;
}

/**
 * 二次元bool配列の生成
 * rows: 行数
 * cols: 列数
 */
bool **makeBoolMatrix(int rows, int cols) {
    bool **matrix = (bool **)malloc(sizeof(bool *) * (rows + 1));
    bool *array = (bool *)malloc(sizeof(bool) * (rows + 1) * (cols + 1));
    for (int i = 0; i < rows + 1; i++) {
        matrix[i] = array + (cols + 1) * i;
    }
    return matrix;
}

/**
 * ナップサック問題の最適解を探索（動的計画法）
 * v: 価格の配列
 * w: 重さの配列
 * n: 対象とする荷物の数
 * C: ナップサックの容量
 */
bool *knapsackDP2(int v[], int w[], int n, int C) {
    int **G = makeIntMatrix(n, C);
    bool **S = makeBoolMatrix(n, C);
    bool *SS = (bool *)malloc(sizeof(bool) * (n + 1));

    // 動的計画法のプログラム（配列S[][]を計算）
    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= C; j++) {
            if (i == 0 || j == 0) {
                G[i][j] = 0;
                S[i][j] = false;
            } else if (j >= w[i]) {
                const int include = G[i - 1][j - w[i]] + v[i];
                const int exclude = G[i - 1][j];
                if (include > exclude) {
                    G[i][j] = include;
                    S[i][j] = true;
                } else {
                    G[i][j] = exclude;
                    S[i][j] = false;
                }
            } else {
                G[i][j] = G[i - 1][j];
                S[i][j] = false;
            }
        }
    }

    // 配列G[][]と配列S[][]から選択された荷物の集合SS[]を計算
    int rC = C;
    for (int i = n; i >= 0; i--) {
        if (S[i][rC]) {
            SS[i] = true;
            rC -= w[i];
        } else {
            SS[i] = false;
        }
    }

    return SS;
}
