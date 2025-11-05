import { NextRequest, NextResponse } from "next/server"
import { getCampaigns } from "@/lib/actions/campaigns"

export async function GET(req: NextRequest) {
  const searchParams = req.nextUrl.searchParams
  const status = searchParams.get("status") || "active"
  const limit = parseInt(searchParams.get("limit") || "10")

  try {
    const result = await getCampaigns(status)
    
    if (result.error) {
      return NextResponse.json({ error: result.error }, { status: 500 })
    }

    // Limit results
    const campaigns = (result.campaigns || []).slice(0, limit)

    return NextResponse.json({ campaigns })
  } catch (err) {
    console.error("/api/campaigns error", err)
    return NextResponse.json({ error: "Failed to fetch campaigns" }, { status: 500 })
  }
}

