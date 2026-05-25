const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  }
});

const envoyerHistoriqueJournalier = async (email, nom, historique, totalCommissions) => {
  const lignes = historique.map(op => `
    <tr>
      <td style="padding:8px;border:1px solid #ddd;">${op.typeOperation.toUpperCase()}</td>
      <td style="padding:8px;border:1px solid #ddd;">${op.description}</td>
      <td style="padding:8px;border:1px solid #ddd;">${op.montant} F</td>
      <td style="padding:8px;border:1px solid #ddd;">${op.statut}</td>
      <td style="padding:8px;border:1px solid #ddd;">${new Date(op.date).toLocaleTimeString('fr-FR')}</td>
    </tr>
  `).join('');

  const html = `
    <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;">
      <div style="background:linear-gradient(135deg,#00A859,#78B596);padding:20px;border-radius:10px 10px 0 0;">
        <h1 style="color:white;margin:0;">MultiPay-Bénin</h1>
        <p style="color:white;margin:5px 0;">Rapport journalier du ${new Date().toLocaleDateString('fr-FR')}</p>
      </div>
      
      <div style="padding:20px;background:#f9f9f9;">
        <p>Bonjour <strong>${nom}</strong>,</p>
        <p>Voici le résumé de vos activités d'aujourd'hui :</p>
        
        <div style="background:white;padding:15px;border-radius:8px;margin:15px 0;">
          <h3 style="color:#00A859;">💰 Commissions du jour</h3>
          <p style="font-size:24px;font-weight:bold;color:#00A859;">${totalCommissions.toFixed(0)} FCFA</p>
        </div>

        <div style="background:white;padding:15px;border-radius:8px;">
          <h3 style="color:#333;">📋 Détail des opérations</h3>
          ${historique.length === 0 
            ? '<p style="color:grey;">Aucune opération aujourd\'hui</p>'
            : `<table style="width:100%;border-collapse:collapse;">
                <thead>
                  <tr style="background:#00A859;color:white;">
                    <th style="padding:8px;">Type</th>
                    <th style="padding:8px;">Description</th>
                    <th style="padding:8px;">Montant</th>
                    <th style="padding:8px;">Statut</th>
                    <th style="padding:8px;">Heure</th>
                  </tr>
                </thead>
                <tbody>${lignes}</tbody>
              </table>`
          }
        </div>
        
        <p style="color:grey;font-size:12px;margin-top:20px;">
          Ce rapport est envoyé automatiquement chaque jour à minuit.<br>
          © 2026 MultiPay-Bénin
        </p>
      </div>
    </div>
  `;

  await transporter.sendMail({
    from: `"MultiPay-Bénin" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: `📊 Rapport journalier MultiPay - ${new Date().toLocaleDateString('fr-FR')}`,
    html
  });
};

module.exports = { envoyerHistoriqueJournalier };