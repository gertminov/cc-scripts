local viableFuel = {
    ["coal"] = 80,
    ["lava"] = 1000, 
    ["log"] = 15, 
    ["blanks"] = 15
}


local function cehckForItem(wantedAmt, itemName)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local details = turtle.getItemDetail(i)
            if details.name == itemName  then
                if details.count >= wantedAmt then
                    return true, 0
                else
                    return false, math.ceil(wantedAmt - details.count)
                end
            end
        end
    end
    return false, wantedAmt
end


-- function that calculates the amount of torches needed for the given amount of steps and rows
local function calculateTorches(steps, rows)
     return math.ceil(steps/8) * rows
end

local function checkForTorches(amtTorches)
    return cehckForItem(amtTorches, "minecraft:torch")
end

 -- print to user the amount of torches needed for the given amount of steps and rows
 ---comment
 ---@param steps number
 ---@param rows number
local function printTorches(steps, rows)
    local amtTorches = calculateTorches(steps, rows)
    local enoughTorches, missing = checkForTorches(amtTorches)
    if enoughTorches then
        return
    else
        amtTorches = missing
    end
    print("You need " .. amtTorches .. " torches.")
    print("Please place them into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForTorches(amtTorches)
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


local function checkForFuel(amtFuel)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local details = turtle.getItemDetail(i)
            for t , fuel in ipairs(viableFuel) do
                if string.find(details.name, fuel) then
                    if details.count >= amtFuel then
                        return true, 0
                    else
                        return false, math.ceil(amtFuel - details.count)
                    end
                end
            end
           
        end
    end
    return false, amtFuel
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
    local enoughFuel, missing = checkForFuel(amtFuel)
    if enoughFuel then
        return
    else
        amtFuel = missing
    end
    print("You need " .. amtFuel .. " fuel.")
    print("Please place it into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForFuel(amtFuel)
        if enough then
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
    
