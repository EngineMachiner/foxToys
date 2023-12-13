foxToys = {

    Load = function( path, ... )

        return LoadModule( "foxToys/" .. path .. "/default.lua", ... )

    end
    
}