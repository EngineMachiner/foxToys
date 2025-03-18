
-- This actor has two zooms. The common animation zoom and the combo incremental zoom.

local Vector = Astro.Vector


local player = ...          local scale = SCREEN_HEIGHT / 720

local pos = Vector { y = 50 }


local function zoom(combo)
   
    local start = 0.55          local zoom = combo * 0.003 + start

    return math.min( zoom, 0.75 )

end

return Def.ActorFrame {

    InitCommand=function(self) self:zoom(scale) end,

    tapLua.ActorFrame {

        InitCommand=function(self)

            self:effectclock('beat'):set_tween_uses_effect_delta(true)

            self:RunCommandsOnChildren( function(child) child:SetTextureFiltering(false) end )

        end,

        OnCommand=function(self)
            
            local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. player )

            if not p then self:RemoveAllChildren() return end
    
            p.GetPos = tapLua.Actor.GetPos
            

            local pos = p:GetPos() + pos        self:setPos(pos)
        
        end,

        ZoomCommand=function(self)

            local zoom1 = 2.75          local zoom2 = zoom1 * 1.5

            self:stoptweening():zoom( zoom2 ):linear(0.5):zoom( zoom1 )

        end,

        Def.BitmapText {

            Font='1.ini',

            InitCommand=function(self) self:horizalign('HorizAlign_Right') end,

            ComboChangedMessageCommand=function( self, params )

                local isPlayer = params.Player:match( player )

                if not isPlayer then return end


                local p = self:GetParent()          local stats = params.PlayerStageStats
                
                local combo = stats:GetCurrentCombo()


                if combo < 4 then p:visible(false) return else p:visible(true) end

                if combo > params.OldCombo then p:playcommand("Zoom") end

                
                local zoom = zoom(combo)        self:zoom(zoom)

                self:settext(combo)


                local title = p.Title       if not title then return end

                local y = title.PosY + self:GetZoomedHeight() * 0.5

                title:y(y)

            end

        },

        tapLua.Sprite {

            Texture='2.png',

            OnCommand=function(self)
                
                local w, h = self:GetZoomedSize(true)           local pos = Vector( w, - h ) * 0.55

                self:setPos(pos)         self.PosY = pos.y          self:GetParent().Title = self

            end

        }

    }

}