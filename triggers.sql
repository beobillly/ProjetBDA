--(SELECT projets.montant_base FROM projets WHERE projets.id_projet = beneficaires.id_projet ) >= 
--   (SELECT SUM(montant) FROM beneficaires WHERE beneficiaires.id_projet = projets.id_projet);

DROP FUNCTION IF EXISTS log_utilisateur_update CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_insert CASCADE;
DROP FUNCTION IF EXISTS log_utilisateur_delete CASCADE;

DROP FUNCTION IF EXISTS log_projet_update CASCADE;
DROP FUNCTION IF EXISTS log_projet_insert CASCADE;
DROP FUNCTION IF EXISTS log_projet_delete CASCADE;

--fonctions

-- TABLE UTILISATEURS

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

--delete 
CREATE FUNCTION log_projet_delete() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_projets (old_value, date_action, categorie) VALUES (OLD, current_timestamp, 'DELETE');
RETURN NULL;
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