

#ifdef __GNUC__ //  NMC-GCC C++ compilier 
	#define IN_DATA_SECTION(sec) __attribute__((section(sec)))
	#define IN_CODE_SECTION(sec) __attribute__((section(sec)))
#else 			// legacy NMSDK C++ compiler
	#define DO_PRAGMA(x) _Pragma (#x)
	#define IN_DATA_SECTION(sec) DO_PRAGMA(data_section sec)
	#define IN_CODE_SECTION(sec) DO_PRAGMA(code_section sec)
#endif 
