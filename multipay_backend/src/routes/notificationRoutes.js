const express = require('express');
const router = express.Router();
const { consulterNotifications, marquerCommeLue, marquerToutesCommeLues } = require('../controllers/notificationController');
const verifierToken = require('../middlewares/authMiddleware');

router.get('/', verifierToken, consulterNotifications);
router.patch('/:id/lue', verifierToken, marquerCommeLue);
router.patch('/toutes/lues', verifierToken, marquerToutesCommeLues);

module.exports = router;