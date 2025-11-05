# Скрипт для добавления Supabase переменных в Vercel
# Запустите: .\add-supabase-to-vercel.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$SupabaseUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$ServiceRoleKey,
    
    [Parameter(Mandatory=$false)]
    [string]$AnonKey = ""
)

$token = "90yDvxTtS7pSJxB6QhfYqp5X"
$projectId = "prj_VsqHkoeM952J8v5lmYfzFl4CaBPu"
$baseUrl = "https://api.vercel.com/v10/projects/$projectId/env"

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

Write-Host "Добавление Supabase переменных в Vercel..." -ForegroundColor Cyan

# Добавляем NEXT_PUBLIC_SUPABASE_URL
Write-Host "Добавление NEXT_PUBLIC_SUPABASE_URL..." -ForegroundColor Yellow
$body1 = @{
    key = "NEXT_PUBLIC_SUPABASE_URL"
    value = $SupabaseUrl
    type = "encrypted"
    target = @("production", "preview", "development")
} | ConvertTo-Json

try {
    $result1 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body1
    Write-Host "  ✓ NEXT_PUBLIC_SUPABASE_URL добавлен" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Ошибка: $_" -ForegroundColor Red
}

# Добавляем SUPABASE_SERVICE_ROLE_KEY
Write-Host "Добавление SUPABASE_SERVICE_ROLE_KEY..." -ForegroundColor Yellow
$body2 = @{
    key = "SUPABASE_SERVICE_ROLE_KEY"
    value = $ServiceRoleKey
    type = "encrypted"
    target = @("production", "preview", "development")
} | ConvertTo-Json

try {
    $result2 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body2
    Write-Host "  ✓ SUPABASE_SERVICE_ROLE_KEY добавлен" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Ошибка: $_" -ForegroundColor Red
}

# Добавляем NEXT_PUBLIC_SUPABASE_ANON_KEY если предоставлен
if ($AnonKey) {
    Write-Host "Добавление NEXT_PUBLIC_SUPABASE_ANON_KEY..." -ForegroundColor Yellow
    $body3 = @{
        key = "NEXT_PUBLIC_SUPABASE_ANON_KEY"
        value = $AnonKey
        type = "encrypted"
        target = @("production", "preview", "development")
    } | ConvertTo-Json

    try {
        $result3 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body3
        Write-Host "  ✓ NEXT_PUBLIC_SUPABASE_ANON_KEY добавлен" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Ошибка: $_" -ForegroundColor Red
    }
}

Write-Host "`nГотово! Переменные добавлены в Vercel." -ForegroundColor Green
Write-Host "Теперь добавьте их также в GitHub Secrets:" -ForegroundColor Cyan
Write-Host "https://github.com/ahmed11551/SadakaPass/settings/secrets/actions" -ForegroundColor Yellow

