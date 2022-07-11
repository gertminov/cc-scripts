---comment
---@param idx number
---@param name? string
---@return  {count: number, name :string} item
local function  getItemAtIdx(idx, name)
    
    local item = turtle.getItemDetail(idx)
    if name == nil then
        return item
    elseif item.name == name then
            return item
    end
    return {-1, "item not found"}
end



Inventory = {
    getItemAtIdx = getItemAtIdx,
    ---@table<string,Item>
    items = {}

}