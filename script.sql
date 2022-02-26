CREATE DATABASE Projet_stationnement_Paris;
USE Projet_stationnement_Paris;

CREATE TABLE regime(
IDR INT  Primary Key,
Regimeparticulier VARCHAR(50),
Regimeprioritaire VARCHAR(50)
);

CREATE TABLE voie(
Code_voie      VARCHAR(20)  PRIMARY KEY,
Nom_voie       VARCHAR(25),
Type_voie      VARCHAR(15),
Arrondissement INT NOT NULL
);


CREATE TABLE stationnement(
IDS INT  PRIMARY KEY,
Refvoie VARCHAR(20) ,
Type_de_stationnement VARCHAR(12) NOT NULL,
Nombre_places_réelles INT  NOT NULL,
Tarification          VARCHAR(7) NOT NULL,
Surface_calculée      FLOAT  NOT NULL,
CONSTRAINT Fk1 FOREIGN KEY (Refvoie) REFERENCES voie(Code_voie) 
);


CREATE TABLE signalisation(
Ancien_identifiant VARCHAR(50) PRIMARY KEY,
Refstationnement INT,
Signalisation_horizontale VARCHAR(8),
Signalisation_verticale   VARCHAR(14),
Conformite_signalisation  VARCHAR(15),
CONSTRAINT Fk FOREIGN KEY (Refstationnement) REFERENCES stationnement(IDS) 
); 

CREATE TABLE if not exists soumis(
Refregime      INT,
Refstationnement INT,
CONSTRAINT FK1 PRIMARY KEY(Refregime, Refstationnement),
CONSTRAINT FK2 FOREIGN KEY (Refregime) REFERENCES `regime`(IDR),
CONSTRAINT FK3 FOREIGN KEY (Refstationnement) REFERENCES stationnement(IDS)
);

