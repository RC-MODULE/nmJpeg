//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   DCT Library                                                           */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   $Workfile:: ZigZag.asm                                               $*/
//*                                                                         */
//*   Contents:        Routines for forward and inverse Z-reordering        */
//*                                                                         */
//*   Software design: S.Mushkaev                                           */
//*                                                                         */
//*   Version          1.8                                                  */
//*   Start date:      06.02.2001                                           */
//*   Release  $Date: 2005/02/10 12:36:37 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/

 
     
extern	ptr_tbl_w_CombineEvenEven:word;
extern	ptr_tbl_w_CombineOddOdd:word;
extern	ptr_tbl_w_CombineEvenOdd:word;
extern	ptr_tbl_w_CombineOddEven:word;
extern	ptr_tbl_w_CombineDirect:word;

extern	G_tbl_w_OddEvenShr0:long [8];

extern	G_tbl_w_OddOddShr0:long [8] ; 
extern	G_tbl_w_EvenOddShr0:long [8] ; 
extern	G_tbl_w_EvenEvenShr0:long [8] ; 
extern	G_tbl_w_DirectShr0:long [4] ; 
extern	G_tbl_w_OddEven:long [8] ; 
extern	G_tbl_w_OddOdd:long [8] ; 
extern	G_tbl_w_EvenOdd:long [8] ; 
extern	G_tbl_w_EvenEven:long [8] ; 
extern	G_tbl_w_Direct:long [4] ; 
extern	dct_tbl_nb_EvenRightShift:word[13];
extern	dct_tbl_f1cr_int_Clip:word[32];
	



begin ".text_jpeg"


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Register interface function of Combining 2to2 
//
// It is equavalent notice of next two pseudo-instuctions:
//		rep N data=[ar0++gr0] with vsum ,data,vr;
//		rep N [ar6++gr6]=afifo;
// where N=[0,1,2,3....31,32,33....]
//
//
// INPUT REGISTERS:
// ar0->SrcVectorA												:long Global[size/2]
// gr0= SrcVectorA long to long reading step  in 32-bit words	:=[....-4,-2,0,2,4,...]
//
// ar1->SrcVectorB												:long Global[size/2]
// gr1= SrcVectorB long to long reading step  in 32-bit words	:=[....-4,-2,0,2,4,...]
//
// ar6->DstVector												:long Local [size/2]
// gr6= DstVector  long to long writing step  in 32-bit words	:=[....-4,-2,0,2,4,...]
//
// gr5= N - vector's size in 64-bit words(longs)				:=[0,1,2,3..]
//
// sb,nb1,vr,loaded weights  must be previously set
//
// NOTE:  There are no stack operations for some input registers,
// Registers : |ar0|   |   |   |   |   |ar6|   |
//			   |   |   |   |   |   |   |   |   |      will be changed after return !

macro ZCOMBINE2x2_REP(N)
	rep N data=[ar0++gr0],ftw,wtw	with vsum , activate data, 0;
	//WTW_REG(gr4);
	delayed return;
		rep N data=[ar1++gr1]	with vsum , activate data, afifo;
		rep N [ar6++gr6]=afifo;
	nul;
	nul;
	nul;
	nul;
end ZCOMBINE2x2_REP;


<dct_Combine2to2>
.branch;
	ar4=ar5;
	rep 8 wfifo=[ar4++],ftw;
	nb1=gr4;
	wtw;
	//WTW_REG(gr4);
	ar4=ar5;

	push ar2,gr2 with gr2=gr5<<27;
	push ar5,gr5 with gr5>>=5;
	Combine2to2_rep0:label;
	if =0 delayed goto Combine2to2_repN with gr2>>=26;
		ar2 = Combine2to2_rep0 with gr5--;
	
	<NextCombine2to2_rep32>
		rep 32 data =[ar0++gr0],ftw,wtw	with vsum , activate data, 0;
		//WTW_REG(gr4);
		rep 8  wfifo=[ar4++],ftw;
		rep 32 data =[ar1++gr1],wtw		with vsum , activate data, afifo;
		//WTW_REG(gr4);
		nul;
	if <>0 delayed goto NextCombine2to2_rep32 with gr5--;
		ar4=ar5;
		rep 32 [ar6++gr6]=afifo;
	<Combine2to2_repN>
	ar2+=gr2;
	delayed goto ar2 ; 
		pop ar5,gr5;
		pop ar2,gr2;
	<Combine2to2_rep0>
	delayed return;
		ftw;
		nul;
		nul;
	nul;
	nul;
	nul;
	nul;

	ZCOMBINE2x2_REP(4);
	ZCOMBINE2x2_REP(8);
	ZCOMBINE2x2_REP(12);
	ZCOMBINE2x2_REP(16);
	ZCOMBINE2x2_REP(20);
	ZCOMBINE2x2_REP(24);
	ZCOMBINE2x2_REP(28);
