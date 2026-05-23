-- CreateTable
CREATE TABLE "Revendeur" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,
    "telephone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "motDePasse" TEXT NOT NULL,
    "dateInscription" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Revendeur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Compte" (
    "id" SERIAL NOT NULL,
    "soldePrincipal" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "codePin" TEXT NOT NULL,
    "statut" TEXT NOT NULL DEFAULT 'actif',
    "dateCreation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revendeurId" INTEGER NOT NULL,

    CONSTRAINT "Compte_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompteOperateur" (
    "id" SERIAL NOT NULL,
    "operateur" TEXT NOT NULL,
    "numero" TEXT NOT NULL,
    "solde" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "statut" TEXT NOT NULL DEFAULT 'actif',
    "revendeurId" INTEGER NOT NULL,

    CONSTRAINT "CompteOperateur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "montant" DECIMAL(65,30) NOT NULL,
    "frais" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "statut" TEXT NOT NULL DEFAULT 'en_attente',
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reference" TEXT NOT NULL,
    "compteId" INTEGER NOT NULL,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Historique" (
    "id" SERIAL NOT NULL,
    "typeOperation" TEXT NOT NULL,
    "montant" DECIMAL(65,30) NOT NULL,
    "statut" TEXT NOT NULL,
    "description" TEXT,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revendeurId" INTEGER NOT NULL,
    "transactionId" INTEGER,

    CONSTRAINT "Historique_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Forfait" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "prix" DECIMAL(65,30) NOT NULL,
    "validite" INTEGER NOT NULL,
    "description" TEXT,
    "minutes" INTEGER,
    "volumeData" TEXT,

    CONSTRAINT "Forfait_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" SERIAL NOT NULL,
    "titre" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lu" BOOLEAN NOT NULL DEFAULT false,
    "revendeurId" INTEGER NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Parametre" (
    "id" SERIAL NOT NULL,
    "cle" TEXT NOT NULL,
    "valeur" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Parametre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemeOperateurs" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,
    "apiEndpoint" TEXT NOT NULL,
    "statut" TEXT NOT NULL DEFAULT 'actif',

    CONSTRAINT "SystemeOperateurs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarifFrais" (
    "id" SERIAL NOT NULL,
    "typeOperation" TEXT NOT NULL,
    "operateur" TEXT,
    "pourcentage" DECIMAL(65,30) NOT NULL,

    CONSTRAINT "TarifFrais_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Revendeur_telephone_key" ON "Revendeur"("telephone");

-- CreateIndex
CREATE UNIQUE INDEX "Revendeur_email_key" ON "Revendeur"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Compte_revendeurId_key" ON "Compte"("revendeurId");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_reference_key" ON "Transaction"("reference");

-- CreateIndex
CREATE UNIQUE INDEX "Historique_transactionId_key" ON "Historique"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "Parametre_cle_key" ON "Parametre"("cle");

-- AddForeignKey
ALTER TABLE "Compte" ADD CONSTRAINT "Compte_revendeurId_fkey" FOREIGN KEY ("revendeurId") REFERENCES "Revendeur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompteOperateur" ADD CONSTRAINT "CompteOperateur_revendeurId_fkey" FOREIGN KEY ("revendeurId") REFERENCES "Revendeur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_compteId_fkey" FOREIGN KEY ("compteId") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Historique" ADD CONSTRAINT "Historique_revendeurId_fkey" FOREIGN KEY ("revendeurId") REFERENCES "Revendeur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Historique" ADD CONSTRAINT "Historique_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_revendeurId_fkey" FOREIGN KEY ("revendeurId") REFERENCES "Revendeur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
