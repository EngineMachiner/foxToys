
local playerName = ...
local posOffset = { x = 0, y = 0 }
local barAngle = - 90

local function hotSprite(path)

    return Def.Sprite{

        Texture=path,
        InitCommand=function(self) self:blend('add') end,

        LifeChangedMessageCommand=function(self, params)

            if not params.LifeMeter then return end

            local lifeMeter = params.LifeMeter

            if lifeMeter:IsHot() then self:visible(true):diffuseblink():effectperiod(0.5)
            else self:visible(false) end

        end

    }

end

local t = Def.ActorFrame{

    InitCommand=function(self)

        self:zoom( SCREEN_HEIGHT / 240 )
        
        self:RunCommandsOnChildren( function(child)
            child:SetTextureFiltering(false)
            child:effectclock("beat"):set_tween_uses_effect_delta(true)
        end )

        self:rotationz(barAngle)

        if playerName:match("P2") then self:rotationy(180) end
        
    end,

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild(playerName)

        if playerName:match("P1") then

            self:xy( p:GetX() * 0.25 + posOffset.x, p:GetY() + posOffset.y )

        else 
        
            self:xy( p:GetX() * 1.26 - posOffset.x, p:GetY() + posOffset.y )

        end
    
    end,

	Def.Sprite{
		Texture="1.png",
		LifeChangedMessageCommand=function(self, params)

            if not params.LifeMeter then return end

            local lifeMeter = params.LifeMeter
            local life = lifeMeter:GetLife()
            
            self:stoptweening();    self.gb = 1

            if life <= 0.25 then

                local gb = life * 4;        self.gb = gb

                gb = tostring(gb) .. ','

                local c = '1,' .. gb .. gb .. '1'

                self:smooth(1):diffuse( color(c) )

            else

                if self.gb == 1 then return end

                self:smooth(1):diffuse(Color.White);   self.gb = 1

            end

		end
	},

    hotSprite("1.png")

}

-- Pills.
local p = Def.ActorFrame{};     local n = 17;       t[#t+1] = p

local function pill(i)

    return Def.Sprite{
        Texture="2 19x1.png",
        InitCommand=function(self) self:animate(false):setstate(i) end
    }

end

for i = 1, n do

    local hotTemplate = hotSprite()

	p[#p+1] = Def.ActorFrame{

		InitCommand=function(self)

			self:effectclock("beat"):set_tween_uses_effect_delta(true)

			self:RunCommandsOnChildren( function(child)
                child:SetTextureFiltering(false)
				child:effectclock("beat"):set_tween_uses_effect_delta(true)
			end )

		end,

		BounceCommand=function(self)

            local offset = - ( i - 1 ) * 0.5 / ( n * 0.5 ) + 0.25
            local t = 0.125
            
			self:bounce():effectmagnitude( 0, -3, 0 ):effectoffset(offset)
			self:effecttiming( t, 0, t, 1 - t * 2 )

		end,

		-- The back.
		pill(i) .. { OnCommand=function(self)

            self:GetParent():RunCommandsOnChildren( function(child)

                local w = self:GetWidth()
                child:finishtweening():x( w * ( i - 1 - n * 0.45 ) * 0.85 )

                if ( i == math.ceil( n * 0.5 ) ) then child:queuecommand("Idle") end
                
            end )

            self:diffusealpha(0.5) 
            
        end },

		-- Stream.
		Def.Quad{

			InitCommand=function(self) self:zoomto(5, 14):MaskSource(); self.crop = n * 0.5 end,

			IdleCommand=function(self)
				self:smooth(0.75):cropbottom( self.crop - 0.25 )
				self:smooth(0.75):cropbottom( self.crop )
				self:queuecommand("Idle")
			end,

			LifeChangedMessageCommand=function(self, params)

                if not params.LifeMeter then return end

                local p = self:GetParent()
                local unit = params.LifeMeter:GetLife() * 17
                local lim = math.floor(unit)

                self:stoptweening()

                if unit >= i then

                    self:cropbottom(1);     p:queuecommand("Bounce")

                else

                    p:stopeffect()

                    if unit + 1 >= i then

                        self.crop = unit - lim

                        self:smooth(1):cropbottom( self.crop ):queuecommand("Idle")

                    else self:smooth(0.5):cropbottom(0) end

                end

			end

		},

		-- Mask.
		pill(i) .. { InitCommand=function(self) self:MaskDest() end },

        ( pill(i) .. { InitCommand=function(self) self:diffusealpha(0.5) end } ) .. {
            InitCommand=hotTemplate.InitCommand,
            LifeChangedMessageCommand=hotTemplate.LifeChangedMessageCommand
        }

	}
end

return Def.ActorFrame{ t }