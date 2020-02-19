-- SQL REQUESTS --

# Variables
SET @date = '2015-05-28';          -- Date donnée
SET @date_debut = '2015-01-01';    -- Date de début
SET @date_fin = '2015-12-31';      -- Date de fin

# 1. Affiche le salaire, les horaires de travail et les tâches affectés de chaque employé
SELECT e.id 'ID Employé', e.firstname 'Prénom', e.lastname 'Nom', e.salary 'Salaire', p.base_salary 'Salaire (Base)', p.name 'Tâche affecté', s.start_at 'Horaire de début', s.end_at 'Horaire de fin'
FROM employee e
INNER JOIN post p ON e.id_post = p.id
INNER JOIN schedule s ON p.id_schedule = s.id
ORDER BY e.id;

# 2. Affiche les soirées à thème programmé (lieu, réduction éventuel, nombre de personne prévu)
SELECT r.id 'ID Salle', r.name 'Salle', r.entrance_price 'Prix', r.nb_people 'Nb. de personnes', tr.name 'Thème'
FROM room r
INNER JOIN room_theme_room rtr ON r.id = rtr.id_room
INNER JOIN theme_room tr ON rtr.id_theme = tr.id
ORDER BY r.id;

# 3. Affiche l'ensemble des équipements des différentes pièces de la discothèque
SELECT r.id 'ID Salle', r.name 'Salle', g.name 'Nom équipement', rsg.quantity 'Quantité'
FROM room r
INNER JOIN room_salable_gear rsg ON r.id = rsg.id_room
INNER JOIN gear g ON rsg.id_gear = g.id
ORDER BY r.id;

# 4. Affiche le chiffre d'affaire réalisé à une date donnée
SELECT @date 'Date', SUM(CA) 'Chiffre d\'affaire'
FROM(
	SELECT COALESCE(SUM(lr.price), 0) CA FROM leasing_room lr
    WHERE lr.start_at = @date
    UNION ALL
    SELECT COALESCE(SUM(lb.price), 0) CA FROM leasing_building lb
    WHERE lb.start_at = @date
) a;

# 5. Affiche le chiffre d'affaire réalisé pour les soirées à thème à une date donnée
SELECT @date 'Date', SUM(CA) 'Chiffre d\'affaire'
FROM(
	SELECT COALESCE(SUM(lr.price), 0) CA FROM leasing_room lr
    WHERE lr.start_at = @date
    UNION ALL
    SELECT COALESCE(SUM(lb.price), 0) CA FROM leasing_building lb
    WHERE lb.start_at = @date
	UNION ALL
    SELECT COALESCE(SUM(g.price), 0) FROM customer_room cr
    INNER JOIN gear g ON g.id = cr.id_gear
    WHERE cr.buy_at = @date
) a;

# 6. Affiche le chiffre d'affaire réalisé entre deux dates
SELECT @date_debut 'Date de début', @date_fin 'Date de fin', SUM(CA) 'Chiffre d\'affaire'
FROM(
    SELECT COALESCE(SUM(lr.price), 0) CA FROM leasing_room lr
    WHERE lr.start_at BETWEEN @date_debut AND @date_fin
    UNION ALL
    SELECT COALESCE(SUM(lb.price), 0) CA FROM leasing_building lb
    WHERE lb.start_at BETWEEN @date_debut AND @date_fin
) a;

# 7. Affiche le chiffre d'affaire pour les soirée à thèmes entre deux dates
SELECT @date_debut 'Date de début', @date_fin 'Date de fin', SUM(CA) 'Chiffre d\'affaire'
FROM(
    SELECT COALESCE(SUM(lr.price), 0) CA FROM leasing_room lr
    WHERE lr.start_at BETWEEN @date_debut AND @date_fin
    UNION ALL
    SELECT COALESCE(SUM(lb.price), 0) CA FROM leasing_building lb
    WHERE lb.start_at BETWEEN @date_debut AND @date_fin
    UNION ALL
    SELECT COALESCE(SUM(g.price), 0) FROM customer_room cr
    INNER JOIN gear g ON g.id = cr.id_gear
    WHERE cr.buy_at BETWEEN @date_debut AND @date_fin
) a;

# 8. Affiche l'état des finances de la discothèque (la différence de tout ce qu'il y a à payer et les revenus)
SELECT (SELECT COALESCE(SUM(r.entrance_price), 0) FROM customer_room cr
	INNER JOIN room r ON cr.id_room = r.id
	WHERE cr.buy_at BETWEEN @date_debut AND @date_fin)
+ (SELECT COALESCE(SUM(price), 0) FROM leasing_building lb
	WHERE lb.start_at BETWEEN @date_debut AND @date_fin)
+ (SELECT COALESCE(SUM(price), 0) FROM leasing_room lr
	WHERE lr.start_at BETWEEN @date_debut AND @date_fin)
+ (SELECT COALESCE(SUM(g.price), 0) FROM customer_room cr
   INNER JOIN gear g ON g.id = cr.id_gear
   WHERE cr.buy_at BETWEEN @date_debut AND @date_fin)
- ((SELECT COALESCE(SUM(salary * 12), 0) FROM employee e)    -- Différence du salaire des salariés sur une année
+ (SELECT SUM(quantity * price) FROM room_salable_gear rsg WHERE rsg.buy_at BETWEEN @date_debut AND @date_fin)) 'Bénéfice en 2015';

# 9. Affiche la consommation moyenne de l'ensemble des client
SELECT c.id 'ID Client', COALESCE(AVG(lb.price), 0) + COALESCE(AVG(lr.price), 0) 'Consommation moyenne'
FROM customer c
INNER JOIN leasing_building lb ON lb.id_customer = c.id
INNER JOIN leasing_room lr ON lr.id_customer = c.id;

# 10. Affiche la consommation moyenne de l'ensemble des client avec l'entrée
SELECT c.id 'ID Client', COALESCE(AVG(lb.price), 0) + COALESCE(AVG(lr.price), 0) + COALESCE(AVG(r.entrance_price), 0) 'Consommation moyenne'
FROM customer c
INNER JOIN leasing_building lb ON lb.id_customer = c.id
INNER JOIN leasing_room lr ON lr.id_customer = c.id
INNER JOIN customer_room cr ON cr.id_customer = c.id
INNER JOIN room r ON r.id = cr.id_room
GROUP BY c.id;

# 11. Affiche le nombre de personne étant venu à une soirée en particulier ainsi que le nombre de personne mineur, entre 18-25, entre 26-35 et plus vieux que 36 ans
-- SELECT id_room 'ID Salle', COUNT(id_customer) 'Nb. de personnes'
-- SELECT COUNT(*) FROM customer_room cr
-- WHERE date_birth < 18
