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

#adds blank lines before, in between, and after entries
# txt can be a list (multi-line entries) or a vector (one-line entries)
empty_line_wrap <- function(txt){ 
  
  #for a vector add between every line
  if(class(txt) == "character"){
    
  ret <- c("",rbind(txt,rep("",length(txt))))
    
  }else{#for a list add between entries
    
    ret <- lapply(txt,function(x) c(x,""))
    
    ret[[1]] <- c("",ret[[1]])
  }
  
  return(ret)
    
}

#turn text vector into a line block to preserve line breaks
line_block <- function(txt) { paste("|",txt) } 

#turn text vector into a list
list_f <- function(txt) { paste("-",txt) } 

# item helpers ------------------------------

# ... at ends of functions so can apply to dataframe without selecting vars

pub <- function(authors,year,title,link=NA,journal,subtype,...){
  
  ftitle <- title
  
  if((!is.na(link) & link != '')){
    ftitle <- link_f(title,link)
  }
  
  if(subtype == "Preprint"){
    
    paste0(paste(bf_name(authors),paren("Preprint"),ftitle, sep = ". "),".")
    
  }else{
  
    paste0(paste(bf_name(authors),paren(year),ftitle,it(journal), sep = ". "),".")
    
  }

  }

#helper to format specific occassion a presentation/poster was presented
pres_instance <- function(year,month,location,event,...){
  
  paste0(event,", ",location,", ",month," ",year)

}

#formatting for an overall unique presentation/poster
# there can be one or more confrences/events at which it was presented
pres <- function(title,link=NA,dat,..){
  
  ftitle <- title
  
  instances <- dat %>% filter(title == ftitle)
  
  if((!is.na(link) & link != '')){
    ftitle <- link_f(title,link)
  }
  
  return(unlist(c(bf(ftitle), pmap(instances,pres_instance))))
  
}

#formatting for entry on the news section of the index page
news_item <- function(type,subtype,title,link = NA,journal,event,...){
  
  ftitle <- title
  
  if((!is.na(link) & link != '')){
    ftitle <- link_f(title,link)
  }
  
  if(type == "Publication"){
    
    if(subtype == "Preprint"){
      
      ret <- paste("Released preprint ",bf(ftitle))
      
    } else{
      
      ret <- paste("Published paper",bf(ftitle),
                   "in",journal)
      
    }
    
  } else if(type == "Presentation"){
    
    if(subtype == "Presentation"){
      
      ret <- paste("Gave talk",bf(ftitle),"at",event)
      
    } else if(subtype == "Poster"){
      
      ret <- paste("Presented poster",bf(ftitle),"at",event)
      
    }
    #if have an entry that should only go in news, type is "other News"
    #   and title is the desired news text
  } else if(type == "Other News"){
    
    ret <- ftitle
  }
  
  return(ret)
  
}

# page helpers ------------------------------

#splits pages into update and non-update components
#  depends on the section break formatting being very specific
#    for example no lines between ":::"'s and the break string
split_helper <- function(old_page,break_strings){
  
  fun <- function(x){
    
    start_ind <- str_which(old_page,paste0(x,"_start"))
    end_ind <- str_which(old_page,paste0(x,"_end"))
    
    c(start_ind+1,start_ind+2,end_ind-2,end_ind-1)
      
  }
  
  breaks <- c(1,sapply(break_strings,fun),length(old_page))
  
  sapply(seq(from =1,to = length(breaks),by = 2), 
         function(x) old_page[breaks[x]:breaks[(x+1)]])
  
}

#creates updated cv page
cv <- function(old_cv,content){
  
  parts <- split_helper(old_cv,c("cv_pub_update", "cv_pres_update"))
  
  #updating publications
  
  pubs_update <- content %>% filter(type == "Publication") %>% 
    arrange(desc(year)) %>% 
    pmap(pub) %>% unlist() %>% empty_line_wrap()
  
  parts[[2]] <- pubs_update
  
  #updating presentations
  
  #talks
  talks <- content %>% 
    filter(type == "Presentation", subtype == "Presentation") %>%
    arrange(desc(year),desc(num_month))
  
  unique_talks <- talks %>% 
    select(title,link) %>% distinct()
  
  talks_update <- lapply(1:nrow(unique_talks),
                        function(x) pres(unique_talks$title[x],
                                         unique_talks$link[x],
                                         talks)) %>% 
    empty_line_wrap() %>% unlist()
  
  talks_update[2:(length(talks_update)-1)] <- 
    line_block(talks_update[2:(length(talks_update)-1)]) 
  
  talks_update <- c(head("Presentations",3),talks_update)
  
  posters <- content %>% 
    filter(type == "Presentation", subtype == "Poster") %>%
    arrange(desc(year),desc(num_month))
  
  unique_posters <- posters %>% 
    select(title,link) %>% distinct()
  
  
  posters_update <- lapply(1:nrow(unique_posters),
                         function(x) pres(unique_posters$title[x],
                                          unique_posters$link[x],
                                          posters)) %>% 
    empty_line_wrap() %>% unlist()
  
  posters_update[2:(length(posters_update)-1)] <- 
    line_block(posters_update[2:(length(posters_update)-1)]) 
  
  posters_update <- c(head("Posters",3),posters_update)
  
  pres_update <- c(talks_update,posters_update)
  
  parts[[4]] <- pres_update
  
  return(do.call(c,parts))
  
}

#creates updated homepage
index <- function(old_index,content){
  
  parts <- split_helper(old_index,c("news_update"))
  
  news_update <- content %>% filter(skip_in_news != "Yes") %>%
    arrange(desc(year),desc(num_month)) %>%
    #including 5 updates mostly to illustrate, could include less
    slice_head(n = 5) %>% pmap(news_item) %>% 
    unlist() %>% empty_line_wrap()
  
  parts[[2]] <- news_update
  
  return(do.call(c,parts))
}



# run the update ------------------------------

content <- read.csv("sample_content.csv")

content <- content %>% 
  mutate(num_month = match(month,month.name),
         num_month = if_else(is.na(num_month),12,num_month))

#updating cv
old_cv <- readLines("cv_resume1.qmd")

writeLines(old_cv,"old_cv_backup.qmd")

new_cv <- cv(old_cv,content)

writeLines(new_cv,"cv_resume1.qmd")

#updating news section of index
old_index <- readLines("index.qmd")

writeLines(old_index,"old_index_backup.qmd")

new_index <- index(old_index,content)

writeLines(new_index,"index.qmd")
