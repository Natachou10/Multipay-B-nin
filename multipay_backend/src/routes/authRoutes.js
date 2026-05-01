const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/balances', (req, res) => {
    // Simulation en attendant de lier à PostgreSQL
    res.json({ mtn: "50 000", moov: "12 500", celtiis: "7 800" });
});
router.post('/transactions/new', (req, res) => {
    console.log("Transaction reçue:", req.body);
    res.json({ status: "Success", message: "Opération réussie" });
});
module.exports = router;