#include <stdlib.h>
#include <stdio.h>

#define alpha void*

typedef struct _list {
    alpha head;
    struct _list *tail;
} *list;

list cons(alpha head, list tail) {
    list l = malloc(sizeof(struct _list));
    l->head = head;
    l->tail = tail;
    return l;
}

list append(list l1, list l2) {
    if(l1==NULL) return l2;
    return cons(l1->head, append(l1->tail,l2));
}

list filter(int (*p)(alpha), list l) {
    if(l == NULL) return NULL;
    list tl = filter(p, l->tail);
    if(p(l->head)) return cons(l->head, tl);
    else return tl;
}

list map(alpha (*f)(alpha, alpha), list l, alpha param) {
    if(l == NULL) return NULL;
    return cons(f(l->head, param), map(f,l->tail, param));
}

list concmap(list (*f)(alpha, alpha), list l, alpha param) {
    if(l == NULL) return NULL;
    return append(f(l->head, param), concmap(f, l->tail, param));
}

int length(list l) {
    if(l == NULL) return 0;
    int n = length(l->tail);
    return 1 + n;
}

list interval(int n, int m) {
    if (n > m) return NULL;
    else return cons(n, interval(n+1,m));
}

int safe(int d, int x, list l) {
    if(l == NULL) return 1;
    int q = l->head;
    return (x != q) && (x != q+d) && (x != q-d) && safe(d+1,x,l->tail);
}

int ok(list l) {
    if(l == NULL) return 1;
    return safe(1, l->head, l->tail);
}

list testcol(list b, list qs) {
    return filter(ok, map(cons, qs, b));
}

list gen(int n, list qs) {
    if(n == 0) return cons(NULL, NULL);
    list l = gen(n-1, qs);
    return concmap(testcol, l, qs);
}

int queens(int n) {
    return length(gen(n, interval(1, n)));
}

int main() {
    int start = millis();
    for(int i = 0; i < 10000; i++) {
        for(int j = 1; j <= 6; j++) {
            queens(j);
        }
    }
    int end = millis();
    printf("%d\n", end-start);
    return 0;
}
