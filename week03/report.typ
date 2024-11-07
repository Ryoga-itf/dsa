#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/plotst:0.2.0": *

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 3,
  name: "ハッシュ法",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2024 年 11 月 7 日",
  date: "2024 年 11 月 7 日",
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

== 基本課題

実装したコードを以下に示す。

#sourcefile(read("./open_addressing.c"), file:"./open_addressing.c")

参考実装として与えられた `main_open_addressing.c` を用いると、以下のような出力が得られた。

#sourcefile(read("./open_addressing.sample.output"), file:"./open_addressing.sample.output")

要件として提示された

- 辞書に整数を格納できること
- 格納した整数を探索できること

は正しく動作していることが確認できる。

次に、その他の要件を確認するために `main_open_addressing.c` を以下のように書き換えた。

#sourcefile(read("./main_open_addressing.testcase.c"), file:"./main_open_addressing.testcase.c")

この出力は以下の通りである。

#sourcefile(read("./open_addressing.testcase.output"), file:"./open_addressing.testcase.output")

このプログラムの前半部分は同じハッシュを持つ 1, 6, 11 を格納し、それを探索している。
この出力の前半部分により、要件として提示された

- 同じハッシュ値をもつ整数を，それぞれ他の配列要素に格納できること
- 同じハッシュ値をもつ複数の整数を探索できること

は正しく動作していることが確認できる。

また、後半部分のコードでは配列に空きがなく挿入できない状態にデータを挿入しようとしている。
ここでは、警告がなされ、プログラムが異常終了した。

また、終了コードは 1 であり、警告は標準エラー出力に出力された。以下にそれを確認した様子を示す。

#sourcecode[
```
$ ./open_addressing
1 1 6 11 1
Search 1 ...    1
Search 6 ...    2
Search 11 ...   3
[Error] Dictionary is full!

$ ./open_addressing 1>/dev/null
[Error] Dictionary is full!

$ echo $?         
1
```
]

よって、要件として提示された

- データを挿入しようとして配列に空きがなく挿入できない時は，標準エラー出力にエラーメッセージを表示し，exit関数を用いてプログラムを異常終了させること

が正しく動作していることが確認できる。

== 発展課題

実装したコードを以下に示す。

#sourcefile(read("./double_hashing.c"), file:"./double_hashing.c")

また、`main_double_hashing.c` を以下のように実装し、実行した。

#sourcefile(read("./main_double_hashing.sample.c"), file:"./main_double_hashing.sample.c")

出力は以下のようになった。

#sourcefile(read("./double_hashing.sample.output"), file:"./double_hashing.sample.output")

要件として提示された

- 辞書に整数を格納できること
- 格納した整数を探索できること

は正しく動作していることが確認できる。

次に、その他の要件を確認するために `main_double_hashing.c` を以下のように書き換えた。

#sourcefile(read("./main_double_hashing.testcase.c"), file:"./main_double_hashing.testcase.c")

この出力は以下の通りである。

#sourcefile(read("./double_hashing.testcase2.output"), file:"./double_hashing.testcase2.output")

このプログラムの前半部分は同じハッシュを持つ 1, 6, 11 を格納し、それを探索している。
この出力の前半部分により、要件として提示された

- 同じハッシュ値をもつ整数を，それぞれ他の配列要素に格納できること
- 同じハッシュ値をもつ複数の整数を探索できること

は正しく動作していることが確認できる。

また、後半部分のコードでは配列に空きがなく挿入できない状態にデータを挿入しようとしている。
ここでは、警告がなされ、プログラムが異常終了した。

また、終了コードは 1 であり、警告は標準エラー出力に出力された。以下にそれを確認した様子を示す。

#sourcecode[
```
$ ./double_hashing
11 1 1 1 6
Search 1 ...    1
Search 6 ...    4
Search 11 ...   0
[Error] Dictionary is full!

$ ./double_hashing 1>/dev/null
[Error] Dictionary is full!

$ echo $?         
1
```
]

よって、要件として提示された

- データを挿入しようとして配列に空きがなく挿入できない時は，標準エラー出力にエラーメッセージを表示し，exit関数を用いてプログラムを異常終了させること

が正しく動作していることが確認できる。

次に、占有率に対するパフォーマンスを計測するために、`main_double_hashing.c` を以下のように変更し、実行した。

#sourcefile(read("./main_double_hashing.c"), file:"./main_double_hashing.c")

結果は以下のようになった。

#sourcefile(read("./double_hashing.testcase.output"), file:"./double_hashing.testcase.output")

これを、占有率 $alpha$ （単位：%）を横軸にし、実行時間（単位：ミリ秒）を縦軸にとったグラフにすると以下のようになった。

#let data = (
  (0, 2.457),
  (10, 3.712),
  (20, 3.386),
  (30, 3.05),
  (40, 5.113),
  (50, 7.241),
  (60, 4.662),
  (70, 4.256),
  (80, 4.886),
  (90, 7.087),
  (100, 4602.269),
)

#let x_axis = axis(min: 0, max: 100, step: 10, location: "bottom")
#let y_axis = axis(min: 0, max: 5000, step: 1000, location: "left", helper_lines: false)

#let pl = plot(data: data, axes: (x_axis, y_axis))
#graph_plot(pl, (100%, 25%))

100% を除いたグラフは以下の通り

#let data = (
  (0, 2.457),
  (10, 3.712),
  (20, 3.386),
  (30, 3.05),
  (40, 5.113),
  (50, 7.241),
  (60, 4.662),
  (70, 4.256),
  (80, 4.886),
  (90, 7.087),
)

#let x_axis = axis(min: 0, max: 100, step: 10, location: "bottom")
#let y_axis = axis(min: 0, max: 8, step: 1, location: "left", helper_lines: false)

#let pl = plot(data: data, axes: (x_axis, y_axis))
#graph_plot(pl, (100%, 25%))

結果は、占有率が 100% のとき、探索に異常に時間を要することがわかった。
また、概ね占有率が大きくなるほど探索に時間を要することがわかった。
