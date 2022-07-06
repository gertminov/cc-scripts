---@diagnostic disable: lowercase-global
require("getParams")
require("workingMaterials")
require("digging")
require("placing")


steps = 0
direction = nil
rows = 0
sinceLastTorch = 0
light = nil

coordinates = {}
coordinates["x"] = 0
coordinates["y"] = 0

function setup()
    greeting()
    steps = askForSteps()
    rows = askForRows()
    direction = askForDirection()
    printTorches(steps, rows)
    printChests(steps, rows)
    printFuel(steps, rows)
end

setup()

