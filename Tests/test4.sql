
DROP FUNCTION IF EXISTS testTooMuchMoney CASCADE;

--un utlisateur tente de creer un projet et un autre tente un don plus haut que le max du projet autorisé
CREATE OR REPLACE FUNCTION testTooMuchMoney()
RETURNS INTEGER as $$
DECLARE
i INTEGER := 0;
BEGIN
	-- PERFORM newUtilisateurs('Bisasdasdous' :: VARCHAR,'dsde':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kiloka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- PERFORM newUtilisateurs('jfasd' :: VARCHAR,'cocaso':: VARCHAR,56, '70 rue du plankton':: VARCHAR,'joka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	-- 	PERFORM newUtilisateurs('jf' :: VARCHAR,'codco':: VARCHAR,78, '2 rue du plankton':: VARCHAR,'jikoka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'jikoka@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	RETURN don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kiloka@gmail.com'), (SELECT MAX(id_projet) from projets), 300000);
	
END;
$$ LANGUAGE plpgsql;


SELECT testTooMuchMoney();
