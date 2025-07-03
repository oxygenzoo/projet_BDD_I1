# Mini Projet Base de Données – "Malloc Your Muscle"

## Contexte pédagogique

Ce projet a été réalisé dans le cadre du module **Introduction aux bases de données** à l'EFREI Paris (promotion 2023-2024). Il s’inscrit dans une série de TP dont l’objectif final est la création complète d’une base de données relationnelle.

- Projet limité à 2 séances de 3 heures
- Remise : 27 octobre 2024
- Encadré par : Professeur de TD/TP de BDD
- Pondération : 20 % de la note finale du module
- Note obtenue : 16/20

---

## Sujet choisi

### Mini-projet n°1 — Base de données d'une salle de sport

La salle de sport fictive "Malloc Your Muscle" souhaite centraliser toutes ses informations dans une base de données complète.

Fonctionnalités exigées :
- Gestion des adhérents
- Gestion des abonnements
- Gestion des sports proposés
- Extensions : paiements, coachs, créneaux, etc.

---

## Objectifs pédagogiques

- Concevoir un modèle Entité-Association (EA) puis le traduire en schéma relationnel
- Créer une base de données relationnelle robuste
- Automatiser le peuplement de la base via des fichiers CSV
- Rédiger et tester des requêtes SQL avancées
- Organiser un projet SQL de manière professionnelle

---

## Structure du projet

```
Projet/
├── Rendu
│   ├── base de données.sql
│   ├── code source.txt
│   ├── peuplement/
│   │   ├── peuplement_abonnement.csv
│   │   ├── peuplement_adherents.csv
│   │   ├── peuplement_coach.csv
│   │   ├── peuplement_creneau.csv
│   │   ├── peuplement_dispose.csv
│   │   ├── peuplement_donne.csv
│   │   ├── peuplement_paiement.csv
│   │   ├── peuplement_pratique.csv
│   │   ├── peuplement_sport.csv
│   ├── requêtes/
│   │   ├── req1.csv
│   │   ├── req2.csv
│   │   ├── req3.csv
│   │   ├── req4.csv
│   │   ├── req5.csv
│   ├── modele EA.loo
├── ennoncé.pdf
```

---

## Démarche méthodologique

### 1. Analyse du cahier des charges

- Identification des entités, attributs, cardinalités et relations
- Projection en scénarios réels d'utilisation (multi-abonnements, paiements, etc.)

### 2. Modèle Entité-Association (EA)

- Réalisé avec Looping
- Utilisation d’un héritage : un coach est un adhérent
- Relations clés :
  - `Pratique` : adhérents ↔ sports
  - `Dispose_de` : sports ↔ créneaux
  - `Donne` : coachs ↔ sports

### 3. Passage au schéma relationnel

- Normalisation appliquée
- Clés primaires et étrangères définies
- Contraintes d'intégrité respectées

### 4. Création physique

- Script SQL de création des tables avec commentaires
- Implémentation des contraintes (types, clés, validations)

### 5. Peuplement

- Données générées avec l’aide de ChatGPT, nettoyées et formatées
- Fichiers CSV importables

### 6. Requêtes et tests

- Requêtes stockées dans `code source.txt`
- Résultats enregistrés dans `requetes/`

---

## Schéma relationnel

```sql
Adhérent(ID_adhérent, Nom, Prénom, Date_naissance, Email, Téléphone, Num_rue, Nom_rue, CP, Ville)
Abonnement(ID_abonnement, Type, Prix, Date_début, Date_fin, Statut_abonnement, #ID_adhérent)
Paiement(ID_paiement, Montant, Date_paiement, #ID_abonnement)
Coach(ID_coach, Salaire, Certification, #ID_adhérent)
Sport(ID_sport, Nom_sport, Niveau)
Créneau(ID_créneau, Jour, Heure_début, Heure_fin)
Donne(#ID_coach, #ID_sport)
Pratique(#ID_adhérent, #ID_sport)
Dispose_de(#ID_sport, #ID_créneau)
```

---

## Tests (résultats dans le dossier `requêtes/`)

**Requête 1** – Adhérents avec leur abonnement :
```sql
SELECT a.ID_adherent, a.Nom, a.Prenom, ab.Type
FROM adherent a
JOIN abonnement ab ON a.ID_adherent = ab.ID_adherent;
```

**Requête 2** – Liste des sports avec leur niveau :
```sql
SELECT Nom_sport, Niveau FROM Sport;
```

**Requête 3** – Paiements par adhérent :
```sql
SELECT p.ID_paiement, p.Montant, p.Date_paiment, a.Nom, a.Prenom
FROM paiement p
JOIN abonnement ab ON p.ID_abonnement = ab.ID_abonnement
JOIN adhérent a ON ab.ID_adherent = a.ID_adherent;
```

**Requête 4** – Nombre d’adhérents par type d’abonnement :
```sql
SELECT ab.Type, COUNT(a.ID_adherent) AS Nombre_adhérents
FROM Abonnement ab
LEFT JOIN Adherent a ON ab.ID_adherent = a.ID_adherent
GROUP BY ab.Type;
```

**Requête 5** – Coachs et sports qu'ils enseignent :
```sql
SELECT c.ID_coach, c.ID_adherent, s.Nom_sport
FROM Donne d
JOIN Coach c ON d.ID_coach = c.ID_coach
JOIN Sport s ON d.ID_sport = s.ID_sport;
```

---

## Exemple de prompt utilisé pour le peuplement

> Génère un fichier CSV pour peupler une table `Abonnement` avec 100 lignes.  
> Chaque ligne contient : ID_abonnement, type (mensuel, trimestriel, annuel, employé), prix associé, date_début, date_fin (calculée selon le type), et statut_abonnement ("actif" si date_fin > aujourd’hui, "inactif" sinon).  
> Pas d’en-tête, valeurs séparées par des virgules.

---

## Lancer le projet en local

1. Créer la base :
```sql
CREATE DATABASE salle_sport;
USE salle_sport;
SOURCE 'base de données.sql';
```

2. Peupler les tables :
```sql
LOAD DATA INFILE 'peuplement/peuplement_adherents.csv'
INTO TABLE adherents
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '
'
IGNORE 1 ROWS;
```

3. Exécuter les requêtes depuis `code source.txt`.

---

## Fonctionnalités couvertes

- Gestion des abonnements, paiements, coachs, et séances
- Requêtes de suivi et d’analyse (statistiques)
- Relations multiples et cohérentes entre les entités

---

## Technologies utilisées

- SQL (MySQL)
- Fichiers CSV pour le peuplement
- Looping pour la modélisation EA

---

## Compétences développées

- Modélisation conceptuelle et logique
- Écriture de requêtes SQL complexes
- Organisation d’un projet de base de données de A à Z
- Nettoyage, validation et injection de données

---

## Perspectives

Ce projet pourrait facilement évoluer vers une application web (PHP / Django / Flask) ou une interface utilisateur en Java/Vue.js connectée à cette base pour permettre aux utilisateurs de :

- Réserver des créneaux
- Voir leurs paiements
- S’abonner ou changer d’abonnement
- Afficher les statistiques de fréquentation

---

## Réalisé par

- Guignabert Enzo  
- Mehenni Aïssa  
Étudiants en Informatique – EFREI Paris – Promotion 2025
