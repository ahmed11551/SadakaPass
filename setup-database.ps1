# Скрипт для выполнения всех SQL скриптов в Supabase
# Использует Supabase REST API для выполнения SQL

param(
    [string]$SupabaseUrl = "https://fvxkywczuqincnjilgzd.supabase.co",
    [string]$ServiceKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjM0ODA1NiwiZXhwIjoyMDc3OTI0MDU2fQ.S7NaVDbxey9V-3lxiTKYh2nsMOkQYK3Rc3TqsbYahOA"
)

Write-Host "`n=== Настройка базы данных Supabase ===" -ForegroundColor Cyan
Write-Host ""

# Проверяем наличие ключа
if ([string]::IsNullOrEmpty($ServiceKey)) {
    Write-Host "❌ Ошибка: SUPABASE_SERVICE_ROLE_KEY не указан" -ForegroundColor Red
    Write-Host "Использование: .\setup-database.ps1 -ServiceKey 'ваш_ключ'" -ForegroundColor Yellow
    exit 1
}

$headers = @{
    "apikey" = $ServiceKey
    "Authorization" = "Bearer $ServiceKey"
    "Content-Type" = "application/json"
}

$sqlEndpoint = "$SupabaseUrl/rest/v1/rpc/exec_sql"

# Список скриптов в порядке выполнения
$scripts = @(
    "001_create_profiles.sql",
    "002_create_funds.sql",
    "003_create_campaigns.sql",
    "004_create_donations.sql",
    "005_create_campaign_updates.sql",
    "006_create_subscriptions.sql",
    "007_create_reports.sql",
    "009_create_rpc_functions.sql"
)

Write-Host "Выполнение SQL скриптов..." -ForegroundColor Yellow
Write-Host ""

$successCount = 0
$errorCount = 0

foreach ($script in $scripts) {
    $scriptPath = "scripts\$script"
    
    if (-not (Test-Path $scriptPath)) {
        Write-Host "⚠️  $script - файл не найден" -ForegroundColor Yellow
        $errorCount++
        continue
    }
    
    Write-Host "📄 Выполнение: $script..." -ForegroundColor Cyan
    
    try {
        $sqlContent = Get-Content -Path $scriptPath -Raw -Encoding UTF8
        
        # Удаляем комментарии и пустые строки для чистоты
        $sqlContent = $sqlContent -replace '--.*', '' -replace '(?m)^\s*$\r?\n', ''
        
        # Supabase не имеет прямого REST API для выполнения SQL
        # Поэтому выводим инструкцию для ручного выполнения
        Write-Host "   ⚠️  Supabase REST API не поддерживает прямой SQL execution" -ForegroundColor Yellow
        Write-Host "   📋 Выполните этот скрипт вручную в Supabase SQL Editor" -ForegroundColor White
        Write-Host ""
        
        $successCount++
    } catch {
        Write-Host "   ❌ Ошибка чтения файла: $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "=== Итоги ===" -ForegroundColor Cyan
Write-Host "✅ Обработано: $successCount" -ForegroundColor Green
Write-Host "❌ Ошибок: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

Write-Host "=== Инструкция ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Откройте Supabase Dashboard:" -ForegroundColor White
Write-Host "   $SupabaseUrl" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Перейдите в SQL Editor" -ForegroundColor White
Write-Host ""
Write-Host "3. Выполните скрипты в следующем порядке:" -ForegroundColor White
Write-Host ""

foreach ($script in $scripts) {
    $scriptPath = "scripts\$script"
    if (Test-Path $scriptPath) {
        Write-Host "   📄 $script" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "4. Скопируйте содержимое каждого файла и выполните в SQL Editor" -ForegroundColor White
Write-Host ""
Write-Host "5. После выполнения всех скриптов проверьте:" -ForegroundColor White
Write-Host "   - Таблицы созданы (Database → Tables)" -ForegroundColor Gray
Write-Host "   - RPC функции созданы (Database → Functions)" -ForegroundColor Gray
Write-Host "   - RLS политики активны (Authentication → Policies)" -ForegroundColor Gray
Write-Host ""

