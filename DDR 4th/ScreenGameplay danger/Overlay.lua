
return Def.Quad {

    InitCommand=function(self) 
        
        self:setsize( SCREEN_WIDTH, SCREEN_HEIGHT )

        self:diffuse( Color.Black ):diffusealpha(0.5) 
    
    end

} 