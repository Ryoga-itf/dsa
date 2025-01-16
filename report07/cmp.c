#include <stdbool.h>
#include <stdio.h>

extern bool isVerbose;
extern int Ncmp;

/**
 * 文字比較関数．比較回数をカウントする．
 * @param a 比較文字
 * @param b 比較文字
 * @return a と b が等しければ true, 等しくなければ false.
 */
bool cmp(char a, char b) {
    if (isVerbose)
        fprintf(stderr, "cmp(%c, %c)\n", a, b);
    Ncmp++;
    if (a == b)
        return true;
    else
        return false;
}
