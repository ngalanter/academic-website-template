library(dplyr)
library(tidyr)
library(stringr)

# formatting helpers ----------------------

#all of these can work with txt being a vector

it <- function(txt){ paste0("*",txt,"*") }

bf <- function(txt){ paste0("**",txt,"**") }

head <- function(txt,n){ paste0(paste0(rep("#",n),collapse = "")," ",txt) }

#modify to be your actual name
bf_name <- function(txt){ str_replace(txt,"Last, F.",bf("Last, F.")) }

link_f <- function(txt,link){ paste0("[",txt,"](",link,")")}

paren <- function(txt){ paste0("(",txt,")") }

# item helpers -------------------------------

pub <- function(authors,year,title,link=NA,journal){
  
  ftitle <- title
  
  if(!is.na(link)){
    ftitle <- link_f(title,link)
  }
  
  paste0(paste(bf_name(authors),paren(year),ftitle,it(journal), sep = ". "),".")
}