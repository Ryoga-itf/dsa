#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/cetz:0.3.1"
#import "@preview/cetz-plot:0.1.0": plot, chart

#set math.equation(numbering: "1.")

== 基本課題1

=== 実装の方針

課題で示された以下の @eq1 を元にコードを組み立てればよい。
しかし、後述する理由により一時変数を導入して実装している。

$
G_(k, i) = cases(
  G_(k-1, i)                           && "if" i - w_k < 0,
  max(G_(k-1, i), G_(k-1,i-w_k) + v_k) && "otherwise"
)
$ <eq1>

なお、$k = 0$ であるとき、配列外参照が発生するため、条件分岐により 0 を返すようにする。

=== 実装コード及びその説明

実装した `knapsack.c` を @code1-1 に示す。
なお、与えられた `knapsack.c` には `#include` が含まれていたが、それらは一切必要ないものであったので削除している。
また、`max` マクロは参考実装で与えられたものをそのまま利用している。

#figure(
  sourcefile(read("./knapsack.c"), file:"./knapsack.c"),
  caption: [基本課題 1 の実装コード]
) <code1-1>

@eq1 をナイーブにそのまま実装しようとすると、@code1-2 になるが、
`max` はマクロであり、プリプロセッサによりそのまま展開され、考えられないほど非常に遅くなってしまう。
つまりは、`(knapsack(v, w, k - 1, i) > knapsack(v, w, k - 1, i - w[k]) + v[k] ? knapsack(v, w, k - 1, i) : knapsack(v, w, k - 1, i - w[k]) + v[k])` と展開され、複数回関数が評価されてしまう。
さらに、この関数は再帰関数であるから、手に負えないほど分岐が増えてしまう。

@code1-2 では、#link(<1.2>)[基本課題1.2]を確認するのは無理があると考え、一時変数を導入した @code1-1 とした。

#figure(
  sourcecode[
```c
#define max(a, b) (a > b ? a : b)

int knapsack(int v[], int w[], int k, int i) {
    if (k == 0)
        return 0;

    if (w[k] > i) {
        return knapsack(v, w, k - 1, i);
    } else {
        return max(
            knapsack(v, w, k - 1, i),
            knapsack(v, w, k - 1, i - w[k]) + v[k]
        );
    }
}
```
  ],
  caption: [一時変数を導入しない場合のコード]
) <code1-2>

=== 実行結果

`make` コマンドを用いて適切にコンパイルしたのち、@code1-3 の通り実行を行った。また結果も示している。

#figure(
  sourcecode[```
  $ make knapsack
  cc    -c -o knapsack.o knapsack.c
  cc   knapsack.o knapsackMain.o   -o knapsack

  $ ./knapsack 4 4     
  結果：770

  $ ./knapsack 5  
  容量：25
  結果：223
  実行時間：0.000004 sec.

  $
  ```],
  caption: "実行結果"
) <code1-3>

=== 基本課題 1.1

本課題は、教科書の表 6.1の例に関して，荷物の数が4, 容量が3,4,5の場合の実行結果が正しいことを確認するというものである。

実行結果を @code1-4 に示す。

#figure(
  sourcecode[```
  $ ./knapsack 4 3     
  結果：630

  $ ./knapsack 4 4
  結果：770

  $ ./knapsack 4 5
  結果：900

  $
  ```],
  caption: "教科書の表 6.1の例に関して、荷物の数が4、容量が3,4,5の場合の実行結果"
) <code1-4>

実行結果が正しいことを確認する。

/ 容量が 3 の場合:
  
  - 1 番目の荷物（重さ 1, 価値 250）
  - 2 番目の荷物（重さ 2, 価値 380）

  を選ぶとき価値の合計は 630 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。
  
/ 容量が 4 の場合:
  
  - 1 番目の荷物（重さ 1, 価値 250）
  - 4 番目の荷物（重さ 4, 価値 520）

  を選ぶとき価値の合計は 770 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。

/ 容量が 5 の場合:
  
  - 2 番目の荷物（重さ 1, 価値 380）
  - 4 番目の荷物（重さ 4, 価値 520）

  を選ぶとき価値の合計は 900 と最大となり、これ以外に価値の合計を大きくする組合せはない。
  実行結果として得られた値は正しい。

以上より、本課題の要件を確認することができた。

=== 基本課題 1.2 <1.2>

本課題は、knapsack 関数の実行時間が荷物の数に関して指数関数的であることを、確認するというものである。

作成したプログラムに対して、荷物の数として与える引数が25〜30の場合の実行時間を確認する。
その様子を @code1-5 に示す。

#figure(
  sourcecode[```
  $ seq 25 30 | xargs -I {} ./knapsack {}
  容量：125
  結果：1300
  実行時間：0.245991 sec.
  容量：130
  結果：1344
  実行時間：0.456756 sec.
  容量：135
  結果：1090
  実行時間：0.881770 sec.
  容量：140
  結果：1287
  実行時間：1.753688 sec.
  容量：145
  結果：1246
  実行時間：3.529323 sec.
  容量：150
  結果：1333
  実行時間：7.159160 sec.

  $
  ```],
  caption: "荷物の数が25〜30の場合の実行時間を確認した様子"
) <code1-5>

この実行結果をまとめると、@table1 のようになる。

#let data = (
  (25, 0.245991),
  (26, 0.456756),
  (27, 0.881770),
  (28, 1.753688),
  (29, 3.529323),
  (30, 7.159160),
)

