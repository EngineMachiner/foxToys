
local playerName = ...          local n = 9

local function score()

    local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats( "PlayerNumber_" .. playerName )

    return stats:GetScore()

end

local function onChildren(self) self:SetTextureFiltering(false):zoom(3.5) end

local function mask()

    return Def.Quad{

        InitCommand=function(self) self:setsize(375, 52):MaskSource(true) end
        
    }

end

local function background(i)

    return Def.ActorFrame{
        
        InitCommand=function(self) self:RunCommandsOnChildren(onChildren) end,
        
        ScoreChangedMessageCommand=function(self) self:updateValue(i) end,

        Def.Sprite{

            Texture='2.png',
        
            OnCommand=function(self)
                
                local w = self:GetZoomedWidth() * 0.85
                
                local n = i - math.ceil( n * 0.5 )          self:GetParent():x( w * n )
            
            end,
        
            StartCommand=function(self) self:visible(false) end
        
        }

    }

end

local path = foxToys.Path .. 'PSX/DDR/Score/RollingNumbers/1 (stretch).png'

local function sprite() 
    
    return Def.Sprite{ 
    
        Texture=path,
        InitCommand=function(self) self:visible(false) end,
        StartCommand=function(self) self:visible(true) end
    
    } 

end

local args = {

    Num = n,        Mask = mask,        value = score,
    
    background = background,            sprite = sprite

}

local onChildren2 = function(self) self:setsize( 375, 52 * 0.25 ):diffuse(Color.Black) end

local shadow = Def.ActorFrame{

    InitCommand=function(self) self:RunCommandsOnChildren(onChildren2) end,

    Def.Quad{

        OnCommand=function(self) self:y( - self:GetHeight() * 1.5 ):fadebottom(1) end
        
    },

    Def.Quad{

        OnCommand=function(self) self:y( self:GetHeight() * 1.5 ):fadetop(1) end
        
    }

}

local t = tapLua.Load( "Sprite/RollingNumbers", args )

return Def.ActorFrame{ t, shadow }