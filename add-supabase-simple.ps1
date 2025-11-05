# Simple script to add Supabase env vars to Vercel
# Usage: .\add-supabase-simple.ps1 -SupabaseUrl "https://xxx.supabase.co" -AnonKey "eyJ..." -ServiceKey "eyJ..."

param(
    [Parameter(Mandatory=$true)]
    [string]$SupabaseUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$AnonKey,
    
    [Parameter(Mandatory=$false)]
    [string]$ServiceKey = ""
)

$token = "90yDvxTtS7pSJxB6QhfYqp5X"
$projectId = "prj_VsqHkoeM952J8v5lmYfzFl4CaBPu"
$baseUrl = "https://api.vercel.com/v10/projects/$projectId/env"

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$environments = @("production", "preview", "development")

Write-Host "Adding Supabase env vars to Vercel..." -ForegroundColor Cyan

# Add NEXT_PUBLIC_SUPABASE_URL
$body1 = @{
    key = "NEXT_PUBLIC_SUPABASE_URL"
    value = $SupabaseUrl
    type = "encrypted"
    target = $environments
} | ConvertTo-Json -Depth 3

try {
    $result1 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body1
    Write-Host "  [OK] NEXT_PUBLIC_SUPABASE_URL added" -ForegroundColor Green
} catch {
    Write-Host "  [WARN] NEXT_PUBLIC_SUPABASE_URL: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Add NEXT_PUBLIC_SUPABASE_ANON_KEY
$body2 = @{
    key = "NEXT_PUBLIC_SUPABASE_ANON_KEY"
    value = $AnonKey
    type = "encrypted"
    target = $environments
} | ConvertTo-Json -Depth 3

try {
    $result2 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body2
    Write-Host "  [OK] NEXT_PUBLIC_SUPABASE_ANON_KEY added" -ForegroundColor Green
} catch {
    Write-Host "  [WARN] NEXT_PUBLIC_SUPABASE_ANON_KEY: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Add SUPABASE_SERVICE_ROLE_KEY if provided
if ($ServiceKey) {
    $body3 = @{
        key = "SUPABASE_SERVICE_ROLE_KEY"
        value = $ServiceKey
        type = "encrypted"
        target = $environments
    } | ConvertTo-Json -Depth 3

    try {
        $result3 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body3
        Write-Host "  [OK] SUPABASE_SERVICE_ROLE_KEY added" -ForegroundColor Green
    } catch {
        Write-Host "  [WARN] SUPABASE_SERVICE_ROLE_KEY: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Done! Vercel will automatically redeploy." -ForegroundColor Green


