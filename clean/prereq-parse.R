library(dplyr)
library(stringr)

prereq_parse <- function(classDF){
  #pattern for course specifier MAT-175 or PHY-271L
  course_pattern <- "[:upper:]{3}-[:digit:]{3}[LT]?"
  perm_pattern <- "(Instructor permission)|Permission"
  standing_pattern <- "(Junior)|(Senior)|(Junior or Senior) (S|s)tanding"
  math_placement_pattern <- "Math (P|p)lacement"
  placement_pattern <- "(P|p)lacement"
  
  classDF <- select(classDF, sub, number, prerequisites, corequisites)

  classBlank <- classDF[classDF$prerequisites == "",]
  class0 <- classDF[str_count(classDF$prerequisites, course_pattern)==0,] 
  
  classPR <- anti_join(anti_join(classDF, classBlank),class0)
  
  #build matrix, each row is a course in classPR each column is course in prereq string
  prm <- str_extract_all(classPR$prerequisites, course_pattern, simplify = TRUE)
  prdf <- map_dfr(1:dim(prm)[2], function(x) prdf <- data.frame(id1=paste0(classPR$sub, classPR$number), id2=prm[,x]))
  prdf <- prdf[prdf$id2!="",]
  prdf$id2 <- str_remove(prdf$id2,"-")
  prdf <- arrange(prdf, prdf$id1)
  
  return(prdf)
}

#########################
# notes and work to build
# above function
#########################

sum(str_detect(maps$prerequisites, course_pattern))
#48 of 81 courses mention a course in prereq.
str_count(maps$prerequisites, course_pattern)

maps0 <- maps[str_count(maps$prerequisites, course_pattern)==0,]
# 33 courses without course prereq., of these most are blank or 
# have "Instructor permission"
maps_blankPR <- maps[maps$prerequisites == "",]
# 15 courses have blank prereq. field, several have "corequisites"
# mainly physics labs, and math 312 has "Prerequisites " (no colon)