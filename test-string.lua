--
-- This tests the debugging of code inside
-- a loadstring() call
--

local dbg = require("debugger")

my_string_proc = [[
function do_string (x, fn)
  print("inside do_string:", x)
  x = 2 * x
  fn()
  return x
end
]]

local function f_this_file ()
  local x = 99
  x = x + 1

  print("Just to test jumping back here", x)
end

p = loadstring(my_string_proc)
pcall(p)

dbg()
do_string(88, f_this_file)


--
-- Stuff below for stuffing screen
--
