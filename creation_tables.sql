--Creation de table
DROP TABLE IF EXISTS utilisateurs CASCADE;
DROP TABLE IF EXISTS initiateurs CASCADE;
DROP TABLE IF EXISTS projets CASCADE;
DROP TABLE IF EXISTS beneficiaires CASCADE;
DROP TABLE IF EXISTS donateurs CASCADE;
DROP TABLE IF EXISTS log_projets CASCADE;
DROP TABLE IF EXISTS log_utilisateurs CASCADE;
DROP INDEX IF EXISTS X_DONA_MONTNIV CASCADE;
DROP INDEX IF EXISTS X_PROJ_DATE_CREALIM CASCADE;
DROP INDEX IF EXISTS X_UTI_MAIL CASCADE;

--table utilisateurs
CREATE TABLE IF NOT EXISTS utilisateurs (
    id_utilisateur serial PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    age INT NOT NULL CHECK ( age >= 18 ),
    adresse VARCHAR(255) NOT NULL,
    mail VARCHAR(255) NOT NULL,
    niveau_global INT NOT NULL,
    actif BOOLEAN NOT NULL,
    date_inscription DATE NOT NULL,
    date_derniere_connexion DATE DEFAULT NULL
);

--table projet
CREATE TABLE IF NOT EXISTS projets (
    id_projet serial PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    montant_base INT NOT NULL CHECK ( montant_base > 0) DEFAULT 1000,
    montant_max INT NOT NULL CHECK ( montant_max > montant_base ) DEFAULT 1000000,
    montant_actuel INT NOT NULL CHECK (montant_actuel < montant_max AND montant_actuel >= 0) DEFAULT 0,
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
CREATE TABLE IF NOT EXISTS beneficiaires (
    id_beneficiaire serial PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_projet INT NOT NULL,
    role_projet VARCHAR(255) DEFAULT NULL,
    montant INT NOT NULL CHECK (montant >= 0) DEFAULT 0,
    pourcentage_extra INT NOT NULL CHECK (pourcentage_extra >= 0 AND pourcentage_extra <= 100) DEFAULT 0,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id_utilisateur),
    FOREIGN KEY (id_projet) REFERENCES projets(id_projet)
);

--table donateurs
CREATE TABLE IF NOT EXISTS donateurs (
    id_donateur serial PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_projet INT NOT NULL,
    montant INT NOT NULL CHECK (montant >= 0) DEFAULT 0,
    niveau INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id_utilisateur),
    FOREIGN KEY (id_projet) REFERENCES projets(id_projet)
);

--table log_utilisateurs
CREATE TABLE IF NOT EXISTS log_utilisateurs (
    id_log_u serial PRIMARY KEY,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    date_action date NOT NULL,
    categorie VARCHAR(255) NOT NULL
);

--table log_projets
CREATE TABLE IF NOT EXISTS log_projets (
    id_log_p serial PRIMARY KEY,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    date_action date NOT NULL,
    categorie VARCHAR(255) NOT NULL
);

--index secondaire
CREATE INDEX X_PROJ_DATE_CREALIM ON projets (date_creation, date_limite);
CREATE INDEX X_DONA_MONTNIV ON donateurs (montant, niveau);
CREATE INDEX X_UTI_MAIL ON utilisateurs (mail);