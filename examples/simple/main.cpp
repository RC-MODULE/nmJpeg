
#include "time.h"
#include "nmjpeg.h"
#include "malloc.h"
#include "nmpp.h"
#include <stdio.h>
#include <string.h>
#include <nmjpegAUX.h>
#include "insection.h"

 
IN_DATA_SECTION(".jpegout")   long long jpegOut[4096];

#ifdef __NM__
#ifdef __GNUC__ //  NMC-GCC C++ compilier 
inline void* malloc0(unsigned size32) {nmc_malloc_set_heap(0); return malloc(size32); }
inline void* malloc1(unsigned size32) {nmc_malloc_set_heap(1); return malloc(size32); }
inline void* malloc2(unsigned size32) {nmc_malloc_set_heap(2); return malloc(size32); }
inline void* malloc3(unsigned size32) {nmc_malloc_set_heap(3); return malloc(size32); }
#endif
#else 			// x86/x64  compiler
#define malloc0 malloc32
#define malloc1 malloc32
#define malloc2 malloc32
#define malloc3 malloc32

#endif

#include "hash.h"
int main()
{  

	printf("NMC started!\n");


	//------------------------- инициализаци¤ --------------------------------

	int Width  = 256/2;
	int Height = 256/2;
	int Size=Width*Height;

	if (Width % 16 || Height % 16) {
		return -2; // Ўирина высота должна быть кратна 16
	}


	clock_t t0,t1;
	
	nm32u* pSrc=(nm32u*)malloc0(Size/4);	
	nm32u* pDst=(nm32u*)malloc1(Size);
	
	void* pTmp0 = malloc2(Size);
	void* pTmp1 = malloc3(Size);
	int*  pnCWBuffer = (int*)malloc32(4608);
	
	printf("pSrc=%x\n", pSrc);
	printf("pDst=%x\n", pDst);
	printf("pTmp0=%x\n", pTmp0);
	printf("pTmp1=%x\n", pTmp1);

	if (pSrc == 0 || pTmp0 == 0 || pTmp1 == 0 || pnCWBuffer == 0)
		return -1;

	// Градиентная заливка исходного кадра
	nm8u* p = (nm8u*)pSrc;
	for (int y = 0; y<Height; y++) {
		for (int x = 0; x<Width ; x++) {
			nmppsPut_8u(p, y*Width + x, y + x);
		}
	}

	nmjpegInit(pnCWBuffer);		
	//t0=clock();	
	

	int nBytes = nmjpegCompress((nm8u*)pSrc, (nm8u*)pDst, Width, Height,0, pTmp0,pTmp1);
	
	//t1=clock();
	// 8.9 ticks/pixel  без nmjpegFill 

	#ifndef __NM__
	FILE *f = fopen("out.jpg", "wb");
	fwrite(pDst, 1, nBytes, f);
	fclose(f);
	#endif
	
	
	//nmppsCopy_8u((nm8u*)pDst,(nm8u*)jpeg,nBytes);
	memcpy(jpegOut,pDst,nBytes*sizeof(int)/4);
	
	HASH8("hash:",jpegOut,nBytes);
	printf("[%x] Size= %d\n\n",  jpegOut,nBytes);
    return t1-t0;
  
 
	


} 


/*
#include <time.h>
int main(){
	int t=clock();
	return t;
};
*/