class Constants {
  // Remplace par l'IP de ton PC
  static const String baseUrl = 'http://10.0.0.65:5000/api';  
  // Auth
  static const String inscriptionUrl = '$baseUrl/auth/inscrire';
  static const String connexionUrl = '$baseUrl/auth/connecter';
  
  // Compte
  static const String soldeUrl = '$baseUrl/compte/solde';
  static const String verifierPinUrl = '$baseUrl/compte/verifier-pin';
  static const String verrouillerUrl = '$baseUrl/compte/verrouiller'; 
  static const String deverrouillerUrl = '$baseUrl/compte/deverrouiller';
  
  // Transactions
  static const String depotUrl = '$baseUrl/transactions/depot';
  static const String retraitUrl = '$baseUrl/transactions/retrait';
  static const String transactionsUrl = '$baseUrl/transactions';
  
  // Historique
  static const String historiqueUrl = '$baseUrl/historique';
  
  // Vendre
  static const String vendreCreditUrl = '$baseUrl/vendre/credit';
  static const String vendreForfaitUrl = '$baseUrl/vendre/forfait';
  static const String forfaitsUrl = '$baseUrl/vendre/forfaits';
  
  // Services
  static const String payerServiceUrl = '$baseUrl/services/payer';
  
  // Notifications
  static const String notificationsUrl = '$baseUrl/notifications';
  
  // Paramètres
  static const String profilUrl = '$baseUrl/parametres/profil';
  static const String motDePasseUrl = '$baseUrl/parametres/mot-de-passe';
  static const String seuilsUrl = '$baseUrl/parametres/seuils';
  static const String fraisUrl = '$baseUrl/parametres/frais';
  static const String delaiActiviteUrl = '$baseUrl/parametres/delai-activite';
}