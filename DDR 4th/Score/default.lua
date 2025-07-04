
local player = ...              local scale = SCREEN_HEIGHT / 720

return Def.ActorFrame {

    foxToys.Load( "DDR 4th/Score/Frame" ),
    foxToys.Load( "DDR 4th/Score/ScrollingNumbers", player ),

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. player )

        if not p then self:RemoveAllChildren() return end

        self:xy( p:GetX(), SCREEN_HEIGHT - 63 * scale ):zoom(scale)
    
    end

}