---@diagnostic disable: lowercase-global
require("getParams")
require("workingMaterials")
require("digging")
require("placing")
require("enums")


local steps = 0
local direction = nil
local rows = 0
sinceLastTorch = 0
light = nil

---@type table<string, number>
local coordinates = {
    x = 0,
    y = 0,
    z = 0
}


function setup()
    User.Say.greeting()
    steps = User.Ask.forSteps()
    rows = User.Ask.forRows()
    direction = User.Ask.forDirection()
    
    Consumables.checkFuel(steps, rows)
    Consumables.checkTorches(steps, rows)
    Consumables.checkChests(steps, rows)
    Dig.changeRow(direction)
end

setup()

