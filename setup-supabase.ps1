# Скрипт для автоматической настройки Supabase
# Запустите: .\setup-supabase.ps1

param(
    [string]$SupabaseUrl = "https://fvxkywczuqincnjilgzd.supabase.co",
    [string]$AnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNDgwNTYsImV4cCI6MjA3NzkyNDA1Nn0.jBvLDl0T2u-slvf4Uu4oZj7yRWMQCKmiln0mXRU0q54",
    [string]$ServiceKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjM0ODA1NiwiZXhwIjoyMDc3OTI0MDU2fQ.S7NaVDbxey9V-3lxiTKYh2nsMOkQYK3Rc3TqsbYahOA"
)

Write-Host "`n=== Настройка Supabase для SadakaPass ===" -ForegroundColor Cyan
Write-Host ""

# Используем данные по умолчанию (уже есть в проекте)
# Если параметры не переданы, используем значения по умолчанию
if ([string]::IsNullOrEmpty($SupabaseUrl)) {
    $SupabaseUrl = "https://fvxkywczuqincnjilgzd.supabase.co"
}

if ([string]::IsNullOrEmpty($AnonKey)) {
    $AnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNDgwNTYsImV4cCI6MjA3NzkyNDA1Nn0.jBvLDl0T2u-slvf4Uu4oZj7yRWMQCKmiln0mXRU0q54"
}

if ([string]::IsNullOrEmpty($ServiceKey)) {
    $ServiceKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjM0ODA1NiwiZXhwIjoyMDc3OTI0MDU2fQ.S7NaVDbxey9V-3lxiTKYh2nsMOkQYK3Rc3TqsbYahOA"
}

# Проверяем наличие .env.local
$envFile = ".env.local"
if (-not (Test-Path $envFile)) {
    Write-Host "Создаю .env.local файл..." -ForegroundColor Yellow
    
    $envContent = @"
# Supabase
NEXT_PUBLIC_SUPABASE_URL=$SupabaseUrl
NEXT_PUBLIC_SUPABASE_ANON_KEY=$AnonKey
SUPABASE_SERVICE_ROLE_KEY=$ServiceKey

# API
API_AUTH_TOKEN=test_token_123
BOT_API_BASE_URL=https://bot.e-replika.ru
BOT_API_TOKEN=test_token_123

# Telegram
TELEGRAM_BOT_TOKEN=8584160148:AAEPPpNUfO305o7jzCtdORCLGM5saZToxhw
TELEGRAM_SECRET_TOKEN=1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516

# CloudPayments (когда получите)
NEXT_PUBLIC_CLOUDPAYMENTS_PUBLIC_ID=
CLOUDPAYMENTS_API_SECRET=

# Base URL
NEXT_PUBLIC_BASE_URL=http://localhost:3000
"@
    
    $envContent | Out-File -FilePath $envFile -Encoding UTF8
    Write-Host "✅ Файл .env.local создан" -ForegroundColor Green
} else {
    Write-Host "⚠️  Файл .env.local уже существует. Обновите его вручную." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Инструкция по настройке базы данных ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Откройте Supabase Dashboard: $SupabaseUrl" -ForegroundColor White
Write-Host "2. Перейдите в SQL Editor" -ForegroundColor White
Write-Host "3. Выполните SQL скрипты в следующем порядке:" -ForegroundColor White
Write-Host ""

$scripts = @(
    "001_create_profiles.sql",
    "002_create_funds.sql",
    "003_create_campaigns.sql",
    "004_create_donations.sql",
    "005_create_campaign_updates.sql",
    "006_create_subscriptions.sql",
    "009_create_rpc_functions.sql"
)

foreach ($script in $scripts) {
    $scriptPath = "scripts\$script"
    if (Test-Path $scriptPath) {
        Write-Host "   ✅ $script" -ForegroundColor Gray
    } else {
        Write-Host "   ❌ $script (не найден)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "4. После выполнения скриптов:" -ForegroundColor White
Write-Host "   - Проверьте, что все таблицы созданы" -ForegroundColor Gray
Write-Host "   - Проверьте RLS политики в Authentication → Policies" -ForegroundColor Gray
Write-Host "   - Проверьте RPC функции в Database → Functions" -ForegroundColor Gray
Write-Host ""

Write-Host "=== Настройка Storage ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Перейдите в Storage в Supabase Dashboard" -ForegroundColor White
Write-Host "2. Создайте bucket 'campaign-images' (public, 5MB)" -ForegroundColor White
Write-Host "3. Создайте bucket 'user-avatars' (public, 2MB)" -ForegroundColor White
Write-Host ""

Write-Host "=== Готово! ===" -ForegroundColor Green
Write-Host ""
Write-Host "После настройки БД запустите:" -ForegroundColor Yellow
Write-Host "  pnpm dev" -ForegroundColor White
Write-Host ""

