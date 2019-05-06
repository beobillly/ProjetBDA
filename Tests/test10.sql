DROP FUNCTION IF EXISTS test2ProjectCreatedBySamePerson CASCADE;


--Teste si on essaye de creer 2 projets
CREATE OR REPLACE FUNCTION test2ProjectCreatedBySamePerson()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	PERFORM newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kula@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajou@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
		PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'j0j9@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'j0j9@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'j0j9@gmail.com');
	RETURN InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	
END;
$$ LANGUAGE plpgsql;

SELECT test2ProjectCreatedBySamePerson();
