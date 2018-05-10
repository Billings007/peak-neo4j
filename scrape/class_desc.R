#required libraries
library(rvest)
library(stringr)
library(tidyr)
library(dplyr)
library(purrr) #for meaningful use

################################################
# get_descriptions
#
# this function takes a url and returns the url, 
# description, prerequisite, and credit info
# for a course at the College of Idaho.
################################################

get_descriptions <- function(class_url){
  #class_url <- class_list$url[i]
  course_page <- read_html(class_url)
  course_desc_node <- html_nodes(course_page, 'div p')
  course_desc_text <- html_text(course_desc_node)[2]
  
  #replace newlines with spaces
  course_desc_text <- str_replace_all(course_desc_text, '\n', " ")
  #split out prerequisite descriptions
  course_pre <- str_split(course_desc_text, 'Prerequisite[s]?:', n=2, simplify = TRUE)[,2]
  
  #credits
  course_cred <- html_nodes(course_page, '.credits') %>% 
    html_text() %>% str_replace_all(pattern = "\r\n", replacement = "") %>%
    str_replace_all(pattern = "\t", replacement = "")

  return(data.frame(url=class_url,desc=course_desc_text, prerequisites=course_pre, credits=course_cred))
}

maps_desc <- map_dfr(classes[classes$sub %in% c("MAT", "CSC", "PHY"),]$url, get_descriptions)
maps <- inner_join(classes, maps_desc, by="url")
