library(rvest)
library(stringr)
library(dplyr)
library(purrr)
library(tidyr)

#url for courses in catalog
base_url <- "http://collegeofidaho.smartcatalogiq.com"
base_url_ext <- "/en/current/Undergraduate-Catalog/PEAK-Minors/"

base_html <- read_html(paste0(base_url,base_url_ext))
#extract links from base page
minorLinks <- html_nodes(base_html, 'a')
#convert links to text
minorText <- html_text(subjectLinks)
minor_url <- html_attr(minorLinks, 'href')[35:97]
#pick out what corresponds to subject list
#we now have subject codes and names
minorText <- minorText[35:97]

minorDF <- data.frame(Minor = minorText)

#get url for subject, for each row in subDF
#subDF <-subDF %>% mutate(url= paste0(base_url,base_url_ext,'/',sub,'-',str_replace_all(subject,' ','-')))
minorDF <- mutate(minorDF, url=paste0(base_url,minor_url))


get_class_list <- function(i){
  if(i==12){
    return(data.frame(Minor=minorDF$Minor[i], sub = "", num = "", url=""))
  }
  
  #get list of links on subject page
  class_links <- html_nodes(read_html(minorDF$url[i]), 'a')
  #turn links to text
  class_list <- html_text(class_links)
  class_url <- html_attr(class_links, 'href')
  classDF <- data.frame(Minor = rep(minorDF$Minor[i], length(class_list)), list=class_list, url=class_url)
  
  #only keep links for classes, each subject has 
  #classes starting in a different position
  classDF <- classDF %>% filter(str_detect(list, "[:upper:]{2,}-[:digit:]+"))
  
  #two theater classes have typos -THE-###
  #this is solely dealing with that
  classDF$list <- str_replace(classDF$list, "-THE", "THE")

  #back to normal  
  classDF <- separate(classDF, list, into=c("sub", "number"), sep="-")

  #the id field has the last part of the new url, we need the 
  #subject url with the course level (100,200,etc) then id
  classDF <- mutate(classDF,url=paste0(base_url,url))
 
  #for test/debug 
print(i)
  return(classDF)
}

classes <- map_dfr(1:length(minorDF$Minor), get_class_list)

