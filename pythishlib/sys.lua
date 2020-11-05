-- approximation of Python sys module

local sys = {}

sys.argv = {}
sys.exit = os.exit

return sys