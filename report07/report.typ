#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/plotst:0.2.0": *

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 7,
  name: "文字列照合",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2025 年 1 月 27 日",
  date: "2025 年 1 月 27 日",
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

== 基本課題1: 単純照合法

=== 実装の方針

単純な二重ループで実装すればよい。
具体的には、外側のループで開始位置をループし、その後内側のループで開始位置からパターンが出現するかを確認する。

=== 実装コード及びその説明

実装した関数のコードを以下に示す。
なお、コメントアウトしている行があるが、それについては後述する。

#sourcecode[```c
int naive(char *text, unsigned int textlen, char *pat, unsigned int patlen) {
    /* for (int i = 0; i < textlen - patlen; i++) { */
    for (int i = 0; i < textlen; i++) {
        bool match = true;
        for (int j = 0; j < patlen; j++) {
            if (i + j >= textlen || !cmp(pat[j], text[i + j])) {
                match = false;
                break;
            }
        }
        if (match) {
            return i;
        }
    }
    return -1;
}
```]

この関数は単純照合法に基づき、以下のロジックで実装される：

1. テキストを先頭から順にスキャンし、パターンと一致する部分があるか確認。
2. 各比較には `cmp` 関数を利用し、比較回数をカウント。
3. 一致する部分が見つかった場合、その位置を返却。

また、探索結果として、最初に一致する位置（インデックス）を返し、一致しない場合は `-1` を返す。

コメントアウトした部分

#sourcecode[```c
for (int i = 0; i < textlen - patlen; i++) {
```]

を用いても正しく動作するが、`-v` オプションを与えた際の動作のサンプルとして与えられた実行結果と若干異なる結果が得られた。
当初これで実装しており、またこちらのほうがループ回数が減り、効率的であるが今回は実行結果の一致を目的にコードを変更した。

パターンがテキストをはみ出す位置以降を探索しないよう制限しているため、こちらでも正しく動作すると考えられる。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、以下の通り実行を行った。また結果も示している。

#sourcecode[```
$ echo This is a pen. > text

$ echo pen > pat

$ ./mainNaive text pat
Pattern found at 10.

$ ./mainNaive -v text pat
text size: 15
pattern size: 3
cmp(p, T)
cmp(p, h)
cmp(p, i)
cmp(p, s)
cmp(p,  )
cmp(p, i)
cmp(p, s)
cmp(p,  )
cmp(p, a)
cmp(p,  )
cmp(p, p)
cmp(e, e)
cmp(n, n)
Pattern found at 10.
# of comparison(s): 13.

$ echo ix > pat

$ ./mainNaive text pad
Pattern found at -1.

$ ./mainNaive -v text pat
text size: 15
pattern size: 2
cmp(i, T)
cmp(i, h)
cmp(i, i)
cmp(x, s)
cmp(i, s)
cmp(i,  )
cmp(i, i)
cmp(x, s)
cmp(i, s)
cmp(i,  )
cmp(i, a)
cmp(i,  )
cmp(i, p)
cmp(i, e)
cmp(i, n)
cmp(i, .)
cmp(i, 
)
Pattern found at -1.
# of comparison(s): 17.
```]

これは期待されているものと同一である。

次に、作成したプログラムを簡単な動作例を用いて説明し、それが正しく動作することを示す。
ここでは、`text` として `aababacababc`、`pat` として `ababc` を用いた際の動作について説明する。
実行結果は以下の通りである。

#sourcecode[```
$ echo abracadabra > text

$ echo ada > pat         

$ ./mainNaive -v text pat
text size: 13
pattern size: 5
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, b)
cmp(a, a)
cmp(b, b)
cmp(c, a)
cmp(a, b)
cmp(a, a)
cmp(b, b)
cmp(a, a)
cmp(b, c)
cmp(a, b)
cmp(a, a)
cmp(b, c)
cmp(a, c)
cmp(a, a)
cmp(b, b)
cmp(a, a)
cmp(b, b)
cmp(c, c)
Pattern found at 7.
# of comparison(s): 21.
```]

動作の様子を @table1 に示す。

#let ok(x) = table.cell(
  fill: green.lighten(60%),
)[#x]

#let ng(x) = table.cell(
  fill: red.lighten(60%),
)[#x]

#let sk(x) = table.cell(
  fill: gray.lighten(60%),
)[#x]

#figure(
  table(
    columns:12,
    align: center,
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) => if y == 0 {gray},
    inset: (left: 1em, right: 1em),
      [a],   [a],   [b],   [a],   [b],   [a],   [c],   [a],   [b],   [a],   [b],   [c],
    ok[a], ng[b], sk[a], sk[b], sk[c],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ], ok[a], ok[b], ok[a], ok[b], ng[c],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ], ng[a], sk[b], sk[a], sk[b], sk[c],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ], ok[a], ok[b], ok[a], ng[b], sk[c],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ], ng[a], sk[b], sk[a], sk[b], sk[c],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ], ok[a], ng[b], sk[a], sk[b], sk[c],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ],   [ ], ng[a], sk[b], sk[a], sk[b], sk[c],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ], ok[a], ok[b], ok[a], ok[b], ok[c],
  ),
  caption: [動作の様子]
)<table1>

この表は、`cmp` により等しい箇所は緑色の背景で、異なる箇所は赤色の背景で、また比較がスキップされた箇所は灰色の背景で示している。

動作例では比較回数が 21 回であるが、この表も同様に 21 回の比較で終了している。

=== 考察

このアルゴリズムの利点としては以下の通りである。

/ 簡潔で直感的なロジック:
  
  テキストを逐一探索し、すべての文字位置でパターンと比較する単純な方法で、直感的に理解しやすい。

/ 実装の容易さ:

  パターンの長さやテキストの長さに依存せず、コードの構造が単純で容易にデバッグが可能。

/ 特定のデータでの効率性:

  テキスト内に早期に一致するパターンが含まれる場合は、探索回数が少なくなる。

次に、このアルゴリズムの欠点は以下の通り:

/ 効率の低さ（計算量）:

  最悪の場合、比較回数は $n$ をテキスト長、$m$ をパターン長として $Omicron((n−m+1)m)$ となる。

/ 無駄な比較の存在:

  同じ位置から再び比較を開始するため、効率的な探索が行われない。
  部分一致や失敗時のバックトラックがないため、性能は常に最悪のケースを想定する必要があると考えられる。

/ 大規模データへの非適合性:

  テキストやパターンが非常に長い場合、比較回数が増大し、実行時間が長くなる。

== 基本課題1: KMP 法

=== 実装の方針

KMP 法では、検索パターンである文字列 $T$ について、部分マッチテーブルという配列を生成し、それを元に比較を飛ばせるところを飛ばすという流れで文字列探索を行う。

部分マッチテーブルとは $1 <= i <= |T|$ に対して $T[0:i]$ の真の接頭辞と接尾辞が最大で先頭から何文字一致するかという値を持つ配列のことである。
真の接尾辞とはその文字列自身を含まない prefix のことである。

それを生成する関数として `compnext` を実装する。

`kmp` 関数では、テキスト全体は 1 文字ずつ探索し、`next` 配列を用いてパターン内の次の比較位置へ移動する。

=== 実装コード及びその説明

実装した関数のコードを以下に示す。

#sourcecode[```c
void compnext(char *pat, unsigned int *next) {
    next[0] = -1;
    for (int i = 1, j = -1; pat[i] != '\0'; i++, j++) {
        while (j >= 0 && pat[i - 1] != pat[j]) {
            j = next[j];
        }
        next[i] = j + 1;
    }
}

