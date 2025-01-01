
local playerName = ...

return Def.ActorFrame {

    Def.Sprite {
        Texture='1 1x6.png',
        OnCommand=function(self)

            self:SetTextureFiltering(false)

            local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. playerName )

            if not p then self:GetParent():RemoveAllChildren() return end

            local difficulty = GAMESTATE:GetCurrentSteps( "PlayerNumber_" .. playerName ):GetDifficulty()
            local state = tapLua.Table.contains( Difficulty, difficulty ) - 1

            self:zoom(4):xy( p:GetX() - 75, SCREEN_HEIGHT - 125 ):animate(false)
            
            if GAMESTATE:IsBattleMode() then 
                self:setstate(5):x( SCREEN_CENTER_X ); return
            else self:setstate(state) end

            if state == 5 then self:visible(false) return end

        end
    }

}