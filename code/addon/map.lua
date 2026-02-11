---------------
-- Map Class --
---------------

map = {}
map.__index = map

-- layers order: Tiles, Entities, width and height is of the layers, image is the refernce tilemap, items is the reference items map, iwidth1, iwidth2, iheight1, iheight2, is the width and height of the reference images (image (1), items(2)), offX, offY is the offset of the map (based on tiles) --
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

-- get Entity tile on x, y
function map:getEntity(x, y)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    return entities[idx]
end

-- set Entity tile on x, y
function map:setEntity(x, y, set)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    entities[idx] = set
end

-- set Tile on x, y
function map:setTile(x, y, set, item)
    local entities = self.layers[1]
    local idx = ((y - 1) * self.width) + x
    if not item then
        entities[idx] = set
    elseif item then
        entities[idx] = 50 + set
    else
        return 0
    end
end
-- set Item tile on x, y
function map:setItem(x, y, set)
    local entities = self.layers[2]
    local idx = ((y - 1) * self.width) + x
    entities[idx] = 50 + set
end

-- draw map, assumes tile size is 16 by 16
function map:draw()
    for _, layer in ipairs(self.layers) do
        for x=1, self.width do
            for y=1, self.height do
                a = ((y-1) * self.width) + x
                b = layer[a]
                d = b - 50
                dx = ((x-1) * 48) - self.offX * 48 - 24
                dy = ((y-1) * 48) - self.offY * 48 - 24
                if b and type(b) == "number" and b > 0 and dx + 48 > 0 and dx < 768 and dy + 48 > 0 and dy < 432 then
                    if b < 50 then 
                        love.graphics.draw(self.image, self.tiles[b], dx, dy, 0, 3, 3)
                    elseif d == 1 or d == 2 or d == 3 or d == 6 or d == 7 then
                        love.graphics.draw(self.items, self.itiles[d], 12 + dx, 12 + dy, 0, 1.5, 1.5)
                    elseif d == 4 or d == 5 then
                        love.graphics.draw(self.items, self.itiles[d], dx, dy, 0, 3, 3)
                    end
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