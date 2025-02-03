#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int len;

/*
 * set[]: 正の整数の集合
 * n:     対象とする要素数
 * sum:   部分和
 */

bool *subsetSum(int *set, int n, int sum) {
    bool **dp = (bool **)malloc(sizeof(bool *) * (n + 1));
    bool *array = (bool *)malloc(sizeof(bool) * (n + 1) * (sum + 1));
    memset(array, 0, sizeof(bool) * (n + 1) * (sum + 1));
    for (int i = 0; i <= n; i++) {
        dp[i] = array + (sum + 1) * i;
        dp[i][0] = true;
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= sum; j++) {
            if (j - set[i] >= 0) {
                dp[i + 1][j] |= dp[i][j - set[i]];
            }
            dp[i + 1][j] |= dp[i][j];
        }
    }

    if (!dp[n][sum]) {
        free(dp[0]);
        free(dp);
        return NULL;
    }

    bool *S = (bool *)malloc(sizeof(bool) * len);
    memset(S, 0, sizeof(bool) * len);

    int current = sum;
    for (int i = n; i >= 0; i--) {
        if (current - set[i - 1] >= 0 && dp[i][current - set[i - 1]]) {
            S[i - 1] = true;
            current -= set[i - 1];
        }
    }

    free(dp[0]);
    free(dp);
    return S;
}
