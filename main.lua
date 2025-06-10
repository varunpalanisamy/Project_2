local Game = require("game")

function love.load()
    -- love.window.setMode(1024, 768)
    -- love.math.setRandomSeed(os.time())
    -- love.math.random() 
    -- love.math.random()
    -- love.math.random()


    love.window.setMode(1024, 768)


    math.randomseed(os.time())

    math.random(); math.random(); math.random()

    Game:load()
end


function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end

function love.mousepressed(x, y, button)
    Game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    Game:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    Game:mousemoved(x, y, dx, dy)
end
