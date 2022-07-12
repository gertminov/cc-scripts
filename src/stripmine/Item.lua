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

