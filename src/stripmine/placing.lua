--- TODO find toruch in the turtle inventory
local function placeTorch()
    if turtle.detect() then
        turtle.dig()
    end
    turtle.place()
end

local function placeTorchBehind()
    turtle.turnRight()
    turtle.turnRight()
    placeTorch()
    turtle.turnRight()
    turtle.turnRight()
end






Placing = {
    torchBehind = placeTorchBehind,
}