library(dplyr)
library(tidyr)
library(stringr)
library(purrr)

# formatting helpers ----------------------

#all of these can work with txt being a vector

it <- function(txt){ paste0("*",txt,"*") }

bf <- function(txt){ paste0("**",txt,"**") }

head <- function(txt,n){ paste0(paste0(rep("#",n),collapse = "")," ",txt) }

#modify to be your actual name
bf_name <- function(txt){ str_replace(txt,"Last, F.",bf("Last, F.")) }

link_f <- function(txt,link){ paste0("[",txt,"](",link,")")}

paren <- function(txt){ paste0("(",txt,")") }

#adds blank lines before, in between, and after vector entries
empty_line_wrap <- function(txt){ c("",rbind(txt,rep("",length(txt)))) }

# item helpers ------------------------------

# ... at ends of functions so can apply to dataframe without selecting vars

pub <- function(authors,year,title,link=NA,journal,...){
  
  ftitle <- title
  
  if(!is.na(link)){
    ftitle <- link_f(title,link)
  }
  
  paste0(paste(bf_name(authors),paren(year),ftitle,it(journal), sep = ". "),".")
}

# page helpers ------------------------------

cv <- function(old_cv,content){
  
  parts <- list(old_cv[1:(str_which(old_cv,"cv_pub_update_start")+1)],
                old_cv[(str_which(old_cv,"cv_pub_update_start")+2):
                       (str_which(old_cv,"cv_pub_update_end")-2)],
                old_cv[(str_which(old_cv,"cv_pub_update_end")-1):
                         length(old_cv)])
  
  update_with <- content %>% filter(type == "Publication") %>% 
    arrange(desc(year)) %>% pmap(pub) %>% unlist()
  
  update_with <- empty_line_wrap(update_with)
  
  parts[[2]] <- update_with
  
  return(do.call(c,parts))
  
}



# run the update ------------------------------

content <- read.csv("sample_content.csv")

old_cv <- readLines("cv_resume1.qmd")

writeLines(old_cv,"old_cv_backup.qmd")

new_cv <- cv(old_cv,content)

writeLines(new_cv,"cv.qmd")
