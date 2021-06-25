//***************************************************************************/
//*                     RC Module Inc., Moscow, Russia                      */
//*                     NeuroMatrix(r) NM6403 Software                      */
//*                                                                         */
//*   Vector Processing  Library                                            */
//*   (C-callable functions)                                                */
//*                                                                         */
//*   $Workfile:: Quant2Int.cpp                                            $*/
//*                                                                         */
//*   Contents:        Quantizing routines                                  */
//*                                                                         */
//*   Software design: S.Mushkaev                                           */
//*                                                                         */
//*   Version          1.0                                                  */
//*   Start date:      10.09.2002                                           */
//*   Release  $Date: 2005/02/10 12:36:38 $*/
//*                                                                         */
//*                                                                         */
//***************************************************************************/
#include "nmtype.h"

#ifdef __cplusplus
		extern "C" {
#endif


extern "C"
extern "C" int DivTable_1_145_18[];
/////////////////////////////////////////////////////////////////////////////////////////////////////////
void nmjpegQuant_By2Int(
		nm32s*	SrcBuffer,			// Input array 					:long Global[NumbersOfPairs*SrcPairReadStep/2]
		nm32s*	DstBuffer,			// Output qunatized array		:long Global[NumbersOfPairs*DstPairWriteStep/2]
			int*	Quantizers,			// Array of two quantizers		:long Local [2/2]; PairOfQuantizers[0,1]=[1,2,3...128]
			int		Count,				// Number of 32-bit elements to be quantized	:=[0,1,2,3...]
			void*	TmpBuffer,			// First  Temporary array		:long Local [NumbersOfPairs]
			int		SrcReadStep=2,		// long to long reading step (in 32-bit words)	:=[-2,0,2,4,6...]
			int		DstWriteStep=2,		// long to long writing step (in 32-bit words)	:=[-2,0,2,4,6...] 
			int		PreShift=0,			// Right preshifting by even number of bits		:=[0,2,4...30]
			bool	UsePostShift=1		// if =0 - Skip result scaling down by 2^19 
			)
{

	int dst=0;
	int src=0;
	int Mul0=DivTable_1_145_18[Quantizers[0]];
	int Mul1=DivTable_1_145_18[Quantizers[1]];
	int PostShift=18*UsePostShift;
	int src0;
	int src1;
	for (int i=0;i<Count/2;i++)
	{
		src0=SrcBuffer[src];
		src1=SrcBuffer[src+1];

		DstBuffer[dst]	=((src0>>PreShift)*Mul0+0x20000)>>PostShift;
		DstBuffer[dst+1]=((src1>>PreShift)*Mul1+0x20000)>>PostShift;
		dst+=DstWriteStep;
		src+=SrcReadStep;
	}
}
// DESCRIPTION:
//
// Quantization of array of 32-bit signed words.
// Numbers are quntized only by pairs, packed in 64-bit words.
// Numbers placed at odd addresses are quantized by first divisor (Quantizers[0]) and
// numbers placed at even addresses are quantized by second divisor (Quantizers[1]).
// Quantization may be performed by sampling with specified spacing between pairs.
// Results are stored also by pair, packed in 64-bit words.
// The write step of pairs also can be specified.
// By default both steps are equal to 2.
// Operation of this  function may be descibed in next equivalent form:
// for(int i=0,j=0,n=0;n<NumbersOfPairs;n++,i+=SrcReadStep,j+=DstWriteSpep)
// {
//		Dst32bit[j]  =Src32bit[i]  /PairOfQuantizers[0];
//		Dst32bit[j+1]=Src32bit[i+1]/PairOfQuantizers[1];
// }
#ifdef __cplusplus
		};
#endif