#figure(
  table(
    columns: (auto, auto),
    inset: 7pt,
    align: center,
    table.header(
      [*$N$*], [*実行時間 (秒)*],
    ),
    ..data.flatten().map(v => [$#v$])
  ),
  caption: [物の数が25〜30の場合の実行時間]
) <table1>

また、グラフとしてプロットすると @fig1 のようになり、概ね指数関数的に実行時間が増えていることが確認できる。

#figure(
  cetz.canvas({
    plot.plot(
      size: (15, 9),
      x-label: [$N$],
      x-min: 25,
      x-max: 30,
      x-grid: "major",
      x-tick-step: 1,
      y-tick-step: 0.5,
      y-label: [実行時間 (秒)],
      y-max: 7.5,
      y-min: 0,
      y-grid: "major",
      {
        plot.add(data)
      }
    )
  }),
  caption: [@table1 をグラフにプロットした様子]
) <fig1>

=== 考察

この実装は、@eq1 をそのままコードに書き起こすだけなので実装難易度が非常に低いという利点がある。
しかし、時間計算量は指数関数的であるので大規模なデータには向かない。

また、@code1-2 において一時変数を導入しない実装を挙げたが、これを実行してみるととんでもなく遅くなった。
しかし、これはコンパイラの最適化により改善できるのではないかと考え、`-O3` フラグをつけてコンパイルしてみると以下のようなアセンブリが得られた。

@code1-6 及び @code1-7 にそれを示す。

#show figure: set block(breakable: true)

#figure(
  sourcecode[```asm
_Z8knapsackPiS_ii:
        test    edx, edx
        je      .L5
        push    r15
        push    r14
        mov     r14d, ecx
        push    r13
        mov     r13, rsi
        push    r12
        mov     r12, rdi
        push    rbp
        push    rbx
        movsx   rbx, edx
        sub     rsp, 24
        jmp     .L3
.L4:
        sub     rbx, 1
        mov     eax, ebx
        test    ebx, ebx
        je      .L1
.L3:
        mov     ebp, DWORD PTR [r13+0+rbx*4]
        cmp     ebp, r14d
        jg      .L4
        lea     edx, [rbx-1]
        mov     ecx, r14d
        mov     rsi, r13
        mov     rdi, r12
        mov     DWORD PTR [rsp+12], edx
        call    _Z8knapsackPiS_ii
        mov     edx, DWORD PTR [rsp+12]
        mov     ecx, r14d
        mov     rsi, r13
        sub     ecx, ebp
        mov     rdi, r12
        mov     r15d, eax
        call    _Z8knapsackPiS_ii
        add     eax, DWORD PTR [r12+rbx*4]
        cmp     eax, r15d
        jl      .L4
.L1:
        add     rsp, 24
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        ret
.L5:
        xor     eax, eax
        ret
  ```],
  caption: [x86_64 gcc で -O3 フラグをつけた場合に @code1-2 をコンパイルした場合に生成されるアセンブリ],
) <code1-6>


#figure(
  sourcecode[```asm
_Z8knapsackPiS_ii:
        push    rbp
        push    r15
        push    r14
        push    r12
        push    rbx
        test    edx, edx
        je      .LBB0_4
        movsxd  rbx, edx
        dec     rbx
.LBB0_2:
        mov     ebp, ecx
        sub     ebp, dword ptr [rsi + 4*rbx + 4]
        jge     .LBB0_6
        mov     rax, rbx
        dec     rax
        test    ebx, ebx
        mov     rbx, rax
        jne     .LBB0_2
.LBB0_4:
        xor     eax, eax
        jmp     .LBB0_5
.LBB0_6:
        mov     r14, rdi
        mov     r15, rsi
        mov     edx, ebx
        call    _Z8knapsackPiS_ii
        mov     r12d, eax
        mov     rdi, r14
        mov     rsi, r15
        mov     edx, ebx
        mov     ecx, ebp
        call    _Z8knapsackPiS_ii
        add     eax, dword ptr [r14 + 4*rbx + 4]
        cmp     r12d, eax
        cmovg   eax, r12d
.LBB0_5:
        pop     rbx
        pop     r12
        pop     r14
        pop     r15
        pop     rbp
        ret
  ```],
  caption: [x86_64 clang 18.1.0 で -O3 フラグをつけた場合に @code1-2 をコンパイルした場合に生成されるアセンブリ],
) <code1-7>

コンパイラは `knapsack` 関数が純粋関数であることを見事に見抜き最適化され、呼び出し回数が削減されていることがわかる。

さらに、末尾再帰による最適化もなされていることもわかる。

基本課題1.2 において、`-O3` をつけて実行結果を確認してみると、@code1-8 のようになった。

#figure(
  sourcecode[```
$ seq 25 30 | xargs -I {} ./knapsack {}
容量：125
結果：1318
実行時間：0.072028 sec.
容量：130
結果：1392
実行時間：0.105721 sec.
容量：135
結果：1463
実行時間：0.207530 sec.
容量：140
結果：1523
実行時間：0.419270 sec.
容量：145
結果：1658
実行時間：0.840391 sec.
容量：150
結果：1162
実行時間：1.702120 sec.

$
  ```],
  caption: "荷物の数が25〜30の場合の実行時間を確認した様子 (最適化あり)"
) <code1-8>

確かにかなり高速に動作するようになったが、計算量自体は指数関数から落ちていないため、まだ大規模なデータに対しては実用的であるとはいえない。
