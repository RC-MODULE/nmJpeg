//-------------------------------------------------------------------
//    RC Module Inc., Moscow, Russia                                |
//    NeuroMatrix(r) NM6403 Software                                |
//                                                                  |
//    JPEG Library                                                  |
//    (C-callable functions)                                        |
//                                                                  |
//    File:             JPEGRLE.asm                                 |
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
local lab_JPEGRLE_Core_7:		label;
//-------------------------------------------------------------------
data ".data_jpeg"
	w_Convert32_1_Core:	long[32] = (
		0000000000000001hl, 0000000000000002hl,
		0000000000000004hl, 0000000000000008hl,
		0000000000000010hl, 0000000000000020hl,
		0000000000000040hl, 0000000000000080hl,
		0000000000000100hl, 0000000000000200hl,
		0000000000000400hl, 0000000000000800hl,
		0000000000001000hl, 0000000000002000hl,
		0000000000004000hl, 0000000000008000hl,
		0000000000010000hl, 0000000000020000hl,
		0000000000040000hl, 0000000000080000hl,
		0000000000100000hl, 0000000000200000hl,
		0000000000400000hl, 0000000000800000hl,
		0000000001000000hl, 0000000002000000hl,
		0000000004000000hl, 0000000008000000hl,
		0000000010000000hl, 0000000020000000hl,
		0000000040000000hl, 0000000080000000hl);
end ".data_jpeg";
//-------------------------------------------------------------------
//-------------------------------------------------------------------
macro MRLE1(g1, g2)
own lab_MRLE1_1:	label;
	if =0 delayed goto lab_MRLE1_1 with gr3++;
		g2 = [ar1++];
		g2;
	gr4 = g1 << 4;
	ar3 = ar2 with gr3 += gr4;
	gr4 = [ar3+=gr3] with gr3 = true;
	[ar4++] = gr4 with g2;
<lab_MRLE1_1>
end MRLE1;
//-------------------------------------------------------------------
macro MRLE2(g1, g2)
own lab_MRLE2_1:	label;
own lab_MRLE2_2:	label;
	if =0 delayed goto lab_MRLE2_2 with gr3++;
		g2 = [ar1++];
		g2;
	ar5 = ar2 with gr5 = gr3;
	gr3 -= gr0;
	if < delayed goto lab_MRLE2_1;
		gr4 = g1 << 4;	
		gr5 += gr4;
	gr5 = 0ff20000bh;			//ZRL code.
	[ar4++] = gr5 with gr5 = gr4 + gr3;
<lab_MRLE2_1>
	gr5 = [ar5+=gr5] with gr3 = true;
	[ar4++] = gr5 with g2;
<lab_MRLE2_2>
end MRLE2; 
//-------------------------------------------------------------------
macro MRLE3(g1, g2)
own lab_MRLE3_1:	label;
own lab_MRLE3_2:	label;
	if =0 delayed goto lab_MRLE3_2 with gr3++;
		g2 = [ar1++] with gr6 >>= 1;
		g2;
	ar5 = ar2 with gr5 = gr3;
	gr3 -= gr0;
	if < delayed goto lab_MRLE3_1 with gr4 = g1 << 4;
		gr5 += gr4;
		gr6;
	g1 = 0ff20000bh with gr3 - gr0;			//ZRL code.
	if < delayed goto lab_MRLE3_1 with gr5 = gr4 + gr3;
		[ar4++] = g1 with gr3 -= gr0;
		gr6;
	[ar4++] = g1 with gr5 = gr4 + gr3 noflags;
<lab_MRLE3_1>
	if =0 delayed goto lab_JPEGRLE_Core_7;
		gr5 = [ar5+=gr5] with gr3 = true;
		[ar4++] = gr5 with g2;
