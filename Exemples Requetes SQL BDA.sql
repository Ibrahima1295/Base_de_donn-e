#Interrogation de la base 

                                #Question 1 : Requetes simples

#Lister les regimes qui concerne les travaux
SELECT* FROM regime WHERE Regimeprioritaire="travaux";
#Lister les nombre de place des stationnement par ordre croissant
SELECT* from stationnement order by Nombre_places_réelles;
#Lister les stationnements de type Longitudinal
SELECT* FROM stationnement WHERE Type_de_stationnement="Longitudinal";
# Lister les voies dont on dispose pas les adresses,
SELECT* FROM voie WHERE Nom_voie=" " AND Type_voie=" ";
#Lister les voies qui sont dans le 1er, 18ieme, 19ieme, 20ieme à cause du trafic qui est intense
SELECT* FROM voie WHERE Arrondissement IN ('1', '18', '19'); 
#Lister les types de stationnements dont la surface est compris entre 50m2 et 100m2
SELECT* from stationnement WHERE surface_calculée BETWEEN "50" AND "100";

# les stationnement qui ne présentent ni de signalisation verticale ni horizontale.
SELECT* FROM signalisation WHERE Signalisation_horizontale LIKE "Absente" AND Signalisation_verticale LIKE "Absente";
# les régimes de stationnement à deux roues
SELECT*FROM regime WHERE Regimeparticulier LIKE '2 ROUES'; 

                                  #Question 2 requetes avec jointure

# le nombre de stationnement par arrondissement
SELECT DISTINCT count(Type_de_stationnement) AS nombre_de_stationnement , Arrondissement
FROM voie INNER JOIN stationnement
ON voie.Code_voie= stationnement.Refvoie GROUP BY   Arrondissement;

#Lister les stationnements qui ont une signalisation non conforme
SELECT Type_de_stationnement, Conformite_signalisation FROM stationnement ST INNER JOIN signalisation SI 
ON ST.IDS=SI.Refstationnement WHERE conformite_signalisation LIKE"%Non conforme%";

#Lister les voies qui n'ont pas de stationnement;
SELECT* FROM stationnement ST INNER JOIN voie V ON ST.Refvoie=V.Code_voie WHERE Type_de_stationnement=" ";

#Lister les voies qui ont des stationnements ou le nombre de palce réelles est superieur à 50
SELECT Nom_voie,Type_de_stationnement,Nombre_places_réelles FROM voie V INNER JOIN stationnement ST 
on V.Code_voie=ST.Refvoie WHERE Nombre_places_réelles>50;

#Lister les stationnements qui sont soumis à un régime prioritaire "Mixte"
SELECT Distinct Type_de_stationnement,Regimeprioritaire FROM stationnement ST INNER JOIN soumis S
ON ST.IDS=S.Refstationnement INNER JOIN regime R ON R.IDR=S.Refregime
WHERE Regimeprioritaire LIKE "%Mixte%";

#Lister les voies qui ont des stationnements dont la tarification est inferieur à 4 euros/h
SELECT Nom_voie,Type_voie,Type_de_stationnement,Tarification FROM voie V INNER JOIN stationnement ST
ON ST.Refvoie=V.Code_voie WHERE Tarification<4.00;

#Lister les nombres de places réelles, la tarification des stationnements dont le type de voie est "AVENUE"
SELECT Nombre_places_réelles,Tarification FROM voie V INNER JOIN stationnement ST 
ON ST.Refvoie=V.Code_voie WHERE Type_voie="AVENUE";

##### lister les adresses, les types de stationnements à vehicules electrique
SELECT* FROM voie INNER JOIN stationnement ON Code_voie= Refvoie
INNER JOIN soumis ON IDS=Refstationnement 
INNER JOIN regime ON IDR= Refregime WHERE Regimeprioritaire LIKE'%electriques%';

                               #Question 3 Requetes avec agregats
# 1. Surface moyen des stationnements
SELECT AVG(Surface_calculée) as surfacemoyen FROM stationnement;
# Tarification moyen, max et min  
SELECT AVG(Tarification) AS moytarif FROM stationnement;
SELECT MAX(Tarification) AS tarifmax FROM stationnement;
SELECT Min(Tarification) AS tarifmin FROM stationnement;
# prix stationnement en fonction du type de stationnement et le Nombre de place reelle de stationnement
SELECT count(Type_de_stationnement) ,Type_de_stationnement , Tarification FROM stationnement group BY Tarification;
#quel type de stationnement a plus de places ?
SELECT MAX(Nombre_places_réelles) as Nombre_de_place_maximale FROM stationnement;

                             #Question 4 Requetes imbriquées

