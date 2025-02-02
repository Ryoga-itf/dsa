#include <stdlib.h>
#define max(a, b) (a > b ? a : b)

/**
 * ナップサック問題の最適解を探索（動的計画法）
 * v: 価格の配列
 * w: 重さの配列
 * k: 対象とする荷物の数
 * i: ナップサックの容量
 */
int knapsackDP(int v[], int w[], int k, int i) {
    int **dp = (int **)malloc(sizeof(int *) * (k + 1));
    int *array = (int *)malloc(sizeof(int) * (k + 1) * (i + 1));
    for (int index = 0; index <= k; index++) {
        dp[index] = array + (i + 1) * index;
    }

    for (int x = 0; x <= k; x++) {
        for (int y = 0; y <= i; y++) {
            if (x == 0 || y == 0) {
                dp[x][y] = 0;
            } else if (y >= w[x]) {
                dp[x][y] = max(dp[x - 1][y - w[x]] + v[x], dp[x - 1][y]);
            } else {
                dp[x][y] = dp[x - 1][y];
            }
        }
    }

    int result = dp[k][i];

    free(dp[0]);
    free(dp);

    return result;
}