<lab_MRLE3_2>
end MRLE3;
//-------------------------------------------------------------------
macro MRLE4(g1, g2)
own lab_MRLE4_1:	label;
own lab_MRLE4_2:	label;
	if =0 delayed goto lab_MRLE4_2 with gr3++;	
		g2 = [ar1++] with gr6 >>= 1;
		g2;
	ar5 = ar2 with gr5 = gr3;
	gr3 -= gr0;
	if < delayed goto lab_MRLE4_1 with gr4 = g1 << 4;
		gr5 += gr4;
		gr6;
	g1 = 0ff20000bh with gr3 - gr0;			//ZRL code.
	if < delayed goto lab_MRLE4_1 with gr5 = gr4 + gr3;
		[ar4++] = g1 with gr3 -= gr0;
		gr6;
	gr3 - gr0;
	if < delayed goto lab_MRLE4_1 with gr5 = gr4 + gr3;
		[ar4++] = g1 with gr3 -= gr0;
		gr6;
	[ar4++] = g1 with gr5 = gr4 + gr3 noflags;
<lab_MRLE4_1>
	if =0 delayed goto lab_JPEGRLE_Core_7;
		gr5 = [ar5+=gr5] with gr3 = true;
		[ar4++] = gr5 with g2;	
<lab_MRLE4_2>
end MRLE4;
//-------------------------------------------------------------------
begin ".text_jpeg"
//-------------------------------------------------------------------
//	FUNCTION: 
//		Convert32_1_Core.
//
//	DESCRIPTION:
//		Function is  called from assembler code only.		 
//		Compress words to bits. In this version processing
//		second half of block only.
//
//		ar0 - input buffer		:long Local[size/2].
//		ar6 - output buffer		:long Global[size/64].	
//		gr0 - size of input buffer in int (size = 2048,..,n*2048).
//-------------------------------------------------------------------
local Convert32_1_Core: label;
<Convert32_1_Core>
.branch; 
	ar5 = w_Convert32_1_Core;
	gr5 = 0ffffffffh;
	nb1 = gr5;			//64 cols.
	sb = 2;				//2 rows.
	push ar4, gr4 with gr4 = gr0 << 21;	//gr4 - counter.
	if =0 delayed goto lab_Convert32_1_Core_0 with gr4 = gr0 >> 11;
		push ar0, gr0 with gr0 = false;
		push ar6, gr6 with gr0++;
	gr4++;
<lab_Convert32_1_Core_0>
	ar4 = ar5 with gr0 <<= 5;			//gr0 = 32.
	rep 32 wfifo = [ar4++], ftw;
	ar0+=gr0 with gr0 <<= 1;			//gr0 = 64.
	f1cr = 0fffffffeh;
	ar4 = ar5 with gr4--;
	nb1=gr5;
	if =0 delayed goto lab_Convert32_1_Core_2 with gr4--;
		wtw;
		nul;
<lab_Convert32_1_Core_1>
	rep 32 data = [ar0++gr0], ftw,wtw with vsum, activate data, 0;
	//WTW(gr5);
	ar0-=2046;	//return to next vector.
.repeat 14;
	rep 32 data = [ar0++gr0], ftw,wtw with vsum, activate data, afifo;
	//WTW(gr5);
	ar0-=2046;	//return to next vector.
.endrepeat;
	rep 32 wfifo = [ar4++], ftw;
	rep 32 data = [ar0++gr0],wtw with vsum, activate data, afifo;
	//WTW(gr5);
	ar0-=30;	//next 32 blocks.
	if > delayed goto lab_Convert32_1_Core_1 with gr4--;
		ar4 = ar5;
		rep 32 [ar6++] = afifo;
<lab_Convert32_1_Core_2>
	rep 32 data = [ar0++gr0], ftw,wtw with vsum, activate data, 0;
	//WTW(gr5);
	ar0-=2046;
.repeat 14;
	rep 32 data = [ar0++gr0], ftw,wtw with vsum, activate data, afifo;
	//WTW(gr5);
	ar0-=2046;
.endrepeat;
	rep 32 data = [ar0++gr0] with vsum, activate data, afifo;
	rep 32 [ar6++] = afifo;
	pop ar6, gr6;
	pop ar0, gr0;
	pop ar4, gr4;
	return;
