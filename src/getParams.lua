function greeting()
    print("Welcome to stripminer 1.0!")
end

function askForSteps()
    print("How many steps do you want to dig?")
    steps = tonumber(read())
    if steps == nil then
        print("invalid input")
        askForSteps()
    end
    return steps
end

function askForRows()
    print("How many rows do you want to mine?")
    rows = tonumber(read())
    if rows == nil then
        print("Invalid input")
        askForRows()
    end
    return rows
end

function askForDirection()
    print("turn left, or right?, (r, l)")
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