const pool = require('../config/db');

const User = {
    // Créer un compte
    create: async (userData) => {
        const query = `
            INSERT INTO users (nom_complet, telephone, mot_de_passe)
            VALUES ($1, $2, $3) RETURNING id, nom_complet, telephone`;
        const values = [userData.nom_complet, userData.telephone, userData.mot_de_passe];
        const res = await pool.query(query, values);
        return res.rows[0];
    },
    // Trouver un utilisateur par son téléphone (pour le login)
    findByPhone: async (telephone) => {
        const res = await pool.query('SELECT * FROM users WHERE telephone = $1', [telephone]);
        return res.rows[0];
    }
};

module.exports = User;