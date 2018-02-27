#include <stdio.h>
#include <limits.h>

int saturating_add(int x, int y){

  int sum = x + y; //get the result of the addition
  
  //we can assume that for getting the msb we can shift the integer by 31 units

//now find out if x, and y are positive or negative
  //for representing postive,produce 1111...1, negative 0000...0
  int x_significant_bit = x >> 31; //after arithmetic shift
  int y_significant_bit = y >> 31; //this will be an arithmetic shift
  
  //now find out if there has been a positive overflow or negative overflow
  //now find out if there has been an overflow
  //if we use exclusive OR, we can get the most significant bit to represent if there has been an overflow and if we shift it to the right, we get 111...1 or 0000...00
  int overflow = (x^sum) >> 31;

  //now find out if the two are positive or negative
  int both_negative = x_significant_bit & y_significant_bit;
  int both_positive = (~x_significant_bit) & (~y_significant_bit);

    //now decide if there has been positive overflow
    int positive_overflow_occured = overflow & both_positive;
  int negative_overflow_occured = overflow & both_negative;

  //now we know that & (and) with 11..1 has no effect on the bit representation and | (Or) with 0....0 has no effect so return below
  return ((positive_overflow_occured & INT_MAX) | (negative_overflow_occured & INT_MIN) | ((~positive_overflow_occured) & (~negative_overflow_occured) & sum));//we use the last part of the OR to make sure that if we do get overflow, the last term of the return statement be equal to 00...00
}

int main(){
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
