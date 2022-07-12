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