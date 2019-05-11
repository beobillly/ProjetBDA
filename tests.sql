
DROP FUNCTION IF EXISTS testProjectCreation CASCADE;
DROP FUNCTION IF EXISTS testProjectLifeCycle CASCADE;
DROP FUNCTION IF EXISTS testProjectLifeCycleNotEnoughMoney CASCADE;
DROP FUNCTION IF EXISTS testProjectLifeCycleNotEnoughMoneyForceShutdown CASCADE;
DROP FUNCTION IF EXISTS montantNegatif CASCADE;
DROP FUNCTION IF EXISTS testTropJeune CASCADE;
DROP FUNCTION IF EXISTS testDonNegatif CASCADE;
DROP FUNCTION IF EXISTS testTooMuchMoney CASCADE;
DROP FUNCTION IF EXISTS testDateIncorrecte CASCADE;
DROP FUNCTION IF EXISTS redistribute CASCADE;
-- Partie fonctions

--Teste la creation d'un projet en entier
CREATE OR REPLACE FUNCTION testProjectCreation()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'blu@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'herb@gmail.com');
	RETURN InitierProjet(i, 'mon nouveau groupe trop bien fait une tournee', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	
END;
$$ LANGUAGE plpgsql;

--Teste la vie d'un projet en entier

CREATE OR REPLACE FUNCTION testProjectLifeCycle()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'k@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jjo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'j0jo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'j0jo@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'k@gmail.com'), (SELECT MAX(id_projet) from projets), 2000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'k@gmail.com'), (SELECT MAX(id_projet) from projets), 2000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jjo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	RETURN TerminerProjet(i, (SELECT MAX(id_projet) from projets));
	
END;
$$ LANGUAGE plpgsql;

--Teste la vie d'un projet qui n'a pas assez d'argent

CREATE OR REPLACE FUNCTION testProjectLifeCycleNotEnoughMoney()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'koku@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- 	PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jiji@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'jiji@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'koku@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'koku@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jajo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	RETURN TerminerProjet(i, (SELECT MAX(id_projet) from projets));
	
END;
$$ LANGUAGE plpgsql;


--Teste la vie d'un projet qui n'a pas assez d'argent et qui est fermé de force
CREATE OR REPLACE FUNCTION testProjectLifeCycleNotEnoughMoneyForceShutdown()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisasdasdous' :: VARCHAR,'dsde':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kilo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jfasd' :: VARCHAR,'cocaso':: VARCHAR,56, '70 rue du plankton':: VARCHAR,'jo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- 	PERFORM newUtilisateurs('jf' :: VARCHAR,'codco':: VARCHAR,78, '2 rue du plankton':: VARCHAR,'jiko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'jiko@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	RETURN TerminerProjetForce(i, (SELECT MAX(id_projet) from projets));
	
END;
$$ LANGUAGE plpgsql;
-- -- Partie remplissage des tables

--Teste si on essaye de creer 2 projets
CREATE OR REPLACE FUNCTION test2ProjectCreatedBySamePerson()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kula@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajou@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'j0j9@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'j0j9@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'j0j9@gmail.com');
	RETURN InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	
END;
$$ LANGUAGE plpgsql;


