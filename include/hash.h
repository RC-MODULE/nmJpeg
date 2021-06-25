#include "nmpp.h"
#define HASH8(info,data,size) { unsigned crc=	nmppsCrc_8u((nm8u*)(data), size); printf("%s at [%08x] = %x\n", (info), (data), crc);}
#define HASH32(info,data,size32) { unsigned crc=	nmppsCrc_32u((nm32u*)(data), size32); printf("%s at [%08x] = %x\n", (info), (data), crc);}


#define PRINT_MATRIX32(mx,dimy,dimx, spec) { int * m=(int*)mx; for(int y=0; y<dimy; y++) {	for(int x=0;x<dimx; x++) printf(spec,*(m++)); printf("\n");}}
