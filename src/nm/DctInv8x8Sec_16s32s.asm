//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   DCT Library                                                           */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   $Workfile:: DctFrame.asm                                             $*/
//*                                                                         */
//*   Contents:         Routines for computing the                          */
//*                     and inverse 2D DCT of an image                      */
//*                                                                         */
//*   Software design: S.Mushkaev                                           */
//*                                                                         */
//*   Version          2.2                                                  */
//*   Start date:      2014                                                  */
//*                                                                         */
//*                                                                         */
//***************************************************************************/

extern IDCT_Right:long[4*8];
extern IDCT_Left :long[8*1];
extern vec_Mul2D2W4_AddVr: label;


begin ".text_jpeg"

    //--------------------------------------------------------------------
    //! \fn void nmjpegInvDct8x8Sec( nm8s* pSrcImg, nm32s* pDstImg, int nBlocks, void* pTmpBuf);
    //! 
    //--------------------------------------------------------------------


//      <_void._.8.8nmjpegInvDct8x8Sec.1short._.0.9._int._.0.9._int.9._void._.0.2>
global _nmjpegInvDct8x8Sec:label;
      <_nmjpegInvDct8x8Sec>

.branch;
	ar5=ar7-2;
	push ar0,gr0;
	push ar1,gr1;
	push ar2,gr2;
	push ar3,gr3;
	push ar4,gr4;
	push ar5,gr5;
	push ar6,gr6;
	

	gr2 = [--ar5];		// pSrcImg,	
	gr3 = [--ar5];		// pDstImg,	
	push ar3,gr3;		// pDst>>stack
	gr5 = [--ar5];		// nBlocks
	ar6 = [--ar5];		// pTmpBuf
	gr5 <<=3;
	//-------------- умножение [T]=[X]*[C] -----------------------------
	gr0 = 4;
	gr1 = 4;
	gr6 = 2;
	gr3 = gr2+gr6;
	
	sb  = 00020002h;
	nb1 = 80000000h;

	vr = 0;
	ar4= IDCT_Right;
	gr4 = 2*8;
	push ar6,gr6;		// pTmp>>stack
	delayed call vec_Mul2D2W4_AddVr ;
		ar0 = gr2;					// ar0=pSrcImg
		ar1 = gr3;					// ar1=pSrcImg+2
	
	ar4+=gr4;	
	//ar2 = ar6;
	push ar6,gr6;		// pTmp++>>stack
	delayed call vec_Mul2D2W4_AddVr ;
		ar0 = gr2;					// ar0=pSrcImg
		ar1 = gr3;					// ar1=pSrcImg+2
	
	ar4+=gr4;	
	//ar3 = ar6;
	push ar6,gr6;		// pTmp++>>stack
	delayed call vec_Mul2D2W4_AddVr ;
		ar0 = gr2;					// ar0=pSrcImg
		ar1 = gr3;					// ar1=pSrcImg+2
	 
	ar4+=gr4;	
	//ar4 = ar6;
	push ar6,gr6;		// pTmp++>>stack
	delayed call vec_Mul2D2W4_AddVr ;
		ar0 = gr2;					// ar0=pSrcImg
		ar1 = gr3;					// ar1=pSrcImg+2
	
	pop ar4,gr4;		// pTmp++<<stack
	pop ar3,gr3;		// pTmp++<<stack
	pop ar2,gr2;		// pTmp++<<stack
	pop ar1,gr1;		// pTmp  <<stack
	//-------------- умножение [Y]=[C]*[T] -----------------------------
	sb  = 02020202h;
	ar0 = IDCT_Left;
	rep 8 ram=[ar0++];				// <=[cos]
	gr5 >>=3;
	vr  = 08000h;
	pop ar6,gr6;		// pDst<< stack
	gr3 = gr6;
	gr6 = 2*4;
	gr0 = 2;
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
	
		gr3 = ar5 with gr5--;
	if > delayed goto NextBlock8x8 ;		
		rep 8  with vsum ,ram, vr;
		rep 8 [ar6++gr6]=afifo;
		
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


