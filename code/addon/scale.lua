scale = {}
scale.__index = scale

function scale:new(sx, sy)
    self = setmetatable({}, scale)
    self.sx = sx
    self.sy = sy
    self.scaleY = 1
    self.offX = 0
    self.currentWidth = self.sx
    self.currentHeight = self.sy
    self.flags = {}
    return self
end

function scale:update()
    if self.currentHeight ~= self.sy * self.scaleY then
        self.scaleY = self.currentHeight / self.sy
        love.window.updateMode(self.currentWidth * self.scaleY, self.currentHeight * self.scaleY, self.flags)
    end
end

function scale:draw1()
    love.graphics.push()

    self.currentWidth, self.currentHeight, self.flags = love.window.getMode()
    self.offX = (self.currentWidth - (self.sx * self.scaleY)) / 2
    love.graphics.translate(self.offX, 0)
    self.scaleY = self.currentHeight / self.sy
    
    love.graphics.scale(self.scaleY, self.scaleY)
end

function scale:draw2()
    love.graphics.origin()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, self.offX, self.currentHeight)
    love.graphics.rectangle("fill", self.currentWidth - self.offX, 0, self.offX, self.currentHeight)

    love.graphics.pop()
end

return scale