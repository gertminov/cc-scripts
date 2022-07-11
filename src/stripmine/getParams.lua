local function greeting()
    print("Welcome to stripminer 1.0!")
    print("you can stop the program at any point by holding Ctrl + T")
end

---comment
---@return number
local function askForSteps()
    print("How many steps do you want to dig?")
    local steps = tonumber(read())
    if steps == nil then
        print("invalid input")
        askForSteps()
    end
---@diagnostic disable-next-line: return-type-mismatch
    return steps
end


---comment
---@return number
local function askForRows()
    print("How many rows do you want to mine?")
    local rows = tonumber(read())
    if rows == nil then
        print("Invalid input")
        askForRows()
    end
---@diagnostic disable-next-line: return-type-mismatch
    return rows
end

---@return Direction
local function askForDirection()
    print("turn left, or right?, (r, l)")
    local turn = read()
    if turn == "r" or turn == "right" then
        return Direction.RIGHT
    elseif turn == "l" or turn == "left" then
        return Direction.LEFT
    else
        print("invalid input")
        askForDirection()
---@diagnostic disable-next-line: missing-return
    end
end

---@class User
---@field public Ask Ask
User = {
    ---@class Ask
    ---@field public Ask.forSteps function
    ---@field public Ask.forRows function
    ---@field public Ask.forDirection function
    Ask = {
        forSteps = askForSteps,
        forRows = askForRows,
        forDirection = askForDirection
    },
    ---@class Say
    ---@field public Say.greeting function
    Say = {
        greeting = greeting
    }
}