int kmp(char *text, unsigned int textlen, char *pat, unsigned int patlen) {
    unsigned int next[PAT_MAX];
    compnext(pat, next);
    for (int i = 0, j = 0; i + j < textlen;) {
        if (cmp(pat[j], text[i + j])) {
            if (++j == patlen) {
                return i;
            }
        } else {
            i = i + j - next[j];
            if (j > 0) {
                j = next[j];
            }
        }
    }
    return -1;
}
```]

コードの概要を以下に示す。

- *`compnext` 関数による前処理*
  - パターンの部分一致情報（`next` 配列）を計算する。
  - `next[j]` は、`pat[0..j]` の部分文字列の接頭辞と接尾辞が一致する最大長を表す。
- *テキストの探索 (`while` ループ)*
  - テキスト全体を 1 文字ずつ探索する。
  - 現在の位置 `i` とパターンの位置 `j` を比較する。
- *一致時の処理*
  - 現在の文字が一致した場合、`j` を進める。
  - `j == patlen` に達した場合、パターン全体が一致したことを意味し、`i` を返す。
- *不一致時の処理*
  - `j > 0` の場合、`next` 配列を用いてパターン内の次の比較位置へ移動する。
  - `j == 0` の場合、`i` を進め、テキストの次の位置から比較を再開する。
- *探索失敗時の処理*
  - テキスト全体を走査しても一致しなかった場合、`-1` を返す。

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、以下の通り実行を行った。また結果も示している。

#sourcecode[```
$ echo This is a pen. > text

$ echo pen > pat

$ ./mainKMP text pat
Pattern found at 10.

$ ./mainKMP -v text pat
text size: 15
pattern size: 3
cmp(p, T)
cmp(p, h)
cmp(p, i)
cmp(p, s)
cmp(p,  )
cmp(p, i)
cmp(p, s)
cmp(p,  )
cmp(p, a)
cmp(p,  )
cmp(p, p)
cmp(e, e)
cmp(n, n)
Pattern found at 10.
# of comparison(s): 13.

