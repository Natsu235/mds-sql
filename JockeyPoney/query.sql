--
-- 1. Affiche le nombre de courses, jockey, poney et associations jockeyponeycourse
--

SELECT count(*) FROM jockeyponey1.course;
SELECT count(*) FROM jockeyponey1.jockey;
SELECT count(*) FROM jockeyponey1.poney;
SELECT count(*) FROM jockeyponey1.jockeyponeycourse;


--
-- 2. Affiche le(s) jockey(s) (nom, prénom) ayant participé(s) à la course 1
--

SELECT jockey.nom, jockey.prenom
FROM jockeyponeycourse
INNER JOIN jockey ON jockeyponeycourse.id_jockey = jockey.id
WHERE id_course = 1;


--
-- 3. Affiche le(s) poney(s) (id, nom) monté par le jocket 1 (nom, prénom)
--

SELECT p.id AS "ID Poney", p.nom AS "Nom Poney", j.nom AS "Nom Jockey", j.prenom AS "Prénom Jockey"
FROM jockeyponeycourse AS r
INNER JOIN poney AS p ON r.id_poney = p.id
INNER JOIN jockey AS j ON r.id_jockey = j.id
WHERE r.id_jockey = 1;


--
-- 4. Affiche le(s) jockey(s) (nom, prénom) ayant courut avec le poney 1 (nom)
--

SELECT j.nom AS "Nom Jockey", j.prenom AS "Prénom Jockey", p.nom AS "Nom poney" 
FROM jockeyponeycourse AS r
INNER JOIN jockey AS j ON r.id_jockey = j.id
INNER JOIN poney AS p ON r.id_poney = p.id
WHERE r.id_poney=1;


--
-- 5. Affiche le(s) jockey(s) (id, nom, prénom) n'ayant jamais couru
--

SELECT * 
FROM jockey
WHERE id NOT IN(
    SELECT DISTINCT(r.id_jockey)
    FROM jockeyponeycourse AS r
);

--
-- 6. Affiche le(s) poney(s) (id, nom) n'ayant jamais couru
--

SELECT * 
FROM poney
WHERE id NOT IN(
    SELECT DISTINCT(r.id_poney)
    FROM jockeyponeycourse AS r
);


--
-- 7. Affiche le(s) jockey(s) (id, nom, prénom) ayant couru plus de 6 fois
--

SELECT Q1.id, Q1.nom, Q1.prenom
FROM(
    SELECT j.id, j.nom, j.prenom , count(*) AS nb
    FROM jockeyponeycourse as r
    INNER JOIN jockey AS j ON r.id_jockey = j.id 
    GROUP BY (r.id_jockey)
    HAVING nb > 6
) as Q1;


--
-- 8. Affiche le(s) jockey(s) (id, nom, prénom) ayant couru au moins 2 fois avec le même poney (nom)
--

SELECT j.id AS "ID Jockey", j.nom AS "Nom Jockey", j.prenom AS "Prénom Jockey", p.nom AS "Nom Poney"
FROM jockeyponeycourse AS r
INNER JOIN poney AS p ON r.id_poney = p.id
INNER JOIN jockey AS j ON r.id_jockey = j.id  
GROUP BY r.id_jockey, r.id_poney
HAVING COUNT(r.id_poney) >= 2;
