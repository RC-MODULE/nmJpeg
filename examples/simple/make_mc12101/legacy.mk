ROOT = ../../..
#include $(ROOT)/global.mk
#-include ../local.mk
HEAP ?= -heap=6384 -heap1=16384 -heap2=16384 -heap3=16384
# BUILD AND RUN MAKEFILE
# This makefile builds simple nmc-application containing single cpp-file  
# Rule 'run' executes the application on MC12101 board and stores return code in ".exitcode"  file

.SUFFIXES:


ifndef MC12101
$(error ERROR: 'MC12101' environment variable is not defined!  )
endif 


BOARD    = mc12101
TARGET   = main.abs
INC_DIRS = -I"$(MC12101)/include" 	-I$(ROOT)/include 	-I$(NMPP)/include	-I"$(NEURO)/include"
LIB_DIRS = -L"$(MC12101)/lib" 		-L$(ROOT)/lib 		-L$(NMPP)/lib 	-L$(HAL)/lib
LIBS     = mc12101lib_nm.lib nmjpeg-nmc4.lib nmpp-nmc4.lib hal-mc12101.lib  libint_6407.lib
CFG      = mc12101-nmpu1.cfg
SRC_CPP  = $(wildcard $(addsuffix /*.cpp,..))
SRC_ASM  = $(wildcard $(addsuffix /*.asm,..))


#$(ROOT)/lib/nmjpeg-nmc4.lib
$(TARGET): $(SRC_CPP) $(SRC_ASM) $(CFG) 
	nmcc -Tc99 -o$(TARGET) -m.main.map $(SRC_CPP) $(SRC_ASM)  -nmc4 -g -O0 $(INC_DIRS) $(LIB_DIRS) $(LIBS) -c$(CFG) -heap=7000 -heap1=30000 -heap2=30000 -heap3=30000  $(ERRECHO) 

PATH:=$(MC12101)/bin;$(PATH)


$(ROOT)/lib/nmjpeg-nmc4.lib: FORCE
	cd $(ROOT)/make/jpeg-nmc4 && $(MAKE) -f legacy.mk
	
FORCE:
	
run: $(TARGET) 
	mc12101run $(TARGET) -p --recv_file_name=out.jpg --recv_sect=.jpegout.bss --recv_size=0x100
	
#	mc12101run $(TARGET) -p  --recv_file_name=out.jpg --recv_sect=.jpegout.bss --recv_size=1000

clean:
	-$(OS_RM) *.abs *.elf *.ncb *.map *.elf *.suo *.user *.filters
	-$(OS_RD) bin obj
	
kill: clean
	-$(OS_RM) *.vcproj *.sln *.vcxproj
	
vs2005:	$(HOST).vcproj

$(HOST).vcproj:
	premake5 vs2005
	