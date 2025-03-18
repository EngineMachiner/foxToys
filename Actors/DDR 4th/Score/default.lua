
local player = ...

return Def.ActorFrame {

    foxToys.Load( "Actors/DDR 4th/Score/Frame" ),
    foxToys.Load( "Actors/DDR 4th/Score/ScrollingNumbers", player ),

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. player )

        if not p then self:RemoveAllChildren() return end

        self:xy( p:GetX(), SCREEN_HEIGHT - 55 )
    
    end

}