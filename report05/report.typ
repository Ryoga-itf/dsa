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

== 基本課題: 選択ソートの実装

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

#sourcefile(read("./sample.output"), file:"./sample.output")

これは期待されているものと同一である。

次に `main_selection_sort.c` を以下のように書き換え、結果を確認した。

#sourcefile(read("./main_selection_sort.testcase.c"), file:"./main_selection_sort.testcase.c")

実行すると、失敗せずに正常終了したため、入力したデータが正しく整列されることを、複数の例を用いて確認することができた。

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

=== 考察

- アルゴリズムの流れ
  - 配列の先頭から順に、未ソート部分の最小値を探す。
  - 最小値を現在の位置に移動する（交換する）。
  - 未ソート部分を縮小し、繰り返す。

- 計算量
  / 時間計算量:
    比較回数は常に $Omicron(n^2)$（外側のループ $n−1$ 回、内側のループ平均で $n\/2$ 回）。
  / 空間計算量:
    入力配列を直接操作するため、追加メモリは $Omicron(1)$（インプレースソートである）。

== 基本課題: 挿入ソートの実装

=== 実装の方針

やるだけ

二重ループを書き、外側で配列を舐める、内側で挿入位置を探す、をすると良い。

=== 実装コード及びその説明

実装した `insertion_sort.c` を以下に示す。

#sourcefile(read("./insertion_sort.c"), file:"./insertion_sort.c")

外側のループ（4 行目）は配列の 2 番目の要素（インデックス `1`）から最後まで処理する。
これにより、左側の部分配列（`0` から `i-1`）が常に整列される状態を維持する。

現在の要素 (`a[i]`) を変数 `key` に保持する（5 行目）。この値を適切な位置に挿入する。

内側のループ （8 行目）で挿入位置を探している。
整列済み部分の右端（インデックス `j = i-1`）から左に向かって調べ、`key` より大きい要素を 1 つ右に移動する。

12 行目は挿入処理である。
挿入位置が決まったら、`key` をその位置に挿入する (`a[j+1] = key`)。

=== 実行結果

参考実装として与えられた `main_insertion_sort.c` を用いて実行すると、以下のような結果が得られた。

#sourcefile(read("./sample.output"), file:"./sample.output")

これは期待されているものと同一である。

次に `main_insertion_sort.c` を以下のように書き換え、結果を確認した。

#sourcefile(read("./main_insertion_sort.testcase.c"), file:"./main_insertion_sort.testcase.c")

実行すると、失敗せずに正常終了したため、入力したデータが正しく整列されることを、複数の例を用いて確認することができた。

また、手動データの動作説明を以下に示す。

- ステップ1 (`i = 1`)
  1. キーの選択:
    - 現在のキー: `a[1] = 25`
    - ソート済み部分: `[64]`（`i-1` まで）
  2. 比較とシフト:
    - `64 > 25` なので、`64` を右にシフト。
  3. キーの挿入:
    - `25` をインデックス `0` に挿入。
  4. 結果:
    配列: `[25, 64, 12, 22, 11]`
- ステップ2 (`i = 2`)
  1. キーの選択:
    - 現在のキー: `a[2] = 12`
    - ソート済み部分: `[25, 64]`
  2. 比較とシフト:
    - `64 > 12 なので`、`64` を右にシフト。
    - `25 > 12 なので`、`25` を右にシフト。
  3. キーの挿入:
    - `12` をインデックス `0` に挿入。
  4. 結果:
    配列: `[12, 25, 64, 22, 11]`
- ステップ3 (`i = 3`)
  1. キーの選択:
    - 現在のキー: `a[3] = 22`
    - ソート済み部分: `[12, 25, 64]`
  2. 比較とシフト:
    - `64 > 22` なので、`64` を右にシフト。
    - `25 > 22` なので、`25` を右にシフト。
  3. キーの挿入:
    - 22 をインデックス 1 に挿入。
  4. 結果:
    配列: `[12, 22, 25, 64, 11]`
