--(SELECT projets.montant_base FROM projets WHERE projets.id_projet = beneficaires.id_projet ) >= 
--   (SELECT SUM(montant) FROM beneficaires WHERE beneficiaires.id_projet = projets.id_projet);

DROP FUNCTION IF EXISTS log_utilisateur_update CASCADE;

CREATE FUNCTION log_utilisateur_update() RETURNS trigger AS $$ 
BEGIN
INSERT INTO log_utilisateurs  SELECT NEW.*,current_timestamp, 'INSERTION';

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_u_u
AFTER UPDATE ON utilisateurs
FOR EACH ROW EXECUTE PROCEDURE log_utilisateur_update();