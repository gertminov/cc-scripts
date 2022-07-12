
slot = 2

local function checkForItem(wantedAmt)
    local items = 0
    for i=3, 15 do
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

    if fuel >= wantedAmt then
        return true
        else
            return false
    end

    return false, wantedAmt

end


local function checkcurrentslot()

    if turtle.getItemCount(i) == 0 then
        slot=slot + 1
        if slot==17 then
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
        turtle.placeDown()
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
            plant(5)
            if row % 2 == 0 then
                turtle.turnRight()
                turtle.forward()
                
                turtle.turnRight()
                turtle.forward()
                else
                    turtle.turnLeft()
                    turtle.forward()
                    turtle.turnLeft()
            end

        end 
        turtle.turnRight()
        turtle.foreward()
        turtle.turnRight()
        plant(7)   


    end

end


local detected = 0
local empty = 0

while true do

    if rs.getInput("bottom") and detected==0 then
        detected = 1
        print("detected")

    end
        if detected==1 and not rs.getInput("bottom") then
            detected = 0
            print("planting")
            empty = 0
            empty = checkForItem(100)
            empty = checkForFuel(10)

            start_pos()
            replant()
            --if not empty then
            --  replant()
            --end
      end      
        
            print("wating")
            sleep(2)

end
