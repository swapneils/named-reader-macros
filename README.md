# Named Reader Macros

This is a simple utility that allows you to assign long names to reader macros.

Due to some weirdness with SBCL at least changing (cloning?) the readtable object when within a read macro, this utility depends on `named-readtables`, and cannot create named reader macros in unnamed readtables. We can only identify and distinguish readtables through `named-readtables:readtable-name`.

Example usage:
1. Run the `read-with-hello` definition in `named-reader-macros.lisp`
2. Run `#_read-with-hello "hiThere"` in your REPL
3. The output should be `"hello hiThere!"`