- ステップ4 (`i = 4`)
  1. キーの選択:
    - 現在のキー: `a[4] = 11`
    - ソート済み部分: `[12, 22, 25, 64]`
  2. 比較とシフト:
    - `64 > 11` なので、`64` を右にシフト。
    - `25 > 11` なので、`25` を右にシフト。
    - `22 > 11` なので、`22` を右にシフト。
    - `12 > 11` なので、`12` を右にシフト。
  3. キーの挿入:
    - `11` をインデックス `0` に挿入。
  4. 結果:
    配列: `[11, 12, 22, 25, 64]`

これはプログラムの出力結果と一致している。

以上より示された要件
- 入力したデータが正しく整列されることを、複数の例を用いて確認すること。
- 実際に整列する例を示し、動作について説明すること。

が確認できた。

=== 考察

動作についてまとめると以下の通り。

- 配列の各要素を順番に取り出し、それをソート済み部分に挿入する。
- 挿入の際、キーより大きい要素は右にシフトされる。
- 配列全体が整列済みになるまでこのプロセスを繰り返す。

挿入ソートはこのように逐次的な処理を行うため、さらにインプレースソートであるため、小規模でほぼ整列されているデータに適していると考えられる。

- 計算量
  / 時間計算量:
    平均および最悪の場合 $Omicron(n^2)$。
    最良の場合（配列が既に整列済み）: $Omicron(n)$。
  / 空間計算量:
    インプレースソートのため $Omicron(1)$。

== 基本課題: ヒープソートの実装

=== 実装の方針

まず、ヒープソートを実現するために、入力配列を最大ヒープに変換する必要がある。

次に、ヒープの最大値を配列の末尾と交換することによりソートを行う。
その後、ヒープサイズを 1 つ減らし、ヒープのプロパティを維持するように再構築する。
この手順を繰り返して整列された配列を得る。

また、メモリ効率のために配列全体をヒープとして扱い、インプレースでソートを実現する。

=== 実装コード及びその説明

実装した `heap_sort.c` を以下に示す。

#sourcefile(read("./heap_sort.c"), file:"./heap_sort.c")

`sift_down` 関数は、ヒープのプロパティを維持するために、指定されたノードとその子ノードを比較し、必要なら最大値を持つ子ノードと交換することを目的とする。

この関数のアルゴリズムは以下の通りである。

1. 左右の子ノードを計算。
2. 現在のノードと子ノードを比較。
3. 最大値を持つノードが親でない場合、交換。
4. 再帰的に交換された子ノードで修復を続ける。

`build_heap` 関数は、配列を最大ヒープに変換することを目的とする。

この関数のアルゴリズムは以下の通りである。

1. 最後の非葉ノード (`n/2 - 1`) から順に `sift_down` を呼び出す。
2. 全てのノードでヒープのプロパティを満たすよう修復する。

`heap_sort` 関数は、ヒープ化した配列を用いて、配列全体を整列することを目的とする。

この関数のアルゴリズムは以下の通りである。

1. `build_heap` で配列を最大ヒープに変換。
2. 最大値（配列の先頭要素）を末尾と交換。
3. ヒープサイズを1つ減らし、残りの部分でヒープのプロパティを修復。
4. ステップ 2 と 3 を繰り返すことで整列済み配列を得る。

=== 実行結果

参考実装として与えられた `main_heap_sort.c` を用いて実行すると、以下のような結果が得られた。

#sourcefile(read("./sample.output"), file:"./sample.output")

これは期待されているものと同一である。

次に `main_heap_sort.c` を以下のように書き換え、結果を確認した。

#sourcefile(read("./main_heap_sort.testcase.c"), file:"./main_heap_sort.testcase.c")

実行すると、失敗せずに正常終了したため、入力したデータが正しく整列されることを、複数の例を用いて確認することができた。

また、手動データの動作説明を以下に示す。

1. 初期配列: `[64, 25, 12, 22, 11]`
  - `build_heap` を呼び出して最大ヒープを構築。
  - 配列: `[64, 25, 12, 22, 11]` （すでに最大ヒープの形式）
2. ソートの 1 回目:
  - 最大値 `64` を末尾（インデックス `4`）と交換。
  - 残り部分 `[11, 25, 12, 22]` でヒープを再構築。
  - 配列: `[25, 22, 12, 11, 64]`
3. ソートの 2 回目:
  - 最大値 `25` を末尾（インデックス `3`）と交換。
  - 残り部分 `[11, 22, 12]` でヒープを再構築。
  - 配列: `[22, 11, 12, 25, 64]`
