//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             JPEG.cpp                                            */
//*   Contents:         JPEG Library functions                              */
//*                                                                         */
//*   Software design:  S.Landyshev                                         */
//*                                                                         */
//*   Version           1.1                                                 */
//*   Start date:       -09.09.2001                                         */
//*   $Revision: 1.1 $    $Date: 2005/02/10 12:36:37 $                           */
//*                                                                         */
//*                                                                         */
//***************************************************************************/
#include "nmjpegAUX.h"
#include "JpegDCT.h"
//#include <time.h>
#include <string.h>
#include "stdio.h" // for //printf debug purpose
#include "nmpli.h"

//#include "hash.h"

#include "insection.h"

#ifdef __cplusplus
		extern "C" {
#endif


    //--------------------------------------------------------------------
    // Константы.
static  int HEADER_SIZE = 140;

    //--------------------------------------------------------------------
    // Локальные переменные.
IN_DATA_SECTION(".data_jpeg")
static unsigned int pnDefaultQuantTable[64 * 5] = 
{
    0x0B, 0x08, 0x08, 0x0A, 0x08, 0x08, 0x0B, 0x0A,
	0x09, 0x0A, 0x0D, 0x0C, 0x0B, 0x0D, 0x11, 0x1C,
	0x12, 0x11, 0x0F, 0x0F, 0x11, 0x22, 0x19, 0x1A,
	0x14, 0x1C, 0x29, 0x24, 0x2B, 0x2A, 0x28, 0x24,
	0x27, 0x27, 0x2D, 0x32, 0x40, 0x37, 0x2D, 0x30,
	0x3D, 0x30, 0x27, 0x27, 0x38, 0x4C, 0x39, 0x3D,
	0x43, 0x45, 0x48, 0x49, 0x48, 0x2B, 0x36, 0x4F,
	0x55, 0x4E, 0x46, 0x54, 0x40, 0x47, 0x48, 0x45,

    0x29, 0x27, 0x27, 0x28, 0x27, 0x26, 0x29, 0x28, 
    0x27, 0x28, 0x2a, 0x2a, 0x29, 0x2a, 0x2d, 0x36, 
    0x2e, 0x2d, 0x2c, 0x2c, 0x2d, 0x3a, 0x33, 0x34, 
    0x30, 0x36, 0x3f, 0x3c, 0x41, 0x40, 0x3f, 0x3c, 
    0x3e, 0x3e, 0x42, 0x46, 0x51, 0x4a, 0x42, 0x45, 
    0x4e, 0x45, 0x3e, 0x3e, 0x4b, 0x5a, 0x4b, 0x4e, 
    0x53, 0x54, 0x57, 0x57, 0x57, 0x41, 0x49, 0x5c, 
    0x60, 0x5b, 0x55, 0x60, 0x51, 0x56, 0x57, 0x54,

    0x47, 0x46, 0x46, 0x46, 0x46, 0x45, 0x47, 0x46, 
    0x45, 0x46, 0x47, 0x48, 0x47, 0x47, 0x49, 0x50, 
    0x4a, 0x49, 0x49, 0x49, 0x49, 0x52, 0x4d, 0x4e, 
    0x4c, 0x50, 0x55, 0x54, 0x57, 0x56, 0x56, 0x54, 
    0x55, 0x55, 0x57, 0x5a, 0x62, 0x5d, 0x57, 0x5a, 
    0x5f, 0x5a, 0x55, 0x55, 0x5e, 0x68, 0x5d, 0x5f, 
    0x63, 0x63, 0x66, 0x65, 0x66, 0x57, 0x5c, 0x69, 
    0x6b, 0x68, 0x64, 0x6c, 0x62, 0x65, 0x66, 0x63, 

    0x65, 0x65, 0x65, 0x64, 0x65, 0x64, 0x65, 0x64, 
    0x63, 0x64, 0x64, 0x66, 0x65, 0x64, 0x65, 0x6a, 
    0x66, 0x65, 0x66, 0x66, 0x65, 0x6a, 0x67, 0x68, 
    0x68, 0x6a, 0x6b, 0x6c, 0x6d, 0x6c, 0x6d, 0x6c, 
    0x6c, 0x6c, 0x6c, 0x6e, 0x73, 0x70, 0x6c, 0x6f, 
    0x70, 0x6f, 0x6c, 0x6c, 0x71, 0x76, 0x6f, 0x70, 
    0x73, 0x72, 0x75, 0x73, 0x75, 0x6d, 0x6f, 0x76, 
    0x76, 0x75, 0x73, 0x78, 0x73, 0x74, 0x75, 0x72, 

//    0x83, 0x84, 0x84, 0x82, 0x84, 0x83, 0x83, 0x82, 
//    0x81, 0x82, 0x81, 0x84, 0x83, 0x81, 0x81, 0x84, 
//    0x82, 0x81, 0x83, 0x83, 0x81, 0x82, 0x81, 0x82, 
//    0x84, 0x84, 0x81, 0x84, 0x83, 0x82, 0x84, 0x84, 
//    0x83, 0x83, 0x81, 0x82, 0x84, 0x83, 0x81, 0x84, 
//    0x81, 0x84, 0x83, 0x83, 0x84, 0x84, 0x81, 0x81, 
//    0x83, 0x81, 0x84, 0x81, 0x84, 0x83, 0x82, 0x83, 
//    0x81, 0x82, 0x82, 0x84, 0x84, 0x83, 0x84, 0x81

    0x83, 0x83, 0x83, 0x82, 0x83, 0x83, 0x83, 0x82, 
    0x81, 0x82, 0x81, 0x83, 0x83, 0x81, 0x81, 0x83, 
    0x82, 0x81, 0x83, 0x83, 0x81, 0x82, 0x81, 0x82, 
    0x83, 0x83, 0x81, 0x83, 0x83, 0x82, 0x83, 0x83, 
    0x83, 0x83, 0x81, 0x82, 0x83, 0x83, 0x81, 0x83, 
    0x81, 0x83, 0x83, 0x83, 0x83, 0x83, 0x81, 0x81, 
    0x83, 0x81, 0x83, 0x81, 0x83, 0x83, 0x82, 0x83, 
    0x81, 0x82, 0x82, 0x83, 0x83, 0x83, 0x83, 0x81
};

IN_DATA_SECTION(".data_jpeg")
int pnZZTable[64] =
{
	 0,  1,  5,  6, 14, 15, 27, 28,
	 2,  4,  7, 13, 16, 26, 29, 42,  
	 3,  8, 12, 17, 25, 30, 41, 43,
	 9, 11, 18, 24, 31, 40, 44, 53,
	10, 19, 23, 32, 39, 45, 52, 54,
	20, 22, 33, 38, 46, 51, 55, 60,
	21, 34, 37, 47, 50, 56, 59, 61,
	35, 36, 48, 49, 57, 58, 62, 63
};

IN_DATA_SECTION(".data_jpeg")
static int pnAddIt[] = 
{
		0x00000000, 0x0000007f, 0x0000003f, 0x0000001f,
		0x0000000f, 0x00000007, 0x00000003, 0x00000001,
		0x00000000, 0x00007f00, 0x00003f00, 0x00001f00,
		0x00000f00, 0x00000700, 0x00000300, 0x00000100,
		0x00000000, 0x007f0000, 0x003f0000, 0x001f0000,
		0x000f0000, 0x00070000, 0x00030000, 0x00010000,
		0x00000000, 0x7f000000, 0x3f000000, 0x1f000000,
		0x0f000000, 0x07000000, 0x03000000, 0x01000000
};
IN_DATA_SECTION(".data_jpeg")
static unsigned pnHeader[140] = 
{
    0xe0ffd8ff, 0x464a1000, 0x01004649, 0x01000001, 
    0x00000100, 0x4300dbff, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000, 
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00c0ff00, 0x00000811,
    0x01030000, 0x11020022, 0x00110300, 0x1f00c4ff,
    0x05010000, 0x01010101, 0x00000101, 0x00000000,
    0x02010000, 0x06050403, 0x0a090807, 0x00c4ff0b,
    0x020010b5, 0x02030301, 0x05050304, 0x00000404,
    0x02017d01, 0x11040003, 0x31211205, 0x51130641,
    0x71220761, 0x91813214, 0x422308a1, 0x5215c1b1,
    0x3324f0d1, 0x09827262, 0x1817160a, 0x26251a19,
    0x2a292827, 0x37363534, 0x433a3938, 0x47464544,
    0x534a4948, 0x57565554, 0x635a5958, 0x67666564,
    0x736a6968, 0x77767574, 0x837a7978, 0x87868584,
    0x928a8988, 0x96959493, 0x9a999897, 0xa5a4a3a2,
    0xa9a8a7a6, 0xb4b3b2aa, 0xb8b7b6b5, 0xc3c2bab9,
    0xc7c6c5c4, 0xd2cac9c8, 0xd6d5d4d3, 0xdad9d8d7,
    0xe4e3e2e1, 0xe8e7e6e5, 0xf2f1eae9, 0xf6f5f4f3,
    0xfaf9f8f7, 0x1f00c4ff, 0x01030001, 0x01010101,
    0x01010101, 0x00000000, 0x02010000, 0x06050403,
    0x0a090807, 0x00c4ff0b, 0x020011b5, 0x04040201,
    0x05070403, 0x01000404, 0x01007702, 0x04110302,
    0x06312105, 0x07514112, 0x22137161, 0x14088132,
    0xb1a19142, 0x332309c1, 0x6215f052, 0x160ad172,
    0x25e13424, 0x191817f1, 0x2827261a, 0x36352a29,
    0x3a393837, 0x46454443, 0x4a494847, 0x56555453,
    0x5a595857, 0x66656463, 0x6a696867, 0x76757473,
    0x7a797877, 0x85848382, 0x89888786, 0x9493928a,
    0x98979695, 0xa3a29a99, 0xa7a6a5a4, 0xb2aaa9a8,
    0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2, 0xc9c8c7c6,
    0xd4d3d2ca, 0xd8d7d6d5, 0xe3e2dad9, 0xe7e6e5e4,
    0xf2eae9e8, 0xf6f5f4f3, 0xfaf9f8f7, 0x0400feff,
    0xdaff0000, 0x01030c00, 0x03110200, 0x003f0011
};
IN_DATA_SECTION(".data_jpeg")   static int nInit = 0;
IN_DATA_SECTION(".data_jpeg")	static int pnQPair[2];
IN_DATA_SECTION(".data_jpeg")	int *pnDCTable;
IN_DATA_SECTION(".data_jpeg")  	int *pnACTable;

    //--------------------------------------------------------------------
    // Выравнивание битового потока по границе байта.
//__attribute__((section(".text_jpeg")))
 IN_CODE_SECTION(".code_jpeg") int AlignBitstream(
    char *pcSrc,        // Битовый поток.
    int nBits           // Размер битового потока в битах.
    )
{
	int *pnSrc = (int*)pcSrc;

	if(nBits & 0x7)
	{
		pnSrc[nBits >> 5] |= pnAddIt[nBits & 0x1f];
		return  ((nBits >> 3) + 1);
	}
	else
    {
        return (nBits >> 3);
    }
}

    //--------------------------------------------------------------------
    // Вставка маркера конца файла.
IN_CODE_SECTION(".code_jpeg") static int InsertEOF(
    nm8u *pcSrc,        // Битовый поток.
    int nBytes          // Размер битового потока в байтах.
    )
{
    int *pnSrc = (int*)pcSrc;
    pnSrc += nBytes >> 2;

    switch((nBytes) & 0x3)
    {
    case 0:
		*pnSrc = (*pnSrc & 0xFFFF0000) | 0x0000D9FF;
        break;
    case 1:
		*pnSrc = (*pnSrc & 0xFF0000FF) | 0x00D9FF00;
        break;
    case 2:
		*pnSrc = (*pnSrc & 0x0000FFFF) | 0xD9FF0000;
        break;
    case 3:
		pnSrc[0] |= 0xFF000000;
		pnSrc[1] = 0x000000D9;
        break;
    }
	return (nBytes + 2);
}

    //--------------------------------------------------------------------
    // Заполнение заголовка JPEG.
IN_CODE_SECTION(".code_jpeg") static void FillHeader(
    int *pnHdr,         // Формируемый заголовок (140 слов или 560 байтов)
    unsigned int *pnQuantTable,  // Таблица квантования (64 элемента).
    int nWidth,         // Ширина изображения.
	int nHeight         // Высота изображения.
	)
{
	int i, j;
	
    memcpy(pnHdr, pnHeader, HEADER_SIZE * sizeof(int));

	pnHdr[6] |= (pnQuantTable[0] << 8) + (pnQuantTable[1] << 16) + 
            (pnQuantTable[2] << 24);
	j = 3;
	for(i=7, j=3; i<22; i++, j+=4)
    {
        pnHdr[i] = pnQuantTable[j] + (pnQuantTable[j+1] << 8) +
                (pnQuantTable[j+2] << 16) + (pnQuantTable[j+3] << 24);
    }

	pnHdr[22] |= pnQuantTable[63];
	i = (nHeight >> 8);
	i += (nHeight & 0xff) << 8;
	i <<= 16;
	pnHdr[23] |= i;
	i = (nWidth >> 8);
	i += (nWidth & 0xff) << 8;
	pnHdr[24] |= i;
}

    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") void nmjpegInit(int *pnCWBuffer)
{
    pnDCTable = pnCWBuffer;
    pnACTable = pnCWBuffer + 512;
    nmjpegAUX_GenDCEncTab(pnDCTable);
    nmjpegAUX_GenACEncTab(pnACTable);
}

    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") int nmjpegGetHeaderCustom(char *pcHeader, unsigned int *pnQuantTable, int nWidth, int nHeight)
{
    FillHeader((int*)pcHeader, pnQuantTable, nWidth, nHeight);
    return (HEADER_SIZE << 2);
}

    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") int nmjpegGetHeader(char *pcHeader, int nQuality, int nWidth, int nHeight)
{
    return nmjpegGetHeaderCustom(pcHeader, &pnDefaultQuantTable[nQuality * 64], nWidth, nHeight);
}

    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") int nmjpegGetBitstreamCustom(nm8u* pcSrc, nm8u* pcDst, int nWidth, int nHeight, int nDstOffset, unsigned int *pnQuantTable, void *pTmp0, void *pTmp1)
{
    int nResBytes;
    nResBytes = CreateBitstream(pcSrc, pcDst, nWidth, nHeight, nDstOffset, pnQuantTable, pTmp0, pTmp1);
    return InsertEOF(pcDst, nResBytes);
}

    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") int nmjpegGetBitstream(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight,  int nDstOffset, int nQuality, void *pTmp0, void *pTmp1)
{
    return nmjpegGetBitstreamCustom(pcSrc, pcDst, nWidth, nHeight, nDstOffset, &pnDefaultQuantTable[nQuality * 64], pTmp0, pTmp1);
}


IN_CODE_SECTION(".code_jpeg") int nmjpegCompressCustom(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight, unsigned int *pnQuantTable, void *pTmp0, void *pTmp1)
{
    int nResBytes;

	
    nResBytes = CreateBitstream(pcSrc, pcDst, nWidth, nHeight, HEADER_SIZE,  pnQuantTable, pTmp0, pTmp1);

	FillHeader((int*)pcDst, pnQuantTable, nWidth, nHeight); // about 12000
	
	
    nResBytes += (HEADER_SIZE << 2);
	return InsertEOF(pcDst, nResBytes);
}


IN_CODE_SECTION(".code_jpeg") int nmjpegCompress(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight, int nQuality, void *pTmp0, void *pTmp1)
{
	return nmjpegCompressCustom(pcSrc, pcDst, nWidth, nHeight, &pnDefaultQuantTable[nQuality * 64], pTmp0, pTmp1);
}

//#include "stdio.h"
IN_CODE_SECTION(".code_jpeg") int CreateBitstream(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight, int nDstReserve, unsigned int *pnQuantTable, void *pTmp0, void *pTmp1)
{
	
	nm64u XorMask = 0x8080808080808080l;
	int nSize = nWidth * nHeight;
	int nBlocks = nSize >> 6;
	int nResBytes;
	//nm32u crc=1;

	nmppiSplitInto2x2Blocks8x8xor(	(nm8u*) pcSrc,	(nm8u*)pTmp1,(nm8u*)&XorMask,	nWidth,	nHeight);
	
	nmjpegFwdDct8x8Sec((nm8s*)pTmp1, (nm32s*)pTmp0, nBlocks, pcDst);
	
	
	for(int i=0; i<64; i+=2)
	{
		pnQPair[0] = (int)pnQuantTable[pnZZTable[i]];
		pnQPair[1] = (int)pnQuantTable[pnZZTable[i+1]];
		nmjpegQuant_By2Int((int*)pTmp0 + i,	(int*)pcDst + i, pnQPair,   nBlocks * 2, 0,	64, 64, 20, 0);
	}
	// Count DIFF from DC.
	// 0.12 ticks rep image point.
	
	nmjpegAUX_CountDIFF((int*)pcDst, (__int64*)pTmp1, nSize);

	// Zig-zag transformation in blocks.
	// 1.331 ticks per image point.
	nmjpegFwdZigZag8x8((int*)pcDst, (int*)pTmp0,	nBlocks, 18, 1);
	
	// Insert DIFF into work buffer.
	// 0.039 ticks per image point.
	nmjpegAUX_InsertDIFF((__int64*)pTmp1, (int*)pTmp0, nBlocks);
	
	

	// Perform JPEGRLE coding and getting variable length codes (VLC) 
	// from Haffman tables (function used standard table).
	// 5.82 ticks per image point. 
	// Speed of function is depended from quantizers and picture structure strongly.
	nResBytes = nmjpegAUX_RLE((int*)pTmp0, (int*)pcDst, nSize, pnDCTable, pnACTable, pTmp1);
	
	// Compress codes.
	// COD_PressVLC(L, L, G): 4.63 ticks per image point.
	// Speed of function is depended from quantizers and picture structure strongly.
	nResBytes = VLC_Compress((unsigned int*)pcDst, (nm64u*)pTmp0, nResBytes, 0);
	// Align last byte of bitstream 
	nResBytes = AlignBitstream((char*)pTmp0, nResBytes);
	
	// Convert bytes in 32-bit words.
	int n;
	if(nResBytes & 0xff){
		n = 256;
	}
	else{
		n = 0;
	}
	
	// Check FF-byte functions. For all functions: 0.87 ticks per image point.
	// Speed of functions is depended from quantizers and picture structure strongly.  
	// VEC_Cnv8to32: 0.55 ticks per element.
	nmppsConvert_8u32u((nm8u*)pTmp0, (nm32u*)pcDst, nResBytes + n);

	// Insert 0 word after 0x000000ff words. (6 ticks per element).
	nmjpegAUX_GetFFVectors((int*)pcDst, (unsigned int*)pTmp1, nResBytes, pTmp0);

	
	nResBytes = nmjpegAUX_CheckMarkerByte((int*)pcDst, (int*)pTmp0, nResBytes, (unsigned int*)pTmp1);

	
	// Convert 32-bit word to bytes. If generate JPEG-file, then reserved place for JPEG-header.
	if(nResBytes & 0xff){
		n = 256;
	}
	else {
		n = 0;
	}
	

	nmppsConvert_32s8s((nm32s*)pTmp0, (nm8s*)((int*)pcDst + nDstReserve),	nResBytes + n);
	
	return nResBytes;  
}

#ifdef __cplusplus
		};
#endif
