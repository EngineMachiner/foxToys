
local resolvePath = tapLua.resolvePath          local scale = SCREEN_HEIGHT * 1.16 / 240

local playerKey = ...          local n = 9

local h = 16            local function y() return h * 1.6 end


local function onChildren(self) self:setsize( 375, h ):diffuse( Color.Black ) end

local shadow = Def.ActorFrame {

    InitCommand=function(self) self:RunCommandsOnChildren(onChildren) end,

    Def.Quad{ OnCommand=function(self) local y = y()    self:y( - y ):fadebottom(1) end },
    Def.Quad{ OnCommand=function(self) local y = y()    self:y(y):fadetop(1) end }

}


local player = "PlayerNumber_" .. playerKey

local function score()

    local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

    return stats:GetScore()

end

local function mask()

    local size = Astro.Vector( 375, 65 )

    return tapLua.Quad { InitCommand=function(self) self:setSizeVector(size) end }

end


local function background(i)

    local function onChildren(self) self:SetTextureFiltering(false):zoom(scale) end

    return Def.ActorFrame {
        
        InitCommand=function(self) self:RunCommandsOnChildren(onChildren) end,

        Def.Sprite {

            Texture = resolvePath("2.png"),
        
            OnCommand=function(self)
                
                local w = self:GetZoomedWidth() * 0.85          local n = i - math.ceil( n * 0.5 )
                
                self:GetParent():x( w * n )
            
            end,
        
            StartCommand=function(self) self:visible(false) end
        
        }

    }

end

local function sprite() 
    
    return Def.Sprite { 
    
        Texture = resolvePath("1 (stretch).png"),
        
        InitCommand=function(self) self:visible(false) end,
        StartCommand=function(self) self:visible(true) end
    
    } 

end

local args = {

    Number = n,        mask = mask,        value = score,
    
    background = background,            sprite = sprite

}

local numbers = tapLua.Load( "Sprite/ScrollingNumbers", args ) .. {

    ScoreChangedMessageCommand=function(self) self:playcommand("Update") end

}

return Def.ActorFrame{ numbers, shadow }