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



app.use('/api/auth', authRoutes);
app.use('/api/compte', compteRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/historique', historiqueRoutes);
app.use('/api/vendre', vendreRoutes);
app.use('/api/services', autresServicesRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/parametres', parametreRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});

module.exports = app;