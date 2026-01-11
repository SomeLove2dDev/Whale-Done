game_craft = {}
game_craft.__index = game_craft

local scale = require("code.addon.scale")
local Scale1 = scale:new(768, 432)

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
    Scale1:draw2()
end

return game_craft