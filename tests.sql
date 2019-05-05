DROP FUNCTION IF EXISTS getUtilisateurs CASCADE;
DROP FUNCTION IF EXISTS getUtilisateursAge CASCADE;
DROP FUNCTION IF EXISTS moyenneDonateursMontant CASCADE;
DROP FUNCTION IF EXISTS newUtilisateurs CASCADE;
DROP FUNCTION IF EXISTS getBeneficiairesProjet CASCADE;
DROP FUNCTION IF EXISTS totalDons CASCADE;
DROP FUNCTION IF EXISTS don CASCADE;
DROP FUNCTION IF EXISTS CreerInitiateur CASCADE;
DROP FUNCTION IF EXISTS CreerInitiateurAvecDescr CASCADE;
DROP FUNCTION IF EXISTS CreerProjet CASCADE;
DROP FUNCTION IF EXISTS InitierProjet CASCADE;
DROP FUNCTION IF EXISTS TerminerProjet CASCADE;
DROP FUNCTION IF EXISTS testProjectLifeCycle CASCADE;
DROP FUNCTION IF EXISTS aDejaProjetActif CASCADE;
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

CREATE OR REPLACE FUNCTION getBeneficiairesProjet(idProj projets.id_projet%TYPE) 
RETURNS SETOF beneficiaires AS $$
SELECT * FROM beneficiaires
WHERE id_projet = idProj;
$$ LANGUAGE SQL;

--fonction qui renvoie la moyenne des dons faites par un utlisateurs
CREATE OR REPLACE FUNCTION moyenneDonateursMontant (uid donateurs.id_utilisateur%TYPE) 
RETURNS DECIMAL(4,2) AS $$ 
DECLARE 
ligne RECORD;
q donateurs.montant%TYPE := 0;
i INTEGER := 0 ; 
BEGIN 
FOR ligne IN SELECT montant FROM donateurs WHERE id_donateur = uid 
LOOP
	q = q + ligne.montant; 
	i := i + 1 ;
END LOOP;
IF i = 0 
	THEN RETURN 0;
END IF;
RETURN (q :: DECIMAL / i) :: DECIMAL(4,2); 
END;
$$ LANGUAGE plpgsql;

--Fonction qui renvoie le montant total donné par un utilisateur
CREATE OR REPLACE FUNCTION totalDons (uid donateurs.id_utilisateur%TYPE) 
RETURNS INTEGER AS $$ 
BEGIN
RETURN (SELECT SUM (montant)
		AS montant_total
		FROM donateurs
		WHERE donateurs.id_utilisateur = uid);
END;
$$ LANGUAGE plpgsql;

--Fonction qui renvoie le montant total donné par un utilisateur sur un projet
CREATE OR REPLACE FUNCTION totalDons (uid donateurs.id_utilisateur%TYPE, projid donateurs.id_projet%TYPE) 
RETURNS INTEGER AS $$ 
BEGIN
RETURN (SELECT SUM (montant)
		AS montant_total 
		FROM donateurs
		WHERE (donateurs.id_utilisateur = uid) AND (donateurs.id_projet = projid));
END;
$$ LANGUAGE plpgsql;

--fonction qui fait un don
CREATE OR REPLACE FUNCTION don (uid donateurs.id_utilisateur%TYPE, projid donateurs.id_projet%TYPE, donnation INTEGER)
RETURNS INTEGER AS $$

BEGIN
	
	UPDATE projets
	SET montant_actuel = donnation + montant_actuel
	WHERE id_projet = projid;

	UPDATE donateurs
	SET montant = donnation + montant
	WHERE uid = donateurs.id_utilisateur AND id_projet = projid;

	PERFORM update_date_connexion(uid);
	PERFORM update_date_dernier_don(projid); 
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--fonction qui termine un projet 
CREATE OR REPLACE FUNCTION TerminerProjet(uid utilisateurs.id_utilisateur%TYPE, pid projets.id_projet%TYPE)
RETURNS BOOLEAN AS $$
BEGIN
	IF EXISTS (select * from initiateurs where initiateurs.id_utilisateur = uid and initiateurs.id_projet = pid)
	THEN
		IF(SELECT verification_montant_base(pid) = TRUE) OR (SELECT verification_date_limite_projet(pid) = TRUE)
			THEN update projets
		   		set actif=false
		 		where id_projet = pid;
				RETURN TRUE;
			ELSE RAISE 'Le montant du projet n a pas encore atteint le but requis, utilisez TerminerProjetForce si vous êtes sur de vous';
		END IF;
	ELSE RAISE 'Identifiant de l initiateur non trouvé, TRANSACTION ANNULEE';
	END IF;
	RETURN FALSE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CreerInitiateur(uid utilisateurs.id_utilisateur%TYPE, pid projets.id_projet%TYPE)
