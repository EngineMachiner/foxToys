
local Vector = Astro.Vector

local scale = SCREEN_HEIGHT / 240               local scale2 = SCREEN_HEIGHT / 720

local path = tapLua.resolvePath("1.png")

local function sprite() return tapLua.Sprite { Texture = path } end

local args = {

    sprite = sprite,        CornerCrop = Vector( 0.625, 0.625 ),

    CenterCrop = Vector( 0.375, 0.375 ),          Size = Vector( 355, 24 ) * scale2,
    
    Zoom = scale

}

local function onChildren(self) self:SetTextureFiltering(false) end

return tapLua.Load( "Sprite/Matrix", args ) .. {

    InitCommand=function(self) self:RunCommandsOnChildren(onChildren) end

}