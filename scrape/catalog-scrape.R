library(rvest)
library(stringr)
library(dplyr)

#url for courses in catalog
base_url <- "http://collegeofidaho.smartcatalogiq.com"
base_url_ext <- "/en/current/Undergraduate-Catalog/Courses"

base_html <- read_html(paste0(base_url,base_url_ext))
#extract links from base page
subjectLinks <- html_nodes(base_html, 'a')
#convert links to text
subjectText <- html_text(subjectLinks)
#pick out what corresponds to subject list
#we now have subject codes and names
subjectText <- subjectText[78:120]

subDF <- str_remove_all(subjectText, ' ') %>% str_split(pattern= '-', n=2, simplify=TRUE) %>% as.data.frame()
names(subDF) <- c("sub", "subject")

#get url for subject, for each row in subDF
subDF <-subDF %>% mutate(url= paste0(base_url,base_url_ext,'/',sub,'-',str_replace_all(subject,' ','-')))

get_class_list <- function(sub_url, sub_code){
  #get list of links on subject page
  class_links <- html_nodes(read_html(sub_url), 'a')
  #turn links to text
  class_list <- html_text(class_links)
  #only keep links for classes, each subject has 
  #classes starting in a different position
  class_list <- class_list[str_detect(class_list, paste0(sub_code,'-'))]
  #now build class dataframe with sub,number,url - we'll get the
  #name and other details on the next scrape
  
}