library(tidyverse)

nyt_all <- read_rds("~/Documents/gitrepos/text_clustering/nyt_all.rds")

data_lengths <- lapply(nyt_all, function(x) max(nchar(x)))

# inspecting columns that are relevent to that article
nyt_all$response.docs.lead_paragraph[133]
nyt_all$response.docs.abstract[133]
nyt_all$response.docs.snippet[133]
# can combine abstract and lead_paragraph

nyt_df <- nyt_all %>% 
  mutate(text = tolower(paste0(response.docs.lead_paragraph, " ", response.docs.abstract)),
         date = as.Date(response.docs.pub_date),
         news_desk = tolower(response.docs.news_desk),
         section_name = tolower(response.docs.section_name),
         material = tolower(response.docs.type_of_material)) %>% 
  select(date, text, news_desk, section_name, material) %>% 
  mutate(news_desk = if_else(news_desk =="", material, news_desk),
         text = gsub('[[:punct:] ]+', ' ', text))

base_bar_plot <- function(data, col){
  
  col <- enquo(col)
  
  data %>% 
    select(!!col) %>% 
    group_by(!!col) %>% 
    count() %>% 
    ggplot(aes(x = reorder(col, freq), y = freq)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(x = "", y = "", title = paste0("Number of Articles by ", col)) +
    theme_bw()
}

base_bar_plot(nyt_df, material)
base_bar_plot(nyt_df, section_name)
base_bar_plot(nyt_df, news_desk)
