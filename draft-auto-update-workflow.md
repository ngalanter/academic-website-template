# Preparing other site pages for auto update

- add blocks with strings seperating out the auto-update content from the manual page content
  + could use conditional content, like `::: {.content-hidden unless-format="markdown"} index_news_auto  :::` then `::: {.content-hidden unless-format="markdown"} end_index_news_auto  :::`
 
# Preparing auto-update content

- create a csv with fields appplicable to articles, presentations, software, etc, including item type, subtype (like methods as a article subtype), and project (if using a layout separated by projects)
- bonus goal: write a funtion that takes a `.bib` file and outputs/appends to a csv all fields with info present in that file (so excluding things like subtype and project)
- for any associated pictures, create a folder of pictures and add the names to the csv

# Auto-update R code set-up

1. helper functions to make code mode interpretable and easier to modify, each step uses the previous
  a. functions for basic formatting make sure they can be used in combination, examples:
    +   italics
    +   bolding
    +   turning text into a headline
    +   creating a link from two fields
  b.  functions for formatting each type of item, examples:
    + publications on publications page
    + projects on home page
    + publications on cv
  c. functions for each page with:
    + the sections of manual vs auto-update content and their order
    + how to sort the auto-update content
    + (option this could also be part of manual content) how to combine the auto-update content using headings
2. creating pages
  a. read in content csv
  b. read in pages
  c. (optional in case forget to commit beforehand) save old pages as a backup
  c. run page functions
  d. save new pages
