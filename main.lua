g = require("code.game")

game = g:new()

function love.load()
    game:load()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end