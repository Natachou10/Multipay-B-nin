const express = require('express');
const router = express.Router();
const { vendreCredit, vendreForfait, listerForfaits, creerForfait } = require('../controllers/vendreController');
const verifierToken = require('../middlewares/authMiddleware');

router.post('/credit', verifierToken, vendreCredit);
router.post('/forfait', verifierToken, vendreForfait);
router.get('/forfaits', verifierToken, listerForfaits);
router.post('/forfaits', verifierToken, creerForfait);

module.exports = router;
