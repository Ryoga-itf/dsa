#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/cetz:0.3.1"
#import "@preview/cetz-plot:0.1.0": plot, chart

== 発展課題2 部分和問題

=== 実装の方針

- 関数 `subsetSum` は，集合を表現する配列 `set` の `n` 番目までの要素に対して、部分和が `sum` となるような部分集合を探索する。
- 部分和が `sum` となる部分集合が存在するとき、部分集合を表現する `bool` 型の配列を返す。それ以外の場合は `NULL` を返す。

という仕様を実装する。

実装方針として以下のような手順を採用した。

1. *DPテーブルの準備:*
   - `dp[i][j]` は、`set[0]` から `set[i - 1]` までの要素で、合計が `j` になるかを示すブール値。  
   - `dp[i][0] = true` は初期状態として正しい（合計 0 は常に作れる）。  

2. *DPテーブルの構築:*
   - 要素 `set[i]` を使う場合と使わない場合の両方を考慮し、部分和が作れるかを判定する。  
   - 状態遷移は以下の通り：
     - `dp[i + 1][j] |= dp[i][j - set[i]]`: 要素 `set[i]` を使った場合  
     - `dp[i + 1][j] |= dp[i][j]`: 要素 `set[i]` を使わない場合
  - 論理和代入演算子を用いることができるので、これを用いて工夫する。

3. *部分集合の復元:*
   - `dp[n][sum]` が真であれば、部分和が作れることが判明した状態。  
   - ナップサックの復元のように後ろから選ばれた要素を記録することで部分集合を復元する。

=== 実装コード及びその説明

実装した `subsetSum.c` を @code4-1 に示す。

#show figure: set block(breakable: true)

#figure(
  sourcefile(read("./subsetSum.c"), file:"./subsetSum.c"),
  caption: [発展課題 2 の実装コード],
) <code4-1>

このコードは実装の方針で述べたものの通りに実装している。

以下に主要部分の説明を述べる。

1. *メモリ確保*

#sourcecode(numbers-start: 15)[```c
bool **dp = (bool **)malloc(sizeof(bool *) * (n + 1));
bool *array = (bool *)calloc((n + 1) * (sum + 1), sizeof(bool));
for (int i = 0; i <= n; i++) {
    dp[i] = array + (sum + 1) * i;
    dp[i][0] = true;
}
```]

- メモリを動的に確保し、DPテーブル `dp[i][j]` を構築。
- 初期状態 `dp[i][0] = true` を設定することで、合計 0 の部分集合は常に存在することを表す。

2. *DPテーブルの計算*

#sourcecode(numbers-start: 22)[```c
for (int i = 0; i < n; i++) {
    for (int j = 0; j <= sum; j++) {
        if (j - set[i] >= 0) {
            dp[i + 1][j] |= dp[i][j - set[i]];
        }
        dp[i + 1][j] |= dp[i][j];
    }
}
```]

- 要素 `set[i]` を使う場合、`j >= set[i]` のときに部分和が可能かを確認。
- 要素を使わない場合もそのまま遷移状態を維持。

3. *部分和が存在しない場合の処理*

#sourcecode(numbers-start: 31)[```c
if (!dp[n][sum]) {
    free(dp[0]);
    free(dp);
    return NULL;
}
```]

- 部分和が存在しない場合はメモリを解放し、`NULL` を返す。

4. *部分集合を復元する処理*

#sourcecode(numbers-start: 37)[```c
bool *S = (bool *)malloc(sizeof(bool) * len);
memset(S, 0, sizeof(bool) * len);

int current = sum;
for (int i = n - 1; i >= 0; i--) {
    if (current - set[i] >= 0 && dp[i][current - set[i]]) {
        S[i] = true;
        current -= set[i];
    }
}

free(dp[0]);
free(dp);
return S;
```]

- 後ろから探索し、部分和に寄与した要素を記録していく。
- メモリを解放し、結果を返す。

また、`subsetSumMain.c` において `subsetSum` の結果を保持している変数 `S` のメモリ解放処理が無かったため、
`free(S);` を適切な位置に入れた。（もっともこの後にプロセスがすぐ死ぬので不要ではあるが、一般的には適切でないと考えられることが多いため）

=== 実行結果 <run-4>

`make` コマンドを用いて適切にコンパイルしたのち、@code4-2 の通り実行を行った。また結果も示している。

#figure(
  sourcecode[```
  $ make subsetSum
  cc    -c -o subsetSum.o subsetSum.c
  cc    -c -o subsetSumMain.o subsetSumMain.c
  cc   subsetSum.o subsetSumMain.o   -o subsetSum

  $ ./subsetSum 4 21
  部分集合3 7 11

  $ ./subsetSum 4 22
  部分集合7 15

  $ ./subsetSum 4 23
  条件を満たす部分集合はない．

  $
  ```],
  caption: "実行結果"
) <code4-2>

=== 発展課題2.1

本課題は、#link(<run-4>)[実行結果]で確認済みである、
示された実行例において正しく動くことが確認できている。

=== 発展課題2.2

本課題は、配列setを10要素程度の適当な配列に変更し、プログラムの動作を確認するというものである。

`subsetSumMain.c` 内の `set` と `len` の定義を以下のように変更した。

#sourcecode[```c
int set[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
int len = 10;
```]

また、プログラムの動作を確認すると @code4-3 のようになった。

#figure(
  sourcecode[```
$ ./subsetSum 10 100                   
部分集合5 7 17 19 23 29                                                   

$ ./subsetSum 10 129
部分集合2 3 5 7 11 13 17 19 23 29                                              

$ ./subsetSum 10 1  
条件を満たす部分集合はない．

$ ./subsetSum 10 130
条件を満たす部分集合はない．

$ ./subsetSum 10 28 
部分集合5 23                                                                        

$ ./subsetSum 10 11 
部分集合11                                                                          

$ ./subsetSum 10 45
部分集合3 13 29                                                                     

$ ./subsetSum 10 14
部分集合3 11                                                                        

$ ./subsetSum 10 89 
部分集合5 13 19 23 29                                                               

$
  ```],
  caption: "実行結果"
) <code4-3>

`set` をすべて合計すると、129 になる。
`10, 129` を引数に与えて実行したものは、10 要素すべてが出力された。
また、`10 130` （合計以上）にすると条件を満たす部分集合はないと報告された。

同様に他の例についても期待通りの出力が得られた。

=== 考察

DP 配列が `bool` 型であるときは、論理和代入演算子など普段あまり使わないような演算子が有用であると感じた。

また、今回実装した動的計画法は時間計算量 $Omicron(n dot "sum")$ で動作することが、コードを観察することでわかる。