.wait;
//-------------------------------------------------------------------
//	FUNCTION:                                                       
//		JPEGRLE_Core.                                               
//                                                                  
//	DESCRIPTION:                                                    
//		Function is  called from assembler code only.		        
//		Count of RUN and LEVEL according JPEG standard              
//		and substitute each pair by codes from tables.              
//                                                                  
//		ar0 - input buffer		:int Any[size].
//		ar4 - output buffer.	:int Any[size].
//		gr0 - size of input buffer in int	:size = 64,..,n*64.
//      ar2 - AC table.
//      ar3 - DC table.
//		gr7 - size of result in int.
//		ar6 - Checking vectors. :long Any[size/64];
//	Output data format: 
//		bits 0..4 - length of code, bits 5..32 - codes;	
//-------------------------------------------------------------------
local JPEGRLE_Core: label; 
<JPEGRLE_Core>
.branch;
    push ar4, gr4 with gr3 = gr0 >> 6;	//gr3 - counter.
	gr0 = false;
	gr0++;
	ar1 = ar0 with gr0 <<= 4;	//gr0 = 16.
	push ar3, gr3 with gr7 = gr0 >> 2;	//Store DC table and counter.
<lab_JPEGRLE_Core_1>
	gr3 = [ar1++];	//Read DIFF.			
	gr1 = [ar1++];	//Read first AC.
	gr3 = [ar3+=gr3] with gr1;	//Read DIFF-code from DC table.
	[ar4++] = gr3 with gr3 = true noflags;	//Write Diff-code.

//Begin processing AC-koef.	
.repeat 8;
	MRLE1(gr1, gr2);
	MRLE1(gr2, gr1);
.endrepeat;

.repeat 7;
	MRLE2(gr1, gr2);	//RUN maybe equal 16. Begin checking ZRL.	
	MRLE2(gr2, gr1);
.endrepeat;

//Begin check checking vector.
	if =0 delayed goto lab_JPEGRLE_Core_3 with gr3++;
		gr6 = [ar6++];
		gr6;
	ar5 = ar2 with gr5 = gr3;
	gr3 -= gr0;
	if < delayed goto lab_JPEGRLE_Core_2;
		gr4 = gr1 << 4;	
		gr5 += gr4;
	gr5 = 0ff20000bh;			//ZRL code.
	[ar4++] = gr5 with gr5 = gr4 + gr3;
<lab_JPEGRLE_Core_2>
	gr5 = [ar5+=gr5] with gr3 = true;
	[ar4++] = gr5 with gr6;
<lab_JPEGRLE_Core_3>
	if =0 delayed goto lab_JPEGRLE_Core_7;
		gr2 = [ar1++];
		gr2;
	if =0 delayed goto lab_JPEGRLE_Core_5 with gr3++; 
		gr1 = [ar1++] with gr6 >>= 1;		//Begin shift shecking vector.
		gr1;
	ar5 = ar2 with gr5 = gr3;
	gr3 -= gr0;
	if < delayed goto lab_JPEGRLE_Core_4 with gr4 = gr2 << 4;
		gr5 += gr4;
		gr6;
	gr5 = 0ff20000bh;			//ZRL code.
	[ar4++] = gr5 with gr5 = gr4 + gr3 noflags;
<lab_JPEGRLE_Core_4>
	if =0 delayed goto lab_JPEGRLE_Core_7;
		gr5 = [ar5+=gr5] with gr3 = true;
		[ar4++] = gr5 with gr1;
<lab_JPEGRLE_Core_5>
.repeat 8;
	MRLE3(gr1, gr2);	//RUN maybe equal 32.
	MRLE3(gr2, gr1);
.endrepeat;

.repeat 7;
	MRLE4(gr1, gr2);	//RUN maybe equal 48.
	MRLE4(gr2, gr1);
.endrepeat;

	if =0 goto lab_JPEGRLE_Core_7 with gr3++;
	ar5 = ar2 with gr5 = gr3;
	gr3 -= gr0;
	if < delayed goto lab_JPEGRLE_Core_6 with gr4 = gr1 << 4;
		gr5 += gr4;
		gr6;
	gr1 = 0ff20000bh;			//ZRL code.
	gr3 - gr0;
	if < delayed goto lab_JPEGRLE_Core_6 with gr5 = gr4 + gr3;
		[ar4++] = gr1 with gr3 -= gr0;
		gr6;
	gr3 - gr0;
	if < delayed goto lab_JPEGRLE_Core_6 with gr5 = gr4 + gr3;
		[ar4++] = gr1 with gr3-= gr0;
		gr6;
	[ar4++] = gr1 with gr5 = gr4 + gr3;