return;
.wait;

macro	ZCOMBINE_DIRECT(a,b)
	extern vec_vsum_activate_data_0:label;	
	ar4=[ptr_tbl_w_CombineDirect];
	rep 4 wfifo=[ar4++],ftw;
	ar0 = ar2;
	ar6 = ar3;
	ar0+= (a/2)*2;
	ar3+= 2;
	nb1=gr4;
	delayed call vec_vsum_activate_data_0;
		//WTW_REG(gr4);
		wtw;
		nul;

end		ZCOMBINE_DIRECT;

macro	ZCOMBINE_EVEN_EVEN(a,b)
	ar0 = ar2;
	ar1 = ar2;
	ar0+= (a/2)*2;
	ar1+= (b/2)*2;
	ar6 = ar3;
	ar3+= 2;
	
	delayed call dct_Combine2to2;
		ar5=[ptr_tbl_w_CombineEvenEven];
end		ZCOMBINE_EVEN_EVEN;

macro	ZCOMBINE_ODD_ODD(a,b)
	ar0 = ar2;
	ar1 = ar2;
	ar0+= (a/2)*2;
	ar1+= (b/2)*2;
	ar6 = ar3;
	ar3+= 2;
	
	delayed call dct_Combine2to2;
		ar5=[ptr_tbl_w_CombineOddOdd];
end		ZCOMBINE_ODD_ODD;

macro	ZCOMBINE_EVEN_ODD(a,b)
	ar0 = ar2;
	ar1 = ar2;
	ar0+= (a/2)*2;
	ar1+= (b/2)*2;
	ar6 = ar3;
	ar3+= 2;
	
	delayed call dct_Combine2to2;
		ar5=[ptr_tbl_w_CombineEvenOdd];
end		ZCOMBINE_EVEN_ODD;
	
macro	ZCOMBINE_ODD_EVEN(a,b)
	ar0 = ar2;
	ar1 = ar2;
	ar0+= (a/2)*2;
	ar1+= (b/2)*2;
	ar6 = ar3;
	ar3+= 2;
	delayed call dct_Combine2to2;
		ar5=[ptr_tbl_w_CombineOddEven];
end		ZCOMBINE_ODD_EVEN;

	

macro	ZCOMBINE(a,b)
	.if a*80000000h;		// a=odd
		.if b*80000000h;		// b=0dd
			ZCOMBINE_ODD_ODD(a,b);
		.endif;
		.if not b*80000000h;	// b=even
			ZCOMBINE_ODD_EVEN(a,b);
		.endif;
	.endif;

	.if not a*80000000h;	// a=even
		.if b*80000000h;		// b=odd
			ZCOMBINE_EVEN_ODD(a,b);
		.endif;
		.if not b*80000000h;	// b=even
			ZCOMBINE_EVEN_EVEN(a,b);
		.endif;
	.endif;

end		ZCOMBINE;

//////////////////////////////////////////////////////////////////////////////////////////////

    //--------------------------------------------------------------------
    //! \fn void nmjpegFwdZigZag8x8(int* pSrcBlockSeq, int* pDstBlockSeq,	int	nBlocks, int	nPreShift=0, int	fUseCharClip=0 );
    //! 
	//! \perfinclude _nmjpegFwdZigZag8x8__FPiPiiii.html
    //--------------------------------------------------------------------

extern vec_tbl_sb_int_EvenRightShift:long;
extern vec_tbl_nb_int_EvenRightShift:long;



