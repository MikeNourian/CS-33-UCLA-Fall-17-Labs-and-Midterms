#include <math.h>
#include <stdio.h>

union conversion
{
	unsigned u;
	float f;
};

static float u2f(unsigned u) 
{
	union conversion conv;
	conv.u = u;
	return conv.f;
}

// 8^x = (2^3)^x = 2^(3x)
float fpwr8(int x) 
{
	unsigned exp;
	unsigned frac;
	unsigned u;
	
	if( x < -49) //too small return 0.0
	{
		exp = 0;
		frac = 0;
		
	}
	else if ( x < -42) //denormalized result
	{
		exp = 0;
		frac = 1 << (3*x + 149);

	}
	else if ( x < 43) //normalized result
	{
		exp = 3*x +127;
		frac = 0;
	}
	else //too big return +inf
	{
		exp = 255;
		frac = 0;
	}
	
	u = exp << 23 | frac;
	return u2f(u);
		
}

void main() {

	printf("less than -49: %f \n", fpwr8(-50));
	
	printf("-44: %e \n", fpwr8(-44));
	printf("less than -45: %e \n", fpwr8(-45));
	printf("less than -46: %e \n", fpwr8(-46));
	printf("less than -47: %e \n", fpwr8(-47));
	printf("less than -48: %e \n", fpwr8(-48));
	printf("less than -43: %e \n", fpwr8(-43));
	
	printf("less than 43: %f \n", fpwr8(20));
		
	printf("should output 1: %f \n", fpwr8(0));
	
	printf("should output 1/8: %f \n", fpwr8(-1));
	
	printf("should output 8: %f \n", fpwr8(1));
	
	printf("exp too big should output inf: %f \n", fpwr8(45));

	
}
