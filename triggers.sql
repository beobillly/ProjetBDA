--(SELECT projets.montant_base FROM projets WHERE projets.id_projet = beneficaires.id_projet ) >= 
--   (SELECT SUM(montant) FROM beneficaires WHERE beneficiaires.id_projet = projets.id_projet);

DROP FUNCTION IF EXISTS log_utilisateur_update CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_insert CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_before_insert CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_delete CASCADE;

DROP FUNCTION IF EXISTS verification_don CASCADE;
DROP FUNCTION IF EXISTS pending_project CASCADE;

DROP FUNCTION IF EXISTS update_date_connexion CASCADE;
DROP FUNCTION IF EXISTS update_date_dernier_don CASCADE;
DROP FUNCTION IF EXISTS verification_montant_base CASCADE;
DROP FUNCTION IF EXISTS verification_date_limite_projet CASCADE;
DROP FUNCTION IF EXISTS verification_retours_beneficiaires CASCADE;
DROP FUNCTION IF EXISTS verification_retours_beneficiaires_extras CASCADE;

DROP FUNCTION IF EXISTS log_projet_update CASCADE;
DROP FUNCTION IF EXISTS log_projet_insert CASCADE;
DROP FUNCTION IF EXISTS log_projet_delete CASCADE;

--fonctions

-- TABLE UTILISATEURS

CREATE FUNCTION update_date_connexion(uid_utilisateur utilisateurs.id_utilisateur%TYPE) 
RETURNS INTEGER AS $$
BEGIN
UPDATE utilisateurs SET date_derniere_connexion = current_timestamp
WHERE id_utilisateur = uid_utilisateur;
RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- CREATE FUNCTION update_level() 
-- RETURNS trigger AS $$ 
-- BEGIN
-- 	IF ((NEW.montant) > 1000)
-- 	THEN
-- 		NEW.niveau = 2;
-- 	END IF;
-- 	IF ((NEW.montant) > 5000)
-- 	THEN
--   		NEW.niveau = 3;
-- 	END IF;
-- 	IF ((NEW.montant) > 20000)
-- 	THEN
--   		NEW.niveau = 4;
-- 	END IF;
-- RETURN NULL;
-- END;
-- $$ LANGUAGE plpgsql;

CREATE FUNCTION update_date_dernier_don(uid_projet projets.id_projet%TYPE) 
RETURNS INTEGER AS $$
BEGIN
UPDATE projets SET date_dernier_don = current_timestamp
WHERE id_projet = uid_projet;
RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION verification_montant_base(uid_projet projets.id_projet%TYPE) 
RETURNS BOOLEAN AS $$
BEGIN
IF (SELECT montant_actuel from projets where projets.id_projet = uid_projet) >= (SELECT montant_base from projets where projets.id_projet = uid_projet) 
THEN RETURN TRUE;
END IF;
RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION verification_date_limite_projet(uid_projet projets.id_projet%TYPE) 
RETURNS BOOLEAN AS $$
BEGIN
IF (SELECT date_limite from projets where projets.id_projet = uid_projet) < current_timestamp 
THEN RETURN TRUE;
END IF;
RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

--update 
CREATE FUNCTION log_utilisateur_update() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_utilisateurs (old_value, new_value, date_action, categorie) VALUES (OLD, NEW, current_timestamp, 'UPDATE');
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--insert 
CREATE FUNCTION log_utilisateur_insert() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_utilisateurs (new_value, date_action, categorie) VALUES (NEW, current_timestamp, 'INSERT');
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--insert 
CREATE FUNCTION log_utilisateur_before_insert() RETURNS trigger AS $$ 
BEGIN
IF NOT EXISTS (select utilisateurs.mail from utilisateurs where utilisateurs.mail = NEW.mail)
THEN RETURN NEW;
ELSE RAISE EXCEPTION 'Le mail que vous avez choisi existe deja';
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--delete 
CREATE FUNCTION log_utilisateur_delete() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_utilisateurs (old_value, date_action, categorie) VALUES (OLD, current_timestamp, 'DELETE');
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--TABLE PROJETS

--update 
CREATE FUNCTION log_projet_update() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_projets (old_value, new_value, date_action, categorie) VALUES (OLD, NEW, current_timestamp, 'UPDATE');
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--insert 

CREATE FUNCTION log_projet_insert() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_projets (new_value, date_action, categorie) VALUES (NEW, current_timestamp, 'INSERT');
INSERT INTO beneficiaires (id_utilisateur, id_projet, role_projet, montant, pourcentage_extra) VALUES (1, NEW.id_projet, 'Taxe platforme', 0, 5);
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


