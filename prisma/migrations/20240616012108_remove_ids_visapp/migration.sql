/*
  Warnings:

  - You are about to drop the column `agentId` on the `VisaApplication` table. All the data in the column will be lost.
  - You are about to drop the column `employerId` on the `VisaApplication` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "VisaApplication" DROP COLUMN "agentId",
DROP COLUMN "employerId";
