//-------------------------------------------------------------------
//    RC Module Inc., Moscow, Russia                                |
//    NeuroMatrix(r) NM6403 Software                                |
//                                                                  |
//    JPEG Library                                                  |
//    (C-callable functions)                                        |
//                                                                  |
//    File:             CountDiff.asm                               |
//    Contents:         Routines for perform JPEGRLE coding and     |
//                      getting variable length codes (VLC) from    |
//	 				    Haffman tables (standard JPEG)              |
//                                                                  |
//    Software design:  S.Landyshev                                 |
//                                                                  |
//    Version           1.1                                         |
//    Start date:       -09.09.2001                                 |
//    $Revision: 1.1 $    $Date: 2005/02/10 12:36:37 $                   |
//                                                                  |
//                                                                  |
//-------------------------------------------------------------------
//-------------------------------------------------------------------
data ".data_jpeg"
	w_CountDIFF:	long[2] = (01ffhl, 0hl);
	m_CountDIFF:	long = 0ffhl;
	m_InsertDIFF:	long = 0ffffffff00000000hl;
end ".data_jpeg";
//-------------------------------------------------------------------
begin ".text_jpeg"
//-------------------------------------------------------------------
//	FUNCTION: 
//		CountDIFF.
//
//	DESCRIPTION:
//		C/C++ callable function.
//		Count DIFF for DC-koeff. 
//
//	void CountDIFF(
//		int*	piSrc,
//		long*	piDst,
//		int		iSize	//Size of source buffer in int. iSize = 256*N.
//		); 
//-------------------------------------------------------------------


global _nmjpegAUX_CountDIFF :label;
<_nmjpegAUX_CountDIFF>
.branch;
	ar5 = ar7 - 2;
	push ar0, gr0 with gr0 = false;
	push ar1, gr1 with gr0++;
	push ar4, gr4 with gr4 = gr0 << 1;
	push ar5, gr5;
	push ar6, gr6 with gr1 = gr0 << 9; 
	ar0 = [--ar5] with gr1--;
	ar4 = [--ar5] with gr0 <<= 6;
	gr7 = [--ar5] with gr5 = false;
	gr6 = [ar0++gr0] with gr7 >>= 6;
<lab_CountDIFF_1>
	gr6 A>>= 18;
	gr5 = gr6 with gr6 -= gr5;
    gr7--;
	if > delayed goto lab_CountDIFF_1 with gr6 = gr6 and gr1;
		[ar4++gr4] = gr6;
		gr6 = [ar0++gr0];
	pop ar6, gr6;
	pop ar5, gr5;
	pop ar4, gr4;
	pop ar1, gr1;
	pop ar0, gr0;
	return;
.wait;
//.branch;
//	ar5 = ar7 - 2 with gr0 = false;
//	push ar0, gr0 with gr0++;
//	push ar1, gr1 with gr0 <<= 6;
//	push ar4, gr4 with gr1 = gr0;
//	ar0 = [--ar5];
//	ar4 = [--ar5];
//	gr4 = [--ar5];
//	gr7 = [ar0] with gr4 >>= 6;
//	[ar4] = gr7 with gr4--;
//	ar4 += 2;
//	gr5 = 80000100h;
//	nb1 = gr5;
//	sb = 2;
//	ar5 = w_CountDIFF;
//	rep 2 wfifo = [ar5++], ftw;
//	ar5 = m_CountDIFF;
//	ar1 = ar0 + gr0 with gr7 = gr4 >> 5;
//	if <= delayed goto lab_CountDIFF_2 with gr7--;
//		WTW(gr5);
//	rep 32 ram = [ar5];
//<lab_CountDIFF_1>
//	rep 32 data = [ar1++gr1] with mask ram, data, 0;
//	if > delayed goto lab_CountDIFF_1 with gr7--; 
//		rep 32 data = [ar0++gr0] with vsum, data, afifo;
//		rep 32 [ar4++] = afifo;
//<lab_CountDIFF_2>
//	gr7 = gr4 << 27;
//	gr7 >>= 29;
//	if =0 delayed goto lab_CountDIFF_4 with gr7--;
//		rep 4 ram = [ar5];
//		nul;
//
//<lab_CountDIFF_3>
//	rep 4 data = [ar1++gr1] with mask ram, data, 0;
//	if > delayed goto lab_CountDIFF_3 with gr7--; 
//		rep 4 data = [ar0++gr0] with vsum, data, afifo;
//		rep 4 [ar4++] = afifo;
//
//<lab_CountDIFF_4>
//	rep 3 ram = [ar5];
//	rep 3 data = [ar1++gr1] with mask ram, data, 0;
//	rep 3 data = [ar0++gr0] with vsum, data, afifo;
//	rep 3 [ar4++] = afifo;
//
//	pop ar4, gr4;
//	pop ar1, gr1;
//	pop ar0, gr0;
//	return;
//.wait;
//-------------------------------------------------------------------
//	FUNCTION: 
//		InsertDIFF.
//
//	DESCRIPTION:
//		C/C++ callable function.
//		Insert DIFFs into buffer. Each DIFF occupy first place in the block.
//
//	void InsertDIFF(
//		long*	piSrc,	//long Local[iSize/2].
//		int*	piDst,	//long Global[iSize*32].
//		int		iSize	//Quantity of DIFFs.	iSize = 4*N.
//		); 
//	
//	InsertDIFF(Local, Global, 512)	= 1221 ticks.
//	InsertDIFF(Global, Local, 512)	= 1253 ticks.
//	InsretDIFF(Local, Local, 512)	= 1735 ticks.
//	InsertDIFF(Global, Global, 512)	= 1669 ticks.
//-------------------------------------------------------------------



global _nmjpegAUX_InsertDIFF :label;
<_nmjpegAUX_InsertDIFF>
.branch;
	ar5 = ar7 - 2;
	push ar0, gr0 with gr7 = false;
	push ar4, gr4 with gr4 = gr7 + 1;
	push ar6, gr6 with gr4 <<= 6;
	ar0 = [--ar5] with gr6 = gr4;
	ar4 = [--ar5];
	gr0 = [--ar5];
	ar6 = ar4 with gr7 = gr0 >> 5;
	if =0 delayed goto lab_InsertDIFF_2 with gr7--;
		ar5 = m_InsertDIFF;
	rep 32 ram = [ar5];	
<lab_InsertDIFF_1>
	rep 32 data = [ar0++] with data; 
	if > delayed goto lab_InsertDIFF_1 with gr7--;
		rep 32 data = [ar4++gr4] with mask ram, data, afifo;
		rep 32 [ar6++gr6] = afifo;
<lab_InsertDIFF_2>
	gr7 = gr0 << 27;
	if =0 delayed goto lab_InsertDIFF_4 with gr7 >>= 29;
		rep 4 ram = [ar5];
		gr7--;
<lab_InsertDIFF_3>
	rep 4 data = [ar0++] with data; 
	if > delayed goto lab_InsertDIFF_3 with gr7--;
		rep 4 data = [ar4++gr4] with mask ram, data, afifo;
		rep 4 [ar6++gr6] = afifo;
<lab_InsertDIFF_4>
	pop ar6, gr6;
	pop ar4, gr4;
	pop ar0, gr0;
	return;
.wait;
//-------------------------------------------------------------------
end ".text_jpeg";
//-------------------------------------------------------------------
//		END OF FILE CountDiff.asm                                     |
//-------------------------------------------------------------------                                                  
//-------------------------------------------------------------------                                                  
