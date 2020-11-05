-- approximation of Python os module

local fs = require("filesystem")

local newos = {}

newos.mkdir = fs.makeDirectory
newos.remove = fs.remove
newos.rename = fs.rename

return newos