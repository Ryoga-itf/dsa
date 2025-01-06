#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/plotst:0.2.0": *

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 6,
  name: "グラフアルゴリズム",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2025 年 1 月 6 日",
  date: "2024 年 1 月 6 日",
)

本課題を行った環境を以下に示す。

#sourcecode[```
$ cat /proc/version
Linux version 6.6.56_2 (voidlinux@voidlinux) (gcc (GCC) 13.2.0, GNU ld (GNU Binutils) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Oct 15 02:54:10 UTC 2024

$ gcc --version
gcc (GCC) 13.2.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make --version
GNU Make 4.4.1
Built for x86_64-unknown-linux-gnu
Copyright (C) 1988-2023 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```]

== 基本課題1: Dijkstra法の実装

=== 実装の方針

実装すべき関数ごとにその方針を述べる。

/ `void add(int u, bool S[])`:
  
  頂点 `u` を集合 `S` に追加する。この関数は `S[u]` が `false` であるとき、`S[u]` を `true` に変更する操作を行えばよい。
  また、頂点集合 S の要素数を表す変数 `Scount` をそれと同時に更新する。

/ `bool remain`:
  
  この関数は、訪問可能かつ未訪問な頂点があれば `true`、そうでなければ `false` を返す。
  これは単に `Scount` が `N` 未満かを判定すれば十分である。

/ `int select_min()`:

  この関数は、未訪問の頂点のうち最小コストで訪問可能な頂点を返す。
  未訪問である頂点 `i` は `S[i] == false` を満たす。よって、そのうち `d[i]` が最小のものを返せばよい。
  
/ `member(int u, int x)`:
  
  この関数は、頂点 `u` から頂点 `x` に辺があれば `true`、それ以外は `false` を返す。
  これは `w[u][x]` が `M` であるかを判定すれば十分である。

=== 実装コード及びその説明

実装した関数のコードを以下に示す。

#sourcecode[```c
void add(int u, bool S[]) {
    if (!S[u]) {
        S[u] = true;
        Scount++;
    }
}

bool remain() { return Scount < N; }

int select_min() {
    int min_index = -1;
    int min_value = M;
    for (int i = 0; i < N; i++) {
        if (!S[i] && d[i] < min_value) {
            min_value = d[i];
            min_index = i;
        }
    }
    return min_index;
}

bool member(int u, int x) { return w[u][x] != M; }
```]

コードの説明について、関数 `void add(int u, bool S[])`、`void remain()`、`member(int u, int x)` については、
実装の方針で十分詳細に述べたため省略する。

`int select_min()` の実装について説明する。
まず、到達可能な点が存在しない場合、`-1` を返す仕様のため、`min_index` をそれで初期化している。
この `min_index` は結果として返される値であり、ループ内で変更がなされなかった場合（つまり到達可能な点が存在しない場合）、初期値の `-1` が返る。
ループ内ではすべての頂点に対して、未訪問であり (`!S[i]`) かつコストが最小のもの (`d[i] < min_value`) を求め、それを更新していき最小コストで到達可能な頂点を探す。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、以下の通り実行を行った。また結果も示している。

#sourcecode[```
$ ./main_dijkstra 1
d: [ M 0 43 3 40 24 33 12 ]
```]

これは期待されているものと同一である。

また、グラフ 2 に適用した結果を以下に示す。

#sourcecode[```
$ for i in {0..7}; ./main_dijkstra $i     
d: [ 0 11 9 24 25 30 21 4 ]
d: [ 28 0 37 23 14 58 20 32 ]
d: [ 30 2 0 25 16 60 22 34 ]
d: [ M M M 0 M M M M ]
d: [ 83 55 74 9 0 51 6 25 ]
d: [ 32 4 23 22 18 0 19 36 ]
d: [ 108 80 99 3 25 76 0 50 ]
d: [ 58 30 49 20 21 26 17 0 ]

```]

=== 考察

`select_min` の実装が evil であり、かなり効率が悪い。
一回で時間計算量 $Omicron(N)$ も要してしまうため、ヒープ等で $log(N)$ ほどですむようにしたほうが効率的である。

そのような改善をすることで、時間計算量 $Omicron(|E| log |V|)$ を達成できる。
なお、辺の個数を $|V|$、頂点の個数を $|V|$ とした。

== 基本課題2: Dijkstra法における最短路の表示

=== 実装の方針

`dijkstra_util.c` における関数 `display_path` の実装の方針について述べる。

配列 `parent[]` には各頂点についてどの頂点から到達したかが記録される。
よって、再帰関数を用いて頂点から出発点へたどることができる。
また、`d[i] == M` を満たす頂点 `i` に対しては `unreachable` と出力すればよい。

=== 実装コード及びその説明

実装した `display_path` 関数のコードを以下に示す。
なお、再帰関数の実装のためにヘルパー関数の実装も含めている。

#sourcecode[```c
void display_path_helper(int *parent, int current, int origin) {
    if (current == origin) {
        printf("%d", current);
        return;
    }
    display_path_helper(parent, parent[current], origin);
    printf(" %d", current);
}

void display_path(int *parent, int origin) {
    for (int i = 0; i < N; i++) {
        printf("From %d to %d (w = ", origin, i);
        if (d[i] == M) {
            printf("M):  unreachable");
        } else {
            printf("%d):  ", d[i]);
            display_path_helper(parent, i, origin);
        }
        printf("\n");
    }
}
```]

頂点 `i` に対して、`d[i] == M` を満たすときは `unreachable`、すなわち到達不可であることを報告する。
そうでないときは `d[i]` の値、すなわち距離を出力したのち、
`display_path_helper` 関数を用いて最短路を出力している。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、以下の通り実行を行った。また結果も示している。

#sourcecode[```
$ ./main_dijkstra_path 1
d: [ M 0 43 3 40 24 33 12 ]
From 1 to 0 (w = M):  unreachable
From 1 to 1 (w = 0):  1
From 1 to 2 (w = 43):  1 7 5 2
From 1 to 3 (w = 3):  1 3
From 1 to 4 (w = 40):  1 7 4
From 1 to 5 (w = 24):  1 7 5
From 1 to 6 (w = 33):  1 7 5 6
From 1 to 7 (w = 12):  1 7
```]

これは期待されているものと同一である。

また、グラフ 2 に適用した結果を以下に示す。

#sourcecode[```
$ for i in {0..7}; ./main_dijkstra_path $i
d: [ 0 11 9 24 25 30 21 4 ]
From 0 to 0 (w = 0):  0
From 0 to 1 (w = 11):  0 2 1
From 0 to 2 (w = 9):  0 2
From 0 to 3 (w = 24):  0 3
From 0 to 4 (w = 25):  0 7 4
From 0 to 5 (w = 30):  0 7 5
From 0 to 6 (w = 21):  0 7 6
From 0 to 7 (w = 4):  0 7
d: [ 28 0 37 23 14 58 20 32 ]
From 1 to 0 (w = 28):  1 0
From 1 to 1 (w = 0):  1
From 1 to 2 (w = 37):  1 0 2
From 1 to 3 (w = 23):  1 4 6 3
From 1 to 4 (w = 14):  1 4
From 1 to 5 (w = 58):  1 4 7 5
From 1 to 6 (w = 20):  1 4 6
From 1 to 7 (w = 32):  1 4 7
d: [ 30 2 0 25 16 60 22 34 ]
From 2 to 0 (w = 30):  2 1 0
From 2 to 1 (w = 2):  2 1
From 2 to 2 (w = 0):  2
From 2 to 3 (w = 25):  2 4 6 3
From 2 to 4 (w = 16):  2 4
From 2 to 5 (w = 60):  2 4 7 5
From 2 to 6 (w = 22):  2 4 6
From 2 to 7 (w = 34):  2 4 7
d: [ M M M 0 M M M M ]
From 3 to 0 (w = M):  unreachable
From 3 to 1 (w = M):  unreachable
From 3 to 2 (w = M):  unreachable
From 3 to 3 (w = 0):  3
From 3 to 4 (w = M):  unreachable
From 3 to 5 (w = M):  unreachable
From 3 to 6 (w = M):  unreachable
From 3 to 7 (w = M):  unreachable
d: [ 83 55 74 9 0 51 6 25 ]
From 4 to 0 (w = 83):  4 7 5 1 0
From 4 to 1 (w = 55):  4 7 5 1
From 4 to 2 (w = 74):  4 7 5 2
From 4 to 3 (w = 9):  4 6 3
From 4 to 4 (w = 0):  4
From 4 to 5 (w = 51):  4 7 5
From 4 to 6 (w = 6):  4 6
From 4 to 7 (w = 25):  4 7
d: [ 32 4 23 22 18 0 19 36 ]
From 5 to 0 (w = 32):  5 1 0
From 5 to 1 (w = 4):  5 1
From 5 to 2 (w = 23):  5 2
From 5 to 3 (w = 22):  5 6 3
From 5 to 4 (w = 18):  5 1 4
From 5 to 5 (w = 0):  5
From 5 to 6 (w = 19):  5 6
From 5 to 7 (w = 36):  5 1 4 7
d: [ 108 80 99 3 25 76 0 50 ]
From 6 to 0 (w = 108):  6 4 7 5 1 0
From 6 to 1 (w = 80):  6 4 7 5 1
From 6 to 2 (w = 99):  6 4 7 5 2
From 6 to 3 (w = 3):  6 3
From 6 to 4 (w = 25):  6 4
From 6 to 5 (w = 76):  6 4 7 5
From 6 to 6 (w = 0):  6
From 6 to 7 (w = 50):  6 4 7
d: [ 58 30 49 20 21 26 17 0 ]
From 7 to 0 (w = 58):  7 5 1 0
From 7 to 1 (w = 30):  7 5 1
From 7 to 2 (w = 49):  7 5 2
From 7 to 3 (w = 20):  7 6 3
From 7 to 4 (w = 21):  7 4
From 7 to 5 (w = 26):  7 5
From 7 to 6 (w = 17):  7 6
From 7 to 7 (w = 0):  7
```]

=== 考察

アルゴリズムとしては、頂点ごとに「どこの頂点から来たのか」をメモしていき、それを順にたどっていくことで経路を復元する、というものである。

== 発展課題: Floydのアルゴリズムの実装

=== 実装の方針

実装するアルゴリズムは、概ね以下のようなものである。

- 中間点 `k` を経由した場合の距離を計算し、短ければ更新。
- 経路行列 `p[i][j]` を更新し、経路復元に使用。

また、経路復元のアルゴリズムは、概ね以下のようなものである。

- 経路行列 `p[m][n]` を辿りながらスタックに頂点を積む。
- スタックを使って経路を逆順に出力。

=== 実装コード及びその説明

作成した `main_floyd.c` を以下に示す。

#sourcecode[```c
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

void display() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            shortest_path(i, j);
        }
    }
}

