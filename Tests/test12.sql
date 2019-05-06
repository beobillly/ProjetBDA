DROP FUNCTION IF EXISTS testTropJeune CASCADE;

--un utilisateur de moins de 18 ans tente de s'inscrire, cela ne marche pas, fin.
CREATE OR REPLACE FUNCTION testTropJeune () 
RETURNS INTEGER AS $$ 
BEGIN
	PERFORM newUtilisateurs('Henri' :: VARCHAR,'Jp':: VARCHAR,12, '2 rue imo':: VARCHAR,'roro@gmail.com':: VARCHAR,1, TRUE, CURRENT_TIMESTAMP :: DATE);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

SELECT testTropJeune ();