$ echo ix > pat

$ ./mainKMP text pad
Pattern found at -1.

$ ./mainKMP -v text pat
text size: 15
pattern size: 2
cmp(i, T)
cmp(i, h)
cmp(i, i)
cmp(x, s)
cmp(i, s)
cmp(i,  )
cmp(i, i)
cmp(x, s)
cmp(i, s)
cmp(i,  )
cmp(i, a)
cmp(i,  )
cmp(i, p)
cmp(i, e)
cmp(i, n)
cmp(i, .)
cmp(i, 
)
Pattern found at -1.
# of comparison(s): 17.
```]

次に、作成したプログラムを簡単な動作例を用いて説明し、それが正しく動作することを示す。

ここでは、`text` として `aababacababc`、`pat` として `ababc` を用いた際の動作について説明する。
実行結果は以下の通りである。

#sourcecode[```
$ echo aababacababc > text

$ echo ababc > pat        

$ ./mainNaive -v text pat
text size: 13
pattern size: 5
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, b)
cmp(a, a)
cmp(b, b)
cmp(c, a)
cmp(a, a)
cmp(b, c)
cmp(b, c)
cmp(a, c)
cmp(a, a)
cmp(b, b)
cmp(a, a)
cmp(b, b)
cmp(c, c)
Pattern found at 7.
# of comparison(s): 16.
```]

動作の様子を @table2 に示す。

#let ok(x) = table.cell(
  fill: green.lighten(60%),
)[#x]

#let ng(x) = table.cell(
  fill: red.lighten(60%),
)[#x]

#let sk(x) = table.cell(
  fill: gray.lighten(60%),
)[#x]

#figure(
  table(
    columns:12,
    align: center,
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) => if y == 0 {gray},
    inset: (left: 1em, right: 1em),
      [a],   [a],   [b],   [a],   [b],   [a],   [c],   [a],   [b],   [a],   [b],   [c],
    ok[a], ng[b], sk[a], sk[b], sk[c],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ], ok[a], ok[b], ok[a], ok[b], ng[c],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ], sk[a], sk[b], ok[a], ng[b], sk[c],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ], sk[a], ng[b], sk[a], sk[b], sk[c],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ],   [ ], ng[a], sk[b], sk[a], sk[b], sk[c],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ], ok[a], ok[b], ok[a], ok[b], ok[c],
  ),
  caption: [KMP 法による動作の様子]
)<table2>

この表は、`cmp` により等しい箇所は緑色の背景で、異なる箇所は赤色の背景で、また比較がスキップされた箇所は灰色の背景で示している。

動作例では比較回数が 16 回であるが、この表も同様に 16 回の比較で終了している。

同じ入力で行った単純照合法の比較回数は 21 回であったが、16 回に減っている。
また、@table1 と比較すると、冗長な比較が省略されていることがわかる。

=== 考察

KMP 法では、検索パターンである文字列 $T$ について、部分マッチテーブルという配列を生成し、それを元に比較を飛ばせるところを飛ばすという流れで文字列探索を行う。

このアルゴリズムの利点を以下に挙げる: 

/ 効率性:

  - テキスト長を $n$、パターン長を $m$ とすると、KMP 法の計算量は $Omicron(n+m)$ である。
    - 前処理（`compnext`）に $Omicron(m)$。
    - テキスト探索に $Omicron(n)$。
  - 単純照合法の $Omicron((n−m+1)m)$ と比較すると、大幅に効率的である。

/ 冗長な比較の排除:

  - パターン内の部分一致情報を活用して不必要な再比較を回避する。
  - 不一致時にバックトラックする際、`next` 配列を使用して効率的に次の位置を決定する。

/ 大規模データへの適用:

  - KMP 法は長いテキストやパターンに対しても効率的に動作すると考えられる。

また、以下にこのアルゴリズムの欠点を挙げる:

/ 前処理の必要性:

  - `compnext` 関数による部分一致テーブルの計算が必要であり、実装がやや複雑になる。
  - 短いパターンや簡単な照合にはオーバーヘッドになる場合がある。

/ 実装の難しさ:

  - KMP 法の核心部分である `compnext` のロジックは、単純照合法に比べて理解と実装が難しい。
  - プログラムのデバッグや保守も複雑化する。

/ 制限:

  - パターン長が `PAT_MAX` を超える場合、部分一致テーブルの配列サイズを動的に確保する必要があり、コードの修正が必要である。

@table3 に、単純照合法との比較をまとめる。

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    [*比較項目*], [*単純照合法*], [*KMP法*],
    [*計算量*], [最悪 $Omicron((n-m+1)m)$], [$Omicron(n+m)$],
    [*効率性*], [冗長な比較が多い], [部分一致情報で再比較を排除],
    [*実装の容易さ*], [簡単], [やや複雑],
    [*小規模データ*], [効率が良い場合もある], [オーバーヘッドが発生する場合がある],
    [*大規模データ*], [非効率], [効率的],
  ),
  caption: [単純照合法とKMP法の比較]
) <table3>

== 発展課題1

以下のシェルスクリプト `adv1.sh` を作成し、ランダムな文字列に対して単純照合法と KMP 法の比較回数を比較した。

#sourcefile(read("./adv1.sh"), file:"./adv1.sh")

数回実行すると、以下のような結果が得られた。

#sourcecode[```
$ ./adv1.sh
Generated text of length 525 in 'text'
Generated pat of length 8 in 'pat'
Comparisons in Naive: 535.
Comparisons in KMP: 535.

