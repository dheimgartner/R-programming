
#' Numbers needed from uniform s.t. their sum > 1
#'
#' @param verbose `logical` cat stuff to console
#'
#' @return
#' @export
#'
#' @examples
numbers_needed <- function(verbose = TRUE) {
  
  sum_ <- 0
  count <- 0
  
  while (sum_ < 1) {
    number <- runif(1);
    sum_ <- sum_ + number
    count <- count + 1
    
    if (verbose) {
      cat("Adding number", number, "\n")
      cat("Sum is:", sum_, "\n")
      cat("Numbers drawn:", count, "\n\n")
    }
  }
  
  count
  
}



numbers_needed()





numbers_needed_sim <- function(reps = 1000) {
  
  count <- numeric(reps)
  
  for (i in 1:reps) count[i] <- numbers_needed(verbose = F)
  
  class(count) <- "numbers_needed_sim"
  count
  
}



numbers_needed_sim()




print.numbers_needed_sim <- function(x) {
  
  print(prop.table(table(x)))
  
}

numbers_needed_sim()
