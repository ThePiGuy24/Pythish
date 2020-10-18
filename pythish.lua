-- (terrible) Python to Lua transpiler, in Lua

local event = require("event")

local args = {...}

if not args[1] then
  print("Transpiles (poorly) Python into Lua\n\nUsage: pythish <python file> [lua file]")
  return
end

local pyfile = args[1]
local luafile = args[2] or pyfile .. ".lua"

local pf = io.open(pyfile, "r")
if not pf then
  print("Cannot open " .. pyfile)
  return
end

local lf = io.open(luafile, "w")
if not lf then
  pf:close()
  print("Cannot open " .. luafile)
  return
end

local function deindent(line)
  local indlen = 0
  local tab = 0
  for c = 1, #line do
    local char = line:sub(c,c)
    if char == " " then
      indlen = indlen + 1
    elseif char == "\t" then
      indlen = indlen + 1
      tab = tab + 1
    else
      break
    end
  end
  return line:sub(indlen+1), indlen + tab
end

print("Transpiling " .. pyfile .. " into " .. luafile)

local lfd = "\n"

local lindent = 0
local indent = ""
local depth = 0
local dontend = false
local builtins = { -- hacky, but mostly works(tm)
  "range",
  "str",
  "int",
  "float",
  "eval",
  "exec"
}
while not event.pull(0, "interrupted") do
  local line = pf:read("*l")
  if not line then
    break
  end
  -- ok now for the real jank shit
  local line, indcount = deindent(line)
  indent = string.rep(" ", indcount)
  line = line:gsub("#", "--")
  line = line:gsub("!=", "~=")
  local lline = ""
  for k, v in ipairs(builtins) do
    line = line:gsub("%s"..v.."%(", " pythish."..v.."(")
  end
  if line:sub(1,7) == "import " then
    for module in line:sub(8):gmatch("[^,]+") do
      module = module:gsub("%s","")
      lline = indent .. "local " .. module .. " = require(\"pythishlib/" .. module .. "\")\n" -- this works 90% of the time 70% of the time
    end
  elseif line:sub(1,4) == "for " or line:sub(1,6) == "while " then
    lline = indent .. line:gsub(":", " do") .. "\n"
    depth = depth + 1
  elseif line:sub(1,3) == "if " then
    lline = indent .. line:gsub(":", " then") .. "\n"
    depth = depth + 1
  elseif line:sub(1,5) == "elif " then
    lline = indent .. "elseif" .. line:sub(5):gsub(":", " then") .. "\n"
    depth = depth + 1
    dontend = true
  elseif line:sub(1,8) == "else if " then
    lline = indent .. "elseif" .. line:sub(8):gsub(":", " then") .. "\n"
    depth = depth + 1
    dontend = true
  elseif line:sub(1,5) == "else:" or line:sub(1,5) == "else " then
    lline = indent .. line:gsub(":", "") .. "\n"
    depth = depth + 1
    dontend = true
  elseif line:sub(1,4) == "def " then
    lline = indent .. "local function" .. line:sub(4):gsub(":", "") .. "\n"
    depth = depth + 1
  else
    lline = indent .. line .. "\n"
  end
  if #indent < lindent then
    tindent = math.floor(lindent/depth)
    while depth > math.floor(#indent/tindent) do
      if not dontend then
        lfd = lfd .. string.rep(" ", tindent*(depth-1)) .. "end\n"
      end
      dontend = false
      depth = depth - 1
    end
  end
  --print(#indent, depth,line)
  lindent = #indent
  lfd = lfd .. lline
end
indent = math.floor(#indent/depth)
while depth > 0 do
  lfd = lfd .. string.rep(" ", indent*(depth-1)) .. "end\n"
  depth = depth - 1
end

lf:write("-- transpiled with pythish\nlocal pythish = require(\"pythishlib/pythish\")\n" .. lfd)

pf:close()
lf:close()
