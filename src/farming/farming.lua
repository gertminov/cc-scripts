
slot = 2

local function checkForItem(wantedAmt)
    local items = 0
    for i=3, 16 do
        items = items+ turtle.getItemCount(i)
    end
    if items >= wantedAmt then
        return true
        else
            return false
    end

    return false, wantedAmt
    
end

local function checkForFuel(wantedAmt)

    local fuel = 0;

    for i=1, 2 do
        fuel = fuel+ turtle.getItemCount(i)
    end

    if items >= wantedAmt then
        return true
        else
            return false
    end

    return false, wantedAmt

end

local function refuel(amount)
    i=0
    turtle.select(1)
    while turtle.getItemCount(1) > 0 and i<amount do
        turtle.refuel()
        i = i + 1
    end
    turtle.select(2)
    while turtle.getItemCount(2) > 0 and i<amount do
        turtle.refuel()
        i = i + 1
    end
        
end



local function checkcurrentslot()

    if turtle.getItemCount(i) == 0 then
        slot=slot + 1
        if slot > 16 then
            slot = 3
        end

        turtle.select(slot)
        else
            return
    end
end


local function plant(steps)
    for i=0, steps do
        
        checkcurrentslot()
        turtle.placedown()
        turtle.forward()
    end
end

local function start_pos()
    for i=0, 2 do
        turtle.forward()
    end
    turtle.up()
end


local function return_pos()
    for i=0, 3 do
        turtle.up()
    end
    
    for i=0, 20 do
        turtle.back()
    end

    turtle.turnRight()

    for i=0, 8 do
        turtle.back()
    end
    turtle.turnLeft()
    turtle.down()
    turtle.back()
end

local function replant()

    for field=0, 1 do
        for row=0, 6 do
            plant(7)
            if row % 2 then
                turtle.turnRight()
                turtle.forward()
                checkcurrentslot()
                turtle.placedown()

                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.forward()
                checkcurrentslot()
                turtle.placedown()

                turtle.turnLeft()
            end

        end 
        --turtle.turnRight()
        --turtle.foreward()
        --checkcurrentslot()
        --turtle.placedown()

        --turtle.turnRight()
        --plant(7)   


    end

end


detected = 0
empty = 0

while true do

    if rs.getInput("Bottom") then
        detected = 1
        print("watering")
    end

    if detected == 1 and not rs.getInput("Bottom") then
            
            detected = 0
            empty = 0
            empty = checkForItem(140)
            empty = checkForFuel(3)

            if not empty then
              print("planting")
              refuel(3)
              replant()
            end
        
        else
            print("waiting")
            sleep(2)
    end

end