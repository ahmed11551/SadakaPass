# Скрипт для проверки работы Telegram бота

$BOT_TOKEN = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
$SECRET_TOKEN = "1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516"
$WEBHOOK_URL = "https://sadaka-pass.vercel.app/api/telegram/webhook"

Write-Host "`n=== Проверка Telegram бота ===" -ForegroundColor Cyan
Write-Host ""

# 1. Проверка информации о боте
Write-Host "1. Проверка информации о боте..." -ForegroundColor Yellow
try {
    $botInfo = Invoke-RestMethod -Uri "https://api.telegram.org/bot$BOT_TOKEN/getMe"
    if ($botInfo.ok) {
        Write-Host "   ✅ Бот найден: @$($botInfo.result.username)" -ForegroundColor Green
        Write-Host "   Имя: $($botInfo.result.first_name)" -ForegroundColor Gray
    } else {
        Write-Host "   ❌ Ошибка получения информации о боте" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Не удалось подключиться к Telegram API" -ForegroundColor Red
    Write-Host "   Ошибка: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 2. Проверка webhook
Write-Host "2. Проверка webhook..." -ForegroundColor Yellow
try {
    $webhookInfo = Invoke-RestMethod -Uri "https://api.telegram.org/bot$BOT_TOKEN/getWebhookInfo"
    if ($webhookInfo.ok) {
        $webhook = $webhookInfo.result
        if ($webhook.url) {
            Write-Host "   ✅ Webhook настроен: $($webhook.url)" -ForegroundColor Green
            if ($webhook.pending_update_count -gt 0) {
                Write-Host "   ⚠️  Есть необработанных обновлений: $($webhook.pending_update_count)" -ForegroundColor Yellow
            } else {
                Write-Host "   ✅ Все обновления обработаны" -ForegroundColor Green
            }
            if ($webhook.last_error_message) {
                Write-Host "   ❌ Последняя ошибка: $($webhook.last_error_message)" -ForegroundColor Red
            }
        } else {
            Write-Host "   ❌ Webhook не настроен" -ForegroundColor Red
            Write-Host "   Установите webhook командой ниже:" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "   `$body = @{" -ForegroundColor Gray
            Write-Host "     url = `"$WEBHOOK_URL`"" -ForegroundColor Gray
            Write-Host "     secret_token = `"$SECRET_TOKEN`"" -ForegroundColor Gray
            Write-Host "   } | ConvertTo-Json" -ForegroundColor Gray
            Write-Host ""
            Write-Host "   Invoke-RestMethod -Method Post `" -ForegroundColor Gray
            Write-Host "     -Uri `"https://api.telegram.org/bot$BOT_TOKEN/setWebhook`" `" -ForegroundColor Gray
            Write-Host "     -ContentType `"application/json`" `" -ForegroundColor Gray
            Write-Host "     -Body `$body" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "   ❌ Ошибка проверки webhook: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 3. Проверка доступности webhook endpoint
Write-Host "3. Проверка доступности webhook endpoint..." -ForegroundColor Yellow
try {
    $testBody = @{
        message = @{
            chat = @{ id = 123456 }
            text = "/test"
        }
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Method Post `
        -Uri $WEBHOOK_URL `
        -ContentType "application/json" `
        -Headers @{ "X-Telegram-Bot-Api-Secret-Token" = $SECRET_TOKEN } `
        -Body $testBody `
        -UseBasicParsing `
        -ErrorAction Stop

    if ($response.StatusCode -eq 200) {
        Write-Host "   ✅ Webhook endpoint доступен и отвечает" -ForegroundColor Green
    }
} catch {
    Write-Host "   ❌ Webhook endpoint недоступен или не отвечает" -ForegroundColor Red
    Write-Host "   Ошибка: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 4. Проверка API статистики
Write-Host "4. Проверка API статистики..." -ForegroundColor Yellow
try {
    $headers = @{ Authorization = "Bearer test_token_123" }
    $stats = Invoke-RestMethod -Uri "https://sadaka-pass.vercel.app/api/stats" -Headers $headers
    Write-Host "   ✅ API статистики работает" -ForegroundColor Green
    Write-Host "   Всего собрано: $($stats.total_collected)" -ForegroundColor Gray
    Write-Host "   Активных доноров: $($stats.active_donors)" -ForegroundColor Gray
    Write-Host "   Активных кампаний: $($stats.active_campaigns)" -ForegroundColor Gray
} catch {
    Write-Host "   ⚠️  API статистики недоступно (это нормально, если не настроен)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Готово ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Следующие шаги:" -ForegroundColor Yellow
Write-Host "1. Найдите бота в Telegram: @$($botInfo.result.username)" -ForegroundColor White
Write-Host "2. Отправьте команду /start" -ForegroundColor White
Write-Host "3. Отправьте команду /stats" -ForegroundColor White
Write-Host ""

