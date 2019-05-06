DROP FUNCTION IF EXISTS getUtilisateursAge CASCADE;

--fonction qui renvoie tous les utilisateurs plus vieux que "vieux"
CREATE OR REPLACE FUNCTION getUtilisateursAge(vieux int) 
RETURNS SETOF utilisateurs AS $$ 
SELECT * FROM utilisateurs WHERE age > vieux;
$$ LANGUAGE SQL;

