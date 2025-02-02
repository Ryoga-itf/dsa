#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/cetz:0.3.1"
#import "@preview/cetz-plot:0.1.0": plot, chart

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
