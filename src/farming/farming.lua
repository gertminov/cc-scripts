
slot = 2

local function checkForItem(wantedAmt)
    local items = 0
    for i=1, 16 do
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

    for i=0, 2 do
        fuel = fuel+ turtle.getItemCount(i)
    end

    if items >= wantedAmt then
        return true
        else
            return false
    end

    return false, wantedAmt

end


local function checkcurrentslot()

    if turtle.getItemCount(i) == 0 then
        slot=slot + 1
        turtle.select(slot)
        else
            return
    end
end


local function plant(steps)
    for i=0, steps do
        
        checkcurrentslot()
        turtle.placedown()
        turtle.foreward()
    end
end

local function start_pos()
    for i=0, 2 do
        turtle.foreward()
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

    for field=0, 3 do
        for row=0, 7 do
            plant(7)
            if row % 2 then
                turtle.turnRight()
                turtle.foreward()
                turtle.turnRight()
                else
                    turtle.turnLeft()
                    turtle.foreward()
                    turtle.turnLeft()
            end

        end 
        turtle.turnRight()
        turtle.foreward()
        turtle.turnRight()
        plant(7)   


    end

end


detected = 0
empty = 0

while true do

    if redstone.getinput() then
        detected = 1

    
        elseif detected == 1 and redstone.getinput() == 0 then
            detected = 0
            empty = 0
            empty = checkForItem(100)
            empty = checkForFuel(10)

            start_pos()
            replant()
            --if not empty then
            --  replant()
            --end
        
        else
            print("farming")
            sleep(10)
    end

end