
local function quad()

    return Def.Quad{
        InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end
    }

end

local function sprite()

    return Def.Sprite{

        Texture='1.png',
        InitCommand=function(self)
            self:zoom(3):Center():SetTextureFiltering(false)
            self:animate(false)
        end

    }

end

local sleep1, sleep2 = 2.25, 1

local title = Def.ActorFrame{

    InitCommand=function(self) self:visible(false) end,
    OnCommand=function(self) self:visible(true) end,
    
    sprite() .. {

        OnCommand=function(self) 
            self:diffusealpha(0):sleep( sleep1 + sleep2 )
            self:smooth(1):diffusealpha(1):sleep(1)
            self:smooth(1):diffusealpha(0):sleep(1)
        end

    }

}

for i = 1, 4 do

    title[#title+1] = sprite() .. {

        OnCommand=function(self)
            self:diffusealpha(0):sleep(sleep1):queuecommand("Motion")
        end,

        MotionCommand=function(self)
            self:zoom( self:GetZoom() * 1.25 )
            self:pulse():effectoffset( i / 8 ):effectperiod(1.75)
            self:smooth(0.5):diffusealpha( 1 / 5 )
            self:sleep(sleep2):smooth(0.5):diffusealpha(0)
        end

    }

end

return Def.ActorFrame{ LoadModule("foxToys/PSX/DDR/Stars/default.lua"),     title }