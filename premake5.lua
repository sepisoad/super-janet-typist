workspace "Super Janet Typist"
   configurations { "Debug", "Release" }

project "game"
   kind "ConsoleApp"
   language "C"
   targetdir "."
   targetname "game"
   files { "src/**.h", "src/**.c" }
   links {"m", "raylib", "dl"}
   buildoptions { "-Wall" }
   
   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"