$ ./adv1.sh
Generated text of length 500 in 'text'
Generated pat of length 9 in 'pat'
Comparisons in Naive: 512.
Comparisons in KMP: 512.

$ ./adv1.sh
Generated text of length 981 in 'text'
Generated pat of length 20 in 'pat'
Comparisons in Naive: 1011.
Comparisons in KMP: 1010.

$ ./adv1.sh
Generated text of length 579 in 'text'
Generated pat of length 5 in 'pat'
Comparisons in Naive: 592.
Comparisons in KMP: 592.
```]

結果として KMP 法がたまに 1 回ほど比較回数が少ない程度な結果となった。

このような結果になったのは完全にランダムな文字列同士を比較しているため、あまり差が生まれなかったためであると考えられる。

== 発展課題2

単純照合法では、文字列比較が効率的に行われない場合に最悪の計算量が発生する。

この最悪ケースは以下の条件を満たすと考えられる：
  - テキスト文字列とパターン文字列の内容が非常に似ており、多くの部分一致が発生するが、最終的に一致しない。
  - パターンがテキスト内のほぼすべての位置で比較される。

このとき、最悪計算量は $Omicron((n-m+1)m)$ となる。

例えば `text = aaaaaaa...aab`、`pat = aaaab` のようなとき最悪ケースとなる。

実際に実行してみると以下のような結果が得られた。

#sourcecode[```
$ echo  aaaaaaaaab > text

$ echo aaaab > pat      

$ ./mainNaive -v text pat 
text size: 11
pattern size: 5
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, b)
Pattern found at 5.
# of comparison(s): 30.

$ ./mainKMP -v text pat
text size: 11
pattern size: 5
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, a)
cmp(a, a)
cmp(b, b)
Pattern found at 5.
# of comparison(s): 15.
```]

単純照合法では 30 回、KMP 法では 15 回となった。

次に、`text = aaaa...aaab` ($N$ 文字)、`pat = aaaaab` の入力を考える。
以下のシェルスクリプトを作成し、入力のための `text` ファイルを生成および実行した。

#sourcefile(read("./adv2.sh"), file:"./adv2.sh")

複数の $N$ に対して両者の比較回数を比較すると @table4 のようになった。

#let naive_data = (
  (1000, 5970),
  (2000, 11970),
  (3000, 17970),
  (4000, 23970),
  (5000, 29970),
  (6000, 35970),
  (7000, 41970),
  (8000, 47970),
  (9000, 53970),
  (10000, 59970),
)
#let kmp_data = (
  (1000, 1994),
  (2000, 3994),
  (3000, 5994),
  (4000, 7994),
  (5000, 9994),
  (6000, 11994),
  (7000, 13994),
  (8000, 15994),
  (9000, 17994),
  (10000, 19994),
)

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 7pt,
    align: center,
    table.header(
      [*$N$*], [*単純照合法*], [*KMP法*],
    ),
    ..range(1, 10).map(t=> (
      t * 1000,
      naive_data.at(t).at(1),
      kmp_data.at(t).at(1),
    )).flatten().map(v => $#v$)
  ),
  caption: [単純照合法とKMP法の比較回数の比較]
) <table4>

これをグラフにプロットすると以下のようになった。
なお、青色の実線が単純照合法、赤色の実線が KMP 法の比較回数を表している。

#let x_axis = axis(min: 0, max: 10000, step: 1000, location: "bottom")
#let y_axis = axis(min: 0, max: 65000, step: 10000, location: "left", helper_lines: false)

#let naive_pl = plot(data: naive_data, axes: (x_axis, y_axis))
#let naive_display = graph_plot(naive_pl, (100%, 30%), stroke: blue)

#let kmp_pl = plot(data: kmp_data, axes: (x_axis, y_axis))
#let kmp_display = graph_plot(kmp_pl, (100%, 30%), stroke: red)

#overlay((naive_display, kmp_display), (100%, 30%))

KMP 法のほうが、高速に動作することがわかる。
