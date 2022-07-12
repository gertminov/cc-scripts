require("placing")

local updateCords = nil


local function digForwardAndUP()
    turtle.dig()
    turtle.digUp()
end



-- function that moves the turtle forward for "steps" blocks
local function digForward(steps)
    if steps == 0 then
        return
    end
    local place = function (idx )end
    local fillIdx = 16
    local fillBlock = Inventory.findFillBlock()
    if fillBlock ~= nil then
        place = Placing.filler
        fillIdx = fillBlock.idx
        turtle.select(fillIdx)
    end

    for i = 0, steps do
        digForwardAndUP()
        turtle.forward()
        if not turtle.detectDown() then
            place(fillIdx)
        end
        if i%8 == 1 then
            Placing.torchBehind()
            turtle.select(fillIdx)
        end
    end
    turtle.digUp()
end

-- function that moves the turtle backward for "steps" blocks
local function backward(steps)
    if steps == 0 then
        return
    end
    turtle.up()

    for i = 0, steps do
        turtle.back()
    end
    turtle.down()
end

-- digs a column of "steps" blocks and 2 blocks height and returns the tutrtle to the starting point
local function digColumn(steps)
    digForward(steps)
    backward(steps)
end

---@param direction Direction
local function changeRow(direction)
    local reverseDirection = nil
    if direction == Direction.RIGHT then
        turtle.turnRight()
        reverseDirection = turtle.turnLeft
    else
        turtle.turnLeft()
        reverseDirection = turtle.turnRight
    end
    digForwardAndUP()
    turtle.forward()
    digForwardAndUP()
    turtle.forward()
    digForwardAndUP()
    turtle.forward()
    reverseDirection()
end

local function initDigger(updateCords)

end

Dig = {
    forward = digForward,
    backward = backward,
    column = digColumn,
    changeRow = changeRow

}