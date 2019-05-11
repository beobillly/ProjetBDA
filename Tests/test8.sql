DROP FUNCTION IF EXISTS testProjectLifeCycleNotEnoughMoneyForceShutdown CASCADE;




--Teste la vie d'un projet qui n'a pas assez d'argent et qui est fermé de force
CREATE OR REPLACE FUNCTION testProjectLifeCycleNotEnoughMoneyForceShutdown()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'jiko@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	RETURN TerminerProjetForce(i, (SELECT MAX(id_projet) from projets));
	
END;
$$ LANGUAGE plpgsql;


SELECT testProjectLifeCycleNotEnoughMoneyForceShutdown();
