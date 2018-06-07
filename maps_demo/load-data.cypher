LOAD CSV WITH HEADERS FROM 'file:///maps_course_nodes.csv' AS course CREATE (:Course {name:course.name, id:course.id,url:course.url,description:course.description, number:course.number, subject:course.sub, minCredits:course.min_credits, maxCredits:course.max_credits})

CREATE INDEX ON :Course(id)

LOAD CSV WITH HEADERS FROM 'file:///prerequisite.csv' AS pre MATCH (c:Course), (s:Course) WHERE c.id=pre.id1 AND s.id=pre.id2 CREATE (s)-[:Prerequisite]->(c)

LOAD CSV WITH HEADERS FROM 'file:///majors.csv' AS major CREATE (:Major {name:major.name})

CREATE INDEX ON :Major(name)


LOAD CSV WITH HEADERS FROM 'file:///majComp-math.csv' AS mc CREATE (:Component {name:mc.name, major:"Mathematics"})

LOAD CSV WITH HEADERS FROM 'file:///majComp-mathcs.csv' AS mc CREATE (:Component {name:mc.name, major:"Math/CS"})

LOAD CSV WITH HEADERS FROM 'file:///majComp-phys.csv' AS mc CREATE (:Component {name:mc.name, major:"Math/Physics"})

CREATE INDEX ON :Component(name)

MATCH (c:Component), (m:Major) WHERE c.major=m.name CREATE (c)-[r:Part_Of]->(m)

LOAD CSV WITH HEADERS FROM 'file:///mathReq.csv' AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component}) MERGE (c)-[s:Satifies {type:mmr.type}]->(mc)

LOAD CSV WITH HEADERS FROM 'file:///mathcsReq.csv' AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component}) MERGE (c)-[s:Satifies {type:mmr.type}]->(mc)

LOAD CSV WITH HEADERS FROM 'file:///mathphysReq.csv' AS mmr MERGE (c:Course {id:mmr.course}) MERGE (mc:Component {name:mmr.component}) MERGE (c)-[s:Satifies {type:mmr.type}]->(mc)

