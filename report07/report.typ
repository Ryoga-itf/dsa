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

また、`text` として `abracadabra`、`pat` として `ada` を用いた際の動作について説明する。
実行結果は以下の通りである。

#sourcecode[```
$ echo abracadabra > text

$ echo ada > pat         

$ ./mainNaive -v text pat
text size: 12
pattern size: 3
cmp(a, a)
cmp(d, b)
cmp(a, b)
cmp(a, r)
cmp(a, a)
cmp(d, c)
cmp(a, c)
cmp(a, a)
cmp(d, d)
cmp(a, a)
Pattern found at 5.
# of comparison(s): 10.
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
    columns:11,
    align: center,
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) => if y == 0 {gray},
    inset: (left: 1em, right: 1em),
      [a],   [b],   [r],   [a],   [c],   [a],   [d],   [a],   [b],   [r],   [a],
    ok[a], ng[d], sk[a],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ], ng[a], sk[d], sk[a],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ], ng[a], sk[d], sk[a],   [ ],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ], ok[a], ng[d], sk[a],   [ ],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ], ng[a], sk[d], sk[a],   [ ],   [ ],   [ ],   [ ],
      [ ],   [ ],   [ ],   [ ],   [ ], ok[a], ok[d], ok[a],   [ ],   [ ],   [ ],
  ),
  caption: [動作の様子]
)<table1>

この表は、`cmp` により等しい箇所は緑色の背景で、異なる箇所は赤色の背景で、また比較がスキップされた箇所は灰色の背景で示している。

動作例では比較回数が 10 回であるが、この表も同様に 10 回の比較で終了している。

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

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、以下の通り実行を行った。また結果も示している。

// #sourcecode[```
// ```]

これは期待されているものと同一である。

=== 考察

== 発展課題1

== 発展課題2
