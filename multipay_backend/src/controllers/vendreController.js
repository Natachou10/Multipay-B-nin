const prisma = require('../config/prisma');
const { simulerOperateur } = require('../services/operateurService');

// Vendre du crédit
const vendreCredit = async (req, res) => {
  const { montant, operateur, numero } = req.body;

  try {
    const compte = await prisma.compte.findUnique({
      where: { revendeurId: req.revendeur.id }
    });

    if (!compte) {
      return res.status(404).json({ message: 'Compte introuvable' });
    }

    if (compte.statut !== 'actif') {
      return res.status(403).json({ message: 'Compte verrouillé' });
    }

    if (Number(compte.soldePrincipal) < montant) {
      return res.status(400).json({ message: 'Solde insuffisant' });
    }

    // Simuler l'appel opérateur
    const resultat = await simulerOperateur(operateur, numero, montant, 'credit');

    if (resultat.statut === 'echec') {
      return res.status(400).json({ message: resultat.message });
    }

    await prisma.$transaction(async (tx) => {
      await tx.compte.update({
        where: { id: compte.id },
        data: { soldePrincipal: { decrement: montant } }
      });

      await tx.historique.create({
        data: {
          typeOperation: 'credit',
          montant,
          statut: 'confirme',
          description: `Vente crédit ${operateur} - ${numero}`,
          operateur: operateur,
          revendeurId: req.revendeur.id
        }
      });
    });

    res.status(201).json({
      message: 'Crédit envoyé avec succès',
      reference: resultat.reference,
      numero,
      operateur,
      montant,
      frais: resultat.frais,
      profit: resultat.frais
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Vendre un forfait
const vendreForfait = async (req, res) => {
  const { forfaitId, operateur, numero } = req.body;

  try {
    const compte = await prisma.compte.findUnique({
      where: { revendeurId: req.revendeur.id }
    });

    if (!compte) {
      return res.status(404).json({ message: 'Compte introuvable' });
    }

    if (compte.statut !== 'actif') {
      return res.status(403).json({ message: 'Compte verrouillé' });
    }

    const forfait = await prisma.forfait.findUnique({
      where: { id: forfaitId }
    });

    if (!forfait) {
      return res.status(404).json({ message: 'Forfait introuvable' });
    }

    if (Number(compte.soldePrincipal) < Number(forfait.prix)) {
      return res.status(400).json({ message: 'Solde insuffisant' });
    }

    // Simuler l'appel opérateur
    const resultat = await simulerOperateur(operateur, numero, Number(forfait.prix), 'forfait');

    if (resultat.statut === 'echec') {
      return res.status(400).json({ message: resultat.message });
    }

    await prisma.$transaction(async (tx) => {
      await tx.compte.update({
        where: { id: compte.id },
        data: { soldePrincipal: { decrement: Number(forfait.prix) } }
      });

      await tx.historique.create({
        data: {
          typeOperation: 'forfait',
          montant: Number(forfait.prix),
          statut: 'confirme',
          description: `Vente forfait ${forfait.type} ${operateur} - ${numero}`,
          operateur: operateur,
          revendeurId: req.revendeur.id
        }
      });
    });

    res.status(201).json({
      message: 'Forfait activé avec succès',
      reference: resultat.reference,
      numero,
      operateur,
      forfait: {
        type: forfait.type,
        prix: forfait.prix,
        validite: forfait.validite,
        description: forfait.description
      },
      profit: resultat.frais
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Lister les forfaits disponibles
const listerForfaits = async (req, res) => {
  const { type } = req.query;

  try {
    const forfaits = await prisma.forfait.findMany({
      where: type ? { type } : {},
      orderBy: { prix: 'asc' }
    });

    res.status(200).json({ forfaits });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};
// Créer un forfait (admin)
const creerForfait = async (req, res) => {
  const { type, prix, validite, description, minutes, volumeData } = req.body;

  try {
    const forfait = await prisma.forfait.create({
      data: { type, prix, validite, description, minutes, volumeData }
    });

    res.status(201).json({ message: 'Forfait créé', forfait });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};
module.exports = { vendreCredit, vendreForfait, listerForfaits, creerForfait };