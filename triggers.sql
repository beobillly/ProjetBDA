--(SELECT projets.montant_base FROM projets WHERE projets.id_projet = beneficaires.id_projet ) >= 
--   (SELECT SUM(montant) FROM beneficaires WHERE beneficiaires.id_projet = projets.id_projet);

DROP FUNCTION IF EXISTS log_utilisateur_update CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_insert CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_delete CASCADE;

DROP FUNCTION IF EXISTS verification_don CASCADE;
DROP FUNCTION IF EXISTS pending_project CASCADE;

DROP FUNCTION IF EXISTS update_date_connexion CASCADE;
DROP FUNCTION IF EXISTS update_date_dernier_don CASCADE;

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

CREATE FUNCTION update_date_dernier_don(uid_projet projets.id_projet%TYPE) 
RETURNS INTEGER AS $$
BEGIN
UPDATE projets SET date_dernier_don = current_timestamp
WHERE id_projet = uid_projet;
RETURN 1;
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
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION pending_project()
    RETURNS TRIGGER
    AS $$
    DECLARE 
	ligne RECORD;
	i INTEGER := 0 ;
    BEGIN FOR ligne IN SELECT id_projet FROM projets WHERE projets.nom = NEW.nom
	LOOP
		IF ligne.actif = TRUE 
			THEN RAISE EXCEPTION 'Projet encore en cours sous le meme nom';
		END IF;
		i := i + 1 ;
	END LOOP;
    -- IF LENGTH(NEW.login_name) = 0 THEN
    --     RAISE EXCEPTION 'Login name must not be empty.';
    -- END IF;
 
    -- IF POSITION(' ' IN NEW.login_name) > 0 THEN
    --     RAISE EXCEPTION 'Login name must not include white space.';
    -- END IF;
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
IF (NEW.montant_actuel >= NEW.montant_max) OR (NEW.actif = FALSE)
THEN RAISE EXCEPTION 'Le montant de votre don dépasse le montant maximal autorisé par ce projet';
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

--insert

/*
CREATE TRIGGER p_p
BEFORE INSERT ON projets
FOR EACH ROW EXECUTE PROCEDURE pending_project();
*/
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

