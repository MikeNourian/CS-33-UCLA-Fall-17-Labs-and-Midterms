#include <stdio.h>
#include <limits.h>

bool int_shifts_are_arithmetic(){
int i = INT_MIN >> 1;
return i<0;
}

int main (void){
bool value_returned = int_shifts_are_arithmetic();
return 0;
}
