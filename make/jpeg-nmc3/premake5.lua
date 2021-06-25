#!lua
--require "src-dirs"
ROOT = "../.."
						
-- array = {"Lua", "Tutorial"}
						
SRC =  	 	"../../src/common/*.cpp","../../src/nm/*.cpp","../../src/nm/*.asm"

print (SRC[0]);
-- A solution contains projects, and defines the available configurations
solution "jpeg-nmc3"
   configurations { "Debug", "Release" }

	project "jpeg-nmc3"
      kind "Makefile"
	  
      files { "../../include/include/*.h", "Makefile", "../../src/common/*.cpp","../../src/nm/*.cpp","../../src/nm/*.asm"}
	 
	  configuration "Debug"
		   buildcommands {"make DEBUG=y -f Makefile"}
		   rebuildcommands {"make -B DEBUG=y -f Makefile"}
		   cleancommands {"make clean"}
		   
	  configuration "Release"
		   buildcommands {"make -f Makefile"}
		   rebuildcommands {"make -B -f Makefile"}
		   cleancommands {"make clean"}		   
		
		
		