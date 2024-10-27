#import "../template.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.1": sourcecode, sourcefile

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: 1,
  name: "C によるプログラミングの復習",
  authors: (
    (
      name: env.STUDENT_NAME,
      email: env.STUDENT_ID,
      affiliation: env.STUDENT_AFFILIATION
    ),
  ),
  deadline: "2024 年 10 月 16 日",
  date: "2024 年 10 月 7 日",
)

== 基本課題

=== 課題1

本課題は `gcd_iter.c` および `main_iter.c` を入力、コンパイルし、実際に動作を確かめるというものである。
本課題の指示にレポートでの報告は不要である、とあるのでここでは省略する。

=== 課題2

以下に実装した gcd_euclid 関数を示す。

#sourcefile(read("./gcd_euclid.c"), file:"./gcd_euclid.c")

また、以下に実行結果を示す。実行においては、n = 333, m = 57 および n = 12, m = 144 で試している。

#sourcecode[```
$ ./gcd_euclid 333 57
The GCD of 333 and 57 is 3.

$ ./gcd_euclid 12 144
The GCD of 12 and 144 is 12.
```]

=== 課題3

`gcd_iter(16, 12)` の動作について考える。

- 関数冒頭の処理により、$𝑛 = 12, 𝑚 = 16$ となる
- 変数 `gcd` が $1$ に、i が 1 に初期化される 
- `while` ループに入る
  - `if` の条件中の式は `true` と評価され、`gcd` は $1$ になる
  - `i` がインクリメントされ、$2$ になる
- `while` の条件 `i <= n` は `true` であるからループが続く
  - `if` の条件中の式は `true` と評価され、`gcd` は $2$ になる
  - `i` がインクリメントされ、$3$ になる
  - 同様にループが続き、`i = 4` のときに `gcd = 4` となる
  - 同様にループが続き、`i = 12` のとき、`i` がインクリメントされ、`i = 13` になり、条件を満たさなくなるため `while` ループを抜ける
- 戻り値として `4` が返る

`gcd_euclid(16, 12)` の動作について考える。

- `while` ループに入る
  - 変数 `tmp` に $𝑛 = 16$ を $𝑚 = 12$ で割った余りである $4$ が代入される
  - `n` が `m` に、`m` が `tmp` に更新される。
- `while` の条件 `m != 0` は `true` と評価されるため、ループが続く
  - 変数 `tmp` に `𝑛 = 12` を `𝑚 = 4` で割った余りである $0$ が代入される
  - `n` が `m` に、`m` が `tmp` に更新される。
- `while` の条件 `m != 0` は `false` と評価されるため、ループから抜ける
- 戻り値として `𝑛` すなわち $4$ が返る

== 応用課題

=== 課題1

`gcd_iter` の計算量について考える。

この関数は、$n, m$ を $1$ から $min(n, m)$ までの数で割り、その余りを確認している。
よって、`gcd_iter(n, m)` の計算は $Omicron(min(n, m))$ で行える。

また、領域計算量は $Omicron(1)$ である。

`gcd_euclid` の計算量について考える。

$n > m > 0$ であり、$n$ を $m$ で割った余りが $q$ であるとする。

$
n >= 2m => m + q <= m + m <= 2/3 (n + m) \
n <= 2m => m + q <= m + (n - m) <= 2/3 (n + m)
$

であるから、ユークリッドの互除法の計算を $1$ ステップ進めると、$2$ 数の和が $2/3$ 倍以下になることがわかる。
したがって、`gcd_euclid(n, m)` の計算は $Omicron(log(n + m))$ で行える。

特に、$1$ 回目の除算においては、どちらも $min(n, m)$ 以下になるため、$Omicron(log min(n, m))$ とすることもできる。

また、領域計算量は $Omicron(1)$ である。

以上より、それぞれの計算量（時間計算量，領域計算量）は 表 1 のようになる。

#figure(
  table(
    columns: 3,
    [], [*時間計算量*], [*領域計算量*],
    [`gcd_iter`], [$Omicron(min(n, m))$], [$Omicron(1)$],
    [`gcd_euclid`], [$Omicron(log min(n, m))$], [$Omicron(1)$],
  ),
  caption: [`gcd_iter` と `gcd_euclid` の計算量]
)

=== 課題2

以下に実装した `gcd_recursive` 関数を示す。

#sourcefile(read("./gcd_recursive.c"), file:"./gcd_recursive.c")

`gcd_recursive(16, 12)` の動作について考える。

- `gcd_recursive(16, 12)` が呼び出される
  - `12 != 0` であるため、`gcd_recursive(12, 16 % 12)` すなわち `gcd_recursive(12, 4)` が呼び出される
    - `4 != 0` であるため、`gcd_recursive(4, 12 % 4)` すなわち `gcd_recursive(4, 0)` が呼び出される
      - `0 != 0` ではないため、`n` すなわち `4` が返る
    - `gcd_recursive(4, 0)` すなわち `4` が返る
  - `gcd_recursive(12, 4)` すなわち `4` が返る
- `4` が返る
