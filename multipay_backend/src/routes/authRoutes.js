const express = require('express');
const router = express.Router();
const { inscrire, connecter } = require('../controllers/authController');

router.post('/inscrire', inscrire);
router.post('/connecter', connecter);

module.exports = router;