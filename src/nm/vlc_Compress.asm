//-------------------------------------------------------------------
//                  RC Module Inc., Moscow, Russia                  
//                  NeuroMatrix(r) NM6403 Software                  
//                                                                                                          
//                  FILE:VLC.asm                                    
//                                                                  
//      CONTENTS:   Routines for press and catanation               
//                  variable length codes (VLC)                      
//      SOFTWARE DESIGN:  S.Landyshev                               
//      VERSION:    1.0                                             
//      START DATE:	05.09.2001                                      
//      LAST UPDATE: 06.09.2001                                     
//-------------------------------------------------------------------
extern vec_vsum_data_0:             label;
extern _VEC_TBL_Triangle_G:         word;
local lab_Shift:                    label;
local lab_VLCC_2:                   label;
//-------------------------------------------------------------------
macro SHIFT(s1, s2)
	delayed goto ar3 with gr2 = gr3 << s1;
		gr3 >>= s2;
		gr1 and not gr6;
		nul;
end SHIFT;
//-------------------------------------------------------------------
begin ".text_jpeg"
TranspositionBytes: long[8] = (
	0000000001000000hl, 0000000000010000hl,
	0000000000000100hl, 0000000000000001hl,
	0100000000000000hl, 0001000000000000hl,
	0000010000000000hl, 0000000100000000hl);
Reserve: long;
Mask: long;
Offs: word;
//-------------------------------------------------------------------
//! \fn int VLC_Compress(unsigned int* src, unsigned int* dst, int qCodes, int offs, int& resBits, unsigned int* tmp)
//!
//! \perfinclude _VLC_Compress__FPUiPUiiiRiPUi.html
//-------------------------------------------------------------------
//	FUNCTION: 
//		VLC_Compress.
//
//	DESCRIPTION:
//		C/C++ callable version of function VLC_Compress_core.
//	int COD_VLC_Compress(
//		unsigned int *pnSrc,		// Input data.		    :long Local[qCodes/2].
//		unsigned int *pnDst,		// Compressed codes.	:long Global[resBits/64+1].
//		int		nCodes,		        // Quantity of codes.
//		int		nOffs,		        // Bit offset of compressed data in <dst>.
//		int&	nResBits,	        // Compressed codes size in bits + nOffs.
//		unsigned int *pnTmp			// Temporary buffer.	:long Local[resBits/64+1].				:l
//		);
//	Input data format (each element in 32-bit word):
//		bits 0..4 - length of code, bits 5..32 - codes;
//-------------------------------------------------------------------




global  _VLC_Compress:label;
	   <_VLC_Compress>
.branch;
	ar5 = ar7 - 2;
        
	push ar0, gr0;
    push ar1, gr1;
	push ar2, gr2;
    push ar3, gr3;
	push ar4, gr4;
    push ar5, gr5;
    push ar6, gr6;

	ar0 = [--ar5];		// Input data.
	ar4 = [--ar5];		// Output data.
	gr0 = [--ar5];		// Size of input data in 32-bit words.
	gr1 = [--ar5];		// Bits offset.

        // Заполняем матрицу весовых коэффициентов для перестановки байтов.
	ar5 = TranspositionBytes with gr1 <<= 26;
	nb1 = 80808080h with gr1 >>= 26;    //8 cols.
	sb = 02020202h with gr4 = false;    //8 rows.
	rep 8 wfifo = [ar5++], ftw, wtw;

        // Сохраняем значение смещения.
    [Offs] = gr1;

        // Сохраняем первые 64 бита из выходного буфера.
    ar6 = Reserve with gr6 = true;
    ar5, gr5 = [ar4] with gr6 >>= 27;   // gr6 = 0x1f - маска.
    [ar6] = ar5, gr5 with gr7 = gr1;

	ar5 = lab_Shift with gr1 >>= 5;
    ar1 = ar4;

        // Обнуляем первое слово результата.
	[ar1++gr1] = gr4;
	[ar1] = gr4;	    

	gr2 = [ar0++] with gr5 = gr7 and gr6;
	gr3 = gr2 with gr2 = gr2 and gr6;   // в gr2 - размер кода.
	gr1 = gr5 with gr5 <<= 2;
	ar3 = lab_VLCC_2;
