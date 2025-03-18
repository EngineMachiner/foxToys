
local path = "/Appearance/Themes/_fallback/Modules/foxToys/"

if tapLua.isLegacy() then path = "/Modules/foxToys/" end

foxToys = {

    Path = path,

    Load = function( path, ... )

        local endsWith = path:Astro():endsWith("%.lua")

        local path = endsWith and path or path .. "/default.lua"

        return LoadModule( "foxToys/" .. path, ... )

    end
    
}