#Y-a-t-il un stationnement de type Epi ayant un nombre de place réélles inferieur à tous les stationnements de type Longitudinal?
SELECT* FROM stationnement WHERE Type_de_stationnement LIKE "%Epi%" AND Nombre_places_réelles< ALL
(SELECT Nombre_places_réelles FROM stationnement WHERE Type_de_stationnement LIKE "%Longitudinal%");

#Quels sont les stationnements de type Longitudinal ayant une Surface_calculée inferieur au moins à un stationnements de type bataille
SELECT Type_de_stationnement, ROUND (Surface_calculée) FROM stationnement WHERE Type_de_stationnement LIKE "Longitudinal"AND "Surface_calculée"< ANY
(SELECT Surface_calculée FROM stationnement WHERE Type_de_stationnement LIKE "Bataille");

#Lister les adresses des 10 stationnements qui ont les tarifs les plus chers
SELECT Code_voie, CONCAT(Type_voie, ' ',Nom_voie) AS adresse,Arrondissement FROM voie WHERE Code_voie IN 
(SELECT Refvoie FROM stationnement WHERE Tarification>=4.00 ORDER BY Tarification)
LIMIT 10;

#Les types de stationnement qui ont un régime prioritaire
SELECT type_de_stationnement FROM stationnement st INNER JOIN soumis s ON st.IDS=s.Refstationnement 
INNER JOIN regime r ON s.Refregime=r.IDR WHERE Regimeprioritaire="Ex Autolib' 2 avec bornes de recharge";

#Y'a t-il un type de voie qui n'a pas de stationnement de type"Longitudinale"
SELECT* FROM voie WHERE EXISTS(
SELECT Type_voie FROM voie INNER JOIN stationnement ON stationnement.Refvoie=voie.Code_voie
WHERE stationnement.Type_de_stationnement ="Longitudinal");

#Les types de stationnements ayant le plus nombre de place réelles
SELECT* FROM stationnement GROUP BY Type_de_stationnement
HAVING COUNT(Nombre_places_réelles)=(SELECT MAX(np) AS M FROM (SELECT COUNT(Nombre_places_réelles) AS np
FROM stationnement GROUP BY Nombre_places_réelles) AS Sub);


#Lister les nombres de places réelles, la tarification des stationnements dont le type de voie est "AVENUE"
SELECT Nombre_places_réelles,Tarification FROM voie V INNER JOIN stationnement ST 
ON ST.Refvoie=V.Code_voie WHERE Type_voie="AVENUE";

# les voies sur lesquelles ont peut trouver les stationnement les plus chers
SELECT* FROM voie WHERE Code_voie IN (SELECT Refvoie FROM stationnement WHERE Tarification=4.00);

                               #Mise à Jour de la Base
  #Question1 Requetes d'ajouts
#Ajouter un régime dont le numero(IDR) est 1000, Régimepartuclier "Gratuit" et Régimeprioritaire "Trotinettes"
INSERT into regime VALUES(1000,"Gratuit","Trotinettes");

#Ajouter un régime dont le numéro(IDR) est 1003, Régimeparticulier"Payant" et Régimeprioritaire"PMR" pour les personnes à mobilité réduite
INSERT INTO regime VALUES(1003, "Payant", "PMR");

#Ajouter un stationnement de type Unilateral dont le nombre de place réelles est de 70, tarification 2.10 euros/h
# et de surface de 50m2
INSERT into stationnement VALUES(1001,4434,"Unilateral",70,"2.10",50);

#Ajouter un stationnement interdit de surface 15m2 dans chaque voie pour les secours
INSERT INTO stationnement VALUES(1003,9999,'interdit',0 , 0, 15);

#Question2 Mise à jour des donées
                             