//////////////////////////////////////////////////////////////////////////////////////////////

    //--------------------------------------------------------------------
    //! \fn void nmjpegInvZigZag8x8(int*	pSrcBlockSeq, int*	pDstBlockSeq, int nBlock);
    //! 
	//! \perfinclude _nmjpegInvZigZag8x8__FPiPii.html
    //--------------------------------------------------------------------



//<_nmjpegInvZigZag8x8__FPiPii>

global _nmjpegInvZigZag8x8:label;
<_nmjpegInvZigZag8x8>
.branch;
	ar5=ar7-2;
	
	push ar0, gr0;
	push ar1, gr1;
	push ar2, gr2;
	push ar3, gr3;
	push ar4, gr4;
	push ar5, gr5;
	push ar6, gr6;
	
	ar0 = [--ar5];//		GSrc,	// Input array in normal order	:long Global[nBlocks*64/2]
	ar6 = [--ar5];//		GDst,	// Output array in Z-order		:long Global[nBlocks*64/2]
	gr5 = [--ar5];//		nBlocks	// Number of 8x8 Blocks			:nBlocks=[1,2,3....]
	
	
	sb  = [vec_tbl_sb_int_EvenRightShift];
	f1cr= 80000000h;
	gr4 = 80000002h;
	
	gr0 = G_tbl_w_EvenEvenShr0;
	gr1 = G_tbl_w_EvenOddShr0;
	gr2 = G_tbl_w_OddEvenShr0;
	gr3 = G_tbl_w_OddOddShr0;
	gr7 = G_tbl_w_DirectShr0;
	

	[ptr_tbl_w_CombineEvenEven]=gr0;
	[ptr_tbl_w_CombineEvenOdd] =gr1;
	[ptr_tbl_w_CombineOddEven] =gr2;
	[ptr_tbl_w_CombineOddOdd]  =gr3;
	[ptr_tbl_w_CombineDirect]  =gr7;

	
	gr0 = 64;
	gr1 = 64;
	gr6 = 64;
	ar2 = ar0;
	ar3 = ar6;
	nb1 = gr4;
	

	// 0,  1,  5,  6, 14, 15, 27, 28,
	// 2,  4,  7, 13, 16, 26, 29, 42,  
	// 3,  8, 12, 17, 25, 30, 41, 43,
	// 9, 11, 18, 24, 31, 40, 44, 53,
	//10, 19, 23, 32, 39, 45, 52, 54,
	//20, 22, 33, 38, 46, 51, 55, 60,
	//21, 34, 37, 47, 50, 56, 59, 61,
	//35, 36, 48, 49, 57, 58, 62, 63

	ZCOMBINE_DIRECT(0,1);
	ZCOMBINE(5,6);
	ZCOMBINE_DIRECT(14,15);
	ZCOMBINE(27,28);	
	ZCOMBINE(2,4);	
	ZCOMBINE(7,13);	
	ZCOMBINE(16,26);	
	ZCOMBINE(29,42);	
	ZCOMBINE(3,8);	
	ZCOMBINE(12,17);	
	ZCOMBINE(25,30);
	ZCOMBINE(41,43);
	ZCOMBINE(9,11);
	ZCOMBINE(18,24);
	ZCOMBINE(31,40);
	ZCOMBINE(44,53);
	ZCOMBINE(10,19);
	ZCOMBINE(23,32);
	ZCOMBINE(39,45);
	ZCOMBINE(52,54);
	ZCOMBINE(20,22);
	ZCOMBINE(33,38);
	ZCOMBINE(46,51);	
	ZCOMBINE(55,60);	
	ZCOMBINE(21,34); 
	ZCOMBINE(37,47);	
	ZCOMBINE(50,56);	
	ZCOMBINE(59,61);
	ZCOMBINE(35,36);
	ZCOMBINE_DIRECT(48,49);
	ZCOMBINE(57,58);
	ZCOMBINE_DIRECT(62,63); 

	pop ar6, gr6;
	pop ar5, gr5;
	pop ar4, gr4;
	pop ar3, gr3;
	pop ar2, gr2;
	pop ar1, gr1;
	pop ar0, gr0;

return; 



end ".text_jpeg";


