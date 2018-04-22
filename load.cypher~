LOAD CSV WITH HEADERS FROM 'file:///course2.csv' AS course
CREATE (:Course {name:course.name,subject:course.subject,number:course.number})

LOAD CSV WITH HEADERS FROM 'file:///prerequisites.csv' AS pre
MATCH (p:Course),(s:Course) WHERE p.subject=pre.prevSubject AND
    p.number=pre.prevNumber AND s.subject=pre.subSubject AND
    s.number=pre.subNumber
    CREATE (p)-[r:Prerequisite{type:pre.type}]->(s)

MATCH (p:Course)-[r:Prequisites]->(q:Course) RETURN p,r,q