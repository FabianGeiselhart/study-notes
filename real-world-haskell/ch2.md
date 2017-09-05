# Types and Functions

## Why care about types?

* Every expression and function as a type
* Values of a certain type share certain properties (e.g. list concatenation)
* Types give us abstraction. They add meaning to the low-level bits.
* You don't have to know about the implementation of a certain type to use it.
* Not every language uses the same type system.

## Haskell's type system

* Haskell types are strong, static and they can be automatically inferred
* This system makes Haskell safer and more expressive
* You can declare the type of an expression by using the `::` operator

```
  > let x = 1 :: Int
  > let y = 1 :: Float

  > :t x
  x :: Int

  > :t y
  y :: Float
```

### Strong types

* If a function wants an `Integer` you can only pass an `Integer` (otherwise a type error is raised)
* There is no automated type casting (like in C)
* A strong type system can catch certain bugs before compile time

### Static types

* The type of _every_ expression is known at compile time. Hence type errors can't occur at runtime.
* Since the compiler proves the absence of type errors there is no need for large test suits
* To make things more convenient there is polymorphism.

### Type inference

* The compiler knows the type of almost any expression.

## Lists and tuples

* List and tuples are composite data types.
* Using functions like `head` or `snd` may raise exceptions.

### Lists

* A list contains an undefined number of elements of the _same_ type.
* Lists the type of a list changes with the type in the list

### Tuples

* A tuple is a fixed size collection of values with different (or equal) types.
* Tuples with a different length have a different type.
```
  > (True, True, False) == (True, False)
<interactive>:1:24: error:
    • Couldn't match expected type '(Bool, Bool, Bool)’
                  with actual type ‘(Bool, Bool)’
    • In the second argument of ‘(==)’, namely ‘(True, False)’
      In the expression: (True, True, False) == (True, False)
      In an equation for ‘it’: it = (True, True, False) == (True, False)
(0.07 secs,)
```

## Functions

### Types and purity

* The type of a function can provide information about what the function does
* A function type looks like this: `lines :: String -> [String]`
* In Haskell a "normal" function cannot have side effects.
* Functions having side effects are in the `IO` Monad and are called "impure"

### Function application and types

* A function with more than one argument has a signature like this `f :: a -> b -> b`
  Or `f :: a -> (b -> b)` because the `->` is right-associative.
*Haskell's function notation is inspired by lambda calculus. This gives us some
funny things to work with. For example partial function application and currying.

### Conditional evaluation

A `if` expression looks like this

```
f a = if a == 1  -- A expression of type Bool
      then a + 1 -- The branches after then and else must have the same type
      else a + 2 -- Else is required
```

`myDrop` can be written like this: (I think it looks better, thats why I included it)

```
myDrop 0 xs     = xs
myDrop _ []     = []
myDrop n (_:xs) = myDrop (n-1) xs
```

### Lazy evaluation

* Values are not reduced until it's needed. `1 + 2` won't be reduced to `3` until it's neccessary.
* You can define do stuff with infinte lists:

```
let x = [1..] -- All positive integers

-- In a strict language the above statement would result in a memory overflow
-- But I can work with this stuff

print (x !! 6) -- I only have to evaluate 6 elements. So this works
print x        -- Now the whole list gets evaluated. This won't stop.
```

* To print a value without forcing evaluation you can use the `:sprint` ghci command

```
> let x = [1..5] :: [Int]

> :sprint x
x = _ -- Not evaluated yet. Bottom value.

> x !! 1
2

> : sprint x
x = 1 : 2 : _ -- First two elements evaluated
```

### Parametric Polymorphism

* There are two types of polymorphism. Parametric Polymorphism and ad-hoc (typeclass) polymorphism
* A polymorphic function can take any Type as argument.
* A type signature of such an function looks like this:
  `const :: a -> b -> a` `a` and `b` can be of any type, but both `a`'s must have the same.
* A polymorphic function has no way to find out what the type of the polymorphic argument is.
  Hence a function with this `id :: a -> a` signature can only return the unchanged object.

