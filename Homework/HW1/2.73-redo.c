#include <stdio.h>
#include <limits.h>
#define INT_ADD_OVERFLOW_P(a, b) \
  __builtin_add_overflow_p (a, b, (__typeof__ ((a) + (b))) 0)

int saturating_add(int x, int y){
  int sum = x+ y;
  int x_sig_bit = x >> 31;
  int y_sig_bit = y >> 31;

  //get the significant bits of 
  //the function call will be true or false which corresponds to 0 and 1 in bit representation
  int overflow = INT_ADD_OVERFLOW_P (x,y);
  //if there is an overflow, the value of overflow would be 1
  overflow = ~(overflow) + 1;
  //now figure out if they are both positive or negative
  int both_positive = ~(x_sig_bit) & ~(y_sig_bit);
  int both_negative = x_sig_bit & y_sig_bit;

  //now figure out if there has been an overflow
  int positive_overflow_occured = overflow & both_positive;
  int negative_overflow_occured = overflow & both_negative;

  //now return based on positive overflow
  return ((positive_overflow_occured & INT_MAX) | (negative_overflow_occured & INT_MIN) | ((~positive_overflow_occured) & (~negative_overflow_occured) & sum));
}


int main()
{
  int x = saturating_add(INT_MAX, 10);
  printf("%d \n", x);

  int y = saturating_add(INT_MIN, -10);
  printf("%d \n", y);

  int g = saturating_add(38, -4);
  printf("%d \n", g);

  g = saturating_add(38, 4);
  printf("%d \n", g);

  g = saturating_add(-38, 4);
  printf("%d \n", g);

  g = saturating_add(-38, -4);
  printf("%d \n", g);
  return 0;
}
