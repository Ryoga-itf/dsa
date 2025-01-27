#include "common.h"
#include "dijkstra_util.h"
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

bool S[N];
int Scount = 0; // 頂点集合Sの要素数
int d[N];
int parent[N];

/**
 * ダイクストラ法で，頂点 p から各頂点への最短路の重みを計算する．
 * @param p 開始点
 * @return なし
 */
void dijkstra(int p) {
    add(p, S);

    for (int i = 0; i < N; i++) {
        d[i] = w[p][i];
        parent[i] = p;
    }

    while (remain()) {
        int u = select_min();
        if (u == -1) {
            break;
        } else {
            add(u, S);
        }

        for (int x = 0; x < N; x++) {
            if (member(u, x)) {
                int k = d[u] + w[u][x];
                if (d[x] == M) {
                    d[x] = k;
                    parent[x] = u;
                } else if (k < d[x]) {
                    d[x] = k;
                    parent[x] = u;
                }
            }
        }
    }
}

/**
 * メイン関数．
 * @param argc
 * @param argv
 * @return 終了ステータス 0
 */
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: ./main_dijkstra <node ID>\n");
        return 1;
    }

    int p = atoi(argv[1]);
    if (p < 0 || N <= p) {
        fprintf(stderr, "Node ID %d is out of range: [0, %d].\n", p, N);
        return 1;
    }

    for (int i = 0; i < N; i++) {
        S[i] = false;
    }

    dijkstra(p);     // ダイクストラ法による最短路の計算
    display("d", d); // 結果表示
    display_path(parent, p);

    return 0;
}
