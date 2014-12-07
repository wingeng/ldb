ldb
===

Lua terminal debugger


I had a hard time finding command line debuggers that work with
lua. Funny how lua is so popular but there doesn't seem to be a place
that houses debuggers that work from the command line and integrates
into emacs (maybe I didn't look hard enough?)

This repo contains an Emacs e-lisp file that provides the tracking of
the source file from tagged output of the debugger.lua file.  Emacs
isn't required.  If used outside of emacs it'll print out context
lines from the source.

This is an extension of the work of Scott Lembcke of Howling Moon
Software. 

# To use outside of emacs


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
  print("Inside foo")
  local x = 1
  x = x + 4
  print("x:", x)
end
</pre>

# Example from terminal

Try debugging the file "test-file.lua".

<pre>

minitwo:~/work/ldb> lua test-file.lua
debugger.lua loaded for Lua 5.1
inside bar
:   --
:   local function foo (x)
:      -- This is essentially a break point
:      dbg()
: >    print("inside foo")
:      x = x * 8
:      print("ex times 8 is : ", x)
:      return x
:   end
:
[ldb:@test-file.lua:28]

</pre>

You'll see the 'context' lines.  The default default number of lines is
half of the terminal lines. (Note: LINES must be exported, otherwise it
defaults to 24)

# Example from emacs

The ldb.el file contains the elisp to track the debug'ed file using the
output of the debugger [ldb:@file:line-no].

To use, eval the ldb.el file and start the debugging from the shell

<pre>

Emacs window: 
![emacs-window photo](http://wingeng.github.io/photos/ldb-emacs.png)
