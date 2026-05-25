require('dotenv').config();
const express = require('express');
const app = express();

app.use(express.json());

// Routes (on les ajoutera au fur et à mesure)
const authRoutes = require('./routes/authRoutes');
const compteRoutes = require('./routes/compteRoutes');
const transactionRoutes = require('./routes/transactionRoutes');
const historiqueRoutes = require('./routes/historiqueRoutes');
const vendreRoutes = require('./routes/vendreRoutes');
const autresServicesRoutes = require('./routes/autresServicesRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const parametreRoutes = require('./routes/parametreRoutes');
const statsRoutes = require('./routes/statsRoutes');
const { demarrerCron } = require('./services/cronService');


app.use('/api/auth', authRoutes);
app.use('/api/compte', compteRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/historique', historiqueRoutes);
app.use('/api/vendre', vendreRoutes);
app.use('/api/services', autresServicesRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/parametres', parametreRoutes);
app.use('/api/stats', statsRoutes);


const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
  demarrerCron();
});

module.exports = app;