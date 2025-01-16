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

=== 実装コード及びその説明

実装した関数のコードを以下に示す。

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

=== 考察

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
