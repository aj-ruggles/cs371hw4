local Brick = {}

--= Color Associates Hit Points(hp)
local red, blue, yellow, gray = 0, 1, -1, -1

function Brick:new( o, x, y, color )
    o = o or {}
    o.x = x or 0
    o.y = y or 0
    --= create a new brick with these colors to display on the screen
    o.brick = display.newRect( o.x, o.y, o.width, o.height )
    if color == "red" then 
        o.hp = 1
        o.color = red 
        o.brick:setFillColor(1,0,0)         --= red color
    elseif color == "blue" then 
        o.hp = 2
        o.color = blue
        o.brick:setFillColor(0,0,1)         --= blue color
    elseif color == "yellow" then 
        o.hp = -1
        o.color = yellow
        o.brick:setFillColor(1,1,0)         --= yellow color
    else 
        o.hp = -1
        o.color = gray
        o.brick:setFillColor(.5,.5,.5)      --= gray color
    end

    setmetatable( o, self )
    self.__index = self
    return o
end

function Brick:swapColor()
    if self.color == red then 
        self.hp = 1
        self.color = blue
        self.brick:setFillColor(0,0,1)
    elseif self.color == blue then 
        self.hp = 0
        self.color = red 
        self.brick:setFillColor(1,0,0)
    end
end

return Brick