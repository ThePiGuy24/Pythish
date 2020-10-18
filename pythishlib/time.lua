-- approximation of Python time module

local computer = require("computer")

local time = {}

time.time = computer.uptime
time.sleep = os.sleep

function time.time_ns()
  return computer.uptime() * 1000000000 -- shit but it will do
end

function time.timezone()
  return 0
end

return time