
local i = ...
local jplusc = Def.ActorFrame{}

	--Judgment
	jplusc[#jplusc+1] = Def.Sprite{
		InitCommand=function(self)
			self:Load(THEME:GetPathG("","Gameplay/judgment 1x6.png"))
		end,
		OnCommand=function(self)
			local p = SCREENMAN:GetTopScreen():GetChild("PlayerP"..tostring(i))
			p:GetChild("Combo"):visible(false)
			p:GetChild("Judgment"):visible(false)
			self:xy( p:GetX(), SCREEN_CENTER_Y - 20 )
			self:animate(false)
			self:SetTextureFiltering(false)
			self:zoom(0)
			self:effectclock("beat")
			self:set_tween_uses_effect_delta(true)
		end,
		JudgmentMessageCommand=function(self, params)
			if string.match(params.Player,tostring(i)) then
				local num = string.match(params.TapNoteScore,"%d")
				num = tonumber(num)
				if num or params.TapNoteScore == 'TapNoteScore_Miss' then
					local pass
					if num then
						if num <= 2 then 
							self:setstate(0)
						else
							self:setstate(num-2)
						end
						if num >= 4 then
							pass = true
						end
					end
					if params.TapNoteScore == 'TapNoteScore_Miss' then 
						self:setstate(self:GetNumStates()-2)
						pass = "Miss"
					end
					if not params.HoldNoteScore then
						self:finishtweening()
						self:diffusealpha(1)
						if not pass then
							self:zoom(3):linear(0.25):zoom(2)
							self:sleep(1):linear(0.25):diffusealpha(0)
						elseif pass == "Miss" then
							local h = self:GetY()
							self:zoom(2)
							self:linear(0.25):y( h + 7 ):linear(0.25):y( h + 8 ):diffusealpha(0)
							self:sleep(0):y( h )
						else
							self:zoom(2):sleep(1):linear(0.25):diffusealpha(0)
						end
					end
				end
			end
		end
	}

	--Combo
	jplusc[#jplusc+1] = Def.ActorFrame{
		OnCommand=function(self)
			self.Combo = 0
			local p = SCREENMAN:GetTopScreen():GetChild("PlayerP"..tostring(i))
			self:diffusealpha(0)
			self:xy( p:GetX(), SCREEN_CENTER_Y + 25 )
			self:effectclock("beat")
			self:set_tween_uses_effect_delta(true)
			self:SetTextureFiltering(false)
		end,
		JudgmentMessageCommand=function(self, params)
			if string.match(params.Player,tostring(i)) then
				if not params.HoldNoteScore then
					local num = string.match(params.TapNoteScore,"%d")
					num = tonumber(num)
					if num then
						if num <= 3 then
							self:finishtweening()
							self:diffusealpha(1)
							self:zoom(2):linear(0.25):zoom(1):sleep(1):linear(0.25):diffusealpha(0)
						end
					end
				end
			end
		end,
		Def.BitmapText{
			Font="Combo numbers",
			InitCommand=function(self) self:PixelFont() end,
			JudgmentMessageCommand=function(self, params)

				if string.match(params.Player,tostring(i)) then

					local p = self:GetParent()
					self:diffusealpha(0)

					local num = string.match(params.TapNoteScore,"%d")
					num = tonumber(num)

					if num
					and not params.HoldNoteScore then
						if num >= 4 then 
							p.Combo = 0
						end
						if num <= 3 then
							p.Combo = p.Combo + 1
						end
					end

					if params.TapNoteScore == 'TapNoteScore_Miss' then
						p.Combo = 0
					end

					self:settext(p.Combo)
					self:x( - self:GetWidth() * 0.5 )

					if p.Combo >= 4 then 
						self:diffusealpha(1)
					end

				end

			end
		},
		Def.Sprite{
			InitCommand=function(self)
				self:Load(THEME:GetPathG("","Gameplay/judgment 1x6.png"))
				self:animate(false):setstate(self:GetNumStates()-1)
				self:SetTextureFiltering(false)
				self:xy( 30, 10 )
			end,
			JudgmentMessageCommand=function(self, params)
				if string.match(params.Player,tostring(i)) then
					self:diffusealpha(0)
					local p = self:GetParent()
					if p.Combo then
						if p.Combo >= 4 then 
							self:diffusealpha(1)
						end
					end
				end
			end
		}
	}

return Def.ActorFrame{ jplusc }