//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*  Discrete Cosine Transform Library                                      */
//*  (C-callable functions)                                                 */
//*                                                                         */
//*  $Workfile:: Dct.cpp                                                   $*/
//*  Contents:   Fixed-Point DCT routines (PC Library)                      */
//*                                                                         */
//*  Author:     S.Mushkaev                                                 */
//*                                                                         */
//*  Version         2.0                                                    */
//*  Start    Date:  23.11.2000                                             */
//*  Release $Date: 2005/02/10 12:36:38 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/
#include "nmplv.h"
#include "nmtl.h"

#ifdef __cplusplus
		extern "C" {
#endif


extern double	ptblDCT_left[];	
extern double	ptblDCT_right[];	
extern double	ptblIDCT_left[];	
extern double	ptblIDCT_right[];

extern nm8s		ptblDCT_left_8[];
extern nm32s	ptblDCT_right_32[];
extern nm8s		ptblIDCT_left_8[] ;
extern nm32s	ptblIDCT_right_32[];

//////////////////////////////////////////////////////////////////////////////////////////////////////
// C - equivalent of assembly code for NM6403
// This routine perform DCT under sequence of Blocks8x8 

//
//void nmjpegFwdDct8x8(
//			 nm8s*		pSrcImg,		// Input Frame		:long Local [Width*Height/8]
//			nm32s*		pDstImg,		// Result DCT 		:long Global[Width*Height/2]
//			int			nWidth,			// Frame Width		:Width=     [16,32,48...]
//			int			nHeight,		// Frame Height		:Height=    [16,32,48...]
//			void*		pTmpBuf		// Temporary buffer	:long Local [Width*Height/2]
//			)
//{
//	nm8s* pSrcImgCopy=new nm8s[nWidth*nHeight];
//	memcpy(pSrcImgCopy, pSrcImg, nWidth*nHeight);
//
//
//	nmmtr8s		tblDCT_left_8 (ptblDCT_left_8,8,8);
//	nmmtr32s	tblDCT_right_32 (ptblDCT_right_32,8,8);
//	nmmtr8s		tblIDCT_left_8  (ptblIDCT_left_8,8,8);
//	nmmtr32s	tblIDCT_right_32 (ptblIDCT_right_32,8,8);
//
//	nmint32s OneHalf(0);
//	int ShiftR=20;
//	OneHalf=1<<(ShiftR-1);
//
//	nmmtr32s mRound(8,8);
//	mRound.fill(OneHalf);
//
//	for(int row=0,i=0;row<nHeight;row+=16)
//		for(int col=0;col<nWidth;col+=16,i+=4)
//		{
//
//			nmmtr8s Src1(pSrcImgCopy+row*nWidth+col,		8,8,nWidth);
//			nmmtr8s Src2(pSrcImgCopy+row*nWidth+col+8,		8,8,nWidth);
//			nmmtr8s Src3(pSrcImgCopy+(row+8)*nWidth+col,	8,8,nWidth);
//			nmmtr8s Src4(pSrcImgCopy+(row+8)*nWidth+col+8,	8,8,nWidth);
//
//			nmmtr32s Dst1(pDstImg+i*64,8,8);
//			nmmtr32s Dst2(pDstImg+(i+1)*64,8,8);
//			nmmtr32s Dst3(pDstImg+(i+2)*64,8,8);
//			nmmtr32s Dst4(pDstImg+(i+3)*64,8,8);
//
//			Dst1=tblDCT_left_8*(Src1*tblDCT_right_32);
//			Dst1+=mRound;
//			Dst1>>=ShiftR;
//	
//			Dst2=tblDCT_left_8*(Src2*tblDCT_right_32);
//			Dst2+=mRound;
//			Dst2>>=ShiftR;
//	
//			Dst3=tblDCT_left_8*(Src3*tblDCT_right_32);
//			Dst3+=mRound;
//			Dst3>>=ShiftR;
//	
//			Dst4=tblDCT_left_8*(Src4*tblDCT_right_32);
//			Dst4+=mRound;
//			Dst4>>=ShiftR;
//
//		}
//	delete pSrcImgCopy;
//
//}

void nmjpegFwdDct8x8(
			nm8s*		pSrcImg,		// Input Frame		:long Local [Width*Height/8]
			nm32s*		pDstImg,		// Result DCT 		:long Global[Width*Height/2]
			int			nWidth,			// Frame Width		:Width=     [16,32,48...]
			int			nHeight,		// Frame Height		:Height=    [16,32,48...]
			void*		pTmpBuf		// Temporary buffer	:long Local [Width*Height/2]
			)
{
	nm8s* pSrcImgCopy=new nm8s[nWidth*nHeight];
	memcpy(pSrcImgCopy, pSrcImg, nWidth*nHeight);


	nmmtr8s		tblDCT_left_8 (ptblDCT_left_8,8,8);
	nmmtr32s	tblDCT_right_32 (ptblDCT_right_32,8,8);
	nmmtr8s		tblIDCT_left_8  (ptblIDCT_left_8,8,8);
	nmmtr32s	tblIDCT_right_32 (ptblIDCT_right_32,8,8);

	nmint32s OneHalf(0);
	int ShiftR=20;
	OneHalf=1<<(ShiftR-1);

	nmmtr32s mRound(8,8);
	mRound.fill(OneHalf);

	for(int row=0,i=0;row<nHeight;row+=16)
		for(int col=0;col<nWidth;col+=16,i+=4)
		{

			nmmtr8s Src1(pSrcImgCopy+row*nWidth+col,		8,8,nWidth);
			nmmtr8s Src2(pSrcImgCopy+row*nWidth+col+8,		8,8,nWidth);
			nmmtr8s Src3(pSrcImgCopy+(row+8)*nWidth+col,	8,8,nWidth);
			nmmtr8s Src4(pSrcImgCopy+(row+8)*nWidth+col+8,	8,8,nWidth);

			nmmtr32s Dst1(pDstImg+i*64,8,8);
			nmmtr32s Dst2(pDstImg+(i+1)*64,8,8);
			nmmtr32s Dst3(pDstImg+(i+2)*64,8,8);
			nmmtr32s Dst4(pDstImg+(i+3)*64,8,8);

			Dst1=tblDCT_left_8*(Src1*tblDCT_right_32);
			Dst1+=mRound;
	
			Dst2=tblDCT_left_8*(Src2*tblDCT_right_32);
			Dst2+=mRound;
	
			Dst3=tblDCT_left_8*(Src3*tblDCT_right_32);
			Dst3+=mRound;
	
			Dst4=tblDCT_left_8*(Src4*tblDCT_right_32);
			Dst4+=mRound;
		}
	delete pSrcImgCopy;

}



void nmjpegFwdDct8x8Sec(
				   nm8s*		pSrcBlocks,		// Input Frame		:long Local [Width*Height/8]
				   nm32s*		pDstBlocks,		// Result DCT 		:long Global[Width*Height/2]
				   int			nBlocks,		// Frame Width		:Width=     [16,32,48...]
				   void*		pTmpBuf			// Temporary buffer	:long Local [Width*Height/2]
				   )
{
	nmmtr8s		tblDCT_left_8 (ptblDCT_left_8,8,8);
	nmmtr32s	tblDCT_right_32 (ptblDCT_right_32,8,8);
	
	nmint32s OneHalf(0);
	int ShiftR=20;
	OneHalf=1<<(ShiftR-1);

	nmmtr32s mRound(8,8);
	mRound.fill(OneHalf);

	for(int i=0;i <nBlocks; i++){
		nmmtr8s Src(pSrcBlocks+i*64,8,8);
		nmmtr32s Dst(pDstBlocks+i*64,8,8);
			
		Dst=tblDCT_left_8*(Src*tblDCT_right_32);
		Dst+=mRound;
	}
}
#ifdef __cplusplus
		};
#endif