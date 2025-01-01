
local path = foxToys.Path .. "PSX/DDR/Score/Frame/1.png"

local function onChildren(self) self:SetTextureFiltering(false) end

local function sprite() return Def.Sprite{ Texture = path } end

local args = {

    sprite = sprite,        cornerCrop = { X = 0.625, Y = 0.625 },

    centerCrop = { X = 0.375, Y = 0.375 },          size = { X = 365, Y = 14, Zoom = 4 }

}

return Def.ActorFrame{ 
    
    tapLua.Load( "Sprite/Matrix", args ) .. {

        InitCommand=function(self) self:RunCommandsOnChildren(onChildren) end

    }

}