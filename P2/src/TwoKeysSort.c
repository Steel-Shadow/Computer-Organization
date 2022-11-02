// 第一行读取n，为要排序的对象个数
// 接下来2n行，期中第2i行对应第i个元素的关键字A， 第2i+1行对应第i个元素的关键字B
// 以A为第一关键字，B为第二关键字进行降序排序
// 输出排序后的结果，每个对象一行，包含两个数字
// 保证n<1000
#include <stdio.h>
#include <stdlib.h>
int a[1005];

int main() {
    int n;
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        int A, B;
        scanf("%d", &A);
        scanf("%d", &B);
        a[2 * i] = A;
        a[2 * i + 1] = B;
    }

    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (a[2 * j] < a[2 * j + 2]) {
                int t5 = a[2 * j];
                int t6 = a[2 * j + 1];

                a[2 * j] = a[2 * j + 2];
                a[2 * j + 1] = a[2 * j + 3];

                a[2 * j + 2] = t5;
                a[2 * j + 3] = t6;
            } else if (a[2 * j] == a[2 * j + 2]) {
                if (a[2 * j + 1] < a[2 * j + 3]) {
                    int t5 = a[2 * j];
                    int t6 = a[2 * j + 1];

                    a[2 * j] = a[2 * j + 2];
                    a[2 * j + 1] = a[2 * j + 3];

                    a[2 * j + 2] = t5;
                    a[2 * j + 3] = t6;
                }
            }
        }
    }

    for (int i = 0; i < n; i++) {
        printf("%d %d\n", a[2 * i], a[2 * i + 1]);
    }
    return 0;
}