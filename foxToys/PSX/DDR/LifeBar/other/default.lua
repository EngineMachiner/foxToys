
local function SGMetric(s)
	return THEME:GetMetric("ScreenGameplay",s)
end

local function CheckPlayer(self, n)
	local t = GAMESTATE:GetEnabledPlayers()
	for i=1,#t do
		if string.match(t[i],tostring(n)) then
		break
		elseif i == #t then
			self:visible(false)
		end
	end
end

local n = GAMESTATE:GetCurrentStage()
n = string.match( n, "%d" )

return Def.ActorFrame{

	OnCommand=function(self)
		KMBranch.ChildrenNoFiltering(self)
		KMBranch.IntInput(false)
	end,

	Def.ActorFrame{

		InitCommand=function(self)
			CheckPlayer(self, 1)
		end,

		loadfile( THEME:GetPathG("","Gameplay/LifeMeterBar") )( {
			Player = 1,
			Pos = {
				SGMetric("LifeP1X"),
				SGMetric("LifeP1Y")
			}
		} )

	},

	Def.ActorFrame{

		InitCommand=function(self)
			CheckPlayer(self, 2)
		end,

		loadfile( THEME:GetPathG("","Gameplay/LifeMeterBar") )( {
			Player = 2,
			Pos = {
				SGMetric("LifeP2X"),
				SGMetric("LifeP2Y")
			}
		} )
				
	},

	Def.ActorFrame{

		InitCommand=function(self)
			self:Center()
			self:y( SCREEN_TOP + 44 )
			self:zoom(2)
		end,

		Def.Sprite{
			OnCommand=function(self)
				if not n then
					self:Load(THEME:GetPathG("","Gameplay/demo"))
				else
					n = tonumber(n)
					self:Load(THEME:GetPathG("","Gameplay/stages 1x7"))
					self:animate(false)
					self:setstate(n)
					self:y( - self:GetHeight() * 0.4 )
				end
			end
		},

		Def.Sprite{
			OnCommand=function(self)
				if not n then
					self:visible(false)
				end
				self:Load(THEME:GetPathG("","Gameplay/stages 1x7"))
				self:animate(false):setstate(6)
				self:y( self:GetHeight() * 0.4 )
			end
		}

	},

	loadfile( THEME:GetPathB( 
		"ScreenGameplay", 
		"overlay/info.lua"
	) )()

}