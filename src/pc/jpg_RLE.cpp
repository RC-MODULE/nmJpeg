//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             JPEGRLE.cpp                                         */
//*   Contents:         Routines for perform JPEGRLE coding and             */
//*                     getting variable length codes (VLC) from            */
//*					    Haffman tables (standard JPEG)                      */ 
//*                                                                         */
//*   Software design:  S.Landyshev                                         */
//*                                                                         */
//*   Version           1.1                                                 */
//*   Start date:       -09.09.2001                                         */
//*   $Revision: 1.1 $    $Date: 2005/02/10 12:36:38 $                           */
//*                                                                         */
//*                                                                         */
//***************************************************************************/

#ifdef __cplusplus
		extern "C" {
#endif


int nmjpegAUX_RLE(
	int *pnSrc,		// Input buffer,	:int Local[nSize].
	int *pnDst,		// Output buffer.:int Global[nSize].
	int	nSize,		// Size of input buffer in int.
    int *pnDCTable, // Таблица для кодирования DC.
    int *pnACTable, // Таблица для кодирования AC.
	void *pvTmp		// Temporary buffer.	:long Local[nSize/64].
	)
{
	int i, j, r, d, k, m;
	int nRes = 0;

	d = 0;
    k = 0;
	for(i=0; i<nSize; i+=64)
	{
		k++;
		pnDst[nRes++] = pnDCTable[pnSrc[i]];
		r = 0;
		for(j=1; j<64; j++)
		{
			if(m = pnSrc[i+j])
			{
				while(r > 15)
				{
					pnDst[nRes++] = pnACTable[0xf];
					r -= 16;
				}
				pnDst[nRes++] = pnACTable[r + (m << 4)];
				r = 0;
			}
			else
				r++;
		}
		if(r)
        {
            pnDst[nRes++] = pnACTable[0];
        }
		if(!(k%4))
        {
            pnDst[nRes++] = 8; //Cb&Cr = 0
        }
	}
	return nRes;
}
//-----------------------------------------------------------------------------
#ifdef __cplusplus
		};
#endif