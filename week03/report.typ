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
  date: "2024 年 11 月 6 日",
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

// また、動作を確認するために `main_linked_list.c` を以下のように書き換えた。
//
// #sourcefile(read("./main_linked_list.testcase.c"), file:"./main_linked_list.testcase.c")
//
// この出力は以下の通りである。
//
// #sourcefile(read("./linked_list.output"), file:"./linked_list.output")
