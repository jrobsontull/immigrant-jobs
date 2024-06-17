/*
  Warnings:

  - You are about to drop the column `visaApplicationId` on the `Agent` table. All the data in the column will be lost.
  - You are about to drop the column `visaApplicationId` on the `employer` table. All the data in the column will be lost.
  - You are about to drop the column `employerId` on the `employer_contact` table. All the data in the column will be lost.
  - You are about to drop the column `visaApplicationId` on the `worksite` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[visa_application_id]` on the table `Agent` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[visa_application_id]` on the table `employer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[employer_id]` on the table `employer_contact` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[visa_application_id]` on the table `worksite` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `visa_application_id` to the `Agent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `visa_application_id` to the `employer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `employer_id` to the `employer_contact` table without a default value. This is not possible if the table is not empty.
  - Added the required column `visa_application_id` to the `worksite` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Agent" DROP CONSTRAINT "Agent_visaApplicationId_fkey";

-- DropForeignKey
ALTER TABLE "employer" DROP CONSTRAINT "employer_visaApplicationId_fkey";

-- DropForeignKey
ALTER TABLE "employer_contact" DROP CONSTRAINT "employer_contact_employerId_fkey";

-- DropForeignKey
ALTER TABLE "worksite" DROP CONSTRAINT "worksite_visaApplicationId_fkey";

-- DropIndex
DROP INDEX "Agent_visaApplicationId_key";

-- DropIndex
DROP INDEX "employer_visaApplicationId_key";

-- DropIndex
DROP INDEX "employer_contact_employerId_key";

-- DropIndex
DROP INDEX "worksite_visaApplicationId_key";

-- AlterTable
ALTER TABLE "Agent" DROP COLUMN "visaApplicationId",
ADD COLUMN     "visa_application_id" UUID NOT NULL;

-- AlterTable
ALTER TABLE "employer" DROP COLUMN "visaApplicationId",
ADD COLUMN     "visa_application_id" UUID NOT NULL;

-- AlterTable
ALTER TABLE "employer_contact" DROP COLUMN "employerId",
ADD COLUMN     "employer_id" UUID NOT NULL;

-- AlterTable
ALTER TABLE "worksite" DROP COLUMN "visaApplicationId",
ADD COLUMN     "visa_application_id" UUID NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Agent_visa_application_id_key" ON "Agent"("visa_application_id");

-- CreateIndex
CREATE UNIQUE INDEX "employer_visa_application_id_key" ON "employer"("visa_application_id");

-- CreateIndex
CREATE UNIQUE INDEX "employer_contact_employer_id_key" ON "employer_contact"("employer_id");

-- CreateIndex
CREATE UNIQUE INDEX "worksite_visa_application_id_key" ON "worksite"("visa_application_id");

-- AddForeignKey
ALTER TABLE "employer" ADD CONSTRAINT "employer_visa_application_id_fkey" FOREIGN KEY ("visa_application_id") REFERENCES "visa_application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employer_contact" ADD CONSTRAINT "employer_contact_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "employer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agent" ADD CONSTRAINT "Agent_visa_application_id_fkey" FOREIGN KEY ("visa_application_id") REFERENCES "visa_application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worksite" ADD CONSTRAINT "worksite_visa_application_id_fkey" FOREIGN KEY ("visa_application_id") REFERENCES "visa_application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
