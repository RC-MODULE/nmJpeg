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
 void nmjpegInvDct8x8(
			nm16s*		pSrcImg,	// Input Frame		:long Local [Width*Height/4]
			nm32s*		pDstImg,	// Result DCT 		:long Global[Width*Height/2]
			int			nWidth,		// Frame Width		:Width=     [16,32,48...]
			int			nHeight,	// Frame Height		:Height=    [16,32,48...]
			void*		pTmpBuf		// Temporary buffer	:long Local [Width*Height/2]
			)
{
	nm16s* pSrcImgCopy=new nm16s[nWidth*nHeight];
	memcpy(pSrcImgCopy, pSrcImg, nWidth*nHeight*2);

	nmmtr8s		tblDCT_left_8	(ptblDCT_left_8,8,8);
	nmmtr32s	tblDCT_right_32 (ptblDCT_right_32,8,8);
	nmmtr8s		tblIDCT_left_8  (ptblIDCT_left_8,8,8);
	nmmtr32s	tblIDCT_right_32(ptblIDCT_right_32,8,8);



	nmint32s OneHalf(0);


	int ShiftR=16;
	OneHalf=1<<(ShiftR-1);
	
	nmmtr32s mRound(8,8);
	mRound.fill(OneHalf);

	int DstIdx=0;
	for(int row=0,i=0; row<nHeight; row+=16)
		for(int col=0; col<nWidth; col+=16,i+=4)
		{
			nmmtr16s Src1(pSrcImgCopy+i*64,8,8);
			nmmtr16s Src2(pSrcImgCopy+(i+1)*64,8,8);
			nmmtr16s Src3(pSrcImgCopy+(i+2)*64,8,8);
			nmmtr16s Src4(pSrcImgCopy+(i+3)*64,8,8);

			nmmtr32s Dst1(pDstImg+row*nWidth+col,8,8,nWidth);
			nmmtr32s Dst2(pDstImg+row*nWidth+col+8,8,8,nWidth);
			nmmtr32s Dst3(pDstImg+(row+8)*nWidth+col,8,8,nWidth);
			nmmtr32s Dst4(pDstImg+(row+8)*nWidth+col+8,8,8,nWidth);
			
			Dst1=tblIDCT_left_8*(Src1*tblIDCT_right_32);
			Dst1+=mRound;
			Dst1>>=ShiftR;
	
			Dst2=tblIDCT_left_8*(Src2*tblIDCT_right_32);
			Dst2+=mRound;
			Dst2>>=ShiftR;
	
			Dst3=tblIDCT_left_8*(Src3*tblIDCT_right_32);
			Dst3+=mRound;
			Dst3>>=ShiftR;
	
			Dst4=tblIDCT_left_8*(Src4*tblIDCT_right_32);
			Dst4+=mRound;
			Dst4>>=ShiftR;

		}

	delete pSrcImgCopy;

}
#ifdef __cplusplus
		};
#endif