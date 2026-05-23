const express = require('express');
const router = express.Router();
const { consulterHistorique, consulterHistoriqueParType } = require('../controllers/historiqueController');
const verifierToken = require('../middlewares/authMiddleware');

router.get('/', verifierToken, consulterHistorique);
router.get('/:type', verifierToken, consulterHistoriqueParType);

module.exports = router;