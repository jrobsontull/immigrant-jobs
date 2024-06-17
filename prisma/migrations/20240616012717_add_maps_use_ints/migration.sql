/*
  Warnings:

  - You are about to drop the `Account` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Employer` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `EmployerContact` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Session` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `VerificationToken` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `VisaApplication` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Worksite` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Account" DROP CONSTRAINT "Account_userId_fkey";

-- DropForeignKey
ALTER TABLE "Agent" DROP CONSTRAINT "Agent_visaApplicationId_fkey";

-- DropForeignKey
ALTER TABLE "Employer" DROP CONSTRAINT "Employer_visaApplicationId_fkey";

-- DropForeignKey
ALTER TABLE "EmployerContact" DROP CONSTRAINT "EmployerContact_employerId_fkey";

-- DropForeignKey
ALTER TABLE "Session" DROP CONSTRAINT "Session_userId_fkey";

-- DropForeignKey
ALTER TABLE "Worksite" DROP CONSTRAINT "Worksite_visaApplicationId_fkey";

-- DropTable
DROP TABLE "Account";

-- DropTable
DROP TABLE "Employer";

-- DropTable
DROP TABLE "EmployerContact";

-- DropTable
DROP TABLE "Session";

-- DropTable
DROP TABLE "User";

-- DropTable
DROP TABLE "VerificationToken";

-- DropTable
DROP TABLE "VisaApplication";

-- DropTable
DROP TABLE "Worksite";

-- CreateTable
CREATE TABLE "account" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "userId" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,
    "refresh_token_expires_in" INTEGER,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "sessionToken" TEXT NOT NULL,
    "userId" UUID NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification_token" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "employer" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "address1" TEXT NOT NULL,
    "address2" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "province" TEXT NOT NULL DEFAULT '',
    "phone" TEXT NOT NULL,
    "phone_ext" TEXT NOT NULL DEFAULT '',
    "visaApplicationId" UUID NOT NULL,

    CONSTRAINT "employer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employer_contact" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "lastName" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "middleName" TEXT NOT NULL DEFAULT '',
    "jobTitle" TEXT NOT NULL,
    "address1" TEXT NOT NULL,
    "address2" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "province" TEXT NOT NULL DEFAULT '',
    "phone" TEXT NOT NULL,
    "phone_ext" TEXT NOT NULL DEFAULT '',
    "email" TEXT NOT NULL,
    "employerId" UUID NOT NULL,

    CONSTRAINT "employer_contact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "worksite" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "address1" TEXT NOT NULL,
    "address2" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL,
    "county" TEXT NOT NULL DEFAULT '',
    "state" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "visaApplicationId" UUID NOT NULL,

    CONSTRAINT "worksite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "visa_application" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_number" TEXT NOT NULL,
    "case_status" TEXT NOT NULL,
    "received_date" TIMESTAMP(3) NOT NULL,
    "decision_date" TIMESTAMP(3) NOT NULL,
    "visa_class" TEXT NOT NULL,
    "job_title" TEXT NOT NULL,
    "soc_code" TEXT NOT NULL,
    "soc_title" TEXT NOT NULL,
    "full_time_position" BOOLEAN NOT NULL,
    "begin_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "total_worker_positions" INTEGER NOT NULL DEFAULT 0,
    "wage_rate_of_pay_from" INTEGER NOT NULL DEFAULT 0,
    "wage_rate_of_pay_to" INTEGER NOT NULL DEFAULT 0,
    "wage_unit_of_pay" TEXT NOT NULL,
    "prevailing_wage" INTEGER NOT NULL DEFAULT 0,
    "total_worksite_locations" INTEGER NOT NULL DEFAULT 0,
    "agree_to_lc_statement" BOOLEAN NOT NULL,
    "h_1b_dependent" BOOLEAN NOT NULL,
    "willful_violator" BOOLEAN NOT NULL,

    CONSTRAINT "visa_application_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "account_provider_providerAccountId_key" ON "account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "session_sessionToken_key" ON "session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "verification_token_token_key" ON "verification_token"("token");

-- CreateIndex
CREATE UNIQUE INDEX "verification_token_identifier_token_key" ON "verification_token"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "employer_visaApplicationId_key" ON "employer"("visaApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "employer_contact_employerId_key" ON "employer_contact"("employerId");

-- CreateIndex
CREATE UNIQUE INDEX "worksite_visaApplicationId_key" ON "worksite"("visaApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "visa_application_case_number_key" ON "visa_application"("case_number");

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employer" ADD CONSTRAINT "employer_visaApplicationId_fkey" FOREIGN KEY ("visaApplicationId") REFERENCES "visa_application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employer_contact" ADD CONSTRAINT "employer_contact_employerId_fkey" FOREIGN KEY ("employerId") REFERENCES "employer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agent" ADD CONSTRAINT "Agent_visaApplicationId_fkey" FOREIGN KEY ("visaApplicationId") REFERENCES "visa_application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worksite" ADD CONSTRAINT "worksite_visaApplicationId_fkey" FOREIGN KEY ("visaApplicationId") REFERENCES "visa_application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
