game_craft = {}
game_craft.__index = game_craft

local scale = require("code.addon.scale")
local Scale1 = scale:new(768, 432)
button = require("code.addon.button")
blocksMain = love.graphics.newImage("assets/blocks.png")
blocks = {}
for i=1, 5 do
    for j=1, 5 do
        table.insert(blocks, love.graphics.newQuad((i-1) * 16, (j-1) * 16, 16, 16, blocksMain))
    end
end
Buttons = {}
text = {
    "bridge",
    "workbench",
    "smelter",
    "item",
    "item",
    "item"
}
logo = {
    blocks[1],
    nil,
    nil,
    nil,
    nil,
    nil,
}
rgb = 1/255
bqt = 6
for i=1, bqt do
    table.insert(Buttons, button:new(400, 30 + (i-1) * 60, 300, 50, text[i], 0, 0, {125 * rgb, 125 * rgb, 125 * rgb, 1}, nil))
end

Large = {
    image = button:new(80, 70, 300, 270 ,"item", 0, 0, {150 * rgb, 150 * rgb, 150 * rgb, 1}, nil),
    focus = 1
}

function game_craft:new()
    local obj = {}
    setmetatable(obj, game_craft)
    return obj
end

function game_craft:load()

end

function game_craft:update(dt)
    if love.keyboard.isDown("x") then
        return "game"
    end
    
    Scale1:update()

    return "craft"
end

function game_craft:draw()
    Scale1:draw1()

    for _, Button in ipairs(Buttons) do
        Button:draw(blocksMain)

    end

    Large.image:draw()

    Scale1:draw2()
end

return game_craft