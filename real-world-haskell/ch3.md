# Chapter 3

## Data Types

* Data types add structure to values in a Haskell program
* Data types also improve the safety of the program (you can't mix two types with the same
  structure)
* A data type consists of:
  * A Type constructor (1), used in Type signatures
  * A data (or value) constructor (2), used to create the type (often equals the Type const.)
  * Some values the type contains
```
--      (1)     (2)  (3)   (3)      (3)
data Book = Book Int String [String]
```
* Types are created by using the data constructor like a function
```
myBook = Book 1 "Real world haskell" ["Bryan O'Sullivan", "Don Stewart", "John Goerzen"]
```
* The type of `myBook` is the type constructor of `Book` (`myBook :: Book`)

## Type Synonyms

* You can define a synonym to existing values. (e.g. To give them a more descriptive name)
* Using the `type` keyword the synonym has the representation of the original at compile and
  runtime. (You can interchange the synonym almost everywhere)
* Using `newtype` the synonym has the representation of the original only at runtime.
  (Used it you want different type class instances for one type)

## Algebraic data types

* An algebraic data type can have more than one data constructor (cases).
* Multiple algebraic data types are used like this:
```
data BookInfo = Book String Int
              | Magazine String Int
```
* Algebraic data types are used instead of tuples if one wants to distinguish between two
  structurally identical values.
