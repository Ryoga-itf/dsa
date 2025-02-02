#define max(a, b) (a > b ? a : b)

/**
 * ナップサック問題の最適解を探索（動的計画法を用いない）
 * v: 価格の配列
 * w: 重さの配列
 * k: 対象とする荷物の数
 * i: ナップサックの容量
 */
int knapsack(int v[], int w[], int k, int i) {
    if (k == 0)
        return 0;

    // 選ばない
    const int exclude = knapsack(v, w, k - 1, i);

    // 選ぶ
    const int include =
        i - w[k] >= 0 ? knapsack(v, w, k - 1, i - w[k]) + v[k] : 0;

    return max(exclude, include);
}
