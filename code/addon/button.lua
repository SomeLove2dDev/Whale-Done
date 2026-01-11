Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, color, onClick)
    self = setmetatable({}, Button)
    self.x = x
    self.y = y
    self.text = text
    self.width = width
    self.height = height
    self.color = color
    self.onClick = onClick
    return self
end

function Button:Clicked(i)
    local mx, my = love.mouse.getPosition()
    local i = i or 1
    if mx > self.x * i and mx < (self.x + self.width) * i and my > self.y * i and my < (self.y + self.height) * i and love.mouse.isDown(1) then
        if self.onClick then
            self.onClick()
        end
    end
end

function Button:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(self.text, self.x + self.width / 2 - 9, self.y + self.height / 2 - 9)
    love.graphics.setColor(1,1,1,1)
end

return Button