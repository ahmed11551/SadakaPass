# Скрипт для переноса проекта в новый репозиторий MubarakWay

Write-Host "🚀 Начинаем перенос проекта в новый репозиторий..." -ForegroundColor Green
Write-Host ""

# Проверка текущего статуса
Write-Host "📋 Проверка текущего статуса Git..." -ForegroundColor Yellow
$status = git status --porcelain
if ($status) {
    Write-Host "⚠️  ВНИМАНИЕ: Есть незакоммиченные изменения!" -ForegroundColor Red
    Write-Host "Пожалуйста, закоммитьте или отмените изменения перед переносом." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Все изменения закоммичены" -ForegroundColor Green
Write-Host ""

# Показываем текущий remote
Write-Host "📡 Текущий remote:" -ForegroundColor Yellow
git remote -v
Write-Host ""

# Удаляем старый remote
Write-Host "🗑️  Удаление старого remote..." -ForegroundColor Yellow
git remote remove origin
Write-Host "✅ Старый remote удалён" -ForegroundColor Green
Write-Host ""

# Добавляем новый remote
Write-Host "➕ Добавление нового remote..." -ForegroundColor Yellow
git remote add origin https://github.com/ahmed11551/MubarakWay.git
Write-Host "✅ Новый remote добавлен" -ForegroundColor Green
Write-Host ""

# Проверяем новый remote
Write-Host "📡 Новый remote:" -ForegroundColor Yellow
git remote -v
Write-Host ""

# Спрашиваем подтверждение перед push
Write-Host "⚠️  ВНИМАНИЕ: Сейчас будет выполнен push в новый репозиторий!" -ForegroundColor Red
$confirm = Read-Host "Продолжить? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "❌ Отменено пользователем" -ForegroundColor Yellow
    exit 0
}

# Push в новый репозиторий
Write-Host ""
Write-Host "📤 Отправка кода в новый репозиторий..." -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Успешно! Код отправлен в новый репозиторий" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Следующие шаги:" -ForegroundColor Cyan
    Write-Host "1. Откройте: https://vercel.com/dashboard" -ForegroundColor White
    Write-Host "2. Нажмите 'Add New Project'" -ForegroundColor White
    Write-Host "3. Выберите репозиторий: ahmed11551/MubarakWay" -ForegroundColor White
    Write-Host "4. Добавьте все переменные окружения" -ForegroundColor White
    Write-Host "5. Проверьте деплой" -ForegroundColor White
    Write-Host ""
    Write-Host "📖 Подробная инструкция в файле MIGRATION_GUIDE.md" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Ошибка при отправке кода!" -ForegroundColor Red
    Write-Host "Проверьте, что новый репозиторий существует и у вас есть права доступа." -ForegroundColor Yellow
}

