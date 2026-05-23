const prisma = require('../config/prisma');
const { simulerOperateur } = require('../services/operateurService');

const payerService = async (req, res) => {
  const { typeService, montant, reference, details } = req.body;

  const servicesDisponibles = ['sbee', 'soneb', 'canal', 'scolarite'];

  if (!servicesDisponibles.includes(typeService.toLowerCase())) {
    return res.status(400).json({ message: 'Service non disponible' });
  }

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

    // Simuler l'appel au service
    const resultat = await simulerOperateur(typeService, reference, montant, 'credit');

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
          typeOperation: typeService.toLowerCase(),
          montant,
          statut: 'confirme',
          description: `Paiement ${typeService.toUpperCase()} - Réf: ${reference} ${details ? '- ' + details : ''}`,
          revendeurId: req.revendeur.id
        }
      });
    });

    res.status(201).json({
      message: `Paiement ${typeService.toUpperCase()} effectué avec succès`,
      reference: resultat.reference,
      typeService,
      montant,
      profit: resultat.frais,
      details
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = { payerService };