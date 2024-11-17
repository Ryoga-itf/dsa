// Find the greatest common divisor of the two integers, n and m.
int gcd_recursive(int n, int m) { return m != 0 ? gcd_recursive(m, n % m) : n; }
