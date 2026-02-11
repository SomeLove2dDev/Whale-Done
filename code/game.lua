game = {}
game.__index = game

game_game = require("code.game_state.game_game")
game_craft = require("code.game_state.game_craft")
play = game_game:new()
craft = game_craft:new()
state = {"game", "game"}
switch = true
switchState = false
time = 0
pTime = 0
save = {}
pastState = "game"

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
    pTime = pTime + 1
    cooldown = 10
    if state[2] == "game" and switch then 
        state[2] = play:update(dt, save, state[1])
        if state[2] == "craft" then
            switch = false
            time = 0
        end
        if pTime < 1 then
            state[1] = "craft"
        else
            state[1] = "game"
        end
    elseif state[2] == "craft" and switch then
        state[2] = craft:update(dt, save)
        if state[2] == "game" then
            switch = false
            time = 0
        end
        if pTime < 1 then
            state[1] = "game"
        else
            state[1] = "craft"
        end
    end

    if time > cooldown and not switch then
        switch = true
        pTime = 0
        if state[2] == "game" then
            save = craft:switch()
        elseif state[2] == "craft" then
            save = play:switch()
        end
    end
end

function game:draw()
    if state[2] == "game" then 
        play:draw()
    elseif state[2] == "craft" then
        craft:draw()
    end
end

function game:getScale() 
    Scale:getScale()
end

return game