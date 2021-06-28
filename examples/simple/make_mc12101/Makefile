ROOT = ../../..
ifeq ($(OS),Windows_NT)
SHELL = cmd
-include nmc4vars_win.mk
endif
-include $(ROOT)/clean.mk
NMPP?=$(ROOT)
.SUFFIXES:

BOARD = mc12101
BSP = $(MC12101)
ifndef MC12101
$(warning *** WARNING: 'mc12101' environment variable is not defined! Board SDK might not have installed correctly. )
endif 

ARCH 	 = nmc4
PROJECT  = main
TARGET   = $(PROJECT)

CC       = nmc-g++
AS       = nmc-gcc 
CXXFLAGS = -std=c++11 -O2 -Wall -m$(ARCH)

LIBS     = -lnmjpeg-$(ARCH) -lnmpp-$(ARCH)  -lhal-$(BOARD)     -Wl,--whole-archive -l$(BOARD)   -Wl,--no-whole-archive  -lc


#CFG     = -c$(BOARD)-nmpu1.cfg
CFG      = -T$(BOARD)-nmpu1.lds
MAP      = $(PROJECT).map

LDFLAGS  = -Wl,-Map=$(MAP) -Wl,$(CFG) 

INC_DIRS = -I"$(BSP)/include" -I"$(NMPP)/include" -I"$(HAL)/include" -I$(ROOT)/include
LIB_DIRS = -L"$(BSP)/lib" 	  -L"$(NMPP)/lib"     -L"$(HAL)/lib" 	 -L$(ROOT)/lib   -L"$(NMCGCC)/lib" -L"$(NMCGCC)/nmc/lib/$(ARCH)"


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
	$(BOARD)run $(TARGET) -p --recv_file_name=out.jpg --recv_sect=.jpegout --recv_size=0x400


qemu:	
	$(MAKE) LIBS="-lnmpp-$(ARCH) -lc " -B TARGET=$(TARGET)_qemu
	nmc-qemu $(TARGET)_qemu
	
nmc4vars_win.mk:
	copy "$(NMC_GCC_TOOLPATH)\nmc4-ide\include\nmc4vars_win.mk" nmc4vars_win.mk

legacy:
	$(MAKE) -f legacy.mk
	
vs2015:
	premake5 vs2015
	
vs2008:
	premake5 vs2008		