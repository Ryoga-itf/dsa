#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile

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
