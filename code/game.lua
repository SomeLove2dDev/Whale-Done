game = {}
game.__index = game

game_game = require("code.game_state.game_game")
game_craft = require("code.game_state.game_craft")
play = game_game:new()
craft = game_craft:new()
state = "game"
switch = true
time = 0

function game:new()
    local obj = {}
    setmetatable(obj, game)
    return obj
end

function game:load()
    play:load()
    craft:load()
end

function game:update(dt)
    time = time + 1
    cooldown = 10
    if state == "game" and switch then 
        state = play:update(dt)
        if state == "craft" then
            switch = false
            time = 0
        end
    elseif state == "craft" and switch then
        state = craft:update(dt)
        if state == "game" then
            switch = false
            time = 0
        end
    end

    if time > cooldown and not switch then
        switch = true
    end 
end

function game:draw()
    if state == "game" then 
        play:draw()
    elseif state == "craft" then
        craft:draw()
    end
end

function game:getScale() 
    Scale:getScale()
end

return game