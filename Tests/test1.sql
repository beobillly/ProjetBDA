DROP FUNCTION IF EXISTS getUtilisateurs CASCADE;


--fonction qui renvoie tous les utilisateurs 
CREATE OR REPLACE FUNCTION getUtilisateurs() 
RETURNS SETOF utilisateurs AS $$
SELECT * FROM utilisateurs;
$$ LANGUAGE SQL;

SELECT getUtilisateurs();