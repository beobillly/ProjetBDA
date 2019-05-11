DROP FUNCTION IF EXISTS montantNegatif CASCADE;

--Un utilisateur tente de créer un projet avec un solde(montant_base ou monatant max) negatif, cela ne marche pas.
CREATE OR REPLACE FUNCTION montantNegatif () 
RETURNS BOOLEAN AS $$ 
DECLARE
i INTEGER := 0;
BEGIN
	PERFORM newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kokoko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
	i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'kokoko@gmail.com');
	RETURN InitierProjet(i, 'mon disque', -6000, 10000, 'on va seclater ouaiiiis', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
END;
$$ LANGUAGE plpgsql;

SELECT montantNegatif();
