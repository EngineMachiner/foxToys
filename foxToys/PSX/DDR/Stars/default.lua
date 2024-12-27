
local starType = ... or 1

local t = Def.ActorFrame{} -- Failed and cleared stars.
local t2 = Def.ActorFrame{} -- Stars at the beginning.

local zoom = SCREEN_HEIGHT / 240;       local n = 8

for j = 1, 2 do for i = 1, n do

    t[#t+1] = Def.ActorFrame{
        
        Def.Quad{ InitCommand=function(self) self:GetParent().Quad = self end },

        Def.Sprite{

            Texture='2 1x3.png',
            InitCommand=function(self)

                local i = i - 1

                self:zoom(zoom):setstate(1):animate(false)

                local w, h = self:GetZoomedWidth(), self:GetZoomedHeight()

                local x = - ( SCREEN_WIDTH * 2 - w ) * 0.5

                if j == 2 then x = - x else self:rotationy(180) end

                self:x(x):SetTextureFiltering(false):blend('add')

                local p = self:GetParent();     local q = p.Quad

                local a = math.abs( i - n * 0.5 + 0.5 )
                x = w * ( a - n + 1 ) * 0.5
                x = SCREEN_WIDTH * 2 - x

                if j == 2 then
                    a = math.abs( i - n * 0.5 + 1 )
                    x = w * ( - a - n + 1 ) * 0.5
                    x = - SCREEN_WIDTH * 2 - x
                else p:y( - h ) end

                p:xy( x, p:GetY() + h * ( i * 2 + 1.5 ) )

                q:setsize( SCREEN_WIDTH * 2, h ):diffuse(Color.Black)

                if starType == 1 then self:playcommand("PlayerFailed") end

            end,

            PlayerFailedCommand=function(self)

                local p = self:GetParent():GetParent()

                p:zoomx(-1):x(SCREEN_WIDTH)

                self:setstate(0):queuecommand("Off")

            end,

            OffCommand=function(self)
                
                local p = self:GetParent()
                local t = SCREEN_WIDTH / SCREEN_HEIGHT
                local x = - SCREEN_WIDTH * 2

                if j == 2 then x = - x end

                p:linear( t * 1.5 ):x( p:GetX() + x )

            end

        }

    }

    t2[#t2+1] = Def.ActorFrame{
        
        Def.Quad{ InitCommand=function(self) self:GetParent().Quad = self end },

        Def.Sprite{

            Texture='2 1x3.png',
            InitCommand=function(self)

                local i = i - 1

                self:zoom(zoom):setstate(2):animate(false)

                local w, h = self:GetZoomedWidth(), self:GetZoomedHeight()

                local x = - ( SCREEN_WIDTH * 2 - w ) * 0.5

                if j == 2 then x = - x else self:rotationy(180) end

                self:x(x):SetTextureFiltering(false):blend('add')
                
                local p = self:GetParent();     local q = p.Quad

                x = w * ( i - n + 1 ) * 0.5

                if j == 1 then 
                    x = SCREEN_WIDTH * 2 - x;   p:y( - h )
                else 
                    x = - SCREEN_WIDTH * 1.6 - x
                end

                p:xy( x, p:GetY() + h * ( i * 2 + 1.5 ) )

                if i + 1 == 1 and j == 1 then q:clearzbuffer(true) end

                q:setsize( SCREEN_WIDTH * 2, h ):diffuse(Color.Black):MaskSource()

            end,

            OnCommand=function(self)
                
                local p = self:GetParent()
                local t = SCREEN_WIDTH / SCREEN_HEIGHT
                local x = - SCREEN_WIDTH * 2

                if j == 2 then x = - x end

                p:linear( t * 1.5 ):x( p:GetX() + x )

            end

        }

    }

end end

t2[#t2+1] = Def.Quad { 
    
    InitCommand=function(self) self:diffuse( Color.Black ):FullScreen():MaskDest() end 

}

if starType == 3 then return Def.ActorFrame{ t2 } end             return Def.ActorFrame{ t }