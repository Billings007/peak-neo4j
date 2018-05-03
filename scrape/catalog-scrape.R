library(rvest)
library(stringr)
library(dplyr)
library(purrr)

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

subDF <- str_split(subjectText,pattern= '-', n=2, simplify=TRUE) %>% as.data.frame()
names(subDF) <- c("sub", "subject")
subDF <-mutate(subDF, sub=str_trim(sub, side="both"), subject=str_trim(subject, side="both"))

#get url for subject, for each row in subDF
subDF <-subDF %>% mutate(url= paste0(base_url,base_url_ext,'/',sub,'-',str_replace_all(subject,' ','-')))

#hack to fix ENV link issue
envStud_url <- subDF[subDF$sub=='ENV',]$url
subDF[subDF$sub=='ENV',]$url <- str_replace(envStud_url, 'Studies', 'Science')

get_class_list <- function(i){
  #get list of links on subject page
  class_links <- html_nodes(read_html(subDF$url[i]), 'a')
  #turn links to text
  class_list <- html_text(class_links)
  #only keep links for classes, each subject has 
  #classes starting in a different position
  class_list <- class_list[str_detect(class_list, paste0(subDF$sub[i],'-'))]
  #now build class dataframe with sub,number,name,url - we'll get the
  #other details on the next scrape
  
  #We'll split on 1st space, discard everything after it and use
  #what's before it to build the required DF
  class_list <- str_split(class_list, " ", n=2, simplify=TRUE) %>% data.frame()
  names(class_list) <- c("id","Name")
  
  #the id field has the last part of the new url, we need the 
  #subject url with the course level (100,200,etc) then id
  class_list <- mutate(class_list, url=paste0())
  print(i) #for testing to see when a suject fails
  return(class_list)
}
