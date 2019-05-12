DROP FUNCTION IF EXISTS testDateIncorrecte CASCADE;


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

--un utlisateur tente de creer un projet avec la date de limite  inférieur à la date courante
SELECT testDateIncorrecte();