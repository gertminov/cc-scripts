viableFuel = {"coal", "lava", "log", "blanks"}



-- function that calculates the amount of torches needed for the given amount of steps and rows
 function calculateTorches(steps, rows)
     return math.ceil(steps/8) * rows
 end



 -- print to user the amount of torches needed for the given amount of steps and rows
function printTorches(steps, rows)
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

function checkForTorches(amtTorches)
    return cehckForItem(amtTorches, "minecraft:torch")
end


 -- function that calculates the amount of chests needed for the given amount of steps and rows
 function calculateChests(steps, rows)
    return math.floor(steps/260 * rows)
end

    -- print to user the amount of chests needed for the given amount of steps and rows
function printChests(steps, rows)
    local amtChests = calculateChests(steps, rows)
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

function checkForChests(amtChests)
    return cehckForItem(amtChests, "minecraft:chest")
end


-- function that calculates the amount of fuel needed for the given amount of steps and rows
function calculateFuel(steps, rows)
    return steps * rows + (rows* 3)
end

    -- print to user the amount of fuel needed for the given amount of steps and rows
function printFuel(steps, rows)
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

function checkForFuel(amtFuel)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            details = turtle.getItemDetail(i)
            for fuel in viableFuel do
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


function cehckForItem(wantedAmt, itemName)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            details = turtle.getItemDetail(i)
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
    
