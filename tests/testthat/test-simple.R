


test_that("simple trie works", {

  words <- c('cat', 'god', 'dog', 'toc')
  trie <- trie_create(words)
  expect_identical(trie_find_subwords(trie, 'tac'), 'cat')
  expect_identical(trie_find_subwords(trie, 'dog'), c('dog', 'god'))

  expect_null(trie_find_subwords(trie, 'xxx'))
})
