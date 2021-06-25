ROOT = ../../..
ifeq ($(OS),Windows_NT)
SHELL = cmd
-include nmc4vars_win.mk
endif
-include $(ROOT)/clean.mk
NMPP?=$(ROOT)
.SUFFIXES:

BOARD = mc5103
BSP = $(MC5103)
ifndef MC5103
$(warning *** WARNING: 'mc5103' environment variable is not defined! Board SDK might not have installed correctly. )
endif 

PROJECT  = main
TARGET   = $(PROJECT).abs

CC       = nmc-g++
AS       = nmc-gcc 
CXXFLAGS = -std=c++11 -O2 -Wall -mnmc3
LIBS     = -lnmjpeg-nmc3 -lnmpp-nmc3 -lhal-$(BOARD)  -lc  -Wl,--whole-archive -l$(BOARD)lib  -Wl,--no-whole-archive

#-l$(BOARD)lib
CFG      = $(BOARD)brd.cfg
MAP      = $(PROJECT).map

LDFLAGS  = -Wl,-Map=$(MAP) -Wl,-c$(CFG) 

INC_DIRS = -I"$(BSP)/include" -I"$(NMPP)/include" -I"$(HAL)/include" -I$(ROOT)/include
#LIB_DIRS = -L"$(BSP)/lib"     -L"$(NMPP)/lib"     -L"$(HAL)/lib" 	 -L$(ROOT)/lib -L"$(NMCGCC)/lib" -L"$(NMCGCC)/nmc/lib/nmc4"
LIB_DIRS = -L"$(BSP)/lib"     -L"$(NMPP)/lib"     -L"$(HAL)/lib" 	 -L$(ROOT)/lib -L"$(NMCGCC)/lib" -L"$(NMCGCC)/nmc/lib/nmc3"
SRC_DIRS = ..
SRC_CPP  = $(wildcard $(addsuffix /*.cpp,$(SRC_DIRS)))
SRC_ASM  = $(wildcard $(addsuffix /*.asm,$(SRC_DIRS)))
SRC_C    = $(wildcard $(addsuffix /*.c,$(SRC_DIRS)))
SRC_ALL  = $(SRC_CPP) $(SRC_ASM) $(SRC_C)

.DEFAULT_GOAL := $(TARGET)

$(TARGET): $(SRC_ALL) Makefile
	$(CC) -o$(TARGET) $(CXXFLAGS) $(LDFLAGS) $(SRC_ALL) $(INC_DIRS) $(LIB_DIRS) $(LIBS) $(ERRECHO)

#PATH:=$(BSP)/bin;$(PATH)

run: $(TARGET)
	mc5103run $(TARGET)
#	--recv_file_name=out.jpg --recv_sect=.jpegout --recv_size=0x100

#$(MAKE) -f legacy.mk run

qemu:	
	$(MAKE) LIBS="-lnmpp-nmc3 -lc " -B TARGET=$(TARGET)_qemu
	nmc-qemu $(TARGET)_qemu
	
nmc4vars_win.mk:
	copy "$(NMC_GCC_TOOLPATH)\nmc4-ide\include\nmc4vars_win.mk" nmc4vars_win.mk

legacy:
	$(MAKE) -f legacy.mk
	
vs2015:
	premake5 vs2015
	
vs2008:
	premake5 vs2008		