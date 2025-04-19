local Card = require("card")
local Deck = {}
Deck.__index = Deck

local suits = {"clubs","diamonds","hearts","spades"}
local ranks = {"A",2,3,4,5,6,7,8,9,10,"J","Q","K"}

local rankMap = {
  A = "ace",
  ["J"] = "jack",
  ["Q"] = "queen",
  ["K"] = "king",
}

function Deck:new()
    local self = setmetatable({ cards = {} }, Deck)

    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            local rname = rankMap[rank] or tostring(rank)
            local base  = rname .. "_of_" .. suit
            local path1 = "assets/cards/" .. base .. ".png"
            local path2 = "assets/cards/" .. base .. "2.png"

            local imagePath
            if love.filesystem.getInfo(path1) then
                imagePath = path1
            elseif love.filesystem.getInfo(path2) then
                imagePath = path2
            else
                error("Cannot find card image for: " .. base)
            end

            table.insert(self.cards, Card:new(suit, rank, imagePath))
        end
    end

    return self
end

function Deck:shuffle()
    local c = self.cards
    for i = #c, 2, -1 do
        local j = math.random(i)
        c[i], c[j] = c[j], c[i]
    end
end

function Deck:draw()
    return table.remove(self.cards)
end

return Deck
