const pool = require('../config/db');

const Transaction = {
    create: async (data) => {
        const query = `
            INSERT INTO transactions (operateur, type_op, montant, numero_destinataire, frais)
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *`;
        const values = [
            data.operateur, 
            data.type_op, 
            data.montant, 
            data.numero_destinataire,
            data.frais || 0
        ];
        const res = await pool.query(query, values);
        return res.rows[0];
    }
};

module.exports = Transaction;