#Supprimer les stationnements dont les voies ont des adresses  manquantes
DELETE FROM voie WHERE Nom_voie= " " AND Type_voie=" ";
#Remplacer les types de voie "BOULEVARD DE", "BOULEVARD DE LA" et "BOULEVARD DE L" par "BOULEVARD"
UPDATE voie SET Type_voie="BOULEVARD" WHERE Type_voie IN ("BOULEVARD DE", "BOULEVARD DE LA", "BOULEVARD DE L");
#Augmenter de 20% la tarification des stationnement dans les voies de type "Boulevard" 
Update stationnement set Tarification=1.20*Tarification WHERE Refvoie IN (SELECT Code_voie FROM voie WHERE Type_voie="Boulevard");

#Reduire la surface de 10m2 et le nombre de place de 5 des stationnement qui se situent dans les "Boulevard"
#pour limiter le deplacement des voitures en centre ville et limiter la pollution
UPDATE stationnement st INNER JOIN voie v ON st.Refvoie=v.Code_voie SET st.`Surface_calculée`=Surface_calculée-5
AND Nombre_places_réelles=Nombre_places_réelles-5 WHERE Type_voie="Boulevard";

#Corriger les signalisations qui presentent des defauts en remplacant Absente par Presente
UPDATE signalisation SET Signalisation_verticale="Absente" and Signalisation_horizontale="Absente"
WHERE Signalisation_verticale= "Presente" and Signalisation_horizontale="Presente";

#Augmenter les nombres de place réelles(5) des stationnements de type "Longitudinal"
UPDATE stationnement SET Nombre_places_réelles=Nombre_places_réelles+5 WHERE Type_de_stationnement="Longitudinal";


               #Langage Controle de données
#CREATE USER Moucharaph
CREATE USER Moucharaph;
#Create User Bouna
CREATE USER Bouna;

#Donner le droit de consultation et de mise a jour de la base à Moucharaph
GRANT SELECT,UPDATE ON stationnement TO Moucharaph;
GRANT SELECT,UPDATE ON voie TO Moucharaph;
GRANT SELECT,UPDATE ON regime TO Moucharaph;
GRANT SELECT,UPDATE ON signalisation TO Moucharaph;
GRANT SELECT,UPDATE ON soumis TO Moucharaph;


#Donner le droit de consultation, d'ajouter et de mise à jour de toutes les tables de la base à l'utilisateur Bouna
GRANT SELECT,INSERT,UPDATE ON stationnement TO Bouna;
GRANT SELECT,INSERT,UPDATE ON voie TO Bouna;
GRANT SELECT,INSERT,UPDATE ON regime TO Bouna;
GRANT SELECT,INSERT,UPDATE ON signalisation TO Bouna;
GRANT SELECT,INSERT,UPDATE ON soumis TO Bouna;

#Supprimer tout droit de suppression, d’insertion et de modification des  tables stationnement et voie de la base aux 2 utilisateurs
REVOKE ALL PRIVILEGES ON stationnement FROM Moucharaph;
REVOKE ALL PRIVILEGES on voie FROM Moucharaph;
REVOKE ALL PRIVILEGES ON stationnement FROM Bouna;
REVOKE ALL PRIVILEGES ON voie from Bouna;

                                     #Interface d’interaction avec la base 
#Controle de données par les vues
#Création d'une vue constituant une restriction de la TABLE  stationnement des voies du 18ieme arrondissement
CREATE VIEW Client_Mairie_18ieme AS
SELECT* FROM stationnement ST INNER JOIN voie V ON ST.Refvoie=V.Code_voie
WHERE Arrondissement LIKE '18' WITH CHECK OPTION;

#Mise à jour Vue Client_Mairie_18ieme
UPDATE Client_Mairie_18ieme
SET  Nom_voie= "Anthoine"
WHERE Nom_voie = "LEIBNIZ";

#Creation d'une Vue des stationnements qui sont en travaux
CREATE VIEW Travaux AS SELECT* FROM regime INNER JOIN soumis ON IDR=Refregime 
INNER JOIN stationnement ON Refstationnement=IDS WHERE Regimeprioritaire="travaux" WITH CHECK OPTION;

# interface utilisateur de stationnement 
CREATE VIEW utilisateur AS SELECT*FROM voie INNER JOIN stationnement 
ON Code_voie=Refvoie WITH check OPTION;

                                   # Requetes Index
EXPLAIN SELECT* FROM voie WHERE Nom_voie="ALBERT";
CREATE INDEX idx_Nom_voie ON voie(Nom_voie);
            



