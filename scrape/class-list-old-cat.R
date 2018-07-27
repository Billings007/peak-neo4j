library(rvest)
library(stringr)
library(dplyr)
library(purrr)
library(tidyr)

#url for courses in catalog
base_url <- "http://collegeofidaho.smartcatalogiq.com"
base_url_ext <- "/2016-2017/Undergraduate-Catalog/Courses"

base_html <- read_html(paste0(base_url,base_url_ext))
#extract links from base page
subjectLinks <- html_nodes(base_html, 'a')
#convert links to text
subjectText <- html_text(subjectLinks)
sub_url <- html_attr(subjectLinks, 'href')[78:120]
#pick out what corresponds to subject list
#we now have subject codes and names
subjectText <- subjectText[78:120]

subDF <- str_split(subjectText,pattern= '-', n=2, simplify=TRUE) %>% as.data.frame()
names(subDF) <- c("sub", "subject")
subDF <-mutate(subDF, sub=str_trim(sub, side="both"), subject=str_trim(subject, side="both"))

#get url for subject, for each row in subDF
#subDF <-subDF %>% mutate(url= paste0(base_url,base_url_ext,'/',sub,'-',str_replace_all(subject,' ','-')))
subDF <- mutate(subDF, url=paste0(base_url,sub_url))

#hack to fix ENV link issue -- not needed since url is pulled from html_attr
#envStud_url <- subDF[subDF$sub=='ENV',]$url
#subDF[subDF$sub=='ENV',]$url <- str_replace(envStud_url, 'Studies', 'Science')

get_class_list <- function(i){
  #get list of links on subject page
  class_links <- html_nodes(read_html(subDF$url[i]), 'a')
  #turn links to text
  class_list <- html_text(class_links)
  class_url <- html_attr(class_links, 'href')
  classDF <- data.frame(list=class_list, url=class_url)
  
  #only keep links for classes, each subject has 
  #classes starting in a different position
  classDF <- classDF %>% filter(str_detect(list, paste0(subDF$sub[i],'-')))
  #now build class dataframe with sub,number,name,url - we'll get the
  #other details on the next scrape
  
  #We'll split on 1st space, discard everything after it and use
  #what's before it to build the required DF
  classDF <- separate(classDF, list, into=c("id", "name"),sep=" ",extra="merge")
  
  #two theater classes have typos -THE-###
  #this is solely dealing with that
  classDF$id <- str_replace(classDF$id, "-THE", "THE")

  #back to normal  
  classDF <- separate(classDF, id, into=c("sub", "number"), sep="-")
  
  #the id field has the last part of the new url, we need the 
  #subject url with the course level (100,200,etc) then id
  classDF <- mutate(classDF, url=paste0(base_url,url))
  
  #several class names have '\n' in them, let's remove that now
  classDF <- mutate(classDF, name=str_replace_all(name, '\n',' '))
  
  return(classDF)
}

classes <- map_dfr(1:length(subDF$sub), get_class_list)

