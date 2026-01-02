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
    self.items = {}
    for i = 1, self.width do
        for j = 1, self.height do
            table.insert(self.items, love.graphics.newQuad((i-1) * 16, (j-1) * 16, 16, 16, self.itemsImage))
        end
    end
    return self
end

function storage:load()

end

function storage:draw()
    love.graphics.draw(self.itemsImage, self.items[1], self.screenData[1] / 2 + 16, self.screenData[2] / 2 + 30)
    for i = 1, self.slots do
        love.graphics.draw(self.ui, 60 + ((i - 1) * 72), self.screenData[2] - 78, 0, 3, 3)
    end
end

return storage