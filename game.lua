local Deck = require("deck")
local Pile = require("pile")
local Card = require("card")

local Game = {}

function Game:load()
    self.deck = Deck:new()
    self.deck:shuffle()

    self.stock = Pile:new("stock", 50,  50)
    self.waste = Pile:new("waste", 150, 50)
    while true do
        local c = self.deck:draw()
        if not c then break end
        c.faceUp = false
        self.stock:addCard(c)
    end

    self.tableau = {}
    for i = 1, 7 do
        local p = Pile:new("tableau",  50 + (i-1)*120, 200)
        for j = 1, i do
            local c = self.stock:drawTop()
            c.faceUp = (j == i)
            p:addCard(c)
        end
        table.insert(self.tableau, p)
    end

    self.foundations = {}
    for i = 1, 4 do
        table.insert(self.foundations,
            Pile:new("foundation", 500 + (i-1)*120, 50)
        )
    end

    self.held       = nil
    self.originPile = nil
end

function Game:update(dt) end

function Game:draw()

    love.graphics.clear(0, 128/255, 0)

    self.stock:draw()


    self.waste:draw()

    love.graphics.setColor(1,1,1)
    for _, f in ipairs(self.foundations) do
        love.graphics.rectangle(
            "line",
            f.x, f.y,
            Card.SLOT_WIDTH, Card.SLOT_HEIGHT
        )

        
    end

    for _, f in ipairs(self.foundations) do f:draw() end

    for _, t in ipairs(self.tableau) do t:draw() end

    if self.held then
        local mx, my = love.mouse.getPosition()
        for i, c in ipairs(self.held) do
            c:drawAt(mx, my + (i - 1) * 20)
        end
    end
end

function Game:mousepressed(x, y, button)
    if button ~= 1 then return end

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
        if #self.stock.cards > 0 then
            for i = 1, 3 do
                local c = self.stock:drawTop()
                if not c then break end
                c.faceUp = true
                self.waste:addCard(c)
            end
        else
            while #self.waste.cards > 0 do
                local c = self.waste:drawTop()
                c.faceUp = false
                table.insert(self.stock.cards, 1, c)
            end
            self.stock:updateCardPositions()
        end
        return
    end


    if pickFrom(self.waste) then return end

    for _, t in ipairs(self.tableau) do
        if pickFrom(t) then return end
    end
end

function Game:mousereleased(x, y, button)
    if button ~= 1 or not self.held then return end

    local dropped = false

    -- try drop onto any foundation
    for _, f in ipairs(self.foundations) do
        if f:canAccept(self.held[1]) and f:contains(x,y) then
            f:addCards(self.held)
            dropped = true
            break
        end
    end
    if not dropped then
        for _, t in ipairs(self.tableau) do
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

    if self.originPile.type == "tableau" then
        local cards = self.originPile.cards
        if #cards > 0 then
            local top = cards[#cards]
            if not top.faceUp then
                top.faceUp = true
                self.originPile:updateCardPositions()
            end
        end
    end

    self.held       = nil
    self.originPile = nil
end

function Game:mousemoved(x, y, dx, dy) end

return Game
