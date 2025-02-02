#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/cetz:0.3.1"
#import "@preview/cetz-plot:0.1.0": plot, chart

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 8,
  name: "動的計画法",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2025 年 2 月 3 日",
  date: "2025 年 2 月 3 日",
)

#set math.equation(numbering: "1.")

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

== 基本課題1

=== 実装の方針

課題で示された以下の @eq1 を元にコードを組み立てればよい。
しかし、後述する理由により一時変数を導入して実装している。

$
G_(k, i) = cases(
  G_(k-1, i)                           && "if" i - w_k < 0,
  max(G_(k-1, i), G_(k-1,i-w_k) + v_k) && "otherwise"
)
$ <eq1>

なお、$k = 0$ であるとき、配列外参照が発生するため、条件分岐により 0 を返すようにする。

=== 実装コード及びその説明

実装した `knapsack.c` を @code1-1 に示す。
なお、与えられた `knapsack.c` には `#include` が含まれていたが、それらは一切必要ないものであったので削除している。
また、`max` マクロは参考実装で与えられたものをそのまま利用している。

#figure(
  sourcefile(read("./knapsack.c"), file:"./knapsack.c"),
  caption: [基本課題 1 の実装コード]
) <code1-1>

@eq1 をナイーブにそのまま実装しようとすると、@code1-2 になるが、
`max` はマクロであり、プリプロセッサによりそのまま展開され、考えられないほど非常に遅くなってしまう。
つまりは、`(knapsack(v, w, k - 1, i) > knapsack(v, w, k - 1, i - w[k]) + v[k] ? knapsack(v, w, k - 1, i) : knapsack(v, w, k - 1, i - w[k]) + v[k])` と展開され、複数回関数が評価されてしまう。
さらに、この関数は再帰関数であるから、手に負えないほど分岐が増えてしまう。

@code1-2 では、#link(<1.2>)[基本課題1.2]を確認するのは無理があると考え、一時変数を導入した @code1-1 とした。

#figure(
  sourcecode[
```c
#define max(a, b) (a > b ? a : b)

int knapsack(int v[], int w[], int k, int i) {
    if (k == 0)
        return 0;

    if (w[k] > i) {
        return knapsack(v, w, k - 1, i);
    } else {
        return max(
            knapsack(v, w, k - 1, i),
            knapsack(v, w, k - 1, i - w[k]) + v[k]
        );
    }
}
```
  ],
  caption: [一時変数を導入しない場合のコード]
) <code1-2>

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、@code1-3 の通り実行を行った。また結果も示している。

#figure(
  sourcecode[```
  $ make knapsack
  cc    -c -o knapsack.o knapsack.c
  cc   knapsack.o knapsackMain.o   -o knapsack

  $ ./knapsack 4 4     
  結果：770

  $ ./knapsack 5  
  容量：25
  結果：223
  実行時間：0.000004 sec.

  $
  ```],
  caption: "実行結果"
) <code1-3>

=== 基本課題 1.1

本課題は、教科書の表 6.1の例に関して，荷物の数が4, 容量が3,4,5の場合の実行結果が正しいことを確認するというものである。

実行結果を @code1-4 に示す。

#figure(
  sourcecode[```
  $ ./knapsack 4 3     
  結果：630

  $ ./knapsack 4 4
  結果：770

  $ ./knapsack 4 5
  結果：900

  $
  ```],
  caption: "教科書の表 6.1の例に関して、荷物の数が4、容量が3,4,5の場合の実行結果"
) <code1-4>

実行結果が正しいことを確認する。

/ 容量が 3 の場合:
  
  - 1 番目の荷物（重さ 1, 価値 250）
  - 2 番目の荷物（重さ 2, 価値 380）

  を選ぶとき価値の合計は 630 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。
  
/ 容量が 4 の場合:
  
  - 1 番目の荷物（重さ 1, 価値 250）
  - 4 番目の荷物（重さ 4, 価値 520）

  を選ぶとき価値の合計は 770 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。

/ 容量が 5 の場合:
  
  - 2 番目の荷物（重さ 1, 価値 380）
  - 4 番目の荷物（重さ 4, 価値 520）

  を選ぶとき価値の合計は 900 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。

以上より、本課題の要件を確認することができた。

=== 基本課題 1.2 <1.2>

本課題は、knapsack 関数の実行時間が荷物の数に関して指数関数的であることを、確認するというものである。

作成したプログラムに対して、荷物の数として与える引数が25〜30の場合の実行時間を確認する。
その様子を @code1-5 に示す。

