
local scale = SCREEN_HEIGHT / 240

local path = tapLua.resolvePath("1 2x4.png")

local input = {

    Path = path,          Zoom = scale,

    Sprite = {
        
        InitCommand=function(self)

            self:SetTextureFiltering(false):effectclock("beat")

            self:SetAllStateDelays(0.125)
        
        end

    }

}

return tapLua.Load( "Sprite/Tile", input )