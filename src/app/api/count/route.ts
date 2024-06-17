import { db } from "@/server/db";

export async function GET() {
  const count = await db.visaApplication.count({});
  return Response.json({ count: count });
}