#figure(
  sourcecode[```
  $ seq 25 30 | xargs -I {} ./knapsack {}
  容量：125
  結果：1300
  実行時間：0.245991 sec.
  容量：130
  結果：1344
  実行時間：0.456756 sec.
  容量：135
  結果：1090
  実行時間：0.881770 sec.
  容量：140
  結果：1287
  実行時間：1.753688 sec.
  容量：145
  結果：1246
  実行時間：3.529323 sec.
  容量：150
  結果：1333
  実行時間：7.159160 sec.

  $
  ```],
  caption: "物の数が25〜30の場合の実行時間を確認した様子"
) <code1-5>

この実行結果をまとめると、@table1 のようになる。

#let data = (
  (25, 0.245991),
  (26, 0.456756),
  (27, 0.881770),
  (28, 1.753688),
  (29, 3.529323),
  (30, 7.159160),
)

#figure(
  table(
    columns: (auto, auto),
    inset: 7pt,
    align: center,
    table.header(
      [*$N$*], [*実行時間 (秒)*],
    ),
    ..data.flatten().map(v => [$#v$])
  ),
  caption: [物の数が25〜30の場合の実行時間]
) <table1>

また、グラフとしてプロットすると @fig1 のようになり、概ね指数関数的に実行時間が増えていることが確認できる。

#figure(
  cetz.canvas({
    plot.plot(
      size: (15, 9),
      x-label: [$N$],
      x-min: 25,
      x-max: 30,
      x-grid: "major",
      x-tick-step: 1,
      y-tick-step: 0.5,
      y-label: [実行時間 (秒)],
      y-max: 7.5,
      y-min: 0,
      y-grid: "major",
      {
        plot.add(data)
      }
    )
  }),
  caption: [@table1 をグラフにプロットした様子]
) <fig1>

== 基本課題2

=== 実装の方針

$"dp"[x][y] := x "番目までの荷物の中から重さが" y "を超えないように選んだときの、価値の総和の最大値"$

とすると、以下の手順により $"dp"[x - 1][y]$ からこの値は求めることができるから、動的計画法を用いて解くことができる。

- $x = 0$ または $y = 0$ であるとき、$"dp"[x][y] = 0$
- 品物 ($w[x], v[x]$) を選ぶ場合 ($y >= w[x]$ の場合に限る)
  - $"dp"[x][y] = "dp"[x - 1][y - w[x]] + v[x]$
- 品物 ($w[x], v[x]$) を選ばない場合
  - $"dp"[x][y] = "dp"[x - 1][y]$

と更新できる。
$"dp"$ は価値の総和の最大値であるから、これらの操作のうち大きい方を取っていくように更新していけばよい。 

=== 実装コード及びその説明

実装した `knapsackDP.c` を @code2-1 に示す。

なお、VLA が使える環境ではあるが `knapsackMain.c` に倣って `malloc` 及び `free` を読んでいるため、メモリの動的確保及び解放が煩雑になっている。
メモリにおいては内部で連続するようにアロケーションする実装にしたため、`free(dp[0])` のように先頭番地を free するだけで十分である。

また、`max` マクロは参考実装で与えられたものをそのまま利用している。

#figure(
  sourcefile(read("./knapsackDP.c"), file:"./knapsackDP.c"),
  caption: [基本課題 2 の実装コード],
) <code2-1>

このコードは実装の方針で述べたものの通りに実装している。

以下に主要部分の説明を述べる。

1. *メモリ確保*

#sourcecode(numbers-start: 12)[```c
int **dp = (int **)malloc(sizeof(int *) * (k + 1));
int *array = (int *)malloc(sizeof(int) * (k + 1) * (i + 1));
for (int index = 0; index <= k; index++) {
    dp[index] = array + (i + 1) * index;
}
```]

- `dp` は動的に確保された二次元配列。
- `dp[x][y]` は荷物 `x` 個を使い、容量 `y` のナップサックで得られる最大価値を表す。
- 一度だけメモリを確保し、行ごとにポインタを設定することでメモリ効率を向上させている。

2. *DPテーブルの計算*


#sourcecode(numbers-start: 18)[```c
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
```]

- 初期条件: `dp[0][y] = 0` または `dp[x][0] = 0` では価値はゼロ。
- 荷物がナップサック容量に収まる場合、`max(dp[x - 1][y - w[x]] + v[x], dp[x - 1][y])` の最大値を選ぶ。
- 荷物が容量を超える場合、`dp[x][y] = dp[x - 1][y]` を選択する。

3. *結果取得とメモリ解放*

#sourcecode(numbers-start: 30)[```c
int result = dp[k][i];

