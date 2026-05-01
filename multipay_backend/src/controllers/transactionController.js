const Transaction = require('../models/transactionModel');

exports.saveTransaction = async (req, res) => {
    try {
        const newTransaction = await Transaction.create(req.body);
        res.status(201).json({
            success: true,
            message: "Transaction enregistrée avec succès",
            data: newTransaction
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};