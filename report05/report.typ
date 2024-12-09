#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/plotst:0.2.0": *

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 4,
  name: "整列",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2024 年 12 月 9 日",
  date: "2024 年 12 月 9 日",
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

== 基本課題: 課題共通の関数の実装

=== 実装の方針

`bool is_sorted(int a[], int n)` 関数は長さが `n` の配列 `a` が整列されているか確認するための関数である。
これは、隣接する要素を順に $a, b$ とすると $a <= b$ が全ての箇所で成り立てばよい。
小さい方から順に見ていけば、時間計算量 $Omicron (n)$ と配列の長さに対して十分高速に実現できる。

`void display(int a[], int n)` 関数は、長さが `n` の配列 `a` に含まれる要素を標準出力に表示する関数である。
配列の要素数を半角スペース 1 文字で区切り、最後の要素のあとには改行を含めなければならない。
これは配列を順に舐めていき、最後の要素でないときはスペースを、最後の要素であるときは改行 (`\n`) を出力すればよい。

選択ソートの実装は単純に `for` ループを二重に書けば実現できる。
実装の方針を説明するほど複雑でないためここでは省略する。

=== 実装コード及びその説明

実装した `sort_util.c` を以下に示す。
前節で述べた `is_sorted` と `display` 関数の実装が該当する。

なお、実装コードにおいては C99 以降の仕様を前提としている。また、これ以降も同様である。

#sourcefile(read("./sort_util.c"), file:"./sort_util.c")

配列外参照の問題を防ぐため、`is_sorted` では配列のインデックスを `1` から見て、それと前の要素が前節で示した条件を満たさないときは早期リターンをする実装になっている。
すべて条件を満たす、すなわち条件を満たさない組がない場合は `true` が返る。

`display` 関数では、配列が最後の要素であるかを `i == n - 1` で判定している。
暗黙の型変換により、この条件を満たすときは `" \n"[1]` と解釈され、改行 (`\n`) が出力される。
それ以外は、`" \n"[0]` と解釈され、半角スペース 1 文字が出力される。

次に、実装した `selection_sort.c` を以下に示す。

#sourcefile(read("./selection_sort.c"), file:"./selection_sort.c")

選択ソートは、配列を部分ごとに分割し、未ソート部分から最小値を見つけて先頭と交換するアルゴリズムである。

外側のループ（4 行目）は、配列を左から順に処理する。
`i` は現在の先頭位置（ソート済み部分の次）を示す。
最後の要素は比較不要なため、ループは $n-1$ 回繰り返す。

`min_index` は最小値のインデックスを記録するための変数である。（5 行目）
`min_index` に未ソート部分の最初の要素（`i` 番目）を一旦代入する。
この変数は未ソート部分の最小値の位置を追跡する。

内側のループ（6 行目）では、未ソート部分の配列を走査して、現在の最小値 (`a[min_index]`) より小さい値が見つかれば、`min_index` をその位置に更新する。

7 行目の `if` 文において各要素 `a[j]` を調べて最小値を見つけている。

11 から 15 行目は交換処理である。
見つけた最小値が現在の位置 (`i`) と異なる場合は、`a[i]` と `a[min_index]` を交換する。
この操作によって、未ソート部分の最小値がソート済み部分の末尾に追加される。

=== 実行結果

参考実装として与えられた `main_selection_sort.c` を用いて実行すると、以下のような結果が得られた。

#sourcefile(read("./selection_sort.sample.output"), file:"./selection_sort.sample.output")

これは期待されているものと同一である。

次に `main_selection_sort.c` を以下のように書き換え、結果を確認した。

#sourcefile(read("./main_selection_sort.testcase.c"), file:"./main_selection_sort.testcase.c")

実行すると、失敗せずに正常終了したため、入力したデータが正しく整列されることを，複数の例を用いて確認することができた。

また、手動データの動作説明を以下に示す。

1. 初期状態:
  配列は `64 25 12 22 11`。
2. 1回目のループ:
  - 未ソート部分: `[64, 25, 12, 22, 11]`
  - 最小値 `11` を見つける（インデックス `4`）。`64` と交換。
  - 配列: `[11, 25, 12, 22, 64]`
3. 2回目のループ:
  - 未ソート部分: `[25, 12, 22, 64]`
  - 最小値 `12` を見つける（インデックス `2`）。`25` と交換。
  - 配列: `[11, 12, 25, 22, 64]`
4. 3回目のループ:
  - 未ソート部分: `[25, 22, 64]`
  - 最小値 `22` を見つける（インデックス `3`）。`25` と交換。
  - 配列: `[11, 12, 22, 25, 64]`
5. 4回目のループ:
  - 未ソート部分: `[25, 64]`
  - 最小値 `25` がそのまま。交換不要。
6. 最終結果:
  配列: `[11, 12, 22, 25, 64]`

これはプログラムの出力結果と一致している。

以上より示された要件
- 入力したデータが正しく整列されることを、複数の例を用いて確認すること。
- 実際に整列する例を示し、動作について説明すること。

が確認できた。
