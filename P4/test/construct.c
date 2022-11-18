#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
typedef long long LL;
char* s[40] = {"add", "sub", "ori", "lui", "lw",
               "sw",  "beq", "jal", "jr",  "nop"};
int need1[40] = {1, 1, 1, 1, 1, 1, 1, 0, 1, 0};
int need2[40] = {1, 1, 1, 2, 4, 4, 1, 0, 0, 0};
int need3[40] = {1, 1, 2, 0, 0, 0, 0, 0, 0, 0};  //ÿ��ָ�������Ҫ���������
int n;
int ins_range = 10;  //ѡ��ָ���������P5��10��P6��29
int next[1010];
int nextcnt;
int lastins = -1;
int curins;
int lastwrite, curwrite;  //��һ���Ƿ�д���˼Ĵ�������д����һ�������滻
int getjal;

int getrand(int need) {
    if (need == 1)  //�Ĵ����������
        return rand() % 32;
    if (need == 2)  //�޷������������ɣ���Χ0~65535
        return (rand() + rand() + (rand())) % 65536;  //����rand��Χ0~32767
    if (need == 3)  //�����з�������������Χ-32768~32767
        return ((rand() + rand() + (rand())) % 65536) - 32768;
    if (need == 4)
        return (rand() % 3072) * 4;
    if (need == 5)
        return (rand() % 10);
}
int judge() {  //�ṩһ��70%Ϊ��ĸ���
    return ((rand() % 10) <= 6);
}
int main() {
    freopen("..\\random_code.asm", "w", stdout);
    srand(time(0));
    n = 10 + rand() % 91;
    for (int i = 0; i < n; i++) {
        curins = getrand(5);
        if (lastins == 7)
            getjal = 1;
        while ((lastins <= 8) && (lastins >= 6) && (curins >= 6) &&
               (curins <= 8)) {
            curins = getrand(5);
        }  //��֤�ӳٲ���ָ�Ϊ��ת
        while (((i >= (n / 2)) || (i <= 10)) && (curins >= 6) &&
               (curins <= 8)) {
            curins = getrand(5);
        }
        while ((!getjal) && (curins == 8)) {
            curins = getrand(5);
        }
        if (next[i])
            printf("next%d: ", next[i]);
        if (curins == 6 || curins == 7) {
            nextcnt++;
            int offset = 2 + (rand() % (n - i - 5));
            next[i + offset] = nextcnt;
        }
        printf("%s ", s[curins]);
        if (curins == 0 || curins == 1) {
            curwrite = getrand(1);
            printf("$%d,$%d,$%d\n", curwrite,
                   (judge() == 1) ? lastwrite : getrand(1), getrand(1));
        }
        if (curins == 2) {
            curwrite = getrand(1);
            printf("$%d,$%d,%d\n", curwrite,
                   (judge() == 1) ? lastwrite : getrand(1), getrand(2));
        }
        if (curins == 3) {  // lui $1
            curwrite = getrand(1);
            printf("$%d,%d\n", curwrite, getrand(2));
        }
        if (curins == 5 || curins == 4) {  // lw $1,4($0)
            curwrite = getrand(1);
            printf("$%d,%d($0)\n", (judge() == 1) ? curwrite : lastwrite,
                   getrand(4));
        }
        if (curins == 6) {  // beq $0,$7,next2
            printf("$%d,$%d,next%d\n",
                   ((judge() == 1)) ? lastwrite : getrand(1),
                   ((judge() == 1)) ? 0 : getrand(1), nextcnt);
        }
        if (curins == 7) {  // jal next3
            printf("next%d\n", nextcnt);
        }
        if (curins == 8) {  // jr $31
            printf("$31\n");
        }
        if (curins == 9) {
            puts("");
        }

        lastwrite = curwrite;
        lastins = curins;
    }
    printf("testend: nop\n");
}