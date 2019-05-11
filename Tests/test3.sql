DROP FUNCTION IF EXISTS testDonNegatif CASCADE;

--un utlisateur tente de faire un don negatif
CREATE OR REPLACE FUNCTION testDonNegatif () 
RETURNS INTEGER AS $$ 
DECLARE
i INTEGER := 0;
BEGIN
	--PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kakoko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'kakoko@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don(i, (SELECT MAX(id_projet) from projets), -500);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

SELECT testDonNegatif ();
