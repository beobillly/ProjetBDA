DROP FUNCTION IF EXISTS testProjectLifeCycle CASCADE;

--Teste la vie d'un projet en entier
CREATE OR REPLACE FUNCTION testProjectLifeCycle()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'j0jo@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'k@gmail.com'), (SELECT MAX(id_projet) from projets), 2000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'k@gmail.com'), (SELECT MAX(id_projet) from projets), 2000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jjo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	PERFORM newBeneficiaire((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'framo@gmail.com'), (SELECT MAX(id_projet) from projets), 10);
	PERFORM newBeneficiaire((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'milyjonck@gmail.com'), (SELECT MAX(id_projet) from projets), 20);
	RETURN TerminerProjet(i, (SELECT MAX(id_projet) from projets));
	
END;
$$ LANGUAGE plpgsql;




--Teste la vie d'un projet en entier
SELECT testProjectLifeCycle();