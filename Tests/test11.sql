
DROP FUNCTION IF EXISTS testBehaviour CASCADE;



/*
Fonctionnement normal d'un projet avec petites restrictions:
       Un utilisateur créé un projet, il a quelques dons puis décide de créer un autre projet avant que son premier projet soit fini.
       Il constate qu'il ne peut pas et attend que son premier projet se termine puis fini par créer son deuxieme projet.
*/
CREATE OR REPLACE FUNCTION testBehaviour()
RETURNS BOOLEAN as $$
DECLARE
i INTEGER := 0;
BEGIN
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'kokiku@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);

	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 500);
	BEGIN
		PERFORM InitierProjet(i, 'mon instrument', 3000, 7000, 'un nouveau sax', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	EXCEPTION 
	WHEN others THEN
	
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'kilo@gmail.com'), (SELECT MAX(id_projet) from projets), 4000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jo@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);

	PERFORM TerminerProjet(i, (SELECT MAX(id_projet) from projets));

	RETURN InitierProjet(i, 'mon instrument', 3000, 7000, 'un nouveau sax', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	END;
	
END;
$$ LANGUAGE plpgsql;



SELECT testBehaviour();