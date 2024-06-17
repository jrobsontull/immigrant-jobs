-- DropForeignKey
ALTER TABLE "Agent" DROP CONSTRAINT "Agent_visa_application_id_fkey";

-- DropForeignKey
ALTER TABLE "employer" DROP CONSTRAINT "employer_visa_application_id_fkey";

-- DropForeignKey
ALTER TABLE "employer_contact" DROP CONSTRAINT "employer_contact_employer_id_fkey";

-- DropForeignKey
ALTER TABLE "worksite" DROP CONSTRAINT "worksite_visa_application_id_fkey";

-- AddForeignKey
ALTER TABLE "employer" ADD CONSTRAINT "employer_visa_application_id_fkey" FOREIGN KEY ("visa_application_id") REFERENCES "visa_application"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employer_contact" ADD CONSTRAINT "employer_contact_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "employer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agent" ADD CONSTRAINT "Agent_visa_application_id_fkey" FOREIGN KEY ("visa_application_id") REFERENCES "visa_application"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worksite" ADD CONSTRAINT "worksite_visa_application_id_fkey" FOREIGN KEY ("visa_application_id") REFERENCES "visa_application"("id") ON DELETE CASCADE ON UPDATE CASCADE;
