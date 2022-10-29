#include <stdio.h>
#include <stdlib.h>

int n, m;  // n=s0  m=s1
int graph[7][7];
int x0, Y0;  // x0=s2 Y0=s34
int x1, Y1;  // x1=s4 Y1=s5
int ans;     // ans = s6

void fun(int x, int y) {
    if (graph[x][y] == 1) {  // 1 可走 0不可走

        if (x == x1 && y == Y1) {
            ans++;
            return;
        }

        graph[x][y] = 0;
        fun(x + 1, y);
        fun(x - 1, y);
        fun(x, y + 1);
        fun(x, y - 1);
        graph[x][y] = 1;
    }

    return;
}

int main() {
    scanf("%d%d ", &n, &m);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            int t;
            scanf("%d", &t);
            graph[i][j] = (1 - t);
        }
    }
    scanf("%d%d", &x0, &Y0);
    x0--;
    Y0--;
    scanf("%d%d", &x1, &Y1);
    x1--;
    Y1--;

    fun(x0, Y0);
    printf("%d", ans);
    return 0;
}