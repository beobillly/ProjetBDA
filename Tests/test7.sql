DROP FUNCTION IF EXISTS testProjectLifeCycleNotEnoughMoney CASCADE;

--Teste la vie d'un projet qui n'a pas assez d'argent pour terminer

CREATE OR REPLACE FUNCTION testProjectLifeCycleNotEnoughMoney()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'jiji@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'koku@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'koku@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jajo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	RETURN TerminerProjet(i, (SELECT MAX(id_projet) from projets));
	
END;
$$ LANGUAGE plpgsql;



SELECT testProjectLifeCycleNotEnoughMoney();