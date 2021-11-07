# Environments ----
# http://adv-r.had.co.nz/Environments.html#binding
library(pryr)



# Environment basics ----
# active env
environment()

# list all parents of global env
search()

# access any env
as.environment("package:stats")

# list the bindings
ls(package:stats)

# create new env
e <- new.env()
parent.env(e)

# easiest way to modify bindings -> treat like list
e$a <- "hello"
e$b <- "world"
e$.a <- "hidden"
ls(e)
ls(e, all.names = T)

# use $, [[]] or get() to extract values
c <- "global_env"
e$c  # looks only in e (no scoping), as does e[["c]]
get("c", envir = e)  # with scoping

rm(".a", envir = e)
ls(e, all.names = T)

exists("c", envir = e)
exists("c", envir = e, inherits = F)



# Recursing over environments ----
where("c")
where("mean")



# Function environments ----
# Four types of environments are associated with a function: enclosing, binding, execution and calling
# enclosing env: where function was created and values are looked up
# binding env: binding function to a name with <- operator
# execution env: stores variables created during execution (thrown away afterwards)
# calling env: tells you where the function was called


# Enclosing environments --
# reference to the env it was made
y <- 1
f <- function(x) x + y
environment(f)

# Binding environments --
# For the function f the binding env is the same as the enclosing env
# however we can assign a different env
e <- new.env()
e$g <- function() y
e$g()  # takes y from global_env
environment(e$g) <- e  # change enclosing env
e$y <- 2
e$g()  # now takes y from e

# The enclosing env determines how the function finds values;
# the binding envs determine how we find the function

environment(sd)  # enclosing env namespace:stats (where to find values)
where("sd")  # binding env package:stats (where to find function)

# Execution environments --
# Each time a function is called, a new env is created to host execution
# which is thrown away after execution

plus <- function(x) {
  function(y) x + y  # returns a function!
}

plus_one <- plus(1) # the enclosing env of plus_one is the execution env of plus() where x is bound to the value 1
plus_one(3)

# Calling environments --
# the unfortunately named parent.frame() retrns the environment where the function was called

