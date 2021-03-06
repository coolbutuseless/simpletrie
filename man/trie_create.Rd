% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trie.R
\name{trie_create}
\alias{trie_create}
\title{Create a trie}
\usage{
trie_create(words = NULL)
}
\arguments{
\item{words}{vector of character strings with which to initialise trie.
Default: NULL}
}
\description{
Create a trie
}
\section{Trie data representation}{

The trie is implemented here as nested environments.  Environments are
created with \code{new.env(parent = emptyenv(), hash = FALSE)}.

Using the \code{emptyenv()} as parent saves some memory, as the parent
environment is never needed in this process.

\code{hash} is set to \code{FALSE} as using a hash table expands the memory
usage by quite a bit - even if \code{size} is set on the hash table.

Using a hash table on the environment doesn't
appreciably change the speed of trie creation or preforming look-ups.
}

