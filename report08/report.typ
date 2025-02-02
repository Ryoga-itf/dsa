#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 8,
  name: "動的計画法",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2025 年 2 月 3 日",
  date: "2025 年 2 月 3 日",
)

#set math.equation(numbering: "1.")

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

#include "basic1.typ"
#include "basic2.typ"
#include "advanced1.typ"
#include "advanced2.typ"
