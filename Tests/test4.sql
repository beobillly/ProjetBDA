DROP FUNCTION IF EXISTS getBeneficiairesProjet CASCADE;

CREATE OR REPLACE FUNCTION getBeneficiairesProjet(idProj projets.id_projet%TYPE) 
RETURNS SETOF beneficiaires AS $$
SELECT * FROM beneficiaires
WHERE id_projet = idProj;
$$ LANGUAGE SQL;
