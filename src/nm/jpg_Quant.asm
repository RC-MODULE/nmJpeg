//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   Vector Processing  Library                                            */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   $Workfile:: JPEGQuant.asm                                            $*/
//*                                                                         */
//*   Contents:        Quantizing routines                                  */
//*                                                                         */
//*   Software design: S.Mushkaev                                           */
//*                                                                         */
//*   Version          1.5                                                  */
//*   Start date:      31.01.2001                                           */
//*   Release  $Date: 2005/02/10 12:36:37 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/
// #include "vDiv.h"

extern	Quant32Table:long;
extern vec_w_int_2174Div132:long;
extern vec_tbl_sb_int_EvenRightShift:long;
extern vec_vsum_data_vr:label;
extern vec_IncNeg:label;




data ".data_jpeg"
		vec_long_0:long=0hl;
		//vec_long_tmp:long;
		PostShift:word;

		param0:word;
		param1:word;
		param2:word;
		param3:word;
		
GR7:word;
tmp:word;
end  ".data_jpeg";

macro WTW_REG( Arg )
.wait;
    nb1 = Arg;
    wtw;
.branch;
end WTW_REG;

begin ".text_jpeg"

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// void nmjpegQuant_By2Int(
//			int*	SrcBuffer,			// Input array 					:long Global[NumbersOfPairs*SrcPairReadStep/2]
//			int*	DstBuffer,			// Output qunatized array		:long Global[NumbersOfPairs*DstPairWriteStep/2]
//			int*	Quantizers,			// Array of two quantizers		:long Local [2/2]; PairOfQuantizers[0,1]=[1,2,3...128]
//			int		Count,				// Number of 32-bit elements to be quantized	:=[0,1,2,3...]
//			void*	TmpBuffer,			// First  Temporary array		:long Local [NumbersOfPairs]
//			int		SrcReadStep=2,		// long to long reading step (in 32-bit words)	:=[-2,0,2,4,6...]
//			int		DstWriteStep=2,		// long to long writing step (in 32-bit words)	:=[-2,0,2,4,6...] 
//			int		PreShift=0,			// Right preshifting by even number of bits		:=[0,2,4...30]
//			bool	UsePostShift=1		// if =0 - Skip result scaling down by 2^19 
//			);							
//
// DESCRIPTION:
//
// Quantization of array of 32-bit signed words.
// Numbers are quntized only by pairs, packed in 64-bit words.
// Numbers placed at odd addresses are quantized by first divisor (Quantizers[0]) and
// numbers placed at even addresses are quantized by second divisor (Quantizers[1]).
// Quantization may be performed by sampling with specified spacing between pairs.
// Results are stored also by pair, packed in 64-bit words.
// The write step of pairs also can be specified.
// By default both steps are equal to 2.
// Operation of this  function may be descibed in next equivalent form:
// for(int i=0,j=0,n=0;n<NumbersOfPairs;n++,i+=SrcReadStep,j+=DstWriteSpep)
// {
//		Dst32bit[j]  =Src32bit[i]  /PairOfQuantizers[0];
//		Dst32bit[j+1]=Src32bit[i+1]/PairOfQuantizers[1];
// }
//
//  RETURN: 0
//
//  PERFORMANCE:
//		The performance of function depends on memory allocation for  
//		input, output  and temporary buffers.
//		For the maximum speed performance it is recommended  
//		to use the following configuration:
//
//		Configuration I:
//			Src32bit		: Local		SRAM
//			Dst32bit		: Global	SRAM
//			TempBuffer1		: Global	SRAM
//			TempBuffer2		: Local		SRAM
//
//			4659 clocks per 1024 int pairs with C++ call (2.27 clocks per 32bit word)
//
//		Configuration II:	
//			Src32bit		: Global	SRAM
//			Dst32bit		: Local		SRAM
//			TempBuffer1		: Local		SRAM
//			TempBuffer2		: Global	SRAM
//
//			4666 clocks per 1024 int pairs with C++ call (2.28 clocks per 32bit word)
//
//		For the others configurations the following results were achieved: 
//
//
//	COMMENTS:
//		The order of intermediate data transmissions in function is:
//			if (UsePostShift!=0)
//			[Local]				[Global]
//			Src32bit[]		==>	TmpBuffer[]			- PreShift, 1/x Multiplying	(in-place is supported only if SrcReadStep=2)
//			Dst32bit[]		<==	TmpBuffer[]			- PostShift (Scaling down)	(in-place is supported only if DstWriteStep==2)
// 
//			if (UsePostShift==0)
//			[Local]				[Global]
//			Src32bit[]		==>	Dst32bit[]			- PreShift, 1/x Multiplying	(in-place is supported only if SrcReadStep=DstWriteStep)
//
//		Consider this sequence to use same buffer pointers and support in-place
//			Examples of some allowable calls:
//				Quant32_By2Int(Src,Dst,64,QuantizerTable,3,Dst,Dst)
//				Quant32_By2Int(Src,Src,64,QuantizerTable,3,Src,Src)
//
//		Note that the using same buffer pointers can reduce function performance.
//
//VEC_Quant_By2Int((int*)G0,(int*)G1,QuantTbl,10240,G2,2,2,2,1);//21196
//VEC_Quant_By2Int((int*)G0,(int*)G1,QuantTbl,10240,L2,2,2,2,1);//11720
//VEC_Quant_By2Int((int*)G0,(int*)L1,QuantTbl,10240,G2,2,2,2,1);//16611
//VEC_Quant_By2Int((int*)G0,(int*)L1,QuantTbl,10240,L2,2,2,2,1);//17055
//VEC_Quant_By2Int((int*)L0,(int*)G1,QuantTbl,10240,G2,2,2,2,1);//16294
//VEC_Quant_By2Int((int*)L0,(int*)G1,QuantTbl,10240,L2,2,2,2,1);//16737
//VEC_Quant_By2Int((int*)L0,(int*)L1,QuantTbl,10240,G2,2,2,2,1);//11731
//VEC_Quant_By2Int((int*)L0,(int*)L1,QuantTbl,10240,L2,2,2,2,1);//22075

