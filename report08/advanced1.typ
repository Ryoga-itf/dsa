#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/cetz:0.3.1"
#import "@preview/cetz-plot:0.1.0": plot, chart

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

=== 発展課題1.1

本課題は、教科書の表 6.1の例に関して，荷物の数が4, 容量が3,4,5の場合の実行結果が正しいことを確認するというものである。

実行結果を @code3-3 に示す。

#figure(
  sourcecode[```
  $ ./knapsackDP2 4 3  
  重さ 1 価値 250
  重さ 2 価値 380
  合計価値 630

  $ ./knapsackDP2 4 4
  重さ 1 価値 250
  重さ 3 価値 520
  合計価値 770

  $ ./knapsackDP2 4 5
  重さ 2 価値 380
  重さ 3 価値 520
  合計価値 900

  $
  ```],
  caption: "教科書の表 6.1の例に関して、荷物の数が4、容量が3,4,5の場合の実行結果"
) <code3-3>

実行結果が正しいことを確認する。
なお、具体的な確認方法については Appendix を参照。

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

=== 発展課題1.2

// TODO:

=== 考察

// TODO:
