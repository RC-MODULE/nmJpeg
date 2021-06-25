//------------------------------------------------------------------------
//
//  $Workfile:: iJPEG.h  $
//
//  ��������-��������� ����������
//
//  Copyright (c) RC Module Inc.
//
//  $Revision: 1.1 $      $Date: 2005/02/10 12:36:37 $
//
//! \if file_doc
//!
//! \file   iJPEG.h
//! \author S.Landyshev
//! \brief  Definition of JPEG Library functions                         
//!
//! \endif
//!
//------------------------------------------------------------------------

#ifndef _InmjpegH_
#define _InmjpegH_

#include "nmtype.h"

#ifdef __cplusplus
		extern "C" {
#endif


//*****************************************************************************
	/** 
    *  \defgroup iJPEG JPEG main functions
    */

	/** 
		* \~
    * \ru
    *     \defgroup iJPEG JPEG ������
    * \en
    *     \defgroup iJPEG JPEG compression
    * \~
    */
  
  
  /** 
    * \if Russian
    *     \defgroup iJPEG_Main iJPEG_Main
    *			\ingroup iJPEG
    * \endif
    * \if English
    *     \defgroup iJPEG_Main iJPEG_Main
    *			\ingroup iJPEG
    * \endif
    */
    

//*****************************************************************************
	/**
	\defgroup nmjpegInit nmjpegInit
	\ingroup iJPEG
	\brief 
		\ru �������������. ���������� ������.
        \en Initialization. Called first.
	
	\~
	\param pnDCTable
	    \ru ����� ��� �������� ������� ����.
            ���������� ����� �� ����� ���� ����������� �� ��������� ������
            � ��������� ��� ������ JPEG.
            ������ ������ - �� ����� 4608 32-���. ����. 
		\en Buffer for code words.
            Size of the buffer must to be not less than 4608 32-bit words.
	\param pnACTable
	    \ru ����� ��� �������� ������� ���� ��� ����������� AC �������������.
            ������ ������ - �� ����� 4096 32-���. ����. 
		\en Buffer of code words for the coding of AC.
            Size of buffer must to be not less than 4096 32-bit words.
    \return \e void

	*/
	//! \{
void nmjpegInit(int *pnCWBuffer);
	//! \}


	/**
	\defgroup nmjpegCompress nmjpegCompress
	\ingroup iJPEG_Main
	\brief 
		\ru ������ ����������� ������� JPEG.
        \en Image compressing by JPEG standard.
	
	\~
	\param pcSrc
	    \ru �������� �����������.
		\en Image bytes.
	\param pcDst
	    \ru �������������� �����������. ������ ������� ������ ���� nHeight*nWidth 32�. ����
		\en Result buffer (compressed data). Size of array must be equal nHeight*nWidth 32bit words
    \param nWidth
	    \ru ������ ����������� � ��������. ������ ���� ������ 16
		\en Image width. Must be divisible by 16
	\param nHeight
	    \ru ������ ����������� � ��������. ������ ���� ������ 16
		\en Image height. Must be divisible by 16
    \param nQuality
        \ru �������� (�������) ������. ���������� �������� - 0, 1, 2, 3, 4.
            0 - ������� ��������. ����������� ������� ������.
            2 - ������� ��������.
            4 - ������ ��������. ������������ ������� ������.
        \en Quality of compression.
            0 - High quality. Minimum degree of compression.
            2 - Average quality.
            4 - Low quality. Maximum degree of compression.
	\param pnQuantTable
	    \ru ������� ����������� (64 ��������).
			����������� �������� �������� ������� = 8.	
            ������������ �������� �������� ������� = 131.
		\en Table of quantizers (64 elements).
			Minimum value of element tables = 8.
            Maximum value of element tables = 131.
	\param pvTmp1
	    \ru ��������� �����.
            ������ ������ - �� ����� (nWidth * nHeight) 32-���. ����. 
		\en Temporary buffer.
            Size of the buffer must to be not less than (nWidth * nHeight) 32-bit words.
	\param pvTmp2
	    \ru ��������� �����.
            ������ ������ - �� ����� (nWidth * nHeight) 32-���. ����.
		\en Temporary buffer.
            Size of the buffer must to be not less than (nWidth * nHeight) 32-bit words.
    \return \e int
	    \ru ������ ������� ����������� � ������.
		\en Size of compressed image in bytes.

    

	*/
 
//   \par
//    \xmlonly
//        <testperf> 
//            <param> pcSrc </param> <values> L G </values>
//            <param> pcDst </param> <values> L G </values>
//            <param> pnQuantTable </param> <values> QuantTable </values>
//            <param> pvTmp1 </param> <values> L1 G1 </values>
//            <param> pvTmp2 </param> <values> L1 G1 </values>
//            <param> nQuality </param> <values> 2 </values>
//            <param> nHeight </param> <values> 64 </values>
//            <param> nWidth </param> <values> 64 </values>
//            <size> nWidth*nHeight </size>
//        </testperf>
//        <testperf> 
//            <param> pcSrc </param> <values> L </values>
//            <param> pcDst </param> <values> G </values>
//            <param> pnQuantTable </param> <values> QuantTable </values>
//            <param> pvTmp1 </param> <values> G1 </values>
//            <param> pvTmp2 </param> <values> L1 </values>
//            <param> nQuality </param> <values> 0 1 2 3 4 </values>
//            <param> nHeight </param> <values>  256 </values>
//            <param> nWidth </param> <values>  256 </values>
//            <size> nWidth*nHeight </size>
//        </testperf>
//    \endxmlonly

	//! \{
int nmjpegCompressCustom(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight, unsigned int *pnQuantTable, void *pvTmp1, void *pvTmp2);

int nmjpegCompress(nm8u* pSrc, nm8u* pDst, int nWidth, int nHeight, int nQuality, void *pvLTmp, void *pvGTmp);


	//! \}


//			<init> 
//					int* InitData;
//					VEC_Malloc(&InitData, 4096, MEM_GLOBAL);
//					nmjpegInit((int *) InitData);
//					unsigned int QuantTable[64];
//					VEC_Fill(QuantTable,32,64);
//			</init>

	/**
	\defgroup nmjpegGetHeader nmjpegGetHeader
	\ingroup iJPEG_Main
	\brief 
		\ru ��������� ��������� JPEG.
        \en Getting of JPEG header.
	
	\~
	\param pcHeader
	    \ru �������� ������ ��� ������ ���������.
            ������ ������� - �� ����� 560 ������. 
		\en Output array for writing a header.
            Size of the array must to be not less than 560 bytes.
    \param pnQuantTable
	    \ru ������� ����������� (64 ��������).
			����������� �������� �������� ������� = 8.	
            ������������ �������� �������� ������� = 131.
		\en Table of quantizers (64 elements).
			Minimum value of element tables = 8.
            Maximum value of element tables = 131.
    \param nWidth
	    \ru ������ ����������� � ��������.
		\en Image width.
	\param nHeight
	    \ru ������ ����������� � ��������.
		\en Image height.
    \return \e int
	    \ru ������ ��������� � ������.
		\en Header size in bytes.
*/

//    \par
//    \xmlonly
//        <testperf> 
//						<init> unsigned int QuantTable[64];
//for(int i=0; i&lt;64; i++)
//QuantTable[i]=(unsigned int)SCL_Rand(8, 131);
//						</init>
//            <param> pcHeader </param> <values> L G </values>
//            <param> pnQuantTable </param> <values> QuantTable </values>
//            <param> nQuality </param> <values> 0 </values>
//            <param> nHeight </param> <values> 64 </values>
//            <param> nWidth </param> <values> 64 </values>
//            <size> nWidth*nHeight </size>
//        </testperf>
//        <testperf> 
//						<init> unsigned int QuantTable[64];
//for(int i=0; i&lt;64; i++)
//QuantTable[i]=(unsigned int)SCL_Rand(8, 131);
//						</init>
//            <param> pcHeader </param> <values> L </values>
//            <param> pnQuantTable </param> <values> QuantTable </values>
//            <param> nQuality </param> <values> 0 1 2 3 4 </values>
//            <param> nHeight </param> <values> 64 </values>
//            <param> nWidth </param> <values> 64 256 </values>
//            <size> nWidth*nHeight </size>
//        </testperf>
//    \endxmlonly





	//! \{
int nmjpegGetHeaderCustom(char *pcHeader, unsigned int *pnQuantTable, int nWidth, int nHeight);
int nmjpegGetHeader(char *pcHeader, int nQuality, int nWidth, int nHeight);
	//! \}

	/**
	\defgroup nmjpegGetBitstream nmjpegGetBitstream
	\ingroup iJPEG_Main
	\brief 
		\ru ������ ����������� ������� JPEG. 
            �������������� ������ �������� ������ ������ ����������� ��� ��������� JPEG.
        \en Image compressing by JPEG statdard.
            Output buffer is kept only compressed image without the JPEG header.
	
	\~
	\param pcSrc
	    \ru �������� �����������.
		\en Image bytes.
	\param pcDst
	    \ru �������������� �����������. ������ ������� ������ ���� nHeight*nWidth 32�. ����
		\en Result buffer (compressed data). Size of array must be equal nHeight*nWidth 32bit words
    \param nWidth
	    \ru ������ ����������� � ��������.
		\en Image width.
	\param nHeight
	    \ru ������ ����������� � ��������.
		\en Image height.
    \param nQuality
        \ru �������� (�������) ������. ���������� �������� - 0, 1, 2, 3, 4.
            0 - ������� ��������. ����������� ������� ������.
            2 - ������� ��������.
            4 - ������ ��������. ������������ ������� ������.
        \en Quality of compression.
            0 - High quality. Minimum degree of compression.
            2 - Average quality.
            4 - Low quality. Maximum degree of compression.
	\param pnQuantTable
	    \ru ������� ����������� (64 ��������).
			����������� �������� �������� ������� = 8.	
            ������������ �������� �������� ������� = 131.
		\en Table of quantizers (64 elements).
			Minimum value of element tables = 8.
            Maximum value of element tables = 131.
    \param nDstOffset
        \ru �������� ������������ ������ pcDst � 32-� ���. ������, ���� ����� ������� ���������.
            � ������� ����� ��������� ����� �����������, ��������, 
            ������� ��������� � ������ ������.
        \en Offset comparatively beginning pcDst in 32-bits words to write result.
            By means of this parameter possible to realize, for instance, 
            insertion of header in compressed data.
	\param pvTmp1
	    \ru ��������� �����.
            ������ ������ - �� ����� (nWidth * nHeight) 32-���. ����. 
		\en Temporary buffer.
            Size of the buffer must to be not less than (nWidth * nHeight) 32-bit words.
	\param pvTmp2
	    \ru ��������� �����.
            ������ ������ - �� ����� (nWidth * nHeight ) 32-���. ����.
		\en Temporary buffer.
            Size of the buffer must to be not less than (nWidth * nHeight) 32-bit words.
    \return \e int
	    \ru ������ ������� ����������� � ������.
		\en Size of compressed image in bytes.

   

	*/

//    \par
//    \xmlonly
//        <testperf> 
//						<init> unsigned int QuantTable[64];
//for(int i=0; i&lt;64; i++)
//QuantTable[i]=(unsigned int)SCL_Rand(8, 131);
//						</init>
//            <param> pcSrc </param> <values> L G </values>
//            <param> pcDst </param> <values> L G </values>
//            <param> pvLTmp </param> <values> L G </values>
//            <param> pvGTmp </param> <values> L G </values>
//            <param> pnQuantTable </param> <values> QuantTable </values>
//            <param> nDstOffset </param> <values> 0 </values>
//            <param> nQuality </param> <values> 0 </values>
//            <param> nHeight </param> <values> 64 </values>
//            <param> nWidth </param> <values> 64 </values>
//            <size> nWidth*nHeight </size>
//        </testperf>
//        <testperf> 
//						<init> unsigned int QuantTable[64];
//for(int i=0; i&lt;64; i++)
//QuantTable[i]=(unsigned int)SCL_Rand(8, 131);
//						</init>
//            <param> pcSrc </param> <values> L </values>
//            <param> pcDst </param> <values> G </values>
//            <param> pvLTmp </param> <values> G </values>
//            <param> pvGTmp </param> <values> G </values>
//            <param> pnQuantTable </param> <values> QuantTable </values>
//            <param> nDstOffset </param> <values> 0 1 2 </values>
//            <param> nQuality </param> <values> 0 1 2 3 4 </values>
//            <param> nHeight </param> <values> 64 </values>
//            <param> nWidth </param> <values> 64 256 </values>
//            <size> nWidth*nHeight </size>
//        </testperf>
//    \endxmlonly




	//! \{
int nmjpegGetBitstreamCustom(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight, int nDstOffset, unsigned int *pnQuantTable, void *pvLTmp, void *pvGTmp);
int nmjpegGetBitstream(nm8u *pcSrc, nm8u *pcDst, int nWidth, int nHeight, int nDstOffset, int nQuality, void *pvLTmp, void *pvGTmp);
    //! \}

//*****************************************************************************
#ifdef __cplusplus
};
#endif


#endif //_InmjpegH_