//VEC_Quant_By2Int((int*)G0,(int*)G1,QuantTbl,10240,G2,2,2,2,0);//10647
//VEC_Quant_By2Int((int*)G0,(int*)G1,QuantTbl,10240,L2,2,2,2,0);//10670
//VEC_Quant_By2Int((int*)G0,(int*)L1,QuantTbl,10240,G2,2,2,2,0);//6076
//VEC_Quant_By2Int((int*)G0,(int*)L1,QuantTbl,10240,L2,2,2,2,0);//6077
//VEC_Quant_By2Int((int*)L0,(int*)G1,QuantTbl,10240,G2,2,2,2,0);//5755
//VEC_Quant_By2Int((int*)L0,(int*)G1,QuantTbl,10240,L2,2,2,2,0);//5755
//VEC_Quant_By2Int((int*)L0,(int*)L1,QuantTbl,10240,G2,2,2,2,0);//11099
//VEC_Quant_By2Int((int*)L0,(int*)L1,QuantTbl,10240,L2,2,2,2,0);//11091




//<_nmjpegQuant_By2Int__FPiPiPiiPviiib>

global _nmjpegQuant_By2Int:label;
<_nmjpegQuant_By2Int>
 

.branch;

	ar5 = ar7-2;

	push ar0, gr0;
	push ar1, gr1;
	push ar2, gr2;
	push ar3, gr3;
	push ar4, gr4;
	push ar5, gr5;
	push ar6, gr6;

	ar0 = [--ar5];		//			int*	Src32bit,			
	ar6 = [--ar5];		//			int*	Dst32bit,			
	ar1 = [--ar5];		//			int*	PairOfQuantizers,	
	gr5 = [--ar5];		//			int		Count,		
	ar2 = [--ar5];		//			void*	TmpBuffer,			
	gr0 = [--ar5];		//			int		SrcReadStep=2,	
	gr6 = [--ar5];		//			int		DstWriteStep=2,	
	gr4 = [--ar5];		//			int		PreShift=0;
	gr7 = [--ar5];		//			int		UsePostShift=1
	//[vec_long_tmp]=gr7;
	ar5 = ar2;
	[PostShift]=gr7;

	
	//////////////////////////////////////////
	// sb,nb,f1cr,woper Initialization
	gr1=80000000h with gr4;
	nb1=gr1;
	if <>0 delayed goto LoadPreShiftTbl;
		ar4 = vec_w_int_2174Div132;
	///////////////////////////
	// NonPreShift 1/X Table loading
	sb=2			with gr7=false;
	// Lower Quntizer Loading 
	gr2 = [ar1++]	with gr7++;
	ar2 = ar4		with gr2 <<= 2;
	rep 1 wfifo=[ar2+=gr2];
	
	// Hight Quntizer Loading 
	gr2 = [ar1++]	with gr7++;
	ar2 = ar4		with gr2 <<= 2;
	gr2+= gr7;
	rep 1 wfifo=[ar2+=gr2],ftw;
	
	
	delayed goto EndLoadDivTbl;
		nul;
		nul;
	
	///////////////////////////
	// PreShift Table loading
	<LoadPreShiftTbl>

	ar3 = vec_long_0	with gr7=false;
	// Lower Quntizer Loading 
	gr2 = [ar1++]		with gr7++;
	ar2 = ar4			with gr2<<=2;
	rep 1 wfifo=[ar3];
	rep 1 wfifo=[ar2+=gr2];
	// Hight Quntizer Loading 
	gr2 = [ar1++]		with gr7++;
	ar2 = ar4			with gr2 <<= 2;
	gr2+= gr7;
	rep 1 wfifo=[ar3];
	rep 1 wfifo=[ar2+=gr2];


	ar4 = vec_tbl_sb_int_EvenRightShift;
	sb  = [ar4+=gr4];
	ftw;

	<EndLoadDivTbl>
	WTW_REG(gr1);
	
	
	///////////////////////////////////////////////////////////////
	// 1/x multiplication	
	// [Src32bit] => [TmpBuffer] if PostShift!=0
	// [Src32bit] => [DstBuffer] if PostShift==0
	gr7 = [PostShift];
	push ar5,gr5;	//  TmpBuffer
	push ar6,gr6	// gr6 = 64,gr0 =64
		with gr7;
	
	vr=0020000h;
	if =0 delayed goto SkipPostShift with gr5 >>=1;
		nul;
		nul;
	gr6 = 2;
	ar6 = ar5;		//	 ar6 = TempBuffer
	<SkipPostShift>
	//	ar0- src
	//	ar6- dst
	//  gr0- src read step
	//	gr6- dst write step
	//	gr5- count of longs
	//delayed call vec_rep_n_vsum_data_vr;					
	delayed call vec_vsum_data_vr;					
		nul;
		nul;
	pop ar6,gr6;
	pop ar5,gr5;	// TmpBuffer

	//////////////////////////////////////////////////////////////
	// Right shift scaling
	// [TmpBuffer] => [DstBuffer]
	gr7 = [PostShift];
	gr0 = 2 with gr7;
	ar0 = ar5;
	if =0 delayed goto EndArsh32;
		gr3 = 18;



