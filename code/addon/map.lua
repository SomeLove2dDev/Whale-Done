map = {}
map.__index = map

function map:new(layers, width, height, image, items, iWidth1, iHeight1, iWidth2, iHeight2, offX, offY)
    self = setmetatable({}, map)
    self.layers = layers or {}
    self.width = width or 0
    self.height = height or 0
    self.image = image
    self.items = items
    self.tiles = {}
    self.itiles = {}
    self.iWidth1 = iWidth1
    self.iHeight1 = iHeight1
    self.iWidth2 = iWidth2
    self.iHeight2 = iHeight2
    self.offX = offX or 0
    self.offY = offY or 0
    for j=1, self.iHeight1 do
        for i=1, self.iWidth1 do
            table.insert(self.tiles, love.graphics.newQuad((i-1) * 16, (j-1) * 16, 16, 16, self.image))
        end
    end
    for j=1, self.iHeight2 do
        for i=1, self.iWidth2 do
            table.insert(self.itiles, love.graphics.newQuad((i-1) * 16, (j-1) * 16, 16, 16, self.items))
        end
    end
    return self
end

function map:getEntity(x, y)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    return entities[idx]
end

function map:setEntity(x, y, set)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    entities[idx] = set
end

function map:setItem(x, y, set)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    entities[idx] = 50 + set
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
                if b and type(b) == "number" and b > 50 and b < 75 and dx + 48 > 0 and dx < 768 and dy + 48 > 0 and dy < 432 then
                    d = b - 50 
                    love.graphics.draw(self.items, self.itiles[d], 12 + dx, 12 + dy, 0, 1.5, 1.5)
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