# Как получить GitHub Token для добавления секретов

## Шаг 1: Создайте Personal Access Token

1. Перейдите: https://github.com/settings/tokens
2. Нажмите **"Generate new token"** → **"Generate new token (classic)"**
3. Назовите токен (например, "Add Secrets to SadakaPass")
4. Выберите срок действия (например, "No expiration" или "90 days")
5. **Выберите права доступа:**
   - ✅ `repo` (Full control of private repositories)
     - Это включает `repo:secrets` который нужен для работы с секретами
6. Нажмите **"Generate token"**
7. **ВАЖНО:** Скопируйте токен сразу (он показывается только один раз!)

## Шаг 2: Запустите скрипт

```powershell
.\add-all-github-secrets.ps1 -GitHubToken "ваш_токен_из_шага_1"
```

## Альтернатива: Через веб-интерфейс GitHub

Если скрипт не работает, добавьте секреты вручную:
https://github.com/ahmed11551/SadakaPass/settings/secrets/actions

Добавьте:
- NEXT_PUBLIC_SUPABASE_URL = `https://fvxkywczuqincnjilgzd.supabase.co`
- NEXT_PUBLIC_SUPABASE_ANON_KEY = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNDgwNTYsImV4cCI6MjA3NzkyNDA1Nn0.jBvLDl0T2u-slvf4Uu4oZj7yRWMQCKmiln0mXRU0q54`
- SUPABASE_SERVICE_ROLE_KEY = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGt5d2N6dXFpbmNuamlsZ3pkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjM0ODA1NiwiZXhwIjoyMDc3OTI0MDU2fQ.S7NaVDbxey9V-3lxiTKYh2nsMOkQYK3Rc3TqsbYahOA`
- TELEGRAM_BOT_TOKEN = `8584160148:AAEPPpNUfO305o7jzCtdORCLGM5saZToxhw`
- TELEGRAM_SECRET_TOKEN = `1f2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7081a9b0c1d2e3f40516`
- API_AUTH_TOKEN = `test_token_123`
- VERCEL_ORG_ID = `team_y1QCs5r5OPnKKuHRQJYVUvEX`
- VERCEL_PROJECT_ID = `prj_VsqHkoeM952J8v5lmYfzFl4CaBPu`
- VERCEL_TOKEN = `90yDvxTtS7pSJxB6QhfYqp5X`

