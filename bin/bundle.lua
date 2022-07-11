-- Bundled by luabundle {"version":"1.6.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
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


end)
__bundle_register("placing", function(require, _LOADED, __bundle_register, __bundle_modules)
function placeTorchBehind()
    turtle.turnRight()
    turtle.turnRight()
    placeTorch()
    turtle.turnRight()
    turtle.turnRight()
end
end)
__bundle_register("digging", function(require, _LOADED, __bundle_register, __bundle_modules)
require("placing")


local function digForwardAndUP()
    turtle.dig()
    turtle.digUp()
end



-- function that moves the turtle forward for "steps" blocks
local function digForward(steps)
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

-- function that moves the turtle backward for "steps" blocks
local function backward(steps)
    if steps == 0 then
        return
    end
    turtle.up()

    for i = 0, steps do
        turtle.back()
    end
    turtle.down()
end

-- digs a column of "steps" blocks and 2 blocks height and returns the tutrtle to the starting point
local function digColumn(steps)
    digForward(steps)
    backward(steps)
end

Dig = {
    forward = digForward,
    backward = backward,
    column = digColumn

}
end)
__bundle_register("workingMaterials", function(require, _LOADED, __bundle_register, __bundle_modules)
viableFuel = {"coal", "lava", "log", "blanks"}



-- function that calculates the amount of torches needed for the given amount of steps and rows
 function calculateTorches(steps, rows)
     return math.ceil(steps/8) * rows
 end



 -- print to user the amount of torches needed for the given amount of steps and rows
function printTorches(steps, rows)
    local amtTorches = calculateTorches(steps, rows)
    local enoughTorches, missing = checkForTorches(amtTorches)
    if enoughTorches then
        return
    else
        amtTorches = missing
    end
    print("You need " .. amtTorches .. " torches.")
    print("Please place them into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForTorches(amtTorches)
        if enough then
            print("You have enough torches")
            return
        else
            print("You need " .. missing .. " more torches")
        end
    end

end

function checkForTorches(amtTorches)
    return cehckForItem(amtTorches, "minecraft:torch")
end


 -- function that calculates the amount of chests needed for the given amount of steps and rows
 function calculateChests(steps, rows)
    return math.floor(steps/260 * rows)
end

    -- print to user the amount of chests needed for the given amount of steps and rows
function printChests(steps, rows)
    local amtChests = calculateChests(steps, rows)
    local enoughChests, missing = checkForChests(amtChests)
    if enoughChests then
        return
    else
        amtChests = missing
    end
    print("You need " .. amtChests .. " chests.")
    print("Please place them into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForChests(amtChests)
        if enough then
            print("You have enough chests")
            return
        else
            print("You need " .. missing .. " more chests")
        end
    end
end

function checkForChests(amtChests)
    return cehckForItem(amtChests, "minecraft:chest")
end


-- function that calculates the amount of fuel needed for the given amount of steps and rows
function calculateFuel(steps, rows)
    return steps * rows + (rows* 3)
end

    -- print to user the amount of fuel needed for the given amount of steps and rows
function printFuel(steps, rows)
    local amtFuel = calculateFuel(steps, rows)
    local enoughFuel, missing = checkForFuel(amtFuel)
    if enoughFuel then
        return
    else
        amtFuel = missing
    end
    print("You need " .. amtFuel .. " fuel.")
    print("Please place it into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForFuel(amtFuel)
        if enough then
            print("You have enough fuel")
            return
        else
            print("You need " .. missing .. " more fuel")
        end
    end
end

function checkForFuel(amtFuel)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            details = turtle.getItemDetail(i)
            for fuel in viableFuel do
                if string.find(details.name, fuel) then
                    if details.count >= amtFuel then
                        return true, 0
                    else
                        return false, math.ceil(amtFuel - details.count)
                    end
                end
            end
           
        end
    end
    return false, amtFuel
end


function cehckForItem(wantedAmt, itemName)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            details = turtle.getItemDetail(i)
            if details.name == itemName  then
                if details.count >= wantedAmt then
                    return true, 0
                else
                    return false, math.ceil(wantedAmt - details.count)
                end
            end
        end
    end
    return false, wantedAmt
end
    

end)
__bundle_register("getParams", function(require, _LOADED, __bundle_register, __bundle_modules)
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
end)
return __bundle_require("__root")