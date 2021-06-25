//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   DCT Library                                                           */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   $Workfile:: DctFrame.asm                                             $*/
//*                                                                         */
//*   Contents:         Routines for computing the forward                  */
//*                     and inverse 2D DCT of an image                      */
//*                                                                         */
//*   Software design: S.Mushkaev                                           */
//*                                                                         */
//*   Version          2.2                                                  */
//*   Start date:      23.11.2001                                           */
//*   Release  $Date: 2005/02/10 12:36:37 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/
//#include "dct.h"


extern DCT_Right:long[4*8];
extern DCT_Left:long[8*1];
//extern RoundTbl_32bit:long[32];

extern vec_vsum_data_0: label;


begin ".text_jpeg"

    //--------------------------------------------------------------------
    //! \fn void nmjpegFwdDct8x8Sec( nm8s* pSrcImg, nm32s* pDstImg, int nBlocks, void* pTmpBuf);
    //! 
    //--------------------------------------------------------------------





global _nmjpegFwdDct8x8Sec:label;
<_nmjpegFwdDct8x8Sec>

.branch;
	ar5=ar7-2;
	push ar0,gr0;
	push ar1,gr1;
	push ar2,gr2;
	push ar3,gr3;
	push ar4,gr4;
	push ar5,gr5;
	push ar6,gr6;
	

	gr4 = [--ar5];		// pSrcImg,	
	gr3 = [--ar5];		// pDstImg,	
	gr5 = [--ar5];		// nBlocks
	ar1 = [--ar5];		// pTmpBuf
	gr5 <<=3;
	//-------------- умножение [T]=[X]*[C] -----------------------------
	gr0 = 2;
	gr6 = gr0;
	
	sb  = 02020202h;
	nb1 = 80000000h;

	ar4= DCT_Right;
	rep 32 wfifo = [ar4++],ftw;
		
	ar6 = ar1;						// pTmpBuf
	wtw;
	delayed call vec_vsum_data_0 ;
		ftw;
		ar0 = gr4;					// ar0=pSrcImg
		
	ar2 = ar6;
	wtw;
	delayed call vec_vsum_data_0 ;
		ar0 = gr4;					// ar0=pSrcImg
		ftw;
	ar3 = ar6;
	wtw;
	delayed call vec_vsum_data_0 ;
		ar0 = gr4;					// ar0=pSrcImg
		ftw;
	ar4 = ar6;
	wtw;
	delayed call vec_vsum_data_0 ;
		ar0 = gr4;					// ar0=pSrcImg
		nul;
	
	//-------------- умножение [Y]=[C]*[T] -----------------------------
	ar0 = DCT_Left;
	rep 8 ram=[ar0++];				// <=[cos]
	gr5 >>=3;
	vr  = 80000h;
	ar6 = gr3;			// ar6=pDstImg
	gr6 = 2*4;
	
	<NextBlock8x8>
		
		rep 8 wfifo=[ar1++], ftw;
		wtw;
		ar6 = gr3 with gr3+=gr0;
		rep 8 wfifo=[ar2++], ftw with vsum ,ram, vr;
		rep 8 [ar6++gr6]=afifo, wtw;
		ar5 = ar6;
		ar6 = gr3 with gr3+=gr0;
		rep 8 wfifo=[ar3++], ftw with vsum ,ram, vr;
		rep 8 [ar6++gr6]=afifo, wtw;
	
		ar6 = gr3 with gr3+=gr0;
		rep 8 wfifo=[ar4++], ftw with vsum ,ram, vr;
		rep 8 [ar6++gr6]=afifo, wtw;
		ar6 = gr3 with gr3+=gr0;
	
		rep 8  with vsum ,ram, vr;
		rep 8 [ar6++gr6]=afifo;
		gr3 = ar5 with gr5--;
if > goto NextBlock8x8 ;		
		
	pop ar6,gr6;
	pop ar5,gr5;
	pop ar4,gr4;
	pop ar3,gr3;
	pop ar2,gr2;
	pop ar1,gr1;
	pop ar0,gr0;
	 
	return ; 
.wait;





end ".text_jpeg";


