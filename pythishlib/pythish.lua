-- the pythish lib with stuff

local pythish = {}

function pythish.range(stop, start, inc)
  if start then
    local temp = stop
    stop = start
    start = temp
  end
  start = start or 0
  inc = inc or 1
  local ifunc = load("v = v + " .. inc .. "; if v < " .. stop .. " then return v end return nil", "range", "t", {v = start - inc})
  return ifunc
end

pythish.str = tostring
pythish.float = tonumber

function pythish.int(num)
  return math.floor(tonumber(num))
end

return pythish