require("enums")
require("inventory")
require("Item")

---comment
---@param wantedAmt number
---@param itemName string
---@return boolean enough
---@return integer still_needed
---@return integer inventory_slot
local function cehckForItem(wantedAmt, itemName)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local details = turtle.getItemDetail(i)
            if details.name == itemName  then
                if details.count >= wantedAmt then
                    return true, 0, i
                else
                    return false, math.ceil(wantedAmt - details.count), i
                end
            end
        end
    end
    return false, math.ceil(wantedAmt), -1
end


-- function that calculates the amount of torches needed for the given amount of steps and rows
local function calculateTorches(steps, rows)
     return math.ceil(steps/8) * rows
end

---comment
---@param amtTorches any
---@return boolean enough
---@return integer still_needed
---@return integer inventory_slot
local function checkForTorches(amtTorches)
    return cehckForItem(amtTorches, "minecraft:torch")
end

 -- print to user the amount of torches needed for the given amount of steps and rows
 ---comment
 ---@param steps number
 ---@param rows number
local function printTorches(steps, rows)
    local neededAmtTorches = calculateTorches(steps, rows)
    local enoughTorches, missing, slot = checkForTorches(neededAmtTorches)
    -- local torches = Inventory.getItemAtIdx(slot, WorkingMaterials.TORCH)

    if enoughTorches then
        print("You have enough torches")
        return
    else
        neededAmtTorches = missing
    end
    print("You need " .. neededAmtTorches .. " torches.")
    print("Please place them into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForTorches(neededAmtTorches)
        if enough then
            print("You have enough torches")
            return
        else
            print("You need " .. missing .. " more torches")
        end
    end

end



 -- function that calculates the amount of chests needed for the given amount of steps and rows
local function calculateChests(steps, rows)
    return math.floor(steps/260 * rows)
end

local function checkForChests(amtChests)
    return cehckForItem(amtChests, "minecraft:chest")
end

    -- print to user the amount of chests needed for the given amount of steps and rows
    ---comment
    ---@param steps number
    ---@param rows number
local function printChests(steps, rows)
    local amtChests = calculateChests(steps, rows)
    if amtChests == 0 then
        return
    end

    local enoughChests, missing = checkForChests(amtChests)
    if enoughChests then
        print("You have enough chests")
        return
    else
        amtChests = missing
    end
    print("You need " .. amtChests .. " chests.")
    print("Please place them into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForChests(amtChests)
        if enough then
            print("You have enough chests")
            return
        else
            print("You need " .. missing .. " more chests")
        end
    end
end

local function refuel(slot)
    turtle.select(slot)
    turtle.refuel()
    turtle.select(1)
end

---comment
---@param amtFuel number
---@return boolean enoughFuel
---@return integer still_needed
---@return integer inventory_slot
local function checkForFuel(amtFuel)
    if amtFuel <= 0 then
        return true, 0 , -1
    end
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local details = turtle.getItemDetail(i)
            for fuelType, fuelAmt in pairs(WorkingMaterials.FUEL) do
                if string.find(details.name, fuelType) then
                    if details.count*fuelAmt >= amtFuel then
                        return true, 0, i
                    else
                        return false, math.ceil(amtFuel - details.count*fuelAmt)
                    end
                end
            end
           
        end
    end
    return false, amtFuel
end

local function checkFuelLevel(neededFuel)
    local fuellevel = turtle.getFuelLevel()
    neededFuel = neededFuel - fuellevel
    if neededFuel < 0 then
        neededFuel = 0
    end
    return neededFuel
end



---comment
---@param steps number
---@param rows number
---@return number
local function calculateFuel(steps, rows)
    return steps * rows + (rows* 3)
end

    -- print to user the amount of fuel needed for the given amount of steps and rows
    ---comment
    ---@param steps number
    ---@param rows number
local function printFuel(steps, rows)
    local amtFuel = calculateFuel(steps, rows)
    amtFuel = checkFuelLevel(amtFuel)
    local enoughFuel, missing, slot = checkForFuel(amtFuel)
    if enoughFuel then
        print("you have enough fuel")
        if amtFuel > 0 then
            refuel(slot)
        end
        return
    else
        amtFuel = missing
    end
    print("You need " .. amtFuel .. " fuel.")
    print("Please place it into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing, slot = checkForFuel(amtFuel)
        if enough then
            refuel(slot)
            print("You have enough fuel")
            return
        else
            print("You need " .. missing .. " more fuel")
        end
    end
end








---@class Consumables
---@field public printTorches function
---@field public printChests function
---@field public printFuel function
Consumables = {
    checkTorches = printTorches,
    checkChests = printChests,
    checkFuel = printFuel
}
    
