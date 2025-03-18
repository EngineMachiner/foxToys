
local path = "Actors/DDR 4th/ScreenGameplay danger/"

return Def.ActorFrame {

    InitCommand=function(self)

        self:effectclock("beat"):set_tween_uses_effect_delta(true)

        self:queuecommand("Danger")

    end,

    DangerCommand=function(self) 

        self:sleep(2):diffusealpha(1):sleep(2):diffusealpha(0)

        self:queuecommand("Danger")

    end,

    Def.ActorFrame {

        InitCommand=function(self) self:Center():diffusealpha(0) end,

        ShowCommand=function(self)

            if self.wasDanger then return end       self.wasDanger = true

            self:stoptweening():linear(0.25):diffusealpha(1) 

        end,

        HideCommand=function(self)

            if not self.wasDanger then return end       self.wasDanger = false

            self:stoptweening():linear(0.25):diffusealpha(0) 

        end,

        HealthStateChangedMessageCommand=function(self, params)

            local isDanger = params.HealthState:match("Danger")

            local command = isDanger and "Show" or "Hide"

            self:queuecommand(command)

        end,

        foxToys.Load( path .. "Sprite" ),       foxToys.Load( path .. "Title" ),
        foxToys.Load( path .. "Overlay.lua" )

    }

}