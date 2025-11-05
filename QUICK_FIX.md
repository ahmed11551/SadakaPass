# Быстрое исправление ошибки 500

## Проблема
Ошибка `MIDDLEWARE_INVOCATION_FAILED` возникает из-за отсутствия Supabase переменных в Vercel.

## Решение

### Шаг 1: Найдите значения Supabase

1. Откройте https://supabase.com/dashboard
2. Выберите проект
3. Settings → API
4. Скопируйте:
   - **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
   - **anon public key** → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - **service_role key** → `SUPABASE_SERVICE_ROLE_KEY`

### Шаг 2: Добавьте через скрипт

```powershell
.\add-supabase-simple.ps1 `
  -SupabaseUrl "https://ваш-проект.supabase.co" `
  -AnonKey "ваш-anon-key" `
  -ServiceKey "ваш-service-role-key"
```

### Или через Vercel CLI:

```powershell
npx vercel env add NEXT_PUBLIC_SUPABASE_URL production --token 90yDvxTtS7pSJxB6QhfYqp5X
npx vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production --token 90yDvxTtS7pSJxB6QhfYqp5X
npx vercel env add SUPABASE_SERVICE_ROLE_KEY production --token 90yDvxTtS7pSJxB6QhfYqp5X
```

После добавления Vercel автоматически перезапустит деплой и ошибка исчезнет.


