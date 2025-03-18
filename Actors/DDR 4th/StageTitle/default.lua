
local scale = SCREEN_HEIGHT / 240           local y = 100

local Stages = {

    ['Stage_1st'] = 1,
    ['Stage_2nd'] = 2,
    ['Stage_3rd'] = 3,
    ['Stage_4th'] = 4,
    ['Stage_Final'] = 5
    
}

local function title()

    return Def.Sprite {

        Texture = '1 1x7.png',

        InitCommand=function(self) self:animate(false):SetTextureFiltering(false) end

    }

end

local function onChildren(self) self:SetTextureFiltering(false) end

return Def.ActorFrame {

    InitCommand=function(self)
        
        self:CenterX():zoom(scale):addy(y):RunCommandsOnChildren(onChildren) 
    
    end,

    Def.ActorFrame {

        title() .. {

            OnCommand=function(self)
                
                local stage = STATSMAN:GetCurStageStats():GetStage()        local state = Stages[stage]
                
                if not state then self:GetParent():visible(false) return end

                self:setstate(state)

            end

        },

        title() .. {

            InitCommand=function(self)

                local h = self:GetZoomedHeight()        self:y(h):setstate(6)

            end

        }

    },

    Def.Sprite { Texture='2.png',       Condition = GAMESTATE:IsDemonstration() }

}