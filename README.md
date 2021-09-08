# Physics Theory Citation Network

This repository includes an assignment assigned for the cource "Mining Big Datasets" offered by the Master of Science in Business Analytics of the Athens University of Economics and Business. In this assignment given a subset of the high energy physics theory citation network, which contains authors, articles, journals and citations between articles, i will : 

1. Model the data as a property graph by designing the appropriate entities and assigning the relevant labels, types and properties.
2. Create a graph database on Neo4j and load the citation network elements (nodes, edges, attributes).
3. Query the database

## Dataset

The dataset files are:
* [ArticleNodes.csv](https://github.com/chriskal96/physics-theory-citation-network/blob/main/ArticleNodes.csv): Contains info about Article nodes (id, title, year, journal and abstract).
* [AuthorNodes.csv](https://github.com/chriskal96/physics-theory-citation-network/blob/main/AuthorNodes.csv): Contains article id and the name of the author(s).
* [Citations.csv](https://github.com/chriskal96/physics-theory-citation-network/blob/main/Citations.csv): Contains info about citations between articles (articleId,--[Cites]->,articleId).

## Author

<a href="https://github.com/chriskal96">Christos Kallaras</a>
