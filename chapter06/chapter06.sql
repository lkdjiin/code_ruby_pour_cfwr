-- Un article en base de données
select * from articles where id = 1;


-- Un user en base de données
select * from users where id = 1;

-- La base de données pour ce chapitre
CREATE TABLE articles(id INTEGER PRIMARY KEY, name TEXT, quantity INTEGER);
INSERT INTO articles values(NULL, 'Tomate', 7);
INSERT INTO articles values(NULL, 'Pomme', 12);
INSERT INTO articles values(NULL, 'Courgette', 35);
INSERT INTO articles values(NULL, 'Fleur', 1);


