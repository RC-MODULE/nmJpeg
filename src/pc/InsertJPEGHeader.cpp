//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             JPEGHeader.asm                                      */
//*   Contents:         Routines for forming and insert JPEG header         */
//*						                                                    */
//*                                                                         */
//*   Software design:  S.Landyshev                                         */
//*                                                                         */
//*   Version           1.1                                                 */
//*   Start date:       -09.09.2001                                         */
//*   $Revision: 1.1 $    $Date: 2005/02/10 12:36:38 $                           */
//*                                                                         */
//*                                                                         */
//***************************************************************************/
//#include "JPEGHeader.h"
#include "jpegDCT.h"
#ifdef __cplusplus
		extern "C" {
#endif

///////////////////////////////////////////////////////////
//JPEGHeader:
//qTable offset	+25 bytes.
//Height offset	+94 bytes.
//Width  offset	+96 bytes.
//Total size 560 bytes, or 140 32-bit words, or 70 64-bit words. 
int JPEGHeader[] = {
	0xe0ffd8ff, 0x464a1000, 0x01004649, 0x01000001, 
	0x00000100, 0x4300dbff, 0x00000000, 0x00000000,
	0x00000000, 0x00000000, 0x00000000, 0x00000000, 
	0x00000000, 0x00000000, 0x00000000, 0x00000000,
	0x00000000, 0x00000000, 0x00000000, 0x00000000,
	0x00000000, 0x00000000, 0x00c0ff00, 0x00000811,
	0x01030000, 0x11020022, 0x00110300, 0x1f00c4ff,
	0x05010000, 0x01010101, 0x00000101, 0x00000000,
	0x02010000, 0x06050403, 0x0a090807, 0x00c4ff0b,
	0x020010b5, 0x02030301, 0x05050304, 0x00000404,
	0x02017d01, 0x11040003, 0x31211205, 0x51130641,
	0x71220761, 0x91813214, 0x422308a1, 0x5215c1b1,
	0x3324f0d1, 0x09827262, 0x1817160a, 0x26251a19,
	0x2a292827, 0x37363534, 0x433a3938, 0x47464544,
	0x534a4948, 0x57565554, 0x635a5958, 0x67666564,
	0x736a6968, 0x77767574, 0x837a7978, 0x87868584,
	0x928a8988, 0x96959493, 0x9a999897, 0xa5a4a3a2,
	0xa9a8a7a6, 0xb4b3b2aa, 0xb8b7b6b5, 0xc3c2bab9,
	0xc7c6c5c4, 0xd2cac9c8, 0xd6d5d4d3, 0xdad9d8d7,
	0xe4e3e2e1, 0xe8e7e6e5, 0xf2f1eae9, 0xf6f5f4f3,
	0xfaf9f8f7, 0x1f00c4ff, 0x01030001, 0x01010101,
	0x01010101, 0x00000000, 0x02010000, 0x06050403,
	0x0a090807, 0x00c4ff0b, 0x020011b5, 0x04040201,
	0x05070403, 0x01000404, 0x01007702, 0x04110302,
	0x06312105, 0x07514112, 0x22137161, 0x14088132,
	0xb1a19142, 0x332309c1, 0x6215f052, 0x160ad172,
	0x25e13424, 0x191817f1, 0x2827261a, 0x36352a29,
	0x3a393837, 0x46454443, 0x4a494847, 0x56555453,
	0x5a595857, 0x66656463, 0x6a696867, 0x76757473,
	0x7a797877, 0x85848382, 0x89888786, 0x9493928a,
	0x98979695, 0xa3a29a99, 0xa7a6a5a4, 0xb2aaa9a8,
	0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2, 0xc9c8c7c6,
	0xd4d3d2ca, 0xd8d7d6d5, 0xe3e2dad9, 0xe7e6e5e4,
	0xf2eae9e8, 0xf6f5f4f3, 0xfaf9f8f7, 0x0400feff,
	0xdaff0000, 0x01030c00, 0x03110200, 0x003f0011};
///////////////////////////////////////////////////////////
int CreateJPEGHeader(
	int		width,		//Image width.
	int		height,		//Image height.
	int*	qTable		//Quant table (64 elements).
	)
{
	int i, j;
	
	JPEGHeader[6] |= (qTable[0]<<8)+(qTable[1]<<16)+(qTable[2]<<24);
	j = 3;
	for(i=7, j=3; i<22; i++, j+=4)
		JPEGHeader[i] = qTable[j] + 
					(qTable[j+1]<<8) +
					(qTable[j+2]<<16) +
					(qTable[j+3]<<24);
	JPEGHeader[22] |= qTable[63];
	i = (height >> 8);
	i += (height & 0xff) << 8;
	i <<= 16;
	JPEGHeader[23] |= i;
	i = (width >> 8);
	i += (width & 0xff) << 8;
	JPEGHeader[24] |= i;
	return 0;
}
///////////////////////////////////////////////////////////
int InsertJPEGHeader(
	char*	src,		//Input data.
	int&	resBytes	//Size of src in bytes.
	)
{
	int i;
	int *s = (int*)src;

	for(i=0; i<140; i++)
		s[i] = JPEGHeader[i];
	i = (resBytes) & 0x3;
    switch(i)
    {
    case 0:
		s[resBytes >> 2] = (s[resBytes >> 2] & 0xFFFF0000) | 0x0000D9FF;
        break;
    case 1:
		s[resBytes >> 2] = (s[resBytes >> 2] & 0xFF0000FF) | 0x00D9FF00;
        break;
    case 2:
		s[resBytes >> 2] = (s[resBytes >> 2] & 0x0000FFFF) | 0xD9FF0000;
        break;
    case 3:
		s[resBytes >> 2] |= 0xFF000000;
		s[(resBytes >> 2) + 1] = 0x000000D9;
        break;
    }
	resBytes += 2;
	return 0;
}
#ifdef __cplusplus
		};
#endif