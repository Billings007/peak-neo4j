library(dplyr)
library(stringr)

prereq_parse <- function(classDF){
  #pattern for course specifier MAT-175 or PHY-271L
  course_pattern <- "[:upper:]{3}-[:digit:]{3}[LT]?"
  perm_pattern <- "(Instructor permission)|Permission"
  standing_pattern <- "(Junior)|(Senior)|(Junior or Senior) Standing"
  placement_pattern <- "Math (P|p)lacement"
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