require("placing")


local function digForwardAndUP()
    turtle.dig()
    turtle.digUp()
end

function digForward(steps)
    if steps == 0 then
        return
    end

    for i = 0, steps do
        digForwardAndUP()
        turtle.forward()
        if not turtle.detectDown() then
            turtle.placeDown()
        end
        if i%8 == 1 then
            placeTorchBehind()
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

function digColumn(steps)
    digForward(steps)
    backward(steps)
end