
local Vector = Astro.Vector         local Actor = tapLua.Actor


local player = ...          local scale = SCREEN_HEIGHT / 240

local pos = Vector()        local angle = 0


local function playerExists(params)

    local isPlayer = params.Player:match(player)

    return params.LifeMeter and isPlayer

end

local function onChildren(self)

    self:SetTextureFiltering(false)

    self:effectclock("beat"):set_tween_uses_effect_delta(true)

end


local function frameColor( self, life )

    -- Get the current color and compare it with the next.

    local current = self:GetDiffuse()           local next = color( 1, 1, 1 )

    if life <= 0.25 then -- More red.

        local a = life * 4      next[2] = a     next[3] = a

    end

    if current == next then return end          return next

end

local t = tapLua.ActorFrame {

    InitCommand=function(self)

        self:zoom(scale):rotationz(angle)
        
        if player == "P2" then self:rotationy(180) end

        self:RunCommandsOnChildren(onChildren)
        
    end,

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. player )

        if not p then self:RemoveAllChildren() return end

        p.GetPos = Actor.GetPos


        local pos = p:GetPos() + pos        self:setPos(pos)
    
    end,

    -- Normal frame.
    
	Def.Sprite {

		Texture = "1.png",

		LifeChangedMessageCommand=function(self, params)

            if not playerExists(params) then return end


            local life = params.LifeMeter:GetLife()
            
            local color = frameColor(life)      if not color then return end

            self:stoptweening():smooth(1):diffuse(color)

		end
	},

    -- Hot frame.

    Def.Sprite {

        Texture = '1.png',
    
        InitCommand=function(self) 
            
            self:blend("add")       self:diffuseblink():effectperiod(0.5)
        
        end,

        HealthStateChangedMessageCommand=function(self, params)
    
            if not playerExists(params) then return end

            local isHot = params.HealthState:match("Hot")      self:visible(isHot)
    
        end
    
    }

}


local function pill(i)

    return tapLua.Sprite {

        Texture = "2 19x1.png",
        InitCommand=function(self) self:animate(false):setstate(i) end

    }

end


local hotFrame = t[#t]          local p = Def.ActorFrame {}      t[#t+1] = p

local function half() return math.ceil( #p * 0.5 ) end

local function bounceOffset(i)

    local offset = i - 1        offset = - offset / #p           
    
    return offset + 0.25

end

for i = 1, 17 do

    local blinkPill = pill(i) .. {

        InitCommand=function(self)
            
            self:diffusealpha(0.5)      hotFrame.InitCommand(self) 
        
        end,

        LifeChangedMessageCommand = hotFrame.LifeChangedMessageCommand

    }

	p[#p+1] = tapLua.ActorFrame {

		InitCommand=function(self) self:RunCommandsOnChildren( OnChildren ) end,

		BounceCommand=function(self)

            if self.Bounce then return end


            local t = 0.125         local offset = bounceOffset(i)      self.Bounce = true

            self:bounce():effectmagnitude( 0, -3, 0 ):effectoffset(offset)

            self:effecttiming( t, 0, t, 1 - t * 2 )

		end,

        StopBounceCommand=function(self) self:stopeffect()      self.Bounce = false end,

        --[[ 
        
            This is going to be a sandwich. The background of the pill, the stream
            and the front of the pill using a mask.

        ]]

		pill(i) .. { 
            
            OnCommand=function(self)

                self:diffusealpha(0.5)


                local p = self:GetParent()      local size = self:GetSize()
                
                local x = n - i - 1     x = size.x * 0.625 * x
                
                p:x(x):setSizeVector(size)


                if i == half() then p:queuecommand("Idle") end
                
            end
    
        },

		-- Life stream.

		tapLua.Quad {

			InitCommand=function(self) 
                
                local size = self:GetParent():GetSize()         self:MaskSource():setSizeVector(size)

                self.crop = 0       self:croptop( self.crop )
            
            end,

			IdleCommand=function(self)

                local crop = self.crop

				self:smooth(0.75):croptop( crop - 0.25 ):smooth(0.75):croptop(crop)

				self:queuecommand("Idle")

			end,

			LifeChangedMessageCommand=function(self, params)

                if not playerExists(params) then return end  


                local life = params.LifeMeter:GetLife()
                
                local rate = life * #p          local p = self:GetParent()

                if i <= rate then p:queuecommand("Bounce") return end


                self:stoptweening()

                local crop = rate - math.floor(rate)        local time = 1

                if i >= rate + 1 then crop, time = 1, 0.5 else self:queuecommand("Idle") end

                self:smooth(time):cropbottom(crop)

			end

		},

		-- Mask.

		pill(i) .. { InitCommand=function(self) self:invertedMaskDest() end },

        blinkPill

	}

end

return Def.ActorFrame{ t }