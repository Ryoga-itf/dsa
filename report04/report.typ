#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/plotst:0.2.0": *

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 4,
  name: "2分木、2分探索木",
  authors: (
    (
      name: env.STUDENT_NAME,
      id: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2024 年 11 月 18 日",
  date: "2024 年 11 月 18 日",
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

== 基本課題: 2 分木の実装

この課題では、教科書リスト2.11 ~ 2.12 (pp.40 ~ 41) を基づいた 2 分木の C プログラム `binarytree.c` を作成し、作成したプログラムの動作を確認した。

=== 実装の方針

木の探索及び可視化については、末尾に `_inner` という名前のついた関数をそれぞれ作成した。
また、必要に応じてその関数内で再帰することにより、見通しの良いプログラムを目指した。

幅優先探索においては、以前の課題で作成した queue を再利用しつつ、内部に `*Node` を格納できるよう変更を行った。

木の高さの計算については、再帰関数を適用し、ポインタを活用することで単純な実装にすることができた。


=== 実装コード及びコードの説明

実装した関数はそれぞれ以下の通り

- ノードの作成: create_node を利用して二分木のノードを生成
- 走査 (traversal):
  - 先行順 (preorder)、中間順 (inorder)、後行順 (postorder) による木の走査
  - 幅優先探索 (BFS) による木の走査
- 木の可視化: 木の構造を再帰的に文字列形式で表示
- 木の高さの計算: 木の深さを計算
- 木の削除: メモリを解放するためにノードを再帰的に削除

工夫した点は以下の通り

- 効率的なデータ管理: BFS のキューや再帰を適切に用い、データ構造を効率的に管理
- 汎用性の高いインターフェース: 表示や高さ計算など、汎用的な操作がシンプルに利用可能
- メモリ管理: delete_tree を実装することで動的メモリの安全な解放を保証

また、実装した `binarytree.c` を以下に示す。

#sourcefile(read("./binarytree.c"), file:"./binarytree.c")

=== 実行結果

参考実装として与えられた `main_binarytree.c` を用いると、以下のような出力が得られた。

#sourcefile(read("./binarytree.output"), file:"./binarytree.output")

これは示された実行例と一致し、正しく実装が行えていることが確認できる。

また、次の図で示す 2 分木に対して、動作を確認した。

#figure(
  image("./assets/tree.png"),
  caption: "動作確認用の 2 分木"
)

これをもとに `main_binarytree.c` を書き換えると以下のようになった。

#sourcefile(read("./main_binarytree.testcase.c"), file:"./main_binarytree.testcase.c")

根は `A` であるからそこに注意して書き換えている。

これの出力は以下のようになった。

#sourcefile(read("./binarytree.testcase.output"), file:"./binarytree.testcase.output")

== 発展課題: 2 分木の鏡像

実装した `binarytree_mirror.c` を以下に示す。

#sourcefile(read("./binarytree_mirror.c"), file:"./binarytree_mirror.c")

== 基本課題: 2 分探索木の実装

実装した `./binarysearchtree.c` を以下に示す。

#sourcefile(read("./binarysearchtree.c"), file:"./binarysearchtree.c")

参考実装として与えられた `main_binarysearchtree.c` を用いると、以下のような出力が得られた。

#sourcefile(read("./binarysearchtree.output"), file:"./binarysearchtree.output")
