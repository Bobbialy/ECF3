DROP DATABASE IF EXISTS cryo;
CREATE DATABASE cryo;
USE cryo;

CREATE TABLE user_(
    id_user INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nom_user VARCHAR(50),
    prenom_user VARCHAR(50),
    num_tel_user VARCHAR(50),
    login_user VARCHAR(50),
    password_user VARCHAR(255),
    statut_user VARCHAR(50),
    commentaire_user VARCHAR(200)
)ENGINE=InnoDB;

CREATE TABLE abonnement(
    id_abo INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    libelle_abo VARCHAR(50),
    nb_seances INT,
    prix_abo DECIMAL(5,2)
)ENGINE=InnoDB;

INSERT INTO abonnement(libelle_abo, nb_seances, prix_abo) VALUES
('abo_1','5', 160.00),
('abo_2','10', 300.00),
('abo_3','20', 500.00);

CREATE TABLE posseder(
    id_user_abo INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_abo DATE,
    nb_seances_restantes INT,
    id_user INT UNSIGNED NOT NULL,
    id_abo INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user_(id_user),
    FOREIGN KEY (id_abo) REFERENCES abonnement(id_abo)
)ENGINE=InnoDB;

CREATE TABLE seance(
    id_seance INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT UNSIGNED NOT NULL,
    date_seance DATE,
    heure_seance TIME,
    commentaire_seance VARCHAR(200),
    FOREIGN KEY (id_user) REFERENCES user_(id_user)
)ENGINE=InnoDB;



CREATE TABLE partenaire(
    id_partenaire INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nom_partenaire VARCHAR(50),
    login_partenaire VARCHAR(50),
    num_tel_partenaire VARCHAR(50),
    sport VARCHAR(50)
)ENGINE=InnoDB;

INSERT INTO partenaire(nom_partenaire, login_partenaire, num_tel_partenaire, sport) VALUES
('partner_1', 'login_partner_1@mail.com', '01.02.03.04.05', 'Football'),
('partner_2', 'login_partner_2@mail.com', '11.12.13.14.15', 'Rugby'),
('partner_3', 'login_partner_3@mail.com', '21.22.23.24.25', 'Kayak');

CREATE TABLE etre_affilie(
    id_user INT UNSIGNED NOT NULL,
    id_partenaire INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_user, id_partenaire),
    FOREIGN KEY (id_user) REFERENCES user_(id_user),
    FOREIGN key (id_partenaire) REFERENCES partenaire(id_partenaire)
)ENGINE=InnoDB;

CREATE TABLE contrat(
    id_contrat INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    libelle_contrat VARCHAR(50),
    nb_seances_hebdo_max INT,
    prix_contrat DECIMAL(7,2)
)ENGINE=InnoDB;

INSERT INTO contrat(libelle_contrat, nb_seances_hebdo_max, prix_contrat) VALUES
('contrat_foot', '15', '15000.00'),
('contrat_rugby', '20', '20000.00'),
('contrat_kayak', '7', '7000.00');

CREATE TABLE disposer(
    id_contrat_part INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_debut_contrat DATE,
    date_fin_contrat DATE,
    id_partenaire INT UNSIGNED NOT NULL,
    id_contrat INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_partenaire) REFERENCES partenaire(id_partenaire),
    FOREIGN KEY (id_contrat) REFERENCES contrat(id_contrat)
)ENGINE=InnoDB;

INSERT INTO disposer(date_debut_contrat, date_fin_contrat, id_partenaire, id_contrat) VALUES
('2021-01-01', '2022-01-01', '1', '1'),
('2021-02-02', '2022-02-03', '2', '2'),
('2021-03-03', '2022-03-03', '3', '3');
