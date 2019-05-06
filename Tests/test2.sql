DROP FUNCTION IF EXISTS newUtilisateurs CASCADE;

--fonction qui ajoute des utilisateurs dans la table utilisateurs
CREATE OR REPLACE FUNCTION newUtilisateurs(unom utilisateurs.nom%TYPE, uprenom utilisateurs.prenom%TYPE, uage utilisateurs.age%TYPE, uadresse utilisateurs.adresse%TYPE, umail utilisateurs.mail%TYPE, univeau_global utilisateurs.niveau_global%TYPE, uactif utilisateurs.actif%TYPE, udate_inscription utilisateurs.date_inscription%TYPE) 
RETURNS SETOF utilisateurs AS $$
INSERT INTO utilisateurs (nom, prenom, age, adresse, mail, niveau_global, actif, date_inscription) 
VALUES (unom, uprenom, uage, uadresse, umail, univeau_global, uactif, udate_inscription);
SELECT getUtilisateurs();
$$ LANGUAGE SQL;