const jwt = require('jsonwebtoken');
require('dotenv').config();

module.exports = (req, res, next) => {
    // 1. Récupérer le token dans l'en-tête (header) de la requête
    const token = req.header('Authorization');

    // 2. Vérifier si le token existe
    if (!token) {
        return res.status(401).json({ message: "Accès refusé. Aucun token fourni." });
    }

    try {
        // 3. Vérifier et décoder le token (on enlève "Bearer " si Tony l'ajoute)
        const tokenClean = token.replace('Bearer ', '');
        const decoded = jwt.verify(tokenClean, process.env.JWT_SECRET);
        
        // 4. Ajouter les infos de l'agent à la requête
        req.user = decoded;
        next(); // On passe à l'étape suivante (le contrôleur)
    } catch (error) {
        res.status(400).json({ message: "Token invalide." });
    }
};