# 🤖 Как проверить работу Telegram бота

## 📋 Доступные команды бота

1. **`/start`** - Приветствие и инструкция
2. **`/stats`** - Статистика платформы (всего собрано, активных доноров, кампаний, средний чек)

## 🔍 Шаг 1: Проверьте, что webhook настроен

Выполните в PowerShell:

```powershell
# Проверка текущего webhook
$token = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getWebhookInfo"
```

Если webhook не настроен, установите его:

```powershell
$token = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
$body = @{
  url = "https://sadaka-pass.vercel.app/api/telegram/webhook"
  secret_token = "1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516"
} | ConvertTo-Json

Invoke-RestMethod -Method Post `
  -Uri "https://api.telegram.org/bot$token/setWebhook" `
  -ContentType "application/json" `
  -Body $body
```

## 📱 Шаг 2: Найдите бота в Telegram

1. Откройте Telegram
2. Найдите бота по имени (используйте токен, чтобы узнать имя бота)
3. Или используйте прямую ссылку (если знаете username бота)

Чтобы узнать информацию о боте:

```powershell
$token = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getMe"
```

## ✅ Шаг 3: Протестируйте команды

### В Telegram:

1. Откройте чат с ботом
2. Отправьте `/start` - должно прийти: "Ассаляму алейкум! Я бот MubarakWay. Используйте /stats для статистики."
3. Отправьте `/stats` - должна прийти статистика в формате:
   ```
   Всего собрано: 1234567
   Активных доноров: 123
   Активных кампаний: 45
   Средний чек: 5000
   ```

## 🐛 Если бот не отвечает

### Проверка 1: Webhook работает?

```powershell
# Проверьте статус webhook
$token = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
$webhookInfo = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getWebhookInfo"
$webhookInfo | ConvertTo-Json
```

Должно быть:
- `ok: true`
- `result.url` должен содержать ваш webhook URL
- `result.pending_update_count` должен быть 0 (если есть ошибки, здесь будет число)

### Проверка 2: API работает?

```powershell
# Проверьте, что webhook endpoint доступен
Invoke-RestMethod -Method Post `
  -Uri "https://sadaka-pass.vercel.app/api/telegram/webhook" `
  -ContentType "application/json" `
  -Headers @{ "X-Telegram-Bot-Api-Secret-Token" = "1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516" } `
  -Body '{"message":{"chat":{"id":123456},"text":"/start"}}'
```

### Проверка 3: Переменные окружения в Vercel

Убедитесь, что в Vercel настроены:
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_SECRET_TOKEN`

## 📝 Локальное тестирование (для разработки)

Если вы запускаете локально и хотите протестировать через ngrok:

1. Установите ngrok: https://ngrok.com/
2. Запустите: `ngrok http 3000`
3. Скопируйте HTTPS URL (например: `https://abc123.ngrok.io`)
4. Установите webhook на локальный URL:

```powershell
$token = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
$body = @{
  url = "https://YOUR_NGROK_URL.ngrok.io/api/telegram/webhook"
  secret_token = "1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516"
} | ConvertTo-Json

Invoke-RestMethod -Method Post `
  -Uri "https://api.telegram.org/bot$token/setWebhook" `
  -ContentType "application/json" `
  -Body $body
```

## 🔄 Отладка

### Просмотр логов в Vercel:

1. Перейдите: https://vercel.com/ahmed11551s-projects/sadaka-pass
2. Откройте вкладку "Logs"
3. Найдите ошибки при отправке сообщений боту

### Тестовая отправка сообщения напрямую:

```powershell
$token = "8417046320:AAF6TExdeJiSq3xK0Cy2GhL8KVRrvZf7UWQ"
$chatId = "YOUR_CHAT_ID" # Узнайте свой chat_id через @userinfobot
$body = @{
  chat_id = $chatId
  text = "Тестовое сообщение"
} | ConvertTo-Json

Invoke-RestMethod -Method Post `
  -Uri "https://api.telegram.org/bot$token/sendMessage" `
  -ContentType "application/json" `
  -Body $body
```

Это проверит, что бот может отправлять сообщения (токен работает).

