
local find = Astro.Table.find           local Vector = Astro.Vector

local playerKey = ...          local scale = SCREEN_HEIGHT / 720

local player = "PlayerNumber_" .. playerKey         local isP2 = playerKey == "P2"

local path = isP2 and '2' or '1'             path = path .. " 1x6.png"

return Def.ActorFrame {

    tapLua.Sprite {

        Texture = tapLua.resolvePath(path),

        OnCommand=function(self)

            local child = "Player" .. playerKey

            local p = SCREENMAN:GetTopScreen():GetChild(child)

            if not p then self:GetParent():RemoveAllChildren() return end


            self:SetTextureFiltering(false):animate(false)


            local zoom = scale * 3.5          local x = isP2 and -75 or 75
            
            local pos = Vector( p:GetX(), SCREEN_HEIGHT ) - Vector( x, 125 ) * scale

            self:zoom(zoom):setPos(pos)
            

            local steps = GAMESTATE:GetCurrentSteps(player)
            
            local difficulty = steps:GetDifficulty()        local i = find( Difficulty, difficulty ).key


            local isBattle = GAMESTATE:IsBattleMode()

            local state = isBattle and 5 or i - 1       self:setstate(state)

            if isBattle then self:CenterX() end

            if difficulty:match("Edit") then self:visible(false) end

        end

    }

}