
local Vector = Astro.Vector


local player = ...          local scale = SCREEN_HEIGHT * 1.05 / 240

local pos = Vector( - 50, - SCREEN_CENTER_Y * 0.85 )        local angle = 0

local isP2 = player == "P2"             if isP2 then pos.x = - pos.x end


local function playerExists(params)

    local isPlayer = params.Player:match(player)            return params.LifeMeter and isPlayer

end

local function onChildren(self)

    self:SetTextureFiltering(false):effectclock("beat"):set_tween_uses_effect_delta(true)

end


local dangerF = 0.25

local function dangerColor( self, life )

    -- Get the current color and compare it with the next color.

    local current = self:GetDiffuse()           local color = color( 1, 1, 1 )


    -- More red.

    if life <= dangerF then

        for i = 2, 3 do color[i] = life / dangerF end

    end


    if current == color then return end          return color

end

local t = tapLua.ActorFrame {

    InitCommand=function(self)

        self:zoom(scale):rotationz(angle)           if isP2 then self:rotationy(180) end
        
    end,

    OnCommand=function(self)

        local p = SCREENMAN:GetTopScreen():GetChild( "Player" .. player )

        if not p then self:RemoveAllChildren() return end

        local pos = p:GetPos() + pos            self:setPos(pos)
    
    end,

    Def.ActorFrame {

        InitCommand=function(self) self:zoomx(0.875):RunCommandsOnChildren( onChildren ) end,

        -- Normal frame.
        
        Def.Sprite {

            Texture = "1.png",

            LifeChangedMessageCommand=function(self, params)

                if not playerExists(params) then return end


                local life = params.LifeMeter:GetLife()
                
                local color = dangerColor(self, life)          if not color then return end


                self:stoptweening():smooth(1):diffuse(color)

            end
        },

        -- Hot frame.

        Def.Sprite {

            Texture = '1.png',
        
            InitCommand=function(self) 
                
                self:blend("add")       self:diffuseblink():effectperiod(0.5):visible(false)
            
            end,

            LifeChangedMessageCommand=function(self, params)
        
                if not playerExists(params) then return end


                local life = params.LifeMeter:GetLife()         local isHot = life == 1
                
                self:visible(isHot)

            end
        
        }

    }

}


local function pill(i)

    return tapLua.Sprite {

        Texture = tapLua.resolvePath("2 19x1.png"),
        
        InitCommand=function(self) self:animate(false):setstate(i) end

    }

end


local HotFrame = t[#t][2]          local n = 17

local p = Def.ActorFrame { InitCommand=function(self) self:RunCommandsOnChildren( onChildren ) end }

t[#t+1] = p


local function bounceOffset(i) i = i - 1        i = - i / n          return i end

local function onLimit(self)

    local hasInit = self.Init

    if hasInit then self:queuecommand("Idle") else self:queuecommand("First") end

end

local function onInit( self, i )

    if self.Init then return end        i = i - 1           self:sleep( i * 8 / n )

    self.Init = true

end


for i = 1, n do

    local life

    local BlinkPill = pill(i) .. {

        InitCommand=function(self) self:diffusealpha(0.5)      HotFrame.InitCommand(self) end,

        LifeChangedMessageCommand = HotFrame.LifeChangedMessageCommand

    }

	p[#p+1] = tapLua.ActorFrame {

		InitCommand=function(self)
            
            local t = 0.125             local o = bounceOffset(i)

            self:bounce():effectoffset(o):effecttiming( t, 0, t, 1 - t * 2 ):playcommand("NoBounce")

            self:RunCommandsOnChildren( onChildren )
        
        end,

		BounceCommand=function(self) self:effectmagnitude( 0, - life * 3, 0 ) end,

        NoBounceCommand=function(self) self:effectmagnitude( 0, 0, 0 ) end,

        --[[ 
        
            This is going to be a sandwich. The background of the pill, the stream
            and the front of the pill using a mask.

        ]]

		pill(i) .. { 
            
            OnCommand=function(self)

                self:diffusealpha(0.5)          local size = self:GetSize()

                local x = i - n / 2             x = size.x * 0.75 * x
                
                self:GetParent():x(x):setSizeVector(size)
                
            end
    
        },

		-- Life stream.

		tapLua.Quad {

            InitCommand=function(self) self:croptop(1)          self.crop = 0.5 end,

			OnCommand=function(self)
                
                local size = self:GetParent():GetSize()         size.x = size.x * 0.675

                self:setSizeVector(size):MaskSource()
            
            end,

			IdleCommand=function(self)

                local crop = self.crop          self:smooth(1):croptop( crop + 0.25 ):smooth(1):croptop(crop)

				self:queuecommand("Idle")

			end,

			LifeChangedMessageCommand=function(self, params)

                if not playerExists(params) then return end             life = params.LifeMeter:GetLife()

                self:stoptweening()


                local rate = life * n           local crop = i - rate       self.crop = crop

                local isLimit = i == math.ceil(rate) and crop ~= 0          if isLimit then onLimit(self) end

                onInit( self, i )       self:queuecommand("Second"):queuecommand("CheckBounce")

			end,

            CheckBounceCommand=function(self)

                local isFull = self.crop <= 0

                local p = self:GetParent()          local command = isFull and '' or "No"

                p:queuecommand( command .. "Bounce" )

            end,

            FirstCommand=function(self)

                local crop = self.crop          local c = {}

                for i = 1, 4 do c[#c+1] = crop - 0.25 / i          c[#c+1] = crop + 0.25 / i end

                for i,v in ipairs(c) do self:smooth(1):croptop(v) end

            end,

            SecondCommand=function(self) self:smooth(1):croptop( self.crop ) end

		},

		-- Mask.

		pill(i) .. { InitCommand=function(self) self:invertedMaskDest() end },

        BlinkPill

	}

end

return Def.ActorFrame{ t }