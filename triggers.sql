(SELECT projets.montant_base FROM projets WHERE projets.id_projet = beneficaires.id_projet ) >= 
    (SELECT SUM(montant) FROM beneficaires WHERE beneficiaires.id_projet = projets.id_projet)