free(dp[0]);
free(dp);
```]

- 計算結果を `result` に保存し、確保したメモリを解放する。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、@code2-2 の通り実行を行った。また結果も示している。

#figure(
  sourcecode[```
  $ make knapsackDP
  cc    -c -o knapsackDP.o knapsackDP.c
  cc   knapsackDP.o knapsackDPMain.o   -o knapsackDP

  $ ./knapsackDP 4 4 
  結果：770

  $ ./knapsackDP 5  
  容量：25
  結果：345
  実行時間：0.000005 sec.

  $
  ```],
  caption: "実行結果"
) <code2-2>

=== 基本課題 2.1

本課題は、教科書の表 6.1の例に関して，荷物の数が4, 容量が3,4,5の場合の実行結果が正しいことを確認するというものである。

実行結果を @code2-3 に示す。

#figure(
  sourcecode[```
  $ ./knapsackDP 4 3     
  結果：630

  $ ./knapsackDP 4 4
  結果：770

  $ ./knapsackDP 4 5
  結果：900

  $
  ```],
  caption: "教科書の表 6.1の例に関して、荷物の数が4、容量が3,4,5の場合の実行結果"
) <code2-3>

実行結果が正しいことを確認する。

/ 容量が 3 の場合:
  
  - 1 番目の荷物（重さ 1, 価値 250）
  - 2 番目の荷物（重さ 2, 価値 380）

  を選ぶとき価値の合計は 630 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。
  
/ 容量が 4 の場合:
  
  - 1 番目の荷物（重さ 1, 価値 250）
  - 4 番目の荷物（重さ 4, 価値 520）

  を選ぶとき価値の合計は 770 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。

/ 容量が 5 の場合:
  
  - 2 番目の荷物（重さ 1, 価値 380）
  - 4 番目の荷物（重さ 4, 価値 520）

  を選ぶとき価値の合計は 900 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。

以上より、本課題の要件を確認することができた。

=== 基本課題 2.2

// TODO:

== 発展課題1

=== 実装の方針

=== 実装コード及びその説明

実装した `knapsackDP2.c` を @code3-1 に示す。

#show figure: set block(breakable: true)

#figure(
  sourcefile(read("./knapsackDP2.c"), file:"./knapsackDP2.c"),
  caption: [発展課題 1 の実装コード],
) <code3-1>


また、`knapsackDP2Main.c` において `knapsackDP2` の結果を保持している変数 `S` のメモリ解放処理が無かったため、
`printf("合計価値 %d\n", total);` の行の後ろに `free(S);` を入れた。（もっともこの後にプロセスがすぐ死ぬので不要ではあるが、一般的には適切でないと考えられることが多いため）

また、`makeIntMatrix` や `makeBoolMatrix` で得られる配列は内部のメモリは連続しているため、`0` 番目を free すればよいと考え、そのように実装している。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、@code3-2 の通り実行を行った。また結果も示している。

#figure(
  sourcecode[```
  $ make knapsackDP2
  cc    -c -o knapsackDP2.o knapsackDP2.c
  cc    -c -o knapsackDP2Main.o knapsackDP2Main.c
  cc   knapsackDP2.o knapsackDP2Main.o   -o knapsackDP2

  $ ./knapsackDP2 4 5
  重さ 2 価値 380
  重さ 3 価値 520
  合計価値 900

  $
  ```],
  caption: "実行結果"
) <code3-2>

== 発展課題2 部分和問題

=== 実装の方針

=== 実装コード及びその説明

実装した `subsetSum.c` を @code4-1 に示す。

#show figure: set block(breakable: true)

#figure(
  sourcefile(read("./subsetSum.c"), file:"./subsetSum.c"),
  caption: [発展課題 2 の実装コード],
) <code4-1>

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、@code4-2 の通り実行を行った。また結果も示している。

#figure(
  sourcecode[```
  $ make subsetSum
  cc    -c -o subsetSum.o subsetSum.c
  cc    -c -o subsetSumMain.o subsetSumMain.c
  cc   subsetSum.o subsetSumMain.o   -o subsetSum

  $ ./subsetSum 4 21
  部分集合3 7 11

  $ ./subsetSum 4 22
  部分集合7 15

  $ ./subsetSum 4 23
  条件を満たす部分集合はない．

  $
  ```],
  caption: "実行結果"
) <code4-2>
