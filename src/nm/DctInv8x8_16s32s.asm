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

//import from regs;
import from rtmacro;
//import from macros;
//import from vecmacro;



extern DCT_Right:long[4*8];
extern DCT_Left:long[8*1];
extern IDCT_Right:long[4*8];
extern IDCT_Left:long[8*1];
extern RoundTbl_32bit:long[32];




data ".data_jpeg"
	MacroblockRow:word;
	struct SDCT_Param		// Structure of parameters for  DCT_Multiplication function
		Src:word;			// Input  16bit-Buffer			long[n8x8Blocks*64/4]
		Dst:word;			// Output 32-bit Buffer			long[n8x8Blocks*64/2]
		Tmp:word;			// Temporary 32-bit Buffer		long[n8x8Blocks*64/2]
		n8x8Blocks:word;	// Number of blocks in Source Buffer
		LeftMx:word;		// Left-hand  being multiplied matrix
		RightMx:word;		// Right-hand being multiplied matrix
		RoundIndx:word;		// Index of Roundating number - fix(0.5) 
		Temp:word;
		Width:word;
		Height:word;
	end SDCT_Param;
	PostShift:word;


	.align;	DCT   :SDCT_Param;

	T1:word;
	T0:word;
	AR0:word;
	AR1:word;
	AR2:word;
	AR3:word;
	AR6:word;	

end ".data_jpeg";

begin ".text_jpeg"


/////////////////////////////////////////////////////////////////////////////////
  
    //--------------------------------------------------------------------
    //! \fn void nmjpegInvDct8x8( nm16s* pSrcImg, nm32s*		pDstImg, int	nWidth,	int	 nHeight, void* pTmpBuf	);
    //! 
	//! \perfinclude _nmjpegInvDct8x8__FPSsPiiiPv.html
    //--------------------------------------------------------------------
//
//  DESCRIPTION:
//	2D - forward DCT computation under each 8x8 blocks of the  frame.
//  Frame - 2D array Width*Height of 8-bit SIGNED elements
//  Each four neighbouring transformed blocks are combined into macroblocks 16x16 and
//  then stored as a sequense of macroblocks 16x16 with the scannig order from the left to the right
//  and from the top to the bottom within frame.
//  The scanning order of blocks within macroblock is: 
//  01 02 
//  03 04
//  The scanning order of the coefficients within block is:
//  00 01 02 03 04 ... 07
//  08 09 10 11 12 ... 15
//  .....................
//  56 57 58 59 60 ... 63
// 

global _nmjpegInvDct8x8__FPSsPiiiPv:label;
global _void._.8.8nmjpegInvDct8x8.1short._.0.9._int._.0.9._int.9._int.9._void._.0.2 :label;
<_nmjpegInvDct8x8__FPSsPiiiPv>
<_void._.8.8nmjpegInvDct8x8.1short._.0.9._int._.0.9._int.9._int.9._void._.0.2>

.branch;
//pswr set 30000h;
	ar5=ar7-2;
	push ar0, gr0;
	push ar1, gr1;
	push ar2, gr2;
	push ar3, gr3;
	push ar4, gr4;
	push ar5, gr5;
	push ar6, gr6;
	
	gr0 = [--ar5];		//SrcBuffer,	// Source buffer	:long[nBlock8x8*64/4] (Block by block input order)
	gr1 = [--ar5];		//DstBuffer,	// Result DCT		:long[nBlock8x8*64/2] (Block by block output order)
	gr2 = [--ar5];		//Width,		// Frame Width
	gr3 = [--ar5];		//Height,		// Frame Height
	gr4 = [--ar5];		//Buffer		// Temp buffer		:long[nBlock8x8*64/4]

	[DCT.Src]	=gr0; 
	[DCT.Tmp]	=gr1;	// DstBuffer (Use PostShift)
	[DCT.Width]	=gr2;	 
	[DCT.Height]=gr3;
	[DCT.Dst]	=gr4;	// TmpBuffer (Use PostShift)
	gr0=IDCT_Right;
	gr1=IDCT_Left;
	[DCT.RightMx]=gr0;
	[DCT.LeftMx]=gr1;

	call IDCT_Frame_Multiplication; 

	ar0 = [DCT.Dst];	// TmpBuffer
	ar6 = [DCT.Tmp];	// DstBuffer
	gr0 = [DCT.Width];
	gr1 = [DCT.Height];

	MULT32(gr2,gr0,gr1);
	
	gr7=16;
