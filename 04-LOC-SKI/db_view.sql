use loc_ski;

-- Liste des clients (toutes les informations) dont le nom commence par un D
SELECT clients.noCli AS noCli, clients.nom AS Nom, clients.prenom AS Prenom, clients.adresse AS Adresse, clients.cpo AS 'Code Postal', clients.ville AS Ville
FROM Clients
WHERE clients.nom LIKE 'D%';

-- Nom et prénom de tous les clients
SELECT clients.nom AS Nom, clients.prenom AS Prenom
FROM Clients;

-- Liste des fiches (n°, état) pour les clients (nom, prénom) qui habitent en Loire Atlantique (44)
SELECT f.noFic AS noFic, f.etat AS 'État', clients.nom AS Nom, clients.prenom AS Prenom
FROM Clients
INNER JOIN fiches f ON f.noCli = clients.noCli
WHERE clients.cpo LIKE '44%';

-- Détail de la fiche n°1002

SELECT lF.noFic AS noFic, c.nom AS Nom, c.prenom AS 'Prénom', lF.refart AS refart, a.designation AS designation, lF.depart AS depart, lF.retour AS retour, t.prixJour as 'Prix Jour', ((SELECT DATEDIFF(IF(lF.retour IS NULL,NOW(),lF.retour), lF.depart)+1) * t.prixJour )AS montant
FROM fiches f 
INNER JOIN clients c ON c.noCli = f.noCli
INNER JOIN lignesFic lF ON lF.noFic = f.noFic
INNER JOIN articles a ON a.refart = lF.refart
INNER JOIN categories cat ON cat.codeCate = a.codeCate
INNER JOIN grilleTarifs gT ON gT.codeCate = cat.codeCate
INNER JOIN tarifs t ON t.codeTarif = gT.codeTarif
WHERE lF.noFic LIKE '1002'
GROUP BY lF.refart

;


-- Prix journalier moyen de location par gamme
SELECT g.libelle AS Gamme, AVG(t.prixJour) AS 'tarif journalier moyen'
FROM tarifs t
INNER JOIN grilleTarifs gT ON gT.codeTarif = t.codeTarif
INNER JOIN gammes g ON g.codeGam = gT.codeGam
GROUP BY g.codeGam;

-- Détail de la fiche n°1002 avec Total

SELECT lF.noFic AS noFic, c.nom AS Nom, c.prenom AS 'Prénom', lF.refart AS refart, a.designation AS designation, lF.depart AS depart, lF.retour AS retour, t.prixJour as 'Prix Jour', ((SELECT DATEDIFF(IF(lF.retour IS NULL,NOW(),lF.retour), lF.depart)+1) * t.prixJour )AS montant, 200

-- SUM(( DATEDIFF(IF(lF.retour IS NULL,NOW(),lF.retour), lF.depart)+1) * t.prixJour ) 
AS Total
FROM fiches f 
INNER JOIN clients c ON c.noCli = f.noCli
INNER JOIN lignesFic lF ON lF.noFic = f.noFic
INNER JOIN articles a ON a.refart = lF.refart
INNER JOIN categories cat ON cat.codeCate = a.codeCate
INNER JOIN grilleTarifs gT ON gT.codeCate = cat.codeCate
INNER JOIN tarifs t ON t.codeTarif = gT.codeTarif
WHERE lF.noFic LIKE '1002'
GROUP BY lF.refart
;
 
-- Grille des tarifs
SELECT cat.libelle as libelle, g.libelle as LibelleGamme, t.libelle as LibelleTarifs, t.prixJour AS prixJour
FROM grilleTarifs gT 
INNER JOIN tarifs t ON t.codeTarif= gT.codeTarif
INNER JOIN gammes g ON g.codeGam = gT.codeGam
INNER JOIN categories cat ON cat.codeCate = gT.codeCate
ORDER BY g.codeGam;

-- Liste des location de la categorie Surf 
SELECT a.refart AS 'Ref. Article', a.designation AS 'Désignation', COUNT(codeCate) AS nbLocation
FROM articles a
WHERE a.refart like 'S%'
GROUP BY a.refart;

-- Calcul du nombre moyen d’articles loués par fiche de location 

-- Pas encore bon
SELECT (SELECT SUM(lF.noLig) AS NbMoyen
FROM lignesFic lF )/COUNT(lF.noFic) 
FROM lignesFic lF 





