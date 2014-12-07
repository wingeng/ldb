--
-- Another test file to test the tracking of the debugger
--

local function other_local_foo (x, y)
   print("in other_local_foo:")
end

function other_test (x, y)
   print("Other called:")

   print("x:", x, "y:", y)
   

   other_local_foo(x, y)
end
