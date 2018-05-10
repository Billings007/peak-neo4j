#required libraries
library(dplyr)
library(stringr)

credit_range <- function(cred_string){
  #remove "credit" or "credits"
  cred_num <- str_split(cred_string, "[:blank:]", simplify=TRUE)[1]
  
  if(str_detect(cred_num, '-')){
    cred1 = str_split(cred_num, "-", simplify=TRUE)[1] %>% as.numeric()
    cred2 = str_split(cred_num, "-", simplify=TRUE)[2] %>% as.numeric()
    min_credits=min(cred1,cred2)
    max_credits=max(cred1,cred2)
  }
  else{
    cred = str_extract(cred_num, "[:digit:]") %>% as.numeric()
    min_credits=cred
    max_credits=cred
  }
  
  return(data.frame(min_credits, max_credits))
}

maps_cred_range <- map_dfr(maps$credits, credit_range)