/*
Fonctionnement normal d'un projet avec petites restrictions:
       Un utilisateur créé un projet, il a quelques dons puis décide de créer un autre projet avant que son premier projet soit fini.
       Il constate qu'il ne peut pas et attend que son premier projet se termine puis fini par créer son deuxieme projet.
*/
CREATE OR REPLACE FUNCTION testBehaviour()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kudla@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajouju@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- 	PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kokiku@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'kokiku@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);

	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	BEGIN
		PERFORM InitierProjet(i, 'mon instrument', 3000, 7000, 'un nouveau sax', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	EXCEPTION 
	WHEN others THEN
	
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 4000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	PERFORM TerminerProjet(i, (SELECT MAX(id_projet) from projets));

	RETURN InitierProjet(i, 'mon instrument', 3000, 7000, 'un nouveau sax', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	END;
	
END;
$$ LANGUAGE plpgsql;

--un utilisateur de moins de 18 ans tente de s'inscrire, cela ne marche pas, fin.
CREATE OR REPLACE FUNCTION testTropJeune () 
RETURNS INTEGER AS $$ 
BEGIN
	PERFORM newUtilisateurs('Henri' :: VARCHAR,'Jp':: VARCHAR,12, '2 rue imo':: VARCHAR,'roro@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--Un utilisateur tente de créer un projet avec un solde(montant_base ou monatant max) negatif, cela ne marche pas.
CREATE OR REPLACE FUNCTION montantNegatif () 
RETURNS BOOLEAN AS $$ 
DECLARE
i INTEGER := 0;
BEGIN
	PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kokoko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'kokoko@gmail.com');
	RETURN InitierProjet(i, 'mon disque', -6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
END;
$$ LANGUAGE plpgsql;

--un utlisateur tente de faire un don negatif
CREATE OR REPLACE FUNCTION testDonNegatif () 
RETURNS INTEGER AS $$ 
DECLARE
i INTEGER := 0;
BEGIN
	--PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kakoko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'kakoko@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don(i, (SELECT MAX(id_projet) from projets), -500);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--un utlisateur tente de creer un projet et un autre tente un don plus haut que le max du projet autorisé
CREATE OR REPLACE FUNCTION testTooMuchMoney()
RETURNS INTEGER as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisasdasdous' :: VARCHAR,'dsde':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kiloka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jfasd' :: VARCHAR,'cocaso':: VARCHAR,56, '70 rue du plankton':: VARCHAR,'joka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- 	PERFORM newUtilisateurs('jf' :: VARCHAR,'codco':: VARCHAR,78, '2 rue du plankton':: VARCHAR,'jikoka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'jikoka@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	RETURN don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kiloka@gmail.com'), (SELECT MAX(id_projet) from projets), 300000);
	
END;
$$ LANGUAGE plpgsql;


--un utlisateur tente de creer un projet avec la date de limite  inférieur à la date courante
CREATE OR REPLACE FUNCTION testDateIncorrecte()
RETURNS BOOLEAN AS $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'bludabedibaduba@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'bludabedibaduba@gmail.com');
	RETURN InitierProjet(i, 'mon nouveau groupe trop bien fait une tournee', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2015/07/09', 'yyyy/mm/dd') :: DATE);
END;
$$ LANGUAGE plpgsql;




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
SELECT getUtilisateurs();
SELECT getUtilisateursAge(15);
SELECT moyenneDonateursMontant(1);
SELECT totalDons(1);
SELECT totalDons(1,1);
SELECT don (1, 1, 75);


--Teste la creation d'un projet en entier
SELECT testProjectCreation();

--Teste la vie d'un projet en entier
SELECT testProjectLifeCycle();

--Teste la vie d'un projet qui n'a pas assez d'argent
SELECT testProjectLifeCycleNotEnoughMoney();

--Teste la vie d'un projet qui n'a pas assez d'argent et qui est fermé de force
SELECT testProjectLifeCycleNotEnoughMoneyForceShutdown();

--Teste si on essaye de creer 2 projets
SELECT test2ProjectCreatedBySamePerson();

/*
Fonctionnement normal d'un projet avec petites restrictions:
       Un utilisateur créé un projet, il a quelques dons puis décide de créer un autre projet avant que son premier projet soit fini.
       Il constate qu'il ne peut pas et attend que son premier projet se termine puis fini par créer son deuxieme projet.
*/
SELECT testBehaviour();

--un utilisateur de moins de 18 ans tente de s'inscrire, cela ne marche pas, fin.
SELECT testTropJeune ();

--Un utilisateur tente de créer un projet avec un solde(montant_base ou monatant max) negatif, cela ne marche pas.
SELECT montantNegatif ();

--un utlisateur tente de faire un don negatif
SELECT testDonNegatif ();

--un utlisateur tente de creer un projet et un autre tente un don plus haut que le max du projet autorisé
SELECT testTooMuchMoney();

--un utlisateur tente de creer un projet avec la date de limite  inférieur à la date courante
SELECT testDateIncorrecte();

--un administrateur veut obtenir les mails de tous les utilisateurs inscrits en novembre 2018
-- SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kikiki@gmail.com':: VARCHAR,1, FALSE, TO_DATE('2018/07/09', 'yyyy/mm/dd') :: DATE);
-- SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jaaaajo@gmail.com':: VARCHAR,1, FALSE, TO_DATE('2018/11/09', 'yyyy/mm/dd') :: DATE);	
-- SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,32, '2 rue du sae':: VARCHAR,'bludabediba@gmail.com':: VARCHAR,1, FALSE, TO_DATE('2018/11/09', 'yyyy/mm/dd') :: DATE);
SELECT mail FROM utilisateurs WHERE (date_inscription > TO_DATE('2018/10/31', 'yyyy/mm/dd') :: DATE) AND (date_inscription < TO_DATE('2018/12/01', 'yyyy/mm/dd') :: DATE);

--un administrateur veut obtenir les projets crées en novembre 2018
SELECT * FROM projets WHERE (date_creation > TO_DATE('2018/10/31', 'yyyy/mm/dd') :: DATE) AND (date_creation < TO_DATE('2018/12/01', 'yyyy/mm/dd') :: DATE);

--petites tests divers
SELECT getUtilisateurs();
SELECT getUtilisateursAge(15);
SELECT moyenneDonateursMontant(1);
SELECT totalDons(1);
SELECT totalDons(1,1);
SELECT don (1, 1, 75);


CREATE OR REPLACE FUNCTION redistribute  (projid projets.id_projet%TYPE) 
RETURNS INTEGER AS $$ 
DECLARE 
ligne RECORD;
BEGIN 
FOR ligne IN SELECT * FROM beneficiaires WHERE beneficiaires.id_projet = projid
LOOP
	UPDATE beneficiaires
	SET montant = ((SELECT montant_actuel FROM projets WHERE id_projet = projid)*(ligne.pourcentage_extra))/100 
	WHERE id_beneficiaire = ligne.id_beneficiaire;
END LOOP;
RETURN 1; 
END;
$$ LANGUAGE plpgsql;