#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.1": sourcecode, sourcefile

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 2,
  name: "連結リスト，スタック，キュー",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2024 年 10 月 28 日",
  date: "2024 年 10 月 27 日",
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

=== 課題2-1

実装したコードを以下に示す。

#sourcefile(read("./linked_list.c"), file:"./linked_list.c")

また、動作を確認するために `main_linked_list.c` を以下のように書き換えた。

#sourcefile(read("./main_linked_list.testcase.c"), file:"./main_linked_list.testcase.c")

この出力は以下の通りである。

#sourcefile(read("./linked_list.output"), file:"./linked_list.output")

1 行目の `1 2 3 4` の出力は `insert_cell` の動作を確認するためのものである。
- 5 行目の処理により `1` は先頭に入ることが期待される。
- 6 行目の処理により `3` は先頭の直後に入ることが期待される。
- 7 行目の処理により `2` は先頭の直後に入ることが期待される。
- 8 行目の処理により `4` は先頭の次の次の直後に入ることが期待される。
- 以上の動作により `1 2 3 4` が出力されることが期待されるが、出力結果がそれと同じであるので正しく機能していると考えられる。

以上より、「セルを指定したセルの直後に挿入できること」が確認できる。


2 行目の `1 3` の出力は `delete_cell` の動作を確認するためのものである。
- 11, 12 行目の処理により、`1` の直後の `2` が削除され、その後、`1` の次の `3` の直後、すなわち `4` が削除されることが期待される。
- 以上の動作により `1 3` が出力されることが期待されるが、出力結果がそれと同じであるので正しく機能していると考えられる。

以上より、 「指定したセルの直後のセルを削除できること」が確認できる。


3 行目の `0 1 3` の出力は `insert_cell_top` の動作を確認するためのものである。
- 15 行目の処理により先頭に `0` を追加されることが期待される。
- 以上の動作により `0 1 3` が出力されることが期待されるが、出力結果がそれと同じであるので正しく機能していると考えられる。

以上より、 「セルをリストの先頭に挿入できること」が確認できる。

4 行目の `1 3` の出力は `delete_cell_top` の動作を確認するためのものである。
- 18 行目の処理により、先頭、すなわち `0` が削除されることが期待される。
- 以上の動作により `1 3` が出力されることが期待されるが、出力結果がそれと同じであるので正しく機能していると考えられる。

以上より、「先頭セルを削除できること」が確認できる。

よって、課題で示された確認すべき項目は全て正しく動作している。

=== 課題2-2

実装したコードを以下に示す。

#sourcefile(read("./queue.c"), file:"./queue.c")

また、動作を確認するために `main_queue.c` を以下のように書き換えた。

#sourcefile(read("./main_queue.testcase_01.c"), file:"./main_queue.testcase_01.c")

この出力は以下の通りである。

#sourcefile(read("./queue.01.output"), file:"./queue.01.output")

1 行目の `1 2` の出力は `enqueue` の動作を確認するためのものである。
- 9, 10 行目の処理により、キューに `1`, `2` がこの順に格納される。
- 以上の動作により、次の行で `1 2` が出力されることが期待されるが、出力結果がそれと同じであるので正しく機能していると考えられる。

2 行目の出力 `1` と 3 行目の出力 `2` により、`dequeue` が正しく動作していることが確認できる。

以上より、「キューに整数を 1 つ格納し、それが取り出せること」「キューに整数を複数連続して格納し、それが格納した順番で取り出せること」が確認できる。

3, 4 行目においてはこの出力は正しく行えていることが確認できる。
この出力は 10 個連続で格納しているが、これはその前の処理によって明らかにデータが末尾と先頭にまたがる。
この場合においてもキューに格納、取り出しが正しく行えていることがわかる。

次に、`main_queue.c` を以下のように書き換え動作を確認した。

#sourcefile(read("./main_queue.testcase_02.c"), file:"./main_queue.testcase_02.c")

この出力は以下の通りである。

#sourcefile(read("./queue.02.output"), file:"./queue.02.output")

これはサイズ 3 のキューに 4 つ数字を格納しようとしているが、
警告がなされ、プログラムが異常終了した。

また、終了コードは 1 であり、警告は標準エラー出力に出力された。以下にそれを確認した様子を示す。

#sourcecode[
```
$ ./queue
1 2 3
[Error] Queue is full!

$ ./queue 1>/dev/null
[Error] Queue is full!

$ echo $?         
1
```
]

さらに、`main_queue.c` を以下のように書き換え動作を確認した。

#sourcefile(read("./main_queue.testcase_03.c"), file:"./main_queue.testcase_03.c")

この出力は以下の通りである。

#sourcefile(read("./queue.03.output"), file:"./queue.03.output")

これは 2 つ数字を格納したのち、3 回取り出そうとしているが、
警告がなされ、プログラムが異常終了した。

また、終了コードは 1 であり、警告は標準エラー出力に出力された。以下にそれを確認した様子を示す。

#sourcecode[
```
$ ./queue
1 2
1
2
[Error] Queue is empty!

$ ./queue 1>/dev/null
[Error] Queue is empty!

$ echo $?         
1
```
]

よって、課題で示された確認すべき項目は全て正しく動作している。

== 発展課題

=== 課題2-3

実装したコードを以下に示す。

#sourcefile(read("./doublylinked_list.c"), file:"./doublylinked_list.c")
