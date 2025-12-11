mysql> CREATE DATABASE IF NOT EXISTS universite CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
Query OK, 1 row affected, 1 warning (0.01 sec)

mysql> USE universite;
Database changed
mysql> CREATE TABLE ETUDIANT (
    ->     id INT PRIMARY KEY,
    ->     nom VARCHAR(100) NOT NULL,
    ->     email VARCHAR(100) UNIQUE NOT NULL
    -> ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ERROR 1050 (42S01): Table 'etudiant' already exists
mysql> CREATE TABLE PROFESSEUR (
    ->     id INT PRIMARY KEY,
    ->     nom VARCHAR(100) NOT NULL,
    ->     email VARCHAR(100) UNIQUE NOT NULL,
    ->     departement VARCHAR(50)
    -> ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ERROR 1050 (42S01): Table 'professeur' already exists
mysql> CREATE TABLE COURS (
    ->     id INT PRIMARY KEY,
    ->     titre VARCHAR(150) NOT NULL,
    ->     code VARCHAR(10) UNIQUE NOT NULL,
    ->     credits INT NOT NULL
    -> ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ERROR 1050 (42S01): Table 'cours' already exists
mysql> CREATE TABLE ENSEIGNEMENT (
    ->     id INT PRIMARY KEY AUTO_INCREMENT,
    ->     cours_id INT NOT NULL,
    ->     professeur_id INT,
    ->     semestre VARCHAR(20) NOT NULL,
    ->
    ->     UNIQUE KEY uk_enseignement (cours_id, professeur_id, semestre),
    ->
    ->     FOREIGN KEY (cours_id) REFERENCES COURS(id),
    ->     FOREIGN KEY (professeur_id) REFERENCES PROFESSEUR(id)
    ->         ON DELETE SET NULL
    -> ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ERROR 1050 (42S01): Table 'enseignement' already exists
mysql> CREATE TABLE INSCRIPTION (
    ->     id INT PRIMARY KEY AUTO_INCREMENT,
    ->     etudiant_id INT NOT NULL,
    ->     enseignement_id INT NOT NULL,
    ->     date_inscription DATE NOT NULL,
    -> UNIQUE KEY uk_etudiant_enseignement (etudiant_id, enseignement_id),
    -> FOREIGN KEY (etudiant_id) REFERENCES ETUDIANT(id),
    ->     FOREIGN KEY (enseignement_id) REFERENCES ENSEIGNEMENT(id)
    -> ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ERROR 1050 (42S01): Table 'inscription' already exists
mysql> CREATE TABLE EXAMEN (
    ->     id INT PRIMARY KEY AUTO_INCREMENT,
    ->     inscription_id INT UNIQUE NOT NULL,
    ->     date_examen DATE NOT NULL,
    ->     score DECIMAL(4, 2) NOT NULL,
    -> FOREIGN KEY (inscription_id) REFERENCES INSCRIPTION(id),
    -> CHECK (score BETWEEN 0 AND 20)
    -> ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ERROR 1050 (42S01): Table 'examen' already exists
mysql> INSERT INTO PROFESSEUR (id, nom, email, departement) VALUES
    -> (10, 'Dr. Smith', 'smith@univ.fr', 'Informatique'),
    -> (20, 'Dr. Johnson', 'johnson@univ.fr', 'Mathematiques');
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> INSERT INTO COURS (id, titre, code, credits) VALUES
    -> (100, 'Introduction au SQL', 'CS101', 3),
    -> (200, 'Algorithmes avancés', 'CS202', 4),
    -> (300, 'Analyse I', 'MATH100', 3);
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO ETUDIANT (id, nom, email) VALUES
    -> (1, 'Alice', 'alice@etud.fr'),
    -> (2, 'Bob', 'bob@etud.fr');
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> INSERT INTO ENSEIGNEMENT (id, cours_id, professeur_id, semestre) VALUES
    -> (1, 100, 10, 'Automne 2025'),
    -> (2, 300, 20, 'Hiver 2026');
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> INSERT INTO INSCRIPTION (etudiant_id, enseignement_id, date_inscription) VALUES
    -> (1, 1, '2025-09-01'),
    -> (1, 2, '2026-01-10'),
    -> (2, 1, '2025-09-02'),
    -> (2, 2, '2026-01-15');
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO EXAMEN (inscription_id, date_examen, score) VALUES
    -> (1, CURDATE(), 18.5),
    -> (2, CURDATE(), 15.0),
    -> (3, CURDATE(), 12.0),
    -> (4, CURDATE(), 19.5);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> SELECT DISTINCT et.nom
    -> FROM ETUDIANT et
    -> JOIN INSCRIPTION i ON et.id = i.etudiant_id
    -> JOIN ENSEIGNEMENT en ON i.enseignement_id = en.id
    -> JOIN COURS c ON en.cours_id = c.id
    -> WHERE c.code = 'CS101';
+-------+
| nom   |
+-------+
| Alice |
| Bob   |
+-------+
2 rows in set (0.00 sec)

mysql> SELECT nom, email
    -> FROM PROFESSEUR
    -> WHERE departement = 'Informatique';
+-----------+---------------+
| nom       | email         |
+-----------+---------------+
| Dr. Smith | smith@univ.fr |
+-----------+---------------+
1 row in set (0.00 sec)

mysql> SELECT c.titre, en.semestre, i.date_inscription
    -> FROM INSCRIPTION i
    -> JOIN ETUDIANT et ON i.etudiant_id = et.id
    -> JOIN ENSEIGNEMENT en ON i.enseignement_id = en.id
    -> JOIN COURS c ON en.cours_id = c.id
    -> WHERE et.nom = 'Alice'
    -> ORDER BY i.date_inscription DESC;
+---------------------+--------------+------------------+
| titre               | semestre     | date_inscription |
+---------------------+--------------+------------------+
| Analyse I           | Hiver 2026   | 2026-01-10       |
| Introduction au SQL | Automne 2025 | 2025-09-01       |
+---------------------+--------------+------------------+
2 rows in set (0.00 sec)

mysql> -- E.1 : Requête d'inscription détaillée
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT
    ->     et.nom AS nom_etudiant,
    ->     c.titre AS titre_cours,
    ->     en.semestre,
    ->     i.date_inscription
    -> FROM INSCRIPTION i
    -> JOIN ETUDIANT et ON i.etudiant_id = et.id
    -> JOIN ENSEIGNEMENT en ON i.enseignement_id = en.id
    -> JOIN COURS c ON en.cours_id = c.id;
+--------------+---------------------+--------------+------------------+
| nom_etudiant | titre_cours         | semestre     | date_inscription |
+--------------+---------------------+--------------+------------------+
| Alice        | Analyse I           | Hiver 2026   | 2026-01-10       |
| Alice        | Introduction au SQL | Automne 2025 | 2025-09-01       |
| Bob          | Analyse I           | Hiver 2026   | 2026-01-15       |
| Bob          | Introduction au SQL | Automne 2025 | 2025-09-02       |
+--------------+---------------------+--------------+------------------+
4 rows in set (0.00 sec)

mysql> SELECT
    ->     et.nom,
    ->     (
    ->         SELECT COUNT(i.id)
    ->         FROM INSCRIPTION i
    ->         WHERE i.etudiant_id = et.id
    ->     ) AS nb_cours_inscrits
    -> FROM ETUDIANT et;
+-------+-------------------+
| nom   | nb_cours_inscrits |
+-------+-------------------+
| Alice |                 2 |
| Bob   |                 2 |
+-------+-------------------+
2 rows in set (0.00 sec)

mysql> CREATE OR REPLACE VIEW vue_etudiant_charges AS
    -> SELECT
    ->     et.nom AS nom_etudiant,
    ->     COUNT(i.id) AS nb_inscriptions,
    ->     COALESCE(SUM(c.credits), 0) AS somme_credits
    -> FROM ETUDIANT et
    -> LEFT JOIN INSCRIPTION i ON et.id = i.etudiant_id
    -> LEFT JOIN ENSEIGNEMENT en ON i.enseignement_id = en.id
    -> LEFT JOIN COURS c ON en.cours_id = c.id
    -> GROUP BY et.id, et.nom;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT
    ->     c.titre,
    ->     COUNT(i.id) AS nb_inscriptions
    -> FROM COURS c
    -> JOIN ENSEIGNEMENT en ON c.id = en.cours_id
    -> JOIN INSCRIPTION i ON en.id = i.enseignement_id
    -> GROUP BY c.id, c.titre
    -> ORDER BY nb_inscriptions DESC;
+---------------------+-----------------+
| titre               | nb_inscriptions |
+---------------------+-----------------+
| Introduction au SQL |               2 |
| Analyse I           |               2 |
+---------------------+-----------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     c.titre,
    ->     COUNT(i.id) AS nb_inscriptions
    -> FROM COURS c
    -> JOIN ENSEIGNEMENT en ON c.id = en.cours_id
    -> JOIN INSCRIPTION i ON en.id = i.enseignement_id
    -> GROUP BY c.id, c.titre
    -> HAVING COUNT(i.id) > 10;
Empty set (0.00 sec)

mysql> SELECT
    ->     en.semestre,
    ->     ROUND(AVG(ex.score), 2) AS moyenne_score_semestre
    -> FROM ENSEIGNEMENT en
    -> JOIN INSCRIPTION i ON en.id = i.enseignement_id
    -> JOIN EXAMEN ex ON i.id = ex.inscription_id
    -> GROUP BY en.semestre;
+--------------+------------------------+
| semestre     | moyenne_score_semestre |
+--------------+------------------------+
| Automne 2025 |                  15.25 |
| Hiver 2026   |                  17.25 |
+--------------+------------------------+
2 rows in set (0.01 sec)

mysql> ALTER TABLE EXAMEN
    -> ADD COLUMN commentaire TEXT NULL;
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> -- INNER JOIN
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT
    ->     et.nom AS nom_etudiant,
    ->     c.titre AS titre_cours,
    ->     e.date_examen,
    ->     e.score
    -> FROM EXAMEN e
    -> INNER JOIN INSCRIPTION i ON e.inscription_id = i.id
    -> INNER JOIN ETUDIANT et ON i.etudiant_id = et.id
    -> INNER JOIN ENSEIGNEMENT en ON i.enseignement_id = en.id
    -> INNER JOIN COURS c ON en.cours_id = c.id;
+--------------+---------------------+-------------+-------+
| nom_etudiant | titre_cours         | date_examen | score |
+--------------+---------------------+-------------+-------+
| Alice        | Analyse I           | 2025-12-11  | 15.00 |
| Alice        | Introduction au SQL | 2025-12-11  | 18.50 |
| Bob          | Analyse I           | 2025-12-11  | 19.50 |
| Bob          | Introduction au SQL | 2025-12-11  | 12.00 |
+--------------+---------------------+-------------+-------+
4 rows in set (0.00 sec)

mysql> SELECT
    ->     et.nom AS nom_etudiant,
    ->     COALESCE(COUNT(e.id), 0) AS total_examens
    -> FROM ETUDIANT et
    -> LEFT JOIN INSCRIPTION i ON et.id = i.etudiant_id
    -> LEFT JOIN EXAMEN e ON i.id = e.inscription_id
    -> GROUP BY et.id, et.nom;
+--------------+---------------+
| nom_etudiant | total_examens |
+--------------+---------------+
| Alice        |             2 |
| Bob          |             2 |
+--------------+---------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     c.titre AS titre_cours,
    ->     COALESCE(COUNT(DISTINCT i.etudiant_id), 0) AS nb_etudiants_inscrits
    -> FROM INSCRIPTION i
    -> INNER JOIN ENSEIGNEMENT en ON i.enseignement_id = en.id
    -> RIGHT JOIN COURS c ON en.cours_id = c.id
    -> GROUP BY c.id, c.titre;
+---------------------+-----------------------+
| titre_cours         | nb_etudiants_inscrits |
+---------------------+-----------------------+
| Introduction au SQL |                     2 |
| Algorithmes avancés |                     0 |
| Analyse I           |                     2 |
+---------------------+-----------------------+
3 rows in set (0.00 sec)

mysql> SELECT
    ->     et.nom AS nom_etudiant,
    ->     p.nom AS nom_professeur
    -> FROM ETUDIANT et
    -> CROSS JOIN PROFESSEUR p
    -> LIMIT 20;
+--------------+----------------+
| nom_etudiant | nom_professeur |
+--------------+----------------+
| Bob          | Dr. Smith      |
| Alice        | Dr. Smith      |
| Bob          | Dr. Johnson    |
| Alice        | Dr. Johnson    |
+--------------+----------------+
4 rows in set (0.00 sec)

mysql> CREATE OR REPLACE VIEW vue_performances AS
    -> SELECT
    ->     et.id AS etudiant_id,
    ->     et.nom,
    ->     COALESCE(AVG(e.score), 0) AS moyenne_score
    -> FROM ETUDIANT et
    -> LEFT JOIN INSCRIPTION i ON et.id = i.etudiant_id
    -> LEFT JOIN EXAMEN e ON i.id = e.inscription_id
    -> GROUP BY et.id, et.nom;
Query OK, 0 rows affected (0.01 sec)

mysql> WITH top_cours AS (
    ->     SELECT
    ->         c.titre,
    ->         c.credits,
    ->         AVG(e.score) AS moyenne_score_cours
    ->     FROM COURS c
    ->     INNER JOIN ENSEIGNEMENT en ON c.id = en.cours_id
    ->     INNER JOIN INSCRIPTION i ON en.id = i.enseignement_id
    ->     INNER JOIN EXAMEN e ON i.id = e.inscription_id
    ->     GROUP BY c.id, c.titre, c.credits
    ->     ORDER BY moyenne_score_cours DESC
    ->     LIMIT 3
    -> )
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' at line 13
mysql> WITH top_cours AS (
    ->     SELECT
    ->         c.titre,
    ->         c.credits,
    ->         AVG(e.score) AS moyenne_score_cours
    ->     FROM COURS c
    ->     INNER JOIN ENSEIGNEMENT en ON c.id = en.cours_id
    ->     INNER JOIN INSCRIPTION i ON en.id = i.enseignement_id
    ->     INNER JOIN EXAMEN e ON i.id = e.inscription_id
    ->     GROUP BY c.id, c.titre, c.credits
    ->     ORDER BY moyenne_score_cours DESC
    ->     LIMIT 3
    -> )
    -> SELECT
    ->     titre,
    ->     credits,
    ->     moyenne_score_cours
    -> FROM top_cours;
+---------------------+---------+---------------------+
| titre               | credits | moyenne_score_cours |
+---------------------+---------+---------------------+
| Analyse I           |       3 |           17.250000 |
| Introduction au SQL |       3 |           15.250000 |
+---------------------+---------+---------------------+
2 rows in set (0.00 sec)

mysql>