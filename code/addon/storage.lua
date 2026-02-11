-------------------
-- Storage Class --
-------------------

storage = {}
storage.__index = storage


-- create class, screenData is width, height, real width and height is the amount of tiles width and height in the refernce image (items)
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

-- add items to your inventory
function storage:add(itemID, Quantity)
    for i = 1, self.slots do
        j = self.items[i]
        if j.item == itemID then
            self.items[i] = {
                item = itemID, 
                quantity = j.quantity + Quantity
            }
            return 0
        end
        if j.item == nil then
            self.items[i] = {
                item = itemID, 
                quantity = Quantity
            }
            return 0
        end
    end
end

function storage:remove(itemID, Quantity)
    for i = 1, self.slots do
        j = self.items[i]
        if j.item == itemID and j.quantity > 0 and Quantity > 0 then
            self.items[i] = {
                item = itemID, 
                quantity = j.quantity - Quantity
            }
            return 0
        end
    end
end

function storage:set(itemID, Quantity)
    for i = 1, self.slots do
        j = self.items[i]
        if j.item == itemID then
            self.items[i] = {
                item = itemID, 
                quantity = Quantity
            }
            return 0
        end
        if j.item == nil then
            self.items[i] = {
                item = itemID, 
                quantity = Quantity
            }
            return 0
        end
    end
end

-- hold a certain item
function storage:hold(slot)
    self.holding = slot
end

-- get holding block
function storage:getHolding()
    i = self.holding
    return self.items[i].item
end

-- get quantity of holding block
function storage:getQuantity(itemID)
    for _, item in ipairs(self.items) do
        if item.item == itemID then
            return item.quantity
        end
    end
    return 0
end

-- update storage class
function storage:update()
    for i = 1, self.slots do
        j = self.items[i]
        if j.quantity < 1 then
            self.items[i] = {
                item = nil,
                quantity = 0
            }
        end
    end
end

function storage:getAll()
    return self.items
end

-- draw storage class
function storage:draw(direction, rotate)
    u = self.holding
    i = self.items[u].item
    if i then
        if direction > 0 then
            love.graphics.draw(self.itemsImage, self.itemQuads[i], self.screenData[1] / 2 + 28, self.screenData[2] / 2 + 33, math.rad(rotate), 1.5, 1.5, 8, 8)
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
                love.graphics.print(tostring(k), 107 + ((d - 1) * 72), self.screenData[2] - 45)
            else
                love.graphics.print(tostring(k), 97 + ((d - 1) * 72), self.screenData[2] - 45)
            end
            love.graphics.setColor(1,1,1,1)
            
        end
    end
end

return storage