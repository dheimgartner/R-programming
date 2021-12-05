# Create a class that allows you to write a line to a specified file.
# You should open a connection to the file in $initialize(), append a line using cat()
# in $append_line(), and close the connection in $finalize().

library(R6)

rm(list = ls())


# TODO: append does not work -> see ?cat (only if not a connection... (?))

FileWriter <- 
  R6::R6Class("FileWriter",
              private = list(.file = NULL),
              public = list(
                path = NULL,
                initialize = function(path) {
                  self$path <- path
                  private$.file <- file(path, "w")
                  cat("Established connection to: ", path, "\n", sep = "")
                },
                finalize = function() {
                  message("Cleaning up ", self$path)    # sends to stderr() connection
                  close(private$.file)
                },
                append_line = function(line) {
                  cat(line, file = private$.file, sep = "\n", append = TRUE)
                }
              ))




fw <- FileWriter$new("./hello_file_writer.txt")
fw$append_line("hello world")
rm(fw)

fw <- FileWriter$new("./hello_file_writer.txt")
fw$append_line("how do you do?")
rm(fw)
