
local function motionSprite( path, state, startSleep )

    local t = Def.ActorFrame{

        OnCommand=function(self)
            self:Center():zoom(3):diffusealpha(0):sleep(startSleep)
            self:queuecommand("Move"):linear(0.325):diffusealpha( 0.333 )
            self:sleep(0):diffusealpha(1):sleep(0.5):linear(0.325):diffusealpha(0)
        end

    }

    for i = -1, 1 do
        
        t[#t+1] = Def.Sprite{

            Texture=path,
            InitCommand=function(self) 

                self:SetTextureFiltering(false)
                self:animate(false):setstate(state)

                local w, h = self:GetWidth(), self:GetHeight()
                self:xy( w * i * 0.075, - h * i * 0.5 )

            end,

            MoveCommand=function(self) self:linear(0.325):xy(0, 0) end

        }

    end

    return t

end

return Def.ActorFrame{

    motionSprite( "1 1x2.png", 0, 3 ),    motionSprite( "1 1x2.png", 1, 4.5 ),

    LoadModule( "foxToys/PSX/DDR/Stars/default.lua", 3 ),
    
}