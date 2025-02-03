#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

bool *knapsackDP2(int v[], int w[], int n, int C);

int main(int argc, char **argv) {
    /* 教科書：表 6.1の例
       v[1]〜v[4]：価格
       w[1]〜w[4]：重さ */
    int num = 4;
    int v[] = {0, 250, 380, 420, 520};
    int w[] = {0, 1, 2, 4, 3};

    // 引数処理
    if (argc == 3) {
        int k = atoi(argv[1]);
        int i = atoi(argv[2]);
        bool *S = knapsackDP2(v, w, k, i);
        int total = 0;
        for (int k = 1; k <= num; k++)
            if (S[k]) {
                total = total + v[k];
                printf("重さ %d 価値 %d\n", w[k], v[k]);
            }
        printf("合計価値 %d\n", total);
        free(S);
    } else {
        fprintf(stderr, "Usage: knapsackDP2 <k: no. of items> <i: capacity>\n");
        return 1;
    }
    return 0;
}
