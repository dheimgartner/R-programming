# http://adv-r.had.co.nz/OO-essentials.html

library(pryr)



# S3 ----
# check if object is S3
df <- data.frame(x = 1:10, y = letters[1:10])
otype(df)
otype(df$x)  # numeric vector is "base"
otype(df$y)  # factor is "S3"
class(df$y)
typeof(df$y)

# in S3 methods belong to functions (so-called generics)

# Some S3 generics (like [, sum(), etc.) don't call UseMethod() because they are
# implemented in C. They are called internal generics and documented in ?"internal generic".
# ftype() knows about these special cases too.
?"internal generic"

# Defining classes and creating objects --
foo <- structure(list(), class = "foo")

foo <- list()
class(foo) <- "foo"

# most S3 classes provide a constructor function
foo <- function(x) {
  if (!is.numeric(x)) stop("X must be numeric")
  structure(list(x), class = "foo")
}

# Creating new methods and generics --
# To add a new generic, create a function that calls UseMethod()
f <- function(x) UseMethod("f")  # takes two arguments: the name of the generic function, and the argument to use for method dispatch
ftype(f)

# generic.class
f.a <- function(x) "Hello from method describing behaviour if f is applied on class a"
f.default <- function(x) "Unknown class"

a <- structure(list(), class = "a")
f(a)
f(list())



# S4 ----
# methods still belong to functions

# Defining classes and creating objects --
# use setClass() and new()
# find documentatin with special syntax class?className

setClass("Person",
         slots = list(name = "character", age = "numeric"))
setClass("Employee",
         slots = list(boss = "Person"),  # in slots you can use S4 classes, S3 classes (setOldClass()) or implicit class or base type
         contains = "Person")  # contains ~ inherits

alice <- new("Person", name = "Alice", age = 40)
john <- new("Employee", name = "John", age = 20, boss = alice)

alice@age
slot(john, "boss")

# Creating new methods and generics --
# good idea to use constructor function with same name as class (then use constructor instead of new())
# if you create generics from scratch use standardGeneric() which is the S4 equivalent to UseMethod()
setGeneric("phone_call", 
           def = function(x, y) standardGeneric("phone_call"))

setMethod("phone_call",
          c(x = "Person", y = "Person"),  # signature
          function(x, y) print(paste0(x@name, " calls ", y@name)))

setMethod("phone_call",
          c(x = "character", y = "character"),
          function(x, y) print(paste0(x, " --> ", y)))

phone_call(alice, john)  # since john is also a Person...
phone_call("Alice", "John")

selectMethod("phone_call", list("Person", "Person"))

otype(alice)
is(alice)
str(alice)
isS4(alice)

otype(phone_call)
ftype(phone_call)
is(phone_call)
str(phone_call)
isS4(phone_call)



# Use rather R6 than RC (below) -------------------------------------------
# https://adv-r.hadley.nz/r6.html#r6

# see separate file

# RC ----
# Methods belong to objects (standard OO kind of way)
# Best used for describing stateful objects (i.e. objects that change over time)

# Defining classes and creating objects --
# use setRefClass()
# use Class$new() to create new RC objects
Account <- setRefClass("Account")
Account$new()

# add fields which you later can get and set with $
Account <- setRefClass("Account",
                       fields = list(balance = "numeric"))

a <- Account$new(balance = 100)
a$balance  # get
a$balance <- 200  # set

# attention: objects are mutable
b <- a
b$balance
a$balance <- 0
b$balance

# if you don't want that behaviour use copy()
c <- a$copy()
c$balance
a$balance <- 100
c$balance

# in method definiion modify fields with <<-
Account <- setRefClass("Account",
                       fields = list(balance = "numeric"),
                       methods = list(
                         withdraw = function(x) {
                           balance <<- balance - x
                         },
                         deposit = function(x) {
                           balance <<- balance + x
                         }
                       ))

a <- Account$new(balance = 100)
a$deposit(100)
a$balance

# use `contains`
# which is the name of the parent RC class to inherit behaviour from
NoOverdraft <- setRefClass("NoOverdraft",
                           contains = "Account",
                           methods = list(
                             withdraw = function(x) {
                               if (balance < x) stop("Not enough money")
                               balance <<- balance - x
                             }
                           ))

accountJohn <- NoOverdraft$new(balance = 100)
accountJohn$deposit(50)
accountJohn$withdraw(200)

isS4(accountJohn)
is(accountJohn, "refClass")
otype(accountJohn)
