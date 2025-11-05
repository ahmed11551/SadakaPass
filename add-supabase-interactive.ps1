# Интерактивный скрипт для добавления Supabase переменных в Vercel

$token = "90yDvxTtS7pSJxB6QhfYqp5X"
$projectId = "prj_VsqHkoeM952J8v5lmYfzFl4CaBPu"
$baseUrl = "https://api.vercel.com/v10/projects/$projectId/env"

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$environments = @("production", "preview", "development")

Write-Host "=== Добавление Supabase переменных в Vercel ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Найдите значения в Supabase Dashboard:" -ForegroundColor Yellow
Write-Host "https://supabase.com/dashboard → Settings → API" -ForegroundColor Green
Write-Host ""

# Запрашиваем значения
$supabaseUrl = Read-Host "Введите NEXT_PUBLIC_SUPABASE_URL (например: https://xxxxx.supabase.co)"
$anonKey = Read-Host "Введите NEXT_PUBLIC_SUPABASE_ANON_KEY (anon public key)"
$serviceRoleKey = Read-Host "Введите SUPABASE_SERVICE_ROLE_KEY (service_role key, опционально - нажмите Enter чтобы пропустить)"

Write-Host ""
Write-Host "Добавление переменных..." -ForegroundColor Cyan
Write-Host ""

# Добавляем NEXT_PUBLIC_SUPABASE_URL
Write-Host "Добавление NEXT_PUBLIC_SUPABASE_URL..." -ForegroundColor Yellow
$body1 = @{
    key = "NEXT_PUBLIC_SUPABASE_URL"
    value = $supabaseUrl
    type = "encrypted"
    target = $environments
} | ConvertTo-Json -Depth 3

try {
    $result1 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body1
    Write-Host "  ✓ NEXT_PUBLIC_SUPABASE_URL добавлен" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "  ⚠ NEXT_PUBLIC_SUPABASE_URL уже существует, обновление..." -ForegroundColor Yellow
        # Удаляем старый и создаем новый
        try {
            $envId = (Invoke-RestMethod -Uri "$baseUrl/$($result1.id)" -Headers $headers -Method Get).id
            Invoke-RestMethod -Uri "$baseUrl/$envId" -Headers $headers -Method Delete
            $result1 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body1
            Write-Host "  ✓ NEXT_PUBLIC_SUPABASE_URL обновлен" -ForegroundColor Green
        } catch {
            Write-Host "  ✗ Ошибка обновления: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  ✗ Ошибка: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Добавляем NEXT_PUBLIC_SUPABASE_ANON_KEY
Write-Host "Добавление NEXT_PUBLIC_SUPABASE_ANON_KEY..." -ForegroundColor Yellow
$body2 = @{
    key = "NEXT_PUBLIC_SUPABASE_ANON_KEY"
    value = $anonKey
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
if ($serviceRoleKey) {
    Write-Host "Добавление SUPABASE_SERVICE_ROLE_KEY..." -ForegroundColor Yellow
    $body3 = @{
        key = "SUPABASE_SERVICE_ROLE_KEY"
        value = $serviceRoleKey
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
Write-Host "Готово! Переменные добавлены в Vercel." -ForegroundColor Green
Write-Host "Vercel автоматически перезапустит деплой." -ForegroundColor Cyan
Write-Host ""
Write-Host "Проверьте переменные:" -ForegroundColor Yellow
Write-Host ('npx vercel env ls --token ' + $token) -ForegroundColor White