4. 繰り返し:
  - 最大値を順に取り出し、末尾に配置。
  - 最終結果: `[11, 12, 22, 25, 64]`

これはプログラムの出力結果と一致している。

以上より示された要件
- 入力したデータが正しく整列されることを、複数の例を用いて確認すること。
- 実際に整列する例を示し、動作について説明すること。

が確認できた。

=== 考察

- 計算量
  / 時間計算量:
    配列をヒープ化する際 $Omicron(n)$
    ソートする際、各要素の抽出に $Omicron(log n)$ が必要で、全体として $Omicron (n log n)$
  / 空間計算量:
    配列をインプレースでソートするため $Omicron(1)$。

ヒープソートでは、ヒープの最大値（配列の先頭）を配列の末尾と交換するが、この際、値が同じ要素があっても、相対的な順序を考慮しないため、不安定ソートであると考えられる。
また、ヒープ再構築 (`sift_down`) の際、子ノード同士を比較して最大値を持つノードを親ノードと交換する。
同じ値が複数ある場合、どちらの子ノードが優先されるかはアルゴリズムの実装次第であり、元の順序は保証されない。

ヒープソートを安定化するには、値に加えてインデックス情報などを比較に含める必要があるのではないか。

== 基本課題: クイックソートの実装

=== 実装の方針

クイックソートは分割統治法によるアルゴリズムであり、再帰関数を利用するものであるから、ヘルパー関数を導入して再帰で求めることができるようにする。

分割統治法の部分については以下のように実装する。
- 配列を小さな部分に分割
- 各部分を独立してソート
- 結果を結合

なお、結果を結合する部分に関しては、もとの配列の一部分の区間を利用するため暗黙的に実現される。

パーティション処理は以下のように実装する。
- ピボットを選択
- ピボットを基準に配列を2つの部分に分割
- 小さい要素を左側、大きい要素を右側に移動

=== 実装コード及びその説明

実装した `quick_sort.c` を以下に示す。

#sourcefile(read("./quick_sort.c"), file:"./quick_sort.c")

`partition` 関数は配列の一部を、ピボットを基準に2つの部分に分割することを目的とする。

この関数のアルゴリズムは以下の通りである。
- ピボット値を保存
- ピボットを右端に移動
- 左からスキャンしながら、ピボットより小さい要素を左側に集める
- ピボットを適切な位置に配置
- ピボットの最終位置を返す

`quick_sort_helper` 関数は、再帰を実現するために導入した関数であり、再帰的なクイックソートの実装を目的とする。

この関数のアルゴリズムは以下の通りである。
- 終了条件のチェック（要素が1つ以下なら終了）
- ピボットの選択
- パーティション処理の実行
- 左右の部分配列に対して再帰的に処理

`quick_sort` 関数は、単にヘルパー関数を呼び出す。外部へのインターフェースを提供することを目的とする。

=== 実行結果

参考実装として与えられた `main_quick_sort.c` を用いて実行すると、以下のような結果が得られた。

#sourcefile(read("./sample.output"), file:"./sample.output")

これは期待されているものと同一である。

次に `main_quick_sort.c` を以下のように書き換え、結果を確認した。

#sourcefile(read("./main_quick_sort.testcase.c"), file:"./main_quick_sort.testcase.c")

実行すると、失敗せずに正常終了したため、入力したデータが正しく整列されることを、複数の例を用いて確認することができた。

また、手動データの動作説明を以下に示す。

1. 初期配列: `[64, 25, 12, 22, 11]`
  - 配列の右端の値 (`11`) をピボットとして選ぶ。
2. `partition` 関数の動作
  - ピボット: `11`
  - `i` は `-1` から開始し、`j` は左端から右端の1つ前まで走査。
  - 配列を走査し、`a[j] <= pivot` の場合に `i` をインクリメントし、`a[i] と a[j]` を交換する。
    - `a[0] = 64` は `11` より大きいため、交換せず、次に進む。
    - `a[1] = 25` も `11` より大きいため、交換せず、次に進む。
    - `a[2] = 12` は `11` より大きいため、交換せず、次に進む。
    - `a[3] = 22` も `11` より大きいため、交換せず、次に進む。
    - `a[4] = 11` はピボットと同じなので、交換せず進む。
    - 最後に、`i + 1` の位置にピボット（`11`）を配置。
  - ピボットを最終位置に移動
    - `i + 1 = 0` なので、`a[0]` と `a[4]`（ピボット）を交換。
  - 結果: `[11, 25, 12, 22, 64]`
  - ピボット `11` の最終位置はインデックス `0`
  - ピボットを基準に、左側にはソートする要素がない。右側の `[25, 12, 22, 64]` を再帰的にソートする。
