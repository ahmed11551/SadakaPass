# Скрипт для добавления недостающих Supabase переменных в Vercel
# ВАЖНО: Замените значения на ваши реальные из Supabase Dashboard

param(
    [Parameter(Mandatory=$true)]
    [string]$SupabaseUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$SupabaseAnonKey,
    
    [Parameter(Mandatory=$false)]
    [string]$ServiceRoleKey = ""
)

$token = "90yDvxTtS7pSJxB6QhfYqp5X"
$projectId = "prj_VsqHkoeM952J8v5lmYfzFl4CaBPu"
$baseUrl = "https://api.vercel.com/v10/projects/$projectId/env"

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$environments = @("production", "preview", "development")

Write-Host "Добавление Supabase переменных в Vercel..." -ForegroundColor Cyan
Write-Host ""

# Добавляем NEXT_PUBLIC_SUPABASE_URL
Write-Host "Добавление NEXT_PUBLIC_SUPABASE_URL..." -ForegroundColor Yellow
$body1 = @{
    key = "NEXT_PUBLIC_SUPABASE_URL"
    value = $SupabaseUrl
    type = "encrypted"
    target = $environments
} | ConvertTo-Json -Depth 3

try {
    $result1 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body1
    Write-Host "  ✓ NEXT_PUBLIC_SUPABASE_URL добавлен" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "  ⚠ NEXT_PUBLIC_SUPABASE_URL уже существует" -ForegroundColor Yellow
    } else {
        Write-Host "  ✗ Ошибка: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Добавляем NEXT_PUBLIC_SUPABASE_ANON_KEY
Write-Host "Добавление NEXT_PUBLIC_SUPABASE_ANON_KEY..." -ForegroundColor Yellow
$body2 = @{
    key = "NEXT_PUBLIC_SUPABASE_ANON_KEY"
    value = $SupabaseAnonKey
    type = "encrypted"
    target = $environments
} | ConvertTo-Json -Depth 3

try {
    $result2 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body2
    Write-Host "  ✓ NEXT_PUBLIC_SUPABASE_ANON_KEY добавлен" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "  ⚠ NEXT_PUBLIC_SUPABASE_ANON_KEY уже существует" -ForegroundColor Yellow
    } else {
        Write-Host "  ✗ Ошибка: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Добавляем SUPABASE_SERVICE_ROLE_KEY если предоставлен
if ($ServiceRoleKey) {
    Write-Host "Добавление SUPABASE_SERVICE_ROLE_KEY..." -ForegroundColor Yellow
    $body3 = @{
        key = "SUPABASE_SERVICE_ROLE_KEY"
        value = $ServiceRoleKey
        type = "encrypted"
        target = $environments
    } | ConvertTo-Json -Depth 3

    try {
        $result3 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body3
        Write-Host "  ✓ SUPABASE_SERVICE_ROLE_KEY добавлен" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 409) {
            Write-Host "  ⚠ SUPABASE_SERVICE_ROLE_KEY уже существует" -ForegroundColor Yellow
        } else {
            Write-Host "  ✗ Ошибка: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Готово! Переменные добавлены." -ForegroundColor Green
Write-Host "Проверьте переменные:" -ForegroundColor Cyan
Write-Host "npx vercel env ls --token $token" -ForegroundColor Yellow
Write-Host ""
Write-Host "После добавления Vercel автоматически перезапустит деплой." -ForegroundColor Green


