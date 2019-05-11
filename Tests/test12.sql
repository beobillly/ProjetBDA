DROP FUNCTION IF EXISTS pourcentageDepasse CASCADE;

--un utilisateur ajoute des beneficiaires pour plus de 100% de reversement
CREATE OR REPLACE FUNCTION pourcentageDepasse () 
RETURNS INTEGER AS $$ 
BEGIN
	PERFORM newBeneficiaire(1, 1, 60);
	PERFORM newBeneficiaire(2, 1, 60);
	RETURN 1;

END;
$$ LANGUAGE plpgsql;

SELECT pourcentageDepasse();