int fibo(int n) {
    if (n <= 1) return n;
    return fibo(n-1) + fibo(n-2);
}

int main() {
    int start = millis();
    for (int i = 0; i < 1000000; i++) {
        fibo(5);
    }
    int end = millis();
    printf("%d\n", end-start);
    return 0;
}
