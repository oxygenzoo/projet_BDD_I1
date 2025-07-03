SELECT a.ID_adherent, a.Nom, a.Prenom, ab.Type
FROM adhérent a
JOIN abonnement ab ON a.ID_adherent = ab.ID_adherent;




