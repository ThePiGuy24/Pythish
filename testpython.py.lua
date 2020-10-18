-- transpiled with pythish
local pythish = require("pythishlib/pythish")

-- transpiler demonstration

local time = require("pythishlib/time")

local function hello(name)
    if name == "Dave" then
        print("hello")
    elseif name == "Egg" then
        print("close enough")
    else
        print("you arent dave")
    end
end

print(time.time())
for i in pythish.range(5) do
    print("thonkening")
    time.sleep(0.2)
end

-- comment demo
hello("Dave")
hello("Egg")
hello("Philipe")
