//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             GenTebles.cpp                                       */
//*   Contents:         Generate AC/DC tables functions                     */
//*                                                                         */
//*   Software design:  S.Landyshev                                         */
//*                                                                         */
//*   Version           1.1                                                 */
//*   Start date:       -09.09.2001                                         */
//*   Release data:     -20.11.2001                                         */
//*                                                                         */
//*                                                                         */
//***************************************************************************/
#include "insection.h"    
	// Структуры и данные для генерирования таблиц для алгоритма Хаффмана.
#ifdef __cplusplus
		extern "C" {
#endif

struct S_nmjpegCodeElem
{
	int nLen;
	int nCode;
};
    //--------------------------------------------------------------------
    // DCHuffman - 16 elements.
IN_DATA_SECTION(".data_jpeg") static struct S_nmjpegCodeElem DCHuffman[] = 
{
	2,0x0,		3,0x2,		3,0x3,		3,0x4, 
	3,0x5,		3,0x6,		4,0xe,		5,0x1e, 
	6,0x3e,		7,0x7e,		8,0xfe,		9,0x1fe, 
	0,0,		0,0,		0,0,		0,0	//not used.
};

    //--------------------------------------------------------------------
    // ACHuffman - 256 elements.
IN_DATA_SECTION(".data_jpeg") static struct S_nmjpegCodeElem ACHuffman[] = 
{
	4,0xa,		2,0x0,		2,0x1,		3,0x4,
	4,0xb,		5,0x1a,		7,0x78,		8,0xf8,
	10,0x3f6,	16,0xff82,	16,0xff83,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		4,0xc,		5,0x1b,		7,0x79,
	9,0x1f6,	11,0x7f6,	16,0xff84,	16,0xff85,
	16,0xff86,	16,0xff87,	16,0xff88,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		5,0x1c,		8,0xf9,		10,0x3f7,
	12,0xff4,	16,0xff89,	16,0xff8a,	16,0xff8b,
	16,0xff8c,	16,0xff8d,	16,0xff8e,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		6,0x3a,		9,0x1f7,	12,0xff5,
	16,0xff8f,	16,0xff90,	16,0xff91,	16,0xff92,
	16,0xff93,	16,0xff94,	16,0xff95,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		6,0x3b,		10,0x3f8,	16,0xff96,
	16,0xff97,	16,0xff98,	16,0xff99,	16,0xff9a,
	16,0xff9b,	16,0xff9c,	16,0xff9d,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		7,0x7a,		11,0x7f7,	16,0xff9e,
	16,0xff9f,	16,0xffa0,	16,0xffa1,	16,0xffa2,
	16,0xffa3,	16,0xffa4,	16,0xffa5,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		7,0x7b,		12,0xff6,	16,0xffa6,
	16,0xffa7,	16,0xffa8,	16,0xffa9,	16,0xffaa,
	16,0xffab,	16,0xffac,	16,0xffad,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		8,0xfa,		12,0xff7,	16,0xffae,
	16,0xffaf,	16,0xffb0,	16,0xffb1,	16,0xffb2,
	16,0xffb3,	16,0xffb4,	16,0xffb5,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		9,0x1f8,	15,0x7fc0,	16,0xffb6,
	16,0xffb7,	16,0xffb8,	16,0xffb9,	16,0xffba,
	16,0xffbb,	16,0xffbc,	16,0xffbd,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		9,0x1f9,	16,0xffbe,	16,0xffbf,
	16,0xffc0,	16,0xffc1,	16,0xffc2,	16,0xffc3,
	16,0xffc4,	16,0xffc5,	16,0xffc6,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		9,0x1fa,	16,0xffc7,	16,0xffc8,
	16,0xffc9,	16,0xffca,	16,0xffcb,	16,0xffcc,
	16,0xffcd,	16,0xffce,	16,0xffcf,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		10,0x3f9,	16,0xffd0,	16,0xffd1,
	16,0xffd2,	16,0xffd3,	16,0xffd4,	16,0xffd5,
	16,0xffd6,	16,0xffd7,	16,0xffd8,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		10,0x3fa,	16,0xffd9,	16,0xffda,
	16,0xffdb,	16,0xffdc,	16,0xffdd,	16,0xffde,
	16,0xffdf,	16,0xffe0,	16,0xffe1,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		11,0x7f8,	16,0xffe2,	16,0xffe3,
	16,0xffe4,	16,0xffe5,	16,0xffe6,	16,0xffe7,
	16,0xffe8,	16,0xffe9,	16,0xffea,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	0,0x0,		16,0xffeb,	16,0xffec,	16,0xffed,
	16,0xffee,	16,0xffef,	16,0xfff0,	16,0xfff1,
	16,0xfff2,	16,0xfff3,	16,0xfff4,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
	11,0x7f9,	16,0xfff5,	16,0xfff6,	16,0xfff7,
	16,0xfff8,	16,0xfff9,	16,0xfffa,	16,0xfffb,
	16,0xfffc,	16,0xfffd,	16,0xfffe,	0,0x0,
	0,0x0,		0,0x0,		0,0x0,		0,0x0,
};
    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") static int GetCategory(int val)
{
	if(!val)
		return 0;
	else if(val>(-2) && val<2)
		return 1;
	else if(val>(-4) && val<4)
		return 2;
	else if(val>(-8) && val<8)
		return 3;
	else if(val>(-16) && val<16)
		return 4;
	else if(val>(-32) && val<32)
		return 5;
	else if(val>(-64) && val<64)
		return 6;
	else if(val>(-128) && val<128)
		return 7;
	else if(val>(-256) && val<256)
		return 8;
	else if(val>(-512) && val<512)
		return 9;
	else if(val>(-1024) && val<1024)
		return 10;
	else if(val>(-2048) && val>2048)
		return 11;
	else
		return -1;
}
    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") void nmjpegAUX_GenDCEncTab(
	int *t		//Output table (size = 512).
	)
{
	int i, cat; 
	
	for(i=0; i<512; i++)
	{
		if(i & 256)
        {
            t[i] = i - 512;
        }
		else 
        {
            t[i] = i;
        }
		cat = GetCategory(t[i]);
		if(t[i] < 0)
        {
            t[i] = (t[i] - 1) & ((1 << cat) - 1);
        }
		t[i] |= (DCHuffman[cat].nCode << cat);
		t[i] <<= (32 - (DCHuffman[cat].nLen + cat));
		t[i] = t[i] | (DCHuffman[cat].nLen + cat);
	}

}

    //--------------------------------------------------------------------
IN_CODE_SECTION(".code_jpeg") void nmjpegAUX_GenACEncTab(
	int *t		// Output table (size = 4096).
	)
{

	int i, run, cat;
	unsigned lev;

	for(i=0; i<4096; i++)
	{
		run = (i & 0xf) << 4;
		lev = i >> 4;
		if(lev & 128)
        {
			lev -= 256;
        }
		cat = GetCategory(lev);
		run |= cat;	//run = |run|cat|.
		if((int)lev < 0)
        {
            lev = (lev - 1) & ((1 << cat) - 1);
        }
		lev |= (ACHuffman[run].nCode << cat);
		lev <<= (32 - (ACHuffman[run].nLen + cat));
		t[i] = lev | (ACHuffman[run].nLen + cat);
	}
}
    //--------------------------------------------------------------------

#ifdef __cplusplus
		};
#endif
