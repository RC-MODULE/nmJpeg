//******************************************************************/
//*                     RC Module Inc., Moscow, Russia             */
//*                     NeuroMatrix(r) NM6403 Software             */
//*                                                                */
//*   VLC Library                                                  */
//*   (C-callable functions)                                       */
//*                                                                */
//*   File:             VLC.cpp                                    */
//*   Contents:         Implementation of Variable nLength Coding   */
//*                     routines.                                  */
//*                                                                */
//*   Software design:  S.Landyshev                                */
//*                                                                */
//*   Version           1.1                                        */
//*   Start date:       -09.09.2001                                */
//*   $Revision: 1.1 $    $Date: 2005/02/10 12:36:38 $                  */
//******************************************************************/
#include "jpegDCT.h"

#ifdef __cplusplus
		extern "C" {
#endif


int VLC_Compress(unsigned int *pnSrc, nm64u *pDst, int nCodes, int nOffs)
{
	int i, j;
	unsigned int *pnCur;
    unsigned int *pnDst = (unsigned int*)pDst;
    unsigned int nCode, nLen, lc, rc, sh;
    int nResBits;

        // Допустимые значения для смещения - 0..63.
    nOffs &= 0x3F;

	nResBits = nOffs;
	pnDst += (nOffs >> 5);

    if(nOffs & 0x1f)
	{
		*pnDst = (*pnDst << 24) | ((*pnDst << 8) & 0xff0000) |	((*pnDst >> 8) & 0xff00) | (*pnDst >> 24);
		*pnDst &= (0xffffffff << (32 - (nResBits & 0x1f)));
	}
	else
    {
    	*pnDst = 0;
    }
	
	pnCur = pnDst;
	//sh = nResBits & 0x1f;					//сколько бит торчит в последнем слове 0..31
	j = 0;
/*	
    for(i=0; i<nCodes; i++)
	{
		nLen = (pnSrc[i] & 0x1f);			// длина кода
		nCode = pnSrc[i] & 0xffffffe0;		// код
        lc = 0;								// левая часть кода
        rc = 0;								// правая часть кода
		if(sh < 32)
        {		
            lc = nCode >> sh;				// выделяем левую часть
        }
		if(sh) 
        {
            rc = nCode << (32 - (nResBits & 0x1f));
        }
		pnCur[j] |= lc;
		sh += nLen;
		if(sh > 32)
		{
			pnCur[++j] = rc;
			sh -= 32;
		}
		nResBits += nLen;
	}
*/

	for(i=0; i<nCodes; i++)
	{
		nLen = (pnSrc[i] & 0x1f);			// длина кода
		nCode = pnSrc[i] & 0xffffffe0;		// код
		sh = nResBits&31;					// битовая позиция на запись кода в слове 
		lc = nCode >> sh;					// выделяем левую часть
		pnCur[j] |= lc;						// приписываем левую часть
		if (sh+nLen>=32){					// если код не влез целиком
			rc = nCode << (32-sh);			// выделяем правую часть
			pnCur[++j] = rc;
		}
		nResBits += nLen;
	}

	for(i=0; i<=j; i++)
    {
        pnDst[i] = (pnDst[i] << 24) | ((pnDst[i] << 8) & 0x00ff0000) | 	((pnDst[i] >> 8) & 0xff00) | (pnDst[i] >> 24);
    }
    if(i & 1)
    {
        pnDst[i] = 0;
    }

    return nResBits - nOffs;
}
//-------------------------------------------------------------------
//		END OF FILE VLC.cpp
//-------------------------------------------------------------------
#ifdef __cplusplus
		};
#endif