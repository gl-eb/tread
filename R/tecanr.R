# make where() from tidyselect available
utils::globalVariables("where")

# suppress R CMD check note
ignore_unused_imports <- function() {
  utils::help()
}
