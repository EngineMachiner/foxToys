
local playerName = ...

return Def.ActorFrame{

    foxToys.Load("PSX/DDR/Score/Frame"),
    foxToys.Load( "PSX/DDR/Score/RollingNumbers", playerName ),

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. playerName )

        if not p then self:RemoveAllChildren() return end

        self:xy( p:GetX(), SCREEN_HEIGHT - 55 )
    
    end

}