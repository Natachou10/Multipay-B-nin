const prisma = require('../config/prisma');
const { simulerOperateur } = require('../services/operateurService');
const { creerNotification } = require('./notificationController');


// Effectuer un dépôt
const effectuerDepot = async (req, res) => {
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

    // Simuler l'appel opérateur AVANT la transaction
    const resultat = await simulerOperateur(operateur, numero, montant, 'depot');

    if (resultat.statut === 'echec') {
      return res.status(400).json({ message: resultat.message });
    }

    // Transaction Prisma sans délai
    await prisma.$transaction(async (tx) => {
      const nouvelleTransaction = await tx.transaction.create({
        data: {
          type: 'depot',
          montant,
          frais: resultat.frais,
          statut: 'confirme',
          reference: resultat.reference,
          compteId: compte.id
        }
      });

      await tx.compte.update({
        where: { id: compte.id },
        data: { soldePrincipal: { increment: resultat.montantNet } }
      });

      await tx.historique.create({
        data: {
          typeOperation: 'depot',
          montant,
          statut: 'confirme',
          description: `Dépôt via ${operateur} - ${numero}`,
           operateur: operateur,
          revendeurId: req.revendeur.id,
          transactionId: nouvelleTransaction.id
        }
      });
    });
    await creerNotification(
  req.revendeur.id,
  'Dépôt effectué',
  `Dépôt de ${montant} FCFA via ${operateur} effectué avec succès. Référence: ${resultat.reference}`
);

    res.status(201).json({
      message: 'Dépôt effectué avec succès',
      reference: resultat.reference,
      montant,
      frais: resultat.frais,
      montantNet: resultat.montantNet
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Effectuer un retrait
const effectuerRetrait = async (req, res) => {
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

    // Simuler l'appel opérateur AVANT la transaction
    const resultat = await simulerOperateur(operateur, numero, montant, 'retrait');

    if (resultat.statut === 'echec') {
      return res.status(400).json({ message: resultat.message });
    }

    // Transaction Prisma sans délai
    await prisma.$transaction(async (tx) => {
      const nouvelleTransaction = await tx.transaction.create({
        data: {
          type: 'retrait',
          montant,
          frais: resultat.frais,
          statut: 'confirme',
          reference: resultat.reference,
          compteId: compte.id
        }
      });

      await tx.compte.update({
        where: { id: compte.id },
        data: { soldePrincipal: { decrement: resultat.montantNet } }
      });

      await tx.historique.create({
        data: {
          typeOperation: 'retrait',
          montant,
          statut: 'confirme',
          description: `Retrait via ${operateur} - ${numero}`,
           operateur: operateur,
          revendeurId: req.revendeur.id,
          transactionId: nouvelleTransaction.id
        }
      });
    });
  await creerNotification(
  req.revendeur.id,
  'Retrait effectué',
  `Retrait de ${montant} FCFA via ${operateur} effectué avec succès. Référence: ${resultat.reference}`
);
    res.status(201).json({
      message: 'Retrait effectué avec succès',
      reference: resultat.reference,
      montant,
      frais: resultat.frais,
      montantNet: resultat.montantNet
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};
// Consulter les transactions
const consulterTransactions = async (req, res) => {
  try {
    const compte = await prisma.compte.findUnique({
      where: { revendeurId: req.revendeur.id }
    });

    if (!compte) {
      return res.status(404).json({ message: 'Compte introuvable' });
    }

    const transactions = await prisma.transaction.findMany({
      where: { compteId: compte.id },
      orderBy: { date: 'desc' }
    });

    res.status(200).json({ transactions });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = { effectuerDepot, effectuerRetrait, consulterTransactions };