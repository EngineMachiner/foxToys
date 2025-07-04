
local scale = SCREEN_HEIGHT / 240

local function sprite()

    return Def.Sprite {

        Texture = '1.png',

        InitCommand=function(self) self:SetTextureFiltering(false) end

    }

end

local starsTime = 2

local t = Def.ActorFrame {

    InitCommand=function(self) self:Center():zoom(scale):diffusealpha(0) end,

    OnCommand=function(self)
    
        self:sleep(starsTime):queuecommand("Motion")

        self:linear(0.25):diffusealpha(1):sleep(1):linear(0.5):diffusealpha(0)

    end

}

for i = 1, 3 do

    local sleep = i - 1         sleep = sleep * 0.25 / 2

    local alpha = 4 - i         alpha = alpha * 0.5 / 3

    t[#t+1] = sprite() .. {

        InitCommand=function(self)
            
            local blend = Blend.Add             self:zoom(1.5):diffusealpha(alpha):blend(blend)
        
        end,

        MotionCommand=function(self)

            self:sleep(sleep):smooth(0.4):zoom(0.75):smooth(0.4):zoom(1)
            
        end

    }

end

return Def.ActorFrame{ foxToys.Load( "DDR 4th/Stars", 1 ),   t }