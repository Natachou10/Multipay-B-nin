const prisma = require('../config/prisma');

// Consulter tout l'historique
const consulterHistorique = async (req, res) => {
  try {
    const historique = await prisma.historique.findMany({
      where: { revendeurId: req.revendeur.id },
      orderBy: { date: 'desc' }
    });

    res.status(200).json({ historique });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Consulter historique par type d'opération
const consulterHistoriqueParType = async (req, res) => {
  const { type } = req.params;

  try {
    const historique = await prisma.historique.findMany({
      where: {
        revendeurId: req.revendeur.id,
        typeOperation: type
      },
      orderBy: { date: 'desc' }
    });

    res.status(200).json({ historique });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = { consulterHistorique, consulterHistoriqueParType };