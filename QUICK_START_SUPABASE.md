# 🚀 Быстрый старт: Настройка Supabase за 5 минут

## Шаг 1: Создать проект (2 мин)

1. Откройте https://supabase.com → **New Project**
2. Заполните:
   - Name: `SadakaPass`
   - Password: (создайте и сохраните!)
   - Region: (выберите ближайший)
3. Дождитесь создания проекта

## Шаг 2: Получить ключи (1 мин)

1. **Settings** → **API**
2. Скопируйте:
   - **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
   - **anon public** → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - **service_role** → `SUPABASE_SERVICE_ROLE_KEY`

## Шаг 3: Настроить .env.local (1 мин)

Запустите скрипт:

```powershell
.\setup-supabase.ps1
```

Или создайте вручную `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...
```

## Шаг 4: Создать схему БД (1 мин)

В Supabase Dashboard → **SQL Editor** выполните по порядку:

1. `scripts/001_create_profiles.sql`
2. `scripts/002_create_funds.sql`
3. `scripts/003_create_campaigns.sql`
4. `scripts/004_create_donations.sql`
5. `scripts/005_create_campaign_updates.sql`
6. `scripts/006_create_subscriptions.sql`
7. `scripts/007_create_reports.sql`
8. `scripts/009_create_rpc_functions.sql` ⭐ (важно!)
9. `scripts/008_seed_initial_data.sql` (опционально, тестовые данные)

## Шаг 5: Настроить Storage (опционально)

**Storage** → Create bucket:
- `campaign-images` (public, 5MB)
- `user-avatars` (public, 2MB)

## Готово! ✅

```bash
pnpm dev
```

---

**Подробная инструкция**: см. `SUPABASE_SETUP.md`

