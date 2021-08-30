ROOT = ../../..
#include $(ROOT)/global.mk
#-include ../local.mk
HEAP ?= -heap=6384 -heap1=16384 -heap2=16384 -heap3=16384
# BUILD AND RUN MAKEFILE
# This makefile builds simple nmc-application containing single cpp-file  
# Rule 'run' executes the application on MC5103 board and stores return code in ".exitcode"  file

.SUFFIXES:


ifndef MC5103
$(error ERROR: 'MC5103' environment variable is not defined!  )
endif 


BOARD    = mc5103
TARGET   = main.abs
INC_DIRS = -I"$(MC5103)/include" -I$(ROOT)/include -I"$(NEURO)/include" -I$(NMPP)/include
LIB_DIRS = -L"$(MC5103)/lib" -L$(ROOT)/lib -L$(NMPP)/lib -L$(HAL)/lib
LIBS     = mc5103lib.lib nmjpeg-nmc3.lib nmpp-nmc3.lib hal-mc5103.lib libint05.lib libc05.lib cppnew05.lib
CFG      = mc5103brd.cfg
SRC_CPP  = $(wildcard $(addsuffix /*.cpp,..))
SRC_ASM  = $(wildcard $(addsuffix /*.asm,..))




$(TARGET): $(SRC_CPP) $(SRC_ASM) $(CFG) 
	nmcc -Tc99 -o$(TARGET) -m.main.map $(SRC_CPP) $(SRC_ASM) -nmc3 -g -O0 $(INC_DIRS) $(LIB_DIRS) $(LIBS) -c$(CFG) -heap=17000 -heap1=30000 -heap2=30000 -heap3=30000 $(ERRECHO) -Tc99

#$(ROOT)/lib/nmjpeg-nmc3.lib
#nmcpp ../main.cpp -Tc99 -nmc3  $(INC_DIRS) -Omain.asm

PATH:=$(MC5103)/bin;$(PATH)


$(ROOT)/lib/nmjpeg-nmc3.lib: FORCE
	cd $(ROOT)/make/jpeg-nmc3 && $(MAKE) clean && $(MAKE) -f legacy.mk
	
FORCE:
	
run: $(TARGET) 
	mc5103run $(TARGET) --recv_file_name=out.jpg --recv_sect=.jpegout.bss --recv_size=0x400
	
#	mc5103run $(TARGET) --recv_file_name=out.jpg --recv_sect=.jpegout.bss --recv_size=1000

clean:
	-$(OS_RM) *.abs *.elf *.ncb *.map *.elf *.suo *.user *.filters
	-$(OS_RD) bin obj
	
kill: clean
	-$(OS_RM) *.vcproj *.sln *.vcxproj
	
vs2005:	$(HOST).vcproj

$(HOST).vcproj:
	premake5 vs2005
	