3. 右側の部分配列をソート
  - ピボット: `64`
  - 走査し、ピボットより小さい要素を左に、そうでない要素を右に配置。
    - `a[3] = 22` は `64` より小さいので、`i` をインクリメントして `a[3]` と `a[3]` を交換（同じ要素なので変化なし）。
    - 最後に、`i + 1 = 4` にピボット `64` を置き換える。
  - 分割後: ピボット `64` の位置はインデックス `4` で、左側の部分配列 `[25, 12, 22]` を再度ソートする。
4. 左側の部分配列をソート
  - ピボット: `22`
  - 走査して、`a[j] <= 22` の場合に `i` をインクリメントして交換する。
    - `a[1] = 25` は `22` より大きいので、交換せず。
    - `a[2] = 12` は `22` より小さいので、i をインクリメントし、`a[1]` と `a[2]` を交換。
    - 最後に、ピボット `22` を `i + 1` に置く。
  - 分割後: ピボット `22` の位置はインデックス `2` です。左側の部分配列 `[12]` はすでに整列されている。
  - 右側の部分配列 `[25]` も整列済み。
5. 最終結果: `[11, 12, 22, 25, 64]`

これはプログラムの出力結果と一致している。

以上より示された要件
- 入力したデータが正しく整列されることを、複数の例を用いて確認すること。
- 実際に整列する例を示し、動作について説明すること。

が確認できた。

=== ヒープソートとクイックソートの性能分析

実験用に以下に示すコード `main_task_quick_heap_cmp.c` を作成した。
なお、ソートに比較回数をカウントする機能を追加するため、別途再実装している。

#sourcefile(read("./main_task_quick_heap_cmp.c"), file:"./main_task_quick_heap_cmp.c")

適切なコマンドを用いてコンパイルし、実行すると以下のような結果が得られた。

#sourcefile(read("./task.output"), file:"./task.output")

これをグラフにプロットすると以下のようになった。

==== 3.1

横軸が `numdata`、縦軸が比較回数である。
なお、青の実線がヒープソート、赤の実線がクイックソートである。

#let heap_data = (
  (1000, 30209),
  (2000, 66479),
  (3000, 105287),
  (4000, 144959),
  (5000, 186218),
  (6000, 228488),
  (7000, 271532),
  (8000, 313772),
  (9000, 357599),
  (10000, 402749),
)

#let quick_data = (
  (1000, 21939),
  (2000, 52329),
  (3000, 88047),
  (4000, 122175),
  (5000, 156079),
  (6000, 187113),
  (7000, 220033),
  (8000, 248757),
  (9000, 279035),
  (10000, 311243),
)

#let x_axis = axis(min: 0, max: 10000, step: 1000, location: "bottom")
#let y_axis = axis(min: 0, max: 420000, step: 50000, location: "left", helper_lines: false)

#let heap_pl = plot(data: heap_data, axes: (x_axis, y_axis))
#let heap_display = graph_plot(heap_pl, (100%, 30%), stroke: blue)

#let quick_pl = plot(data: quick_data, axes: (x_axis, y_axis))
#let quick_display = graph_plot(quick_pl, (100%, 30%), stroke: red)

#overlay((heap_display, quick_display), (100%, 30%))

==== 3.2

横軸が `numdata`、縦軸が実行時間（単位: ミリ秒）である。
なお、青の実線がヒープソート、赤の実線がクイックソートである。

#let heap_data = (
  ( 100000,   26.614),
  ( 300000,   90.851),
  ( 500000,  155.190),
  ( 700000,  225.837),
  ( 900000,  305.890),
  (1100000,  378.089),
  (1300000,  457.758),
  (1500000,  580.243),
  (1700000,  703.314),
  (1900000,  793.863),
  (2100000,  945.651),
  (2300000,  879.340),
  (2500000, 1134.828),
  (2700000, 1240.648),
  (2900000, 1631.296),
)

