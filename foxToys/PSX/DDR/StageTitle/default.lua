
local offsetY = 100

local STAGES = {
    ['Stage_1st'] = 1,
    ['Stage_2nd'] = 2,
    ['Stage_3rd'] = 3,
    ['Stage_4th'] = 4,
    ['Stage_Final'] = 5
}

local function init(self) self:zoom(3):SetTextureFiltering(false):Center() end

local function stageTitle()

    return Def.Sprite{
        Texture='1 1x7.png',
        InitCommand=function(self) init(self) self:animate(false) end
    }

end

return Def.ActorFrame {

    Def.ActorFrame{

        stageTitle() .. {
            OnCommand=function(self)
                
                self:y(offsetY)

                local stage = STATSMAN:GetCurStageStats():GetStage()
                local state = STAGES[stage]
                
                if not state then self:GetParent():visible(false) return end

                self:setstate(state)

            end
        },

        stageTitle() .. {
            InitCommand=function(self)

                local h = self:GetZoomedHeight()

                self:y( offsetY + h ):setstate(6)

            end
        }

    },

    Def.Sprite{
        Condition=GAMESTATE:IsDemonstration(),
        Texture='2.png',
        InitCommand=function(self)
            init(self)  self:y(offsetY)
        end
    }

}