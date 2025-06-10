-- game.lua
local Deck   = require("deck")
local Pile   = require("pile")
local Card   = require("card")

local Game = {}

-- load our button images
local resetImg = love.graphics.newImage("assets/reset.png")
local winImg   = love.graphics.newImage("assets/winner.png")

-- compute their sizes & positions

local RESET_SCALE = 0.25
local RESET_W, RESET_H = resetImg:getWidth() * RESET_SCALE, resetImg:getHeight() * RESET_SCALE
local RESET_X = 1024/2 - RESET_W/2
local RESET_Y = 700

local WIN_SCALE = 0.25
local WIN_W, WIN_H = winImg:getWidth(), winImg:getHeight()
local WIN_X = 350
local WIN_Y = 425 -- centered vertically

function Game:load()
    self.won = false

    -- shuffle
    self.deck = Deck:new()
    self.deck:shuffle()

    -- stock & waste
    self.stock = Pile:new("stock", 50, 50)
    self.waste = Pile:new("waste", 150, 50)
    while true do
        local c = self.deck:draw()
        if not c then break end
        c.faceUp = false
        self.stock:addCard(c)
    end

    -- tableau
    self.tableau = {}
    for i=1,7 do
        local p = Pile:new("tableau", 50 + (i-1)*120, 200)
        for j=1,i do
            local c = self.stock:drawTop()
            c.faceUp = (j==i)
            p:addCard(c)
        end
        table.insert(self.tableau, p)
    end

    -- foundations
    self.foundations = {}
    for i=1,4 do
        table.insert(self.foundations, Pile:new("foundation", 500 + (i-1)*120, 50))
    end

    -- drag
    self.held = nil
    self.originPile = nil
end

function Game:update(dt) end

function Game:draw()
    love.graphics.clear(0, 128/255, 0)

    -- draw piles
    self.stock:draw()
    self.waste:draw()

    love.graphics.setColor(1,1,1)
    for _, f in ipairs(self.foundations) do
        love.graphics.rectangle("line", f.x, f.y, Card.SLOT_WIDTH, Card.SLOT_HEIGHT)
    end
    for _, f in ipairs(self.foundations) do f:draw() end
    for _, t in ipairs(self.tableau)     do t:draw() end

    -- draw held cards
    if self.held then
        local mx,my = love.mouse.getPosition()
        for i,c in ipairs(self.held) do
            c:drawAt(mx, my + (i-1)*20)
        end
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(resetImg, RESET_X, RESET_Y, 0, RESET_SCALE, RESET_SCALE)
    if self.won then

        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle("fill", 0,0,1024,768)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(winImg, WIN_X, WIN_Y, 0, WIN_SCALE, WIN_SCALE)
    end

end

function Game:mousepressed(x,y,button)
    if button~=1 then return end

    if x>=RESET_X and x<=RESET_X+RESET_W and y>=RESET_Y and y<=RESET_Y+RESET_H then
        math.randomseed(os.time())
        math.random(); math.random(); math.random()
        self:load()
        return
    end

    if self.won then return end

    local function pickFrom(pile)
        local stack = pile:pickUp(x,y)
        if stack then
            self.held = stack
            self.originPile = pile
            return true
        end
        return false
    end

    if self.stock:contains(x,y) then
        if #self.stock.cards>0 then
            for i=1,3 do
                local c = self.stock:drawTop()
                if not c then break end
                c.faceUp = true
                self.waste:addCard(c)
            end
        else
            while #self.waste.cards>0 do
                local c = self.waste:drawTop()
                c.faceUp = false
                table.insert(self.stock.cards,1,c)
            end
            self.stock:updateCardPositions()
        end
        return
    end

    -- pick from waste or tableau
    if pickFrom(self.waste) then return end
    for _,t in ipairs(self.tableau) do
        if pickFrom(t) then return end
    end
end

function Game:mousereleased(x,y,button)
    if button~=1 or not self.held then return end

    local dropped = false
    -- foundations
    for _,f in ipairs(self.foundations) do
        if f:canAccept(self.held[1]) and f:contains(x,y) then
            f:addCards(self.held)
            dropped = true
            break
        end
    end
    -- tableau
    if not dropped then
        for _,t in ipairs(self.tableau) do
            if t:canAccept(self.held[1]) and t:contains(x,y) then
                t:addCards(self.held)
                dropped = true
                break
            end
        end
    end

    if not dropped then
        self.originPile:addCards(self.held)
    end

    -- auto flip
    if self.originPile.type=="tableau" then
        local cards = self.originPile.cards
        if #cards>0 then
            local top = cards[#cards]
            if not top.faceUp then
                top.faceUp = true
                self.originPile:updateCardPositions()
            end
        end
    end

    self.held = nil
    self.originPile = nil

    -- check win
    local all13 = true
    for _,f in ipairs(self.foundations) do
        if #f.cards<13 then all13=false; break end
    end
    self.won = all13
end

function Game:mousemoved(x,y,dx,dy) end

return Game
