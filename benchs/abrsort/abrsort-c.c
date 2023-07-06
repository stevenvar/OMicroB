#include <stdlib.h>

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

void free_list(list l) {
    if(l == NULL) return;
    free_list(l->tail);
    free(l);
}

typedef struct _tree {
    alpha d;
    struct _tree *l;
    struct _tree *r;
} *tree;

tree node(alpha d, tree l, tree r) {
    tree t = malloc(sizeof(struct _tree));
    t->d = d;
    t->l = l;
    t->r = r;
    return t;
}

list init(int n, alpha (*f)(alpha)) {
    list l = NULL;
    while(n > 0) {
        l = cons(f(n), l);
        n--;
    }
    return l;
}

alpha fold_left(alpha (*f)(alpha, alpha), alpha accu, list l) {
    while(l) {
        accu = f(accu,l->head);
        l = l->tail;
    }
    return accu;

}

tree add(tree t, alpha a) {
    if(t==NULL) return node(a, NULL, NULL);
    alpha x = t->d;
    if(a < x) {
        t->l = add(t->l, a);
    } else {
        t->r = add(t->r, a);
    }
    return t;
}

list append(list l1, list l2) {
    if(l1==NULL) return l2;
    return cons(l1->head, append(l1->tail,l2));
}

list to_list(tree t) {
    if(t==NULL) return NULL;
    return append(to_list(t->l), cons(t->d,to_list(t->r)));
}

list tree_sort(list l) {
    return to_list(fold_left(add, NULL, l));
}

int my_random(int n) {
    float r = rand() / (float)RAND_MAX;
    return (r * n);
}

int main() {
    list l;
    int start = millis();
    for(int i = 0; i < 10000; i++) {
        l = tree_sort(init(100, my_random));
    }
    int end = millis();
    printf("%d\n", end-start);
    return 0;
}
