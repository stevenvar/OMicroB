

#include <stdio.h>

double integ(double accu, double x, double (*f)(double), double b, double h) {
  if (x > b) return accu ;
  else return (integ((*f)(x) + accu, x+h, f, b, h));
}

double integrale (double (*f)(double), int a, int b , int n) {
  double h = (double)(b - a) / (double)n ;
  return (integ(0.0, a * h, f, b, h)) ;
}

double poly(double x) {return x * x + 2 * x + 1;}

int repeat (double a, int n) {
 if (n<=0) {return(a);}
 else return repeat(a+ integrale(&poly, 0.0, 1.0, 10000),n-1);
}

int main() {
double t = 2.333583335 ;
double eps = 0.001 ;
double r  =  repeat(0.0,400) ;
    double r2 = (r / 10000) / 400  ;
  if (((t - eps) <= r2) && (t + eps) >= r2)  printf("%f\n",r2);
  else printf("%s %f\n","PB", r2);
}

