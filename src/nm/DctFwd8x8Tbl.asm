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

 
data ".data_jpeg_opt1"


global DCT_Right:long[4*8]=(
0000007D9000005A8hl,0000006A7000005A8hl,000000472000005A8hl,000000190000005A8hl,0FFFFFE70000005A8hl,0FFFFFB8E000005A8hl,0FFFFF959000005A8hl,0FFFFF827000005A8hl,
0000006A700000764hl,0FFFFFE7000000310hl,0FFFFF827FFFFFCF0hl,0FFFFFB8EFFFFF89Chl,000000472FFFFF89Chl,0000007D9FFFFFCF0hl,00000019000000310hl,0FFFFF95900000764hl,
000000472000005A8hl,0FFFFF827FFFFFA58hl,000000190FFFFFA58hl,0000006A7000005A8hl,0FFFFF959000005A8hl,0FFFFFE70FFFFFA58hl,0000007D9FFFFFA58hl,0FFFFFB8E000005A8hl,
00000019000000310hl,0FFFFFB8EFFFFF89Chl,0000006A700000764hl,0FFFFF827FFFFFCF0hl,0000007D9FFFFFCF0hl,0FFFFF95900000764hl,000000472FFFFF89Chl,0FFFFFE7000000310hl
);
global DCT_Left:long[8*1]=(
05A5B5A5B5A5B5A5Bhl,
08296B9E719476A7Ehl,
07631CF8A8ACF3176hl,
096197E47B982E76Ahl,
05BA5A55B5BA5A55Bhl,
0B97EE7966A198247hl,
0318A76CFCF768A31hl,
0E747967E826AB919hl
);



end ".data_jpeg_opt1";



