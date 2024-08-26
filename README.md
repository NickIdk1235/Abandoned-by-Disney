# Abandoned by Disney
[Friday Night Funkin': Abandoned by Disney](https://gamebanana.com/mods/537937) is an Friday Night Funkin' Fangame, Directed by Juddlee. It is a canon expansion/spinoff of the Abandoned by Disney series, being made with the approval of AbD's author, Slimebeast.
![image](https://github.com/user-attachments/assets/583dc233-dc5b-4209-94fa-ee38cd757cc9)

## Credits:
![CreditsImage](https://github.com/user-attachments/assets/d3282e82-9f2d-44fb-9d4e-9852d50a5ea8)

## Installation:
You must have [the most up-to-date version of Haxe](https://haxe.org/download/), seriously, stop using 4.1.5, it misses some stuff.

Follow a Friday Night Funkin' source code compilation tutorial, after this you will need to install LuaJIT.

To install LuaJIT do this: `haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit` on a Command prompt/PowerShell

...Or if you don't want your mod to be able to run .lua scripts, delete the "LUA_ALLOWED" line on Project.xml


If you get an error about StatePointer when using Lua, run `haxelib remove linc_luajit` into Command Prompt/PowerShell, then re-install linc_luajit.

If you want video support on your mod, simply do `haxelib install hxCodec` on a Command prompt/PowerShell

otherwise, you can delete the "VIDEOS_ALLOWED" Line on Project.xml
_____________________________________
