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
DROP FUNCTION IF EXISTS TerminerProjetForce CASCADE;
DROP FUNCTION IF EXISTS aDejaProjetActif CASCADE;
DROP FUNCTION IF EXISTS newBeneficiaire CASCADE;
DROP FUNCTION IF EXISTS redistribute CASCADE;

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
DECLARE
mont INTEGER :=0;
BEGIN
	IF (donnation <= 0) THEN 
		RAISE 'Le montant a donner n est pas valide (egal ou inferieur a 0)';
	END IF;
	

	IF EXISTS (SELECT * FROM donateurs WHERE donateurs.id_utilisateur = uid AND donateurs.id_projet = projid)
	THEN
		UPDATE donateurs
		SET montant = donnation + montant
		WHERE id_utilisateur = uid AND id_projet = projid;

		mont = (SELECT montant FROM donateurs WHERE donateurs.id_utilisateur = uid);
	ELSE
		INSERT INTO donateurs (id_utilisateur, id_projet, montant, niveau)
		VALUES(uid, projid, donnation, 1);
		mont = donnation;
	END IF;

	IF (mont < 1000 AND mont >0)
	THEN
		UPDATE donateurs
		SET niveau = 1
		WHERE id_utilisateur = uid  AND id_projet = projid;
	ELSEIF (mont >= 1000 AND mont < 5000)
	THEN
		UPDATE donateurs
		SET niveau = 2
		WHERE id_utilisateur = uid  AND id_projet = projid;
	ELSEIF (mont >= 5000 AND mont < 20000)
	THEN
  		UPDATE donateurs
		SET niveau = 3
		WHERE id_utilisateur = uid  AND id_projet = projid;	
	ELSE
  		UPDATE donateurs
		SET niveau = 4
		WHERE id_utilisateur = uid  AND id_projet = projid;	
	END IF;

	UPDATE projets
	SET montant_actuel = donnation + montant_actuel
	WHERE id_projet = projid;

	-- UPDATE donateurs
	-- SET montant = donnation + montant
	-- WHERE uid = donateurs.id_utilisateur AND id_projet = projid;

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
		 		PERFORM redistribute(pid);
				RETURN TRUE;
			ELSE RAISE 'Le montant du projet n a pas encore atteint le but requis, utilisez TerminerProjetForce si vous voulez annuler le projet';
		END IF;
	ELSE RAISE 'Identifiant de l initiateur non trouvé, TRANSACTION ANNULEE';
	END IF;
	RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TerminerProjetForce(uid utilisateurs.id_utilisateur%TYPE, pid projets.id_projet%TYPE)
RETURNS BOOLEAN AS $$
BEGIN
	IF EXISTS (select * from initiateurs where initiateurs.id_utilisateur = uid and initiateurs.id_projet = pid)
	THEN
		update projets
		set actif=false
		where id_projet = pid;
		RETURN TRUE;
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
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--Fonction pour initier un projet
CREATE OR REPLACE FUNCTION InitierProjet(uid utilisateurs.id_utilisateur%TYPE, nomProjet projets.nom%TYPE, montantBase projets.montant_base%TYPE, montantMax projets.montant_max%TYPE, descriptionProjet projets.descr%TYPE, deadline projets.date_limite%TYPE)
RETURNS BOOLEAN AS $$
DECLARE
i INTEGER :=0;
BEGIN
	IF aDejaProjetActif(uid) THEN	
		RAISE 'Vous avez deja un projet actif';
		RETURN FALSE;
	ELSE
		PERFORM CreerProjet(nomProjet, montantBase, montantMax, descriptionProjet, deadline); 
		i := (SELECT MAX(id_projet) FROM projets);
		PERFORM CreerInitiateur(uid, i );
		RETURN TRUE;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION newBeneficiaire(uid beneficiaires.id_utilisateur%TYPE, projid beneficiaires.id_projet%TYPE, pourcentage beneficiaires.pourcentage_extra%TYPE) 
RETURNS SETOF beneficiaires AS $$
INSERT INTO beneficiaires (id_utilisateur, id_projet, pourcentage_extra) 
VALUES (uid, projid, pourcentage);
SELECT getBeneficiairesProjet(projid);
$$ LANGUAGE SQL;

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