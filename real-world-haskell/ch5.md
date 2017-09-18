# Chapter 5

## Representing JSON Data

* A JSON data field can be represented with a Algebraic data type
* Writing accessor functions to turn a `JValue` into a "normal value" easily

## Modules

* Modules declare which names inside the module (file) are accessible from the outside
* A file and the module it contains MUST have the same name (without the .hs)
* A module with no( `()` ) exports is perfectly possible
* Unlike in the book, my `Main` module had to export the main function

## Generating a Haskell program

* A program can be complied with the `ghc` executable
* You can create object code of the file with the `-c` option
* You can compile your project by starting `ghc` with all files (or objects) as arguments

## Printing JSON Data

* One should seperate pure and impure code to have more flexibility

## Type inference is a double-edged sword

* Automatically infered types may not be what you expect the to be
* Without explicit type signatures finding errors might be harder

## Developing haskell code without going nuts

* Functions can be declared with and `undefined` body. This functions cannot be executed but
  they can be type checked.
* Using such an "stub" is helpful, since code can be compiled (and thus checked for type
  errors) before every function is complete.

## Pretty Printing a string

* The `string` function will take a `String` and transform it into a `Doc`
* The `oneChar` function escapes the characters. The lookup function escapes the simple
  ones and returns a `Maybe String`. Otherwise the character is either escaped by hexEscape
  or simply returned as a `Doc`.
* Unicode escaping work either through `smallHex` (if the value is => 0xffff) or through
  the `astral` function which splits the Unicode character into two. The `hexEscape` function
  determines whether `smallHex` or `astral` is appropriate to use.

## Arrays objects and the module header

* The `series` function takes an opening and a closing char a function to wrap a type `a` into
  a `Doc` and a list of `a`.
* The punctuate function is the `Doc` version of `intersperse` from `Data.List`
* Arrays can now be rendered by using the `series` function to wrap the values in `[]`.
* Rendering objects needs a helper function to add the colon between the name and the value

## Writing a module header

A explicit list of module imports has following advantages:
 * Clarity about imports
 * Probability of name conflicts is reduced

## Fleshing out the pretty printing library

* The `Doc` type is an algebraic data type with four data constructors for values (`Empty`,
  `Char`, `Text` and `Line`), a `Concat` constructor to create a tree of `Docs` and a `Union`
  constructor.
* The constructors of `Doc` don't get exported. There are custom constructor functions
  provided instead. This is done because some constructors need some sort of extra
  transformation. (E.G `Concat`)
* The `<>` function combines two `Doc`s by using the `Concat` data constructor. If either
  side is `Empty` the function behaves like `id`
* `hcat` folds a list of `Doc` values with `<>`
* `fsep` works like `hcat` but inserts a `softline` after every element.
* `softline` inserts a `\n` if the line has become too wide, or a space otherwise. This is
  done by the `group` function, which evaluates to a `Union` containing a flattened version
  of the value and the normal one.
* `flatten` just replaces a `Line` with a `' '`.

## Compact rendering

* The `compact` function renders a `Doc` value with as few characters as possible.
* It only uses the second field of a `Union` (the one with the newline)

## True pretty printing

* The `pretty` function takes the maximum length of a line of output and determines whether
  to use a ` ` or a `\n` at a softline.
* The `fits` function checks whether a line fits.
