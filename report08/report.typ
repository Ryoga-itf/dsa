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

実装した `knapsack.c` を @code1 に示す。
なお、与えられた `knapsack.c` には `#include` が含まれていたが、それらは一切必要ないものであったので削除している。
また、`max` マクロは参考実装で与えられたものをそのまま利用している。

#figure(
  sourcefile(read("./knapsack.c"), file:"./knapsack.c"),
  caption: [基本課題 1 の実装コード]
) <code1>

@eq1 をナイーブにそのまま実装しようとすると、@code2 になるが、
`max` はマクロであり、プリプロセッサによりそのまま展開され、考えられないほど非常に遅くなってしまう。
つまりは、`(knapsack(v, w, k - 1, i) > knapsack(v, w, k - 1, i - w[k]) + v[k] ? knapsack(v, w, k - 1, i) : knapsack(v, w, k - 1, i - w[k]) + v[k])` と展開され、複数回関数が評価されてしまう。
さらに、この関数は再帰関数であるから、手に負えないほど分岐が増えてしまう。

@code2 では、#link(<1.2>)[基本課題1.2]を確認するのは無理があると考え、一時変数を導入した @code1 とした。

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
) <code2>

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、@code3 の通り実行を行った。また結果も示している。

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
) <code3>

=== 基本課題 1.1

本課題は、教科書の表 6.1の例に関して，荷物の数が4, 容量が3,4,5の場合の実行結果が正しいことを確認するというものである。

実行結果を @code4 に示す。

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
) <code4>


=== 基本課題 1.2 <1.2>

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
)

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
)

== 基本課題2

=== 実装の方針

=== 実装コード及びその説明

実装した `knapsackDP.c` を @code5 に示す。

なお、VLA が使える環境ではあるが `knapsackMain.c` に倣って `malloc` 及び `free` を読んでいるため、メモリの動的確保及び解放が煩雑になっている。
また、`max` マクロは参考実装で与えられたものをそのまま利用している。

#figure(
  sourcefile(read("./knapsackDP.c"), file:"./knapsackDP.c"),
  caption: [基本課題 2 の実装コード]
) <code5>

=== 実行結果

== 発展課題1

=== 実装の方針

=== 実装コード及びその説明

=== 実行結果


== 発展課題2 部分和問題

=== 実装の方針

=== 実装コード及びその説明

=== 実行結果
