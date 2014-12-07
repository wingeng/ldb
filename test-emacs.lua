--[[

Test file for debugger. Just run in the lua interp

This example tells debugger.lua that it's running in emacs
so that output lines are not needed.

Example:

  lua ./test-emacs.lua

-- ]]

dbg = require("debugger")

dbg.inside_emacs = true


dbg()

print("inside test-emacs")

x = 99

print(x)
