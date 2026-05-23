/*
  Warnings:

  - You are about to drop the column `telephone` on the `Revendeur` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "Revendeur_telephone_key";

-- AlterTable
ALTER TABLE "Revendeur" DROP COLUMN "telephone";
