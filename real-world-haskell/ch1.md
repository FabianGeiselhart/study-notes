# Chapter 1 Notes

## Environment

* ghc: Compiler
* ghci: Interpreter
* runghc: running as scripts.

The haskell stack is not mentioned. But using it makes things easier. (eg. Package management).
Installing it makes installing ghc uneccessary. (At least on arch linux)

## Arithmetics

* You can make infix functions prefix by wrapping them in ( ). (Spoil: wrapping them in \` \` makes them infix)

* Wrap negative numbers in ( ) if they are the second argument of a function.

## Boolean

* Most comparison functions are the same as in C. With the one notable exception being
`/=` (the equivalent to C's `!=`)

* You can not compare bools and Ints (typesystem)

## Operator precedence and associativity

* `:info (+)` provides information about associativity and precedence about the infix operator `+`

## Values and variables

* pi is defined

* You can create a variable using this syntax: `let e = 4`. This is ghci specific.o

## Lists

* List syntax: `[e1, e2, e3]`. Empty list: `[]`

* All list elements have to be of the same type

* Easy list enumeration: `[1..6]`. (Only works for `Ord a => a`

* Concatenate lists: `a ++ b`

* Add at index 0: `x : [a , b]`

## Strings

* A string is surrounded by `"`

* A string is a list of chars. (Thus `'a'` is /= `"a"`) (GHC.Base: `type String = [Char])

* Every list function works on strings.

=> A string is a fancy way of writing a list of characters.

## Types

* The type of an expression is denoted by this syntax: `value :: Type`

* The first char of a type is uppercase. (comp: `Char`, `String`, `Bool`)
