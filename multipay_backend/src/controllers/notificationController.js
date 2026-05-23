const prisma = require('../config/prisma');

// Consulter les notifications
const consulterNotifications = async (req, res) => {
  try {
    const notifications = await prisma.notification.findMany({
      where: { revendeurId: req.revendeur.id },
      orderBy: { date: 'desc' }
    });

    res.status(200).json({ notifications });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Marquer une notification comme lue
const marquerCommeLue = async (req, res) => {
  const { id } = req.params;

  try {
    const notification = await prisma.notification.update({
      where: { id: parseInt(id) },
      data: { lu: true }
    });

    res.status(200).json({ message: 'Notification marquée comme lue', notification });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Marquer toutes les notifications comme lues
const marquerToutesCommeLues = async (req, res) => {
  try {
    await prisma.notification.updateMany({
      where: { revendeurId: req.revendeur.id, lu: false },
      data: { lu: true }
    });

    res.status(200).json({ message: 'Toutes les notifications marquées comme lues' });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Créer une notification (utilitaire interne)
const creerNotification = async (revendeurId, titre, message) => {
  await prisma.notification.create({
    data: { revendeurId, titre, message }
  });
};

module.exports = { consulterNotifications, marquerCommeLue, marquerToutesCommeLues, creerNotification };