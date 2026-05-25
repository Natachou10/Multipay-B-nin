const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const prisma = require('../config/prisma');

// Inscription
const inscrire = async (req, res) => {
  console.log('Body reçu:', req.body);
  const { nom, email, motDePasse, codePin } = req.body;

  try {
    const existant = await prisma.revendeur.findFirst({
      where: { email }
    });

    if (existant) {
      return res.status(400).json({ message: 'Email déjà utilisé' });
    }

    if (!/^\d{5}$/.test(codePin)) {
      return res.status(400).json({ message: 'Le code PIN doit contenir exactement 5 chiffres' });
    }

    const motDePasseHash = await bcrypt.hash(motDePasse, 10);
    const codePinHash = await bcrypt.hash(codePin, 10);

    const revendeur = await prisma.revendeur.create({
      data: {
        nom,
        email,
        motDePasse: motDePasseHash,
        compte: {
          create: {
            codePin: codePinHash,
            soldePrincipal: 0
          }
        }
      },
      include: { compte: true }
    });

    const token = jwt.sign(
      { id: revendeur.id, email: revendeur.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.status(201).json({
      message: 'Inscription réussie',
      token,
      revendeur: {
        id: revendeur.id,
        nom: revendeur.nom,
        email: revendeur.email
      }
    });

  } catch (error) {
    console.log('ERREUR INSCRIPTION:', error.message);
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

// Connexion
const connecter = async (req, res) => {
  const { email, motDePasse } = req.body;

  try {
    const revendeur = await prisma.revendeur.findUnique({ where: { email } });

    if (!revendeur) {
      return res.status(404).json({ message: 'Revendeur introuvable' });
    }

    const motDePasseValide = await bcrypt.compare(motDePasse, revendeur.motDePasse);

    if (!motDePasseValide) {
      return res.status(401).json({ message: 'Mot de passe incorrect' });
    }

    const token = jwt.sign(
      { id: revendeur.id, email: revendeur.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.status(200).json({
      message: 'Connexion réussie',
      token,
      revendeur: {
        id: revendeur.id,
        nom: revendeur.nom,
        email: revendeur.email,
      }
    });

  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', erreur: error.message });
  }
};

module.exports = { inscrire, connecter };