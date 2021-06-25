    //--------------------------------------------------------------------
#ifndef _nmjpegAUX_H_
#define _nmjpegAUX_H_

#include "nmtype.h"
    //--------------------------------------------------------------------
    // ������� � ������� ������ DC.
#ifdef __cplusplus
		extern "C" {
#endif
void nmjpegAUX_CountDIFF(int *pnSrc, __int64 *pnDst, int nSize);
void nmjpegAUX_CountDIFF2(int *pnSrc, __int64 *pnDst, int nSize);
void nmjpegAUX_InsertDIFF(__int64 *pnSrc, int *pnDst, int nSize);
void nmjpegAUX_InsertDIFF2(__int64 *pnSrc, int *pnDst, int nSize);


    //--------------------------------------------------------------------
    // �����������.
	
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
    // RLE �����������.
    // ���������� ���������� ���������� ������� ����.
int nmjpegAUX_RLE(
	int *pnSrc,		// �������� ������.
	int *pnDst,	    // �������� ������ (������� �����).
	int	nSize,		// ������ ������� ������.
    int *pnDCTable, // ������� ��� ����������� DC.
    int *pnACTable, // ������� ��� ����������� AC.
	void *pvTmp	    // ��������� �����.
	);


int nmjpegAUX_RLE2(
				int *pnSrc,		// �������� ������.
				int *pnDst,	    // �������� ������ (������� �����).
				int	nSize,		// ������ ������� ������.
				int *pnDCTable, // ������� ��� ����������� DC.
				int *pnACTable, // ������� ��� ����������� AC.
				void *pvTmp	    // ��������� �����.
				);

    //--------------------------------------------------------------------
    // ��������� ������� ��������, ������������ ������� ������ 0xFF.


void nmjpegAUX_GetFFVectors(
	int *pnSrc,		// ������� �����. ������ ���� ������ ���������� � 32-� ������� �����.
	unsigned int *pnBitVector,	// ������� ������.
	int nSize,		// ������ �������� ������ � 32-� ���. ������.
	void *pvTmp     // ��������� �����.
	);		
    
    // ������������ ������ 0xFF. 
    // ���������� ������ ��������� �������� ������ � 32-� ���. ������.
int nmjpegAUX_CheckMarkerByte(
    int *pnSrc,        // ������� ������� �����. ������ ���� ������ ���������� � 32-� ������� �����.
	int *pnDst,	    // �������� ������� �����.
	int nSize,		    // ������ �������� �������� ������ � ������.
	unsigned int *pnBitVector   // ������� �������, ������������ ������� ������ 0xFF.
	);
    

    //--------------------------------------------------------------------

int AlignBitstream(
	  char *pcSrc,        // ������� �����.
	  int nBits           // ������ �������� ������ � �����.
		  );

int CreateBitstream(nm8u *pSrc, nm8u *pDst, int nWidth, int nHeight, int nDstReserve, unsigned int *pnQuantTable, void *pTmp0, void *pTmp1);

    //--------------------------------------------------------------------
    // ������������� ������ ��� ������ �� ��������.
void nmjpegAUX_GenDCEncTab(int *pnDCTable);  // ������ ������� = 512.
void nmjpegAUX_GenACEncTab(int *pnACTable);  // ������ ������� = 4096.
#ifdef __cplusplus
};	
#endif

#endif  // _nmjpegAUX_H_