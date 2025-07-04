
local scale = SCREEN_HEIGHT / 240

local function motionSprite( state, sleep )

    local t = Def.ActorFrame {

        InitCommand=function(self) self:Center():zoom(scale):diffusealpha(0) end,

        OnCommand=function(self)

            self:sleep(sleep):queuecommand("Move")

            self:linear(0.325):diffusealpha( 1 / 3 ):sleep(0):diffusealpha(1)
            
            self:sleep(0.5):linear(0.325):diffusealpha(0)

        end

    }

    for i = -1, 1 do
        
        t[#t+1] = tapLua.Sprite {

            Texture = tapLua.resolvePath("1 1x2.png"),

            InitCommand=function(self) 

                self:SetTextureFiltering(false):animate(false):setstate(state)

                local size = self:GetSize() * i         self:xy( size.x * 0.075, - size.y * 0.5 )

            end,

            MoveCommand=function(self) self:linear(0.325):xy(0,0) end

        }

    end

    return t

end

return Def.ActorFrame {

    motionSprite( 0, 3 ),    motionSprite( 1, 4.5 ),        foxToys.Load( "DDR 4th/Stars", 3 ),
    
}