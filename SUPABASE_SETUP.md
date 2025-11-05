# 🗄️ Настройка Supabase для SadakaPass

## 📋 Что нужно сделать

### 1. Создать проект в Supabase

1. Перейдите на https://supabase.com
2. Зарегистрируйтесь или войдите в аккаунт
3. Нажмите "New Project"
4. Заполните:
   - **Name**: `SadakaPass` или `MubarakWay`
   - **Database Password**: создайте надёжный пароль (сохраните его!)
   - **Region**: выберите ближайший регион
5. Нажмите "Create new project"
6. Дождитесь создания проекта (2-3 минуты)

### 2. Получить ключи доступа

1. В проекте перейдите в **Settings** → **API**
2. Скопируйте:
   - **Project URL** (например: `https://xxxxx.supabase.co`)
   - **anon public** ключ (в секции "Project API keys")
   - **service_role** ключ (⚠️ НЕ делитесь им публично!)

### 3. Настроить переменные окружения

Создайте файл `.env.local` в корне проекта:

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# API
API_AUTH_TOKEN=test_token_123
BOT_API_BASE_URL=https://bot.e-replika.ru
BOT_API_TOKEN=test_token_123

# Telegram
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
TELEGRAM_SECRET_TOKEN=your_telegram_secret_token

# CloudPayments (когда получите)
NEXT_PUBLIC_CLOUDPAYMENTS_PUBLIC_ID=pk_xxxxxxxxxxxxxxxxxxxxxxxx
CLOUDPAYMENTS_API_SECRET=your_secret_key

# Base URL
NEXT_PUBLIC_BASE_URL=http://localhost:3000
```

### 4. Создать схему базы данных

#### Вариант А: Через SQL Editor (рекомендуется)

1. В Supabase перейдите в **SQL Editor**
2. Выполните скрипты **по порядку**:

**Шаг 1**: `scripts/001_create_profiles.sql` - таблица профилей
**Шаг 2**: `scripts/002_create_funds.sql` - таблица фондов  
**Шаг 3**: `scripts/003_create_campaigns.sql` - таблица кампаний
**Шаг 4**: `scripts/004_create_donations.sql` - таблица пожертвований
**Шаг 5**: `scripts/005_create_campaign_updates.sql` - обновления кампаний
**Шаг 6**: `scripts/006_create_subscriptions.sql` - подписки
**Шаг 7**: `scripts/007_create_reports.sql` - отчёты (если есть)
**Шаг 8**: `scripts/009_create_rpc_functions.sql` - RPC функции (см. ниже)

#### Вариант Б: Автоматически (PowerShell скрипт)

Используйте готовый скрипт (см. ниже)

### 5. Создать RPC функции

Создайте файл `scripts/009_create_rpc_functions.sql` и выполните его:

```sql
-- RPC функция для увеличения общей суммы пожертвований пользователя
create or replace function public.increment_total_donated(
  user_id uuid,
  amount numeric
)
returns void
language plpgsql
security definer
as $$
begin
  update public.profiles
  set total_donated = total_donated + amount
  where id = user_id;
end;
$$;

-- RPC функция для увеличения суммы кампании
create or replace function public.increment_campaign_amount(
  campaign_id uuid,
  amount numeric
)
returns void
language plpgsql
security definer
as $$
begin
  update public.campaigns
  set 
    current_amount = current_amount + amount,
    donor_count = donor_count + 1
  where id = campaign_id;
end;
$$;

-- RPC функция для увеличения суммы фонда
create or replace function public.increment_fund_amount(
  fund_id uuid,
  amount numeric
)
returns void
language plpgsql
security definer
as $$
begin
  update public.funds
  set 
    total_raised = total_raised + amount,
    donor_count = donor_count + 1
  where id = fund_id;
end;
$$;
```

### 6. Настроить Storage (для загрузки изображений)

1. Перейдите в **Storage** в Supabase
2. Создайте bucket `campaign-images`:
   - **Public bucket**: ✅ включено
   - **File size limit**: 5 MB
   - **Allowed MIME types**: `image/jpeg,image/png,image/webp`
3. Создайте bucket `user-avatars`:
   - **Public bucket**: ✅ включено
   - **File size limit**: 2 MB
   - **Allowed MIME types**: `image/jpeg,image/png,image/webp`

### 7. Настроить аутентификацию (опционально)

1. Перейдите в **Authentication** → **Providers**
2. Включите нужные провайдеры:
   - **Email** (по умолчанию)
   - **Telegram** (для интеграции с ботом)
3. Настройте **Email Templates** (если нужны кастомные)

### 8. Проверить настройку

Запустите приложение:

```bash
pnpm install
pnpm dev
```

Проверьте:
- ✅ Приложение запускается без ошибок
- ✅ Подключение к Supabase работает
- ✅ Можно создать пользователя (если настроена аутентификация)

---

## 🔧 Автоматизация настройки

### PowerShell скрипт для выполнения всех SQL скриптов

См. `setup-supabase.ps1` (ниже)

---

## ✅ Проверка работоспособности

После настройки проверьте:

1. **Таблицы созданы**:
   - `profiles`
   - `funds`
   - `campaigns`
   - `donations`
   - `campaign_updates`
   - `subscriptions`

2. **RLS политики активны**:
   - В **Authentication** → **Policies** проверьте, что политики созданы

3. **RPC функции работают**:
   - В **Database** → **Functions** проверьте наличие функций

4. **Storage настроен**:
   - В **Storage** проверьте наличие buckets

---

## 🐛 Решение проблем

### Ошибка "relation does not exist"
- Проверьте, что все SQL скрипты выполнены в правильном порядке
- Убедитесь, что вы в правильной схеме (`public`)

### Ошибка "permission denied"
- Проверьте RLS политики
- Убедитесь, что пользователь авторизован

### Ошибка "function does not exist"
- Проверьте, что RPC функции созданы
- Убедитесь, что функции в схеме `public`

### Не подключается к Supabase
- Проверьте переменные окружения в `.env.local`
- Убедитесь, что ключи правильные (без пробелов)
- Проверьте, что проект не приостановлен

---

## 📚 Дополнительные ресурсы

- [Документация Supabase](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

**Готово!** Теперь Supabase настроен и готов к работе. 🎉

