#import "@preview/codelst:2.0.2": sourcecode, sourcefile

== Appendix: 教科書の表 6.1の例に関して、すべての組を列挙する

教科書の表 6.1の例に関して、荷物の数が4, 容量が3,4,5の場合の実行結果が正しいことを確認する課題のために使用したコードを @appendix-code に示す。

#figure(
  sourcefile(read("./appendix.c"), file:"./appendix.c"),
  caption: [教科書の表 6.1の例に関して、すべての組を列挙するコード]
) <appendix-code>

なお、実装としてはいわゆる Bit 全探索というもので、$2^4$ 通りある集合を全探索するものである。
