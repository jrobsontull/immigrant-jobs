/*
  Warnings:

  - You are about to drop the column `firstName` on the `Agent` table. All the data in the column will be lost.
  - You are about to drop the column `lastName` on the `Agent` table. All the data in the column will be lost.
  - You are about to drop the column `middleName` on the `Agent` table. All the data in the column will be lost.
  - You are about to drop the column `firstName` on the `employer_contact` table. All the data in the column will be lost.
  - You are about to drop the column `jobTitle` on the `employer_contact` table. All the data in the column will be lost.
  - You are about to drop the column `lastName` on the `employer_contact` table. All the data in the column will be lost.
  - You are about to drop the column `middleName` on the `employer_contact` table. All the data in the column will be lost.
  - Added the required column `first_name` to the `Agent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `Agent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `first_name` to the `employer_contact` table without a default value. This is not possible if the table is not empty.
  - Added the required column `job_title` to the `employer_contact` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `employer_contact` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Agent" DROP COLUMN "firstName",
DROP COLUMN "lastName",
DROP COLUMN "middleName",
ADD COLUMN     "first_name" TEXT NOT NULL,
ADD COLUMN     "last_name" TEXT NOT NULL,
ADD COLUMN     "middle_name" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "employer_contact" DROP COLUMN "firstName",
DROP COLUMN "jobTitle",
DROP COLUMN "lastName",
DROP COLUMN "middleName",
ADD COLUMN     "first_name" TEXT NOT NULL,
ADD COLUMN     "job_title" TEXT NOT NULL,
ADD COLUMN     "last_name" TEXT NOT NULL,
ADD COLUMN     "middle_name" TEXT NOT NULL DEFAULT '';
