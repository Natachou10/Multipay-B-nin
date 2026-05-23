const express = require('express');
const router = express.Router();
const { consulterSolde, verifierPin, verrouiller, deverrouiller, configurerCompteOperateur } = require('../controllers/compteController');
const verifierToken = require('../middlewares/authMiddleware');


router.get('/solde', verifierToken, consulterSolde);
router.post('/verifier-pin', verifierToken, verifierPin);
router.patch('/verrouiller', verifierToken, verrouiller);
router.patch('/deverrouiller', verifierToken, deverrouiller);
router.post('/operateurs', verifierToken, configurerCompteOperateur);
module.exports = router;
