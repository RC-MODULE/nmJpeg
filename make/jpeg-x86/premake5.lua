#!lua
-- https://premake.github.io/
ROOT = "../.."
-- A solution contains projects, and defines the available configurations
solution "nmjpeg-pc"
    configurations { "Release", "Debug" }
	
	filter {"system:linux", "action:gmake*"}
		platforms { "x86","x64"}
  
	filter {"system:windows", "action:gmake*"}
		platforms { "x86","x64"}

	filter {"system:windows", "action:vs*"}
		platforms { "x86","x64"}
		systemversion ="latest"
		
      	
	project "nmjpeg"
	  --objdir ("o")
		kind "StaticLib"
		
	  files { ROOT.."../include/*.h",
		ROOT.."/src/common/*.cpp",
		ROOT.."/src/pc/*.cpp"
		}
		
		includedirs { ROOT.."/include","$(NMPP)/include"}
		  
		targetdir (ROOT.."/lib")
		
		
		configuration {"Debug","x86"}
			targetsuffix ("-x86d")
			architecture "x86"
			defines { "DEBUG"}
			symbols  ="On" 
			objdir "1"
		
		configuration {"Release","x86"}
			targetsuffix ("-x86")
			architecture "x86"
			defines { "NDEBUG"}
			symbols  ="Off" 
			objdir "2"
		
		configuration {"Debug","x64"}
			targetsuffix ("-x64d")
			architecture "x86_64"
			defines { "DEBUG"}
			symbols  ="On" 
			objdir "3"
		
		configuration {"Release","x64"}
			targetsuffix ("-x64")
			architecture "x86_64"
			defines { "NDEBUG"}
			symbols  ="Off" 
			objdir "4"
	 
 
