
local find = Astro.Table.find           local Vector = Astro.Vector

local player = ...          local scale = SCREEN_HEIGHT / 720

return Def.ActorFrame {

    tapLua.Sprite {

        Texture = '1 1x6.png',

        OnCommand=function(self)

            local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. player )

            if not p then self:GetParent():RemoveAllChildren() return end


            self:SetTextureFiltering(false):animate(false)


            local zoom = scale * 4
            
            local pos = Vector( p:GetX(), SCREEN_HEIGHT ) - Vector( 75, 125 )

            self:zoom(zoom):setPos(pos)
            

            local steps = GAMESTATE:GetCurrentSteps( "PlayerNumber_" .. player )
            
            local difficulty = steps:GetDifficulty()        local i = find( Difficulty, difficulty ).key


            local isBattle = GAMESTATE:IsBattleMode()

            local state = isBattle and 5 or i - 1       self:setstate(state)

            if isBattle then self:CenterX() end

            if difficulty:match("Edit") then self:visible(false) end

        end

    }

}