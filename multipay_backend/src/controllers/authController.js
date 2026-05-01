const User = require('../models/userModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
require('dotenv').config();

// Fonction d'inscription (Register)
exports.register = async (req, res) => {
    try {
        const { nom_complet, telephone, mot_de_passe } = req.body;

        // 1. Vérifier si l'utilisateur existe déjà
        const userExists = await User.findByPhone(telephone);
        if (userExists) {
            return res.status(400).json({ message: "Ce numéro de téléphone est déjà utilisé." });
        }

        // 2. Crypter le mot de passe (Sécurité cruciale pour le mémoire)
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(mot_de_passe, salt);

        // 3. Créer l'utilisateur en base
        const newUser = await User.create({
            nom_complet,
            telephone,
            mot_de_passe: hashedPassword
        });

        res.status(201).json({
            success: true,
            message: "Compte agent créé avec succès !",
            user: newUser
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Fonction de connexion (Login)
exports.login = async (req, res) => {
    try {
        const { telephone, mot_de_passe } = req.body;

        const user = await User.findByPhone(telephone);
        if (!user) {
            return res.status(404).json({ message: "Utilisateur non trouvé." });
        }

        const isMatch = await bcrypt.compare(mot_de_passe, user.mot_de_passe);
        if (!isMatch) {
            return res.status(400).json({ message: "Mot de passe incorrect." });
        }

        const token = jwt.sign(
            { id: user.id, telephone: user.telephone },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );

        res.status(200).json({
            success: true,
            message: "Connexion réussie",
            token,
            user: {
                id: user.id,
                nom_complet: user.nom_complet,
                telephone: user.telephone
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};