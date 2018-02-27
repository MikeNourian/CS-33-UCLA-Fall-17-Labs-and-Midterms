//Name: Milad Nourian
//UID: 004854226
#include <stdio.h>
long cread_alt (long *xp){
  long temp = 0;
  if (!xp) 
    xp = &temp;
  return *xp;

}

int main(void){
  long * nullPtr = NULL;
  long value = cread_alt(nullPtr);
  return 0;
}
