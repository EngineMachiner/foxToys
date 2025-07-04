
local scale = SCREEN_HEIGHT / 240

local title = Def.ActorFrame {

    InitCommand=function(self) self:visible(false) end,
    ShowCommand=function(self) self:visible(true) end,

    OnCommand=function(self) self:sleep(2.25):queuecommand("Show") end,

    Def.Sprite {

        Texture='1.png',
        
        InitCommand=function(self)

            self:Center():zoom(scale):SetTextureFiltering(false)

        end,

        ShowCommand=function(self)

            self:sleep(3):linear(2):diffusealpha(0):sleep(1)
            
        end

    },

    Def.Quad {

        InitCommand=function(self) self:FullScreen():diffuse( Color.Black ) end,

        ShowCommand=function(self)

            self:y( SCREEN_HEIGHT * 0.125 )         self:fadebottom(0):linear(4):fadebottom(1)

        end

    }

}

return Def.ActorFrame{ foxToys.Load( "DDR 4th/Stars", 2 ),     title }