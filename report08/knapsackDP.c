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
    int **dp = (int **)malloc(sizeof(int *) * (++k + 1));
    for (int index = 0; index <= k; index++) {
        dp[index] = (int *)malloc(sizeof(int) * (i + 1));
    }

    for (int x = 0; x < k; x++) {
        for (int y = 0; y <= i; y++) {
            if (x == 0) {
                dp[x][y] = 0;
            }
            if (y >= w[x]) {
                dp[x + 1][y] = max(dp[x][y - w[x]] + v[x], dp[x][y]);
            } else {
                dp[x + 1][y] = dp[x][y];
            }
        }
    }

    int result = dp[k][i];
    for (int index = 0; index <= k; index++) {
        free(dp[index]);
    }
    free(dp);

    return result;
}
