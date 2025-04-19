local Card = {}
Card.__index = Card

local SCALE_FACEUP   = 0.2
local SCALE_FACEDOWN = 0.56

local facedownImage = love.graphics.newImage("assets/cards/facedown.png")

Card.FACEDOWN_WIDTH  = facedownImage:getWidth()  * SCALE_FACEDOWN
Card.FACEDOWN_HEIGHT = facedownImage:getHeight() * SCALE_FACEDOWN

Card.SLOT_WIDTH  = facedownImage:getWidth()  * SCALE_FACEUP
Card.SLOT_HEIGHT = facedownImage:getHeight() * SCALE_FACEUP

Card.WIDTH  = facedownImage:getWidth()  * SCALE_FACEUP
Card.HEIGHT = facedownImage:getHeight() * SCALE_FACEUP

function Card:getWidth()
  return (self.faceUp and SCALE_FACEUP or SCALE_FACEDOWN)
      * self.image:getWidth()
end
function Card:getHeight()
  return (self.faceUp and SCALE_FACEUP or SCALE_FACEDOWN)
      * self.image:getHeight()
end

function Card:new(suit, rank, imagePath)
    local img = love.graphics.newImage(imagePath)
    local obj = setmetatable({
        suit   = suit,
        rank   = rank,
        faceUp = false,
        image  = img,
        x      = 0,
        y      = 0,
    }, Card)
    return obj
end

function Card:draw()
    if self.faceUp then
        love.graphics.draw(self.image, self.x, self.y, 0, SCALE_FACEUP, SCALE_FACEUP)
    else
        love.graphics.draw(facedownImage, self.x, self.y, 0, SCALE_FACEDOWN, SCALE_FACEDOWN)
    end
end

function Card:drawAt(x, y)
    if self.faceUp then
        love.graphics.draw(self.image, x, y, 0, SCALE_FACEUP, SCALE_FACEUP)
    else
        love.graphics.draw(facedownImage, x, y, 0, SCALE_FACEDOWN, SCALE_FACEDOWN)
    end
end

return Card
