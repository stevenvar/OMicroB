

#include <stdio.h>

int gcd(m,n)
int m,n;
{ if (m == n) return m;
   else if (m < n) return gcd(m,n-m);
   else return gcd(m-n,n);
}

int repeat (n)
int n;
{if (n<=0) {return(0);}
 else {return (gcd(500001,500003) +  repeat(n-1));}
}

main()
{int i;
 printf("%d\n", repeat(200));
}

