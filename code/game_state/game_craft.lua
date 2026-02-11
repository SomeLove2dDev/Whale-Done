------------------
-- Game : Craft --
------------------

game_craft = {}
game_craft.__index = game_craft

-- set variables and get required code
local scale = require("code.addon.scale")
local Scale1 = scale:new(768, 432)
button = require("code.addon.button")
blocks = {}
Buttons = {}
hold = false
held = true
bReturn = {{false, 0}, {false, 0}}
have = {}
q1 = false
q2 = false
q3 = false
q4 = false
bQty = {
    0,
    0,
    0
}
text = {
    "bridge",
    "workbench",
    "wood",
}
recipe = {
    "x3",
    "x5   + x4",
    "x4"
}
rgb = 1/255
bqt = 3
for i=1, bqt do
    table.insert(Buttons, button:new(150, 100 + (i-1) * 60, 500, 50, text[i], -150, 0, {87 * rgb, 114 * rgb, 119 * rgb, 1}))
end

-- create game craft
function game_craft:new()
    local obj = {}
    setmetatable(obj, game_craft)
    return obj
end

-- load function for game craft
function game_craft:load()
    love.graphics.setDefaultFilter("nearest", "nearest", 18)
    myFont = love.graphics.newFont("assets/DefaultFont.ttf", 36)
    love.graphics.setFont(myFont)
    blocksMain = love.graphics.newImage("assets/items.png")
    for i=1, 5 do
        for j=1, 5 do
            table.insert(blocks, love.graphics.newQuad((j-1) * 16, (i-1) * 16, 16, 16, blocksMain))
        end
    end
    logo = {
        blocks[4],
        blocks[5],
        blocks[1]
    }
end

-- update function for game craft
function game_craft:update(dt, save)
    have = save
    d = 0
    if love.mouse.isDown(1) then
        hold = true
    elseif not love.mouse.isDown(1) then
        hold = false
        held = false
    end
    if not held and hold then
        for _, b in ipairs(Buttons) do
            d = d + 1
            if b:Clicked(Scale1:getScale()) == true then
                bQty[d] = bQty[d] + 1
                bReturn[d] = {true, bQty[d]}
            end
        end
        held = true
    end

    -- controlls
    -- switch to game
    if love.keyboard.isDown("x") then
        return "game"
    end
    -- exit
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    Scale1:update()

    return "craft"
end

-- draw function for game craft
function game_craft:draw()
    for _, item in ipairs(have) do
        if item.item == 1 then
            if item.quantity >= 3 and item.quantity then 
                q1 = true
                if item.quantity >= 5 then q2 = true end
            else
                q1 = false
                q2 = false
            end
        elseif item.item == 2 and item.quantity then
            if item.quantity >= 4 then q3 = true 
            else q3 = false end
        elseif item.item == 7 and item.quantity then
            if item.quantity >= 4 then q4 = true 
            else q4 = false end
        end
    end

    Scale1:draw1()

    d = 1
    love.graphics.setColor(199 * rgb, 207 * rgb, 204 * rgb, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 500)
    love.graphics.setColor(1, 1, 1, 1)
    for _, Button in ipairs(Buttons) do
        Button:draw()
        a, b = Button:getPos()
        love.graphics.setColor(16 * rgb, 20 * rgb, 31 * rgb, 1)
        love.graphics.rectangle("fill", a + 6, b + 6, 38, 38)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(blocksMain, logo[d], a + 9, b + 9, 0, 2, 2)
        love.graphics.setColor(0,0,0,1)
        love.graphics.print(recipe[d], a + 100, b + 35, 0, 0.5, 0.5)
        love.graphics.setColor(1,1,1,2/4)
        if d == 1 then
            if q1 then love.graphics.setColor(1,1,1,1) end
            love.graphics.draw(blocksMain, blocks[1], a + 115, b + 36, 0, 3/4, 3/4)
            love.graphics.setColor(1,1,1,2/4)
        elseif d == 2 then
            if q2 then love.graphics.setColor(1,1,1,1) end
            love.graphics.draw(blocksMain, blocks[1], a + 115, b + 36, 0, 3/4, 3/4)
            love.graphics.setColor(1,1,1,2/4)
            if q3 then love.graphics.setColor(1,1,1,1) end
            love.graphics.draw(blocksMain, blocks[2], a + 165, b + 36, 0, 3/4, 3/4)
            love.graphics.setColor(1,1,1,2/4)
        elseif d == 3 then
            if q4 then love.graphics.setColor(1,1,1,1) end
            love.graphics.draw(blocksMain, blocks[7], a + 115, b + 36, 0, 3/4, 3/4)
            love.graphics.setColor(1,1,1,2/4)
        end
        love.graphics.setColor(1,1,1,1)
        d = d + 1
    end

    Scale1:draw2()
end

function game_craft:switch()
    return bReturn
end

return game_craft