//	VEC_ARSH32_RRRRRR(ar0,ar6,gr5,gr3,gr0,gr6);				


//macro VEC_ARSH32_RRRRRR(rSrc,rDst,rCount,rShift,rReadStep,rWriteStep)
	extern _MTR_ARShift_1Col__FPiiPiiii:label;
	ar5 = sp;
	ar7 += 6;
	[ ar5++ ] = gr3;
	[ ar5++ ] = gr5;
	[ ar5++ ] = gr6;
	[ ar5++ ] = ar6;
	delayed call _MTR_ARShift_1Col__FPiiPiiii;
//void  MTR_ARShift_1Col (nm32s *pSrcMtr, int nSrcColumns, nm32s *pDstMtr, int nDstColumns, int nRows, int nShift) 

		[ ar5++ ] = gr0;
		[ ar5++ ] = ar0;
	nul;
	ar7 -= 6;
//end VEC_ARSH32_RRRRRR;





	<EndArsh32>
	
	pop ar6, gr6;
	pop ar5, gr5;
	pop ar4, gr4;
	pop ar3, gr3;
	pop ar2, gr2;
	pop ar1, gr1;
	pop ar0, gr0;

	return;
.wait;
//-------------------------------------------------------------------
//macro MJPEGQ(arg)
//	delayed goto ar3;
//		rep arg data = [ar0++gr0] with vsum, data, 0;
//		rep arg [ar4++gr4] = afifo;
//		nul;
//end MJPEGQ;
//-------------------------------------------------------------------
//local JPEGQuant_By2Int: label;
//<JPEGQuant_By2Int>
//.branch;
//	ar5 = ar7 - 2;
//	
//	push ar0, gr0;
//	push ar1, gr1;
//	push ar2, gr2;
//	push ar3, gr3;
//	push ar4, gr4;
//	push ar5, gr5;
//	push ar6, gr6;
//
//	nb1 = 80000000h;
//	sb = 2h;
//	ar1 = _QuantTable;
//	rep 32 wfifo = [ar1++], ftw;
//	WTW();
//
//	gr1 = 15;
//<lab_Q2I_1>
//	
//<lab_Q2I_2>
//	if > delayed goto lab_Q2I_2 with gr2--;
//		rep 32 data = [ar0++gr0] with vsum, data, 0;
//		rep 32 [ar4++gr4] = afifo;
//
//	rep 32 data = [ar0++gr0], ftw with vsum, data, 0;
//	rep 32 [ar4++gr4] = afifo;
//	
//	gr1--;	
//	if > delayed goto lab_Q2I_1;
//		WTW(gr5);
//
//	rep 32 wfifo = [ar1++], ftw;
//	WTW();
//
//
//	
//	
//	
//	
//	
//	gr5 = 16;
//<lab_Q2I_3>
//	
//<lab_Q2I_4>
//	if > delayed goto lab_Q2I_4 with gr7--;
//		rep 32 data = [ar0++gr0] with vsum, data, 0;
//		rep 32 [ar4++gr4] = afifo;
//
//	gr5--;	
//	if > delayed goto lab_Q2I_3;
//		nul;
//		nul;
//
//	pop ar6, gr6;
//	pop ar5, gr5;
//	pop ar4, gr4;
//	pop ar3, gr3;
//	pop ar2, gr2;
//	pop ar1, gr1;
//	pop ar0, gr0;
//
//	return;
//
//<lab_MJPEGQ>
//	MJPEGQ(1);
//	MJPEGQ(2);
//	MJPEGQ(3);
//	MJPEGQ(4);
//	MJPEGQ(5);
//	MJPEGQ(6);
//	MJPEGQ(7);
//	MJPEGQ(8);
//	MJPEGQ(9);
//	MJPEGQ(10);
//	MJPEGQ(11);
//	MJPEGQ(12);
//	MJPEGQ(13);
//	MJPEGQ(14);
//	MJPEGQ(15);
//	MJPEGQ(16);
//	MJPEGQ(17);
//	MJPEGQ(18);
//	MJPEGQ(19);
//	MJPEGQ(20);
//	MJPEGQ(21);
//	MJPEGQ(22);
//	MJPEGQ(23);
//	MJPEGQ(24);
//	MJPEGQ(25);
//	MJPEGQ(26);
//	MJPEGQ(27);
//	MJPEGQ(28);
//	MJPEGQ(29);
//	MJPEGQ(30);
//	MJPEGQ(31);
//	MJPEGQ(32);
//
//.wait;
//-------------------------------------------------------------------

//<JPEGQuant>
//.branch;
//	ar5 = ar7 - 2;
//	
//	push ar0, gr0;
//	push ar1, gr1;
//	push ar2, gr2;
//	push ar3, gr3;
//	push ar4, gr4;
//	push ar5, gr5;
//	push ar6, gr6;
//
//		
//
//	pop ar6, gr6;
//	pop ar5, gr5;
//	pop ar4, gr4;
//	pop ar3, gr3;
//	pop ar2, gr2;
//	pop ar1, gr1;
//	pop ar0, gr0;
//
//	return;
//.wait;
//-------------------------------------------------------------------
end ".text_jpeg";
