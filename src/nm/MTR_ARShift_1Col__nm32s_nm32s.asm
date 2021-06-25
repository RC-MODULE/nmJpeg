//------------------------------------------------------------------------
//
//  $Workfile:: ARSH32.as $
//
//  Векторно-матричная библиотека
//
//  Copyright (c) RC Module Inc.
//
//  $Revision: 1.1 $      $Date: 2005/02/10 12:36:37 $
//
//! \if file_doc
//!
//! \file   ARSH32.asm
//! \author Сергей Мушкаев
//! \brief  Функции сдвига для векторов.
//!
//! \endif
//!
//------------------------------------------------------------------------
//#include "vShift.h"

extern vec_vsum_shift_data_0:label;
extern vec_vsum_data_0:label;


extern vec_tbl_nb_int_EvenRightShift:long[16];

extern vec_tbl_sb_int_EvenRightShift:long[16];

extern vec_tbl_w_int_EvenRightShift:long[4*16];
extern vec_tbl_sb_int_OddRightShift:long[16];

extern vec_tbl_nb_int_OddRightShift:long[16];
extern vec_tbl_w_int_OddRightShift:long[6*16];
// This data for VEC_ARSH32_aaRC macros
extern Table_sb_nb_woper_even:long[6*16];
					   
// This data for VEC_ARSH32_aaRC macros
extern Table_sb_nb_woper_odd:long[8*16];


import from macros.mlb;

begin ".text_jpeg"

    //--------------------------------------------------------------------
    //! \fn void MTR_ARShift_1Col(nm32s* pSrcMtr, int nSrcStride, nm32s* pDstMtr, int nDstStride, int nRows, int nShift);
	//!
//! \perfinclude _MTR_ARShift_1Col__FPiiPiiii.html
    //--------------------------------------------------------------------

global _MTR_ARShift_1Col__FPiiPiiii:label;
<_MTR_ARShift_1Col__FPiiPiiii>
.branch;
	ar5 = sp - 2;

	push ar0,gr0;
	push ar1,gr1;
	push ar4,gr4;
	push ar5,gr5;
	push ar6,gr6;
	
	ar0 = [--ar5];	// pSrcMtr
	gr0 = [--ar5];	// nSrcStride
	ar6 = [--ar5];	// pDstMtr
	gr6 = [--ar5];	// nDstStride
	gr5 = [--ar5];	// nRows
	gr4 = [--ar5]	// nShift
		with gr7 = gr4<<31;
	<AShiftRight_Core>
	if =0 delayed goto arsh32_Even_by32; 
		nul;
		nul;
	/////////////////////////////////////////////////////////////
	// Shifting by odd number of bits to the right
	ar4 = vec_tbl_sb_int_OddRightShift	with gr4--;
	sb  = [ar4+=gr4]					with gr7 =gr4<<1;
	ar4 = vec_tbl_nb_int_OddRightShift  with gr7+=gr4;
	gr1 = [ar4+=gr4]					with gr4=gr7<<1;
	nb1 = gr1;											
	ar4 = vec_tbl_w_int_OddRightShift;
	ar4+= gr4;		
	rep 6 wfifo=[ar4++],ftw;

	delayed call vec_vsum_shift_data_0;
		//WTW_REG(gr1);
		wtw;
		nul;
	
	goto arsh32_Finish;
	
	<arsh32_Even_by32>
	/////////////////////////////////////////////////////////////
	// Shifting by Even number of bits to the right
	ar4 = vec_tbl_sb_int_EvenRightShift;
	sb  = [ar4+=gr4];
	ar4 = vec_tbl_nb_int_EvenRightShift;
	gr1 = [ar4+=gr4];
	nb1 = gr1;											
	ar4 = vec_tbl_w_int_EvenRightShift with gr4<<=2;
	ar4+= gr4;		
	rep 4 wfifo=[ar4++],ftw;

	delayed call vec_vsum_data_0;
		//WTW_REG(gr1);
		wtw;
		nul;

	<arsh32_Finish>


	pop ar6,gr6;
	pop ar5,gr5;
	pop ar4,gr4;
	pop ar1,gr1;
	pop ar0,gr0;
	return;
.wait;
end ".text_jpeg";