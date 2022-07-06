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
end

setup()


end)
__bundle_register("workingMaterials", function(require, _LOADED, __bundle_register, __bundle_modules)
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
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            details = turtle.getItemDetail(i)
            if details.name == "minecraft:torch"  then
                if details.count >= amtTorches then
                    return true, 0
                else
                    return false, math.ceil(amtTorches - details.count)
                end
            end
        end
    end
    return false, amtTorches
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