//	VEC_ARSH32_RRRR(ar0,ar6,gr2,gr7);(rSrc,rDst,rIntCount,rShift)
//	VEC_ArshC (nm8s *pSrcVec, int nShift, nm8s *pDstVec, int nSize)
//	extern _VEC_ArshC__FPiiPii:label;
	extern _void._.8.8VEC_ArshC.1int._.0.9._int.9._int._.0.9._int.2:label;
	ar5 = ar7;
	ar7 += 4;
	[ ar5++ ] = gr2; //nSize
	[ ar5++ ] = ar6; //pDstVec
	//delayed call _void._.8.8VEC_ArshC.1int._.0.9._int.9._int._.0.9._int.2;
		[ ar5++ ] = gr7; //nShift
		[ ar5++ ] = ar0; //pSrcVec
	nul;
	ar7-=4;


	pop ar6, gr6;
	pop ar5, gr5;
	pop ar4, gr4;
	pop ar3, gr3;
	pop ar2, gr2;
	pop ar1, gr1;
	pop ar0, gr0;
	
//gr7=t1;
gr7=[T1];
return ; 
.wait;



//**********************************************************
//  Core IDCT computation  - without final normalization
//	Data is gotten direct from frame and placed in macroblock sequence 
// 
//	PERFORM:
//		computation LBuffer1=DTC(SrcBuffer)=LeftMx*SrcBuffer*RightMx
//	ON ENTER: 
//		gr7=1
//		[DCT.Src]			= Input Sequence of INPUT MATRIXES 8x8 (16-bit values)
//		[DCT.Dst]			= Sequence of OUTPUT DCT(IDCT) MATRIXES 8x8 (32-bit values)
//		[DCT.Width]			= Temp buffer
//		[DCT.Height]
//		[DCT.LeftMx]		= Left-hand  being multiplied matrix
//		[DCT.RightMx]		= Right-hand being multiplied matrix
//		[DCT.RoundIndx]		= Index of Rounder - +0.5 in fixed-point notation
//  COMMENTS:
//	WARNING:
//		There are no stack operations - some registers will be changed
//		
//*************************************************************
<IDCT_Frame_Multiplication>
.branch;


	/////////////////////////////////////////////////////////
	// The first stage matrix-matrix multiplication 
	// DstBuffer=SrcBuffer*RightMx
	//
	//	__int64 RightMx[8][4]	
	//	__int64 Src[Height*Width/4]
	//	__int64 Dst[Height*Width/2/4][4]
	//
	//	for (int S=0;S<Height*Width/4;S+=32)
	//	{
	//		for(int R=0;R<32;R++)
	//			afifo=vsum4x2(Src[S+R],C[0..3][0]);
	//		for(int R=0;R<32;R++)
	//			Tmp[S+R][0]=vsum4x2(Src[S+R],C[4..7][0]) + afifo;
	//		
	//		
	//		for(int R=0;R<32;R++)
	//			afifo=vsum4x2(Src[S+R],C[0..3][1]);
	//		for(int R=0;R<32;R++)
	//			Tmp[S+R][1]=vsum4x2(Src[S+R],C[4..7][1]) + afifo;
	//		
	//		
	//		for(int R=0;R<32;R++)
	//			afifo=vsum4x2(Src[S+R],C[0..3][2]);
	//		for(int R=0;R<32;R++)
	//			Tmp[S+R][2]=vsum4x2(Src[S+R],C[4..7][2]) + afifo;
	//		
	//		
	//		for(int R=0;R<32;R++)
	//			afifo=vsum4x2(Src[S+R],C[0..3][3]);
	//		for(int R=0;R<32;R++)
	//			Tmp[S+R][3]=vsum4x2(Src[S+R],C[4..7][3]) + afifo;
	//	}
	//
	gr0=[DCT.Width]	;
	gr1=[DCT.Height];
	MULT32(gr7,gr0,gr1);
	gr7>>=6;
	[DCT.n8x8Blocks]=gr7;

	gr7=1;
	sb =00020002h 
		with gr0=gr7<<31;
	ar1=[DCT.Src]				// SOURCE MATRIX
		with gr2=gr7<<1;								
	nb1=gr0;					//gr0=80000000h; (CONST)

	ar2=ar1	 with gr1=gr7<<2;	//gr1=4;							// A[0][0] A[0][1] A[0][2] A[0][3] 
	ar2+=gr2 with gr2=gr7<<2;	//gr2=4;							// A[0][4] A[0][5] A[0][6] A[0][7]
	ar3=ar2  with gr3=gr7<<2;	//gr3=4;							// A[0][4] A[0][5] A[0][6] A[0][7]
	ar4=ar2  with gr4=gr7<<2;	//gr4=4;							// A[0][4] A[0][5] A[0][6] A[0][7]
	ar5=ar2  with gr5=gr7<<2;	//gr5=4;
	ar6=[DCT.Tmp];				// TEMP MATRIX
	ar0=[DCT.RightMx];			// RIGHT-HAND MATRIX
	
	rep 32 wfifo=[ar0++],ftw;
	gr6 = 8;
	//WTW_REG(gr0);
	nb1=gr0;
	wtw;
	gr7=[DCT.n8x8Blocks];
	gr7>>=2;
	with gr7--;
	<IDCT_Frame_NextMacroblock>
		rep 32 data,ram=[ar1++gr1],ftw,wtw with vsum ,data,0;		// A[0][0] A[0][1] A[0][2] A[0][3] 
		//WTW_REG(gr0);
		push ar6,gr6;
		push ar6,gr6;
		rep 32 data=[ar2++gr2],ftw,wtw with vsum ,data,afifo;	// A[0][4] A[0][5] A[0][6] A[0][7]
		//WTW_REG(gr0);
		rep 32 [ar6++gr6]=afifo ,ftw,wtw with vsum ,ram,0;
		//WTW_REG(gr0);
		pop ar6,gr6;
		nul;
		ar6+=2;


		push ar6,gr6;
		rep 32 data=[ar3++gr3],ftw,wtw with vsum ,data,afifo;	// A[0][4] A[0][5] A[0][6] A[0][7]
		//WTW_REG(gr0);	
		rep 32 [ar6++gr6]=afifo,ftw,wtw with vsum ,ram,0;
		//WTW_REG(gr0);
		pop ar6,gr6;
		nul;
		ar6+=2;
		
		push ar6,gr6;
		rep 32 data=[ar4++gr4],ftw,wtw with vsum ,data,afifo;	// A[0][4] A[0][5] A[0][6] A[0][7]
		//WTW_REG(gr0);
		rep 32 [ar6++gr6]=afifo,ftw,wtw with vsum ,ram,0;
		//WTW_REG(gr0);
		ar0=[DCT.RightMx];
		pop ar6,gr6;
		nul;
		ar6+=2;


		rep 32 data=[ar5++gr5] with vsum ,data,afifo;		// A[0][4] A[0][5] A[0][6] A[0][7]
		rep 32 wfifo=[ar0++],ftw,wtw;
		//WTW_REG(gr0);
		rep 32 [ar6++gr6]=afifo;
		pop ar6,gr6;
	if <>0 delayed goto IDCT_Frame_NextMacroblock with gr7--;
		ar6+=4*64;

	ftw,wtw;
	ftw,wtw;
	ftw,wtw;
	ftw,wtw;
	ftw,wtw;
	ftw,wtw;
	ftw,wtw;
	

	//=============================================================
	// The second stage matrix-matrix multiplication 
	// Multiplying CT Matrix by AxC product in four steps
	// gr4 - 80000000h
	//
	// int64 LeftMx[8]					// Matrix CT 
	// int64 Dst[Height*Width/8][4]		// A*C
	// int64 Tmp[Width*Height/2]		// Result CT*A*C
	//	 or  Tmp[Width/2][Height]
	//  
	//	int DR=0
	//	int r=0;
	//	for(int TR=0;TR<Height/16;TR+=16)
	//		for(int TC=0;TC<Width/16/2;TC+=8,DR+=32)
	//		{
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+0]=vsum(LeftMX[...],Dst[DR...][0]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+1]=vsum(LeftMX[...],Dst[DR...][1]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+2]=vsum(LeftMX[...],Dst[DR...][2]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+3]=vsum(LeftMX[...],Dst[DR...][3]);
	//
	//			DR+=8;
	//
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+4+0]=vsum(LeftMX[...],Dst[DR+8...][0]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+4+1]=vsum(LeftMX[...],Dst[DR+8...][1]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+4+2]=vsum(LeftMX[...],Dst[DR+8...][2]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+r][TC+4+3]=vsum(LeftMX[...],Dst[DR+8...][3]);
	//
	//
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+0]=vsum(LeftMX[...],Dst[DR+16...][0]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+1]=vsum(LeftMX[...],Dst[DR+16...][1]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+2]=vsum(LeftMX[...],Dst[DR+16...][2]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+3]=vsum(LeftMX[...],Dst[DR+16...][3]);
	//
	//
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+4+0]=vsum(LeftMX[...],Dst[DR+24...][0]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+4+1]=vsum(LeftMX[...],Dst[DR+24...][1]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+4+2]=vsum(LeftMX[...],Dst[DR+24...][2]);
	//			for(r=0;r<8;r++)
	//				Tmp[TR+8+r][TC+4+3]=vsum(LeftMX[...],Dst[DR+24...][3]);
	//
	//		}
	//	}

	
	
	sb  = 02020202h;
	gr4 = 80000000h;
	nb1 = gr4;
	
	ar6 = [DCT.Tmp];
	ar0 = [DCT.Dst];			// TEMP MATRIX
	
	gr5 = 8;
	gr6 = 2;

	ar5=ar6;
	rep 8 wfifo=[ar5++gr5],ftw;
	ar5 = ar6 + gr6 with gr6++;
	with gr6++;


	ar1 = ar0+2;
	ar2 = ar0+4;
	ar3 = ar0+6;
	gr0 = [DCT.Width];
	
	[AR0]=ar0 with gr1 = gr0;
	[AR1]=ar1 with gr2 = gr0;
	[AR2]=ar2 with gr3 = gr0;
	[AR3]=ar3;
	[AR6]=ar6;

	ar4 = [DCT.LeftMx];		// LEFT-HAND MATRIX
	rep 8 ram=[ar4++];

	


	vr  = 00008000h;
		
	
	gr7 = [DCT.Height];
	gr7 >>= 4;			// Number of macroblocks in column
	[MacroblockRow]=gr7;

	//WTW_REG(gr4);
	nb1=gr4;
	wtw;

	<IDCT_Frame_NextMacroblockRow>
		gr7 = [DCT.Width];
		with gr7 >>=4;	// Number of macroblocks in row
	
		<IDCT_Frame_NextMacroBlock>	
			
			// 1-st Block of macroblock calculation 
			// Start of Block (Column01)
			
			
			//****** Processing Block 1 of macroblock ********
			push ar0,gr0;
			push ar1,gr1;
			push ar2,gr2;
			push ar3,gr3;



			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar0++gr0]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar1++gr1]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar2++gr2]=afifo;
			
			
			//****** Processing Block 3 of macroblock ********
			ar6 +=8*8*2;		
			gr6 = 2;
			ar5 = ar6;			
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar3++gr3]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;

			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar0++gr0]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar1++gr1]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar2++gr2]=afifo;
			
			gr6 = 2;
			ar6 +=-8*8*2+8*8;
			ar5 = ar6;

			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar3++gr3]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
					
			pop ar3,gr3;
			pop ar2,gr2;
			pop ar1,gr1;
			pop ar0,gr0;
			//****** Processing Block 2 of macroblock ******** 

			ar0+=8;
			ar1+=8;
			ar2+=8;
			ar3+=8;

			push ar0,gr0;
			push ar1,gr1;
			push ar2,gr2;
			push ar3,gr3;

			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar0++gr0]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;			
	
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar1++gr1]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;			

			
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar2++gr2]=afifo;
			ar6+=-8*8+8*8*3;		
			gr6 = 2;
			ar5=ar6;			

			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar3++gr3]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
			
			//****** Processing Block 4 of macroblock ********
			

			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar0++gr0]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
						
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar1++gr1]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;
			
			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar2++gr2]=afifo;
			ar6=[AR6];
			gr6 =2;
			ar6 +=8*8*4;
			[AR6]=ar6;
			ar5=ar6;
			

			//WTW_REG(gr4);
			wtw;
			rep 8 wfifo=[ar5++gr5],ftw with vsum ,ram,vr;
			rep 8 [ar3++gr3]=afifo;
			ar5 = ar6 + gr6 with gr6++;
			with gr6++;

			pop ar3,gr3;
			pop ar2,gr2;
			pop ar1,gr1;
			pop ar0,gr0;
			//***********************************************
			nul;
			ar0+=8;
			ar1+=8;
			ar2+=8;
			ar3+=8 with gr7--;
		if <>0 delayed goto IDCT_Frame_NextMacroBlock;
			nul;
			nul;


		ar0=[AR0]		with gr7=gr0;
		gr0=[DCT.Width] ;
						with gr0<<=4;
		ar1=[AR1]		with gr1=gr0;
		ar2=[AR2]		with gr2=gr0;
		ar3=[AR3]		with gr3=gr0;
		nul;
		ar0+=gr0;
		ar1+=gr1;
		ar2+=gr2;
		ar3+=gr3;


		[AR0]=ar0 with gr0=gr7;
		[AR1]=ar1 with gr1=gr7;
		[AR2]=ar2 with gr2=gr7;
		[AR3]=ar3 with gr3=gr7;

		
		gr7 = [MacroblockRow];
		gr7--;
	if <>0 delayed goto IDCT_Frame_NextMacroblockRow;
		[MacroblockRow]=gr7;

	wtw;

return;
.wait;



end ".text_jpeg";


