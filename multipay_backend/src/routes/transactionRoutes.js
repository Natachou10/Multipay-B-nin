const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transactionController');
const auth = require('../middleware/authMiddleware');

// Cette ligne est la plus importante : le 'auth' verrouille la route
router.post('/add', auth, transactionController.saveTransaction);

module.exports = router;