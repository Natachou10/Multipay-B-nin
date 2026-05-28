const prisma = require('../config/prisma');

const consulterStats = async (req, res) => {
  try {
    const revendeurId = req.revendeur.id;

    const historique = await prisma.historique.findMany({
      where: { revendeurId }
    });

    const stats = {};
    const statsOperateurs = {
      MTN: { count: 0, montant: 0, commissions: 0 },
      MOOV: { count: 0, montant: 0, commissions: 0 },
      CELTIIS: { count: 0, montant: 0, commissions: 0 }
    };
    let totalCommissions = 0;
    let commissionsJour = 0;
    const aujourd_hui = new Date().toDateString();

    for (const op of historique) {
      const type = op.typeOperation;

      // Stats par type
      if (!stats[type]) {
        stats[type] = { count: 0, montantTotal: 0, commissions: 0 };
      }
      stats[type].count++;
      stats[type].montantTotal += Number(op.montant);

      // Calcul commissions
      let taux = 0;
      if (type === 'depot') taux = 0.006;
      else if (type === 'retrait') taux = 0.03;
      else taux = 0.05;

      const commission = Number(op.montant) * taux;
      stats[type].commissions += commission;
      totalCommissions += commission;

      // Commissions du jour
      if (new Date(op.date).toDateString() === aujourd_hui) {
        commissionsJour += commission;
      }

      // Stats par opérateur
      if (op.operateur && statsOperateurs[op.operateur]) {
        statsOperateurs[op.operateur].count++;
        statsOperateurs[op.operateur].montant += Number(op.montant);
        statsOperateurs[op.operateur].commissions += commission;
      }
    }

    // Évolution 7 jours
    const evolution = [];
    for (let i = 6; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const dateStr = date.toDateString();

      const opsJour = historique.filter(op =>
        new Date(op.date).toDateString() === dateStr
      );

      const montantJour = opsJour.reduce((sum, op) => sum + Number(op.montant), 0);

      evolution.push({
        jour: date.toLocaleDateString('fr-FR', { weekday: 'short' }),
        montant: montantJour,
        nombre: opsJour.length
      });
    }

    res.status(200).json({
      totalCommissions,
      commissionsJour,
      stats,
      statsOperateurs,
      evolution
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = { consulterStats };