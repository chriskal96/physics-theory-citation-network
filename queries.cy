//Load Article 
CREATE CONSTRAINT ON (a:Article) ASSERT a.articleId IS UNIQUE

LOAD CSV FROM 'file:///ArticleNodes.csv' AS row with toInteger(row[0]) as articleId,row[1] as title,toInteger(row[2]) as year,row[3] as journal,row[4] as abstract MERGE (a:Article {articleId:articleId}) SET a.title = title,a.year = year,a.journal = journal,a.abstract = abstract return count(a)

MATCH (a:Article) return a limit 20

//Load Authors
LOAD CSV FROM 'file:///AuthorNodes.csv' AS row with toInteger(row[0]) as author_articleId, row[1] as author_name CREATE(b:Author {author_articleId:author_articleId, author_name:author_name})
MATCH (au:Authors) return a limit 20

//Create relationship between article and author 
MATCH
  (a:Author),
  (b:Article)
WHERE a.author_articleId = b.articleId
CREATE (a)-[rel:WROTE]->(b)
RETURN count(rel)

MATCH (a:Author)-[rel:WROTE]->(b:Article)
RETURN a, rel, b LIMIT 20;

//Create relationship between article and article 

//:auto USING PERIODIC COMMIT 
//LOAD CSV FROM "file:/Citations.csv" AS row FIELDTERMINATOR '\t'
//MATCH (articleid1:Article {id: toInteger(row[0])})
//MATCH (articleid2:Article {id: toInteger(row[1])}) 
//CREATE (articleid1)-[:Cites]->(articleid2)

:auto USING PERIODIC COMMIT 
LOAD CSV FROM 'file:///Citations.csv' AS row
WITH toInteger(row[0]) AS firstId, toInteger(row[1]) AS secondId
MATCH (c:Article { articleId:firstId})
MATCH (a:Article {articleId:secondId})
MERGE (c)-[rel:CITES]->(a)
RETURN count(rel);


MATCH (c:Article)-[rel:CITES]->(a:Article)
RETURN c, rel, a LIMIT 20;

//create a dummy schema
CALL db.schema.visualization()

//Querry 1

MATCH (a:Author) - [rel:WROTE] -> (b:Article) <- [c:CITES] - (n:Article)
        RETURN a.author_name AS author, COUNT(c) AS citations
        ORDER BY citations DESC
        LIMIT 5

//Querry 2
        RETURN a.author_name AS author, COUNT(DISTINCT d) AS collaborations
        ORDER BY collaborations DESC
        LIMIT 5 

//Querry 3
MATCH (a:Author) - [rel:WROTE] -> (b:Article)
        OPTIONAL MATCH (collaborator:Author) - [rel1:WROTE] -> (b:Article)
      WITH a, COUNT(b) AS articles, COUNT(DISTINCT collaborator) AS collaborators
        WHERE collaborators = 1
        RETURN a.author_name as name, articles
        ORDER BY articles DESC
        LIMIT 1

//Querry 4
MATCH (a:Author) - [:WROTE] -> (b:Article)
RETURN a.author_name, count(b) AS articles
ORDER BY articles DESC
LIMIT 1

//Querry 5
MATCH(a:Article) WHERE a.year =1998 AND toLower(a.title) CONTAINS "gravity" RETURN a.journal as Journal,COUNT(a) AS Papers ORDER BY Papers DESC LIMIT 1

//Querry 6
MATCH (a:Article)-[rel:CITES]->(b:Article)
RETURN b.title AS title, COUNT(rel) AS number_of_citations
ORDER BY number_of_citations DESC
LIMIT 5


//Querry 7
CALL db.index.fulltext.createNodeIndex("AbstractTitle", ["Article"], ["title", "abstract"])

CALL db.index.fulltext.queryNodes("AbstractTitle", "holography anti de sitter")
        YIELD node AS article
        MATCH (author:Author)-[:WROTE]->(article)
        RETURN article.title AS article_title, author.author_name as name
        LIMIT 5


//Querry 8
MATCH (a1:Author {author_name: 'C.N. Pope'}),
      (a2:Author {author_name: 'M. Schweda'}),
      p = shortestPath((a1)-[*]-(a2))
 RETURN [n in nodes(p) | n.author_name] AS path, length(p)

//Querry 9
MATCH (a1:Author {author_name: 'C.N. Pope'}),
      (a2:Author {author_name: 'M. Schweda'}),
      p = shortestPath((a1)-[*]-(a2))
 RETURN [n in nodes(p) | n.author_name] AS path, length(p)

//Querry 10
MATCH (a:Author{author_name:"Edward Witten"}),((a)-[:WROTE]->(article:Article)) MATCH p= ShortestPath((article)-[*]-(b:Author)) WHERE length(p) >25 AND a<>b return b.name as author_Name, length(p) as length , article.title as title