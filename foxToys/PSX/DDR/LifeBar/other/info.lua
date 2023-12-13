
local M = Def.ActorFrame{}

local lim0,lim1 = 0,0

local ply = GAMESTATE:GetHumanPlayers()
if #ply > 0  then
	local s = string.match(ply[1],"%d")
	if s then 
		lim0 = tonumber(s)
	end

	if #ply > 1 then 
		local s = string.match(ply[2],"%d")
		if s then 
			lim1 = tonumber(s)
		end
	else
		lim1 = lim0
	end
end

local name = "ScreenGameplay"
for i=lim0,lim1 do

	M[#M+1] = loadfile( THEME:GetPathB( name, "overlay/J+C.lua" ) )( i )

	M[#M+1] = Def.Sprite{
		OnCommand=function(self)

			if SCREENMAN:GetTopScreen():GetName() ~= "ScreenDemonstration" then

				local diff = {
					"Difficulty_Beginner",
					"Difficulty_Easy",
					"Difficulty_Medium",
					"Difficulty_Hard",
					"Difficulty_Challenge",
					"Battle"
				}

				self:Load(THEME:GetPathG("","Gameplay/difficulty 1x6.png"))
				self:zoom(2.5)
				self:SetTextureFiltering(false)
				self:xy(self:GetZoomedWidth()*0.6125,SCREEN_BOTTOM-35*2-self:GetZoomedHeight()*0.5)
				if i == 2 then 
					self:xy(SCREEN_RIGHT-self:GetZoomedWidth()*0.6125,SCREEN_BOTTOM-35*2-self:GetZoomedHeight()*0.5)
				end
				self:animate(false)

				local song = GAMESTATE:GetCurrentSong()
				for k=1,#diff do
					if diff[k] == GAMESTATE:GetCurrentSteps(i-1,song):GetDifficulty() then
						self:setstate(k-1)
					break
					end
				end

			end

		end
	}

end

return Def.ActorFrame{ M }