#let quick_data = (
  ( 100000,   18.287),
  ( 300000,   79.291),
  ( 500000,  170.848),
  ( 700000,  294.652),
  ( 900000,  457.288),
  (1100000,  674.826),
  (1300000,  889.375),
  (1500000, 1142.111),
  (1700000, 1451.628),
  (1900000, 1789.795),
  (2100000, 2179.687),
  (2300000, 2632.450),
  (2500000, 3255.237),
  (2700000, 3734.194),
  (2900000, 4312.473),
)

#let x_axis = axis(min: 0, max: 3000000, step: 500000, location: "bottom")
#let y_axis = axis(min: 0, max: 4500, step: 500, location: "left", helper_lines: false)

#let heap_pl = plot(data: heap_data, axes: (x_axis, y_axis))
#let heap_display = graph_plot(heap_pl, (100%, 30%), stroke: blue)

#let quick_pl = plot(data: quick_data, axes: (x_axis, y_axis))
#let quick_display = graph_plot(quick_pl, (100%, 30%), stroke: red)

#overlay((heap_display, quick_display), (100%, 30%))

==== 3.3

横軸が `numdata`、縦軸が比較回数である。
なお、青の実線がヒープソート、赤の実線がクイックソートである。

#let heap_data = (
  ( 1000,  32123),
  ( 2000,  69899),
  ( 3000, 111755),
  ( 4000, 153425),
  ( 5000, 197795),
  ( 6000, 242483),
  ( 7000, 287291),
  ( 8000, 331913),
  ( 9000, 378665),
  (10000, 425867),
)

#let quick_data = (
  ( 1000,   1000999),
  ( 2000,   4001999),
  ( 3000,   9002999),
  ( 4000,  16003999),
  ( 5000,  25004999),
  ( 6000,  36005999),
  ( 7000,  49006999),
  ( 8000,  64007999),
  ( 9000,  81008999),
  (10000, 100009999),
)

#let x_axis = axis(min: 0, max: 10000, step: 1000, location: "bottom")
#let y_axis = axis(min: 0, max:  100009999, step: 10000000, location: "left", helper_lines: false)

#let heap_pl = plot(data: heap_data, axes: (x_axis, y_axis))
#let heap_display = graph_plot(heap_pl, (100%, 30%), stroke: blue)

#let quick_pl = plot(data: quick_data, axes: (x_axis, y_axis))
#let quick_display = graph_plot(quick_pl, (100%, 30%), stroke: red)

#overlay((heap_display, quick_display), (100%, 30%))

=== 考察

- クイックソートは平均的なケースでヒープソートよりも高速な性能を示した
- クイックソートはデータが大きくなると遅くなった。これは再帰が深くなるからではないかと考えられる。
- 比較回数においては両アルゴリズムとも理論的な $Omicron(n log n)$ に従う傾向を示した。
- ヒープソートの比較回数が若干多い傾向が見られた
- これは以下が原因と考えられる：
  - ヒープ構造の維持に必要な追加の比較操作
  - クイックソートの効率的なパーティション処理

また、最悪ケースにおいては以下のようなことがわかった。
- クイックソートはグラフを読み取るとほぼ $Omicron(n^2)$ の計算量であることがわかる。
- 不均衡なパーティション分割により、再帰がかなり深くなる。

両アルゴリズムにはそれぞれ特徴的な長所と短所があり、使用状況に応じて適切な選択が必要である。
一般的な用途ではクイックソートが優れた選択となるが、安定性や最悪ケースの保証が重要な場合はヒープソートが適している。
実際のアプリケーションでは、これらの特性を理解した上で、要件に合わせた選択を行うことが重要である。

また、クイックソートにおいて再帰の深さが一定以上になった場合、ヒープソートに処理を切り替えるという手法を導入することで、より効率的なソートアルゴリズムが実現できると考えられる。

C++ の `std::sort` の仕様書を読んでみると、$Omicron(n log n)$ であることが要求されている。
これはクイックソートは適格でない。（最悪計算量が $Omicron(n^2)$ であるため）
実際に各種標準ライブラリの実装を調査したところ、予想通り、単純なクイックソートではなく、改良版とも呼べる実装が採用されていた。

