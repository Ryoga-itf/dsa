#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * ファイルを読み込みむ．
 * @param path 読み込むファイルのパス
 * @param str 読み込んだ文字列を格納する配列へのポインタ
 * @return 読み込んだファイルのサイズ（バイト数）．
 */
int readFile(char *path, char *str) {
    FILE *fp = NULL;

    fp = fopen(path, "r");
    if ((fp = fopen(path, "r")) == NULL) {
        perror("Cannot not open file");
        exit(1);
    }

    int len = 0;
    while (!feof(fp))
        str[len++] = (char)fgetc(fp);
    fclose(fp);
    str[--len] = '\0'; // 末尾のEOFを削除
    return len;
}
