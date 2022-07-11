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
    }
}

