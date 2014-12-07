ldb
===

Lua terminal debugger


I had a hard time finding command line debuggers that work with
lua. Funny how lua is so popular but there doesn't seem to be a place
that houses debuggers that work from the command line and integrates
into emacs (maybe I didn't look hard enough?)

This repo contains an Emacs e-lisp file that provides the tracking of
the source file from tagged output of the debugger.lua file.

This is an extension of the work of Scott Lembcke of Howling Moon
Software. 


To use:

Say you are debugging a file "test-file.lua".   You can add this to
the top of the file. (Note: that debugger.lua should be in your
LUA_PATH)

If you want to debug a function foo().  Call the dbg() function inside
of foo().

<pre>

dbg = require("debugger")

dbg ()

function foo ()
  dbg()

  -- my foo function
end

</
