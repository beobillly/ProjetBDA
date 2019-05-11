
DROP FUNCTION IF EXISTS testProjectCreation CASCADE;
--Teste la creation d'un projet en entier
CREATE OR REPLACE FUNCTION testProjectCreation()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'herb@gmail.com');
	RETURN InitierProjet(i, 'mon nouveau groupe trop bien fait une tournee', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	
END;
$$ LANGUAGE plpgsql;



SELECT testProjectCreation();