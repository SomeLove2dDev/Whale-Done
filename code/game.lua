game = {}
game.__index = game

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
    my = 0
}

function game:new()
    local obj = {}
    setmetatable(obj, game)
    return obj
end

function game:load()
    love.graphics.setDefaultFilter("nearest", "nearest", 10)
    player.image = love.graphics.newImage("assets/player.png")
    player.hover.image = love.graphics.newImage("assets/hover.png")
    Map = map:new(
        {Tiles, Entities},
        300,
        200,
        love.graphics.newImage("assets/tileset.png"),
        10,
        5,
        player.x, 
        player.y
    ) 
    InventoryUI = love.graphics.newImage("assets/inventory-ui.png")
    items = love.graphics.newImage("assets/items.png")
    Inventory = storage:new(InventoryUI, 9, 99, {screenWidth, screenHeight}, items, 5, 5)
    
end

function game:update(dt)
    player.sx = player.x + 9
    player.sy = player.y + 6
    mtime = mtime + 1
    cooldown = 5
    if mtime > cooldown then
        if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then 
            player.hover.offX = 1
            player.hover.offY = 0
            if Map:getEntity(player.sx + 1, player.sy) == 0 then
                player.x = player.x + 1
                Map:setOffset(player.x, player.y) 
            end
        end
        if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then 
            player.hover.offX = -1
            player.hover.offY = 0
            if Map:getEntity(player.sx - 1, player.sy) == 0 then
                player.x = player.x - 1
                Map:setOffset(player.x, player.y) 
            end
        end
        if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then 
            player.hover.offY = 1
            player.hover.offX = 0
            if Map:getEntity(player.sx, player.sy + 1) == 0 then
                player.y = player.y + 1
                Map:setOffset(player.x, player.y) 
            end
        end
        if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then 
            player.hover.offY = -1
            player.hover.offX = 0
            if Map:getEntity(player.sx, player.sy - 1) == 0 then
                player.y = player.y - 1
                Map:setOffset(player.x, player.y) 
            end
        end
        if love.keyboard.isDown("z") then
            player.hover.inside = Map:getEntity(player.sx + player.hover.offX, player.sy + player.hover.offY)
        end
        mtime = 0
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    Scale:update()
end

function game:draw()
    Scale:draw1()

    love.graphics.setColor(46*rgb, 138*rgb, 230*rgb, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)
    Map:draw()
    love.graphics.draw(player.hover.image, screenWidth / 2 - 24 + (player.hover.offX * 48), screenHeight / 2 + (player.hover.offY * 48), 0, player.scale, player.scale)
    love.graphics.draw(player.image, screenWidth / 2 - 24, screenHeight / 2, 0, player.scale, player.scale)
    Inventory:draw()

    Scale:draw2()
end

return game