//すべて削除
MATCH (n) DETACH DELETE n;

//Node作成
LOAD CSV WITH HEADERS FROM "file:///contacts.csv" AS row
CREATE (c:Contact {contactId: row.contactId, name: row.name, occupation: row.occupation});

//制限とINDEX
CREATE CONSTRAINT ON (c:Contact) ASSERT c.contactId IS UNIQUE;

//すべてのリレーションをまとめる
//LOAD CSV WITH HEADERS FROM "file:///contact_relations_2.csv" AS row
//MATCH (c:Contact { contactId:row.contactId })
//MATCH (o:Contact { contactId:row.opponentId})
//CREATE (c)-[r:RelationAll {type:row.relation}]->(o)


//動的にリレーション名を付ける
LOAD CSV WITH HEADERS FROM "file:///contact_relations_2.csv" AS row
MATCH (c:Contact { contactId:row.contactId })
MATCH (o:Contact { contactId:row.opponentId})
CALL apoc.create.relationship(c, row.relation, NULL, o) YIELD rel 
RETURN c.name, type(rel), o.name

//最短パス
MATCH (from:Contact { contactId:'10035'}),(to:Contact { contactId:'10006' }) 
WITH from, to 
MATCH p = shortestPath((from)-[*..6]-(to)) 
WHERE NONE(x IN NODES(p) WHERE (x:Supernode)) 
RETURN p 

