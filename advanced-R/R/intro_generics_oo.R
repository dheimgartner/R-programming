help(print)

# x - an object used to select a method
# the default method print.default - use methods("print")

help(methods)

# list methods for S3 Generic Functions or Classes

methods(print)
class(print)

# https://cran.r-project.org/doc/manuals/r-release/R-intro.html#Object-orientation

# how to extend generic functions ?
# how to write generic functions ?

# EXERCISE: create a class "my_char" which you can index using the function "["

ex <- "hello"
class(ex)
class(ex) <- "my_char"
class(ex)
mode(ex)

print(ex)
print.my_char <- function(x) print(paste0("---", x, "---"))
print(ex)

"print.my_char" %in% methods(print)

`[.my_char` <- function(x, i) {
  if (i > length(x)) stop("Index out of bound!")
  strsplit(x, "")[[1]][i]
}

ex[1]
ex[10]
"hello"[1]

# http://adv-r.had.co.nz/OO-essentials.html
# TODO: Read OO field guide -> see oo_field_guide.R
