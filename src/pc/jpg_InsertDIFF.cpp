//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             JPEGRLE.cpp                                         */
//*   Contents:         Routines for perform saving and count DIFF          */
//*                     for DC.                                             */ 
//*                                                                         */
//*   Software design:  S.Landyshev                                         */
//*                                                                         */
//*   Version           1.1                                                 */
//*   Start date:       -09.09.2001                                         */
//*   $Revision: 1.1 $    $Date: 2005/02/10 12:36:38 $                           */
//***************************************************************************/

#ifdef __cplusplus
		extern "C" {
#endif


void nmjpegAUX_CountDIFF(
	int*	piSrc,
	__int64*	piDst,
	int		iSize
	)
{
	int i, j, a = 0;
	
	for(i=0, j=0; i<iSize; i+=64, j++)
	{
		piDst[j] = ((piSrc[i]>>18) - a) & 0x1ff;
		a = piSrc[i] >> 18;
	}
}
//-----------------------------------------------------------------------------
void nmjpegAUX_InsertDIFF(
	__int64*	piSrc,
	int*	piDst,
	int		iSize
	)
{
	int i, j;
	

	for(i=0, j=0; i<iSize; i++, j+=64)
		piDst[j] = piSrc[i];
}
//-----------------------------------------------------------------------------
#ifdef __cplusplus
		};
#endif