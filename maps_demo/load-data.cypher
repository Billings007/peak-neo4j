LOAD CSV WITH HEADERS FROM 'file:///maps_minor_course_nodes.csv' AS course CREATE (:Course {name:course.name, id:course.id,url:course.url,description:course.description, number:course.number, subject:course.sub, minCredits:course.min_credits, maxCredits:course.max_credits})

CREATE INDEX ON :Course(id)

LOAD CSV WITH HEADERS FROM 'file:///majors.csv' AS major CREATE (:Major {name:major.name})

CREATE INDEX ON :Major(name)


LOAD CSV WITH HEADERS FROM 'file:///majComp-math.csv' AS mc CREATE (:Component {name:mc.name, major:"Mathematics"})

LOAD CSV WITH HEADERS FROM 'file:///majComp-mathcs.csv' AS mc CREATE (:Component {name:mc.name, major:"Math/CS"})

LOAD CSV WITH HEADERS FROM 'file:///majComp-phys.csv' AS mc CREATE (:Component {name:mc.name, major:"Math/Physics"})

CREATE INDEX ON :Component(name)

MATCH (c:Component), (m:Major) WHERE c.major=m.name CREATE (c)-[r:Part_Of]->(m)

LOAD CSV WITH HEADERS FROM 'file:///mathReq.csv' AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component}) MERGE (c)-[s:Satisfies {type:mmr.type}]->(mc)

LOAD CSV WITH HEADERS FROM 'file:///mathcsReq.csv' AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component}) MERGE (c)-[s:Satisfies {type:mmr.type}]->(mc)

LOAD CSV WITH HEADERS FROM 'file:///mathphysReq.csv' AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component}) MERGE (c)-[s:Satisfies {type:mmr.type}]->(mc)

LOAD CSV WITH HEADERS FROM 'file:///minor-no-lab.csv' AS minor MERGE (c:Course {id:minor.course}) MERGE (m:Minor {name:minor.minor}) MERGE (cluster:Component {name:minor.other, minor:minor.minor}) MERGE (c)-[p:Satisfies {type:minor.type}]->(cluster) MERGE (cluster)-[s:Part_Of]->(m)

CREATE (:Component{name:"Lab", desc: "Misc. Lab requirement for Applied Math, CSD, and Math minors"})

CREATE (:Course {name:"Approved Labs", id:"AppLab"})

MATCH (c:Course{id:"AppLab"}), (l:Component{name:"Lab"}), (m:Minor) WHERE m.name="Mathematics" OR m.name="Applied Math" OR m.name="Computer Studies" MERGE (l)-[:Part_Of]->(m) MERGE (c)-[:Satisfies {type:"option"}]->(l)

LOAD CSV WITH HEADERS FROM 'file:///minorPrereq.csv' AS pre MATCH (c:Course), (s:Course) WHERE c.id=pre.id1 AND s.id=pre.id2 MERGE (s)-[:Prerequisite]->(c)
