--- TODO find toruch in the turtle inventory
local function placeTorch()
    if turtle.detect() then
        turtle.dig()
    end
    local item = Inventory.getItemByName(WorkingMaterials.TORCH)
    if item == nil or  item.amt <0 then
        ReturnHome()
    end
    turtle.select(item.idx)
    turtle.place()
end

local function placeTorchBehind()
    turtle.turnRight()
    turtle.turnRight()
    placeTorch()
    turtle.turnRight()
    turtle.turnRight()
end


local function placeFiller(idx)
    turtle.select(idx)
    turtle.placeDown()
    turtle.select(1)
end








Placing = {
    torchBehind = placeTorchBehind,
    filler = placeFiller,
}