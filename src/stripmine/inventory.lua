local function updateInventory(item, idx)
    if item == nil then
        Inventory.items[idx] = nil
        return { -1, -1, "no_item"}
    end
    local inventoryItem = Item:new{
        idx = idx,
        amt = item.count,
        name = item.name
    }
    Inventory.items[idx] = inventoryItem
    return inventoryItem
    
end

---comment
---@param idx number
---@param name? string
---@return  {count: number, name :string} item
local function  getTurtleItemAtIdx(idx, name)
    
    local item = turtle.getItemDetail(idx)
    if name == nil then
        return updateInventory(item, idx)
    elseif item.name == name then
            return updateInventory(item, idx)
    end
    return updateInventory(nil, idx)
end


local function getItemByName(name)
    for i=1, 16 do
        local item = getTurtleItemAtIdx(i)
        if item.name == name then
            return item
        end
    end
    return updateInventory(nil, -1)
end




Inventory = {
    getItemAtIdx = getTurtleItemAtIdx,
    getItemByName = getItemByName,
    ---@table<integer,Item>
    items = {}

}