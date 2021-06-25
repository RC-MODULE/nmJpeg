//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             MarkFF.asm                                          */
//*   Contents:         Routine to insert 0 word after                      */
//*						0x000000ff word                                     */
//*                                                                         */
//*   Software design:  S.Landyshev                                         */
//*                                                                         */
//*   Version           1.1                                                 */
//*   Start date:       -09.09.2001                                         */
//*   $Revision: 1.1 $    $Date: 2005/02/10 12:36:37 $                           */
//***************************************************************************/
//extern	_VEC_BoolCnv32to1__FPiPUiii:	label;
//extern _VEC_CmpEq0__FPUi3nm1Pii:	label;
extern _nmppsCmpEq0_32u31b:	label;
       
local	lab_GMBBV_3:					label;
//--------------------------------------------------------------------
data ".data_jpeg"
	entry_Y:	long = 0000000100000001hl;
end ".data_jpeg";
//--------------------------------------------------------------------
macro ADD_ITERATION(arg)
	delayed goto ar2;
		rep arg ram = [ar3];
		rep arg data = [ar1++] with data + ram;
		rep arg [ar5++] = afifo;
end ADD_ITERATION;
//--------------------------------------------------------------------
begin ".text_jpeg"
//********************************************************************
//	FUNCTION: 
//		GetMarkerBytesBitVectors.
//
//	DESCRIPTION:
//		C/C++ callable function. Generate bit vector.
//	void GetMarkerBytesBitVectors(
//		int				*src,		//Input data.		:long Local[size/2].
//		unsigned int	*bitVector,	//Output vectors.	:long Local[size/64];
//		int				size,		//Input buffer size in int (size = 1, 2, 3, .., n).
//		void			*tmp		//Temporary buffer.	:long Global[(size+1)/2].
//		);		
//	For these configuration the following results were achieved: 
//********************************************************************


global _nmjpegAUX_GetFFVectors:label;
<_nmjpegAUX_GetFFVectors>
.branch;
	nb1 = 80000080h;
	ar5 = entry_Y;
	rep 32 ram = [ar5], wtw;
	ar5 = ar7 - 2;
	push ar5, gr5; 
	push ar0, gr0 with gr7 = true;
	push ar1, gr1 with gr7 >>= 27;
	push ar2, gr2 with gr7 <<= 2;		
	push ar3, gr3 with gr5 = false;
	push ar4, gr4 with gr5++;			
	push ar6, gr6 with gr5++;
	ar0 = [--ar5];						//ar0 - source.
	ar4 = [--ar5];						//ar4 - dst.
	gr4 = [--ar5];						//gr4 - source size.
	ar6 = [--ar5] with gr0 = gr4 << 31;	//ar6 - temporary buffer.
	if =0 goto lab_GMBBY_1 with gr0 = gr4;
	gr0 = gr4 + 1;
<lab_GMBBY_1>
	gr2 = gr0 << 1;	
	ar3 = entry_Y with gr1 = gr0 >> 6;
	if =0 delayed goto lab_GMBBV_2 with gr2 = gr2 and gr7;
		ar5 = ar6 with gr2 += gr5;
		ar1 = ar0 with gr1--;
<lab_GMBBV_1>
	if > delayed goto lab_GMBBV_1 with gr1--;
		rep 32 data = [ar1++] with data + ram;
		rep 32 [ar5++] = afifo;
<lab_GMBBV_2>
	delayed skip gr2;
		ar2 = lab_GMBBV_3;
		nul;
	goto ar2;
	ADD_ITERATION(1);
	ADD_ITERATION(2);
	ADD_ITERATION(3);
	ADD_ITERATION(4);
	ADD_ITERATION(5);
	ADD_ITERATION(6);
	ADD_ITERATION(7);
	ADD_ITERATION(8);
	ADD_ITERATION(9);
	ADD_ITERATION(10);
	ADD_ITERATION(11);
	ADD_ITERATION(12);
	ADD_ITERATION(13);
	ADD_ITERATION(14);
	ADD_ITERATION(15);
	ADD_ITERATION(16);
	ADD_ITERATION(17);
	ADD_ITERATION(18);
	ADD_ITERATION(19);
	ADD_ITERATION(20);
	ADD_ITERATION(21);
	ADD_ITERATION(22);
	ADD_ITERATION(23);
	ADD_ITERATION(24);
	ADD_ITERATION(25);
	ADD_ITERATION(26);
	ADD_ITERATION(27);
	ADD_ITERATION(28);
	ADD_ITERATION(29);
	ADD_ITERATION(30);
	ADD_ITERATION(31);
