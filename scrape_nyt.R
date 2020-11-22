library(jsonlite)
library(tidyverse)
library(plyr)

# pull in nyt api key
NYTIMES_KEY <- Sys.getenv(x = "NYTIMES_KEY")

# term to search for
term <- "election" # Need to use + to string together separate words

# day after the election
begin_date <- "20201104"

# two weeks after election
end_date <- "202011028"

# create url
baseurl <- paste0("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=",term,
                  "&begin_date=",begin_date,"&end_date=",end_date,
                  "&facet_filter=true&api-key=",NYTIMES_KEY, sep="")

# calling api
nitialQuery <- fromJSON(baseurl)

# number of pages to scrape
maxPages <- round((initialQuery$response$meta$hits[1] / 10)-1) 

# loading in article meta data
pages <- list()
for(i in 0:maxPages){
  nytSearch <- fromJSON(paste0(baseurl, "&page=", i), flatten = TRUE) %>% data.frame() 
  message("Retrieving page ", i)
  pages[[i+1]] <- nytSearch 
  Sys.sleep(60) 
}

# combining all data into dataframe
nyt_all <- rbind_pages(pages)

write_rds(nyt_all, "~/Documents/gitrepos/text_clustering/nyt_all.rds")