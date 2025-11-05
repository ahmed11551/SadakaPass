# Добавление Supabase переменных

## Где найти значения:

1. Откройте https://supabase.com/dashboard
2. Выберите ваш проект
3. Перейдите в **Settings → API**
4. Скопируйте:
   - **Project URL** → это `NEXT_PUBLIC_SUPABASE_URL`
   - **service_role key** (секретный) → это `SUPABASE_SERVICE_ROLE_KEY`
   - **anon public key** → это `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Вариант 1: Через скрипт (автоматически в Vercel)

После того как найдете значения, выполните:

```powershell
.\add-supabase-to-vercel.ps1 `
  -SupabaseUrl "https://ваш-проект.supabase.co" `
  -ServiceRoleKey "ваш-service-role-key" `
  -AnonKey "ваш-anon-key"
```

## Вариант 2: Вручную через Vercel CLI

```powershell
# Добавить NEXT_PUBLIC_SUPABASE_URL
npx vercel env add NEXT_PUBLIC_SUPABASE_URL production --token 90yDvxTtS7pSJxB6QhfYqp5X
# (введите значение когда попросит)

# Добавить SUPABASE_SERVICE_ROLE_KEY
npx vercel env add SUPABASE_SERVICE_ROLE_KEY production --token 90yDvxTtS7pSJxB6QhfYqp5X
# (введите значение когда попросит)

# Добавить NEXT_PUBLIC_SUPABASE_ANON_KEY
npx vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production --token 90yDvxTtS7pSJxB6QhfYqp5X
# (введите значение когда попросит)
```

## Вариант 3: Через веб-интерфейс Vercel

1. Перейдите: https://vercel.com/ahmed11551s-projects/sadaka-pass/settings/environment-variables
2. Добавьте каждую переменную:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Важно: Также добавьте в GitHub Secrets

После добавления в Vercel, обязательно добавьте те же значения в GitHub:
https://github.com/ahmed11551/SadakaPass/settings/secrets/actions

- `NEXT_PUBLIC_SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` (опционально, но рекомендуется)

