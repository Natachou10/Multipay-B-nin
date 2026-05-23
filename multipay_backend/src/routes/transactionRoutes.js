const express = require('express');
const router = express.Router();
const { effectuerDepot, effectuerRetrait, consulterTransactions } = require('../controllers/transactionController');
const verifierToken = require('../middlewares/authMiddleware');

router.post('/depot', verifierToken, effectuerDepot);
router.post('/retrait', verifierToken, effectuerRetrait);
router.get('/', verifierToken, consulterTransactions);

module.exports = router;