
local playerName = ...
local posOffset = { x = 0, y = 50 }

return Def.ActorFrame {

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. playerName )

        if not p then self:RemoveAllChildren() return end

        self:xy( p:GetX() + posOffset.x, p:GetY() + posOffset.y )

        self:effectclock('beat'):set_tween_uses_effect_delta(true)

        self:RunCommandsOnChildren( function(child) 
            child:SetTextureFiltering(false)
        end )
    
    end,

    ZoomiesCommand=function(self)

        local zoom = 2.75

        self:stoptweening():zoom( zoom * 1.5 ):linear(0.5):zoom(zoom)

    end,

    Def.BitmapText {
        Font='Combo numbers.ini',
        ComboChangedMessageCommand=function(self, params)

            local isPlayer = params.Player:match(playerName)

            if not isPlayer then return end

            local p = self:GetParent()
            local stats = params.PlayerStageStats
            local combo = stats:GetCurrentCombo()

            if combo < 4 then p:visible(false) else p:visible(true) end

            if params.OldCombo ~= combo then p:playcommand("Zoomies") end

            self:horizalign('HorizAlign_Right'):settext(combo)

            local zoom = 0.55 + combo * 0.003
            zoom = math.min( zoom, 0.75 );  self:zoom(zoom)

            local h = self:GetZoomedHeight()

            local title = p.Title;      if not title then return end
            
            local pos = title.formerPos;    title:y( pos.y + h * 0.5 )

        end
    },

    Def.Sprite{
        Texture='combo.png',
        OnCommand=function(self)

            local w, h = self:GetZoomedWidth(), self:GetZoomedHeight()

            self:xy( w * 0.55, - h * 0.55 );   self:GetParent().Title = self

            self.formerPos = { x = self:GetX(), y = self:GetY() }

        end 
    }

}