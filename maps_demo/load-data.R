##DB Connection
library(RNeo4j)

#data is already loaded into database using load-data.cypher
gdb <- startGraph("http://localhost:7474/db/data", user="neo4j", password = "maps") #only the password is DB specific here

##Queries

q1<-'LOAD CSV WITH HEADERS FROM "file:///maps_minor_course_nodes.csv" AS course CREATE (:Course {name:course.name, id:course.id,url:course.url,description:course.description, number:course.number, subject:course.sub, minCredits:course.min_credits, maxCredits:course.max_credits})'

q2<-'CREATE INDEX ON :Course(id)'

q3<-'LOAD CSV WITH HEADERS FROM "file:///majors.csv" AS major CREATE (:Major {name:major.name})'

q4<-'CREATE INDEX ON :Major(name)'

q5<-'LOAD CSV WITH HEADERS FROM "file:///majComp-math.csv" AS mc CREATE (:Component {name:mc.name, major:"Mathematics"})'

q6<-'LOAD CSV WITH HEADERS FROM "file:///majComp-mathcs.csv" AS mc CREATE (:Component {name:mc.name, major:"Math/CS"})'

q7<-'LOAD CSV WITH HEADERS FROM "file:///majComp-phys.csv" AS mc CREATE (:Component {name:mc.name, major:"Math/Physics"})'

q8<-'CREATE INDEX ON :Component(name)'

q9<-'MATCH (c:Component), (m:Major) WHERE c.major=m.name MERGE (c)-[r:Part_Of]->(m)'

q10<-'LOAD CSV WITH HEADERS FROM "file:///mathReq.csv" AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component, major:"Mathematics"}) MERGE (c)-[s:Satisfies {type:mmr.type}]->(mc)'

q11<-'LOAD CSV WITH HEADERS FROM "file:///mathcsReq.csv" AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component, major:"Math/CS"}) MERGE (c)-[s:Satisfies {type:mmr.type}]->(mc)'

q12<-'LOAD CSV WITH HEADERS FROM "file:///mathphysReq.csv" AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component, major:"Math/Physics"}) MERGE (c)-[s:Satisfies {type:mmr.type}]->(mc)'

q13<-'LOAD CSV WITH HEADERS FROM "file:///minor-no-lab.csv" AS minor MERGE (c:Course {id:minor.course}) MERGE (m:Minor {name:minor.minor}) MERGE (cluster:Component {name:minor.other, minor:minor.minor}) MERGE (c)-[p:Satisfies {type:minor.type}]->(cluster) MERGE (cluster)-[s:Part_Of]->(m)'

q14<-'CREATE (:Component{name:"Lab", desc: "Misc. Lab requirement for Applied Math, CSD, and Math minors"})'

q15<-'CREATE (:Course {name:"Approved Labs", id:"AppLab"})'

q16<-'MATCH (c:Course{id:"AppLab"}), (l:Component{name:"Lab"}), (m:Minor) WHERE m.name="Mathematics" OR m.name="Applied Math" OR m.name="Computer Studies" MERGE (l)-[:Part_Of]->(m) MERGE (c)-[:Satisfies {type:"option"}]->(l)'

q17<-'LOAD CSV WITH HEADERS FROM "file:///minorPrereq.csv" AS pre MATCH (c:Course), (s:Course) WHERE c.id=pre.id1 AND s.id=pre.id2 MERGE (s)-[:Prerequisite]->(c)'

## Execute Queries

queries <- c(q1,q2,q3,q4,q5,q6,q7,q9,q10,q11,q12,q13,q14,q15,q16,q17) #removed q8 for now, major cores where being combined
library(purrr)
map(queries, function(x) cypher(gdb,x))

