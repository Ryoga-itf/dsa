#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAT_MAX 256               // パターンの最大の長さ
#define TEXT_MAX 1024 * 1024 * 10 // テキストの最大の長さ（10 MB）

bool isVerbose = false; // 比較回数表示スイッチ
unsigned int Ncmp = 0;  // 比較回数のカウンタ

int readFile(char *, char *);
bool cmp(char, char);

/**
 * 単純照合法による文字列照合．
 * @param text テキスト
 * @param pat 検索パターン
 * @return 照合に成功した位置．失敗した場合は -1．
 */
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

/**
 * メイン関数
 * @param argc
 * @param argv
 * @return 終了ステータス：正常終了 0 / それ以外 1
 */
int main(int argc, char **argv) {
    char pat[PAT_MAX]; // 検索パターン
    char *text = (char *)malloc(TEXT_MAX * sizeof(char));
    int patlen = 0;
    int textlen = 0;

    // 引数処理・ファイル読み込み
    if (argc < 3 || 4 < argc) {
        fprintf(stderr, "Usage: ./main [-v] <text file> <pattern file>\n");
        return 1;
    }
    int i = 1;
    if (strcmp(argv[i], "-v") == 0) {
        isVerbose = true;
        i++;
    }
    textlen = readFile(argv[i++], text);
    patlen = readFile(argv[i], pat);

    // pat 末尾の改行コードを削除
    while (pat[patlen - 1] == '\r' || pat[patlen - 1] == '\n')
        pat[--patlen] = '\0';

    // 文字列照合・結果表示
    if (isVerbose) {
        printf("text size: %d\n", textlen);
        printf("pattern size: %d\n", patlen);
    }
    printf("Pattern found at %d.\n", naive(text, textlen, pat, patlen));
    if (isVerbose)
        printf("# of comparison(s): %d.\n", Ncmp);

    free(text);

    return 0;
}
