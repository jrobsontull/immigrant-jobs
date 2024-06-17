-- CreateTable
CREATE TABLE "Account" (
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

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "sessionToken" TEXT NOT NULL,
    "userId" UUID NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Employer" (
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

    CONSTRAINT "Employer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployerContact" (
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

    CONSTRAINT "EmployerContact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Agent" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "lastName" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "middleName" TEXT NOT NULL DEFAULT '',
    "address1" TEXT NOT NULL,
    "address2" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "province" TEXT NOT NULL DEFAULT '',
    "phone" TEXT NOT NULL,
    "phone_ext" TEXT NOT NULL DEFAULT '',
    "email_address" TEXT NOT NULL,
    "lawfirm_name_business" TEXT NOT NULL,
    "visaApplicationId" UUID NOT NULL,

    CONSTRAINT "Agent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Worksite" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "address1" TEXT NOT NULL,
    "address2" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL,
    "county" TEXT NOT NULL DEFAULT '',
    "state" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "visaApplicationId" UUID NOT NULL,

    CONSTRAINT "Worksite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VisaApplication" (
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
    "total_worker_positions" INTEGER NOT NULL,
    "employerId" TEXT NOT NULL,
    "agentId" TEXT NOT NULL,
    "worksiteId" TEXT NOT NULL,
    "wage_rate_of_pay_from" DOUBLE PRECISION NOT NULL,
    "wage_rate_of_pay_to" DOUBLE PRECISION,
    "wage_unit_of_pay" TEXT NOT NULL,
    "prevailing_wage" DOUBLE PRECISION NOT NULL,
    "total_worksite_locations" INTEGER NOT NULL,
    "agree_to_lc_statement" BOOLEAN NOT NULL,
    "h_1b_dependent" BOOLEAN NOT NULL,
    "willful_violator" BOOLEAN NOT NULL,

    CONSTRAINT "VisaApplication_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "Employer_visaApplicationId_key" ON "Employer"("visaApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "EmployerContact_employerId_key" ON "EmployerContact"("employerId");

-- CreateIndex
CREATE UNIQUE INDEX "Agent_visaApplicationId_key" ON "Agent"("visaApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "Worksite_visaApplicationId_key" ON "Worksite"("visaApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "VisaApplication_case_number_key" ON "VisaApplication"("case_number");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employer" ADD CONSTRAINT "Employer_visaApplicationId_fkey" FOREIGN KEY ("visaApplicationId") REFERENCES "VisaApplication"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployerContact" ADD CONSTRAINT "EmployerContact_employerId_fkey" FOREIGN KEY ("employerId") REFERENCES "Employer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agent" ADD CONSTRAINT "Agent_visaApplicationId_fkey" FOREIGN KEY ("visaApplicationId") REFERENCES "VisaApplication"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Worksite" ADD CONSTRAINT "Worksite_visaApplicationId_fkey" FOREIGN KEY ("visaApplicationId") REFERENCES "VisaApplication"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
