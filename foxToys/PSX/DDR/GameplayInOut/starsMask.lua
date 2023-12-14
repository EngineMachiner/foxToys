
local t = Def.ActorFrame{}

local zoom = SCREEN_HEIGHT / 240
local n = 8

for j = 1, 2 do for i = 1, n do

    t[#t+1] = Def.ActorFrame{
        
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

t[#t+1] = Def.Quad { InitCommand=function(self) self:diffuse( Color.Black ):FullScreen():MaskDest() end }

return Def.ActorFrame{ t }