const prisma = require('../config/prisma');
const bcrypt = require('bcryptjs');

// Consulter le solde
const consulterSolde = async (req, res) => {
  try {
    const compte = await prisma.compte.findUnique({
      where: { revendeurId: req.revendeur.id }
    });

    if (!compte) {
      return res.status(404).json({ message: 'Compte introuvable' });
    }

    res.status(200).json({
      soldePrincipal: compte.soldePrincipal,
      statut: compte.statut
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Configurer les comptes opérateurs
const configurerCompteOperateur = async (req, res) => {
  const { comptes } = req.body;
  // comptes = [{ operateur: 'MTN', numero: '97000001' }, ...]

  try {
    for (const compte of comptes) {
      await prisma.compteOperateur.upsert({
        where: {
          id: compte.id || 0
        },
        update: {
          numero: compte.numero,
          operateur: compte.operateur
        },
        create: {
          operateur: compte.operateur,
          numero: compte.numero,
          revendeurId: req.revendeur.id
        }
      });
    }

    res.status(200).json({ message: 'Comptes opérateurs configurés' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Vérifier le codePin
const verifierPin = async (req, res) => {
  const { codePin } = req.body;

  try {
    const compte = await prisma.compte.findUnique({
      where: { revendeurId: req.revendeur.id }
    });

    if (!compte) {
      return res.status(404).json({ message: 'Compte introuvable' });
    }

    const pinValide = await bcrypt.compare(codePin, compte.codePin);

    if (!pinValide) {
      return res.status(401).json({ message: 'Code PIN incorrect' });
    }

    res.status(200).json({ message: 'PIN valide' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Verrouiller le compte
const verrouiller = async (req, res) => {
  try {
    await prisma.compte.update({
      where: { revendeurId: req.revendeur.id },
      data: { statut: 'verrouille' }
    });

    res.status(200).json({ message: 'Compte verrouillé' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Déverrouiller le compte
const deverrouiller = async (req, res) => {
  try {
    await prisma.compte.update({
      where: { revendeurId: req.revendeur.id },
      data: { statut: 'actif' }
    });

    res.status(200).json({ message: 'Compte déverrouillé' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = { consulterSolde, verifierPin, verrouiller, deverrouiller, configurerCompteOperateur };