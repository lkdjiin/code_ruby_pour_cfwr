--
CREATE TABLE articles(id INTEGER PRIMARY KEY, name TEXT, quantity INTEGER);

--
INSERT INTO articles values('Tomates', 7);

--
INSERT INTO articles values(NULL, 'Tomates', 7);

--
INSERT INTO articles(name, quantity) values('Pommes', 12);

--
select * from articles;

--
.headers on
select * from articles;

--
.mode line
select * from articles;

--
.mode column
select * from articles;

--
.headers on
.mode column
select * from articles;

--
.headers on
.mode column
.width -5 5 -5
select * from articles;
