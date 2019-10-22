#define _CRT_SECURE_NO_WARNINGS  // for using scanf in VS

#include <stdio.h>

//#define USE_PREENTERED_DATA

#ifdef USE_PREENTERED_DATA
    #define ARRAY_SIZE = 3
    #define ARRAY_VALUES = {4., 5., 6.}
    #define C_VALUE = 1.
    #define D_VALUE = 1.
#else
    #define ARRAY_SIZE
    #define ARRAY_VALUES
    #define C_VALUE
    #define D_VALUE
#endif 

#define MAX_ARRAY_SIZE 256
#define CHECK_SIZE(x) < x && x <=

// if (c > d) x[i] = ( d / 2 - 53 / c)    / ( arctg(d - a[i]) * c + 1); // (c > d) 
// else       x[i] = (c * 4 + 28 * d / c) / (5 - arctg(a[i] * d));      // (c <= d) 
extern "C" void calcLab4(double * x, double * a, float c, float d, int n);

int main()
{
	int n ARRAY_SIZE;
	double a[MAX_ARRAY_SIZE] ARRAY_VALUES, x[MAX_ARRAY_SIZE];// ARRAY_VALUES;
	float c C_VALUE;
	float d D_VALUE;

#ifndef USE_PREENTERED_DATA
	printf("Enter values:\n");
	printf("n = ");
	scanf("%d", &n);
#endif

	if (0 CHECK_SIZE(n) 256){
#ifndef USE_PREENTERED_DATA
		for (unsigned int index = 0; index < n; ++index){
			printf("a[%d] = ", index);
			scanf("%lf", a + index);		
		}
		printf("c = ");
		scanf("%f", &c);
		printf("d = ");
		scanf("%f", &d);	
#endif

		calcLab4(x, a, c, d, n);
	}
	else{
		printf("Error size of arrays\r\n");
		return 0;
	}

	return 0;
}