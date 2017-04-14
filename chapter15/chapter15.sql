-- Création d'un utilisateur
create user framework password 'bonjour';

-- Beaucoup de droits
alter user framework with superuser;

-- Création d'une base de données
create database framework_blog owner framework;

-- Création d'une table
create table posts(
  id serial primary key,
  title text,
  content text,
  date timestamp
);

-- Création de deux posts
insert into posts(title, content, date)
values('Bonjour !', 'Premier post avec Postgresql', now());

insert into posts(title, content, date)
values('Hello !', 'In english this time', current_timestamp);

-- Afficher les posts dans Postgresql
select * from posts;
