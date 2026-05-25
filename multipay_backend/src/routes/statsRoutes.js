const express = require('express');
const router = express.Router();
const { consulterStats } = require('../controllers/statsController');
const verifierToken = require('../middlewares/authMiddleware');

router.get('/', verifierToken, consulterStats);

module.exports = router;