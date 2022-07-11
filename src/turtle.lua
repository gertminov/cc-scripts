turtle = {
    forward = function () print("forward") end,
    back = function () print("back") end,
    up = function () print("up") end,
    down = function () print("down") end,
    turnLeft = function () print("turnLeft") end,
    turnRight = function () print("turnRight")  end ,
    dig = function (side) print("dig") return true, "reason" end,
    getItemDetail = function (slot) print("getItemDetail") return {name = "name", count = 1, damage = 0} end,
}

function read()
    return io.read()
end