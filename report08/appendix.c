
#include <stdio.h>
int main() {
    /* 教科書：表 6.1の例
       v[1]〜v[4]：価格
       w[1]〜w[4]：重さ */
    int v[] = {0, 250, 380, 420, 520};
    int w[] = {0, 1, 2, 4, 3};

    for (int s = 0; s < (1 << 4); s++) {
        printf("選ぶ組 (index): ");
        int sum_v = 0;
        int sum_w = 0;
        for (int i = 0; i < 4; i++) {
            if (s & (1 << i)) {
                printf("%d ", i + 1);
                sum_v += v[i + 1];
                sum_w += w[i + 1];
            }
        }
        printf("\n");
        printf("    sum_v: %d\n", sum_v);
        printf("    sum_w: %d\n", sum_w);
    }

    return 0;
}
