


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Insert words into trie
#'
#' @param trie trie object
#' @param words character strings
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
trie_insert <- function(trie, words) {

  orig_node <- trie
  all_chars <- strsplit(words, '')

  for (i in seq_along(words)) {
    node <- orig_node
    for (char in all_chars[[i]]) {
      if (is.null(node[[char]])) {
        node[[char]] <- new.env(parent = emptyenv(), hash = FALSE)
      }
      node <- node[[char]]
    }
    node$term <- words[i]
  }

}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a trie
#'
#' @section Trie data representation:
#' The trie is implemented here as nested environments.  Environments are
#' created with \code{new.env(parent = emptyenv(), hash = FALSE)}.
#'
#' Using the \code{emptyenv()} as parent saves some memory, as the parent
#' environment is never needed in this process.
#'
#' \code{hash} is set to \code{FALSE} as using a hash table expands the memory
#' usage by quite a bit - even if \code{size} is set on the hash table.
#'
#' Using a hash table on the environment doesn't
#' appreciably change the speed of trie creation or preforming look-ups.
#'
#' @param words vector of character strings with which to initialise trie.
#'        Default: NULL
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
trie_create <- function(words = NULL) {

  trie <- new.env(parent = emptyenv(), hash = FALSE)

  if (!is.null(words)) {
    trie_insert(trie, words)
  }

  class(trie) <- 'trie'
  trie
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find anagrams using all possible subsets of characters
#'
#' @param node starting node of tree
#' @param chars vector of single characters. Use '.' for a wildcard
#'
#' @return character vector of words. may contain duplicates
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
trie_find_subwords_inner <- function(node, chars) {

  possibles <- intersect(chars, names(node))

  words <- c()

  for (char in possibles) {
    idx        <- min(which(chars == char))
    next_chars <- chars[-idx]
    next_node  <- node[[char]]
    next_words <- trie_find_subwords_inner(next_node, next_chars)
    words      <- c(words, next_node$term, next_words)
  }

  if ('.' %in% chars) {
    possibles <- intersect(letters, names(node))
    idx        <- min(which(chars == '.'))
    next_chars <- chars[-idx]
    for (char in possibles) {
      next_node  <- node[[char]]
      next_words <- trie_find_subwords_inner(next_node, next_chars)
      words      <- c(words, next_node$term, next_words)
    }
  }

  words
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Within a trie, find all possible words which can be created from the letters of the given word
#'
#' @param trie root node of trie
#' @param word single character string
#'
#' @return character vector of words, or NULL if no matching words found
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
trie_find_subwords <- function(trie, word) {
  stopifnot("'word' argument must be length = 1" = length(word) == 1)
  trie_find_subwords_inner(trie, strsplit(tolower(word), '')[[1]])
}


