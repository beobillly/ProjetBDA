--Creation de table
DROP TABLE IF EXISTS utilisateurs;
DROP TABLE IF EXISTS initiateurs;
DROP TABLE IF EXISTS projets;
DROP TABLE IF EXISTS beneficaires;
DROP TABLE IF EXISTS donateurs;
DROP TABLE IF EXISTS log_projets;
DROP TABLE IF EXISTS log_utilisateurs;

--table utilisateurs
CREATE TABLE IF NOT EXISTS utilisateurs (
    id_utilisateur serial PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(20) NOT NULL,
    age INT NOT NULL CHECK ( age > 18 ),
    adresse VARCHAR(50) NOT NULL,
    mail VARCHAR(50) NOT NULL,
    niveau_global INT NOT NULL,
    actif BOOLEAN NOT NULL,
    date_inscription DATE NOT NULL,
    date_derniere_connexion DATE DEFAULT NULL
);

--table projet
CREATE TABLE IF NOT EXISTS projets (
    id_projet serial PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    montant_base INT NOT NULL CHECK ( montant_base > 0) DEFAULT 1000,
    montant_max INT NOT NULL CHECK ( montant_max > montant_base ) DEFAULT 1000000,
    montant_actuel INT NOT NULL CHECK (montant_actuel < montant_max) DEFAULT 0,
    descr VARCHAR(255) NOT NULL,
    date_creation DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_limite DATE NOT NULL CHECK (date_limite >= date_creation),
    date_dernier_don DATE DEFAULT NULL,
    actif BOOLEAN NOT NULL DEFAULT TRUE
);

--table initiateur
CREATE TABLE IF NOT EXISTS initiateurs (
    id_initiateur serial PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_projet INT NOT NULL,
    descr VARCHAR(255) DEFAULT NULL,
    fiabilite INT DEFAULT 5,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id_utilisateur),
    FOREIGN KEY (id_projet) REFERENCES projets(id_projet)
);

--table beneficiaire
CREATE TABLE IF NOT EXISTS beneficaires (
    id_beneficiaire serial PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_projet INT NOT NULL,
    role_projet VARCHAR(255) DEFAULT NULL,
    montant INT CHECK (montant > 0) DEFAULT 0,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id_utilisateur),
    FOREIGN KEY (id_projet) REFERENCES projets(id_projet)
);

--table donateurs
CREATE TABLE IF NOT EXISTS donateurs (
    id_donateur serial PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_projet INT NOT NULL,
    montant INT DEFAULT 0,
    niveau INT DEFAULT 1,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id_utilisateur),
    FOREIGN KEY (id_projet) REFERENCES projets(id_projet)
);

--table log_utilisateurs
CREATE TABLE IF NOT EXISTS log_utilisateurs (
    id_log_u serial PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    date_action date NOT NULL,
    action_u VARCHAR(255) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id_utilisateur)
);

--table log_projets
CREATE TABLE IF NOT EXISTS log_projets (
    id_log_p serial PRIMARY KEY,
    id_projet INT NOT NULL,
    date_action date NOT NULL,
    action_p VARCHAR(255) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_projet) REFERENCES projets(id_projet)
);

--Insertion dans les tables

INSERT INTO utilisateurs (nom, prenom, age, adresse, mail, niveau_global, actif, date_inscription) 
VALUES ('Duval','Albert',25, '2 rue du sae','bebert@gmail.com',1, FALSE, CURRENT_TIMESTAMP);


INSERT INTO projets (nom, montant_base, montant_max, descr, date_limite, actif) 
VALUES ('Duval',1000,25000,'mon super projet', CURRENT_TIMESTAMP, True);


INSERT INTO initiateurs (id_utilisateur, id_projet, descr, fiabilite) 
VALUES (1,1, 'coucou',5);

INSERT INTO beneficaires (id_utilisateur, id_projet, role_projet, montant) 
VALUES (1,1, 'batteur',50);

INSERT INTO donateurs (id_utilisateur, id_projet, montant, niveau) 
VALUES (1,1, 50,5);

INSERT INTO log_utilisateurs (id_utilisateur, date_action, action_u, categorie) 
VALUES (1,CURRENT_TIMESTAMP, 'CREATION dun log','CREATION');

INSERT INTO log_projets (id_projet, date_action, action_p, categorie) 
VALUES (1,CURRENT_TIMESTAMP, 'CREATION dun log','CREATION');