具体的には、多くの実装でイントロソート（Introsort）と呼ばれるアルゴリズムが採用されている。
これはクイックソートとヒープソートを組み合わせたハイブリッドなソートアルゴリズムである。
`std::sort` の実装に特定のアルゴリズムを使用することは仕様上で強制されていないものの、イントロソートはクイックソートの平均的な高速性とヒープソートの最悪計算量の保証を両立させた効果的な解決策として広く採用されている。

== 発展課題: 基数ソートの実装

=== 実装の方針

最下位の桁（1の位）から最上位の桁まで順次ソートする。

特定の位の数字の取得は `(a[i] / exp) % 10` でできる。

桁の移動は exp を 10 倍ずつ増加すればよい。

=== 実装コード及びその説明

実装した `radix_sort.c` を以下に示す。

#sourcefile(read("./radix_sort.c"), file:"./radix_sort.c")

`radix_sort` 関数では、配列内の最大値を見つけて、処理が必要な桁数を決定する。
各位でソートを実行する。位の移動は exp に 10 倍していけばよい。

補助関数として `counting_sort` を導入した。

=== 実行結果

参考実装として与えられた `main_radix_sort.c` を用いて実行すると、以下のような結果が得られた。

#sourcefile(read("./radix_sort.output"), file:"./radix_sort.output")

これは期待されているものと同一である。

次に `main_radix_sort.c` を以下のように書き換え、結果を確認した。

#sourcefile(read("./main_radix_sort.testcase.c"), file:"./main_radix_sort.testcase.c")

実行すると、失敗せずに正常終了したため、入力したデータが正しく整列されることを、複数の例を用いて確認することができた。

また、整数 `143, 322, 246, 755, 123, 563, 514, 522` を要素とする配列に対して動作を確認した。

以下にこのプログラムの出力を示す。

#sourcefile(read("./radix_sort.test.output"), file:"./radix_sort.test.output")

以上より示された要件
- 入力したデータが正しく整列されることを、複数の例を用いて確認すること。
- 特定の配列で動作を確認し、その際の各桁の処理の後のバケットの内容を示すこと。

が確認できた。

=== 考察

- 処理の特徴
  - 各桁ごとに独立してソートを行う
  - 下位の桁から順に処理することで、最終的な整列を実現
  - 比較に基づかないソートアルゴリズム
- 安定性
  - 各桁でのソートに安定なカウンティングソートを使用
  - 後ろから処理することで元の順序を保持
  - 結果として安定なソートを実現

結局空間計算量がデカくなりがちなのでユースケースは少なそう。
クイックソートと比べて桁数が小さい場合に効率的である。

負の数や異なる基数への対応、異なるデータ型への対応を考えると応用は難しそうに感じる。
特に小数（浮動小数点）への対応なんて考えたくない、実装がバカほど大変そう。

== 発展課題: マージソートの実装

=== 実装の方針

sorted な 2 つの配列は前から見ていくといい感じに線形時間でマージできる。

あとは Divide and Conquer

=== 実装コード及びその説明

実装した `merge_sort.c` を以下に示す。

#sourcefile(read("./merge_sort.c"), file:"./merge_sort.c")

`merge` 関数は、2 つのソート済み部分配列をマージすることを目的としている。
一時配列を使用している。

左右の部分配列を比較しながらもとの配列に順序よく格納していく。

`merge_sort` 関数は、ボトムアップ的にマージソートを実装している。
配列を小さな部分配列に分割し、それらをマージしていく。

今回はサイズを 2 倍ずつ増やしながら処理を進めるようにした。

=== 実行結果

参考実装として与えられた `main_merge_sort.c` を用いて実行すると、以下のような結果が得られた。

#sourcefile(read("./sample.output"), file:"./sample.output")

これは期待されているものと同一である。

=== 考察

これが $Omicron(n log n)$ の時間計算量であることは直感的には難しいように感じた。

以前アルゴリズムイントロダクションで証明を読んだ気がするので、もう一度見返したい。

また、今回は一時配列に退避させてマージする実装にしたが、空間計算量を減らせないか考えたい。
どうやら in-place merge sort があるらしい。
