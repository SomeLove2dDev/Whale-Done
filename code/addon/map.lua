map = {}
map.__index = map

function map:new(layers, width, height, image, iWidth, iHeight, offX, offY)
    self = setmetatable({}, map)
    self.layers = layers or {}
    self.width = width or 0
    self.height = height or 0
    self.image = image
    self.tiles = {}
    self.iWidth = iWidth
    self.iHeight = iHeight
    self.offX = offX or 0
    self.offY = offY or 0
    for j=1, self.iHeight do
        for i=1, self.iWidth do
            table.insert(self.tiles, love.graphics.newQuad((i-1) * 16, (j-1) * 16, 16, 16, self.image))
        end
    end
    return self
end

function map:getEntity(x, y)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    return entities[idx]
end

function map:draw()
    for _, layer in ipairs(self.layers) do
        for x=1, self.width do
            for y=1, self.height do
                a = ((y-1) * self.width) + x
                b = layer[a]
                dx = ((x-1) * 48) - self.offX * 48 - 24
                dy = ((y-1) * 48) - self.offY * 48 - 24
                if b and type(b) == "number" and b > 0 and b < 50 and dx + 48 > 0 and dx < 768 and dy + 48 > 0 and dy < 432 then
                    love.graphics.draw(self.image, self.tiles[b], dx, dy, 0, 3, 3)
                end
            end
        end
    end
end

function map:setOffset(x, y)
    self.offX = x
    self.offY = y
end

return map