# I/O

* Haskell seperates pure and impure functions

## Classic I/O in Haskell
* A `IO` in the type signature means that it's an I/O Action
* An I/O Action can be executed from another I/O Action
* The return type of an I/O Action is a normal Haskell type. But it can produce side effects.
* `getLine` stores an I/O action.
* `do` is used to define a sequence of actions. It's only neccessary if used with two or more
  actions.
* Ìn a `do` block, `let` is used to bind results of pure code to variable names.

### Why purity matters
* Many bugs are caused by unexpected/unwanted side effects. In Haskell you know which function
  has which side effects.
* Reasoning about pure functions is much easier.

## Working with files and handles
* `System.IO` is a collection of I/O related stuff
* To interact with a file one needs a `Handle` first. (by using `openFile`)
* With this `Handle` one can perform operations on the file
* When working with a `Handle` one uses I/O actions that are similar to the "normal" ones but
  require a `Handle` as arument. (e.g `hPrint`)
* `Handles` can be created with `openFile` and closed with `hClose`.
* The state of the cursor can be checked with `hIsEOF` (`True` at `EOF`)
* You should use `hClose` to close a handle every time.
* `hTell` returns a `IO Integer` containing the cursor position (in bytes)
* Using `stdin`, `stdout` and `stderr` is usphul to pipe in-/outputs to other programs

### Deleting and Renaming Files
* `System.Directory` provides functions to work with files and dirs.
* `renameFile` takes the name of the file and a renamed name.
* `removeFile` takes the name of a file and removes it.

### Temporary files
* `openTempFile` and `openBinaryTempFile` create a Temorary file according to the OS standart.
  This functions take a directory and a file prefix as arguments.
* `System.Directory.getTemporaryDirectory` returns the best dir to place temporary files in.

## Lazy I/O
* `hGetContents` does not load the whole file into RAM. Instead the returned `String` is
  evaluated lazily.
* Pure functions cannot determine whether the used value is read from a file or created from
  within the program.
* Garbage collection only works AFTER the last usage of the value.
* If a `Handle` is closed before the loaded value is used, nothing will be loaded.
* The `interact` function reads from `stdin`, applies a funtion to the created `String` and
  then prints to `stdout`

## The I/O Monad
* I/O Actions are defined within the `IO` Monad.
* Moads are a way of serializing functions.
* Actions don't do anyting until they're invoked
* `mapM` creates a list of actions
* `mapM_` creates a list of actions and executes them

### Sequencing
* The `>>` functions takes two actions and executes them. It evaluates to the return value
  of the second action.
* The `>>=` takes a action and a function that evaluates to an action. The return value of
  the action is passed to the function and the resulting action is executed too.

### The true Nature of return
* The `return` keyword is used to wrap data in a monad.
* Return can occur everywhere in a `do` block.

## Is Haskell Really imperative?

### Side Effects with Lazy I/O
* Haskell functions can't modify global variables, do I/O etc.
* A `String` from `hGetContents` can be passed to a pure function. While processing this
  `String` the ENVIRONMENT may issue I/O commands to read that string. But the commands
  are not issued by the pure function.

## Buffering
* I/O is slower than working with data from within the program
* Buffering allows to reade the same amount of data with less syscalls.
* Haskells default buffering settings work very often but are not really fast.

### Buffering Modes
* There are three buffering modes, all of the type `BufferMode`
* `NoBuffering` does not use buffering. Thus data is read and written one character at a time,
  resulting in poor performance.
* `LineBuffering` writes output whenever a `\n` is insterted (or the chunk gets too large)
  , on input it reads all data available until it reaches a `\n`.
* `BlockBuffering` causes Haskell to read and write in fixed-size chunks. It takes one
  argument of type `Maybe`, denoting the buffer size. (`Nothing` is a implementation defined
  buffer size)
* `hGetBuffering` returns the curren `BufferMode`.
* `hSetBuffering` accepts a `Handle` and a `BufferMode` to change the mode.

### Flushing the buffer
* `hClose` automatically flushes
* Manual flushing can be done with `hFlush`

## Reading Command-Line arguments
* `System.Environment.getArgs` returns an `IO [String]` listing the arguments. (Like `argv`
  in C.
* `System.Console.GetOpt` provides some tools for argument parsing.

## Environment Variables
* `System.Environment` provides two actions (`getEnv` and `getEnvironment`) to get env-vars.
* On a POSIX system you can use `putEnv` or `setEnv` from `System.POSIX.Env` to set env-vars.