<lab_JPEGRLE_Core_6>
	delayed goto lab_JPEGRLE_Core_8;
		gr5 = [ar5+=gr5];
		[ar4++] = gr5;	
<lab_JPEGRLE_Core_7>
	gr6 = 0a0000004h;	//EOB code.
	[ar4++] = gr6;
<lab_JPEGRLE_Core_8>
	ar6++ with gr7--;
	if > delayed goto lab_JPEGRLE_Core_9 with gr1 = gr0 >> 1;	//gr1 =8;
		pop ar3, gr3 with gr0 <<= 2;	//gr0 = 64.
		ar0+=gr0 with gr3--;	
	[ar4++] = gr1;				
	gr7 = 4;
<lab_JPEGRLE_Core_9>
	if > delayed goto lab_JPEGRLE_Core_1 with gr0 >>= 2;	//gr0 = 16.
		push ar3, gr3;
		ar1 = ar0;
	pop ar3, gr3;
    gr7 = ar4;
    pop ar4, gr4;
    gr5 = ar4;
    gr7 -= gr5;
	return;
.wait;
//-------------------------------------------------------------------
//	FUNCTION: 
//		JPEGRLE.
//
//	DESCRIPTION:
//		C/C++ callable version of function JPEGRLE_Core.
//		Calculate of RUN and LEVEL according JPEG standard 
//		and substitute each pair by codes from tables.
//	int JPEGRLE(
//		int*	src,		//Input buffer,	:int Local[size].
//		int*	dst,		//Output buffer.:int Global[size].
//		int		size,		//Size of input buffer in int (size = 2048,..,n*2048).
//		int&	resSize,	//Size of output data in int.
//		long*	tmp			//Temporary buffer.	:long Global[size/64].
//		);	 
//	Output data format:
//		bits 0..4 - length of code, bits 5..32 - codes;
//	For these configuration the following results were achieved:
//	(weight matrix in local) 
//	Configuration 1: JPEGRLE(L, G, 32768, res, 0xff, L, L, L)
//		144703 ticks with C++ call.
//	Configuration 2: JPEGRLE(L, G, 32768, res, 0xff, L, L, G)
//		145152 ticks with C++ call.
//	Configuration 3: JPEGRLE(L, L, 32768, res, 0xff, L, L, L)
//		165954 ticks with C++ call.
//	Configuration 4: JPEGRLE(L, L, 32768, res, 0xff, L, L, G)
//		165452 ticks with C++ call.
//	Configuration 5: JPEGRLE(G, G, 32768, res, 0xff, L, L, L)
//		159940 ticks with C++ call.
//	Configuration 6: JPEGRLE(G, G, 32768, res, 0xff, L, L, G)
//		160389 ticks with C++ call.
//	Configuration 7: JPEGRLE(G, L, 32768, res, 0xff, L, L, L)
//		148614 ticks with C++ call.
//	Configuration 8: JPEGRLE(G, L, 32768, res, 0xff, L, L, G)
//		148112 ticks with C++ call.
//-------------------------------------------------------------------


global _nmjpegAUX_RLE:label;
<_nmjpegAUX_RLE>
	ar5 = ar7 - 2;
	push ar0, gr0;
	push ar1, gr1;
	push ar2, gr2;
	push ar3, gr3;
	push ar4, gr4;
    push ar5, gr5;
	push ar6, gr6;
	ar0 = [--ar5];		// Input buffer.		:int Local[size].
	ar4 = [--ar5];		// Output buffer.	:int Global[size].
    gr0 = [--ar5];		// Size of input buffer in int.
    ar3 = [--ar5];      // DC table.
    delayed call Convert32_1_Core;
        ar2 = [--ar5];      // AC table.
	    ar6 = [--ar5];	    //Temporary buffer.	:long Global[size/64].
	call JPEGRLE_Core;
	pop ar6, gr6;
    pop ar5, gr5;
	pop ar4, gr4;
	pop ar3, gr3;
	pop ar2, gr2;
	pop ar1, gr1;
	pop ar0, gr0;
	return;
//-------------------------------------------------------------------
end ".text_jpeg";
//-------------------------------------------------------------------
//		END OF FILE JPEGRLE.asm                                     |
//-------------------------------------------------------------------