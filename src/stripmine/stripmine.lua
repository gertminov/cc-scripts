---@diagnostic disable: lowercase-global
require("getParams")
require("workingMaterials")
require("digging")
require("placing")
require("enums")
--- require("turtle")


local steps = 0
local direction = nil
local rows = 0
local sinceLastTorch = 0
local light = nil

---@type table<string, number>
local coordinates = {
    x = 0,
    y = 0,
    z = 0
}

local function digging()

    for row = 1, rows do
        Dig.column(steps)
        Dig.changeRow(direction)
    end
end

function setup()
    User.Say.greeting()
    steps = User.Ask.forSteps()
    rows = User.Ask.forRows()
    direction = User.Ask.forDirection()

    Consumables.checkFuel(steps, rows)
    Consumables.checkTorches(steps, rows)
    Consumables.checkChests(steps, rows)

    print(textutils.serialize(Inventory[WorkingMaterials.TORCH]))
    digging()
    
end



setup()



