foxToys = {

    Path = "/Appearance/Themes/_fallback/Modules/foxToys/",

    Load = function( path, ... )

        return LoadModule( "foxToys/" .. path .. "/default.lua", ... )

    end
    
}