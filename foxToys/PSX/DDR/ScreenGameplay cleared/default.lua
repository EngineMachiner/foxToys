
local function quad()

    return Def.Quad{
        InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end
    }

end

local title = Def.ActorFrame{

    InitCommand=function(self) self:visible(false) end,
    OnCommand=function(self) self:sleep(2.25):queuecommand("Show") end,
    ShowCommand=function(self) self:visible(true) end,

    Def.Sprite{

        Texture='1.png',
        
        InitCommand=function(self)
            self:zoom(3):Center():SetTextureFiltering(false)
        end,

        ShowCommand=function(self)
            self:sleep(3):linear(2):diffusealpha(0):sleep(1)
        end

    },

    quad() .. {

        ShowCommand=function(self)

            self:y( SCREEN_HEIGHT * 0.125 )         self:fadebottom(0):linear(4):fadebottom(1)

        end

    }

}

return Def.ActorFrame{ foxToys.Load( "PSX/DDR/Stars", 2 ),     title }