RETURNS INTEGER AS $$ 
BEGIN
	INSERT INTO initiateurs (id_utilisateur, id_projet)
	VALUES(uid, pid);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION CreerInitiateurAvecDescr(uid utilisateurs.id_utilisateur%TYPE, pid projets.id_projet%TYPE, description VARCHAR(255))
RETURNS INTEGER AS $$ 
BEGIN
	INSERT INTO initiateurs (id_utilisateur, id_projet, descr)
	VALUES(uid, pid, description);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION aDejaProjetActif(uid initiateurs.id_utilisateur%TYPE)
RETURNS BOOLEAN AS $$
BEGIN
	RETURN EXISTS(SELECT id_utilisateur FROM initiateurs, projets WHERE id_utilisateur = uid AND initiateurs.id_projet = projets.id_projet AND projets.actif = true);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION CreerProjet(nomProjet projets.nom%TYPE, montantBase projets.montant_base%TYPE, montantMax projets.montant_max%TYPE, descriptionProjet projets.descr%TYPE, deadline projets.date_limite%TYPE)
RETURNS INTEGER AS $$ 
--DECLARE
--ligne RECORD;
--i INTEGER :=0;
BEGIN
	INSERT INTO projets (nom, montant_base, montant_max, descr, date_limite)
	VALUES(nomProjet, montantBase, montantMax, descriptionProjet, deadline);
	RETURN ligne.id_projet;
END;
$$ LANGUAGE plpgsql;

--Fonction pour initier un projet
CREATE OR REPLACE FUNCTION InitierProjet(uid utilisateurs.id_utilisateur%TYPE, nomProjet projets.nom%TYPE, montantBase projets.montant_base%TYPE, montantMax projets.montant_max%TYPE, descriptionProjet projets.descr%TYPE, deadline projets.date_limite%TYPE)
RETURNS BOOLEAN AS $$
DECLARE
i INTEGER :=0;
BEGIN
	IF aDejaProjetActif(uid) THEN	
		RETURN FALSE;
	ELSE
		PERFORM CreerProjet(nomProjet, montantBase, montantMax, descriptionProjet, deadline); 
		i := (SELECT MAX(id_projet) FROM projets);
		PERFORM CreerInitiateur(uid, i );
		RETURN TRUE;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION testProjectLifeCycle()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'herb@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'herb@gmail.com');
	RETURN InitierProjet(i, 'mon nouveau groupe trop bien fait une tournee', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	
END;
$$ LANGUAGE plpgsql;
-- -- Partie remplissage des tables

-- SELECT newUtilisateurs('Bernard' :: VARCHAR,'Jp':: VARCHAR,59, '2 rue imo':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
-- SELECT newUtilisateurs('Paul' :: VARCHAR,'a':: VARCHAR,57, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
-- SELECT newUtilisateurs('Luc' :: VARCHAR,'Juzl':: VARCHAR,45, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
-- SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
-- SELECT newUtilisateurs('Hector' :: VARCHAR,'rsgrdg':: VARCHAR,18, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
-- SELECT newUtilisateurs('Auscour' :: VARCHAR,'jtfj':: VARCHAR,83, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
-- SELECT newUtilisateurs('Vador' :: VARCHAR,'drg':: VARCHAR,47, '2 rue du sae':: VARCHAR,'bebert@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);

--INSERT INTO projets (nom, montant_base, montant_max, descr, date_limite, actif) 
--VALUES ('Dudet', 1000, 25000, 'lautre super projet', CURRENT_TIMESTAMP :: DATE, True);

-- INSERT INTO initiateurs (id_utilisateur, id_projet, descr, fiabilite) 
-- VALUES (1,1, 'coucou',5);

-- INSERT INTO beneficiaires (id_utilisateur, id_projet, role_projet, montant) 
-- VALUES (1,1, 'batteur',50);

--INSERT INTO donateurs (id_utilisateur, id_projet, montant, niveau) 
-- VALUES (1,1, 50,5);

-- INSERT INTO log_utilisateurs (new_value, date_action, categorie) 
-- VALUES ('CREATION dun log',CURRENT_TIMESTAMP,'CREATION');

-- INSERT INTO log_projets (new_value, date_action, categorie) 
-- VALUES ('CREATION dun log',CURRENT_TIMESTAMP,'CREATION');

-- Partie test
--SELECT getUtilisateurs();
--SELECT getUtilisateursAge(15);
--SELECT moyenneDonateursMontant(1);
--SELECT totalDons(1);

--SELECT totalDons(1,1);

--SELECT don (1, 1, 75);


SELECT testProjectLifeCycle();