<lab_VLCC_1>
	delayed goto ar5+gr5 with gr7 += gr2;
		gr3 = gr3 and not gr6;          // в gr3 - код.
		gr1 += gr2;
<lab_VLCC_2>
	if =0 delayed goto lab_VLCC_3 with gr4 = gr4 or gr3;
		gr5 = gr7 and gr6;
		gr0--;
	[ar1++] = gr4 with gr1 -= gr6 noflags;
	gr4 = gr2 with gr1-- noflags;
<lab_VLCC_3>
	if > delayed goto lab_VLCC_1;
		gr2 = [ar0++] with gr5 <<= 2;
		gr3 = gr2 with gr2 = gr2 and gr6;

    gr3 = ar1;
	[ar1] = gr4 with gr3 <<= 31;
    if <>0 delayed goto lab_VLCC_4 with gr3 = false;
        gr1 = [Offs];   // загружаем значение смещения.
    
        // Обнуляем последнее (нечётное) слово.
    [ar1+=1] = gr3;

<lab_VLCC_4>

    gr3 = 64 with gr1;
    if =0 delayed goto lab_VLCC_7 with gr3 -= gr1;
        ar3 = _VEC_TBL_Triangle_G;

        // Делаем конкатенацию.
    gr3 <<= 1;
    ar0, gr0 = [ar3+=gr3];
    gr3 = ar0 with gr0 = not gr0;
    ar3 = gr0 with gr3 = not gr3;
    ar1 = Mask;
    ar2 = Reserve;
    [ar1] = ar3, gr3;
    rep 1 data = [ar2] with vsum, data, 0;
    rep 1 data = [ar1] with mask data, afifo, 0;
    rep 1 data = [ar4] with data or afifo;
    rep 1 [ar4] = afifo;

<lab_VLCC_7>
	gr0 = 2 with gr5 = gr7 << 26;
	if =0 delayed goto lab_VLCC_8 with gr5 = gr7 >> 6;
        ar0 = ar4;
        ar6 = ar4 with gr6 = gr0;

	gr5++;

<lab_VLCC_8>

        // Делаем перестановку байтов в каждом слове результата.
    call vec_vsum_data_0;

    pop ar6, gr6 with gr7 -= gr1;
    pop ar5, gr5;
    pop ar4, gr4;
    pop ar3, gr3;
	pop ar2, gr2;
    pop ar1, gr1;
	pop ar0, gr0;
	return;
.wait;

<lab_Shift>
	delayed goto ar3;
		gr2 = false;
		gr1 and not gr6;
		nul;
	SHIFT(31, 1);
	SHIFT(30, 2);
	SHIFT(29, 3);
	SHIFT(28, 4);
	SHIFT(27, 5);
	SHIFT(26, 6);
	SHIFT(25, 7);
	SHIFT(24, 8);
	SHIFT(23, 9);
	SHIFT(22, 10);
	SHIFT(21, 11);
	SHIFT(20, 12);
	SHIFT(19, 13);
	SHIFT(18, 14);
	SHIFT(17, 15);
	SHIFT(16, 16);
	SHIFT(15, 17);
	SHIFT(14, 18);
	SHIFT(13, 19);
	SHIFT(12, 20);
	SHIFT(11, 21);
	SHIFT(10, 22);
	SHIFT(9, 23);
	SHIFT(8, 24);
	SHIFT(7, 25);
	SHIFT(6, 26);
	SHIFT(5, 27);
	SHIFT(4, 28);
	SHIFT(3, 29);
	SHIFT(2, 30);
	SHIFT(1, 31);

end ".text_jpeg";
