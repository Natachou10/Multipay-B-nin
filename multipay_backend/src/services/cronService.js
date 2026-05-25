const cron = require('node-cron');
const prisma = require('../config/prisma');
const { envoyerHistoriqueJournalier } = require('./emailService');

const demarrerCron = () => {
  // Exécute tous les jours à minuit (00:00)
  cron.schedule('0 0 * * *', async () => {
    console.log('📧 Envoi des rapports journaliers...');

    try {
      const revendeurs = await prisma.revendeur.findMany({
        include: { compte: true }
      });

      const aujourd_hui = new Date();
      aujourd_hui.setHours(0, 0, 0, 0);

      for (const revendeur of revendeurs) {
        const historique = await prisma.historique.findMany({
          where: {
            revendeurId: revendeur.id,
            date: { gte: aujourd_hui }
          },
          orderBy: { date: 'asc' }
        });

        // Calculer commissions du jour
        let totalCommissions = 0;
        for (const op of historique) {
          let taux = 0;
          if (op.typeOperation === 'depot') taux = 0.006;
          else if (op.typeOperation === 'retrait') taux = 0.03;
          else taux = 0.05;
          totalCommissions += Number(op.montant) * taux;
        }

        await envoyerHistoriqueJournalier(
          revendeur.email,
          revendeur.nom,
          historique,
          totalCommissions
        );

        console.log(`✅ Rapport envoyé à ${revendeur.email}`);
      }

    } catch (error) {
      console.error('Erreur cron:', error.message);
    }
  }, {
    timezone: 'Africa/Porto-Novo' // Fuseau horaire du Bénin
  });

  console.log('⏰ Cron job démarré - Rapports envoyés à minuit');
};

module.exports = { demarrerCron };