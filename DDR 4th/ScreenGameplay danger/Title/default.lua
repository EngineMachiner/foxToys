
local scale = SCREEN_HEIGHT / 240

return Def.ActorFrame {

    Def.Quad {

        InitCommand=function(self)

            self:setsize( SCREEN_WIDTH, 128 - 16 ):diffuse( Color.Black )

        end

    },

    Def.Sprite {

        Texture="1 1x2.png",
        
        InitCommand=function(self)

            self:SetTextureFiltering(false):SetAllStateDelays(4)

            self:zoom(scale):effectclock("beat"):animate(false)
            
            self:sleep(0.5):queuecommand("Animate")

        end,

        AnimateCommand=function(self) self:animate(true) end

    }

}