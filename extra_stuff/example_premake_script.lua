workspace "Quarrel"
	configurations { "Development" }

	language "C++"

	location "Generated"
	
	targetdir "Build/%{prj.name}"
	targetname "%{prj.name}_%{cfg.longname}"
	objdir "Build/Obj/%{prj.name}/%{cfg.longname}"
	debugdir "Build/%{prj.name}"

	configuration "vs*"
		defines { "_CRT_SECURE_NO_WARNINGS", "_ITERATOR_DEBUG_LEVEL=0" }

	filter "configurations:Development"
		symbols "On"
		optimize "On"

	filter()

	flags 
	{ 
		"FatalCompileWarnings", 
		"MultiProcessorCompile", 
		"LinkTimeOptimization", 
		"C++14" 
	}

	debugformat "c7"

	-- TODO: Avoid repetition by making functions for including/linking things.

-- Project containing all the game-specific code.
project "Quarrel"
	kind "ConsoleApp"
	files { "Source/Quarrel/**" }
	includedirs 
	{ 
		"Source/QuarrelLib",
		"C:/SFML-2.3.2/SFML-2.3.2-windows-vc14-32-bit/include",
		"External/ImGui",
		"External/json", 
		"External/spdlog/include",
		"External/Box2D",
		"External/Optional"
	}
	libdirs
	{
		"External/SFML/Lib/%{cfg.longname}"
	}
	links
	{
		"QuarrelLib",
		"Box2D", 
		"sfml-system", "sfml-window", "sfml-graphics", "sfml-audio", "opengl32"
	}

-- Arguably Box2D could just be built as part of QuarrelLib. Maybe I'll do that.
project "Box2D"
	kind "StaticLib"
	files { "External/Box2D/Box2D/**.h", "External/Box2D/Box2D/**.cpp" }
	includedirs { "External/Box2D" }

-- Library project containing all the engine code.
project "QuarrelLib"
	kind "StaticLib"
	files { "Source/QuarrelLib/**", "External/ImGui/**.h", "External/ImGui/**.cpp" }
	includedirs 
	{
		"C:/SFML-2.3.2/SFML-2.3.2-windows-vc14-32-bit/include",
		"External/json",
		"External/spdlog/include",
		"External/Box2D",
		"External/ImGui",
		"External/cxxopts",
		"External/Optional"
	}

-- A project containing unit tests written using the Catch framework.
project "QuarrelLibTests"
	kind "ConsoleApp"
	files { "Source/QuarrelLibTests/**.cpp", "Source/QuarrelLibTests/**.h" }
	includedirs
	{
		"Source/QuarrelLib",
		"External/Catch",
		"C:/SFML-2.3.2/SFML-2.3.2-windows-vc14-32-bit/include",
		"External/json",
		"External/spdlog/include",
		"External/Box2D",
		"External/ImGui",
		"External/cxxopts"
	}
	libdirs
	{
		"External/SFML/Lib/%{cfg.longname}"
	}
	links
	{
		"QuarrelLib", 
		"opengl32", 
		"Box2D", 
		"sfml-audio", "sfml-graphics", "sfml-system", "sfml-window"
	}
	defines "CATCH_CPP11_OR_GREATER"