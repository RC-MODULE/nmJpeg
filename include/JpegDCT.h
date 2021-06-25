#ifndef __INTERNAL_H_INCLUDED
#define __INTERNAL_H_INCLUDED

#include "nmplv.h"
#include "nmtype.h"
#include "vlc.h"

#ifdef __cplusplus
		extern "C" {
#endif

//*****************************************************************************

	/** 
    * \if Russian
    *     \defgroup JpgDct DCT
    * \endif
    * \if English
    *     \defgroup JpgDct DCT
    * \endif
    * \ingroup iJPEG
    */

//*****************************************************************************

//*****************************************************************************

	/**
	\defgroup nmjpegFwdDct8x8 nmjpegFwdDct8x8
	\ingroup JpgDct
	\brief
		\ru ���������-���������� �������������� �����������.
		\en Discrete cosine transform of image.

	\ru ��������� ���������� ���������� �������������� (���) ����������� ��� ������� ����� �������� 8�8.
	  ������� �������� � ������������, ����������� 4 �������� ����� �������� 8�8, ������ �� �������
		������� �� ��������� ���� char.
		�� ���� �������� ����������� � ���� ���������� ������� �������� nWidth*nHeight, �����������
		8-������� �������� �������� [-128..+127].
		�������� ������ �������������� � ������� ���������� ����������� 16�16. ���������� ������� �� ��������
		����������� � ������� ����� ������� � ������ ����, ������� � �������� ������ ����.
		� ������ ���������� 4 ����� �������� 8�8 ������������� ���������� 
		���������� ��������������� � ����������� ���� �� ����� � ���� ����������� ���������� ��������.
		� ������� ���������� 3.42 ����� �� ������� ��� ������������� ���������� NM6403.
	\en	2D - Forward Discrete Cosine Transform(DCT) computation under each 8x8 block of the  frame.
		The function operates with macroblocks consisted from 
		four neighbouring blocks of 8x8 SIGNED CHAR elements.
		On input it takes Frame considered as a 2D array Width*Height of 8-bit SIGNED elements [-128..+127].
		Output data is stored as a sequence of macroblocks 16�16. Macroblocks are taken from input Image 
		in left-to-right and top-down scan order. In each macroblock four blocks are transformed by DCT
		and separatly stored one after another with the same inner scan order.
		In average it takes 3.42 clocks per pixel using the NM6403 processor

	\~
	\param pSrcImg   
		\ru ������� �����������. 
		\en Input Frame
	\param pDstImg   
		\ru ��� ������������ �����������.
		\en Result DCT
	\param nWidth   
		\ru ������ ����������� � ��������. nWidth=[16,32,48...]
		\en Frame width in pixels. nWidth=[16,32,48...]
	\param nHeight   
		\ru ������ ����������� � ��������. nHeight=[16,32,48...]
		\en Frame height. nHeight=[16,32,48...]
	\param pTmpBuf   
		\ru ��������� ����� �������	nm64u[nWidth*nHeight/2]
		\en Temporary buffer  of size nm64u[nWidth*nHeight/2]
  \return \e void

    \par
    \xmlonly
        <testperf> 
             <param> pSrcImg </param> <values> L G </values>
             <param> pDstImg </param> <values> L G </values>
             <param> pTmpBuf </param> <values> L G </values>
             <param> nHeight </param> <values> 64 </values>
             <param> nWidth </param> <values> 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
        <testperf> 
             <param> pSrcImg </param> <values> G </values>
             <param> pDstImg </param> <values> L </values>
             <param> pTmpBuf </param> <values> G </values>
             <param> nHeight </param> <values> 16 32 64 </values>
             <param> nWidth </param> <values> 16 32 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
    \endxmlonly
	*/
	//! \{
void nmjpegFwdDct8x8( nm8s* pSrcImg, nm32s* pDstImg, int nWidth, int nHeight, void* pTmpBuf);
	//! \note 
	//!	\ru ������� c ������������ ���������� (������������ ������������� ���� �� 20 ��� ������ ).
	//!	\en Scale down by 20 bit right shift will be performed
//void nmjpegFwdDct8x8(nm8s* pSrcImg, nm32s* pDstImg, int nWidth, int nHeight, void* pTmpBuf);
	//! \note 
	//!	\ru ������� ��� ������������ ���������� (������������� ���� ������ �� ������������).
	//!	\en No scale down by right shift will be performed
	//! \}
void nmjpegFwdDct8x8Sec( nm8s*  pSrcBlocks8x8, nm32s* pDctBlocks8x8, int nBlocks, void* pTmpBuf);
void nmjpegInvDct8x8Sec( nm16s* pDctBlocks8x8, nm32s* pDstBlocks8x8, int nBlocks, void* pTmpBuf);
//*****************************************************************************
/**
	\defgroup nmjpegInvDct8x8 nmjpegInvDct8x8
	\ingroup JpgDct
	\brief
		\ru �������� ���������-���������� �������������� �����������.
		\en Inverse discrete cosine transform of image.

	\ru 
	  ��������� �������� ���������� ���������� �������������� (����) ����������� ��� ������� �����
	  �������� 8�8 � ������� ���. � ������� ���������� 4.13 ������ �� ������ ��� ������������� 
	  ���������� NM6403.
	\en	2D - Inverse Discrete Cosine Transform(iDCT) computation under each 8x8 block produced by DCT.
		In average it takes 4.13 clocks per pixel using the NM6403 processor

	\~
	\param pSrcImg   
		\ru ��� ������������ �����������.
		\en DCT coefficients
	\param pDstImg   
		\ru �������������� �����������. 
		\en Reconstructed frame
	\param nWidth   
		\ru ������ ����������� � ��������. nWidth=[16,32,48...]
		\en Frame width in pixels. nWidth=[16,32,48...]
	\param nHeight   
		\ru ������ ����������� � ��������. nHeight=[16,32,48...]
		\en Frame height. nHeight=[16,32,48...]
	\param pTmpBuf   
		\ru ��������� ����� �������	nm64u[nWidth*nHeight/2]
		\en Temporary buffer  of size nm64u[nWidth*nHeight/2]
	\return \e void


    \par
    \xmlonly
        <testperf> 
             <param> pSrcImg </param> <values> L G </values>
             <param> pDstImg </param> <values> L G </values>
             <param> pTmpBuf </param> <values> L G </values>
             <param> nHeight </param> <values> 64 </values>
             <param> nWidth </param> <values> 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
        <testperf> 
             <param> pSrcImg </param> <values> G </values>
             <param> pDstImg </param> <values> L </values>
             <param> pTmpBuf </param> <values> G </values>
             <param> nHeight </param> <values> 16 32 64 </values>
             <param> nWidth </param> <values> 16 32 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
    \endxmlonly


	*/
	//! \{

 void nmjpegInvDct8x8( nm16s* pSrcImg, nm32s*		pDstImg, int	nWidth,	int	 nHeight, void* pTmpBuf	);
	//! \}

//*****************************************************************************

/**
*	\if Russian
*		\defgroup iZigzagReodering ���-��� ������������������
*	\endif
*	\if English
*		\defgroup iZigzagReodering Zig-zag reodering
*	\endif
*	\ingroup iReodering
*	\brief 
*		\ru ���-��� ����������������� ������������������ ������.
*		\en Zig zag reodering of block sequence.
*	 
*/

//*****************************************************************************

	/**
	\defgroup nmjpegFwdZigZag8x8 nmjpegFwdZigZag8x8
	\ingroup iZigzagReodering
	\brief
		\ru ������������������ �������� ������������������ ������ ������� ���-���.
		\en

	\~
	\param pSrcBlockSeq
	  \ru ������� ������ � ���������� �������
		\en Input array in normal order
	\param pDstBlockSeq
	  \ru �������� ������ � ���-������� �������
		\en Output Array in Z-order
	\param nBlocks
	  \ru ����� ������ �������� 8�8 :nBlocks=[4,8,12....]
		\en Number of 8x8 Blocks :nBlocks=[4,8,12....]
	\param nPreShift
	  \ru ���������� ���, �� ������� ������������ ��������������� ����� ������ : =[0,2,4...30]
		\en Preceding scale down by right shift by nPreShift bits : =[0,2,4...30]
	\param fUseCharClip
	  \ru ���� �� 0, ���������� ���������� �� ��������� [-2^fUseCharClip...+2^fUseCharClip-1]
		\en if !=0 Clipping of results in range [-2^fUseCharClip...+2^fUseCharClip-1]
  \return \e void

	\note
	  \ru nBlocks ��������� �������� 4,8,12....; nPreShift ��������� �������� [0,2,4...30];
        fUseCharClip ��������� �������� [1,2,3,..31]
		\en nBlocks=[4,8,12....]; nPreShift=[0,2,4...30]; fUseCharClip=[1,2,3,..31]

    \par
    \xmlonly
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L G </values>
             <param> pDstBlockSeq </param> <values> L G </values>
             <param> nBlocks </param> <values> 1024 </values>
             <param> nPreShift </param> <values> 0 </values>
             <param> fUseCharClip </param> <values> 0 </values>
             <size> nBlocks </size>
        </testperf>
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L </values>
             <param> pDstBlockSeq </param> <values> G </values>
             <param> nBlocks </param> <values> 8 128 1024 </values>
             <param> nPreShift </param> <values> 0 </values>
             <param> fUseCharClip </param> <values> 0 </values>
             <size> nBlocks </size>
        </testperf>
    \endxmlonly


	*/
	//! \{
void nmjpegFwdZigZag8x8(int* pSrcBlockSeq, int* pDstBlockSeq,	int	nBlocks, int	nPreShift=0, int	fUseCharClip=0 );
	//! \}

//*****************************************************************************

	/**
	\defgroup nmjpegInvZigZag8x8 nmjpegInvZigZag8x8
	\ingroup iZigzagReodering
	\brief
		\ru �������� ������������������ �������� ������������������ ������ ������� ���-���.

	\~
	\param pSrcBlockSeq
	  \ru ������� ������ � ���-������� �������
		\en Array in Z-order
	\param pDstBlockSeq
	  \ru �������������� ������ � ���������� �������
		\en Result array in normal order
	\param nBlocks
	  \ru ����� ������ �������� 8�8
		\en Number of 8x8 Blocks
  \return \e void
	\restr 
	  \ru nBlocks ����� ��������� �������� 1, 2, 3,...
		\en nBlocks=[1,2,3..]

    \par
    \xmlonly
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L G </values>
             <param> pDstBlockSeq </param> <values> L G </values>
             <param> nBlocks </param> <values> 32 </values>
             <size> nBlocks*64 </size>
        </testperf>
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L </values>
             <param> pDstBlockSeq </param> <values> G </values>
             <param> nBlocks </param> <values> 8 32 64 </values>
             <size> nBlocks*64 </size>
        </testperf>
    \endxmlonly

	*/
	//! \{
 void nmjpegInvZigZag8x8(int*	pSrcBlockSeq, int*	pDstBlockSeq, int nBlock);
	//! \}

//*****************************************************************************

#ifdef __cplusplus
};
#endif

#endif
