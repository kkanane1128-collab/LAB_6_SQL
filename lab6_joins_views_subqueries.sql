
mysql> USE bibliotheque;
Database changed
mysql> SELECT e.id, a.nom, e.date_debut
    -> FROM emprunt e
    -> INNER JOIN abonne a
    ->   ON e.abonne_id = a.id;
+----+-------+------------+
| id | nom   | date_debut |
+----+-------+------------+
|  2 | Karim | 2025-06-18 |
|  3 | Karim | 2025-06-18 |
|  4 | Samir | 2025-06-19 |
+----+-------+------------+
3 rows in set (0.00 sec)

mysql> SELECT o.titre, MAX(e.date_debut) AS dernier_emprunt
    -> FROM ouvrage o
    -> LEFT JOIN emprunt e
    ->   ON e.ouvrage_id = o.id
    -> GROUP BY o.id, o.titre;
+---------------------+-----------------+
| titre               | dernier_emprunt |
+---------------------+-----------------+
| Les Misérables      | NULL            |
| 1984                | 2025-06-18      |
| Pride and Prejudice | 2025-06-19      |
| Les Misérables      | NULL            |
| 1984                | NULL            |
| Pride and Prejudice | NULL            |
+---------------------+-----------------+
6 rows in set (0.00 sec)

mysql> SELECT a.nom AS abonne, au.nom AS auteur
    -> FROM abonne a
    -> CROSS JOIN auteur au;
+--------+---------------+
| abonne | auteur        |
+--------+---------------+
| Samir  | Victor Hugo   |
| Karim  | Victor Hugo   |
| Samir  | George Orwell |
| Karim  | George Orwell |
| Samir  | Jane Austen   |
| Karim  | Jane Austen   |
| Samir  | Victor Hugo   |
| Karim  | Victor Hugo   |
| Samir  | George Orwell |
| Karim  | George Orwell |
| Samir  | Jane Austen   |
| Karim  | Jane Austen   |
+--------+---------------+
12 rows in set (0.00 sec)

mysql> CREATE VIEW vue_emprunts_par_abonne AS
    -> SELECT a.id, a.nom, COUNT(e.id) AS total_emprunts
    -> FROM abonne a
    -> LEFT JOIN emprunt e
    ->   ON e.abonne_id = a.id
    -> GROUP BY a.id, a.nom;
Query OK, 0 rows affected (0.02 sec)

mysql> SELECT *
    -> FROM vue_emprunts_par_abonne
    -> WHERE total_emprunts > 5;
Empty set (0.00 sec)

mysql> SELECT a.nom,
    ->   (SELECT o.titre
    ->    FROM emprunt e2
    ->    JOIN ouvrage o ON e2.ouvrage_id = o.id
    ->    WHERE e2.abonne_id = a.id
    ->    ORDER BY e2.date_debut
    ->    LIMIT 1
    ->   ) AS premier_titre
    -> FROM abonne a;
+-------+---------------------+
| nom   | premier_titre       |
+-------+---------------------+
| Karim | 1984                |
| Samir | Pride and Prejudice |
+-------+---------------------+
2 rows in set (0.00 sec)

mysql> SELECT nom, email
    -> FROM abonne
    -> WHERE id IN (
    ->   SELECT abonne_id
    ->   FROM emprunt
    ->   GROUP BY abonne_id
    ->   HAVING COUNT(*) > 3
    -> );
Empty set (0.00 sec)

mysql> SELECT a.nom,
    ->   (SELECT o.titre
    ->    FROM emprunt e2
    ->    JOIN ouvrage o ON e2.ouvrage_id = o.id
    ->    WHERE e2.abonne_id = a.id
    ->    ORDER BY e2.date_debut
    ->    LIMIT 1
    ->   ) AS premier_titre
    -> FROM abonne a;
+-------+---------------------+
| nom   | premier_titre       |
+-------+---------------------+
| Karim | 1984                |
| Samir | Pride and Prejudice |
+-------+---------------------+
2 rows in set (0.00 sec)

mysql> CREATE VIEW vue_emprunts_mensuels AS
    -> SELECT
    ->   YEAR(date_debut) AS annee,
    ->   MONTH(date_debut) AS mois,
    ->   COUNT(*) AS total_emprunts
    -> FROM emprunt
    -> GROUP BY annee, mois;
ERROR 1050 (42S01): Table 'vue_emprunts_mensuels' already exists
mysql> SELECT v.annee, v.mois, v.total_emprunts
    -> FROM vue_emprunts_mensuels v
    -> WHERE v.total_emprunts = (
    ->   SELECT MAX(total_emprunts)
    ->   FROM vue_emprunts_mensuels
    ->   WHERE annee = v.annee
    -> );
+-------+------+----------------+
| annee | mois | total_emprunts |
+-------+------+----------------+
|  2025 |    6 |              3 |
+-------+------+----------------+
1 row in set (0.00 sec)

mysql> SELECT au.nom
    -> FROM auteur au
    -> LEFT JOIN ouvrage o
    ->   ON au.id = o.auteur_id
    -> WHERE o.id IS NULL;
+---------------+
| nom           |
+---------------+
| Victor Hugo   |
| George Orwell |
| Jane Austen   |
+---------------+
3 rows in set (0.00 sec)

mysql> CREATE VIEW vue_abonnes_actifs_mensuels AS
    -> SELECT
    ->   YEAR(date_debut) AS annee,
    ->   MONTH(date_debut) AS mois,
    ->   COUNT(DISTINCT abonne_id) AS nb_abonnes_actifs
    -> FROM emprunt
    -> GROUP BY annee, mois
    -> ORDER BY annee, mois;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT o.titre,
    -> (SELECT a.nom
    -> FROM emprunt e
    -> JOIN abonne a ON e.abonne_id = a.id
    -> WHERE e.ouvrage_id = o.id
    -> ORDER BY e.date_debut DESC
    -> LIMIT 1
    -> ) AS dernier_emprunteur
    -> FROM ouvrage o;
+---------------------+--------------------+
| titre               | dernier_emprunteur |
+---------------------+--------------------+
| Les Misérables      | NULL               |
| 1984                | Karim              |
| Pride and Prejudice | Samir              |
| Les Misérables      | NULL               |
| 1984                | NULL               |
| Pride and Prejudice | NULL               |
+---------------------+--------------------+
6 rows in set (0.00 sec)

mysql>