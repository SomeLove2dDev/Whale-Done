storage = {}
storage.__index = storage

function storage:new(ui, slots, maxCount, screenData, items, width, height)
    self = setmetatable(self, storage)
    self.slots = slots
    self.ui = ui
    self.screenData = screenData
    self.maxCount = maxCount
    self.itemsImage = items
    self.width = width
    self.height = height
    self.itemQuads = {}
    self.items = {}
    self.holding = 1
    for i = 1, self.width do
        for j = 1, self.height do
            table.insert(self.itemQuads, love.graphics.newQuad((j - 1) * 16, (i - 1) * 16, 16, 16, self.itemsImage))
        end
    end
    for i = 1, self.slots do
        table.insert(self.items, {item = nil, quantity = 0})
    end
    return self
end

function storage:newItem(slot, itemID, Quantity)
    i = slot
    self.items[i] = {
        item = itemID, 
        quantity = Quantity
    }
end

function storage:add(itemID, Quantity)
    i = slot
    if self.items[i].quantity < self.maxCount then
        self.items[i].quantity = self.items[i].quantity + Quantity
    end
end

function storage:hold(slot)
    self.holding = slot
end

function storage:draw(direction, rotate)
    u = self.holding
    i = self.items[u].item
    if i then
        if direction > 0 then
            love.graphics.draw(self.itemsImage, self.itemQuads[i], self.screenData[1] / 2 + 18, self.screenData[2] / 2 + 33, math.rad(rotate), 1.5, 1.5, 8, 8)
        else
            love.graphics.draw(self.itemsImage, self.itemQuads[i], self.screenData[1] / 2 - 2, self.screenData[2] / 2 + 33, math.rad(-rotate), -1.5, 1.5, 8, 8)
        end
        
    end

    for d = 1, self.slots do
        j = self.items[d].item
        k = self.items[d].quantity
        if d == u then
            love.graphics.rectangle("fill", 60 + ((d - 1) * 72), self.screenData[2] - 78, 72, 72)
        end
        love.graphics.draw(self.ui, 60 + ((d - 1) * 72), self.screenData[2] - 78, 0, 3, 3)
        if j then
            
            love.graphics.draw(self.itemsImage, self.itemQuads[j], 76 + ((d - 1) * 72), self.screenData[2] - 62, 0, 2.5, 2.5)
            love.graphics.setColor(0,0,0,1)
            if k < 10 then
                love.graphics.print(tostring(k), 107 + ((d - 1) * 72), self.screenData[2] - 40)
            else
                love.graphics.print(tostring(k), 100 + ((d - 1) * 72), self.screenData[2] - 40)
            end
            love.graphics.setColor(1,1,1,1)
            
        end
    end
end

return storage