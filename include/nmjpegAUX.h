    //--------------------------------------------------------------------
#ifndef _nmjpegAUX_H_
#define _nmjpegAUX_H_

#include "nmtype.h"
    //--------------------------------------------------------------------
    // Подсчёт и вставка разниц DC.
#ifdef __cplusplus
		extern "C" {
#endif
void nmjpegAUX_CountDIFF(int *pnSrc, __int64 *pnDst, int nSize);
void nmjpegAUX_CountDIFF2(int *pnSrc, __int64 *pnDst, int nSize);
void nmjpegAUX_InsertDIFF(__int64 *pnSrc, int *pnDst, int nSize);
void nmjpegAUX_InsertDIFF2(__int64 *pnSrc, int *pnDst, int nSize);


    //--------------------------------------------------------------------
    // Квантование.
	
void nmjpegQuant_By2Int(
    int*	SrcBuffer,			// Input array 					:long Global[NumbersOfPairs*SrcPairReadStep/2]
    int*	DstBuffer,			// Output qunatized array		:long Global[NumbersOfPairs*DstPairWriteStep/2]
    int*	Quantizers,			// Array of two quantizers		:long Local [2/2]; PairOfQuantizers[0,1]=[1,2,3...128]
    int		Count,				// Number of 32-bit elements to be quantized	:=[0,1,2,3...]
    void*	TmpBuffer,			// First  Temporary array		:long Local [NumbersOfPairs]
	int		SrcReadStep=2,		// long to long reading step (in 32-bit words)	:=[-2,0,2,4,6...]
    int		DstWriteStep=2,		// long to long writing step (in 32-bit words)	:=[-2,0,2,4,6...] 
    int		PreShift=0,			// Right preshifting by even number of bits		:=[0,2,4...30]
    int		UsePostShift=1		// if =0 - Skip result scaling down by 2^19 
   );	

    //--------------------------------------------------------------------
    // RLE кодирование.
    // Возвращает количество полученных кодовых слов.
int nmjpegAUX_RLE(
	int *pnSrc,		// Исходные данные.
	int *pnDst,	    // Выходные данные (кодовые слова).
	int	nSize,		// Размер входных данных.
    int *pnDCTable, // Таблица для кодирования DC.
    int *pnACTable, // Таблица для кодирования AC.
	void *pvTmp	    // Временный буфер.
	);


int nmjpegAUX_RLE2(
				int *pnSrc,		// Исходные данные.
				int *pnDst,	    // Выходные данные (кодовые слова).
				int	nSize,		// Размер входных данных.
				int *pnDCTable, // Таблица для кодирования DC.
				int *pnACTable, // Таблица для кодирования AC.
				void *pvTmp	    // Временный буфер.
				);

    //--------------------------------------------------------------------
    // Получение битовых векторов, показавающих позиции байтов 0xFF.


void nmjpegAUX_GetFFVectors(
	int *pnSrc,		// Битовый поток. Каждый байт потока распакован в 32-х битовое слово.
	unsigned int *pnBitVector,	// Битовый вектор.
	int nSize,		// Размер входного буфера в 32-х бит. словах.
	void *pvTmp     // Временный буфер.
	);		
    
    // Маскирование байтов 0xFF. 
    // Возвращает размер выходного битового потока в 32-х бит. словах.
int nmjpegAUX_CheckMarkerByte(
    int *pnSrc,        // Входной битовый поток. Каждый байт потока распакован в 32-х битовое слово.
	int *pnDst,	    // Выходной битовый поток.
	int nSize,		    // Размер входного битового потока в байтах.
	unsigned int *pnBitVector   // Битовые векторы, показавающие позиции байтов 0xFF.
	);
    

    //--------------------------------------------------------------------

int AlignBitstream(
	  char *pcSrc,        // Битовый поток.
	  int nBits           // Размер битового потока в битах.
		  );

int CreateBitstream(nm8u *pSrc, nm8u *pDst, int nWidth, int nHeight, int nDstReserve, unsigned int *pnQuantTable, void *pTmp0, void *pTmp1);

    //--------------------------------------------------------------------
    // Генерирование таблиц для сжатия по Хаффману.
void nmjpegAUX_GenDCEncTab(int *pnDCTable);  // Размер таблицы = 512.
void nmjpegAUX_GenACEncTab(int *pnACTable);  // Размер таблицы = 4096.
#ifdef __cplusplus
};	
#endif

#endif  // _nmjpegAUX_H_