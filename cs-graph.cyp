CREATE (:Course {name:"Intro. CS", number:150, subject:"CSC", credits:3})
CREATE (:Course {name:"Data Structures", number:152, subject:"CSC", credits:4})
CREATE (:Course {name:"Applied Databases", number:270, subject:"CSC", credits:3})
CREATE (:Course {name:"Prog. Languages", number:235, subject:"CSC", credits:3})
CREATE (:Course {name:"Architecture", number:160, subject:"CSC", credits:3})
CREATE (:Course {name:"Data Visualization", number:285, subject:"CSC", credits:3})
CREATE (:Course {name:"Algorithms", number:340, subject:"CSC", credits:3})
CREATE (:Course {name:"Automata Theory", number:350, subject:"CSC", credits:3})
CREATE (:Course {name:"Numerical Computation", number:455, subject:"CSC", credits:3})
CREATE (:Course {name:"Software Engineering I", number:480, subject:"CSC", credits:3})
CREATE (:Course {name:"Software Engineering II", number:481, subject:"CSC", credits:3})
CREATE (:Course {name:"Topics in CS", number:490, subject:"CSC", credits:3})


MATCH (p:Course), (q:Course) WHERE p.number=150 AND q.number=152 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=150 AND q.number=160 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=150 AND q.number=270 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=150 AND q.number=285 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=152 AND q.number=235 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=160 AND q.number=350 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=152 AND q.number=455 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=235  AND q.number=480 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=270 AND q.number=480 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=350 AND q.number=480 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=480 AND q.number=481 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q
MATCH (p:Course), (q:Course) WHERE p.number=152 AND q.number=490 CREATE (p)-[r:Required_By]->(q) RETURN p,r,q

