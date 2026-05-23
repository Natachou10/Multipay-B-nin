const prisma = require('../config/prisma');
const bcrypt = require('bcryptjs');

// Consulter le profil
const consulterProfil = async (req, res) => {
  try {
    const revendeur = await prisma.revendeur.findUnique({
      where: { id: req.revendeur.id },
      select: {
        id: true,
        nom: true,
        telephone: true,
        email: true,
        dateInscription: true,
        compte: {
          select: { soldePrincipal: true, statut: true }
        }
      }
    });

    res.status(200).json({ revendeur });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Modifier le profil
const modifierProfil = async (req, res) => {
  const { nom, telephone, localisation, description } = req.body;

  try {
    const revendeur = await prisma.revendeur.update({
      where: { id: req.revendeur.id },
      data: { nom, telephone },
      select: { id: true, nom: true, telephone: true, email: true }
    });

    // Sauvegarder localisation et description dans Parametre
    if (localisation) {
      await prisma.parametre.upsert({
        where: { cle: `localisation_${req.revendeur.id}` },
        update: { valeur: localisation },
        create: { cle: `localisation_${req.revendeur.id}`, valeur: localisation, description: 'Localisation du revendeur' }
      });
    }

    if (description) {
      await prisma.parametre.upsert({
        where: { cle: `description_${req.revendeur.id}` },
        update: { valeur: description },
        create: { cle: `description_${req.revendeur.id}`, valeur: description, description: 'Description du revendeur' }
      });
    }

    res.status(200).json({ message: 'Profil mis à jour', revendeur });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Changer le mot de passe
const changerMotDePasse = async (req, res) => {
  const { ancienMotDePasse, nouveauMotDePasse } = req.body;

  try {
    const revendeur = await prisma.revendeur.findUnique({
      where: { id: req.revendeur.id }
    });

    const valide = await bcrypt.compare(ancienMotDePasse, revendeur.motDePasse);

    if (!valide) {
      return res.status(401).json({ message: 'Ancien mot de passe incorrect' });
    }

    const nouveauHash = await bcrypt.hash(nouveauMotDePasse, 10);

    await prisma.revendeur.update({
      where: { id: req.revendeur.id },
      data: { motDePasse: nouveauHash }
    });

    res.status(200).json({ message: 'Mot de passe modifié avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Consulter seuils et limites
const consulterSeuils = async (req, res) => {
  try {
    const seuils = await prisma.parametre.findMany({
      where: { cle: { startsWith: 'seuil_' } }
    });

    res.status(200).json({ seuils });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Modifier seuils et limites
const modifierSeuil = async (req, res) => {
  const { cle, valeur, description } = req.body;

  try {
    const seuil = await prisma.parametre.upsert({
      where: { cle },
      update: { valeur },
      create: { cle, valeur, description }
    });

    res.status(200).json({ message: 'Seuil mis à jour', seuil });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Consulter frais et commissions
const consulterFrais = async (req, res) => {
  try {
    const frais = await prisma.tarifFrais.findMany({
      orderBy: { typeOperation: 'asc' }
    });

    res.status(200).json({ frais });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Modifier délai d'activité
const modifierDelaiActivite = async (req, res) => {
  const { delai } = req.body;

  try {
    const parametre = await prisma.parametre.upsert({
      where: { cle: 'delai_activite' },
      update: { valeur: String(delai) },
      create: { cle: 'delai_activite', valeur: String(delai), description: 'Délai inactivité en minutes' }
    });

    res.status(200).json({ message: 'Délai mis à jour', parametre });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = {
  consulterProfil,
  modifierProfil,
  changerMotDePasse,
  consulterSeuils,
  modifierSeuil,
  consulterFrais,
  modifierDelaiActivite
};