//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   DCT Library                                                           */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   $Workfile:: DctTbl.asm                                               $*/
//*                                                                         */
//*   Contents:         Routines for computing the forward                  */
//*                     and inverse 2D DCT of an image                      */
//*                     with 16 bit pixel                                   */
//*                                                                         */
//*   Software design: S.Mushkaev                                           */
//*                                                                         */
//*   Version          1.8                                                  */
//*   Start date:      06.02.2001                                           */
//*   Release  $Date: 2005/02/10 12:36:37 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/

 
//#include "dct.h"

//   DESCRIPTION:
//
//		Computes 2-D DCT and IDCT of the 8x8 block sequence  
//
//		Header file : "nmfft.h"
//		Library:	  


data ".data_jpeg"

global RoundTbl_32bit:long[32]=(
	0000000000000000hl,
	0000000100000001hl,
	0000000200000002hl,
	0000000400000004hl,
	0000000800000008hl,
	0000001000000010hl,
	0000002000000020hl,
	0000004000000040hl,
	0000008000000080hl,
	0000010000000100hl,
	0000020000000200hl,
	0000040000000400hl,
	0000080000000800hl,
	0000100000001000hl,
	0000200000002000hl,
	0000400000004000hl,
	0000800000008000hl,
	0001000000010000hl,
	0002000000020000hl,
	0004000000040000hl,
	0008000000080000hl,
	0010000000100000hl,
	0020000000200000hl,
	0040000000400000hl,
	0080000000800000hl,
	0100000001000000hl,
	0200000002000000hl,
	0400000004000000hl,
	0800000008000000hl,
	1000000010000000hl,
	2000000020000000hl,
	4000000040000000hl
	);


end ".data_jpeg";