int main() {
    floyd();
    display();
    return 0;
}
```]

実装上の注意点として、`M` は `INT_MAX` であり、
それに対する加算はオーバーフローを引き起こす恐れがあるため、
条件分岐を用いて事前に `M` であるかを判定して処理をしている。

`floyd` 関数においては、初期化として以下を行う。

- 距離行列 `d[i][j]` を初期グラフの隣接行列で初期化。
- 経路行列 `p[i][j]` を初期化し、経路なしの場合は `-1` を設定。

また、処理としては実装の方針で説明したアルゴリズムである。
なお、スタックの操作としてヘルパー関数 (`push`, `pop`) を導入している。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、以下の通り実行を行った。また結果も示している。

#sourcecode[```
$ ./main_floyd 0
From 0 to 0 (w = 0): 0
From 0 to 1 (w = 22): 0 7 1
From 0 to 2 (w = 42): 0 7 5 2
From 0 to 3 (w = 25): 0 7 1 3
From 0 to 4 (w = 39): 0 7 4
From 0 to 5 (w = 23): 0 7 5
From 0 to 6 (w = 32): 0 7 5 6
From 0 to 7 (w = 11): 0 7
From 1 to 0 (w = M): unreachable
From 1 to 1 (w = 0): 1
From 1 to 2 (w = 43): 1 7 5 2
From 1 to 3 (w = 3): 1 3
From 1 to 4 (w = 40): 1 7 4
From 1 to 5 (w = 24): 1 7 5
From 1 to 6 (w = 33): 1 7 5 6
From 1 to 7 (w = 12): 1 7
From 2 to 0 (w = M): unreachable
From 2 to 1 (w = 44): 2 5 3 1
From 2 to 2 (w = 0): 2
From 2 to 3 (w = 31): 2 5 3
From 2 to 4 (w = 75): 2 5 6 7 4
From 2 to 5 (w = 9): 2 5
From 2 to 6 (w = 18): 2 5 6
From 2 to 7 (w = 47): 2 5 6 7
From 3 to 0 (w = M): unreachable
From 3 to 1 (w = 13): 3 1
From 3 to 2 (w = 56): 3 1 7 5 2
From 3 to 3 (w = 0): 3
From 3 to 4 (w = 53): 3 1 7 4
From 3 to 5 (w = 37): 3 1 7 5
From 3 to 6 (w = 46): 3 1 7 5 6
From 3 to 7 (w = 25): 3 1 7
From 4 to 0 (w = M): unreachable
From 4 to 1 (w = 32): 4 7 1
From 4 to 2 (w = 52): 4 7 5 2
From 4 to 3 (w = 35): 4 7 1 3
From 4 to 4 (w = 0): 4
From 4 to 5 (w = 33): 4 7 5
From 4 to 6 (w = 42): 4 7 5 6
From 4 to 7 (w = 21): 4 7
From 5 to 0 (w = M): unreachable
From 5 to 1 (w = 35): 5 3 1
From 5 to 2 (w = 19): 5 2
From 5 to 3 (w = 22): 5 3
From 5 to 4 (w = 66): 5 6 7 4
From 5 to 5 (w = 0): 5
From 5 to 6 (w = 9): 5 6
From 5 to 7 (w = 38): 5 6 7
From 6 to 0 (w = M): unreachable
From 6 to 1 (w = 40): 6 7 1
From 6 to 2 (w = 60): 6 7 5 2
From 6 to 3 (w = 43): 6 7 1 3
From 6 to 4 (w = 57): 6 7 4
From 6 to 5 (w = 41): 6 7 5
From 6 to 6 (w = 0): 6
From 6 to 7 (w = 29): 6 7
From 7 to 0 (w = M): unreachable
From 7 to 1 (w = 11): 7 1
From 7 to 2 (w = 31): 7 5 2
From 7 to 3 (w = 14): 7 1 3
From 7 to 4 (w = 28): 7 4
From 7 to 5 (w = 12): 7 5
From 7 to 6 (w = 21): 7 5 6
From 7 to 7 (w = 0): 7
```]

これは期待されているものと同一である。

また、適切に動作していることを、前課題で作成した `main_dijkstra_path` を使用して出力を比較した。
すると、出力された最短経路は同じものであった。

=== 考察

このアルゴリズムは、重み付きグラフにおいて、すべての頂点間の最短距離を求める効率的な方法であると考えられる。
特に、その時間計算量は $Omicron(N^3)$、空間計算量は $Omicron(N^2)$ である。
実装がシンプルであるため、ダイクストラ法ですべての頂点ペアの最短距離を求めるよりも効率が良い。
一般に、メモリは連続に・近傍にアクセスする方がキャッシュヒットしやすくなるため、
単に for ループを三重にしたものであると、CPU のキャッシュヒット率が高くなり、効率的であると考えられる。

とはいっても、$Omicron(N^3)$ であるので大規模なグラフには向かない。

アルゴリズムは、始点、中継地、終点の組み合わせを全部試していく動的計画法のようなアプローチである。

適切に実装することで、負の重みを持つグラフに対しても適用でき、また負の閉路があるかどうかを検出することもできる。

また、隣接行列をそのまま更新できるため、もともと隣接行列で表現されているグラフに対しては適用が楽である。
そうでない場合、一旦隣接行列表現に変換する必要があり、若干手間である。