--Vérifie si total montant de retour pour les beneficiaires est inférieur au montant de base du projet
/*
CREATE FUNCTION verification_retours_beneficiaires() 
RETURNS trigger AS $$
BEGIN
IF (SELECT SUM(beneficiaires.montant) from beneficiaires where beneficiaires.id_projet = NEW.id_projet) <= (SELECT montant_base FROM projets WHERE id_projet = NEW.id_projet)
THEN
RAISE EXCEPTION 'Le total des retour pour les béneficiaires dépasse le montant de base';
RETURN OLD;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
*/

--Vérifie si pourcentage total de retour pour les beneficiaires est inférieur a 100%.
CREATE FUNCTION verification_retours_beneficiaires_extras() 
RETURNS trigger AS $$
BEGIN
IF (SELECT SUM(beneficiaires.pourcentage_extra) from beneficiaires where beneficiaires.id_projet = NEW.id_projet) >= 100
THEN
RAISE EXCEPTION 'Le total des pourcentages des extras dépasse 100';
RETURN OLD;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION pending_project()
RETURNS TRIGGER 
AS $$
BEGIN
    IF (SELECT COUNT(*) from initiateurs, projets WHERE initiateurs.id_projet = projets.id_projet AND NEW.id_utilisateur = initiateurs.id_utilisateur AND projets.actif = TRUE) > 1
    THEN
        RAISE EXCEPTION 'L initiateur aurais plus d un projet actif';
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



--delete 
CREATE FUNCTION log_projet_delete() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_projets (old_value, date_action, categorie) VALUES (OLD, current_timestamp, 'DELETE');
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


--update don
CREATE FUNCTION verification_don() RETURNS trigger AS $$ 
BEGIN
IF (NEW.montant_actuel >= OLD.montant_max) OR (OLD.actif = FALSE)
THEN RAISE EXCEPTION 'Le montant de votre don dépasse le montant maximal autorisé par ce projet, le projet n est plus disponible à la modification';
END IF;
IF (/*NEW.montant_actuel <= OLD.montant_actuel) OR */(NEW.montant_actuel < 0))
THEN RAISE EXCEPTION 'Le montant de votre don ne doit pas etre negatif ou nul';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--triggers

-- TABLE UTILISATEURS

--update
CREATE TRIGGER log_u_u
AFTER UPDATE ON utilisateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_update();

CREATE TRIGGER log_i_u
AFTER UPDATE ON initiateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_update();

CREATE TRIGGER log_b_u
AFTER UPDATE ON beneficiaires
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_update();

CREATE TRIGGER log_d_u
AFTER UPDATE ON donateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_update();

CREATE TRIGGER p_p
BEFORE INSERT ON initiateurs
FOR EACH ROW EXECUTE PROCEDURE pending_project();


CREATE TRIGGER verif_r_b
AFTER UPDATE ON beneficiaires
FOR EACH ROW EXECUTE PROCEDURE verification_retours_beneficiaires();


-- CREATE TRIGGER verif_u_l
-- AFTER UPDATE ON donateurs
-- FOR EACH ROW EXECUTE PROCEDURE update_level();

CREATE TRIGGER verif_r_b_e
AFTER INSERT ON beneficiaires
FOR EACH ROW EXECUTE PROCEDURE verification_retours_beneficiaires_extras();

CREATE TRIGGER log_u_i
AFTER INSERT ON utilisateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_insert();

CREATE TRIGGER log_i_i
AFTER UPDATE ON initiateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_insert();

CREATE TRIGGER log_b_i
AFTER UPDATE ON beneficiaires
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_insert();

CREATE TRIGGER log_d_i
AFTER UPDATE ON donateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_insert();

CREATE TRIGGER log_u_i_b
BEFORE INSERT ON utilisateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_before_insert();

--delete
CREATE TRIGGER log_u_d
AFTER DELETE ON utilisateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_delete();

CREATE TRIGGER log_i_d
AFTER UPDATE ON initiateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_delete();

CREATE TRIGGER log_b_d
AFTER UPDATE ON beneficiaires
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_delete();

CREATE TRIGGER log_d_d
AFTER UPDATE ON donateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_delete();

-- TABLE PROJETS

CREATE TRIGGER log_p_u
AFTER UPDATE ON projets
FOR EACH ROW EXECUTE PROCEDURE log_projet_update();


CREATE TRIGGER log_p_i
AFTER INSERT ON projets
FOR EACH ROW EXECUTE PROCEDURE log_projet_insert();


CREATE TRIGGER log_p_d
AFTER DELETE ON projets
FOR EACH ROW EXECUTE PROCEDURE log_projet_delete();

CREATE TRIGGER verif_d
BEFORE UPDATE ON projets
FOR EACH ROW EXECUTE PROCEDURE verification_don();

