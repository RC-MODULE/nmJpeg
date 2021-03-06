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

     
data ".data_jpeg"
	global ptr_tbl_w_CombineEvenEven:word;
	global ptr_tbl_w_CombineOddOdd:word;
	global ptr_tbl_w_CombineEvenOdd:word;
	global ptr_tbl_w_CombineOddEven:word;
	global ptr_tbl_w_CombineDirect:word;

	global dct_tbl_nb_EvenRightShift:word[13]=(
							80000002h,// >>0
							80000002h,// >>2
							80000008h,// >>4
							80000020h,// >>6
							80000080h,// >>8
							80000200h,// >>10
							80000800h,// >>12
							80002000h,// >>14
							80008000h,// >>16
							80020000h,// >>16
							80080000h,// >>18
							80200000h,// >>20
							80800000h // >>22
							);

	global dct_tbl_f1cr_int_Clip:word[32]=(
							0FFFFFFFFh, //2^00
							0FFFFFFFEh, //2^01
							0FFFFFFFCh, //2^02
							0FFFFFFF8h, //2^03
							0FFFFFFF0h, //2^04
							0FFFFFFE0h, //2^05
							0FFFFFFC0h, //2^06
							0FFFFFF80h, //2^07
							0FFFFFF00h, //2^08
							0FFFFFE00h, //2^09
							0FFFFFC00h, //2^10
							0FFFFF800h, //2^11
							0FFFFF000h, //2^12
							0FFFFE000h, //2^13
							0FFFFC000h, //2^14
							0FFFF8000h, //2^15
							0FFFF0000h, //2^16
							0FFFE0000h, //2^17
							0FFFC0000h, //2^18
							0FFF80000h, //2^19
							0FFF00000h, //2^20
							0FFE00000h, //2^21
							0FFC00000h, //2^22
							0FF800000h, //2^23
							0FF000000h, //2^24
							0FE000000h, //2^25
							0FC000000h, //2^26
							0F8000000h, //2^27
							0F0000000h, //2^28
							0E0000000h, //2^29
							0C0000000h, //2^30
							080000000h	//2^31
							);

end ".data_jpeg";


data ".data_jpeg_opt0"

	global G_tbl_w_OddEvenShr0:long [8] = 
						(	0000000000000000hl,
							0000000000000000hl,
							0000000000000001hl,
							0000000000000004hl,

							0000000100000000hl,
							0000000400000000hl,
							0000000000000000hl,
							0000000000000000hl
						    );

	global G_tbl_w_OddOddShr0:long [8] = 
						(	0000000000000000hl,
							0000000000000000hl,
							0000000000000001hl,
							0000000000000004hl,

							0000000000000000hl,
							0000000000000000hl,
							0000000100000000hl,
							0000000400000000hl
						    );
	global G_tbl_w_EvenOddShr0:long [8] = 
						(	0000000000000001hl,
							0000000000000004hl,
							0000000000000000hl,
							0000000000000000hl,

							0000000000000000hl,
							0000000000000000hl,
							0000000100000000hl,
							0000000400000000hl
						    );

//	G_tbl_w_EvenOddShr0:long [8] = 
//						(	0000000000000001hl,
//							0000000000000004hl,
//							0000000000000000hl,
//							0000000000000000hl,
//
//							0000000000000000hl,
//							0000000000000000hl,
//							0000000100000000hl,
//							0000000400000000hl
//						    );

	global G_tbl_w_EvenEvenShr0:long [8] = 
						(	0000000000000001hl,
							0000000000000004hl,
							0000000000000000hl,
							0000000000000000hl,
							
							0000000100000000hl,
							0000000400000000hl,
							0000000000000000hl,
							0000000000000000hl
						    );

	global G_tbl_w_DirectShr0:long [4] = 
						(	0000000000000001hl,
							0000000000000004hl,
							0000000100000000hl,
							0000000400000000hl
						);



	global G_tbl_w_OddEven:long [8] = 
						(	0000000000000000hl,
							0000000000000000hl,
							0000000000000000hl,
							0000000000000001hl,

							0000000000000000hl,
							0000000100000000hl,
							0000000000000000hl,
							0000000000000000hl
						    );

	global G_tbl_w_OddOdd:long [8] = 
						(	0000000000000000hl,
							0000000000000000hl,
							0000000000000000hl,
							0000000000000001hl,

							0000000000000000hl,
							0000000000000000hl,
							0000000000000000hl,
							0000000100000000hl
						    );
	global G_tbl_w_EvenOdd:long [8] = 
						(	0000000000000000hl,
							0000000000000001hl,
							0000000000000000hl,
							0000000000000000hl,

							0000000000000000hl,
							0000000000000000hl,
							0000000000000000hl,
							0000000100000000hl
						    );

	global G_tbl_w_EvenEven:long [8] = 
						(	0000000000000000hl,
							0000000000000001hl,
							0000000000000000hl,
							0000000000000000hl,
							
							0000000000000000hl,
							0000000100000000hl,
							0000000000000000hl,
							0000000000000000hl
						    );
	
	global G_tbl_w_Direct:long [4] = 
						(	0000000000000000hl,
							0000000000000001hl,
							0000000000000000hl,
							0000000100000000hl
						    );


	

//	ZigZagTable:word[64]=(
//				00,01, 08,16, 09,02, 03,10,
//				17,24, 32,25, 18,11, 04,05,
//				12,19, 26,33, 40,48, 41,34,
//				27,20, 13,06, 07,14, 21,28,
//				35,42, 49,56, 57,50, 43,36,
//				29,22, 15,23, 30,37, 44,51,
//				58,59, 52,45, 38,31, 39,46,
//				53,60, 61,54, 47,55, 62,63);
end ".data_jpeg_opt0";



