
local function effect(path, state, startSleep)

    local t = Def.ActorFrame{

        OnCommand=function(self)
            self:Center():zoom(3):diffusealpha(0):sleep(startSleep)
            self:queuecommand("Move"):linear(0.325):diffusealpha( 0.333 )
            self:sleep(0):diffusealpha(1):sleep(0.5):linear(0.325):diffusealpha(0)
        end

    }

    for i = -1, 1 do
        
        t[#t+1] = Def.Sprite{

            Texture=path,
            InitCommand=function(self) 

                self:SetTextureFiltering(false)
                self:animate(false):setstate(state)

                local w, h = self:GetWidth(), self:GetHeight()
                self:xy( w * i * 0.075, - h * i * 0.5 )

            end,

            MoveCommand=function(self) self:linear(0.325):xy(0, 0) end

        }

    end

    return t

end

local function quad()

    return Def.Quad{
        InitCommand=function(self)
            self:FullScreen():diffuse(Color.Black)
        end
    }

end

local function failedTitle()

    return Def.Sprite{

        Texture='3 1x2.png',
        InitCommand=function(self)
            self:zoom(3):Center():SetTextureFiltering(false)
            self:animate(false):setstate(1)
        end

    }

end

local sleep1, sleep2 = 2.25, 1.625

local failed = Def.ActorFrame{

    InitCommand=function(self) self:visible(false) end,
    PlayerFailedMessageCommand=function(self) self:visible(true) end,
    
    failedTitle() .. {

        PlayerFailedMessageCommand=function(self) 
            self:diffusealpha(0):sleep( sleep1 + sleep2 )
            self:smooth(1):diffusealpha(1):sleep(1)
            self:linear(2):diffusealpha(0):sleep(1)
        end

    }

}

for i = 1, 4 do

    failed[#failed+1] = failedTitle() .. {

        PlayerFailedMessageCommand=function(self)
            self:diffusealpha(0):sleep(sleep1):queuecommand("Effect")
        end,

        EffectCommand=function(self)
            self:zoom( self:GetZoom() * 1.25 )
            self:pulse():effectoffset( i / 8 ):effectperiod(1.5)
            self:smooth(1):diffusealpha( 1 / 5 )
            self:sleep(sleep2):smooth(1):diffusealpha(0)
        end

    }

end

local cleared = Def.ActorFrame{

    InitCommand=function(self) self:visible(false) end,
    PlayerFailedMessageCommand=function(self) self.Failed = true end,

    OffCommand=function(self)
        if self.Failed then return end;     self:sleep(sleep1):queuecommand("Show")
    end,

    ShowCommand=function(self) self:visible(true) end,

    Def.Sprite{

        Texture='3 1x2.png',

        InitCommand=function(self)
            self:zoom(3):Center():SetTextureFiltering(false):animate(false)
        end,

        ShowCommand=function(self)
            self:sleep(3):linear(2):diffusealpha(0):sleep(1)
        end

    },

    quad() .. {

        ShowCommand=function(self)
            self:y( SCREEN_HEIGHT * 0.125 )
            self:fadebottom(0):linear(4):fadebottom(1)
        end

    }

}

return Def.ActorFrame{

    effect( "1 1x2.png", 0, 3 ),    effect( "1 1x2.png", 1, 4.5 ),

    LoadModule("foxToys/PSX/DDR/GameplayInOut/starsMask.lua"),

    cleared, failed
    
}