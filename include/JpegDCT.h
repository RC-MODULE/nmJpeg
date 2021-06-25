#ifndef __INTERNAL_H_INCLUDED
#define __INTERNAL_H_INCLUDED

#include "nmplv.h"
#include "nmtype.h"
#include "vlc.h"

#ifdef __cplusplus
		extern "C" {
#endif

//*****************************************************************************

	/** 
    * \if Russian
    *     \defgroup JpgDct DCT
    * \endif
    * \if English
    *     \defgroup JpgDct DCT
    * \endif
    * \ingroup iJPEG
    */

//*****************************************************************************

//*****************************************************************************

	/**
	\defgroup nmjpegFwdDct8x8 nmjpegFwdDct8x8
	\ingroup JpgDct
	\brief
		\ru Дискретно-косинусное преобразование изображения.
		\en Discrete cosine transform of image.

	\ru Двумерное дискретное косинусное преобразование (ДКП) вычисляется для каждого блока размером 8х8.
	  Функция работает с макроблоками, содержащими 4 соседних блока размером 8х8, каждый из которых
		состоит из элементов типа char.
		На вход подается изображение в виде двумерного массива размером nWidth*nHeight, содержащего
		8-битовые знаковые элементы [-128..+127].
		Выходные данные обрабатываются в порядке следования макроблоков 16х16. Макроблоки берутся из входного
		изображения в порядке слева направо и сверху вниз, начиная с верхнего левого угла.
		В каждом макроблоке 4 блока размером 8х8 преобразуются дискретным 
		косинусным преобразованием и сохраняются один за одним в виде непрерывных одномерных массивов.
		В среднем получается 3.42 такта на элемент при использовании процессора NM6403.
	\en	2D - Forward Discrete Cosine Transform(DCT) computation under each 8x8 block of the  frame.
		The function operates with macroblocks consisted from 
		four neighbouring blocks of 8x8 SIGNED CHAR elements.
		On input it takes Frame considered as a 2D array Width*Height of 8-bit SIGNED elements [-128..+127].
		Output data is stored as a sequence of macroblocks 16х16. Macroblocks are taken from input Image 
		in left-to-right and top-down scan order. In each macroblock four blocks are transformed by DCT
		and separatly stored one after another with the same inner scan order.
		In average it takes 3.42 clocks per pixel using the NM6403 processor

	\~
	\param pSrcImg   
		\ru Входное изображения. 
		\en Input Frame
	\param pDstImg   
		\ru ДКП коэффициенты изображения.
		\en Result DCT
	\param nWidth   
		\ru Ширина изображения в пикселях. nWidth=[16,32,48...]
		\en Frame width in pixels. nWidth=[16,32,48...]
	\param nHeight   
		\ru Высота изображения в пикселях. nHeight=[16,32,48...]
		\en Frame height. nHeight=[16,32,48...]
	\param pTmpBuf   
		\ru Временный буфер размера	nm64u[nWidth*nHeight/2]
		\en Temporary buffer  of size nm64u[nWidth*nHeight/2]
  \return \e void

    \par
    \xmlonly
        <testperf> 
             <param> pSrcImg </param> <values> L G </values>
             <param> pDstImg </param> <values> L G </values>
             <param> pTmpBuf </param> <values> L G </values>
             <param> nHeight </param> <values> 64 </values>
             <param> nWidth </param> <values> 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
        <testperf> 
             <param> pSrcImg </param> <values> G </values>
             <param> pDstImg </param> <values> L </values>
             <param> pTmpBuf </param> <values> G </values>
             <param> nHeight </param> <values> 16 32 64 </values>
             <param> nWidth </param> <values> 16 32 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
    \endxmlonly
	*/
	//! \{
void nmjpegFwdDct8x8( nm8s* pSrcImg, nm32s* pDstImg, int nWidth, int nHeight, void* pTmpBuf);
	//! \note 
	//!	\ru Функция c нормализации результата (производится масштабирющий сдиг на 20 бит вправо ).
	//!	\en Scale down by 20 bit right shift will be performed
//void nmjpegFwdDct8x8(nm8s* pSrcImg, nm32s* pDstImg, int nWidth, int nHeight, void* pTmpBuf);
	//! \note 
	//!	\ru Функция без нормализации результата (масштабирющий сдиг вправо не производится).
	//!	\en No scale down by right shift will be performed
	//! \}
void nmjpegFwdDct8x8Sec( nm8s*  pSrcBlocks8x8, nm32s* pDctBlocks8x8, int nBlocks, void* pTmpBuf);
void nmjpegInvDct8x8Sec( nm16s* pDctBlocks8x8, nm32s* pDstBlocks8x8, int nBlocks, void* pTmpBuf);
//*****************************************************************************
/**
	\defgroup nmjpegInvDct8x8 nmjpegInvDct8x8
	\ingroup JpgDct
	\brief
		\ru Обратное дискретно-косинусное преобразование изображения.
		\en Inverse discrete cosine transform of image.

	\ru 
	  Двумерное обратное дискретное косинусное преобразование (ОДКП) вычисляется для каждого блока
	  размером 8х8 с помощью ДКП. В среднем получается 4.13 тактов на пиксел при использовании 
	  процессора NM6403.
	\en	2D - Inverse Discrete Cosine Transform(iDCT) computation under each 8x8 block produced by DCT.
		In average it takes 4.13 clocks per pixel using the NM6403 processor

	\~
	\param pSrcImg   
		\ru ДКП коэффициенты изображения.
		\en DCT coefficients
	\param pDstImg   
		\ru Восстановленое изображение. 
		\en Reconstructed frame
	\param nWidth   
		\ru Ширина изображения в пикселях. nWidth=[16,32,48...]
		\en Frame width in pixels. nWidth=[16,32,48...]
	\param nHeight   
		\ru Высота изображения в пикселях. nHeight=[16,32,48...]
		\en Frame height. nHeight=[16,32,48...]
	\param pTmpBuf   
		\ru Временный буфер размера	nm64u[nWidth*nHeight/2]
		\en Temporary buffer  of size nm64u[nWidth*nHeight/2]
	\return \e void


    \par
    \xmlonly
        <testperf> 
             <param> pSrcImg </param> <values> L G </values>
             <param> pDstImg </param> <values> L G </values>
             <param> pTmpBuf </param> <values> L G </values>
             <param> nHeight </param> <values> 64 </values>
             <param> nWidth </param> <values> 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
        <testperf> 
             <param> pSrcImg </param> <values> G </values>
             <param> pDstImg </param> <values> L </values>
             <param> pTmpBuf </param> <values> G </values>
             <param> nHeight </param> <values> 16 32 64 </values>
             <param> nWidth </param> <values> 16 32 64 </values>
             <size> nWidth*nHeight </size>
        </testperf>
    \endxmlonly


	*/
	//! \{

 void nmjpegInvDct8x8( nm16s* pSrcImg, nm32s*		pDstImg, int	nWidth,	int	 nHeight, void* pTmpBuf	);
	//! \}

//*****************************************************************************

/**
*	\if Russian
*		\defgroup iZigzagReodering Зиг-заг переупорядочивание
*	\endif
*	\if English
*		\defgroup iZigzagReodering Zig-zag reodering
*	\endif
*	\ingroup iReodering
*	\brief 
*		\ru Зиг-заг перупорядочивание последовательности блоков.
*		\en Zig zag reodering of block sequence.
*	 
*/

//*****************************************************************************

	/**
	\defgroup nmjpegFwdZigZag8x8 nmjpegFwdZigZag8x8
	\ingroup iZigzagReodering
	\brief
		\ru Переупорядочивание пикселей последовательности блоков методом зиг-заг.
		\en

	\~
	\param pSrcBlockSeq
	  \ru входной массив в нормальном порядке
		\en Input array in normal order
	\param pDstBlockSeq
	  \ru выходной массив в зиг-заговом порядке
		\en Output Array in Z-order
	\param nBlocks
	  \ru Число блоков размером 8х8 :nBlocks=[4,8,12....]
		\en Number of 8x8 Blocks :nBlocks=[4,8,12....]
	\param nPreShift
	  \ru Количество бит, но которое производится предварительный сдвиг вправо : =[0,2,4...30]
		\en Preceding scale down by right shift by nPreShift bits : =[0,2,4...30]
	\param fUseCharClip
	  \ru Если не 0, результаты обрезаются до диапазона [-2^fUseCharClip...+2^fUseCharClip-1]
		\en if !=0 Clipping of results in range [-2^fUseCharClip...+2^fUseCharClip-1]
  \return \e void

	\note
	  \ru nBlocks принимает значение 4,8,12....; nPreShift принимает значение [0,2,4...30];
        fUseCharClip принимает значение [1,2,3,..31]
		\en nBlocks=[4,8,12....]; nPreShift=[0,2,4...30]; fUseCharClip=[1,2,3,..31]

    \par
    \xmlonly
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L G </values>
             <param> pDstBlockSeq </param> <values> L G </values>
             <param> nBlocks </param> <values> 1024 </values>
             <param> nPreShift </param> <values> 0 </values>
             <param> fUseCharClip </param> <values> 0 </values>
             <size> nBlocks </size>
        </testperf>
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L </values>
             <param> pDstBlockSeq </param> <values> G </values>
             <param> nBlocks </param> <values> 8 128 1024 </values>
             <param> nPreShift </param> <values> 0 </values>
             <param> fUseCharClip </param> <values> 0 </values>
             <size> nBlocks </size>
        </testperf>
    \endxmlonly


	*/
	//! \{
void nmjpegFwdZigZag8x8(int* pSrcBlockSeq, int* pDstBlockSeq,	int	nBlocks, int	nPreShift=0, int	fUseCharClip=0 );
	//! \}

//*****************************************************************************

	/**
	\defgroup nmjpegInvZigZag8x8 nmjpegInvZigZag8x8
	\ingroup iZigzagReodering
	\brief
		\ru Обратное переупорядочивание пикселей последовательности блоков методом зиг-заг.

	\~
	\param pSrcBlockSeq
	  \ru входной массив в зиг-заговом порядке
		\en Array in Z-order
	\param pDstBlockSeq
	  \ru результирующий массив в нормальном порядке
		\en Result array in normal order
	\param nBlocks
	  \ru Число блоков размером 8х8
		\en Number of 8x8 Blocks
  \return \e void
	\restr 
	  \ru nBlocks может принимать значения 1, 2, 3,...
		\en nBlocks=[1,2,3..]

    \par
    \xmlonly
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L G </values>
             <param> pDstBlockSeq </param> <values> L G </values>
             <param> nBlocks </param> <values> 32 </values>
             <size> nBlocks*64 </size>
        </testperf>
        <testperf> 
             <param> pSrcBlockSeq </param> <values> L </values>
             <param> pDstBlockSeq </param> <values> G </values>
             <param> nBlocks </param> <values> 8 32 64 </values>
             <size> nBlocks*64 </size>
        </testperf>
    \endxmlonly

	*/
	//! \{
 void nmjpegInvZigZag8x8(int*	pSrcBlockSeq, int*	pDstBlockSeq, int nBlock);
	//! \}

//*****************************************************************************

#ifdef __cplusplus
};
#endif

#endif
