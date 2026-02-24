-----------------
-- Game : Game --
-----------------

game_game = {}
game_game.__index = game_game

-- set variables and get required code
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
saved = false

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
    x = 135, 
    y = 90,
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

-- load function for game
function game_game:load()
    love.graphics.setDefaultFilter("nearest", "nearest", 18)
    myFont = love.graphics.newFont("assets/font/DefaultFont.ttf", 36)
    love.graphics.setFont(myFont)
    player.image = love.graphics.newImage("assets/sprites/player.png")
    player.hover.image = love.graphics.newImage("assets/sprites/hover.png")
    Map = map:new(
        {Tiles, Entities},
        300,
        200,
        love.graphics.newImage("assets/sprites/tileset.png"),
        love.graphics.newImage("assets/sprites/items.png"),
        10,
        5,
        5,
        5,
        player.x, 
        player.y
    ) 
    InventoryUI = love.graphics.newImage("assets/sprites/inventory-ui.png")
    items = love.graphics.newImage("assets/sprites/items.png")
    Inventory = storage:new(InventoryUI, 9, 99, {screenWidth, screenHeight}, items, 5, 5)
    Inventory:add(3, 1)
    Inventory:add(6, 5)
end

-- update function for game
function game_game:update(dt, save, past)
    -- get saved info from craft
    d = 0
    if past == "craft" then
        saved = false
    end
    for _, thing in ipairs(save) do
        d = d + 1
        if thing[1] == true and not saved then
            if d == 1 then
                cQ1 = Inventory:getQuantity(4)
                added = thing[2] - cQ1
                for i = 1, added do
                    if Inventory:getQuantity(4) < thing[2] and Inventory:getQuantity(1) >= 3 then
                        Inventory:set(4, cQ1 + i)
                        Inventory:remove(1, 3)
                    end
                end
            elseif d == 2 then 
                cQ2 = Inventory:getQuantity(5)
                added = thing[2] - cQ2
                
                for i = 1, added do
                    if Inventory:getQuantity(5) < thing[2] and Inventory:getQuantity(1) >= 5 and Inventory:getQuantity(2) >= 4 then
                        Inventory:set(14, cQ2 + i)
                        Inventory:remove(1, 5)
                        Inventory:remove(2, 4)
                    end
                end
            elseif d == 3 then
                cQ3 = Inventory:getQuantity(1)
                added = thing[2] - cQ3
                for i = 1, added do
                    if Inventory:getQuantity(1) < thing[2] and Inventory:getQuantity(7) >= 4 then
                        Inventory:set(1, cQ3 + i)
                        Inventory:remove(7, 4)
                    end
                end
            end
        end
    end
    saved = true
    player.sx = player.x + 9
    player.sy = player.y + 6
    mtime = mtime + dt
    atime = atime + dt
    cooldown = 0.1

    -- check keys
    if mtime > cooldown then
        -- movement
        if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then 
            player.hover.offX = 1
            player.hover.offY = 0
            player.direction = 1
            if Map:getEntity(player.sx + 1, player.sy) == 0 or Map:getEntity(player.sx + 1, player.sy) < 64 and Map:getEntity(player.sx + 1, player.sy) > 50 then
                player.x = player.x + 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then 
            player.hover.offX = -1
            player.hover.offY = 0
            player.direction = -1
            if Map:getEntity(player.sx - 1, player.sy) == 0 or Map:getEntity(player.sx - 1, player.sy) < 64 and Map:getEntity(player.sx - 1, player.sy) > 50 then
                player.x = player.x - 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then 
            player.hover.offY = 1
            player.hover.offX = 0
            if Map:getEntity(player.sx, player.sy + 1) == 0 or Map:getEntity(player.sx, player.sy + 1) < 64 and Map:getEntity(player.sx, player.sy + 1) > 50 then
                player.y = player.y + 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then 
            player.hover.offY = -1
            player.hover.offX = 0
            if Map:getEntity(player.sx, player.sy - 1) == 0 or Map:getEntity(player.sx, player.sy - 1) < 64 and Map:getEntity(player.sx, player.sy - 1) > 50 then
                player.y = player.y - 1
                Map:setOffset(player.x, player.y) 
            end
            moved = true
        end
        -- interact
        if love.keyboard.isDown("z") and mine == false then
            -- mine
            holding = Inventory:getHolding()
            if holding == 3 then
                player.hover.inside = Map:getEntity(player.sx + player.hover.offX, player.sy + player.hover.offY)
                if player.hover.inside > 0 and player.hover.inside < 50 then 
                    d = player.hover.inside
                    Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 0, false)
                    if d == 14 then
                        Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 1, true)
                    end
                    if d == 24 then 
                        Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 2, true)
                    end
                    if d == 4 then
                        i = love.math.random(10)
                        if i < 2 then 
                            Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 6, true)
                        else
                            Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 7, true)
                        end
                    end
                    if d == 34 then
                        i = love.math.random(3)
                        if i <= 2 then 
                            Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 6, true)
                        else
                            Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 7, true)
                        end
                    end
                end
                atime = 0
                if not mine then
                    mine = true
                end
                moved = true
            end
            --place
            if Inventory:getQuantity(holding) > 0 then
                if Map:getEntity(player.sx + player.hover.offX, player.sy + player.hover.offY) == 50 then
                    if holding == 4 then
                        Map:setTile(player.sx + player.hover.offX, player.sy + player.hover.offY, 4, true)
                        Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 0, false)
                        Inventory:remove(4, 1)
                    end
                else
                    if holding == 14 then
                        Map:setEntity(player.sx + player.hover.offX, player.sy + player.hover.offY, 14, true)
                        Inventory:remove(14, 1)
                    end
                end
            end
        end
        -- switch to craft
        if love.keyboard.isDown("x") then 
            return "craft"
        end

        -- switch holding item
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

    -- mining animation
    if mine == true then
        if atime <= 0.15 then
            player.rotate = player.rotate + 5
        end
        if atime > 0.2 and atime < 0.365 then
            player.rotate = player.rotate - 5
        end
        if atime >= 0.415 then
            atime = 0
            while player.rotate ~= 0 do
                if player.rotate > 0 then
                    player.rotate = player.rotate - 5
                elseif player.rotate < 0 then
                    player.rotate = player.rotate + 5
                end
            end
            mine = false
        end
    end

    -- exit
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- collect items
    if Map:getEntity(player.sx, player.sy) > 50 then 
        d = Map:getEntity(player.sx, player.sy)
        if d == 51 then
            i = love.math.random(3)
            Inventory:add(1, i)
            Map:setEntity(player.sx , player.sy, 0, false)
        end
        if d == 52 then 
            i = love.math.random(2)
            Inventory:add(2, i)
            Map:setEntity(player.sx , player.sy, 0, false)
        end
        if d == 56 then
            i = love.math.random(2)
            Inventory:add(6, i)
            Map:setEntity(player.sx , player.sy, 0, false)
        end
        if d == 57 then
            i = love.math.random(2, 4)
            Inventory:add(7, i)
            Map:setEntity(player.sx , player.sy, 0, false)
        end
    end

    Scale:update()
    Inventory:update()

    return "game"
end

-- draw function for game
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

function game_game:switch()
    return Inventory:getAll()
end

return game_game