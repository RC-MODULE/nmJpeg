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

data ".data_jpeg"


global IDCT_Right:long[4*8]=(
00000005B0000005Ahl,00000006A0000007Ehl,00000003100000075hl,0FFFFFFE70000006Ahl,0FFFFFFA50000005Ahl,0FFFFFF8200000047hl,0FFFFFF8A00000030hl,0FFFFFFB900000019hl,
00000005B0000005Bhl,00000001900000047hl,0FFFFFF8AFFFFFFCFhl,0FFFFFFB9FFFFFF82hl,00000005BFFFFFFA5hl,00000006A00000019hl,0FFFFFFCF00000076hl,0FFFFFF820000006Ahl,
00000005B0000005Bhl,0FFFFFFB9FFFFFFE7hl,0FFFFFFCFFFFFFF8Ahl,00000007E00000047hl,0FFFFFFA50000005Bhl,0FFFFFFE7FFFFFF96hl,000000076FFFFFFCFhl,0FFFFFF960000007Ehl,
00000005B0000005Bhl,0FFFFFF82FFFFFF96hl,00000007600000031hl,0FFFFFF9600000019hl,00000005BFFFFFFA5hl,0FFFFFFB90000007Ehl,000000031FFFFFF8Ahl,0FFFFFFE700000047hl
);
global IDCT_Left:long[8*1]=(
01831465B69767D5Bhl,
0B98A82A5E7316A5Bhl,
06A7619A582CF475Bhl,
082CF6A5BB98A195Bhl,
07ECF965B478AE75Bhl,
09676E7A57ECFB95Bhl,
0478A7EA51931965Bhl,
0E731B95B9676825Bhl
);


end ".data_jpeg";



