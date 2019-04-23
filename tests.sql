DROP FUNCTION IF EXISTS getUtilisateurs CASCADE;
DROP FUNCTION IF EXISTS getUtilisateursAge CASCADE;
DROP FUNCTION IF EXISTS moyenneDonateursMontant CASCADE;
DROP FUNCTION IF EXISTS newUtilisateurs CASCADE;

-- Partie fonctions

--fonction qui renvoie tous les utilisateurs 
CREATE OR REPLACE FUNCTION getUtilisateurs() 
RETURNS SETOF utilisateurs AS $$ 
SELECT * FROM utilisateurs;
$$ LANGUAGE SQL;

--fonction qui ajoute des utilisateurs dans la table utilisateurs
CREATE OR REPLACE FUNCTION newUtilisateurs(unom utilisateurs.nom%TYPE, uprenom utilisateurs.prenom%TYPE, uage utilisateurs.age%TYPE, uadresse utilisateurs.adresse%TYPE, umail utilisateurs.mail%TYPE, univeau_global utilisateurs.niveau_global%TYPE, uactif utilisateurs.actif%TYPE, udate_inscription utilisateurs.date_inscription%TYPE) 
RETURNS SETOF utilisateurs AS $$
INSERT INTO utilisateurs (nom, prenom, age, adresse, mail, niveau_global, actif, date_inscription) 
VALUES (unom, uprenom, uage, uadresse, umail, univeau_global, uactif, udate_inscription);
SELECT getUtilisateurs();
$$ LANGUAGE SQL;

--fonction qui renvoie tous les utilisateurs plus vieux que "vieux"
CREATE OR REPLACE FUNCTION getUtilisateursAge(vieux int) 
RETURNS SETOF utilisateurs AS $$ 
SELECT * FROM utilisateurs WHERE age > vieux;
$$ LANGUAGE SQL;

--fonction qui renvoie la moyenne des dons faites par un utlisateurs
CREATE OR REPLACE FUNCTION moyenneDonateursMontant (uid donateurs.id_utilisateur%TYPE) 
RETURNS DECIMAL(4,2) AS $$ 
DECLARE 
ligne RECORD;
q donateurs.montant%TYPE := 0;
i INTEGER := 0 ; 
BEGIN FOR ligne IN SELECT montant FROM donateurs WHERE id_donateur = uid 
LOOP
q = q + ligne.montant; 
i := i + 1 ;
END LOOP;
IF i = 0 THEN RETURN 0;
END IF;
RETURN (q :: DECIMAL / i) :: DECIMAL(4,2); 
END;
$$ LANGUAGE plpgsql;

-- Partie remplissage des tables

SELECT newUtilisateurs('Bernard' :: VARCHAR,'Jp':: VARCHAR,59, '2 rue imo':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Paul' :: VARCHAR,'a':: VARCHAR,57, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Luc' :: VARCHAR,'Juzl':: VARCHAR,45, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Hector' :: VARCHAR,'rsgrdg':: VARCHAR,18, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Auscour' :: VARCHAR,'jtfj':: VARCHAR,83, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Vador' :: VARCHAR,'drg':: VARCHAR,47, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);

INSERT INTO projets (nom, montant_base, montant_max, descr, date_limite, actif) 
VALUES ('Duval',1000,25000,'mon super projet', CURRENT_TIMESTAMP, True);

INSERT INTO initiateurs (id_utilisateur, id_projet, descr, fiabilite) 
VALUES (1,1, 'coucou',5);

INSERT INTO beneficiaires (id_utilisateur, id_projet, role_projet, montant) 
VALUES (1,1, 'batteur',50);

INSERT INTO donateurs (id_utilisateur, id_projet, montant, niveau) 
VALUES (1,1, 50,5);

INSERT INTO log_utilisateurs (new_value, date_action, categorie) 
VALUES ('CREATION dun log',CURRENT_TIMESTAMP,'CREATION');

INSERT INTO log_projets (new_value, date_action, categorie) 
VALUES ('CREATION dun log',CURRENT_TIMESTAMP,'CREATION');

-- Partie test
SELECT getUtilisateurs();
SELECT getUtilisateursAge(15);
SELECT moyenneDonateursMontant(1);