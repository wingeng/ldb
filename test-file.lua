--[[

Test file for debugger. Just run in the lua interp

Example:

  lua ./test-file.lua

-- ]]


--
-- load in the debugger file
--
dbg = require("debugger")

--
-- load in other test file
--
other = require("second-test-file")

--
-- Test functions
--
local function foo (x)
   -- This is essentially a break point
   dbg()
   print("inside foo")
   x = x * 8
   print("ex times 8 is : ", x)
   return x
end

local function bar (y)
   print("inside bar")

   local x = foo(y)

   y = y * 7
   print("why time 7 is :", y)

   other_test(x, y)

   return y
end


bar(3)
