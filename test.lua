steps = 0
direction = nil
rows = 0
sinceLastTorch = 0
light = nil

function setup()
    print("starting Program")
    print("how far?")
    steps = tonumber(read())
    askForDirection()
    rows = askForRows()
end

-- ask user whather to turn left or right
function askForDirection()
    print("turn left or right? (r,l)")
    local turn = read()
    if turn == "r" or turn == "right" then
        direction = "r"
    elseif turn == "l" or turn == "left" then
        direction = "l"
    else
        print("invalid input")
        askForDirection()
    end
end

-- aks user how many rows should be dug
function askForRows()
    print("how many rows?")
    local rows = tonumber(read())
    if rows == nil then
        print("invalid input")
        askForRows()
    end
    return rows
end


-- function that moves the turtle forward for steps steps
function digForward(steps)
    if steps == 0 then
        return
    end

    for i = 0, steps do
        dig()
        turtle.forward()
        if not turtle.detectDown() then
            turtle.placeDown()
        end
        if i%8 == 1 then
            turtle.turnRight()
            turtle.turnRight()
            placeTorch()
            turtle.turnRight()
            turtle.turnRight()
        end
    end
    turtle.digUp()
end

function fd(steps)
    if steps == 0 then
        return
    end

    for i = 0, steps do
        dig()
        turtle.forward()
        if not turtle.detectDown() then
            turtle.placeDown()
        end
    end
    turtle.digUp()
end

-- function that moves the turtle backward for steps steps
function backward(steps)
    if steps == 0 then
        return
    end
    turtle.up()

    for i = 0, steps do
        turtle.back()
    end
    turtle.down()
end

-- function that digs up forward
function dig()
    turtle.dig()
    turtle.digUp()
end

-- function that checks fuel level
function checkFuel()
    if turtle.getFuelLevel() < 10 then
        print("Fuel level too low")
        return false
    end
    return true
end

-- function that gets itemDetail from every item in inventory
function findItems()
    local fuel = {}
    light = {}
    chest = {}
    for i = 1, 16 do
        
        local item = turtle.getItemDetail(i)
        if item then
            item["slot"] = i
            -- if item.name contains "coal" or "lavar" then add it to the table
            if string.find(item.name, "coal") or string.find(item.name, "lava") then
                fuel[i] = item
            end

            -- if item name contains "torch" then add to light table
            if string.find(item.name, "torch") then
                light[i] = item
            end

            -- if item name contains "chest" then add to chest table
            if string.find(item.name, "chest") then
                chest[i] = item
            end
        end
    end
    return fuel, light, chest
end

-- function that refuels the turtle with coal or lava
function refuel(itemDetail)
    for i, item in pairs(itemDetail) do
        -- print current fuellevel and item name. remove "minecraft:" from item name
        print("fuel lvl: ",turtle.getFuelLevel())
        print("using: ",  item.name:sub(11), "to refuel")
        turtle.select(item.slot)
        turtle.refuel()
        -- if fuellevel is 90% of fuellimit stop refueling
        if turtle.getFuelLevel() > turtle.getFuelLimit() * 0.9 then
            return
        end

        -- if fuellevel is less than 10% of fuellimit ask user to add fuel to turtle
        if turtle.getFuelLevel() < turtle.getFuelLimit() * 0.1 then
            print("Fuel level too low")
            print("add fuel to turtles inventory")
        end


    end
end

function placeTorch()
    for i, itme in pairs(light) do
        count = turtle.getItemCount(itme.slot)
        detail = turtle.getItemDetail(itme.slot)
        if detail.name == "minecraft:torch" and count > 0 then
            turtle.select(itme.slot)
            turtle.place()
            return
        end
    end
    print("no torches in inventory")
    os.exit()

end

function digging()
    for i = 1, rows do
        digForward(steps)
        backward(steps)
        if direction == "r" then
            turtle.turnRight()
            fd(2)
            turtle.turnLeft()
        else
            turtle.turnLeft()
            fd(2)
            turtle.turnRight()
        end
    end
    if direction == "r" then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end
    fd(rows*3 -1)
end

function getLightCount()
    local count = 0
    for i, item in pairs(light) do
        count = count + turtle.getItemCount(item.slot)
    end
    return count
end

function getChestCount()
    local count = 0
    for i, item in pairs(chest) do
        count = count + turtle.getItemCount(item.slot)
    end
    return count
end

function enoughtLight()
    needetLights = steps * rows /8
    
    if getLightCount() < steps*rows / 10 then
        return false, needetLights
    end
    return true, needetLights
end




function main()
    setup()
    fuel, light, chest = findItems()
    lightCount = getLightCount()
    chestCount = getChestCount()

    print("lights: ", lightCount)
    enoughtLight, needet = enoughtLight()
    if not enoughtLight then
        print("not enought light")
        print("expected to need: ", needet)
        return
    end
    
    print("chests: ", chestCount)
    refuel(fuel)
    digging()
end

main()