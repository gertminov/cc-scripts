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
require("enums")
require("inventory")
require("navigator")
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

local function digging(rows, steps, direction)

    for row = 1, rows do
        Dig.column(steps)
        Dig.changeRow(direction)
    end
end

function ReturnHome()
    print("Returning home")
end

function setup()
    User.Say.greeting()
    steps = User.Ask.forSteps()
    rows = User.Ask.forRows()
    direction = User.Ask.forDirection()

    Consumables.checkFuel(steps, rows)
    Consumables.checkTorches(steps, rows)
    Consumables.checkChests(steps, rows)
    print(textutils.serialize(Inventory.items))
    -- print(textutils.serialize(Inventory.items))

    
    digging(rows, steps, direction)
    
end



setup()




end)
__bundle_register("navigator", function(require, _LOADED, __bundle_register, __bundle_modules)

end)
__bundle_register("inventory", function(require, _LOADED, __bundle_register, __bundle_modules)
local tryAgain = false

local function indexInventory()
    for i=1, 16 do
        local item = turtle.getItemDetail(i)
        if item ~= nil then
            local inventoryItem = Item:new{
                idx = i,
                amt = item.count,
                name = item.name
            }
            Inventory.items[inventoryItem.name] = inventoryItem
        end
    end
end



-- local function updateInventory(item, idx)
--     if item == nil then
--         Inventory.items[idx] = nil
--         return { -1, -1, "no_item"}
--     end
--     local inventoryItem = Item:new{
--         idx = idx,
--         amt = item.count,
--         name = item.name
--     }
--     Inventory.items[idx] = inventoryItem
--     return inventoryItem
    
-- end


---comment
---@param idx number
---@return  Item |nil item
local function  getTurtleItemAtIdx(idx)
    
    local item = turtle.getItemDetail(idx)
    if item  == nil then
        if tryAgain then
            return nil
        end
        indexInventory()
        tryAgain = true
        return getTurtleItemAtIdx(idx)
    end
    return Item:new{
        idx = idx,
        amt = item.count,
        name = item.name
    }
end


local function getItemByName(name)
    local item  = Inventory.items[name]
    if item == nil or item.name ~=name then
        if tryAgain then
            return nil
        end
        indexInventory()
        tryAgain = true
        return getItemByName(name)
    end
    tryAgain = false
    return item
end

---comment
---@return Item| nil item 
local function findFillBlock()
    for i=1, 16 do
        local item = turtle.getItemDetail(i)
        if item ~= nil then
            
            for j, name in pairs(WorkingMaterials.FILLBLOCK) do
                if string.find(item.name, name) then
                    return Item:new{
                        idx = i,
                        amt = item.count,
                        name = item.name
                    }
                end
                
            end
        end
    end
    return nil
end



Inventory = {
    index = indexInventory,
    getItemAtIdx = getTurtleItemAtIdx,
    getItemByName = getItemByName,
    findFillBlock = findFillBlock,
    ---@table<string,Item>
    items = {}

}
end)
__bundle_register("enums", function(require, _LOADED, __bundle_register, __bundle_modules)
---@alias Direction "r"|"l"

---@type Direction
Direction = {
    RIGHT = "r",
    LEFT = "l"
}

WorkingMaterials = {
    TORCH = "minecraft:torch",
    CHEST = "minecraft:chest",
    ---@type table<string, number>
    FUEL = {
        ["coal"] = 80,
        ["lava"] = 1000, 
        ["log"] = 15, 
        ["blanks"] = 15
    },
    FILLBLOCK ={
        "block",
        "dirt",
        "stone",
    }
}


end)
__bundle_register("placing", function(require, _LOADED, __bundle_register, __bundle_modules)
--- TODO find toruch in the turtle inventory
local function placeTorch()
    if turtle.detect() then
        turtle.dig()
    end
    local item = Inventory.getItemByName(WorkingMaterials.TORCH)
    if item == nil or  item.amt <0 then
        ReturnHome()
    end
    turtle.select(item.idx)
    turtle.place()
end

local function placeTorchBehind()
    turtle.turnRight()
    turtle.turnRight()
    placeTorch()
    turtle.turnRight()
    turtle.turnRight()
end


local function placeFiller(idx)
    turtle.select(idx)
    turtle.placeDown()
    turtle.select(1)
end








Placing = {
    torchBehind = placeTorchBehind,
    filler = placeFiller,
}
end)
__bundle_register("digging", function(require, _LOADED, __bundle_register, __bundle_modules)
require("placing")

local updateCords = nil


local function digForwardAndUP()
    turtle.dig()
    turtle.digUp()
end



-- function that moves the turtle forward for "steps" blocks
local function digForward(steps)
    if steps == 0 then
        return
    end
    local place = function (idx )end
    local fillIdx = 16
    local fillBlock = Inventory.findFillBlock()
    if fillBlock ~= nil then
        place = Placing.filler
        fillIdx = fillBlock.idx
        turtle.select(fillIdx)
    end

    for i = 0, steps do
        digForwardAndUP()
        turtle.forward()
        if not turtle.detectDown() then
            place(fillIdx)
        end
        if i%8 == 1 then
            Placing.torchBehind()
            turtle.select(fillIdx)
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

---@param direction Direction
local function changeRow(direction)
    local reverseDirection = nil
    if direction == Direction.RIGHT then
        turtle.turnRight()
        reverseDirection = turtle.turnLeft
    else
        turtle.turnLeft()
        reverseDirection = turtle.turnRight
    end
    digForwardAndUP()
    turtle.forward()
    digForwardAndUP()
    turtle.forward()
    digForwardAndUP()
    turtle.forward()
    reverseDirection()
end

local function initDigger(updateCords)

end

Dig = {
    forward = digForward,
    backward = backward,
    column = digColumn,
    changeRow = changeRow

}
end)
__bundle_register("workingMaterials", function(require, _LOADED, __bundle_register, __bundle_modules)
require("enums")
require("inventory")
require("Item")

---comment
---@param wantedAmt number
---@param itemName string
---@return boolean enough
---@return integer still_needed
---@return integer inventory_slot
local function cehckForItem(wantedAmt, itemName)
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local details = turtle.getItemDetail(i)
            if details.name == itemName  then
                if details.count >= wantedAmt then
                    return true, 0, i
                else
                    return false, math.ceil(wantedAmt - details.count), i
                end
            end
        end
    end
    return false, math.ceil(wantedAmt), -1
end


-- function that calculates the amount of torches needed for the given amount of steps and rows
local function calculateTorches(steps, rows)
     return math.ceil(steps/8) * rows
end

---comment
---@param amtTorches any
---@return boolean enough
---@return integer still_needed
---@return integer inventory_slot
local function checkForTorches(amtTorches)
    return cehckForItem(amtTorches, "minecraft:torch")
end

 -- print to user the amount of torches needed for the given amount of steps and rows
 ---comment
 ---@param steps number
 ---@param rows number
local function printTorches(steps, rows)
    local neededAmtTorches = calculateTorches(steps, rows)
    local enoughTorches, missing, slot = checkForTorches(neededAmtTorches)
    -- local torches = Inventory.getItemAtIdx(slot, WorkingMaterials.TORCH)

    if enoughTorches then
        print("You have enough torches")
        return
    else
        neededAmtTorches = missing
    end
    print("You need " .. neededAmtTorches .. " torches.")
    print("Please place them into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing = checkForTorches(neededAmtTorches)
        if enough then
            print("You have enough torches")
            return
        else
            print("You need " .. missing .. " more torches")
        end
    end

end



 -- function that calculates the amount of chests needed for the given amount of steps and rows
local function calculateChests(steps, rows)
    return math.floor(steps/260 * rows)
end

local function checkForChests(amtChests)
    return cehckForItem(amtChests, "minecraft:chest")
end

    -- print to user the amount of chests needed for the given amount of steps and rows
    ---comment
    ---@param steps number
    ---@param rows number
local function printChests(steps, rows)
    local amtChests = calculateChests(steps, rows)
    if amtChests == 0 then
        return
    end

    local enoughChests, missing = checkForChests(amtChests)
    if enoughChests then
        print("You have enough chests")
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

local function refuel(slot)
    turtle.select(slot)
    turtle.refuel()
    turtle.select(1)
end

---comment
---@param amtFuel number
---@return boolean enoughFuel
---@return integer still_needed
---@return integer inventory_slot
local function checkForFuel(amtFuel)
    if amtFuel <= 0 then
        return true, 0 , -1
    end
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local details = turtle.getItemDetail(i)
            for fuelType, fuelAmt in pairs(WorkingMaterials.FUEL) do
                if string.find(details.name, fuelType) then
                    if details.count*fuelAmt >= amtFuel then
                        return true, 0, i
                    else
                        return false, math.ceil(amtFuel - details.count*fuelAmt)
                    end
                end
            end
           
        end
    end
    return false, amtFuel
end

local function checkFuelLevel(neededFuel)
    local fuellevel = turtle.getFuelLevel()
    neededFuel = neededFuel - fuellevel
    if neededFuel < 0 then
        neededFuel = 0
    end
    return neededFuel
end



---comment
---@param steps number
---@param rows number
---@return number
local function calculateFuel(steps, rows)
    return steps * rows + (rows* 3)
end

    -- print to user the amount of fuel needed for the given amount of steps and rows
    ---comment
    ---@param steps number
    ---@param rows number
local function printFuel(steps, rows)
    local amtFuel = calculateFuel(steps, rows)
    amtFuel = checkFuelLevel(amtFuel)
    local enoughFuel, missing, slot = checkForFuel(amtFuel)
    if enoughFuel then
        print("you have enough fuel")
        if amtFuel > 0 then
            refuel(slot)
        end
        return
    else
        amtFuel = missing
    end
    print("You need " .. amtFuel .. " fuel.")
    print("Please place it into the turtles inventory")
    while true do
        os.pullEvent("turtle_inventory")
        local enough, missing, slot = checkForFuel(amtFuel)
        if enough then
            refuel(slot)
            print("You have enough fuel")
            return
        else
            print("You need " .. missing .. " more fuel")
        end
    end
end








---@class Consumables
---@field public printTorches function
---@field public printChests function
---@field public printFuel function
Consumables = {
    checkTorches = printTorches,
    checkChests = printChests,
    checkFuel = printFuel
}
    

end)
__bundle_register("Item", function(require, _LOADED, __bundle_register, __bundle_modules)
---@class Item
---@field public index number
---@field public amount number
---@field public name string
Item = {
    idx = -1,
    amt = -1,
    name = "",
}

function Item:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Item:add()
    self.amt = self.amt + 1
end

function Item:remove()
    self.amt = self.amt - 1
end


end)
__bundle_register("getParams", function(require, _LOADED, __bundle_register, __bundle_modules)
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
end)
return __bundle_require("__root")