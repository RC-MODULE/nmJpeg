//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*  Discrete Cosine Transform Library                                      */
//*  (C-callable functions)                                                 */
//*                                                                         */
//*  $Workfile:: ZigZag.cpp                                                $*/
//*  Contents:   Z-reordering routines (PC Library)                         */
//*                                                                         */
//*  Author:     S.Mushkaev                                                 */
//*                                                                         */
//*  Version         2.0                                                    */
//*  Start    Date:  23.11.2000                                             */
//*  Release $Date: 2005/02/10 12:36:38 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/
//#include "internal.h"
#include "nmplv.h"

#ifdef __cplusplus
		extern "C" {
#endif


int ZigZagTable[64]={
	 0, 1, 8,16, 9, 2, 3,10,
	17,24,32,25,18,11, 4, 5,
	12,19,26,33,40,48,41,34,
	27,20,13, 6, 7,14,21,28,
	35,42,49,56,57,50,43,36,
	29,22,15,23,30,37,44,51,
	58,59,52,45,38,31,39,46,
	53,60,61,54,47,55,62,63};	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////
void nmjpegFwdZigZag8x8(
				nm32s*	pSrcBlockSeq,			// Input Array in normal order	:long Local [nBlocks*64/2]
				nm32s*	pDstBlockSeq,			// Output Array in Z-order		:long Global[nBlocks*64/2]
				int		nBlocks,		// Number of 8x8 Blocks			:nBlocks=[4,8,12....]
				int		nPreShift,		// Preceding scale down by right shift by nPreShift bits	: =[0,2,4...30]
				int		fUseCharClip	// if !=0 Clipping of results in range [-2^ClipFactor...+2^ClipFactor-1]	: =[1,2,3,..31]
				)
{
	int *DstBuff=pDstBlockSeq;
	for(int b=0;b<nBlocks;b++)
	{

		for(int i=0;i<64;i++)
		{
			pDstBlockSeq[i]=pSrcBlockSeq[ZigZagTable[i]];
		}
		pDstBlockSeq+=64;
		pSrcBlockSeq+=64;
	}
	pDstBlockSeq=DstBuff;
//	VEC_AShiftRight(Dst,Dst,nBlocks*64,PreShift);
	nmppsRShiftC_32s(pDstBlockSeq,nPreShift, pDstBlockSeq,nBlocks*64);
	if (fUseCharClip)
	{
		nmppsClipPowC_32s(pDstBlockSeq,7,pDstBlockSeq,nBlocks*64);
		nm64u nVal=0x000000FF000000FF;
		nmppsAndC_64u((nm64u*) pDstBlockSeq, nVal, (nm64u*)pDstBlockSeq, nBlocks*32);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
void nmjpegInvZigZag8x8(
			nm32s*	pSrcBlockSeq,		// Array in Z-order				:long Local [nBlocks*64/2]
			nm32s*	pDstBlockSeq,		// Result array in normal order	:long Global[nBlocks*64/2]
			int		nBlocks	// Number of 8x8 Blocks			:nBlocks=[1,2,3..]
				)
{
	for(int b=0;b<nBlocks;b++)
	{

		for(int i=0;i<64;i++)
		{
			pDstBlockSeq[ZigZagTable[i]]=pSrcBlockSeq[i];
		}
		pDstBlockSeq+=64;
		pSrcBlockSeq+=64;
	}
}
#ifdef __cplusplus
		};
#endif