game_game = {}
game_game.__index = game_game

map = require("code.addon.map")
scale = require("code.addon.scale")
storage = require("code.addon.storage")
screenWidth = 768
screenHeight = 432
currentWidth = screenWidth
currentHeight = screenHeight
rgb = 1/255
mtime = 0
scaleY = 1
mine = false
atime = 0
moved = false
Scale = scale:new(screenWidth, screenHeight)
mapdata = require("code.map.Survival")

Tiles = mapdata.layers[1].data
Entities = mapdata.layers[2].data

player = {
    image = nil,
    hover = {
        image = nil,
        offX = 1,
        offY = 0,
        inside = nil
    },
    scale = 3,
    x = 1, 
    y = 1,
    sx = 10,
    sy = 7,
    mx = 0,
    my = 0,
    direction = 1,
    rotate = 0
}

function game_game:new()
    local obj = {}
    setmetatable(obj, game_game)
    return obj
end

function game_game:load()
    love.graphics.setDefaultFilter("nearest", "nearest", 10)
    myFont = love.graphics.newFont("assets/DefaultFont.ttf", 18)
    love.graphics.setFont(myFont)
    player.image = love.graphics.newImage("assets/player.png")
    player.hover.image = love.graphics.newImage("assets/hover.png")
    Map = map:new(
        {Tiles, Entities},
        300,
        200,
        love.graphics.newImage("assets/tileset.png"),
        love.graphics.newImage("assets/items.png"),
        10,
        5,
        5,
        5,
        player.x, 
        player.y
    ) 
    InventoryUI = love.graphics.newImage("assets/inventory-ui.png")
    items = love.graphics.newImage("assets/items.png")
    Inventory = storage:new(InventoryUI, 9, 99, {screenWidth, screenHeight}, items, 5, 5)
    Inventory:add(3, 1)
end

function game_game:update(dt)
    player.sx = player.x + 9
    player.sy = player.y + 6
    mtime = mtime + 1
    atime = atime + 1
    cooldown = 6
    if mtime > cooldown then
        if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then 
            player.hover.offX = 1
            player.hover.offY = 0
            player.direction = 1
            if Map:getEntity(player.sx + 1, player.sy) == 0 or Map:getEntity(player.sx + 1, player.sy) > 50 then
                player.x = player.x + 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then 
            player.hover.offX = -1
            player.hover.offY = 0
            player.direction = -1
            if Map:getEntity(player.sx - 1, player.sy) == 0 or Map:getEntity(player.sx - 1, player.sy) > 50 then
                player.x = player.x - 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then 
            player.hover.offY = 1
            player.hover.offX = 0
            if Map:getEntity(player.sx, player.sy + 1) == 0 or Map:getEntity(player.sx, player.sy + 1) > 50 then
                player.y = player.y + 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then 
            player.hover.offY = -1
            player.hover.offX = 0
            if Map:getEntity(player.sx, player.sy - 1) == 0 or Map:getEntity(player.sx, player.sy - 1) > 50 then
                player.y = player.y - 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if love.keyboard.isDown("z") and mine == false and Inventory:getHolding() == 3 then
            player.hover.inside = Map:getEntity(player.sx + player.hover.offX, player.sy + player.hover.offY)
            if player.hover.inside > 0 and player.hover.inside < 50 then 
                d = player.hover.inside
                Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 0)
                if d == 14 then
                    Map:setItem(player.sx + player.hover.offX, player.sy + player.hover.offY, 1)
                end
                if d == 24 then 
                    Map:setItem(player.sx + player.hover.offX, player.sy + player.hover.offY, 2)
                end
            end
            atime = 0
            mine = true
            moved = true
        end

        if love.keyboard.isDown("x") then 
            return "craft"
        end

        if love.keyboard.isDown("1") then Inventory:hold(1) end
        if love.keyboard.isDown("2") then Inventory:hold(2) end
        if love.keyboard.isDown("3") then Inventory:hold(3) end
        if love.keyboard.isDown("4") then Inventory:hold(4) end
        if love.keyboard.isDown("5") then Inventory:hold(5) end
        if love.keyboard.isDown("6") then Inventory:hold(6) end
        if love.keyboard.isDown("7") then Inventory:hold(7) end
        if love.keyboard.isDown("8") then Inventory:hold(8) end
        if love.keyboard.isDown("9") then Inventory:hold(9) end
        if moved then mtime = 0 end
    end

    if mine == true then
        if atime <= 10 then
            player.rotate = player.rotate + 5
        end
        if atime > 10 and atime < 22 then
            player.rotate = player.rotate - 5
        end
        if atime == 22 then
            atime = 0
            mine = false
        end
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if Map:getEntity(player.sx, player.sy) > 50 then 
        d = Map:getEntity(player.sx, player.sy)
        if d == 51 then
            i = love.math.random(2)
            Inventory:add(1, i)
        end
        if d == 52 then 
            i = love.math.random(2, 4)
            Inventory:add(2, i)
        end
        Map:setEntity(player.sx , player.sy, 0)
    end

    Scale:update()

    return "game"
end

function game_game:draw()
    Scale:draw1()
    love.graphics.setColor(46*rgb, 138*rgb, 230*rgb, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)
    Map:draw()
    love.graphics.draw(player.hover.image, screenWidth / 2 - 24 + (player.hover.offX * 48), screenHeight / 2 + (player.hover.offY * 48), 0, player.scale, player.scale)
    love.graphics.draw(player.image, screenWidth / 2, screenHeight / 2 + 24, 0, player.scale * player.direction, player.scale, 8, 8)
    Inventory:draw(player.direction, player.rotate)
    Scale:draw2()
end

return game_game