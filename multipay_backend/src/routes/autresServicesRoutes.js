const express = require('express');
const router = express.Router();
const { payerService } = require('../controllers/autresServicesController');
const verifierToken = require('../middlewares/authMiddleware');

router.post('/payer', verifierToken, payerService);

module.exports = router;