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
bool *array = (bool *)malloc(sizeof(bool) * (n + 1) * (sum + 1));
memset(array, 0, sizeof(bool) * (n + 1) * (sum + 1));
for (int i = 0; i <= n; i++) {
    dp[i] = array + (sum + 1) * i;
    dp[i][0] = true;
}
```]

- メモリを動的に確保し、DPテーブル `dp[i][j]` を構築。
- 初期状態 `dp[i][0] = true` を設定することで、合計 0 の部分集合は常に存在することを表す。

2. *DPテーブルの計算*

#sourcecode(numbers-start: 23)[```c
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

#sourcecode(numbers-start: 32)[```c
if (!dp[n][sum]) {
    free(dp[0]);
    free(dp);
    return NULL;
}
```]

- 部分和が存在しない場合はメモリを解放し、`NULL` を返す。

4. *部分集合を復元する処理*

#sourcecode(numbers-start: 38)[```c
bool *S = (bool *)malloc(sizeof(bool) * len);
memset(S, 0, sizeof(bool) * len);

int current = sum;
for (int i = n; i >= 0; i--) {
    if (current - set[i - 1] >= 0 && dp[i][current - set[i - 1]]) {
        S[i - 1] = true;
        current -= set[i - 1];
    }
}

free(dp[0]);
free(dp);
return S;
}
```]

- 後ろから探索し、部分和に寄与した要素を記録していく。
- メモリを解放し、結果を返す。

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

// TODO:

=== 考察

// TODO:
