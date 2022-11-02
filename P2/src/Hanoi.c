#include <stdio.h>
int N;

void move(char x, char y) {
    printf("%c -> %c\n", x, y);
}

void Tower(int n, char A, char B, char C) {
    if (n == 1) {
        move(A, C);
    } else {
        Tower(n - 1, A, C, B);
        move(A, C);
        Tower(n - 1, B, A, C);
    }
}

int main() {
    scanf("%d", &N);
    Tower(N, 'A', 'B', 'C');
    return 0;
}