-- approximation of Python random module

local random = {}

function random.random()
  return math.random()
end

function random.randint(l,h)
  return math.random(l,h)
end

return random