#include "doublylinked_list.h"
#include <stdio.h>

void test_insert();
void test_delete();
void test_search();
void test_array_io();
void test_file_io();

int main() {
    test_insert();
    test_delete();
    test_search();
    test_array_io();
    test_file_io();

    return 0;
}

// 挿入テスト: 先頭、末尾、中間にセルを挿入できるか確認
void test_insert() {
    printf("Insert Test:\n");

    Cell *head = CreateCell(0, true);

    // 先頭にセルを挿入
    InsertNext(head, CreateCell(1, false));

    // 中間にセルを挿入
    InsertNext(head->next, CreateCell(2, false));

    // 末尾にセルを挿入
    InsertPrev(head, CreateCell(3, false));

    Display(head);        // Expected output: 1 2 3
    DisplayReverse(head); // Expected output: 3 2 1
    printf("\n");
}

// 削除テスト: 先頭、末尾、中間のセルを削除できるか確認
void test_delete() {
    printf("Delete Test:\n");

    Cell *head = CreateCell(0, true);
    InsertNext(head, CreateCell(1, false));
    InsertNext(head->next, CreateCell(2, false));
    InsertPrev(head, CreateCell(3, false));

    // 中間のセルを削除
    DeleteCell(head->next->next); // 2を削除
    Display(head);                // Expected output: 1 3

    // 先頭セルを削除
    DeleteCell(head->next); // 1を削除
    Display(head);          // Expected output: 3

    // 末尾セルを削除
    DeleteCell(head->prev); // 3を削除
    Display(head);          // Expected output: (空)

    printf("\n");
}

// 検索テスト: 先頭、末尾、中間のセルを検索できるか確認
void test_search() {
    printf("Search Test:\n");

    Cell *head = CreateCell(0, true);
    InsertNext(head, CreateCell(1, false));
    InsertNext(head->next, CreateCell(2, false));
    InsertPrev(head, CreateCell(3, false));

    // 先頭のセルを検索
    Cell *found = SearchCell(head, 1);
    if (found) {
        printf("Found: %d\n", found->data); // Expected output: Found: 1
    }

    // 中間のセルを検索
    found = SearchCell(head, 2);
    if (found) {
        printf("Found: %d\n", found->data); // Expected output: Found: 2
    }

    // 末尾のセルを検索
    found = SearchCell(head, 3);
    if (found) {
        printf("Found: %d\n", found->data); // Expected output: Found: 3
    }

    // 存在しないセルの検索
    found = SearchCell(head, 99);
    if (!found) {
        printf("Not Found: 99\n"); // Expected output: Not Found: 99
    }

    printf("\n");
}

// 配列との入出力テスト
void test_array_io() {
    printf("Array I/O Test:\n");

    // 配列からリストに読み込む
    int data[] = {10, 20, 30, 40};
    Cell *head = CreateCell(0, true);
    ReadFromArray(head, data, 4);
    Display(head); // Expected output: 10 20 30 40

    // リストの内容を配列に書き出す
    int output[4];
    WriteToArray(head, output, 4);

    // 配列の内容を確認
    printf("Array output:");
    for (int i = 0; i < 4; ++i) {
        printf(" %d", output[i]); // Expected output: Array output: 10 20 30 40
    }
    printf("\n");

    printf("\n");
}

// ファイルとの入出力テスト
void test_file_io() {
    printf("File I/O Test:\n");

    Cell *head = CreateCell(0, true);
    InsertNext(head, CreateCell(100, false));
    InsertNext(head->next, CreateCell(200, false));
    InsertNext(head->next->next, CreateCell(300, false));

    // ファイルに書き出し
    WriteToFile(head, "output.txt");
    printf("List written to file.\n");

    // 新しいリストを作成してファイルから読み込む
    Cell *new_head = CreateCell(0, true);
    ReadFromFile(new_head, "output.txt");
    printf("List read from file:\n");
    Display(new_head); // Expected output: 100 200 300

    printf("\n");
}
