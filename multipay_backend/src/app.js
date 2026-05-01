const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const transactionRoutes = require('./routes/transactionRoutes');
require('dotenv').config();

const app = express();

// Middlewares
app.use(cors()); // Autorise Tony à se connecter depuis l'app mobile
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/transactions', transactionRoutes);

// Route de base pour vérifier que l'API vit
app.get('/', (req, res) => {
    res.send('🚀 Serveur Multi-Pay Bénin opérationnel !');
});

const PORT = process.env.PORT || 5000;

// Utiliser '0.0.0.0' permet au serveur d'écouter sur TOUTES les adresses du PC
// C'est beaucoup plus flexible que de mettre l'IP fixe ici.
app.listen(PORT, '0.0.0.0', () => {
    console.log('-------------------------------------------');
    console.log(`🚀 Serveur Multi-Pay démarré !`);
    console.log(`🏠 Local: http://localhost:${PORT}`);
    console.log(`🌐 Réseau: http://192.168.135.33:${PORT}`);
    console.log('-------------------------------------------');
});