const express = require('express');
const router = express.Router();
const {
  consulterProfil,
  modifierProfil,
  changerMotDePasse,
  consulterSeuils,
  modifierSeuil,
  consulterFrais,
  modifierDelaiActivite
} = require('../controllers/parametreController');
const verifierToken = require('../middlewares/authMiddleware');

router.get('/profil', verifierToken, consulterProfil);
router.patch('/profil', verifierToken, modifierProfil);
router.patch('/mot-de-passe', verifierToken, changerMotDePasse);
router.get('/seuils', verifierToken, consulterSeuils);
router.post('/seuils', verifierToken, modifierSeuil);
router.get('/frais', verifierToken, consulterFrais);
router.patch('/delai-activite', verifierToken, modifierDelaiActivite);

module.exports = router;