<lab_GMBBV_3>
	gr4 = ar6;// with gr3 = false;
	ar0 = 0;//gr3;
	push ar0, gr0;
	push ar4, gr4;	
	call _nmppsCmpEq0_32u31b;
	nul;
	ar7 -= 4;
	pop ar6, gr6;
	pop ar4, gr4;
	pop ar3, gr3;
	pop ar2, gr2;
	pop ar1, gr1;
	pop ar0, gr0;
	pop ar5, gr5;
	return;
.wait;
//////////////////////////////////////////////////////////////////////
//********************************************************************
//	FUNCTION: 
//		CheckMarkerByte.
//
//	DESCRIPTION:
//		C/C++ callable function. Insert 0 word after 0xff words.
//	void CheckMarkerByte(
//		 int	*src,		//Input buffer.			:long Global[inSize/2].
//		int			*dst,		//Output buffer.		:long Local[(outSize+1)/2].
//		int			*bitVector	//Bit vector.			:long Local[inSize/64+1];
//		int			inSize,		//Input buffer size in int.
//		int			&outSize,	//Output buffer size in int. outSize >= isSize.
//		);
//	For these configuration the following results were achieved: 
//	Configuration 1: CheckMarkerByte()
//	Configuration 2. CheckMarkerByte()	 
//********************************************************************


//<_nmjpegAUX_CheckMarkerByte__FPiPiiPUi>

global _nmjpegAUX_CheckMarkerByte:	label;
	  <_nmjpegAUX_CheckMarkerByte>

.branch;
	ar5 = ar7 - 2;
	push ar0, gr0;
	push ar1, gr1;
	push ar2, gr2;
	push ar3, gr3;
	push ar4, gr4;
	push ar5, gr5 with gr5 = false;
	push ar6, gr6;
	ar0 = [--ar5];						//Input buffer.
	ar4 = [--ar5];						//Output buffer.
	gr0 = [--ar5];						//Size of input buffer in bytes.
	ar1 = [--ar5];						//Bit vector.
	gr7 = gr0 with gr2 = gr0 >> 5;
<lab_CMB_1> 
	if =0 delayed goto lab_CMB_100;
		gr1 = [ar1++];
		gr1;
	if =0 delayed goto lab_CMB_2;
		gr4 = ar4;
		gr4 <<= 31;

.repeat 15;
	gr4 = [ar0++] with gr1 >>= 1;
	[ar4++] = gr4 with gr4 = gr5 + carry;
	[ar4++gr4] = gr5 with gr7 += gr4;
	gr4 = [ar0++] with gr1 >>= 1;
	[ar4++] = gr4 with gr4 = gr5 + carry;
	[ar4++gr4] = gr5 with gr7 += gr4;
.endrepeat;
	gr4 = [ar0++] with gr1 >>= 1;
	[ar4++] = gr4 with gr4 = gr5 + carry;
	[ar4++gr4] = gr5 with gr7 += gr4;
	gr1 = [ar0++] with gr1 >>= 1;
	delayed goto lab_CMB_1 with gr4 = gr5 + carry;
		[ar4++] = gr1 with gr2--;
		[ar4++gr4] = gr5 with gr7 += gr4 noflags;
<lab_CMB_2>
	if =0 delayed goto lab_CMB_3;
		nul;
		nul;
.repeat 7;
	ar6, gr6 = [ar0++];
	[ar4++] = ar6;
	[ar4++] = gr6;
	ar6, gr6 = [ar0++];
	[ar4++] = ar6;
	[ar4++] = gr6;
.endrepeat;
	ar6, gr6 = [ar0++];
	[ar4++] = ar6;
	[ar4++] = gr6;
	ar6, gr6 = [ar0++];
	delayed goto lab_CMB_1 with gr2--;
		[ar4++] = ar6;
		[ar4++] = gr6;
<lab_CMB_3>
	delayed goto lab_CMB_1 with gr2--;
		rep 16 data = [ar0++] with data;
		rep 16 [ar4++] = afifo;
<lab_CMB_100>
	gr6 = gr0 << 27;
	if =0 delayed goto lab_CMB_200 with gr6 >>= 27;
		nul;
		nul;
<lab_CMB_101>
	gr4 = [ar0++];
	[ar4++] = gr4 with gr6--;
	if > delayed goto lab_CMB_101 with gr1 >>= 1; 
		gr4 = gr5 + carry;
		[ar4++gr4] = gr5 with gr7 += gr4;
<lab_CMB_200>
	pop ar6, gr6;
	pop ar5, gr5;
	pop ar4, gr4;
	pop ar3, gr3;
	pop ar2, gr2;
	pop ar1, gr1;
	pop ar0, gr0;
	return;
.wait;
end ".text_jpeg";
//********************************************************************
//		END OF FILE MarkFF.asm
//********************************************************************