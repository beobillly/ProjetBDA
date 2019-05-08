--Insertion dans les tables

INSERT INTO utilisateurs (nom, prenom, age, adresse, mail, niveau_global, actif, date_inscription) 
VALUES ('Platforme','Taxe',99, '2 rue du fric','filetonfric@gmail.com',1, true, CURRENT_TIMESTAMP);

INSERT INTO projets (nom, montant_base, montant_max, descr, date_limite, actif) 
VALUES ('Duval',1000,25000,'mon super projet', CURRENT_TIMESTAMP, True);

INSERT INTO initiateurs (id_utilisateur, id_projet, descr, fiabilite) 
VALUES (1,1, 'coucou',5);

INSERT INTO beneficiaires (id_utilisateur, id_projet, role_projet, montant) 
VALUES (1,1, 'batteur',50);

INSERT INTO donateurs (id_utilisateur, id_projet, montant, niveau) 
VALUES (1,1, 0,5);

INSERT INTO log_utilisateurs (new_value, date_action, categorie) 
VALUES ('CREATION dun log',CURRENT_TIMESTAMP,'CREATION');

INSERT INTO log_projets (new_value, date_action, categorie) 
VALUES ('CREATION dun log',CURRENT_TIMESTAMP,'CREATION');
