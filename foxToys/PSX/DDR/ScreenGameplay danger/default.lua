
local filterAlpha = 0.5

local function show(self)
    self.wasDanger = true;      self:stoptweening():linear(0.25):diffusealpha(1)
end

local function hide(self)
    self.wasDanger = false;     self:stoptweening():linear(0.25):diffusealpha(0)
end

local function init(self) self.show = show;  self.hide = hide end

local t = Def.ActorFrame{

	InitCommand=function(self) init(self); self:diffusealpha(0) end,

	HealthStateChangedMessageCommand=function(self, params)

        local isDanger = params.HealthState == 'HealthState_Danger' and not self.wasDanger

        if isDanger then self:show() elseif self.wasDanger then self:hide() end

	end
}

-- Sprites.

local s = Def.ActorFrame{ InitCommand=function(self) self:Center() end };     t[#t+1] = s

local size = 128 * 1.5
local n1 = math.ceil( SCREEN_WIDTH / size )
local n2 = math.ceil( SCREEN_HEIGHT / size )

for i = 1, n1 + 1 do for j = 1, n2 + 1 do

    s[#s+1] = Def.Sprite{
        Texture="1 2x4.png",
        InitCommand=function(self)

            self:SetTextureFiltering(false)
            self:zoom(3):effectclock("beat"):SetAllStateDelays(0.125)
 
            local w, h = self:GetZoomedWidth(), self:GetZoomedHeight()
            
            local i = i - n1 * 0.5 - 1;     local j = j - n2 * 0.5 - 1

            if ( n1 % 2 == 0 ) then i = i - 0.5 end
            if ( n2 % 2 == 0 ) then j = j - 0.5 end

            self:xy( i * w, j * h )
            
        end
    }

end end


-- Title.
t[#t+1] = Def.ActorFrame{

    Def.Quad{
        InitCommand=function(self)
            self:Center():setsize( SCREEN_WIDTH, 128 - 16 ):diffuse( Color.Black )
        end
    },

    Def.Sprite{

        Texture="title 1x2.png",
        InitCommand=function(self)
            self:SetTextureFiltering(false)
            self:Center():zoom(3):effectclock("beat"):animate(false):SetAllStateDelays(4)
            self:sleep(0.5):queuecommand("Animate")
        end,

        AnimateCommand=function(self) self:animate(true) end

    }

}

-- Filter.
t[#t+1] = Def.Quad{
    InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(filterAlpha) end
} 

return Def.ActorFrame{
    InitCommand=function(self) self:effectclock("beat"):set_tween_uses_effect_delta(true):queuecommand("Danger") end,
    DangerCommand=function(self) self:sleep(2):diffusealpha(1):sleep(2):diffusealpha(0):queuecommand("Danger") end,
    t
}