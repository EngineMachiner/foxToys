
local Vector = Astro.Vector


local scale = SCREEN_HEIGHT / 240


local type = ...        local color = Color.Black

--[[

    1. Failed stars.
    2. Cleared stars.
    3. Start stars.

]]

local n = 16 -- Number of stars.

local t = SCREEN_WIDTH / SCREEN_HEIGHT

local function pos( self, i )

    local w, h = self:GetZoomedSize(true)           local offset = i - n * 0.5

    if i > n * 0.5 then w = - w end         return Vector( w * 0.25, h ) * offset

end

local pos = {

    pos,    function( self, i ) return - pos( self, i ) end,

    function( self, i )
    
        local w, h = self:GetZoomedSize(true)           local offset = i - n * 0.5

        if ( i + type - 1 ) % 2 == 0 then w = - w end

        return Vector( w * 0.25, h ) * offset

    end

}

local function stars(i)

    local Quad

    return tapLua.ActorFrame {
        
        InitCommand=function(self)

            local rotation = i + type - 1          rotation = rotation % 2 * 180        
            
            self:Center():rotationy(rotation)
        

            if type == 1 then self:rotationy( rotation - 180 ) end

        end,

        Def.ActorFrame {

            MoveCommand=function(self)

                local x = SCREEN_WIDTH

                self:x( - x ):linear( t * 1.5 ):x(x)

            end,

            tapLua.ActorFrame {

                Def.Quad { InitCommand=function(self) Quad = self end },

                tapLua.Sprite {

                    Texture = tapLua.resolvePath("1 1x3.png"),

                    InitCommand=function(self)

                        local blend = Blend.Add

                        self:SetTextureFiltering(false):blend(blend)

                        self:animate(false):setstate( type - 1 ):zoom(scale)


                        local w, h = self:GetZoomedSize(true)           w = SCREEN_WIDTH * 2 - w

                        Quad:setsize( SCREEN_WIDTH * 2, h ):diffuse(color):x( - w * 0.5 )

                        if type == 3 then Quad:MaskSource( i == 1 ) end

                        
                        self:queuecommand("PostInit")

                    end,

                    PostInitCommand=function(self)

                        local p = self:GetParent()      local pos = pos[type]       pos = pos( self, i )

                        local size = self:GetSize() + Vector( Quad:GetWidth() )

                        p:setPos(pos):setSizeVector(size)


                        p:GetParent():GetParent():queuecommand("Move")

                    end

                }

            }

        }

    }

end

local t = Def.ActorFrame {}         for i = 1, n do t[#t+1] = stars(i) end

t[#t+1] = Def.Quad {

    Condition = type == 3,

    InitCommand=function(self)
        
        self:FullScreen():diffuse(color):MaskDest()
    
    end

}

return Def.ActorFrame { t }