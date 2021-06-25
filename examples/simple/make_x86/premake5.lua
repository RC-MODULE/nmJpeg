#!lua
ROOT = "../../.."
-- A solution contains projects, and defines the available configurations
  solution "test-x86"		 
	configurations { "Debug", "Release" }
	platforms {"x86"}
	project "test-x86"
      kind "ConsoleApp"
      language "C++"
      files { "../*.cpp" }
	  
	  libdirs { "$(NMPP)/lib",ROOT.."/lib"}
	  includedirs { "$(NMPP)/include",ROOT.."/include"}
	  systemversion 'latest'
      configuration "Debug"
		links { "nmpp-x86d","nmjpeg-x86d"} 
        defines { "DEBUG" }
        symbols  "On" 
		 
		 

      configuration "Release"
		links { "nmpp-x86","nmjpeg-x86"} 
         defines { "NDEBUG" }
         symbols  "Off" 
		 

