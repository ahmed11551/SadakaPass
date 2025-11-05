# Скрипт для добавления всех секретов в GitHub через API
# Требуется: GitHub Personal Access Token с правами repo:secrets

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken
)

$repo = "ahmed11551/SadakaPass"
$baseUrl = "https://api.github.com/repos/$repo/actions/secrets"

$headers = @{
    "Accept" = "application/vnd.github.v3+json"
    "Authorization" = "Bearer $GitHubToken"
}

# Получаем публичный ключ репозитория
Write-Host "Получение публичного ключа репозитория..." -ForegroundColor Cyan
try {
    $publicKeyResponse = Invoke-RestMethod -Uri "$baseUrl/public-key" -Headers $headers -Method Get
    $publicKeyBase64 = $publicKeyResponse.key
    $keyId = $publicKeyResponse.key_id
    
    Write-Host "Публичный ключ получен" -ForegroundColor Green
} catch {
    Write-Host "Ошибка получения публичного ключа: $_" -ForegroundColor Red
    Write-Host "Проверьте токен GitHub и права доступа (нужны repo:secrets)" -ForegroundColor Yellow
    exit 1
}

# Импортируем библиотеку для шифрования
Add-Type -AssemblyName System.Security.Cryptography

function Encrypt-WithPublicKey {
    param(
        [string]$PlainText,
        [string]$PublicKeyBase64
    )
    
    # Декодируем публичный ключ
    $publicKeyBytes = [Convert]::FromBase64String($PublicKeyBase64)
    
    # Создаем RSA объект
    $rsa = New-Object System.Security.Cryptography.RSACng
    $rsa.ImportRSAPublicKey($publicKeyBytes, [ref]$null)
    
    # Шифруем данные
    $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
    $encryptedBytes = $rsa.Encrypt($plainTextBytes, [System.Security.Cryptography.RSAEncryptionPadding]::OaepSHA256)
    
    return [Convert]::ToBase64String($encryptedBytes)
}

# Секреты для добавления
$secrets = @{
    "NEXT_PUBLIC_SUPABASE_URL" = "https://fvxkywczuqincnjilgzd.supabase.co"
    "NEXT_PUBLIC_SUPABASE_ANON_KEY" = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNDgwNTYsImV4cCI6MjA3NzkyNDA1Nn0.jBvLDl0T2u-slvf4Uu4oZj7yRWMQCKmiln0mXRU0q54"
    "SUPABASE_SERVICE_ROLE_KEY" = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjM0ODA1NiwiZXhwIjoyMDc3OTI0MDU2fQ.S7NaVDbxey9V-3lxiTKYh2nsMOkQYK3Rc3TqsbYahOA"
    "TELEGRAM_BOT_TOKEN" = "8584160148:AAEPPpNUfO305o7jzCtdORCLGM5saZToxhw"
    "TELEGRAM_SECRET_TOKEN" = "1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516"
    "API_AUTH_TOKEN" = "test_token_123"
    "VERCEL_ORG_ID" = "team_y1QCs5r5OPnKKuHRQJYVUvEX"
    "VERCEL_PROJECT_ID" = "prj_VsqHkoeM952J8v5lmYfzFl4CaBPu"
    "VERCEL_TOKEN" = "90yDvxTtS7pSJxB6QhfYqp5X"
}

# Добавляем секреты
foreach ($secretName in $secrets.Keys) {
    $secretValue = $secrets[$secretName]
    
    Write-Host "Добавление секрета: $secretName" -ForegroundColor Yellow
    
    try {
        # Шифруем значение
        $encryptedValue = Encrypt-WithPublicKey -PlainText $secretValue -PublicKeyBase64 $publicKeyBase64
        
        # Отправляем запрос
        $body = @{
            encrypted_value = $encryptedValue
            key_id = $keyId
        } | ConvertTo-Json
        
        $result = Invoke-RestMethod -Uri "$baseUrl/$secretName" -Headers $headers -Method Put -Body $body
        Write-Host "  ✓ $secretName добавлен" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Host "  ✗ Ошибка: Секрет не найден или нет прав доступа" -ForegroundColor Red
        } else {
            Write-Host "  ✗ Ошибка: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Готово! Секреты добавлены в GitHub." -ForegroundColor Green
Write-Host "GitHub Actions автоматически запустится при следующем push." -ForegroundColor Cyan

