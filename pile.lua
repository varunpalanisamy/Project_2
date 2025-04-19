local Card = require("card")
local Pile = {}
Pile.__index = Pile
local WASTE_SPACING = 30   

local function rankValue(r)
    if type(r) == "number" then return r end
    if r == "A" then return 1 end
    if r == "J" then return 11 end
    if r == "Q" then return 12 end
    if r == "K" then return 13 end
    return tonumber(r) or 0
end

local SPACING_FACEUP   = 30
local SPACING_FACEDOWN = 15

function Pile:new(type, x, y)
    local self = setmetatable({
        type  = type,
        x     = x,
        y     = y,
        cards = {},
    }, Pile)
    return self
end

function Pile:addCard(card)
    table.insert(self.cards, card)
    self:updateCardPositions()
end

function Pile:addCards(stack)
    for _, c in ipairs(stack) do
        table.insert(self.cards, c)
    end
    self:updateCardPositions()
end

function Pile:draw()
    if self.type == "waste" then
        local n = #self.cards
        local start = math.max(1, n - 2)
        for i = start, n do
            local c = self.cards[i]
            local offset = (i - start) * WASTE_SPACING
            c:drawAt(self.x + offset, self.y)
        end
        return
    end

    for _, c in ipairs(self.cards) do
        c:draw()
    end
end

function Pile:contains(px, py)
    -- 1) stock pile (face‑down deck)
    if self.type == "stock" then
        return px >= self.x
           and px <= self.x + Card.FACEDOWN_WIDTH
           and py >= self.y
           and py <= self.y + Card.FACEDOWN_HEIGHT
    end

    -- 2) waste pile (only top card clickable)
    if self.type == "waste" and #self.cards > 0 then
        local n     = #self.cards
        local start = math.max(1, n - 2)
        local idx   = n - start
        local top   = self.cards[n]
        local w, h  = top:getWidth(), top:getHeight()
        local x0    = self.x + idx * WASTE_SPACING
        local y0    = self.y
        return px >= x0
           and px <= x0 + w
           and py >= y0
           and py <= y0 + h
    end

    -- 3) any non‑empty pile: hit test its top card
    if #self.cards > 0 then
        local top = self.cards[#self.cards]
        local w, h = top:getWidth(), top:getHeight()
        return px >= top.x
           and px <= top.x + w
           and py >= top.y
           and py <= top.y + h
    end

    -- 4) empty foundation or empty tableau slots
    if (self.type == "foundation" or self.type == "tableau") and #self.cards == 0 then
        return px >= self.x
           and px <= self.x + Card.SLOT_WIDTH
           and py >= self.y
           and py <= self.y + Card.SLOT_HEIGHT
    end

    -- 5) otherwise: no hit
    return false
end



function Pile:drawTop()
    local c = table.remove(self.cards)
    self:updateCardPositions()
    return c
end



function Pile:pickUp(px, py)
    if #self.cards == 0 then return nil end

    if self.type == "waste" then
        if self:contains(px, py) then
            return { self:drawTop() }
        end
        return nil
    end

    if self.type == "tableau" then
        for i = #self.cards, 1, -1 do
            local c = self.cards[i]
            if c.faceUp then
                local w, h = c:getWidth(), c:getHeight()
                if px >= c.x and px <= c.x + w
                and py >= c.y and py <= c.y + h then
                    -- grab stack…
                    local stack = {}
                    for j = i, #self.cards do stack[#stack+1] = self.cards[j] end
                    for j = #self.cards, i, -1 do table.remove(self.cards) end
                    self:updateCardPositions()
                    return stack
                end
            end
        end
    end

    return nil
end



function Pile:updateCardPositions()
    local yOff = 0
    for i, c in ipairs(self.cards) do
        c.x = self.x
        if self.type == "tableau" then
            c.y = self.y + yOff
            yOff = yOff + (c.faceUp and SPACING_FACEUP or SPACING_FACEDOWN)
        else
            c.y = self.y
        end
    end
end


function Pile:canAccept(card)
    if self.type == "tableau" then
        if #self.cards == 0 then
            return rankValue(card.rank) == 13
        end
        local top = self.cards[#self.cards]
        local red    = (card.suit == "hearts" or card.suit == "diamonds")
        local topRed = (top.suit == "hearts" or top.suit == "diamonds")
        local rv, tv = rankValue(card.rank), rankValue(top.rank)
        return (red ~= topRed) and (rv == tv - 1)

    elseif self.type == "foundation" then
        if #self.cards == 0 then
            return rankValue(card.rank) == 1
        end
        local top = self.cards[#self.cards]
        local rv, tv = rankValue(card.rank), rankValue(top.rank)
        return (card.suit == top.suit) and (rv == tv + 1)
    end

    return false
end

return Pile
