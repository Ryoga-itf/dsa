// Find the greatest common divisor of the two integers, n and m.
int gcd_euclid(int n, int m) {
    while (m != 0) {
        const int tmp = n % m;
        n = m;
        m = tmp;
    }
    return n;
}
