//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   JPEG Library                                                          */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   File:             MarkFF.h                                            */
//*   Contents:         Function for check 0x000000ff word                  */
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

//////////////////////////////////////////////////////////////////////////////
void nmjpegAUX_GetFFVectors(
	int				*src,		//Input data.
	unsigned int	*bitVector,	//Output vectors.
	int				size,		//Input buffer size in int.
	void			*tmp
	)
{
	int i, j = -1;

	for(i=0; i<size; i++)
	{
		if(!(i%32))
		{
			j++;
			bitVector[j] = 0;
		}
		bitVector[j] >>= 1;
		if(src[i] == 0xff)
			bitVector[j] |= 0x80000000;
	}
	bitVector[j] >>= (32 - (i%32));
}

//////////////////////////////////////////////////////////////////////////////
int nmjpegAUX_CheckMarkerByte(
	int	        *src,		//Input buffer.			:long Global[inSize/2].
	int			*dst,		//Output buffer.		:long Local[(outSize+1)/2].
	int			inSize,		//Input buffer size in int.
	unsigned int *bitVector	//Bit vec.			:long Local[inSize/64+1];
	)
{
	int i, j, n;
	
	int outSize = 0;
	n = ((inSize >> 5) << 5);
	for(i=0; i<n; i+=32)
	{
		if(*(bitVector++))
		{
			for(j=0; j<32; j++)
			{
				dst[outSize++] = src[i+j];
				if(src[i+j] == 0xff)
					dst[outSize++] = 0;
			}
		}
		else
		{
			for(j=0; j<32; j++)
				dst[outSize++] = src[i+j];
		}
	}
	n = inSize & 0x1f;
	if(*bitVector)
	{
		for(j=0; j<n; j++)
		{
			dst[outSize++] = src[i+j];
			if(src[i+j] == 0xff)
				dst[outSize++] = 0;
		}
	}
	else
	{
		for(j=0; j<n; j++)
			dst[outSize++] = src[i+j];
	}
    return outSize;
}
//////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
		};
#endif